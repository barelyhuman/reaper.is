---
layout: ../../layouts/Page.astro
title: Typescript, VSCode, JSDoc - An overview on managing coding style and restricting developers
published: true
date: 23/09/2021
image_url: https://og.reaper.im/api?fontSize=14&title=Typescript%2C+VSCode%2C+JSDoc&subtitle=Reaper&fontSizeTwo=8&color=%23000&backgroundImageURL=https%3A%2F%2Freaper.im%2Fassets%2Fog-post-background.png
---

Javascript and Typescript , the unneeded debate as to which is better and which should be used has been around for as long coffeescript existed and the debate shifted to Typescript once typescript started getting a lot more heated.

Anyway, none of my business.

Getting to what I use and why I use it. Oh and before we start

> "JS DEVELOPERS DON'T LIKE STRICT TYPING!!!"

is an argument you can use somewhere else, I work with Go and Rust and I like strict typing so that argument doesn't work with me.

## Types and Strict Typing

The problem we have with JS is that it can be variable typed and that causes issues that making debugging hard and it's not because JS allows you to do it but it's because developers need to understand what they are to write and when it's acceptable. Obviously this helps as a reviewer but then the actual developer doesn't understand the reason for the restriction

eg:

```js
let a = 1;

// in code somewhere
a = "string value";

// in some other function
a += 2;
```

You can see the issue here because I've segregated it to 3 specific lines where the mutation is causing the unexpected behaviour but this won't be easy to do when working with code that's larger and this is where you have 2 options.

1. Use `typescript` and strictly type everything
2. Understand the issue is with my code style and improve it.

### 1. Typescript

This is the easy way out and you can leave it on the TS-server to decide how it helps you with configurations and I would advise you learn TS whether or not you use it. The problem is , that without the ts-server you are basically on your own and you'll have to fallback to your own coding skills to make sure the code is safe but it's always good to have some form of completion to help you so we'll get to that as well.

### 2. Improving your code style

- The easiest step is to consider that everything is immutable and that can be done by starting to use `const` instead of `let` for your declarations.

eg:

```js
const a = 1; // cannot be changed.

a = "string value"; // will throw an error

const b = a + 2; // expected behavior b = 3
```

Now, the issue with this is the amount of memory you use but since most JS runtimes have a GC(Garbage Collector) that can keep the memory in control it is still worth it to know that doing this extensively on a global scope is not a good idea. Keep the memory allocations inside smaller scopes and moving to the next point, smaller broken down logic blocks.

- The next step is to break down logic as much as you can to keep it reusable, I don't mean strict DRY coding because that ends up creating a lot more issues in larger projects but breaking into functions / blocks that can be cloned when needed.

eg:

```js
// file: a.js
async function fetchUser() {
  const userId = 2; // would mostly come from the calling function as a param
  const resp = await serverReq(userId);
  return resp;
}

// file: b.js
async function fetchUserWithImage() {
  const userId = 2; // would mostly come from the calling function as a param
  const resp = await serverReq(userId);
  const imageURL = await imageReq(resp.profile_pic_id);
  return { user: resp, imageURL: imageURL };
}
```

Yes, yes I can import the first one and use in the second one and that's possible and a good solution in this scenario but i'm giving an example as to what I mean by code that can be easily cloned. Things that don't need much modification to reproduce similar behaviour.

What does this do? You now have 2 functions, who's memory usage is defined by themselves, `resp` doesn't clear up totally since the reference is passed to the above function but the internal definitions are cleared as soon as the block ends.

So, in a way a little more control over the memory usage (not as granular as something like C but it's okay for now)

- Post breaking down, there's another issue, a lot of developers don't understand the concept of references in JS and so it's something that I will cover now. There's obviously better posts out there that go in detail for this topic but let's take a brief overlook.

```js
const a = [1, 2, 3];
const b = a;
b[0] = 1;

console.log(a, b);

// next snippet
const x = {
  y: 1,
};

const z = x;
z.y = 3;

console.log(x, z);
```

People who understand the issue here already understand references, and people who think that changing `b` has no effect on `a` and changing `z.y` has no effect on the value of `x.y` , here's what's going on.

JS works with references when working with complex types, which in the generic runtime are `arrays` and `objects`, these internally return a reference point for the runtime,

eg:

```
const a = [1,2,3] // returns referencePoint x12132 <= some random address in the runtime memory
```

when you assign it to another variable, the variable takes the reference.

```
const b = a // `b` now points to `x12132`
```

And well, now any changes you make to B are made on the actual reference so unexpected results when re using the original array or original object.

**How do you avoid this?**

The solution is cloning and this can be a whole different post but for now, know that you create a new reference of the complex types using either additions from the newer [tc39 proposals](https://github.com/tc39/proposals) from **es6** to **esnext** or use libraries like `lodash` or `underscore` to create clones for you.

When you understand this , you avoid most of the issues of cleaning up array and other requirements. This concept also helps with React and react's state management or Angular and Angular's `ngChange` directives since they both use reference comparison to see if something changed or not.

### Next?

Next would be to combine these few points and see the difference, the other things that bother developers is that **code style** needs to be managed and consistent, for this , if anyone observed most of my projects have a formatting action that runs standard / prettier and commits back to the code in case of a PR or an edit from the github editor.

This makes sure I can make changes from anywhere and my actions would take care of handling the code style and `standard` is also in the commit hooks to avoid me making obvious mistakes. Do i need to make it super restrictive? Not really, the point of linters and code formatters is to show you what a simple set of rules can help you with, depending on them to handle other people's coding will just stop those developers from learning what went wrong.

A few people can learn by just assuming based on the given explanation but others need to practically see the code break to understand what they did wrong and 9/10 times they won't repeat that.

### But but! I like the autocompletion from Typescript!?

Um, if you structure you app and code well enough, VSCode is smart enough to help you with auto completion and I have no issues with Typescript , i have issues with it trying to be it's own language. It went from being a strict type engine to a full fledged superset and that adds up work.

eg:

```ts
export type PartialState<
  T extends State,
  K1 extends keyof T = keyof T,
  K2 extends keyof T = K1,
  K3 extends keyof T = K2,
  K4 extends keyof T = K3
> =
  | (Pick<T, K1> | Pick<T, K2> | Pick<T, K3> | Pick<T, K4> | T)
  | ((state: T) => Pick<T, K1> | Pick<T, K2> | Pick<T, K3> | Pick<T, K4> | T);
```

The above is an implementation of a `PartialState` type which will allow the keys to be any of the following from the `State` type and also extend the type `T` if the key is from the type `T` , and then I allow picking them , so your auto completion would work as expected.

The **problem** here? this needs to be learned and can get more and more complex as time goes, compared to simply writing the type of what the particular object / type is to represent, because this is trying to be more than a type, this is trying to be the entire logic of how the code can be accessed, and is specifically written to help people write function parameters the way **I want to restrict it too** but then , is this readable over time? If I come back to this 2 years later will I understand what I was thinking? Probably not.

But yes, I understand that intellisense is a huge part of developers life today and so I use an alternative, I don't write types this complex. I write smaller types that are basically easy to read and use and **use them in my `.js` files.**

### Wait, WHAT?

You read it right, I use the types in my `.js` files. The ts-server is a very powerful tool and even more powerful tool today is the code editor VSCode and it handles typescript natively since it's built on the same tech.

But , it supports the general JS ecosystem to it supports JSDoc and typescript itself supports JSDoc since that was the **de facto** way of writing documentation for JS before all of this came up.

#### Get to the goddamn example already!

Cool, so since ts-server can handle both, I can write types in TS and keep using JS for my logic block without ever having to setup typescript in the project, I don't need `tsconfig`, i don't need to compile my code, or sit and solve type issues that aren't supposed to be blocking when it's Friday and you have to deploy the project in an hour.

so , this is how I have it setup as a small example

```ts
// app.js

/** @returns {import("./types").SomeTypeDef} */
function printSomeTypeDef() {
  return {
    name: "hello", // will show the autocomplete if I type `n` as the return type is defined already
  };
}

//types.d.ts
declare interface SomeTypeDef {
  name: string;
  age: number;
}
```

Nah, don't get scared, the import statement will be autofilled by vscode so it's okay.
Also, minor detail, you can directly write `{SomeTypeDef}` without importing in cases where you have a single ambient type declaration file, if you have any other type declaration file that does `exports` instead of ambient declaration, you'll have to use the import syntax.

#### That's a lot of typing.

Not really, it's the same amount of typing you'd do to import a type in TS and then assign it to a function, also most of JSDoc syntax is also autocompleted by VSCode without the need for a ts-server so that's that. The issue with this is the need for VSCode, for someone like me who works with Vim, Sublime as and when I feel like it, the autocompletion breaks and that's fine because I'd prefer referring and falling back on my own coding skills than totally depending on typescript to decide what I can do in my code.

**Finally**,

- **do learn typescript** it's good to understand the things that are missing in JS and things you can avoid
- **don't write types that make it complex to read the code** - it's useless to be smart for 10 seconds and then go dumb 2 years later and understand nothing that you've written
- **Restrictions are to be understood and not imposed on developers** - if the developer is just going to be a man following orders without understanding the reason and using his own reasoning to whether do it or not, then well I don't see this as a good developer, he's a good bot that can write code

Probably typed a lot of things that will offend people but these are based on my experiences and based on things I've screwed up while learning to code, might differ in your case and you may have valid counter points to everything I've written and I'd honestly like to hear them. Till next time...
