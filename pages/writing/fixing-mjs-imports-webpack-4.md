---
title: Fixing .mjs imports with ESM libraries in Webpack 4
published: true
date: 30/07/2021
---

No long story for this one.

If you are working with **Webpack 4 with/without Typescript** there's a good chance that your webpack is complaining about **`.mjs`** files and not
being able to import stuff from them.

2 solutions.

1. Migrate to Webpack 5
2. Configure Webpack 4 to remove the strict module loading so it can just bundle the `.mjs` files as normal `.js` files

for those who'd go with the 2nd one, here's how.

Considering the below is your webpack config, add another rule to the array of rules.

```js
const config = {
  module: {
    rules: [
      // ... all your loaders/rules
      // add the below rule
      {
        type: 'javascript/auto',
        test: /\.mjs$/,
        use: [],
      },
    ],
  },
}
```

If you are using `create-react-app`, the default `babel-loader` tried to load the **`.mjs`** files but other .mjs rules actually conflict with it so
instead of trying to handle every conflict just let webpack know that it has to consider **`.mjs`** files as just plain javascript files that it needs
to compile as normal and it'll take care of it.

Hope that helps someone.
