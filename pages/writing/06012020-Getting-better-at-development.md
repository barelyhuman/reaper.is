---
title: Getting better at development
date: 06/01/2021
published: true
---

**First**, as Samuel L Jackson would say, Happy New Year, Mother... !

Now, there's like a million posts about this topic and they actually share a lot
of good information because they are written by developers far more skilled than
I am.

Also, I won't be able to add much more value to any of those but I'm still going
to give it a try so, bear with me.

Things that I think are important

- Algorithms (No shit!)
- Understanding of the actual language
- Your ability to humble down
- Learn by Teaching so you can understand what you actually learned (Sorry,
  What?)

## Algorithms

Pretty self-explanatory and probably hyped enough in a world where everyone who
wants to join FAANG(Facebook, Apple, Amazon, Netflix, Google) or similar
companies, already break their heads on problem solving and algorithm
applications.

Which is good, and should be done but not just for FAANG, you should be doing it
for your own god damn improvement, you might not want to join any of the above
companies but getting better at these will help you solve problems in real life
applications quite a bit.

A very simple use case,

You're building a cab booking app and you create an order and start payment,
you're using something like Braintree or stripe for payment and you've already
initiated the payment but the user decided that he wanted to cancel the order a
second after the payment intent was fired, guess what, you now have a race
condition, the payment gateway might win, or the cancel request might win,
either way, you now have 2 dependent actions running in parallel and that leads
to junk data or complete failure.

### The Client Sided Solution

The client has the option to not show the cancel button once the payment went
through which works and is fine, no big issues but we should've thought of a
better solution to start with. Though a user kill might create an issue for
other dependent processes (rare case scenario, so let's ignore it for now)

### The Better Solution

Queues!

Most CS students would already know where I'm going with this but for the self
taught humans, You add these requests into queues , or basically some
implementation of a channeled queue where you can handle the concurrency of
certain categories to avoid processing them in parallel aka Redis + rsmq, Apache
Kafka, etc etc etc etc!

You have worker instances on the lookout for such requests and complete one
request before they complete the other, if a transaction was initialised, wait
for it to complete, then cancel it and refund accordingly, this works because
even if the client app crashes or is killed by the user your queue isn't botched
and is processed as intended.

I can go in more detail but for now , the point is, you need to realise what
problems have already been solved at a base level to find advanced
implementations of them to make it easier for you to implement features and
these are basically what algorithms are, solutions that already exist in the
wild that you just need to understand and implement or use a tool that takes
care of the implementation for you.

## Understanding the Language you use

Now, I'm not going to argue over which language is the best, they were all built
for specific use cases and have been adapted for various use cases over the
years.

The best language is the one you already know , though that doesn't mean you are
going to argue with the internet trying to prove that whatever language you know
is the best.

Learn as many programming languages as you can to find the obvious differences
that can help you choose which language to go with for certain scenarios, you
can find a good overview that
[Drew wrote over at his blog](https://drewdevault.com/2019/09/08/Enough-to-decide.html)

Yes JS is used by SpaceX, because it's easier and cheaper to find web devs, not
because it was an efficient decision but then this statement will fire up all
the JS devs around the globe so I'm not going to into the depths of it for now.

To the actual point, **what do I mean by understand the language?**

Nah, not the syntax, neither the keywords, what you need to understand is how
that language analyses what you instruct it to do. Your syntax is limited to
just giving an instruction. For eg.

```js
function one(obj) {
  return obj.one;
}
```

or

```go
  type exampleType struct{
    one bool
  }

  func one(obj *exampleType){
    return obj.one
  }
```

or

same thing in python, c , I'm not typing each and every snippet, don't have to
show off the number of languages I know.

Back to the explanation, we have snippets that try to access `one` from an
`object` or a `struct` and both will fail if `obj` doesn't exist, in case of JS
undefined can be passed since there's no type checking and even when go has
type-checking you'll still fail during runtime because the pointer can point to
a nil address. Either way, during runtime I have an issue, now this has nothing
to do with the syntax , nor is related to something people will tell you to
remember, you add this into your set of checks as you keep growing into using
the language.

The fixed version of the above is a simple check on the existence of obj, both
are short circuited by AND and OR conditions though you can write them in
simpler more readable `if(obj){}` fashion as well.

```js
function one(obj) {
  return (obj && obj.one) || false;
}
```

or

```go
  type exampleType struct{
    one bool
  }

  func one(obj *exampleType){
    return (obj && obj.one) || false
  }
```

Now, understanding the language can be both proactively done (learn and read
about the interpretor and/or compiler while learning the syntax) or reactively
done (learn by seeing the code break).

While I'd recommend doing both, where you read about it and then forcefully go
ahead and break the code to see and set the error up in your brain (don't do
this in production!)

That's for understanding the languages. Yeah simple examples, we don't have to
go too deep to understand the importance, though if you need more tips , you are
free to hit me up on email.

## Ability to Humble Down

I'm going to shout right now so, one sec.

ITS OKAY TO ASK FOR HELP!

Keep reading the above till you understand it.

As a programmer, you're always going to jump in on something new, something
really old, or something thats irritating before you even get to it.

I've tried learning a few languages , been successful in learning a lot of them
but then there's rust, hard time understanding that language, ended up giving up
on that language twice and then got back on it again and again till I at least
understood the core of the language, I still haven't written anything useful in
that language (then again, I haven't written anything useful in any
language...).

Readers would already know that I've been using Go extensively but then, how do
I know my code is efficient? who reviews it?

Do I have a mentor? Nope Do I ask random strangers to review it? Yes.

It's a simple thing, go to reddit, request a review, someone might be kind
enough to actually review your codebase, chances are they might be new as well
but now you have things that he/she learnt added to your knowledge drive. Win
Win.

If I go, "Nah, I'm way too good at JS , i don't need anyone to help me learn
this new fancy language, I can handle it", I'm literally pushing away all the
free knowledge I could've gained. I'm not kidding, a person reviewed my
[commitlog](https://github.com/barelyhuman/commitlog) codebase that's written in
golang and also wrote about the mistakes I made
[you can read it here](https://percybolmer1.medium.com/performing-a-code-review-1297967683f6).

There's some really simple things that I messed up but then I'm not set with the
language's standards, I wasn't smart enough to check other existing go
repositories read through them and see how things were structured like I did for
my JS/TS projects.

In my defence the reason was that it was a POC(Proof of Concept) implementation
and was written accordingly, but still I got to learn a lot about how it's
better to structure one package into multiple files instead of how I keep
creating package out of every folder I create , which is a habit I have from JS
projects.

Long story short, BE HUMBLE! and learn from wherever and whoever you can!

## Learning by Teaching

There's a great deal of psychological research and articles you can find about
why this works , I'm just going to give you a gist of it.

If you've learned something and you can teach it to someone else aka explain it
well to another person then you've successfully learnt and understood that
concept.

Basically, the source of the rubber duck debugging method, if you can explain
the duck your code, you understand your code and possibly even found the bug
while doing that.

If you're trying to explain it to someone and you are stuck at a certain concept
that you can't explain then guess what, you didn't understand it, so go back and
try again!

That's about it for now,

Adios!
