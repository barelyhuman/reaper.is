---
title: Playing around with Crystal Lang
date: 18/12/2022
---

I'm no professional "Programming Language Reviewer" but I think readers at this point understand that I jump around multiple languages just cause it's
fun.

There's no meaning or purpose behind this, it has given me the advantage of being able to pick a language based on specific usecase but then that's
basically it, for most consumers and most cases today people don't care. I do, so I pick what I like and works for the situation to the point where I
would write something in Assembly if required.

## Reasoning

Picked it up cause at least in my head it's now gaining traction in and around the community and I see a lot of higher level stuff being available in
the language at this point.

I wished to see if I would like the language or not (which is based on just my opinions, hold you horses)

## Language Setup

The setup was pretty simple and straightforward, but then what isn't if it's tied to `brew` , I think I should also release `commitlog` and `mudkip`
on brew to make it easier for me to install them later as well. I spend so much time finding the `curl` script for `mudkip` specifically.

```sh
brew install crystal
```

and you're done, they have package manager setups on linux distros as well, so my attempt with alpine was equally simple.

## Overall Experience

### Syntax

Python has a beautiful syntax and there's no denying it. Actually indented languages with simple syntax are something that just work for me
personally.

Examples: lua, nim lang, ruby

And, I think I can add Crystal to the list of syntaxes I enjoy writing. I mean, it was a no brainer since the language and syntax picks off of ruby so
it was going to be something I like to type but I mean, there were no hiccups in translating ruby syntax knowledge (thanks `fastlane`) to this.

### Size

Now, the breaking factor which moved me to nim from most languages I've tried is the output binary size and even here it's like ~1 MB for a simple
"hello world" program and while that is smaller than outputs from golang, I think I'll still stick to nim in case of future CLI tools, since the
output size matters a lot to me when creating them.

For others, that don't really care about that, you can go ahead

### Web Dev

I've not aggressively tested the language but I was able to setup a basic web server with the following features

- View Rendering (HTML, Mustache)
- The Static server (obviously)
- Basic Auth
- Basic queries from DB
- Worker Threads[^1]

[^1]:
    native concurrency, a little tricky but not that hard, or I'd say it's more about remembering that you can ask the Fibers to yield at will or they
    will wait for the event loop, I think the closest I can compare that to would be the timer functions in Javascript (`setTimeout` and
    `setInterval`)

### CLI Dev

This was impressive since, I've worked with `nim` and `go` for CLI and they both provide a way to parse CLI options in the std library, so this was a
easy winner.

Also, it's really easy to construct and handle the different cases almost as easy as `bash`, so I guess that's a win.

On the other hand, user input, at least text is pretty simple to work with as well, literally the same as ruby so I think for basic cli tooling you
should be fine. Unless you wish to build something like Astro's Hudson.

### Thoughts

I'm going to stick to Go lang for microservices and Nim for CLI tooling for now, but I will keep looking at Crystal for both, since I'm still not able
to confirm that all cases of Database invocations work or let's just say I'm not comfortable switching to it permanently yet. Looks like a good
language to jump to though.
