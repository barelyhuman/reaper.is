---
title: "The ESM and CJS Problem"
date: "18/04/2022"
published: true
---

**Disclaimer:** I understand the advantages of moving to ESM and support that people do so but, I'm not a
fan of just moving everything to new tech while breaking tech that was already working. Users are also at blame for not checking release notes but it's on both parties but finding solutions is a part of our work so, this.

## The problem

### `tldr;`

There's huge number of bundlers, each with their own implementation of the esm spec and so we either need
to support each spec or at least find common ground to support most bundler setups. (though most bundlers are now on par with the official spec, this post will go through things you can do to reduce friction in
older setups)

---

Creating ESM and CJS packages that work in most environments. I wasn't even aware of this being an
issue until I started writing my own packages.

The problem is based on how bundlers handle these files and different ES syntax that are available today.

Most user(developer) setups involve some form of configuration to decide what ES syntax they can
write in their code.

Example.

```js
const array = [1, 2, 3];
const shallowCloned = [...array];

// this might not work for you if the ES syntax your transpiler supports doesn't
// have spread syntax support.
```

So, as a package maintainer, we have to be sure of what version of ES syntax we plan to support and
compile/transpile our code so the user setups can handle them.

I wish it ended at that, but it doesn't. As we have to keep moving forward with the standards so a new standard emerged a while back which was already being used by browsers for a while and its called `EcmaScript Modules` (ESM).
ESM is basically a way of treating modules as asynchronous sources of javascript code / behaviour.

Which makes it possible to use cached modules from a remote source (at least in browsers).
The advantages towards having it in node environments would add a more unified language standard
and reduce the need for bundlers as the esm package could be just shipped as is.

The support for this spec was added behind an experimental flag in earlier versions of Node 12.

A few package maintainers, decided to move to ESM right away and their newer package versions(major version, no breaks for existing users, unless they do `npm install pkg@latest`) would break setups that weren't respecting the ESM standards.

Users(developers) would just go `npm install <package-name>` and that installs the latest version and
half of them never read docs so they had no idea what was going on.

Oh, you should've seen the amount of `cannot use esm in common js` issues that were raised by devs during
this phase.

Now, bundlers that added support for esm as patches handled the issue pretty well. But bundlers that were undergoing changes in arch and API took a little longer to get it working and most people who reported these compat issues were on these bundlers.

"Where's the problem? You're just ranting Reaper". More like giving context, but this is where the
problem is, the diverse nature of setups in the javascript world is what's responsible for the existence
on this problem. How we mitigate it, is up next.

## The Workarounds

"Workarounds", cause these are not concrete solutions.

If you wish to support both sides of the party, CJS and ESM. The points mentioned here might help you
both as a maintainer and as a library user but there's certain behaviours
that I didn't spent much time researching on. Whatever mentioned here is based on my personal work with
these kind of packages and in some cases browsing the codebases of bundlers where an issue for this was raised.

### The simplest one (for maintainers), not so much for users.

**For the maintainer**
Name the files as `.mjs` and ship the package. This will trigger errors on the user(developer)'s bundler and they can add support for `.mjs` accordingly. You can also keep the extension as `.js` and instead
change the `type` field in `package.json` to be `"module"`

```json
{
  // @filename: package.json
  "type": "module"
}
```

**For the user**
Most of your bundlers come with configuration to handle such cases.
What you are looking for is a way to add support for custom extensions and transpile them as normal JS/ES
syntax and transpile as needed.

**NOTE:** If the library is using very specific ESM syntax like `import x from 'node:fs'` , you might need to see if your bundler supports
handling protocol based imports. If not, well, talk to the maintainer, and figure out if they wish to help you with it or if they even have that plan in the scope, if not, you might wanna look for an alternative replacement for the library or look for an older version of the lib.

### Taking the middleground

This is where I'll be standing till the ecosystem has stabilised (at least for me), which is a decision I've taken mainly due to the bundlers and setups used by major frameworks. In my case this would be (React, React Native) and a lot of other system level CLI libraries, cause I work with these the most.

Like everyone else rooting for ESM, I'm also waiting for the point in time where I won't have to use a transpiler anymore, sounds like an amazing place to be, but I'm not the only developers and not everyone
is on the same page and people want CJS to stay for longer so we're going to work for both sides.

Before actually writing your package, you need to decide where is library going to be used?

#### Library for just react native?

Write it like you already did, babel will take care of it. Don't have to deal with ESM and CJS
for now.

#### Library just for the web?

Write it in ESM, it already works in all major browsers but, maybe add an IIFE/UMD version just in case.
It's not that hard to generate these from existing code.

#### Universal package?

Well, this is where the fun is , isn't it?

Let's see the number of bundlers we have that should be able to work with
our package.

1. Webpack 4/5
2. SWC
3. esbuild
4. rollup (microbundle,wrap,etc etc etc)
5. Parcel
6. Metro Bundler
7. sandpack (codesandbox's implementation)
8. Skypack (literally has it's own patched version of react for esm! and other major libraries)

There's a few more actually, but 8 sounds like a nice number to stop at, daunting enough already.
You can add Typescript's `tsc` to the list, as you can kinda use it to generate a single file.

Cool, getting to the fun part.

### Configuration

Starting with `package.json`

The entry point of your package decides what most bundlers see and this is what they look for, when trying to figure out what should be allowed to import and what should be ignored.

This segregation helps with handling private dependencies or internal code that you don't want exposed.

This can also be done by having a single `index.js` file exporting modules that should be exposed, which is the easier way out.

But, when you work with packages that might need multiple entries, you'll have to configure a few things.

A good example of this is [jotai](https://github.com/pmndrs/jotai) and [zustand](https://github.com/pmndrs/zustand) which have imports like the following

```js
import {} from "jotai";
import {} from "jotai/utils";
import create from "zustand";
import {} from "zustand/middleware";
```

This gives the user a clean import and makes it obvious as to what's being used and from where.

**How do we achieve this?**

This is how the `package.json` for something like this would look like if all you were writing for
was ESM.

```json
// @filename: package.json
{
  "exports": {
    ".": "index.js",
    "middleware": "middleware.js"
  }
}
```

We aren't working with just ESM so let's compile a few CJS versions using whatever bundler and
adding them in the entry points as well.

```json
// @filename: package.json
{
  "exports": {
    ".": {
      "import": "index.js",
      "require": "index.cjs"
    },
    "middleware": {
      "import": "middleware.js",
      "require": "middleware.cjs"
    }
  }
}
```

This is what Node's spec specifies for conditional imports. We basically are asking the bundlers to make
sure that they import the right file when working with our package.

Just doing this should solve the issue in your user's code editor because they all use Typescript's LSP engine and this satisfies the conditions for that to work.

Later versions of Node 12 need path specific exports, so we'll have to change the exports a bit.

```json
// @filename: package.json
{
  "exports": {
    ".": {
      "import": "./index.js",
      "require": "./index.cjs"
    },
    "middleware": {
      "import": "./middleware.js",
      "require": "./middleware.cjs"
    }
  }
}
```

The change being, adding path specfiers for the files references. This should still work with the LSP engine but the bundlers need a little more configuration so let's fix that

### Webpack 4 Support

Webpack 4 uses the `module` field to find the esm files so add `module` to `exports`

```json
// @filename: package.json
{
  "exports": {
    ".": {
      "import": "./index.js",
      "module": "./index.js",
      "require": "./index.cjs"
    },
    "middleware": {
      "import": "./middleware.js",
      "module": "./middleware.js",
      "require": "./middleware.cjs"
    }
  }
}
```

If working with single entry file, you add the module field to the top level of your `package.json`

```json
// @filename: package.json
{
  "name": "pkg",
  "module": "./index.js",
  "main": "./index.cjs"
}
```

In certain cases you might have to tell `babel-loader` to consider `.mjs` as a `.js` file. You can find
this online on "how to configure webpack 4 for `.mjs` files"

### Metro Bundler Support

I work with react native a lot and most of my packages start as a utility for one of my work related apps
and then made as a generic package for all platforms.

If you can keep the library limited to 1 entry file, then you don't have to write the exports section at all.
You can do something like this and this should work in both webpack and metro, no issues.

```json
// @filename: package.json
{
  "main": "./dist/index.js",
  "module": "./dist/index.mjs",
  "types": "./dist/index.d.ts"
}
```

Multi entry packages, don't worry. I'm still here.

You will setup everything according to Webpack 4 support and add 1 additional field and one extra export. Also, if you used
`.cjs` like me for commonjs files, you'll have to let the user know that they need to tell metro to consider `.cjs` as a valid format

```json
// @filename: package.json
{
  "exports": {
    // as stupid as it looks, it's needed for metro or it'll complain that it can't import cause it wasn't exported
    "./package.json": "./package.json",
    ".": {
      "import": "./index.js",
      "module": "./index.js",
      "require": "./index.cjs",
      "default": "./index.cjs"
      // you can also add types if you wish to, bundlers might not, but the ts engine does so it should work in most cases.
      "types":"./index.d.ts"
    },
    "middleware": {
      "import": "./middleware.js",
      "module": "./middleware.js",
      "require": "./middleware.cjs"
      "default": "./middleware.cjs"
    }
  }
}
```

Metro configuration if you used `.cjs`, same goes if you used `.mjs` for esm

```js
// @filename: metro.config.js
module.exports = {
  resolver: {
    sourceExts: [".mjs", ".cjs", ".js"], // <= the user will have to add this
  },
};
```

That's all the information you need to support most of them since esbuild, rollup, parcel, and sandpack handle the generic exports
spec pretty well, so just releasing `mjs` and `cjs` files for them just works out of the box

But there's always people who have a setup on something like `node10` and if I was maintaining something like Jotai, i wouldn't want to
leave them hanging so there's other steps that were taken in libs like these and you can read about that on
[How Jotai handles package entries](https://blog.axlight.com/posts/how-jotai-specifies-package-entry-points/).

### End note

These points are just to mitigate the issues when you are using or writing packages and
I wish there were better ways to do things but this is the closest you can get to it right now.

I'd very much like for the majority of the ecosystem to get compatible with esm without having to configure things in each setup like I do right now.

I think, the newer versions of metro should already start taking in the `.mjs` and `.cjs` as normal.

Also, if you are reading this and are still using webpack 4, please, upgrade to webpack 5, please!
