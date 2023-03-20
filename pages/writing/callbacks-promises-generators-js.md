---
title: Callbacks, Promises, Generators and Why a JS Developer needs to understand them.
date: 2020-09-01
published: true
---

I've had my fair share of up and downs with Javascript and it always is frustrating when the language you've been using for a while doesn't behave the
way you assumed it would but I continued using JS for almost everything I built over the past 2-3 years.

## Why Javascript?

I'm not biased towards the language, I would like to get back to being a C developer or maybe be a little modern and be a Go/Rust Developer but as I
mentioned in my previous post, I've been a little bitch about it and keep running back to JS for moral support.

But, I still think that learning JS is a valuable skill. Learning any programming language at this point is.

We though are going to go with JS to start because I can explain stuff about it a little more than I can explain C, Go, or Rust.

## It all Started with him... the dreaded one

**Callbacks**

Veterans love them, newbies fear them and others have no idea what's going on.

The thing about callbacks is that we are all using them in almost every JS codebase and still fail to realize that we are.

Anyway, getting to the basics.

### What are they?

It's a function. A function trapped inside another one to be precise but it's still a function so let's treat them like one.

```js
function functionOne(callbackFunction) {
  const a = 1
  callbackFunction(a)
}

function functionTwo(num) {
  console.log(num)
}

// Variation One
functionOne(value => {
  functionTwo(value)
})

// Variation Two
functionOne(functionTwo)
```

Now, before I explain the above, I'm assuming you understand that functions in JS aren't considered different than general parameters and thus, you
can pass them down to other functions.

This is also allowed in other languages as well so should not come as a surprise anymore to people who've been jumping languages or to people who've
been dealing with JS a lot.

Let's go through the code snippet now.

We've got 2 functions to start with `functionOne` and `functionTwo`, `functionOne` takes in a parameter called `callbackFunction` which could be
anything, a `string` a `number` or even a `boolean` or an `object/array` for that matter, but I'm going to keep it simple for us to understand and not
add type checks at this point (which you should add if you are writing in just JS, ignore if you use TypeScript).

`functionTwo` on the other hand has the same parameter signature or accepts the same number of arguments as `functionOne`.

If we now look at the inner code of these two we see that one declares a variable `a` and executed `callbackFunction` and passed in that value (again,
`functionOne` assumes that `callbackFunction` is going to come in as a function and so blindly executes it.

`functionTwo`'s inner code is logging the passed parameter to the console/stdout(depending on where you are executing this snippet).

#### Execution

After the declarations we have 2 variations for the execution of our functions, one being a little verbose and the 2nd being my definition of
`readable` code.

1. The first variation basically calls `functionOne` and passes it another function as a parameter which is called an `anonymous` function (guess why)
   and this anonymous function surprisingly has a `value` parameter, we didn't declare it, so how does it get it? `functionOne` passes it to anonymous
   function when we made the `callbackFunction(a)` and `callbackFunction` is now pointing to our anonymous function because this is what we passed as
   a parameter and then we just call our `functionTwo` and pass it the received value.

2. The second variation is used when there's only one function that needs to be executed with the incoming value from `functionOne`, you should still
   go with Variation one if you're going to use the value more than once. Now this works because we are still passing `functionOne` a
   `callbackFunction` which takes in one value and similar to the 1st variation, it accepts the value and runs its logic with it.

You can copy the above code and run it on any JS playground and you should see that the number `1` is printed twice.

### Why use Callbacks?

As I said, you're using them everywhere in JS without realizing that you are but, as to why use them? It's a very simple answer.

**Scoped Data Access**

If you've not gone through the internals of JS this might be a little hard for me to explain but I'll give it a try.

Like most languages, you have data scopes that are maintained by the interpreter or compiler which is why you can access variables only under certain
conditions.

If you go back to the above example, you can see that `var a = 1` is defined inside `functionOne` and thus can only be used by `functionOne`'s scope
or by code that is inside `functionOne` but what do you do if you want that data to be accessible to other functions because if you write everything
inside one function, then it beats the point of having functions and or thinking about creating modules altogether.

This is where callbacks excel and this is why JS is very async friendly.

`async` - asynchronous programming, I'll explain this in detail in another post.

When you write code with async programming in mind, the chances of you blocking the execution thread is very low, unless you hit a deadlock between
two callbacks calling each other or you forgot to break a loop.

So if we go back to our example, we see that `a` is passed to `functionTwo` from `functionOne`'s scope and then `functionTwo` just prints its. That is
a very naive example and in real-life code, callbacks aren't that clean and easy to read.

If dealing with dependant data and working with data from the network, you'll probably see your code go south like this.

```js
function dataFetch() {
  const data = someNetworkRequest()
  formatFetchedData(data, (err, formattedData) => {
    if (err) {
      console.error(err)
      return err
    }

    processFormattedData(formattedData, (err, processingResult) => {
      if (err) {
        console.error(err)
        return err
      }

      sendResultBackToServer(processingResult, (_err_, serverResult) => {
        // let's end this with a console.log
        console.log(serverResult)
      })
    })
  })
}

function formatFetchedData(param, callback) {
  // relevant code
}

function processFormattedData(param, callback) {
  // relevant code
}

function sendResultBackToServer(param, callback) {
  // relevant code
}

dataFetch()
```

A 3 level callback dependency can be readable but obviously, a complex app won't stop at 3 and while I could write something cleaner with an async
chaining utility, a very famous one is `async.js` and we could use it's `waterfall` method to keep passing down upper dependencies to the lower
functions, it's a little more manageable but still messy in larger codebase.

### The Solution to the Living Hell

**Enter Promises**

The above-mentioned chaining is still the solution to avoiding the triangular callback code but with a little more magic handled by the wrappers.

You see, someone wrote a library called `q` which was the initial concept of how promises have grown to be today, this was followed by bluebird's
promise polyfills which overall implement the same `thenable` paper.

### Thenables

We are still going to have the callbacks in our life but we are going to put on a little makeup on them so we can bear them for longer sessions.

Thenables when explained simply, is a stateful container that can be chained by `.then` caller functions and each caller function creates another
thenable. A recursive chain of wrappers to be precise.

I'll explain with the same example

```js
// Variation One
dataFetch()
  .then(data => {
    return formatFetchedData(data)
  })
  .then(formattedData => {
    return processFormattedData(formattedData)
  })
  .then(processingResult => {
    return sendResultBackToServer(processingResult)
  })
  .then(serverResult => {
    return console.log(serverResult)
  })

// Variation two
dataFetch()
  .then(data => formatFetchedData(data))
  .then(formattedData => processFormattedData(formattedData))
  .then(processingResult => sendResultBackToServer(processingResult))
  .then(serverResult => console.log(serverResult))

// Variation Three
dataFetch().then(formatFetchedData).then(processFormattedData).then(processingResult).then(console.log)
```

If you understand the verbose example, you can understand how the other 2 variations work and this is obviously much neater than plain callbacks but
as I said, we are still going to continue using callbacks because the language depends on it. The solution/promises are just a better way to handle
it.

As visible, we still pass functions down to a wrapper/caller function that takes in the returned data and passed it to the next then in the chain
because every function being called inside a `.then` is treated as another Promise and hence can be chained to be such.

I'll try to simplify how Promises work internally. The Promise constructor maintains a state for itself. `pending | fulfilled | rejected` these 3 per
promise decide if the call was successful, or failed and based on it, they call a `.then` or a `.catch`.

```js
new Promise((resolve, reject) => {
  if (1 > 0) return resolve(true)
  else return reject(false)
})
  .then(value => {
    console.log(value)
  })
  .catch(err => {
    console.error(err)
  })
```

To explain this we'll consider the above example. I create a new Promise using the words `new Promise` and this constructor takes in a callback that
is passed 2 params, `resolve`, and `reject`.

Pause.

At this point we have a Promise with the state `pending` because nothing has actually been a success or a failure and it'll stay that way till you,
the person who's writing this promise decides.

`resolve` tells the constructor that the run was successful and you can execute your `.then` function's callback and pass it the data that it has
received. In our case, `true` is passed to `.then`.

`reject`, on the other hand, calls the `.catch` with the passed value and this is where the state changes to `rejected`

**You didn't mention the state changing to `fulfilled` !!**

I know. Patience, human.

The `fulfilled` state is updated but under certain conditions, if there was only one `.then` call, then the main constructor is now `fulfilled` but if
you chained it with more and more `.then`s then each one has it's own state and even though the first constructor might have resolved and changed to
`fulfilled` you'll still see pending in the console because the chained ones each have their Promise instance which still has the state as pending.

In the end, we have a few callbacks and a constructor wrapped around our callbacks to make this chaining possible and code a lot more readable.

### Generators

This is a huge topic so I'm going to explain it in another post sometime in the future but for now all you need to know is that generators are special
kinds of functions that allow you to iterate over and over till you decide to end the function altogether. This is the actual concept that
`async and await` works on. You can write your custom async-await implementation using a few generators and promises.

### The Chosen One

**Async|Await**

Now even though I'm someone who likes promises more than I like async-await, mainly because I keep forgetting to add the async keyword on my functions
and I'm too used to writing `thenables` to control my async flow, still as a programmer we gotta learn what's new. Isn't always better but if you know
your options you can choose the ones that suit the condition.

As mentioned in Generators, you can create your a custom async-await wrapper if you'd like too since the interpreters will actually compile your
async-await code into generators anyway.

Generators allow you to iterate over itself and used a keyword called `yield` which allows you to throw value out of the generator and take in another
value for the next yield till you decide to end it's life with a `return`, much like normal functions.

```js
function* infinite() {
  let index = 0

  while (true) yield index++
}

const generator = infinite() // "Generator { }"

console.log(generator.next().value) // 0
console.log(generator.next().value) // 1
console.log(generator.next().value) // 2
```

With this in place, I can have one generator run, get an async value and yield it out of it, then pass it back to the generator and it can run the
next `yield` scope and so on till it decides to stop. You need to understand that while yielding we are still resolving promises and `async/await` is
nothing more than syntactic sugar for creating and resolving promises and as always, it's also based on the concept of callbacks and hence each of
them creates a slight delay if compared to async functions written with just callbacks. But, developer experience and sanity need to be kept in check,
else we'll have all JS developers in some Asylum yapping about callbacks all day long.

In technical terms, Javascript's concept of considering functions as first-class types improves the composition and this is something that functional
programming languages generally have.

The composition works well but then you gotta limit the level of abstraction you create ( a rant for later )

Overall, a general idea of how the internals of the language dictate your control flow helps you make better choices and this can be seen by the
concept of `callbacks` which is a spec that [André Staltz](https://twitter.com/andrestaltz/) came up with, which is creating a Pub/Sub model using
just callbacks and using them for streams (Again, will make a post about this as well).

Make sure you don't create a callback hell inside a thenable though.

## That was long....

Adios!
