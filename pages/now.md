## Now

This is more of a page to remind me what I'm supposed to be prioritizing right
now

- writing stuff for rawjs.xyz to help more beginners
- figuring out a way to make it sustainable while doing just OSS and minor
  contract work -> [Hire Me?](/hire)
- working on making [goblin.run](https://goblin.run) much more faster and stable

> **NOTE**: (for future self) Do not! and I say DO FUCKING NOT do more than 3
> projects at a time, you just can't handle it.

> ^ Wasn't a challenge.

## Future

Things I wish to build, these are open ideas that you can build as well, the
only request I have is, do keep them **open source**.

> **Note**: It doesn't matter if I've already picked them up, these are still
> open to develop on

**Index**

- [CLI](#cli)
- [Libraries](#libraries)
- [Languages](#languages)
- [Desktop](#desktop)
- [Web](#web)
- [Multi Platform](#multi-platform)
- [Docker](#docker)
- [Uncategorized](#uncategorized)

### CLI

#### `codename`: stirup

**Status**: https://github.com/barelyhuman/stirup

A simple tool to run a script on a dedicated ssh server ( not ansible, something
a lot more concise. BASH can already do this but requires a lot of boilerplate
code)

The script can proxy rsync internally to also provide things like copying files
up and archiving them if needed.

#### `codename`: dynmnt

A simple wrapper on top of linux interface events to manage mounted devices and
be able to run task based on mount or unmount.

The tasks don't have to be bash scripts but any command that the user wishes to
add.

The use case for this was to allow raspberry pi to restart my docker compose
setups when an external drive is connected so it can read and write to it but
might scale to other use cases.

It's going to be easier to write this in C, Go, due to existing interfaces

#### `codename`: musync

[musync](https://github.com/barelyhuman/musync) already exists as a simple
spotify playlist's sync and this can be better done with
[ifttt.com](https://ifttt.com) now since they have a ton of integrations though
I still think I'm missing one very needed feature that I wanted to build into
the app.

I use SongShift on iOS to synchronize my Spotify and Apple playlists, primarily
because the speaker systems at home have better and clearer audio when playing
tracks from the Apple Music app but then Spotify has better recommendations for
Indie tracks.

You can either pick musync to add this integration or you can create a whole
another CLI for the same.

Preferred languages would be: Nim / Rust / Go so I can read and help you fix
tiny issues if possible but if you think there's a better language for the job,
go bonkers with it.

### Libraries

#### `codename`: typeless-gql

This is still a concept and the chances of this being achievable might be
limited by present tech but we want a simple solution

An attempt to avoid having to run the `codegen` manually for graphql and allow
type completion by just being able to inject the graphql document into our
abstraction.

example API

```js
import { createSchemaGQL } from 'typeless-gql'

const gql = createSchemaGQL('/path/to/schema.gql')

const TypedOperationNode = gql`
  query ping {
    pong
  }
`

const response = someExecutionLibrary(TypedOperationNode)
response.data.pong
// should autocomplete at `data` and `pong`
```

#### `codename` : codegtabs

These are code group tabs that only a few markdown transformers support and most
don't have a plugin for it.

These can be seen in [japa.dev](https://japa.dev/test-context) website and in a
few other websites that do multi language documentation.

^ _the section which allows you to switch between cjs and esm_

The plan is to make a library that would only parse the code group in the passed
file and then convert that to html so that the next markdown parser doesn't do
it.

Now this could be a plugin for each markdown parser that we wish to use but
that's well too much work.

The unix philosophy makes it better and more reusable, so let's do that.

This can be written in C with bindings for other languages or in Nim with shared
code and then bindings in other languages.

Either way, maybe research a bit more on it and if there's an easier way, go
bonkers.

### Languages

#### `codename` : mole

Probably will change the name to molecule but whatever, it's a codename.

The idea is to build not a full fledged language but a meta programming language
somewhat similar to nimrod or better known as nim lang.

We don't wanna compete with Nimlang or Vlang. (me noob, please have mercy.)

The conceptual spec right now is to have the following

- **not** Turing complete
- basic arithmetic, maybe a little more advanced in case I decide it.
- single if and else statements, like expressions
- only one way to declare variables
- dynamically typed but doesn't allow changing type over the course. (don't want
  another JS, do we)
- functions are anonymous by default and can be assigned to variables if a name
  is to be used, again like expressions.
- there's no while loops
- no for loops, iterators, will add more on this later on.
- each file is a module and module resolution is based on local files and
  there's no such thing as a global module system. You add files in let's say a
  `lib` folder and it's all packed together when compiling / transpiling /
  interpreting / or whatever-ing. (that sounds like lua...)
- The standard library is going to be very very very tiny, we aren't going to go
  for building anything that depends on the platform at least to start with.

**Why build something like this?**

1. To learn
2. A very simple language that can be compiled into others gives me a good way
   to finally stop running around multiple languages. (nim does that but half
   the time I have to re-learn how pragmas and macros work.)
3. This is for creating tiny little modules of logic and pure logic, so
   separation of concern for let's say, I want to just keep computations to one
   side and then UI to another, I should be able to do that. (eg: computation in
   this lang and then UI in SwiftUI,etc)
4. It's my language!

### Desktop

#### `codename` : pui

A postgres gui tool, hopefully cross-platform

[pui](http://github.com/barelyhuman/pui) already exists as an electron prototype
and was never taken up as a serious project since I was sure people would've
built better native apps and I could find one.

Unlike SequelPro (MySQL) there's hardly any OSS and well polished app for
postgres, there's partially free alternatives like

- Postico
- TablePlus
- Beekeeper

but they are either too heavy for normal work or irritate the crap out of you by
adding limitation to most basic tasks we expect from an app today.

I'd like to build something like SequelPro, with a similar UI as well, that app
is gold but for postgres and if possible use shared connector code so the UI can
be built for other platforms later on.

#### `codename` : retempo

A beautiful and really well designed email client that focuses on async
workflows. The original idea is based off of [Tempo](https://www.yourtempo.co) ,
the email client I currently use and probably the only Electron app I really
like simply because of the beautiful UI/UX and minimalism of the client.

Plus, the client is barely ever open so it's all good.

You can write a similar one in native if you wish to, I wouldn't really
complain.

Other things to consider

- offline device storage instead of google drive / cloud storage.
- Similar todo functionality for mails
- Doesn't need the switchable buttons (that's too much for native UI, go ahead
  if you're doing web)

### Web

#### `codename`: voyage

Self Hosted alternative to Vercel / Netlify / etc

This is not a new idea, a larger version of this is
[Laravel Forge](https://forge.laravel.com)

Probably too big of a project to do alone but then, still doable.

Think of it as a traditional app management platform.

Here's the list of MVP

- Container Creation from a Dockerfile
- Dockerfiles can be uploaded or come from Git repositories.

Good to have

- connect to Github or Gitlab

**Details**

I need an application/web UI that can handle getting my repos and building their
dockerfiles and just run them on the same system that the above project is
hosted on. You could technically build this with dokku and add a repo hook
mechanism over it.

To generalise this to work with any git provider, I'd recommend setting it up
with a Git Remote hook trigger which would listen for events from let's say
Github / Gitlab/ Bitbucket etc and trigger a build.

This saves you the time to setup a full fledged **Git Replicating Engine** and
since it's for devs, it's still going to be easy to work with.

Next up, we need to be able to build these docker images so you can use the
Docker Go SDK to do this and also run the images if needed.

If no `Dockerfile` is found, just do nothing, if you find a `compose.yml` or
`docker-compose.yml` then ask the user if the services from the compose also
need to be started

**Disclaimer** This is not trying to replicate fly.io or Railway or any backend
deployment services and trying to open source them. This is an extention of
dokku that I've had in my head much before ledokku was created and since ledokku
is very tied to github, I wanted one that could be similarly easy to self host
and work with. The dokku dependency could be removed but you would then need to
write the whole implementation with GoLang again and dokku does a great job of
it already, you just need to build an interface around it (still hard, but it's
still easier than building the entire builder engine again)

#### `codename` : feedbag

OSS feedback site, this is an experimental project I wish to build while
learning more about web crypto libs.

The idea was to build a self-hosted / easily-injected feedback system for apps
that would'nt involve getting the users to create a new account or an account at
all it'd use the device key to create an identity (web cryptographic login) and
allow anonymous feedback.

Due to it being anonymous a moderator side is required which in this case would
be the app creator.

The feedback could be of various types,

- feature requests
- bug reports etc etc

They can also sponsor/pay to boost up a request up in priority (additional
requirement by [kdy1dev](https://twitter.com/kdy1dev))

#### `codename` : denopkg-search

While everything else is deno is going great, the package searching on one of
the most used platform [crux.land](https://crux.land) is non-existent and can be
easily solved with a simple caching strat of maintaing any requested module in
cache to make a searchable index.

This is going to be very community dependent but it's not that hard if someone
known in the community picks this up.

The database/cache would be some form of NOSQL db instead of SQL DB since the
cache can be duplicated at points of conflicts and might need total overwrites
which will become tedious to maintain in an SQL database.

I'd go with

- deno + alephjs
- couchdb / mongo (Idk what driver has better support in deno right now)

If someone else is picking this up, you can use whatever stack works well for
you

### Multi-Platform

#### `codename` : hello

A very very very minimal text app, just texts and that's about it.

No unique selling point here, it's supposed to a single focused app to be able
to just quickly text.

- Kik used to be this but now it's a mess
- Apple iMessage is close to what I'm talking about but cannot use it with
  everyone.

**Preferences**

- Monochromatic / BW UI
- Just texts, nothing else (e2e encrypted)
- Probably built of the matrix protocol and servers
- Doesn't need a server, uses SSB(https://scuttlebutt.nz) like setup where the
  devices act as storage
- need to send through generated device ID's to add/name people

**Platforms** Preferably all platforms (iOS,Android,Mac, Windows, Linux) , no
I'm not going to compete with telegram / signal.

Not a platform for everyone but well, I'd use it.

**Architecture** Since implementing the logic for every platform would be a bad
idea, the concept is to implement the whole thing in a low level language like C
/ Nim (C) or use something like Go to create shared object code and use the
platform specific UI's to use the provided methods from the shared object code.

Could do an embedded JSON RPC but that'd become complicated since you are
talking inside the app and then iOS background workers rarely work well with
network requests. Though, an internal one shouldn't really have much issues.
(need to POC before moving forward)

### Docker

#### `codename`: postgres-git-backup

A simple docker image that takes in postgres configuration and schedule a backup
task for the provided configuration but instead of saving to s3 / local, have
the ability to push to a git repo or a git lfs based repo (both should be
supported)

### Uncategorized

Things that belong in multiple categories or none at all

#### `codename`: flatmod

Probably already exists, I couldn't find one so adding it here.

The idea is to be able to modify source code to get rid of circular deps by
analysing the dependency of each file and each file's internal behavioural
dependency.

This can be done manually but also something simple could be handled by a tool.

> Note: I understand what webpack and bundle splitters do, this is more on the
> lines of generative codemod instead of a distributed artifact

If it sounds like something to be built, unless it exists, the idea is to take
the source file, go through the deps, find a circular dep, split out the
circular dep's function or exports into a new shared file, this is to be
recursive to re-analyse the codemod with a max depth of 20 (customizable), if it
crosses the max depth, stop the splitting.

Most of the splitting is to happen on temporary files but since it is all
string, can be done with rope algorithms since the size of these files might
vary from project to project

#### `codename`: bundle-drop

Heard of code-push? No? Basically that but self hostable, I'm not talking about
a replica of App Center, but just the set of code required for react-native apps
to be able to get the bundle from a remote source and you being able to upload
this bundle to a self hosted instance.

Expo has a wrapper around this but is closely tied to expo and harder to
implement without it. Another one was from walmart labs called livecode, which
can be configured to point to self uploaded files but the DX could be improved
and it only works in dev mode so there's no way to send in OTA Updates.

**Expectations**

- Upload to a specific registry standard interface
- Ability to add in token/OTP based blockage while uploading
- React Native side will need implementation on both Android and iOS which is
  going to be a little more work but isn't that hard


