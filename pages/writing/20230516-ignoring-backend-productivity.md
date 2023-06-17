---
title: Ignoring Backend Productivity in JS
published: true
date: 17/06/2023
---

This isn't a rant but more on the lines of the thing I'm struggling with.

I've had quite a few rant posts about backend development and issues with
consistency with existing tech in Javascript.

Most of them do no involve "Full Stack Frameworks" but more make shift solutions
that I've built and libraries that were build around them.

Here's the list of posts, if you wish to go through the rants.

- [GraphQL isn't that amazing]({{.Meta.BaseURL}}writing/20220525-graphql-isnt-that-amazing)
- [On Node JS and REST API Frameworks]({{.Meta.BaseURL}}writing/20230116-on-javascript-rest-apis)
- [Full Stack Development with GraphQL in a Digital Studio]({{.Meta.BaseURL}}writing/20220509-graphql-in-digital-studios)
- [Should you use Hasura?]({{.Meta.BaseURL}}writing/should-you-use-hasura)

A common sequence of events is that companies and everyone wants to build their
own frameworks to be able to make apps and this has lead to a bunch of amazing
products.

I'm also guilty of this since I've at least had 20 iterations of how I could
handle dependency injection in backend apps. Wrote my own router implementations
and resource wrapper implementations

All of this is great and good but often I forget that not everything needs to be
published out in the open. This habit of mine has lead to a problem where I
can't be productive anymore when I'm doing any app's backend.

I start with writing the database schema, I get to the part where I need to
write the functionality and then get stuck on building wrappers and abstractions
for things that don't need abstractions.

This definitely helps since I build tools for the open source world but it
removes any chances of building a web app / SaSS for me. I start writing code
for the SaSS and the next moment I have another abstraction over knex to

- create a simpler ActiveRecord pattern in JS
- create a mongoose like API on top of knex
- create another Objection.js but with better models (in my opinion)
- idk, i'm made a few more random one's as well

That's not the only place I fuck up though. I've build engine and module loading
systems. This did lead to a library called
[typeable](github.com/barelyhuman/typeable) which generates types for a dynamic
object for serializable and native types. Which is nice for any usecases that
others might have but the App engine was built for a modification of Taco's
backend core and I never completed that PR.

The users of libraries that I build are probably in single digits, but still if
they do help them it's nice. Cause they clearly aren't helping me since there's
a new idea and way to solve that issue in my head every other day.

## How do we solve it?

I'm not sure, I'm looking for answers myself, one such answer would be to use
something like Adonis/Sails and while they'd help there's still things that
bother me in both and i'll end up creating helpers libraries again.
