---
title: Turn the Bass up
date: 14/04/2023
published: true
---

This post has nothing to do with music, I'm sorry.

We aren't solving a big problem here, but when have I not given the context of
what was bothering me and what has helped mitigate or reduce that frustration

## CI isn't the most pleasant music

Scripts I write are primarily in bash and this is so that the scripts can be
tested locally, most of them are written in a portable manner or comply with
POSIX so that they can be run on both Unix and Linux in most cases.

This works as a solution in most cases but testing them for a CI always requires
you to still run it on the CI which well, consists of 100s of commits and at
least 3 cups of coffee till you get it running.

The count of commits and coffee doesn't matter if it was a 1-time operation but
we all know it never is.

## Adding Docker for a little more musical harmony

The other solution that I tried or experimented with was writing docker images
that run the code's scripts and these images could be run locally or on remote
CI's with very little setup and worked great.

This is probably the simplest solution but then docker wasn't built for running
scripts directly so you end up having to write a script that builds the image
and runs it for you and the log is then streamed to your terminal.

You **don't** have to write the log streaming part but it makes it easier to
work with.

This story starts somewhere in late 2021 when I first found out about
[earthly.dev](https://earthly.dev) and tried it out for a few web apps

In the past 2 years (_presently 2023_), I've seen a growth in this space of
local CI/CD solutions quite a bit. There's `act` for running Github Actions
locally, there are virtual runners for Gitlab which are still complicated to set
up but usable, and there are also the BuildKit solutions

## BuildKit, the reason behind the melodies

Docker builds are great and all but as mentioned, setting them up yourself per
project might not be ideal considering the maintenance for each of these might
become cumbersome especially when you are working in a small team. It's easier
to delegate this to a tool that just does this and Docker releasing BuildKit out
in the open, helped quite a bit.

BuildKit is responsible for being able to detect the caching and build stages
for the Dockerfile and it also exposes an SDK for various languages that can be
used to trigger or even wrap around such instructions programmatically.

One of the variations of this is Docker itself, but since it's an SDK, we now
have other amazing devs who made use of it.

## Dagger.io and the Golden chords

I was introduced to Dagger.io by [Alex](https://twitter.com/alexsuraci), who was
aligned with their idea of how CI processes should be both local and remote and
this was still under development and was only available for Go lang when I was
introduced to it.

It's now available for quite a few of the mainstream languages if you wish to
try but this is one of the solutions for the problems mentioned above.

Your CI is now a piece of code that can now produce Hermetic Builds(_buzzword_
for consistent and reproducible builds).

The process is simple, you tell Dagger programmatically what the environment is,
similar to Docker and then what scripts or lines are to be executed.

Dagger would take care of

- Pulling and setting up images
- Copying the required context
- Preparing the environment
- Executing and Streaming the logs for you

All of this happens in a BuildKit container instance, instead of creating a new
image and running it every single time, thus reducing the overall time when
compared to the original approach I mentioned which would need you to build and
run which would create quite a few dangling images.

**Example**
```js
import {connect} from "@dagger.io/dagger"

// Connect dagger's buildkit instance
connect(async (client) => {

  const containerDef = client
    // name the pipeline
    .pipeline("test")
    // create a container
    .container()
    // from the following image
    .from("node:16-alpine")
    // then execute the following command with the next set of args
    .withExec(["npm", "-v"])

  const result = await containerDef.stdout()
}, { LogOutput: process.stdout })
```

## Now, to add the Bass

Finally, the other solution and the one I've just started using is called
[Bass](https://github.com/vito/bass), it's not a CI solution but more a language
that uses BuildKit as the target runtime. And hopefully, the readers of this
blog understand my liking for new languages, though I've never actually worked
with LISP/Scheme based languages.

So, it was a little tricky for me to pick up the semantics of Bass but, somehow
I was able to learn enough of it to write a few tiny scripts.

```closure
#!/bin/bash env bass

// define that this run should memoize the thunks
(def memos *dir*/bass.lock)

// define that the function receives an argument `src`
(defn test [src]
    // use the `node:16` image 
    (from (linux/node :16)
      // cd into the src argument
      (cd src
        // run the sequence of commands 
        ($ npm i -g pnpm)
        ($ pnpm i)
        ($ pnpm test))))

// Main is the entry function 
// so here we define the args we might get 
// from stdin

(defn main _
  (for [{:src src} *stdin*]
    // we then go through the args of stdin, take the value for `--src` and pass it 
    // to the function test
    (run (test src))))
```

## Strings that broke

The counterproductive part here is still that I need to set up a docker/BuildKit
environment in CI machine(Circle, Github actions, Gitlab Runners, etc) but most
of them provide a way to connect to a docker setup. Post that, all you need to
do is either install the dagger SDK when working with dagger or install the Bass
lang binary to run the bass script which is a process your language's package
managing solution or a simple `curl` script can handle and is something that
rarely breaks.

Overall, I seem to believe that the whole local first CI space is something
that'll grow more and more in the next few years and save me from having to test
infinite theories of why my CI scripts were breaking.

## Bonus solution

Another one here is Nix, it's a language and a package directory that can cache
and create the same environment everywhere for you. Though based on experience
and review from a lot of people who worked with Nix, the language can get a
little confusing to learn as compared to something like Bass.

I'll add an example from someone's gist here because my nix config files are rather 
unimpressive

This will setup react native and android SDK for you as soon as you activate your shell 
in the project folder

<script src="https://gist.github.com/kamilchm/15916525bf1a1171e5e0942686844298.js"></script>


That's basically about it for now. 
Adios! 
