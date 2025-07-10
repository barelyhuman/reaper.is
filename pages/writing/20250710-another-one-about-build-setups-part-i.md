---
title: Another one about build setups Part - I
published: true
date: 10-07-2025
---

Hey, the name's reaper. I work on various experimental solutions for working
with web apps, ASTs, and generally play around with languages. Mentioning all
this because I'm not some random dude who started working on the web yesterday
and is teaching you things today.

Moving on, I've advocated the use of custom setups and simple build tooling
quite a bit on my [twitter/X profile](https://x.com/barelyreaper), and so this
post is also in the same direction—except I plan to show you how simple it
actually is.

This is a long-ass post, so you might want to start this when you have a clear
mind and can follow along. You don't need to, but it'd be nice.

- [Meta Frameworks](#meta-frameworks)
- [Features](#features)
  - [UI Composition](#ui-composition)
  - [SSR](#ssr)
  - [Code transforms, Bundling, Minification](#code-transforms-bundling-minification)
  - [Client hydration](#client-hydration)
    - [Serving Assets](#serving-assets)

## Meta Frameworks

I'm sure you're aware of what meta frameworks are and when to use them. We
aren't here to call them bad or call my approach good—it's a simple post going
through the process of simplifying what the meta frameworks abstract.

## Features

What do meta frameworks solve that we need to replicate?

- UI Composition
- SSR (for content-based sites)
- Code transforms, Bundling, Minification
- Client hydration
  - Serving Assets
- Routing
- a shit ton of developer experience

The last thing is what makes them really attractive to most developers-beginners
and advanced devs alike. So, we won't be adding any developer experience in this
post. Let's focus on the other things.

### UI Composition

There's a ton of libraries for this: React, Preact, Vue, Svelte, Solid,
Hyperscript, yada yada ya...

We'll use Preact, 'cause it's my post.

Here's what UI composition would look like in Preact:

```jsx
import { useState } from "preact/hooks";

const Layout = ({ children }) => <div className="container">{children}</div>;

const Counter = () => {
  const [count, setCount] = useState(0);
  return (
    <Layout>
      <button onClick={() => setCount(count + 1)}>{count}</button>
    </Layout>
  );
};
```

Now, let's say I wanted to render this in the browser, I'd use the `render`
function from the lib:

```jsx
import { render } from "preact";

//... Counter Component

render(<Counter />, document.getElementById("app"));
```

Great, we have UI composition. Let's target SSR next.

### SSR

SSR, or Server-Side Rendering, is a way to simplify the composed UI into a
simpler form for the target. There can be different renderers; we will be
targeting the browser, so our renderer will do things so a browser can
handle/render it.

The point is to be able to construct structured trees of what needs to be
rendered, and each one of the UI libraries provides some way or another to do
this. Vue and Svelte provide a compiler, (P)react creates a VDOM object. This
makes it easy for us to traverse through and use the structure to our liking—
a.k.a. the renderer can be anything.

For example, we could convert them into serializable JSON and then convert that
JSON back to a tree and then re-construct the component and ask it to render in
the browser (some libs do this, research to find out).

To keep things simple, we are going to convert this structured/vdom tree into
HTML using `preact-iso`. You can also use `preact-render-to-string` (they are
the same library, but `preact-iso` provides other things that we need in this
post).

Let's see what a simple SSR with Node.js would look like:

```jsx
// server.js
import { createServer } from "node:http";
import { prerender } from "preact-iso";
import { useState } from "preact/hooks";

const Counter = () => {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
};

const handleRequest = async (req, res) => {
  const { html } = await prerender(<Counter />);
  res.setHeader("content-type", "text/html");
  return res.end(html);
};

createServer(handleRequest).listen(3000, () => {
  console.log("Listening on :3000");
});
```

It's a little more code than I'd like to explain, but here's what we are trying
to do:

- Create an HTTP server with `node:http` for Node.js
- Instruct the server to respond with an HTML representation of the `Counter`
  component.

What you'll see here is that when you run this with `node server.js`, you get an
error like so:

```
  return <button onClick={() => setCount(count + 1)}>{count}</button>
         ^

SyntaxError: Unexpected token '<'
    at compileSourceTextModule (node:internal/modules/esm/utils:339:16)
    at ModuleLoader.moduleStrategy (node:internal/modules/esm/translators:168:18)
    at callTranslator (node:internal/modules/esm/loader:428:14)
    at ModuleLoader.moduleProvider (node:internal/modules/esm/loader:434:30)
    at async link (node:internal/modules/esm/module_job:87:21)
```

This is where the third feature comes in: the meta frameworks take care of code
transforms, bundling, and minification.

### Code transforms, Bundling, Minification

Since JS doesn't come with macros or a way to make modifications at build time,
we have build tools to help us with that. You see, JSX isn't exactly a part of
the JS spec, so we need something that can build this file into pure JS so we
can run it with Node.

We'll use `esbuild` to help us with this. It's not the only tool for this task,
but I want to establish tools that are written by people who are very thoughtful
about how they add features, and that keeps me from having to update this post
every few months.

```js
// build.js

import esbuild from "esbuild";

await esbuild.build({
  entryPoints: ["./server.js"],
  format: "esm",
  jsx: "automatic",
  outdir: "./dist",
  loader: {
    ".js": "jsx",
  },
  bundle: true,
  platform: "node",
  jsxImportSource: "preact",
  external: ["preact", "preact-iso"],
});
```

With this, we now run `node build.js` first and then run
`node ./dist/server.js`, and you now have a server on `localhost:3000` that
renders a button. The button doesn't do much, but it's there—it's the button you
created on the server, SSR!!!

Moving on...

### Client hydration

The button's useless without the counter increasing, which is what we wanted it
to do, but because we just pushed some HTML to the browser, it doesn't know how
to make the button interactive, and we'll have to fix this.

This is something most frameworks abstract away beautifully, so most people
who've never written a custom implementation feel like there's a super
complicated setup behind this.

We need to accomplish three things now:

1. Make the UI logic isolated
2. Make the server render this isolated UI logic (already have the skeleton for
   this)
3. Make the browser re-add the counter logic.

Let's move the UI logic to a separate file. I'll call it `App.jsx`, and I'm
going to rename the component to `App` instead of `Counter`.

```jsx
// App.jsx

import { useState } from "preact/hooks";

export const App = () => {
  const [count, setCount] = useState(0);
  return <button onClick={() => setCount(count + 1)}>{count}</button>;
};
```

Moving to the second step, our `server.js` now looks like so:

```jsx
import { createServer } from "node:http";
import { prerender } from "preact-iso";
import { App } from "./App.jsx";

const handleRequest = async (req, res) => {
  const { html } = await prerender(<App />);
  res.setHeader("content-type", "text/html");
  return res.end(html);
};

createServer(handleRequest).listen(3000, () => {
  console.log("Listening on :3000");
});
```

If you do a `node build.js` and `node ./dist/index.js`, things should still be
working.

Now, step three: I need the browser to mount this app again. Let's ask Preact to
`hydrate` or mount the app again.

```jsx
// browser.jsx

import { hydrate } from "preact-iso";
import { App } from "./App.jsx";

hydrate(<App />, document.getElementById("app"));
```

We have a `document.getElementById("app")` here, which doesn't exist in the HTML
we've been sending from the server, so let's fix that in the server.

```diff
import { createServer } from 'node:http'
import { prerender } from 'preact-iso'
import { App } from './App.jsx'

const handleRequest = async (req, res) => {
  const { html } = await prerender(<App />)
+  const finalHTML = `
+    <body>
+     <div id="app">
+       ${html}
+     </div>
+   </body>
  `
  res.setHeader('content-type', 'text/html')
-  return res.end(html)
+  return res.end(finalHTML)
}

createServer(handleRequest).listen(3000, () => {
  console.log('Listening on :3000')
})
```

We added wrapper HTML code that contains the element with the `id` of `app`.
Does that solve our problem though? Try building and running again.

We still have a useless button...

Why? Because while we added the wrapper, there's no way the browser knows that
it needs to fetch the `browser.jsx` file. And another problem: it's a file with
JSX code, which means we need to transpile/compile it to pure JS so the
browser can understand it.

Let's deal with the latter problem first. We'll modify the build.js to also
create a bundle for the browser, and the output will be in `dist/client`. You
can check the output of both the server and the browser builds to see what's
being generated—should help you understand a bit more about the build tools.

```jsx
// build.js
import esbuild from "esbuild";

await esbuild.build({
  entryPoints: ["./browser.jsx"],
  format: "esm",
  jsx: "automatic",
  outdir: "./dist/client",
  loader: {
    ".js": "jsx",
  },
  bundle: true,
  platform: "browser",
  jsxImportSource: "preact",
});

await esbuild.build({
  entryPoints: ["./index.js"],
  format: "esm",
  jsx: "automatic",
  outdir: "./dist",
  loader: {
    ".js": "jsx",
  },
  bundle: true,
  platform: "node",
  jsxImportSource: "preact",
  external: ["preact", "preact-iso"],
});
```

Cool, now we have a browser build and a server build where we can write JSX. Back to the original
problem: how does the browser know where to fetch the client file from?

Two steps:

1. Set up static serving for files
2. Add the location for the served files in your HTML wrapper

#### Serving Assets

We need to make some mods so that the browser can ask the server to send a specific file. This is how it would get CSS files in the future, but for now we want it
to get the compiled `browser.js` file from the `./dist/client` folder.

Let's use a simple library called `send` to help us with this. A few things: we
are writing this code with the assumption that the folder structure looks like
this:

```sh
.
├── App.jsx
├── browser.jsx
├── build.js
├── server.js
├── package.json
│---------------- # Build Output
└── dist
    ├── client
    │   └── browser.js
    └── server.js
```

So, the code we run with `node dist/server.js` belongs in the directory `dist`,
and so does the `client` folder. Hence, we need to program the server to keep
that in mind.

Next, we want to ask the server to make sure it only serves the static files
when the request URL starts with `/assets`.

Let's make these modifications.

```jsx
// server.js
import send from "send";
import { fileURLToPath } from "node:url";
import { dirname, join } from "node:path";

const __dirname = dirname(fileURLToPath(import.meta.url));

const handleRequest = async (req, res) => {
  if (req.url.startsWith("/assets")) {
    // remove the prefix `/assets` and only use the rest of the path to serve the file
    // eg: /assets/index.js will become `/index.js` and it will send the `index.js` file
    // in the `client` folder which is defined as the `root` option for send.
    return send(req, req.url.slice("/assets".length), {
      root: join(__dirname, "./client"),
    }).pipe(res);
  }

  //... SSR code
};
```

At this point you should be able to build and run the server and open the browser to
`localhost:3000/assets/browser.js`, and it should show you your bundled
JavaScript code in the browser. Let's change the wrapper HTML code to send this file as a part of our rendered app

```diff
const handleRequest = async (req, res) => {
  if (req.url.startsWith("/assets")) {
    // remove the prefix `/assets` and only use the rest of the path to serve the file
    // eg: /assets/index.js will become `/index.js` and it will send the `index.js` file
    // in the `client` folder which is defined as the `root` option for send.
    return send(req, req.url.slice("/assets".length), {
      root: join(__dirname, "./client"),
    }).pipe(res);
  }

  const { html } = await prerender(<App />)
  const finalHTML = `
  <body>
    <div id="app">
      ${html}
    </div>
+   <script type="module" src="/assets/browser.js"></script>
  </body>
  `
  res.setHeader('content-type', 'text/html')
  return res.end(finalHTML)
}
```

Also make sure to update the `build.js` file to exclude `send` in the external deps in the server's build.

```diff
import esbuild from "esbuild";

await esbuild.build({
    entryPoints: ["./browser.jsx"],
    format: "esm",
    jsx: "automatic",
    outdir: "./dist/client",
    loader: {
        ".js": "jsx",
    },
    bundle: true,
    platform: "browser",
    jsxImportSource: "preact",
});

await esbuild.build({
    entryPoints: ["./server.js"],
    format: "esm",
    jsx: "automatic",
    outdir: "./dist",
    loader: {
        ".js": "jsx",
    },
    bundle: true,
    platform: "node",
    jsxImportSource: "preact",
-   external: ["preact", "preact-iso"],
+   external: ["preact", "preact-iso", "send"],
});
```

Now, if you run `node build.js` and `node ./dist/server.js`, you should have a
working button that increases the counter!!!

In a way, we're kinda done. Next up, there are things like routing, adding more
platform support, abstracting away Node's server layer so you can use it in
different runtimes (for example, Cloudflare or Deno). I'll cover that in the
next post.
