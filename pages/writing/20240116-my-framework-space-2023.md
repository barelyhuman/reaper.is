---
title: My Framework Space 2023 - 2024
date: 16/01/2024
published: true
---

What is the one thing that the web dev worlds has too much of? **Frameworks**.

It's basically `(n+1)-d` number of frameworks. `d` represents the humans who
have mixed opinios thus reducing count and `n` is the original number of
opinions. It'd be worthless to spend time finding an answer to that expression.

Anyway, everyone seems to have a favorite framework and meta-framework so let's
get to the one's I use/wrote.

### Base

Contrary to my work in Javascript a lot of my webapps start with a simple
`main.go` file serving a directory of html,js,css files. I add api's to the go
server and use them in the above mentioned html as needed.

This is what I call, **Base**. It's a very simple setup and can be created in
under a minute. The client side code can be embedded into the resulting go
binary and it's easy to deploy and use on pretty much any straightforward server
today.

The reason for it's existence is simple, not to get too involved into what the
right tech is supposed to be when I'm testing an Idea. This is what
[minweb.site](https://minweb.site) was initial built on.

### DIY Boilers

I've got a few of these and most of them are experiments or evaluations of the
various tech available in the full stack web dev space. They are simple
nodejs/go/nim lang projects that have the frameworks source code placed into the
repository itself.

This allows me to avoid generalisation and build the DIY Framework to be very
specific to what's available in the actual project folder. It also makes it
simpler for the user of this framework to change and improve the whole thing
while working on the actual project without having to wait for me to add the
improvements to the original repository.

I use these at Fountane while working and a lot of these have changed over time
based on requirements, so much so, that it's hard to even compare them to the
original source.

### Nomen

This is something I've been working on and ties with the concept of keeping the
mental model very simple and tied to the NodeJS javascript.

It exists because a lot of what we do today is tied to bundlers and magical
setups. A few established frameworks that come into the it's just "magic" would
be Nuxt.js, Next.js and Astro from the list of things I use.

There is no problem using them since the teams behind them are very dedicated
and love what they do but, a lot of issues that i've faced while working with
them is the need for a shift in the mental model when working with them.

**Eg:**

You're used to a setup where the database connection is shared by defining a
file like the following

```js
export const db = connectToDb(dbConnectionConfig)
```

And now you are using this connection in the different server functions provided
by let's say nuxt, next, astro, qwik, etc.

Each one of them have a different targetted build. I've used next too much, so
I'll go with the un-needed problems I had to solve.

In Next.js this connection is not shared, it's impossible for it to be shared
both in development and in production. So much so that I had to write a post
since it was so commonly asked around in their discussions.

- [Solution to multiple connections with knex while using Next.js](/writing/nextjs-pg-knexjs)

Another solution availabe today is provided by the prisma docs since a lot of
people started using prisma with Next.js

- [Prisma Client Best Practices](https://www.prisma.io/docs/orm/more/help-and-troubleshooting/help-articles/nextjs-prisma-client-dev-practices#solution)

Now they clame that it doesn't need to be used in production but then I've had
the same error in production since the initialisation of API functions are still
done in the same way a lambda would execute. This is faked in a local server and
in realtime if you deploy to Vercel.

Tiny nitpick, I know but you loose you basic nodejs server mental model. This
changes for how Nuxt.js works and also for how Astro works (depending on
Adapters)

A few more such setups led to people using existing services for everying. You
need cron jobs? Use a cron job service. You need to do delayed triggers, Use a
webhook service.

Things that are pretty trivial to write need you to pay for services and that's
fine if you like working that way. It just doesn't work for me.

Hence, Nomen. It's still a nodejs server, it's the same server you'd write
without the bundlers but you can write client side code for a few supported UI's
and it'd work the way a normal nodejs server would. We try to not modify any
paths or add in any magic.

### Adex

Probably hypocritical after that tiny rant up there but Adex uses vite's magical
environment to provide a simple way to write
[ArrowJS](https://www.arrow-js.com/) apps. I needed something that was quick to
write with and still end up with a close to NodeJS setup. I was able to achieve
that with a custom plugin I wrote for Vite and then that turned into what's now
called Adex.

#### What happened to all that magic talk?

Adex is an open ended setup, you can change the entire running, request handling
and rendering of it by just adding your own custom entry files. So, it's more a
meta-meta-framework than a meta-framework.

But, it defaults to the ArrowJS libraries so you can say that it defaults to
magic and then you can remove it if needed.

As for why add a bundler ? It's mostly because of the existing integrations
available for Vite. Tailwind, UnoCSS, UnImport and other amazing DX improvements
that Vite already has and that'd take nomen a bit more time to establish. I need
people to like ArrowJS before Nomen comes with it being the default rendering
engine

ArrowJS is one of the few libraries that don't need a bundler since there's no
JSX to transform, you can use just typescript to transpile and go ahead with it
and that's what nomen does with it's `arrow` module.

I guess, I wanted to try out what Vite could do and I ended up building it.

Both, nomen and adex are still under development with Adex receiving a little
more effort right now since I need to understand and modify the Vite plugins
quiet a bit to make sure I don't add / remove too much of the users code.

Both of them are also written in a way that you don't need to write API's for
route data loading similar to how you'd do it in remix, except remix does create
a fetch request and these both pass that data as JSON to the client similar to
Next.js

Basically, I picked things that made sense from whatever I've used and built a
monstrosity that I like.

That's all the stuff I use right now, I sometimes still pick up Astro when I
don't feel like dealing with the bugs I need to fix in Adex and Nomen but we
circle back to fixing them anyway since it's important in the longer run.
