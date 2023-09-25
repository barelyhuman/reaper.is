---
title: Iterative GraphQL
date: 01/07/2022
---

I wrote a post talking about actual pros and cons of using GraphQL in a post
before

- [GraphQL isn't that amazing](http://reaper.is/writing/20220525-graphql-isnt-that-amazing)

This was primarily for people just walking around social media throwing it
around like they did for typescript.

**Just installing a new tool doesn't solve problems!** , it might mitigate it a
bit but it doesn't solve the inherent problem of you not using it properly.

I could go on this rant, or I can talk about the actual topic.

As always, I was stalking github repositories for learning stuff and github
explore actually kept showing repo's from [the-guild.dev](http://the-guild.dev)
and since I'd already gone through most of their tools I kept skipping but then
I didn't find anything interesting so I did end up at their site again.

Apparently, **I did** miss a library. It's named GraphQL Yoga and this is one of
the few libraries that is functionally minimalistic.

Stuff that it has covered for you

1. Setting up a graphql server
2. Works with [envelop.dev](http://envelop.dev) plugins by default
3. DSL first - which, most of them are and most people just prefer the
   graphql-js approach (type-graphql or graphql pothos) which adds the
   modularisation of code easier but still complicated cause the same could be
   written in the DSL in one line (anyway, personal preference so can't
   complain.)

#### You actually like a graphql library now?

I've never hated graphql, it's fun, handles most of the boilerplate code but
then I wouldn't say it's a all out solution to all problems that you face with
REST.

and I've talked about this in the
[previous post about GraphQL](http://reaper.is/writing/20220525-graphql-isnt-that-amazing),
so you can read that there. The same goes for typescript, I use it where it
would be a better choice, more about this in a future post.

### GraphQL Yoga

This section is more about how the DSL can actually be quite easy to use and
allows you to iterate faster.

so here's what a simple ping query would look like in the graphql dsl

```
type Query{
    ping: String
}
```

and that's it, you have a graphql schema done.

**Yeah, we aren't kids, we know how the DSL works** Then why not use it!?

Moving forward. The next this is to get the DSL executable so it could link to
programmatic resolvers.

This can be done in all graphql server libraries out there, instead of
buildSchema you can just pass in the schema file to the server creation
instance.

I'm going to go through doing this with Yoga cause it's my blog.

```js
import { createServer } from '@graphql-yoga/node'

const server = createServer({
  schema: {
    typeDefs: `
      type Query {
        ping: String
      }
    `,
    resolvers: {
      Query: {
        ping: () => 'pong',
      },
    },
  },
})

server.start()
```

That would take about 30-45 seconds to write and so graphql ping in 30 seconds
(a facepalm for the younger me who said it couldn't be possible.)

The example is pretty much self explanatory but let's see how we can extend
this.

#### Auth

A very basic use case is going to be authentication and passing around
`context`.

This isn't very different from other graphql server implementations but here's
the additions you'd do

```diff
import { createServer } from "@graphql-yoga/node";
+ import { useGenericAuth } from '@envelop/generic-auth';

const server = createServer({
  schema: {
    typeDefs: `
      type Query {
-        ping: String
+        ping: String @skipAuth
+        privatePing: String @auth
      }
    `,
    resolvers: {
      Query: {
        ping: () => "pong",
+        privatePing: () => "another pong",
      },
    },
+   plugins:[useGenericAuth({
+      resolveUserFn,
+      validateUser,
+      mode: 'protect-granular',
+    })]
  },
});

server.start();
```

and now you have granular control over what needs authentication and what
doesn't.

You can also use graphql-shield to add authorization controls but I'd prefer
writing my own as helpers and use them in the resolver since more often than not
I do need the resolved data to find if the requestor should have access to it.

#### Why is this iterative?

1. Reduced time to get typescript decorators to get working. (type reflection
   isn't always perfect)
2. It's now just a function invocation so I can add more composable stuff than
   having to depend on the structure of a library (ex: class types from
   type-graphql)

overall more time spent writing logic than getting the tooling working, which is
what we've been trying to do all this time , right?

But, but but!

#### It's not all amazing

You obviously saw this coming.

1. You still need to define input and output types which are rather easy to do
   since it's all in one `.graphql` file that you can read through to find the
   types.
2. The context switch is a little more but manageable. You move between 2-3
   files at any given point to write a resolver, import it , and define it in
   the `schema.gql` file. This would be just 1-2 files when working with
   something like type-graphql since you'd already have most of the stuff
   autocompleted for you.

Though, in my opinion these can be easily made a little more easier by adding
typescript just for autocompleting the function definitions.

That's about it for this post. Adios!
