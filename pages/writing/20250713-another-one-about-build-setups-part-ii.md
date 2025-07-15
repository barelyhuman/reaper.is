---
title: Another one about build setups Part - II
published: true
date: 15-07-2025
---

Hey, reaper back for Part II. So far we did UI composition, SSR, bundling,
hydration, and a non-functional server and client router. Let's try to map
things so they are a little more functional

- You can read the [Part 1 here](/writing/20250710-another-one-about-build-setups-part-i)

**TOC**

- [Routing](#routing)
  - [Client Sided Routing](#client-sided-routing)
- [Developer Experience](#developer-experience)

## Routing

### Client Sided Routing

You can actually skip this section for your setup as this is mostly needed to
avoid downloading too much javascript on every page load.

I'll try to explain that statement. When we bundle, we end up combining
everything into one single JS file (No shit sherlock!). To rephrase, every page
component you write is now being downloaded for the client, even if the client
never really visits that page. This might be fine for smaller apps but as the
component trees grow larger and the quantity of pages increase, you end up
stuffing the client with a huge javascript file.

So, what does client side routing have to do with this?

Nothing really, but the section is more about making dynamic imports of the page
components so that the bundler can split them and making the router understand
that certain components are to be loaded lazily. Fortunately, `esbuild` and
`preact-iso` already come with all the tools we need.

Let's modify the `src/App.jsx` to now read a magical import variable called
`pages` (which we'll inject in a bit using some build magic), for now all you
need to know if that `import.meta.pages` is an array of paths to files in the
`pages` directory.

```jsx
import {
    ErrorBoundary,
    lazy,
    LocationProvider,
    Route,
    Router,
} from "preact-iso";

// Dynamically import each page under pages
const routes = (import.meta.pages || []).map(({ path, withoutExt }) => {
    const Component = lazy(() => import(`./pages/${path}`));
    const routePath = "/" + withoutExt.replace(/index$/, "").toLowerCase();
    return <Route path={routePath || "/"} component={Component} />;
});

export function App({ url = "" }) {
    return (
        <ErrorBoundary>
            <LocationProvider url={url}>
                <Router>{routes}</Router>
            </LocationProvider>
        </ErrorBoundary>
    );
}
```

We, go through each page item and map it to a component that is being
dynamically imported using a `import()` statement, we do this because esbuild
already supports dynamic import splitting, so now all the `import()` calls would
create a split and the `lazy` call around it from `preact-iso` is to let the
Client side router know that the component needs to be fetched/loaded before
routing to the page.

Now, as mentioned, let's update the build step to provide us with this `pages`
array.

In `build.js`, let's make some mods

```diff
import { build } from "esbuild";
import glob from "tiny-glob";
import { extname } from "path";
import { spawn } from "child_process";

// collect pages metadata
const pages = await glob("src/pages/**/*.{js,jsx,ts,tsx}").then((files) =>
    files.map((fp) => {
        const p = fp.replace("src/pages/", "");
        return { path: p, withoutExt: p.replace(extname(p), "") };
    })
);

await esbuild.build({
    entryPoints: ["./browser.jsx"],
    format: "esm",
    jsx: "automatic",
    outdir: "./dist/client",
    loader: {
        ".js": "jsx",
    },
+   splitting: true,
+   define: { "import.meta.pages": JSON.stringify(pages) },
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
+   define: { "import.meta.pages": JSON.stringify(pages) },
    bundle: true,
    platform: "node",
    jsxImportSource: "preact",
    external: ["preact", "preact-iso","send"],
});
```

We've basically injected the pages as a JSON array of file paths with and
without extensions and added `splitting` for the browser build.

Now when you run the `node build.js` script, you'll see that the `dist/client`
folder has a lot more files than it did before. There's still the `browser.js`
file but now you have a file for each page as well.

Next up, let's modify the server for pre-rendering the client router. If you
were to run `node ./dist/server.js` on the last build, you'll see that you get
an error on the terminal saying `location is not defined`, this is because the
router depends on the browser API and you'll have to stub it for it to work from
the server. Some frameworks and routers do this for you but since we are here to
teach, let's stub it ourselves.

```jsx
// server.js

// ...remaining code
const handleRequest = async (req, res) => {
    if (req.url.startsWith("/assets")) {
        // remove the prefix `/assets` and only use the rest of the path to serve the file
        // eg: /assets/index.js will become `/index.js` and it will send the `index.js` file
        // in the `client` folder which is defined as the `root` option for send.
        return send(req, req.url.slice("/assets".length), {
            root: join(__dirname, "./client"),
        }).pipe(res);
    }

    globalThis.location = new URL(req.url, "http://localhost");

    const { html } = await prerender(<App url={req.url} />);
    // ...remaining code
    return res.end(finalHTML);
};
```

To reiterate, we now have a global `location` value that partially imitates the
browser's `Location` construct. You can obviously create the entire construct if
you wish, but to keep things minimal and simple, a `URL` works just as well.
We've set it to the path `/` and prefixed it with the base URL of
`http://localhost`. You might want to add in an optional `process.env.HOST`
check if working in Node, but just this also works for running things locally.

Another thing we've done is pass a `url` param to the `App` component, which is
passed down to the `LocationProvider` in the component tree. This is done
so the Router knows what the initial path is and what needs to be pre-rendered.

Finally, let's add a page to render, for example, `pages/index.jsx`:

```jsx
export default function HomePage() {
    return <h1>Hello World</h1>;
}
```

and our file structure or tree should look like so:

```
.
├── App.jsx
├── browser.jsx
├── build.js
├── package.json
├── pages
│   └── index.jsx
└── server.js
```

a quick `node build.js` and `node dist/server.js` should now give you the
contents of `pages/index.jsx` on your browser.

This is by no means a complete router, a complete router would also handle
dynamic parameters, catch all cases and if we wish to go fully into whats
possible, something like TanStack Router or React Router which allow defining
route level data, permission guards and additional layers of error checking for
your safety, not always needed but it's good to have.

Sounds like I'm making a counter point to writing your custom solution, but no.
The solution can be written with the above mentioned routers integrated in your
setup. The point of the tutorial is to explain what goes on inside so it's not a
big black box for everyone. We did that to auth, I don't want that happening to
other things.

## Developer Experience

Okay, moving on, there's

- Seamless auto complete and intellisense for the most common parts
- Live reload or better yet, hot module replacement
- Multi Platform support
- A more seamless api and routing layer.

There's no end to improving the developer experience. But since the first 3 are
required for any basic app we'll add that to our example repo that you can refer
to and get working with.

The repo also makes 2 tiny changes,

1. It uses the fetch standard as the interface for request and response
2. There's different entry files for cloudflare and node so you can use this on
   either environments, in a more realistic situation you'd only want one but
   it's there as an example to help potray the logic.

That's it from me and I hope this helps someone either understand the basics of
it or convinces people to not be scared of writing their own if needed.
