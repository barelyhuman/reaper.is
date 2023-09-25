---
title: Going bonkers over island architechture
date: 20/02/2023
published: true
---

If for some reason, you stalk my github, you'll see the past few days have been
just commits upon commits to a repo dealing with creating your own islands
architechture setup using existing tools instead of using a framework that does
it for you.

In most cases, I do suggest you setup something with
[astro](https://astro.build/) or [fresh](https://fresh.deno.dev/) cause they
already handle most edge cases and provide a better DX.

The point of building this though or spending any time of this project was to
just make sure there's at least one repo out there that teaches you how it all
works and ties together.

Currently when searching for an exaplanation on how to get islands working,
you'll most likely be redirected to
[Jason Miller - Islands Architecture](https://jasonformat.com/islands-architecture/)
which explains the concept but then there's no reference implementation, so for
someone who doesn't understand the basics of SSR, Partial Hydration or even
Hydration make no sense to them. For them, Astro and Fresh are doing something
revolutionary when in hindsight this has been the norm for devs working with
Ruby on Rails and Django with the exception that they selectively write what JS
loads on what page.

For most of us, that's too much work since we're used to Next.js / Astro /
SvelteKit / Remix / \<Insert another framework here\> , handling it for us. And
it's all good and great but then these frameworks are heavily dependent on what
their community decides for them and in most cases you end up with technical
debt just because upgrading is a problem. I've talked about this in a
[previous post](https://reaper.is/writing/20230207-decisions-and-updates-january-2023#preact-ssr)
and if I continue on this explanation, I'll most probably repeat everything I've
said in that post.

Anyway, it started as a tiny implementation of selectively deciding what chunks
of JS go to the client and I asked Jason Miller to review if that felt simple
enough as an implementation and he replied with a code snippet to avoid having
to manually mount islands.

This lead to creation of variants in the project repo, and each variant having 2
types.

1. Automatic
2. Manual

The **Automatic** utilises the provided code snippet with some modifications to
allow the user to just write `.island.js` files and it'll be converted to a web
component that automatically pulls the required chunk from the server.

The manual on the other hand requires you to specify what chunks to load and you
get more control over lazy loading a chunk vs sending it with the original
bundle.

Each has it's own advantages because too much lazy loading is also a thing.

In most cases you won't have to worry about "too much lazy loading" because the
generated files in the **Automatic** variants are only the ones that are
actually being used by the server. So if you have a component or island that
isn't being rendered anywhere then a chunk for it is never generated. Thanks for
the bundler for that, not something I've done.

Moving forward, there's currently 4 variants.

1. esbuild
2. webpack
3. esbuild-auto-inject
4. webpack-auto-inject

Each of the `*-auto-inject` one's are the **Automatic** types and the esbuild
version is slightly smaller in deps though the `esbuild-auto-inject` does add
quite a few deps due to esbuild not providing a way to modify the AST, I had to
add in a parser and transformer and they take are bigger than I'd like. I could
take the approach of using Regex's to do the replacements but then that's too
many cases to handle as compared to manipulating the AST directly.

## Still, why!?

Um, I don't actually get anything out of it. Other than maybe having a starter
that's easier to just pick and move forward with. I most already do this with my
go based services using alpinejs but that's more full hydration than partial but
then alpinejs itself is super tiny so I'm not that worried about the total
javascript on the page.

An example of this would be
[minit.barelyhuman.xyz](https://minit.barelyhuman.xyz/) which was written with
Go and AlpineJS.

So, overall, it still doesn't make any sense since ther other frameworks would
be putting in more effort maintaing their work and moving forward while doing
that.

This "moving forward" may align with your own goals but if it doesn't, you
basically are stuck. and I don't like that so it's easier to use tools that are
bound by a scope than one's that aren't.

Either way, hopefully this does help others, if not, no biggie, not like I'm
deleting the repos.

Here's the project the whole post is about.

### [barelyhuman/preact-islands-diy](https://github.com/barelyhuman/preact-islands-diy)

That's about it for now, Adios!
