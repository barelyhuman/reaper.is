---
title: On Node JS and REST API Frameworks
date: 16/01/2023
published: true
---

I've talked about how I like both REST and GraphQL as for me both of them are just an interface to expose functionality.

I've also ranted a bit about GraphQL not being a silver bullet to all your REST problems but either way, it's good to learn and it's definitely useful
and actually kinda faster to setup if you're working with the GraphQL DSL instead of Typescript.

The post is more towards me still being irritated about loopback 3 reaching EOL , it was such a well balanced framework. It's been 3+ years since then
and I'm still irritated but at this point I ended up replicating a lot of things that loopback provided.

Either way, as a programmer being irritated that something doesn't work the way you want it is never the solution, the solution is to fix whatever
isn't working and me being me I wrote a few set of libraries that kinda mimic things I liked about loopback.

This is all going to be a part of the http packages that I release over the course of the next few months. I could release them right now but then
they don't have a dedicated API style and I'm making mods to it while removing the chunk off of TillWhen's backend.

Features or stuff I wish to achieve.

- An app state handler all over the app
- Easy module injection, so no dependency injection is needed
- Ability to handle app boot state while being able to modify the datasources if needed
- Being able to generate a SDK from simple REST Templates for external API's
- Model Level Mixins

The **app state** thing is something most libraries and frameworks already provide so I'm going to reuse that from there.

**Module Injection** The point is to have all required functions, models, etc on the above app state handler so that you can access them from anywhere
in the application source code

This is basically verbose in the current version but I wish to add a graph like tree to avoid having circular deps break when app boots.

**Bootables**

These are functions that I wish to run on app boot to sync with external services or data sources or run migrations etc. and this is also something
that already works but is verbose as the whole thing is right now a part of TillWhen's rewrite.

**SDK**

The SDK generation is actually already a library [httpsdk](https://github.com/barelyhuman/httpsdk) and while it's not published to NPM it's a very
simple concept and obviously not HTTP spec compliant right now, but can handle the basic request body and request header sdk generation.

**Mixins**

More like datasource level metadata which was something I used a lot in loopback to be able to handle custom model properties.

Example, Let's say you wish to populate a field `computedField` based on the `normalField`'s value

```
  if normalField is 0 => computedField = `PENDING`
  if normalField is 1 => computedField = `PAID`
  if normalField is 2 => computedField = `COMPLETED`
```

The problem right now is that we will have to right a function that stores this information and then when fetching data from this table inject it. or
if your orm supports Load hooks then you add this there.

And yes, you can use ENUM's but then changing/modifying enum requires a whole another migration.

But, What if you have such fields all over the place because it's easier to use numbers instead of enums but you can't do this everywhere so this is
where a Mixin and Meta Property would come in place.

Let's say I define a `computedIdentifier` in the property definition for the model and then all models have the same function in the onLoad function
that loops up the `computedIdentifier` and matches the integer value to automatically map the string status.

This is someething you could do in loopback with the Model, and I can kind off achieve this with ObjectionJS but it's still not as seamless.

Being able to get these to work would require me to write an abstraction over knex and that's the complicated part that is stopping me from releasing
the http package and since TillWhen's been by place of toying with concepts, you'll have to wait till I'm done...

Oh, btw, this isn't something new. Fastify has a graph based plugin manager, and then there's also Hapi which has had this for years now. I'm just
making these since a few of them need to be coupled with the other and that isn't something I can do in the existing libraries or maybe I didn't go
through enough iterations with them to be able to achieve it.

This is basically what's going on right now, so hopefully I can finally have a cleaner more manageable backend for tillwhen compared to the initial
hacky codebase that I wrote the project in.
