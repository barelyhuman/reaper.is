---
title: React Native - Flavours
date: 13/04/2023
published: true
---

### React Native - Flavours

The whole point of working with React Native was to have one codebase in most
cases you need more than one environment (development, staging, production,
etc).

You have a few options

- You could use `.env` files for decided the configurations
- You could setup multiple flavors/variants/schemes and then each one has
  different configs

I normally prefer going with the 1st case for most apps and the 2nd one takes
longer to set up but then there are certain cases for larger apps where it makes
sense to just have multiple variants so that you can contain the exact config
per app variant.

Here's a guide to setting this up for both Android and iOS

#### Draft Post

**Android**

- Add the following in `android/app/build.gradle`

```groovy
{
	/** ...remaining config */
	productFlavors{
	  dev {
           applicationIdSuffix ".dev"
        }
      prod {
            getIsDefault().set(true)
        }
     }
}
```

- Set the following config for `buildTypes` in the same file to make sure the
  prod one's are built with the release configs

```groovy
{
	/** remaining signing config*/
	release{
		/** remaining signing config*/
		productFlavors.dev.signingConfig signingConfigs.debug
		productFlavors.prod.signingConfig signingConfigs.release
	}
}
```

**iOS**

- Create a new scheme using XCode
- Rename the newly generated `InfoCopy.plist` file if you need to. If you do
  change the name, make sure you set the `Info.plist` file to the new one in the
  target's Settings
- Post that, you can now add the `.dev` in the bundle identifier from the
  General screen for the new scheme and you are pretty much done.

- **Javascript**

- `config.js` is now something that goes through the following to see what
  config is to be picked up.

```js
import VersionInfo from 'react-native-version-info'

let config = {}

if (
	VersionInfo.bundleIdentifier &&
	VersionInfo.bundleIdentifier.includes('dev')
) {
	config = {
		API_URL: 'dev.api.com',
	}
} else {
	config = {
		API_URL: 'prod.api.com',
	}
}

export default config
```
