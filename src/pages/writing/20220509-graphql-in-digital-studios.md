---
layout: ../../layouts/Page.astro
title: Full Stack Development with GraphQL in a Digital Studio
date: 09/05/2022
published: true
---

GraphQL is what people are building on, a lot right now.
The advantages on a higher level are the one's below

1. Concise client decided payloads
2. No route and parameter handling
3. Faster responses since it's accessing a graph instead of a regex matching algorithm
4. Type-safety

and a few more that you can find

I agree with each of the above and these would make a serious difference if writing REST wasn't easy and I'm talking about REST backends that some senior developer didn't decide to make complex for you. Because, trust me, I can make it very hard to even write REST API's

So, how did I actually make GraphQL a little more worthy and easy to write in for a Digital Studio that deals with quite a few projects in parallel

## Context

To bring you up to speed, I work with a creative/digital studio that helps with creating UI/UX mockups and if you feel like it , the functional app based on them as well.

Now, this business works because people need apps and not everyone can find a development team easily and we already have one so we solve the technical side of things for you.

Considering the rise in apps and demand for more web based products, we deal with quite a few clients. We have no option but to make it very easy for us to create API's in seconds. I wouldn't go all the way into No Code Environment cause my control complex isn't that easy to subdue

Also the reason why Loopback 3 was the base of all my projects, amazing mixins and middlewares. Ability to handle file uploads and signedURL fetching using those same mixins, while keeping all logic modifiable in case the requirements change.

Loopback 3 had it's EOL a few years back.

Now to replicate a few set of the same features, I did write a few internal tools that'd work with express to handle the same things but CRUD generation tied to me a single ORM and I wanted a more quick approach, at least for crud generation.

The following is basically how the current setup looks like for us, and it's pros and cons.

## The CRUD Advantage

The first framework of choice was Hasura

Hasura gave the following advantages

- Auto generated CRUD
- A great db definition website portal
- Ability to autogenerate migrations by using the Hasura CLI's proxy connection
- Handling permissions to limit the access type based on custom user roles.

All this was good for most applications that we were building but that's all we had hasura for. For anything that needed business logic we had 2 options

1. Use the hasura webhooks to use a single interface for handling the request and response
2. Writing a simple REST Service for the custom business logic

We went with the fist approach to be able to scale to a good micro service arch and using hasura as the API gateway for that arch.

This went poorly cause of the limitations of Hasura's Request types at that point of time where the JSON and String primitives were used by us often when we were dealing with a huge nested output that was already typed in hasura and had to be retyped when writing the REST service. This added to the development time and after a while we were just using the JSON primitive where possible

The 2nd approach is something that we are using right now and it's a lot simpler in terms of handling but since the database for hasura is also containerized in our setup, we had to do a few hacks to be able to use the same database url when developing.

Now, this whole advantage itself is limited to a few frameworks but due to the nature of graphql being defined with types, it makes it easier to write generators for it.

Which is something you can get most ORM's to do, by handling the type reflections of the data model for it.

Another example for this is [Prisma](https://www.prisma.io/) + [TypeGraphQL](http://typegraphql.com/) + [TypeGraphql Generator for Primsa](https://prisma.typegraphql.com/)

And so, we started moving away from Hasura and creating something similar using existing tools and writing generators where needed.

## Streamlining Developer Experience

The second part of working with loopback 3 was the fact that a junior dev never really had to worry about handling any of the mixins, or any middleware that was setup. Their work was limited to writing business logic and in some cases writing replication engines for analytical usecases.

Now this wasn't something that was because of loopback 3 but because the entire setup was that well built. Anything that doesn't need to be taught or told about was handled by the setup and maintained by one of the senior guys or juniors who got curious and tried to understand the setup.

1. Generate SDK? Don't worry, I'll do it for you.
2. Update Database to sync with your model changes? Done
3. You mentioned a relation with the files table? here's your signed url in the response
4. Using Dynamic Enums? Here's what the enum points to

All this handling is done using model mixins and the boot scripts of loopback.

Getting a similar experience with existing tools would need a hacky approach but let's go through how that was handled.

### Boot Scripts

Most boot scripts were also defined in `package.json` because I needed to run them separately in certain cases.

```json
{
  "scripts": {
    "boot:models": "ts-node boot/models.ts"
  }
}
```

Next, there's a `boot/index.ts` file that is basically a `npm-run-all` script that runs all the npm scripts that had the prefix `boot:`

```ts
const runner = require('npm-run-all')

const commands = [
  {
    label: 'Running Boot Scripts',
    cmd: 'boot:*',
  },
  {
    label: 'Starting Server',
    cmd: 'start',
  },
]

const info = (msg: string) => `\x1B[36m${msg}\x1B[0m`
const success = (msg: string) => `\x1B[32m${msg}\x1B[0m`

console.log(
  success('> Running in parallel:\n    ')
    + info(commands.map(x => `>> ${x.label.trim()}`).join('\n    '))
)
runner(
  commands.map(x => x.cmd),
  {
    parallel: false,
    stdout: process.stdout,
    stderr: process.stderr,
  }
)
```

To simplify, everytime the server starts, I have the models re-generated for prisma, generators of dynamic enums and files were executed. There's more stuff, but that's very specific to the usecase

### Dynamic Enums

The need for dynamic enum types / app layer enums, are to avoid having to write migrations for every enum change that you make. Which involves having the migration handle deletion and recreation of the enum. These are better done in transactions and I wanted to avoid
doing this altogether.

We call these as `Options` or `Constants` and these were handled via Model mixins in loopback 3.

The flow would be something like this

We'd defined options like so

```js
const options = {
  TRANSACTIONSTATUS: {
    paid: {
      value: 1,
      label: 'Paid',
    },
    pending: {
      value: 2,
      label: 'Pending',
    },
  },
}
```

`TRANSACTIONSTATUS` is the grouping identifier, `paid` would be the enum accessor and `value` is what will be the saved in the DB against the field, in this case `transaction_status`.

So, if I had an order with the `transaction_status` as 1, then that basically means it's paid. Now mixins were used to provide the client side with the label that it's supposed to show.

The mixin would run before the model was accessed and add an additional field in the response.

It'd look for fields mapped with `Options` and use the identifier `TRANSACTIONSTATUS` (defined in the model definition) to match the value and return a new property in the response.

```json
{
  "transaction_status": 1,
  "transaction_status_label": "Paid"
}
```

These can be implemented in GraphQL using field resolvers, which you can either manually write for every option mapping or by writing generators for it using `ts-morph` or something similar and added to the boot-scripts.

The boot script would do the following things.

1. Generate a field resolver class for every entity in option mappings.
2. Add imports for these resolvers in the graphql schema entry point. (depends on how you process your graphql requests)

The mapping and option definitions are defined in a single file to avoid having to change context for something so simple. It looks like this.

```js
export const options = {
  TRANSACTIONSTATUS: {
    paid: {
      value: 1,
      label: 'Paid',
    },
    pending: {
      value: 2,
      label: 'Pending',
    },
  },
}

export const optionMappings = {
  entity: 'Order',
  mappings: [
    {
      identifier: 'TRANSACTIONSTATUS',
      field: 'transaction_status',
    },
  ],
}
```

And the generator scripts goes through both the values to create the field resolvers

### Automatic File URL's

Handling files is no different than the above options/constants table, the difference is the source of data for the field resolvers.

Instead of using a file for the definitions, it uses the database's table data and `services/storage.ts` file to get a signed url of the file that's in the `files` table.

1. Check if the property belongs to the `files` table
2. Then generate a field resolver for that entity's properties that are connected to files.
3. The field resolver get's the signed url using that relational data and adds a field with the suffix `_asset_url` to it.

So eg:

```
----
User Model
----
profile_pic 12


----
Files
----
id  12
path  /path/to/object
```

Once the generator runs it allows the graphql client to fetch the following properties

```graphql
{
  profile_pic # 12
  profile_pic_asset_url # https://s3.signed.object.url/
}
```

Now, most people use a polymorphic schema for files and that actually makes it easier to handle files but since Node doesn't have an ORM that can automatically handle polymorphic relations, the field resolver approach is what works for us and easier to reason about.

The 2 scripts, options resolver and files resolver, each make sure to not create a new resolver for the same entity. It'll look for the entity's resolver and add these field resolver code to it. If it doesn't exist, one of them will create it.

Eg: `Users.ts` is already generated by type-graphql + prisma generator, so anything extra is added in `UsersExtended.ts` , which is what the generators will look for

### SDK Generation

This was the most hacky part of all. Since, loopback 3 came with it's own SDK generation utility.
we on the other hand, would have to create this manually to work in a similar fashion.

1. Setup URQL in core mode.
2. Use graphql-codegen to generate a generic set of utilities using graphql document definitions
3. Write a [graphql requestor module](https://github.com/barelyhuman/urql-generic-requester) for the above generated graphql request function
4. Move this to a separate package in the repo to make sure it generates the sdk again as soon as the documents change (since this is supposed to be re-used into other clients that might come up in the future, like a mobile app)

The file tree for this looks something like this

```sh
-| server
-| shared
---| sdk /
----| generated /
-------| codegen.ts
----| documents /
-------| order.graphql
----| index.ts
-| client
```

This `shared` folder has it's own scripts but these are triggered by the `client` folder as soon as you start the dev server, it starts the watcher for the `documents/*.graphql` files and regenerates the `codegen.ts` file everytime it changes, thus giving the client a tRPC like setup as soon as they add a new document.

Obviously, tRPC doesn't need the client to do this modification but in our case that's the added redundant work (will find a solution for it as well)

# Pros of this setup

- Lesser context switching for a Full Stack developer
- Full fledged local backend and frontend setup for all developers, which drops the need for a dev server and you just need a staging server that replicates data from production for you to debug issues you face with actual user data.
- More like pro from using [Prisma](https://prisma.io), that gives us less migration files and just push to the DB when working on an unconfirmed requirement
- Full fledged graphql, unlike hasura you don't need to setup more services to handle responses, it's all in one, if needed you can create REST requests for other stuff as well, while having it on the same codebase
- Most of it can be modified to match your usecase since it isn't an abstracted framework, the only parts that are dependent on others is the graphql request translation engines(Apollo, Helix, etc),the ORM, and the frontend framework. Which can be replaced but the joining piece is Prisma and that's something I'd like to change but I'll loose my CRUD generation.

# Cons of this setup

- Hacky and needs a maintainer to know what the setup is built on, to be able to fix anything related to the custom generators
- A frontend developer will have to dive a bit into the backend to handle db updates and seeding of data
- The backend developer has to rethink of how they write schema to match with the generator's standard, which means you'll have to set a standard procedure of writing and designing to make sure implementing features doesn't add much friction
- Obviously has a lot of work for the initial setup. (boilerplate for this will be made available publicly soon)
- Tightly coupled to Prisma for CRUD generation, though if you don't need CRUD, you can get rid of that dependency as well and use
  something like knex.js
