---
layout: ../../layouts/Page.astro
title: The lab folder
published: true
date: 26/07/2022
---

I've probably already written about this somewhere though I don't think it was on the blog so we're adding it here now.

The post is based on my workflow of how things end up in git and also kinda prove the level of dumbness that I'm at.

### Ideation

I'm a do first, thing later kinda guy and this shows almost everywhere and most of the work you see has gone through a
filtration stage ( might not believe it since hardly anything I write is useful)

#### Web

The first step in my not so organized life is to take this tiny little idea down somewhere, which is mostly the iOS notes app
since that's what is around me almost always, either on the mac while I'm working or on the iPad later when I'm watching something to
chill

These ideas fill up a folder in the notes app and stay there till I choose to go through them again.

#### Tooling and Packages

The tools and packages on the other hand go into an existing project that I'm working on and are built as a part of that project first. Then they are moved out into a package if I feel like it's something that devs might need at some point.

### Prototype

Don't let it fool you but there's no actual structure in here, it's literally just pickup whatever and do whatever thing. The 2nd stage is basically writing down the code for whatever the idea was.

There's not much difference here since both these things go into the `lab` folder.

#### `lab` folder?

Being an impulsive guy, it's really easy to try to do everything at once and the probability of messing up things with this is quite high. I can't change my nature but I can work with it.

For a smarter person this could be easily solved by changing workflows to be very focused but I'd like to avoid that restrictive workflow, this got me to the whole approach that we are going to be talking about.

_Everything_ goes first to the `lab` folder, which is a simple folder that's named `lab` nothing else, it doesn't have special scripts (it does have scripts, they aren't really special though). This folder just represents being a dump of ideas, a place of experiment and no restriction, and I can fill it up with whatever on earth I want, since it never goes public.

If you thought that "reaper has 256+ git repos and only 4 usable tools", trust me, I could've made 1000's and chose not too (I could've have hogged up github's storage if I wished too)

The scripts here are basically a bash script that allow you to select the kind of project I wish to start, the script itself gets updated every time I pick up a new language so it handles the steps to create a new project. There's no templates, no specific method, just a bash script that goes through multiple commands that I'd write in the shell.

example, here's what the `go.sh` script looks like

```sh
#!/usr/bin/env bash

set -euxo pipefail

mkdir -p $1
cd $1
go mod init "github.com/barelyhuman/$1"
touch main.go
echo "package main" > main.go
nvim .
```

This would do the following in order of the commands

1. use bash
2. set the script to fail on first error and the commands that are being executed and fail on unset variables
3. make a directory of the input name `ex: ./create/go.sh commitlog` would create a directory for `commitlog`
4. change into the directory
5. initialize a go module
6. safe create a file to avoid overriding if the file already exists
7. echo the base package line into the file
8. open the editor of choice (might change as I change editors)

The JS is a similar one, it doesn't setup tooling or anything else, it just sets up the main index file that the code will go into since
before it even becomes a package, it's supposed to be functional.

Also, I've gone through various packaging methods over the years for nodejs packages to learn about the shortcomings of each and so I spend
more time writing the package scripts and tool configurations than I spend writing the actual package (which, isn't a good thing but it's fun)

### Publish / Deploy / Push

Before anything is pushed, the idea is filtered out (yes, after doing it), reason being that there's stuff that people could write themselves in
very small lines of code and that'd be a waste to be added into a package.

2nd, more often than not, someone's already built a much better and more robust solution to it and has been spending time maintaining it, me making a
useless version of it and throwing it out there doesn't make sense. It's still advantageous to do since I learned how the core logic of that implementation works
but that doesn't mean I have to post it out there.

A good example would be the `toyvm` I wrote, while it's public, the sole reason for writing it was to learn, the reason it's on github is because that's something I'd like to refer to later on and since I work with multiple devices having that reference on all devices makes it rather convenient.

8/10 times that's the reason the experimental project is up there.

Next up, once the prototype is ready, the way of working changes a bit based on the project.

1. A pure client side webapp get's dummy deployed using vercel's CLI, checked and then permanently deployed by linking it to the git repo
2. A server and client side webapp gets pushed onto a compute instance (Digital Ocean, AWS, etc) using docker's remote context
3. A npm package get's a CD script to publish to the registry
4. A go package just get's pushed with a tag (the simplest god damn flow!)
5. A go binary get's CI/CD to build the releases on tags and then I spend the next 1 hour figuring out why a certain OS + Arch combo doesn't work for that specific binary.

### `code` folder

Once the above is done and I've pushed to a remote git server (github, personal server, etc etc etc) , the project from the `lab` folder is deleted and
a fresh clone from the git server is taken into the `code` folder (when I decide to polish the app or improve it) till then, there's no record of that
project on disk.

This is done for 2 reasons, a cluttered `code` folder makes it hard to find projects that are similarly named and hog up space and `node_modules` is not a joke! (just kidding, i use `pnpm`)

But, to be honest, as long as the clutter is away it does help to get to code quicker and the code folder normally also has projects that i'm contributing to, so the folder does have quite a few projects when combined with my projects.

### Polishing

Unless you're like me, there's a good chance that your working on just 1 or 2 project and you might pick up the polishing phase a lot quicker than I do.

But, more often than not, your project has probably reached this state

- functional
- looks hideous
- has 1 person interested in using it (should be you, the others can join in later)

This is where you might spend time on polishing it, though I rarely do it unless I've been using the app/tool/package quite a lot.
examples would be

- commitlog
- conch / useless library
- mark
- CRI

These are my primary tools and the one's which are updated over time significantly.

1. commitlog has a whole new CLI
2. conch got a perf boost
3. mark got a UI Revamp and usability improvement
4. migrated the whole thing to a proper database and improved the API's being used.

If I sit down to improve everything I've ever written, trust me, I won't have time to sleep (not that I can sleep for more than 4 hours).

anyway, this is basically how having a separate dump of ideas helps an impulsive monkey like me

- learns stuff
- help filter out from actual prototypes
- adds a tiny bit of structure to whatever I'm doing

And that's about it for the post,
Adios!
