---
title: Updates - 27th September
date: 27/09/2020
published: true
---

Let's look at things I've done in the past few weeks.

### TillWhen

- To-dos now in beta
- Export Project data to CSV

Added the above two to Tillwhen and are right now on the beta environment as I'm posting this, you can expect them to be on the live instance in about
2 days.

### Cor

Haven't touched Cor for a while now , Cor is a project management app that I planned on building but gave up mid way, might get back into building it
soon, but not motivated enough to work on it right now.

### PUI

A postgres UI client that was built as a toy project will take precedence over COR and TillWhen next week. It's usable for local connections for now
but basically has no validations etc so wouldn't really recommend using it for cloud connections right now, plus I haven't added ssl support to it so
that's going to fail on you for various hosted instances anyway.

### Others

I've been working on the text editor research still and have been practicing Go Lang and C a little more and plan to get better at both before I start
using them in production grade stuff. The Minimal Code Editor that I've been planning to build all along is the motivation for me to go to these
languages. C for it's cross-platform availability and Go for it's easy interop with Swift and GTK. While the Linux edition of the editor might come
off easy with just one language, the mac version takes precendence since I'll be testing the editor while using it myself.

Also plan on building a transaction tracker and payment system for people to host , something like Drew's
[fosspay](https://github.com/ddevault/fosspay) but my take on it. Not sure when I'll be starting this but you can follow my Github to see if I do it.

Setup a personal git server for TillWhen's source code, not that I worry it's source code will be out because I will be making it open source once the
app is stable with all the features I want and once I've removed all the heavy UI libraries it has as dependencies for smaller components. Don't want
the community to start patching torn elements of a codebase that's not elegant to deal with so stay tuned for that.
