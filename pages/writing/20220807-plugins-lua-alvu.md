---
title: Plugins, Lua, Alvu
date: 07/08/2022
published: true
---

Now, this was going to go into [kb](https://kb.barelyhuman.dev) but would better serve as a proper post so let's get to it.

## Plugins

Most people might already know what plugins are but for those who don't , it's a mechanism to extend the original implementation with additional
features / mechanisms / etc etc.

Being able to write a truly open API for the plugins to use is pretty hard to do and could end up being complicated and finding languages that most
writers could easily learn and use is also a challenge.

Not everything needs plugins but it definitely takes the load off of the developer to develop and add everything into the tool/app/whatever.

I assume most readers are coders so you already know all this and the closest example would be your code editor, either sublime, vs code, vim
whatever, there's plugins everywhere.

Next, moving onto the reasons to choose lua as a language and things I learned.

## Lua

I barely knew about the existence of lua since I've heard of it being the embedded scripting language for most platforms (games, micro hardware, etc)
but never really learned it.

I recently started moving to nvim from vscode and lua was the choice of configuration by a [friend](https://mellow.dev/) and I'm using his
configuration so I just stuck with it.

Basically, started learning lua to soon realise that the language is pretty tiny, easy to remember and very easy to read even in larger codebases.

It's simple to extend with other functionalities by just adding additional `.lua` files to your project and importing them into your code, or you can
use the global system level libraries with `luarocks` which can involve having libraries writing C lang code that builds into lua.

Thus, the language can be easily extended.

Now, choosing it for alvu was a no-brainer cause alvu itself barely has any functionality. The entire codebase is like 500 lines in a single `main.go`
right now .

It just takes in a directory, converts it to html, everything else is done by the developer and that sounds like a pain but let me tell you what the
developer actually does.

As a user of alvu, you will rarely every write the entire functionality of the blog / wiki / static site that you are building. You'll mostly just
bring in content.

Everything else is already going to exist as a template for you to use, alvu is just a tool that knows how to process these templates for you. This
gives us a way to keep the base tool tiny and still infinitely extendable and considering how small the Lua VM is extending it is not that hard.

## Alvu

You might already know what it is, or you might not, to be put in single statement.

Alvu is a static site generation engine which can be extended with plugins written in lua.

We call these plugins `hooks` but basically they are the primary drivers of how things post render will look.

The base idea is implemented but it's going to change over time with the lua hooks taking over the entire functionality of alvu and the only thing
alvu would be doing would be to give the hooks information about what to process.

Now, this also does shape the direction for other tools that I have and where needed there will be ways to extend the tools (while keeping the base
tool as tiny as possible)

## Problems

There's never anything without it's own set of problems so here's the things that were causing issues when working with it and how I wish I could
improve perfs

1. I was unable to setup a waiting queue algorithm without making the program overly large and so I had to give up on that algo altogether.
   (preferrably build it as a package for later use)
2. Right now it uses a combination of channels and mutex ( exclusion locks ) which internally depend on channels and this code could get messy very
   quick, and I did actually get it to be a little more complex to read so you might wanna avoid that when working with Lua VM since it's not directly
   thread safe and you can have one lua state instance per go routine.
3. There's quite a few repetitive tasks that a alvu template developer might have to do which while isn't a problem that can't be easily solved, it is
   a problem as of right now and don't just go on promises I'm making.
4. Lua as a language does have it's own shortcomings, no regex support, string manipulations are limited, etc etc. And while I can extend lua to have
   these features, it will increase the size of the original tool and that's something we are trying to avoid so it's considered a problem.

Well, that's about it for the post. Adios!
