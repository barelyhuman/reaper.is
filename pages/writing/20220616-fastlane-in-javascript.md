---
title: Writing fastlane scripts in Javascript
date: 16/06/2022
---

3 Posts back to back!? Yes, lot's of content out there right now.

**_tldr;_**

- You install `fastlanejs` using npm
- You create a new fastlane class out of it

```js
import { Fastlane } from 'fastlanejs'
const flane = new Fastlane()
```

- `flane` can then be used to trigger any fastlane native action

**The longer version**

I made a recent post about getting an older react native codebase back up on fairly new hardware and the next step was to add fastlane to make sure
getting builds for debugging would be easier.

Those who don't know, fastlane is a very extensible tool written to automate most of the work that you'd do for creating builds and at the end of the
day it's just ruby you can extend it with numerous gem's available online.

### Why write it in Javascript then?

Well, you see there's a tiny set of issues that need to be addressed to understand the usage of js here.

1. You cannot split lanes into different files
2. All helper functions have to be defined in the same Fastfile

Now, this isn't a problem everyone would face since not everyone has react native apps that use the variant approach for creating dev and prod builds
separately. I do and so my `Fastfile` has quite a bit of code.

These are the functions that my Fastfile has, which are then called by a lane definition

```ruby
# ios
deploy_ios
sign_ios
build_iod
dev
prod

# android
deploy_android
sign_android
build_android
dev
prod
```

the structure is actually very simple, `deploy_` functions call the `sign`+`build` functions, then call the `dev` | `prod` function based on the
params passed.

```sh
fastlane ios dev # would create a dev build
fastlane ios prod # would create an appstore build
```

Now this is necessary since I deal with apps that aren't just going to be uploaded to testflight with the prod api, we haves staging servers and the
QA needs to test them so _dev_ builds are unstable/untested and can't be on testflight, someone's bound to create an accidental release out of it

And when I said multi-variant, there's 2 bundle identifiers created by `com.example.app` and `com.example.app.dev` and the above fastlane lane's take
that into consideration when building. basically each function reads the input parameter.

So, there's a few more helper functions to find out if the given parameter is for dev or prod

let's say the app's ios scheme is named `productOne` ,then the dev scheme is named `productOneDev`

Each of those would create a different build, one would trigger a development certification signing and upload itself to diawi and notify slack with
the link to the installable app.

The other would upload to testflight and notify slack once the app is out of the processing phase

Similar flow for android and , this means there's helpers that help with finding out if the given param was for dev or not

```ruby
def is_ios_dev(scheme)
    if scheme.end_with("Dev")
        true
    else
        false
    end
end

def is_android_dev(bundle)
    if bundle.end_with(".dev")
        true
    else
        false
    end
end
```

Which can be combined into a single function but it's easier to modify this than having 2 if conditions nested.

Also, yes I know implicit returns are to be avoided in ruby but that's a pretty simple function!!

Now, all this is easy and ruby is pretty good language to learn and use but fastlane doesn't really allow importing ruby files so if I need to
modularize any of this, I either write custom actions that import my ruby code which adds a lot of glue code but is definitely something I'll be doing
to stay close to the source of the tool.

Till then, **JAVASCRIPT**

I like the enthusiasm JS community has to move everything into JS.

[Ray Deck](https://github.com/rhdeck) decided to create a auto generated fastlane API layer for javascript. The concept is pretty simple but even
better executed.

1. Run a fastfile with all the actions to generate all the possible inputs and outputs into a json file
2. Setup a tool that can talk to the fastlane runner using the socket server that fastlane has
3. Use the json from the 1st tool to create a typescript api of the same
4. Wrap this all up in a library and done!

Obviously took a lot of work to get it all working so KUDOS!

Now, I found this library while trying to see if someone had already done it, because I had a more verbose approach that I was going to take which was
writing a `child_process` based wrapper for all the fastlane commands that were documented which would actually be a lot more work than writing
something like this. I'm not very smart...

Now, how does this solve my problem?

We get to write smaller functions that are just that, functions and importable. Each function is just like an API call to socket server that'll pass
in the parameters as a serialized payload and get the result back and it's all promises so you can add in more async code.

Let's get to how to use the library.

#### Installation

1. You still need fastlane so go through their [docs](https://docs.fastlane.tools/) to set it up
2. Creating `Appfile` and `Matchfile` will reduce the amount of code you write in lanes so do keep them intact or write them up first.

```
npm i fastlanejs
# or
yarn add fastlanejs
```

#### Basic Usage

```js
import { Fastlane } from 'fastlanejs'

const fastlane = new Fastlane()
;(async () => {
  await fastlane.getVersion()
  await fastlane.close()
})()
```

#### Real life usage

The API is fully typed so your IDE will help you out a lot with what's valid and what's not.

Here's what the dev version build I mentioned about above would look like

```js
#!/usr/bin/env node

import { Fastlane } from 'fastlanejs'
import process from 'node:process'
import dotenv from 'dotenv'
import { upload } from 'diawi-nodejs-uploader'

dotenv.config('../.env')

// dynamic variables to control behaviour over the file
const isDev = true
const flane = new Fastlane()
const buildtype = 'development'
const scheme = 'productDev'
const workspace = 'ios/product.xcworkspace'
const project = 'ios/product.xcodeproj'
const certType = 'development'

await run()

async function run() {
  await flane.updateCodeSigningSettings({
    useAutomaticSigning: false,
    path: project,
  })

  await setup()
  await sign()
  await build()
  const lcRes = await flane.laneContext()
  const lc = JSON.parse(lcRes)

  const uploadResponse = await uploadToDiawi(lc.IPA_OUTPUT_PATH)

  if (!uploadResponse.link) {
    return
  }

  await notifySlack(uploadResponse.link)
  await flane.close()
  return
}

async function setup() {
  await flane.createKeychain({
    name: process.env.KEYCHAIN_NAME,
    password: process.env.MATCH_PASSWORD,
    unlock: true,
  })

  await flane.match({
    gitUrl: process.env.MATCH_CERTIFICATES_URL,
    teamId: process.env.APPLE_TEAM_ID,
    keychainName: process.env.KEYCHAIN_NAME,
    keychainPassword: process.env.MATCH_PASSWORD,
    readonly: flane.isCi,
    forceForNewDevices: true,
    type: certType,
  })
}

async function notifySlack(link) {
  const gitBranch = await flane.gitBranch()
  await flane.slack({
    message: 'Automation Engine: iOS \n' + link,
    success: true,
    payload: { Git: gitBranch },
    useWebhookConfiguredUsernameAndIcon: true,
    slackUrl: process.env.SLACK_HOOK,
  })
}

async function uploadToDiawi(filePath) {
  console.log('Uploading to diawi, please wait...')
  const result = await upload({
    file: filePath,
    token: process.env.DIAWI_TOKEN,
    wall_of_apps: 'false',
  })

  return result
}

async function sign() {
  await flane.registerDevices({
    devicesFile: './fastlane/devices.txt',
    teamId: process.env.APPLE_TEAM_ID,
  })
  await flane.match({
    gitUrl: process.env.MATCH_CERTIFICATES_URL,
    teamId: process.env.APPLE_TEAM_ID,
    keychainName: process.env.KEYCHAIN_NAME,
    keychainPassword: process.env.MATCH_PASSWORD,
    readonly: flane.isCi,
    forceForNewDevices: true,
    type: certType,
  })
}

async function build() {
  await flane.incrementBuildNumber({
    buildNumber: process.env.BUILD_NUMBER,
    xcodeproj: project,
  })

  await flane.gym({
    configuration: 'Debug',
    workspace: workspace,
    scheme: scheme,
    clean: true,
    outputName: scheme,
    silent: true,
    destination: 'generic/platform=iOS',
    outputDirectory: 'builds',
    exportMethod: buildtype,
  })
}
```

The above handles the following

1. Creating keychains
2. Signing the app
3. Building the app
4. Uploading it to a distribution system
5. Notifying slack

and if you closely observe it's only the fastlane's own actions that are available, **plugins** like the `fastlane_diawi` has been replaced with a
node package instead

I can add parameters to each of these functions and export them from a `utils.js` file and reuse them to write the prod script with the only things
that change to be the parameters on the top since everything else is being read from environment variables.

### How do I find the parameters I can pass ?

As mentioned, this is all just generated code from the original fastlane documentation, you can use them and just camelCase the params and you are
done.

Overall this is a nice thing for quick fixes and scripts that I would wish to experiment with and while I've mentioned that I'd like to stay close to
the source, I'll probably write custom actions that'll help me with making it easier to move a fastlane configuration from one project to another
without having to handle the minor details like bundle identifiers and everything which can be programmatically extracted (which fastlane already does
but no clear API for it yet)

Till then, this seems like a viable option, since I've got generative javascript code everywhere, writing something similar will be a lot easier.

That's all for now, Adios!
