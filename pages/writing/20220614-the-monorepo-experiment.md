---
title: An attempt to reduce the monorepo complexity
date: 15/06/2022
---

> **Note**: This involves ESM quite a bit so you might wanna read about ESM
> first and then get to this.

I made a tweet yesterday with regards to getting a unified component API working
on both React Native and React (**not react native web**)

&rarr; [Tweet](https://twitter.com/barelyreaper/status/1536636401131061248)

Now, this might not seem like a huge achievement or something ground breaking
for most people since they've been kinda doing this with typescript all along as
typescript handles the module aliases and path resolution and it's neat.

Plus, ESM has been around for long enough that someone else might have already
done it and I didn't know about it so I got excited but well, let's get to what
the post is actually about.

**Monorepos**

I have a love hate relation with Monorepos , primarily because they reduce the
context switching when compared to a multi repo setup and I hate it due to the
sheer complexity that comes with it while setting it up.

To be fair, [Jared Palmer](https://jaredpalmer.com) did kinda solve this with
[Turborepo](https://turborepo.org) and no I wasn't paid to promote it, I'm not
paid shit anywhere for any of my work.

Now, the solution turborepo brings is more on the lines on initial setup, and
having an opinionated monorepo arch and it's fast since everything is **remotely
cached** for you. This makes it faster to install and rebuild your app even over
CI's

As to why do I still have problems with Monorepos, the complexity hasn't just
gone away.

Yarn v2+ (Yarn 3) has made it easier to create and work with them without the
need to use lerna and even npm handles this well right now but there's still
things that you need to configure when working with both Javascript and
Typescript setups.

A few examples,

- Compiler configurations to make sure your package works in other packages (in
  the repo itself)
- Hoist and No-Hoist issues from various dependencies (mostly react and
  react-native dependent stuff)
- Managing dev and peer deps when working with stuff that shouldn't be bundled
  with your code (ex: styled-components)
- Configuring scripts and linters to make sure a new junior dev doesn't break
  this entire setup with a single line

a.k.a, the abstraction of the tooling is very necessary and that's still
something that people are figuring out.

**What does your tweet have to do with all this?**

be patient!!

When ESM came into the picture, a few developers jumped the train and moved
their modules to pure ESM right away and
[Sindre Sorhus](https://sindresorhus.com) was one of them who did list out a
couple of reasons as to why it was the right thing to do and most points were
valid but I was still concerned cause a lot of my work related stuff was still
on Node 8 at the time.

Also, why I've spent so much time making sure
[ESM and CJS packages worked everywhere, as much as possible](https://reaper.is/writing/20220418-the-esm-cjs-problem)

One point that people missed was the reduced need for transpilers and bundlers.
It should've been obvious since deno is literally the proof for this, but I'm
dumb so I didn't sit to think about it.

Anyway, was working on a monorepo we have at work and there's no UI component
sharing, there's business logic sharing with respect to a API SDK and general
computation on all sides (backend / frontend / mobile) and metro bundler decided
to fail on symlinked packages so I had to fix it's configuration _again_ and
while I was doing that the above concept hit me and with my impulsive nature in
place, we now have...

- an ESM for the whole SDK and computation logic
- another one for a unified component API layer

Now all that's left in the repo in terms of bundlers are Metro, Vite and
Typescript, which is well necessary since type-graphql needs typescript, react
native needs Metro and the react app needs some bundler at least till I'm done
creating a solution to avoid having to use a bundler with simple web apps as
well

We had rollup for the shared logic and SDK , which is now no more needed, and if
you've done component libraries before you've seen the configuration they come
with.

Hence, the tweet. Not so exciting for everyone but I kinda reduced the whole
need to handle multiple bundlers or transpilers in the monorepo and it's only
left to the one's that are absolutely necessary.

This also, **simplified the `metro.config.js`** since I no more have to add
every folder to the watchFolder since it's no more symlinked, I can just add
`extraNodeModules` and give it the path to the neighbouring folder and done. All
the complicated symlink handlers, monorepo helpers, gone, removed, destroyed.

**Why not use Typescript for everything?** _Do you not know me!?_

As for the unification layer this is how my imports for the shared components
are now.

```js
//  in react
import { Button } from "@barelyhuman/ui";

// in react native
import { Button } from "@barelyhuman/ui/native";
```

and the simplified components look like this

```js
// src/button/button.js
export const Button = styled.button`
    ... styles
`;

// src/button/button.native.js
const _Button = styled.TouchableOpacity`
    ... styles
`;

const _ButtonLabel = styled.Text`
    ... styles
`;

export const Button = ({ children, ...props }) => {
  return (
    <_Button>
      <_ButtonLabel>{children}</_ButtonLabel>
    </_Button>
  );
};
```

The source folder has 2 index files for the actual exports

```js
// src/index.js
export * from "./button/button.js";

// src/index.native.js
export * from "./button/button.native.js";
```

and then at the root of the folder we have another `index.js` and a
`native/index.js` to make the imports a little more cleaner, you can also do the
same with the `exports` field in package.json and expect it to work well but
metro fails to recognize this (rarely, but does) so it's easier to just have the
package itself act as the import path

```js
// index.js
export * from "./src/index.js";

// native/index.js
export * from "./src/index.native.js";
```

The same is done for the business logic but since there's no difference there in
terms of implementation and it's just simple functions, the aesthetics are left
to a minimal.

**Here's a demo snippet**:

```js
import { useOptionStore } from "@barleyhuman/shared/store";
import { Checkbox, CheckboxLabel } from "@barleyhuman/ui";

function ListOptions({ selected, onChange }) {
  const populateOptions = useOptionStore((x) => x.populate);
  const options = useOptionStore((x) => x.options);

  useEffect(() => {
    populateOptions();
  }, []);

  return (
    <>
      {options.map((optionItem) => (
        <li>
          <Checkbox
            value={optionItem.value}
            checked={selected === optionItem.value}
            onChange={(v) => onChange && onChange(v)}
          >
            <CheckboxLabel>{optionItem.label}</CheckboxLabel>
          </Checkbox>
        </li>
      ))}
    </>
  );
}
```

So, not much was reduced in terms of complexity but it was plenty considering:

- No extra configurations to handle
- Remove the build scripts from the root for the same
- The setup doesn't break due to an abstraction that no one other than the
  person who setup the code arch understands. (a.k.a easier to look for
  documentation when the configurations are much simpler)
- Easier to compose stuff since it's just javascript.

**Cons**

- Jest will need a babel step in the middle to work (Use uvu,ava,tape,etc if
  you're setting up a new project)
- You still have to be considerate of dev and peer dependencies since react
  doesn't like multiple instances, neither does styled-components
- Not all packages you are using might work with `type:"module"`, so good chance
  you might have to look for hybrid supported packages or pure esm packages.

The last one might irritate quite a bit during development but most of what I
use is from people I know write hybrid packages it's mostly the nested/deep
dependencies that I'm worried about.

Don't worry, I'm not shifting all my packages(ESM + CJS) to pure ESM, if there's
only one person using them, it's still a user and it's going to stay that way.
If that's a bother to you, you are free to fork the packages and create pure ESM
versions of the same. All of them are licensed MIT for this very reason.
