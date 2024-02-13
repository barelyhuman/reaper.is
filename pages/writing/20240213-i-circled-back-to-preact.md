---
title: I circled back to Preact
date: 13/02/2024
published: true
---

I've mentioned about liking arrowjs and working with it for simple and straight
forward web apps with minimal interaction. The concept of being able to do it
all without build tools sat well with my goal of
[plainjs](https://plainjs.github.io)

The overall concept of reactivity as a primitive instead of the entire framework
isn't new and is also something [SolidJS](http://solidjs.com) has proven to be a
good base to work with.

I liked this and wanted to see what I could do make it simpler to work with
arrowjs both without build tooling and with one.

## Without build Tooling

The first iteration of this is [`nomen`](https://github.com/barelyhuman/nomen)
which allows you to choose your rendering engine to be one of the following UI
libraries - preact, arrow and vanilla js.

Nomen, doesn't build / transform anything for arrow and would just bundle it all
up so you didn't have to. The bundling is done at application startup so we can
avoid runtime overhead.

You also have a build cache which would be used in production environments to
avoid rebuilding if the build is already in place.

## With build tooling

The other iteration was what most modern meta frameworks do and it was to use
[Vite](https://vite.dev) to handle the transformation and final distribution.

This was a lower effort since I didn't have to implement most of the basics of a
meta framework from scratch and instead just write a plugin for vite. This
didn't sit with the plainjs mentality but was necessary to be able to quickly
evaluate the usability of my love for ArrowJS.

## ArrowJS

Let's actually look at the good, the bad and the things that I think made me
move back to preact.

### What's good?

- Primitives
- Speed

**Primitives**

The basic primitives are very extensible and work really well. This is what
small and well contained utilities can do.

The entire library works off of the `reactive` and `watch` primitive functions
exposed by it.

And they do exactly what their names tell. One creates a reactive proxy and the
other provides a way to watch these reactive items.

**Speed**

The whole thing is super fast, you can check this on their demos as well but
while using it on a live app, it made me realise how big of a tree it was
constructing and still didn't flinch one bit.

### What's bad?

- Readability
- Composability

**Readability**

The overall nesting that html template literals create gets hard to track and
work with over time.

While you can create simple components with arrow's `html` function, it's still
hard to work with direct html strings.

To help with the development, you can use `lit-html`'s syntax highlighter and it
definitely helps but it's still not as functionally pleasing as let's say Vue's
SFC syntax or JSX.

**Composability**

Keeping track of what's reactive and what's not can get hard. If you have a
static html string and the nested reactive html component, there might be cases
where it doesn't update itself because the root html component was static.

Giving the control of what is and isn't reactive to the developer doesn't work
well in larger trees and you end up having to go through every insertion to find
which template is typed wrong.

Luckily while using `adex` the above was very rare but that doesn't mean the
problem doesn't exist.

I still like the concept and would continue to use it for simple apps where I
don't need build tooling but this does change the priority of what `nomen` and
`adex` will focus on.

The development for both of them would start moving forward to make working
with preact a lot easier since it's going to get hard for preact's team to keep
up with every new change that react might bring to the stage and I want first class frameworks and libraries for preact instead. 

I personally think it's about time the preact ecosystem starts building itself
slowly and steadily to avoid piggybacking on the react ecosystem.

Final point, I am back to working more towards what can be done with preact
instead. Doesn't mean the arrowjs utilities that were created in the meanwhile
would be abandoned.

That's all for now, adios!
