---
title: Solution to multiple connections with knex while using Next.js
date: 2020-05-29 22:14:18
published: true
---

### The Issue

Using next.js has it's own advantages and not going to go through them in this
post but one major blockage while building
[TillWhen](https://tillwhen.barelyhuman.dev) was the number of Database
connection each api request was creating. Initially I thought it was just
because of the constant restarts of the server I was making that lead to the 30+
connections but I remember setting PG to disregard idle connections after a
minute.

Anyway, soon It was obvious that the knex connections I created weren't getting
destroyed and there was a new connection every time I made a request.

Now even though thins could be easily solved for `mysql` using
`serverless-mysql` which manages the connections based of serverless
environments, and I could even use the `pg` version of the above,
`serverless-pg` but, we already had the whole apps built with knex.js and I
didn't wanna rewrite every query again so had to find a better way.

I had 2 solutions at this point.

- Memoize the connection.
- Destroy the connection on request end.

### Solution #1 - Memoize

Now, I assume that you have one file that you maintain the knex instance in, if
not, then you are going to have to do a lot of refactoring.

Let's get to creating a knex instance but with a simple variable that will store
the connection instance so on the next request, the same is sent back to the
handler using the db instance.

`utils/db-injector.js`

```js
const dbConfig = require("knexfile");
const knex = require("knex");

let cachedConnection;

export const getDatabaseConnector = () => {
  if (cachedConnection) {
    console.log("Cached Connection");
    return cachedConnection;
  }
  const configByEnvironment = dbConfig[process.env.NODE_ENV || "development"];

  if (!configByEnvironment) {
    throw new Error(
      `Failed to get knex configuration for env:${process.env.NODE_ENV}`
    );
  }
  console.log("New Connection");
  const connection = knex(configByEnvironment);
  cachedConnection = connection;
  return connection;
};
```

We now have a variable `cachedConnection` that either has an instance, if not, a
new one is created and is referred to by it. Now let's see how you would use
this in the request handlers.

`controllers/user.js`

```js
const db = require("utils/db-injector");

controller.fetchUser = async (req, res) => {
  try {
    const data = db()("users").where();
    return res.status(200).send(data[0]);
  } catch (err) {
    console.error(err);
    throw err;
  }
};
```

At this point you are almost always getting a cached connection, I say almost
always because the actual `utils/db-injector.js` might get reinit by next.js and
you will have a connection that still hanging out with knex for longer than
intented. This isn't much of an issue but if you are like me who doesn't want
this to exist either, let's get to the second solution.

### Solution #2 - Destroy!

Yeah, we mercilessly destroy the connection with the database after each request
to make sure that there's always only one connection per request, the peak of
optimization! Which should've been handled by knex but let's not blame knex!

Anyway, the 2nd solution required a simple higher-order function that would

- take in the request handler
- give it a connection instance
- wait for it to complete the request
- destroy the connection

we start by modifying the `db-injector` to create a new instance everytime
instead of caching because the cached instance won't exist anymore and will give
you a unusable knex connection or no connection at all. Let's do that first.

`utils/db-injector.js`

```js
const dbConfig = require("knexfile");
const knex = require("knex");

let connection;

export const getDatabaseConnector = () => {
  return () => {
    const configByEnvironment = dbConfig[process.env.NODE_ENV || "development"];
    if (!configByEnvironment) {
      throw new Error(
        `Failed to get knex configuration for env:${process.env.NODE_ENV}`
      );
    }
    connection = knex(configByEnvironment);
    return connection;
  };
};
```

We now have a new connection on every request, let's write the higher-order
function so it can destroy the connection and let the DB of the connection
misery.

The higher-order function as said, is going to be very simple, it's just taking
in the handler , waiting for it to complete the request and then we destroy it.

`connection-handler.js`

```js
import { getDatabaseConnector } from "utils/db-injector";
const connector = getDatabaseConnector();

export default (...args) => {
  return (fn) => async (req, res) => {
    req.db = connector();
    await fn(req, res);
    await req.db.destroy();
  };
};
```

Why do I pass in `req.db`?, reason being that if the handler keeps importing the
db , the higher-order function has no way to destroy the exact instance, and
hence we init the db instance and destroy the instance here. It's a simple form
of self-cleaning.

`pages/api/user/index.js`

```js
import connectionHandler from "connection-handler";

const handler = async (req, res) => {
  try {
    if (req.method === "GET") {
      const { currentUser } = req;
      const data = await req
        .db("users")
        .leftJoin("profiles as profile", "users.id", "profile.user_id")
        .where("users.id", currentUser.id)
        .select(
          "profile.name as profileName",
          "profile.id as profileId",
          "users.id ",
          "users.email"
        );
      return Response(200, data[0], res);
    } else {
      return res.status(404).end();
    }
  } catch (err) {
    return res.status(500).send({ error: "Oops! Something went wrong!" });
  }
};

export default connectionHandler()(handler);
```

And finally, I'm showing a generic Next.js handler here instead of the full
fledged controller like in the example above, since the higher-order function is
going to be added in here and not in the controllers. So the only modification
you'll have to do to all the route handlers is , instead of exporting the
handlers directly, export a version wrapped in a higher-order function.
