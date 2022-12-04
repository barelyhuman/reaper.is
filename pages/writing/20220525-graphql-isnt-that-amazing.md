---
title: GraphQL isn't that amazing
published: true
date: 25/05/2022
---

I really didn't think it would come to having to explain this but people think
that GraphQL is the holy grail at this point and that REST isn't needed anymore.

I can just say "You're wrong" and let it be or I can get into a details and
bring sense to the standard. Let's do the 2nd one since I haven't ranted in a
while.

## Why does it exist?

> This is the specification for GraphQL, a query language and execution engine
> originally created at Facebook in 2012 for describing the capabilities and
> requirements of data models for client-server applications

Source: https://spec.graphql.org/October2021/

So, facebook needed a way to have the client and server be able to communicate
the data model. HTTP was still the protocol of communication so they were
limited to GET and POST requests but they wanted the client to be able to talk
to the server and explain itself better.

Here's what people imagine it to be.

##### Before GraphQL

**client**: `/users`  
**server**: Here's all the users, go bonkers  
**client**: Um, i also need the profile pics...  
**server**: the backend developer didn't add it in the response, sorry, make a
request to `/users/:id`

##### After GraphQL

**client**: `/graphql` => `query users { users {id name email} }`  
**server**: ...  
**client**: Um, i also need the profile pics... so
`query users { users {id name email profile_pic} }`  
**server**: ...

and honestly, I'd blame the blog posts that actually make it seem like this, but
just adding graphql doesn't just make it easier.

The above REST implementation would be considered bad talk to the backend dev
and get the field added? how hard is that?

The backend developer can still make the above fail by not including the
`profile_pic` in the attributes that I get from the db

And now, you get an empty string in the `profile_pic` everytime.

**BUT I CAN GET RELATIONAL DATA!!?**  
The backend developer still has to define the types for it and include it in the
response. The work for there hasn't been reduced, it has instead been increased
since the types are to be defined for it.

1. Define types for the response, and request
2. Define types for the relations
3. Define types for the models of the DB

I don't see any reduced time here

## So, Should we use it or not?

Well, every developer who's tested quite a few stacks would say, **it depends**.

But **depends** on what?

Here's a few things that graphql makes easier for a **backend** developer

1. Request Model Validation is done for you, since you define it for input.
2. Response fields are auto documented due to your types so you save time on
   internal documentation. (external documentation still needs work and
   honestly, I wouldn't want that automated)
3. In most implementations, you don't need to worry about routing anymore since
   it's all just one handler processing the DSL. If this sounds like RPC then
   don't be shocked, it did take inspiration.
4. Provides a way to also handle realtime setup because you get subscriptions
   support from most graphql engines

Now, let's get to the client side of things, or how the **frontend** developer's
job is made easier

1. Since model definitions are passed through the schema, you get type
   definitions that graphql clients can use to provide **typesafety** a.k.a
   browsing the documentation is reduced to just looking for exposed operations.
2. **Selective data**, but this isn't an immediate thing, you have to learn to
   write `fragments` . Thus, giving you the ability to include additional fields
   based on the screen/view/page you are working on. Just creating an SDK
   wrapper on top of all fields or selective fields doesn't really make any
   difference. You reduced the network load but increased the memory usage of
   the app which well, is not really an advantage.

**Eg**:

```
# this doesn't really make it any better
query users {
  users {
    id
    name
    addresses{
        id
        street
        state
        country{
            id
            name
            shortCode
        }
    }
  }
}


# you'll have to learn to divide them so that
# they can be composed so you can selective get
# the needed data

fragment UserFields on User {
  id
  name
}

fragment AddressFields on Address {
  id
  street
  state
}

fragment CountryFields on Country {
  id
  name
  shortCode
}

query userBaseDetails {
  users {
    ...UserFields
  }
}

query userDetails {
  users {
    ...UserFields
    addresses {
      ...AddressFields
      country {
        ...CountryFields
      }
    }
  }
}

```

and well, ideally I'd only create a query when it's needed more than once with
the same fields, else I just use the field fragments based on the view's
requirement.

Now, the client get's the exact amount of data that it needs on that exact view
while still being able to scale.

Creating a single query with all fields being used everywhere basically feels
like REST that was written on the frontend, beats the whole argument of
_"fetching only what's needed"_

Fragment writing can be a pain and redundant so shameless plug but you can use
[gqlfragments](https://github.com/barelyhuman/gqlfragments) to generate them for
you.

3. The 3rd advantage is not having to deal with url suffixes, and this is both
   an advantage and disadvantage. **Advantage**, when it comes to the
   development of the app as it reduces the amount of code you write for network
   requests and **disadvantage** when you have to go through 100 `/graphql`
   requests in the network tab to find out which one is that's making an invalid
   data call and then look for the operation that it was passing, can get quite
   irritating

There's a few more but none that actually make any big difference.

## Better than REST?

Uh... in a way, yes.

But most of what's above can be done in REST

1. Selective fields? Easily implemented with middlewares
2. Model validation? There's tons of library for that
3. Url suffixes? OpenAPI / swagger => sdk generator. Done.
4. Type Safety? If you are working with a language that's statically typed, this
   shouldn't be hard to do. JS has trpc which does this with shared types and
   reflections.You can just have a `types` package in your modern monorepo to do
   it for you.

I've left realtime setup, because I'm sure there's enough websocket information
online.

You'll have to add routing for REST which is definitely redundant but it's okay,
you can spend 10 extra seconds to define a route definition.

**BUT THAT'S SO MUCH WORK!?** True, REST implementations require quite a bit of
setup to get everything working but so does GraphQL. If it's just about how much
time it'd take to start a http server that can respond to a `/ping` request.

I'm sure you can imagine that a simple http REST server would take me 30 seconds
and graphql would need a little more than 2-3 mins when typed out.

```js
const express = require("express");

const app = express();

app.get("/ping", (req, res) => {
  res.send("pong");
});

app.listen(3000, () => {
  console.log("listening");
});
```

Okay, took 43 seconds...

let's try go lang

```go
package main

import (
    "fmt"
    "net/http"
)

func main(){
    http.HandleFunc("/ping",func (w http.ResponseWriter, req *http.Request){
        fmt.Fprintf(w,"pong")
    })
    http.ListenAndServe(":3000",nil)
}
```

about a 1min

You're telling me, you'll be able to define a resolver, define it's return type,
add in the graphql engine imports, implement the resolver and the processor then
add in the http server that reads the request, passes it to graphql in the same
time? Nope. Not happening.

Anyway, not here to bash GraphQL. wanted to clarify what the advantages are, and
cleary the above 2 examples are just jokes. I'd have to write much more code to
get the same features that the graphql engine would give me.

1. Validation
2. Doc generation
3. Playground etc, etc

so **yes**, the time spent to setup GraphlQL is worth it, it is better than any
simplistic REST implementation but **no** there's no winner here, it's a usecase
thing.

_It depends_ on how much work you're willing to put up for the setup. I did
write about the amount of work it took to find a decent GraphQL working solution
for work, which you can read about.
[Full Stack Development with GraphQL in a Digital Studio ](/writing/20220509-graphql-in-digital-studios)

REST is easier to iterate over, without breaking the entire engine and you can
find mature sets of tools to help that backend be more stable and making an
argument that "the client decides the response" is an advantage? Dude, the
backend developer can still change the response type definition and you are done
for. You need to collaborate to get the app out, just one of you aren't working
on it.

To other writers, stop using bad REST API implementations as examples for moving
into GraphQL, I can write bad GraphQL API's as well
