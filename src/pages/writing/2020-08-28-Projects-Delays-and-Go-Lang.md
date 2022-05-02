---
layout: ../../layouts/Page.astro
title: Projects Delays and Go Lang
date: 2020-08-28
published: true
---

I've been slacking off on personal projects for a while now and it's not because I want to throw these projects out of the window but because I've been learning Go Lang for the past few weeks and I'm not able to dedicate time to actual coding just yet.

### Sorry, What?

Umm, I'm trying to say that I've been reading books and blogs about Go for the past few weeks and that is pulling away time from me to spend on building new projects and/or optimise and improve TillWhen.

While I myself say that doing actual projects help you learn faster it doesn't apply when you directly want to build a huge project in a new language.

It is a necessary step to learn the language inside out since just treating it like an equivalent of another language I know already, will limit us from actually understanding the actual use case of the new language and also blocks our paths when reaching out for help.

If you don't know what the language calls a particular type or a function and you search on google based on your previous language experience, you are going to get stuck.

### Why Go Lang?

I've been switching back and forth between Node(Javascript) , Rust and Go for a while now and every time I hit a road block in Rust and Go, I immediately jump back to Node to complete the project or tool and this has been a pattern because I lack the theoretical knowledge of the language and have been treating it like a replacement for Node , which it's not and this thinking has been hindering my progress.

A few weeks back I decided to build a project management portal for solo developers which I didn't continue to build because it was going to have it's own Git server and stuff but then the git implementation and the total size of the binary crossed 70MB and I wouldn't want someone to self host something that takes up 70MB with just 2% of the features and this is because it is hard to get rid of node_modules completely when bundling to a binary and then I remembered about [pgweb](https://github.com/sosedoff/pgweb) which is just 8MB and is bundled with a full fledged Postgres web UI.

I liked that and since the Go portable binaries are really well optimised, scaling to desktop apps using an RPC server in Golang would make building native apps a little more easier but, the history of me jumping away from the language every time theres even a minute inconvenience was going to get in the way.

I started researching on how various people moved from language to language and things they had learned about this move.
The things they wish they considered, the things that blocked them or took them time to understand, everything.

I got the answer that I'll need more theoretical programming knowledge specific to this language to be able to avoid most of the blocks and the only ones remaining would depend on the newer packages that I'd add to the codebase, which makes sense and hence, I started reading.

I'm almost done with the book so I'll be working on small tools and maybe even rebuilding tools just to get better at the language and then get to the project management app again.

### The Point of the Post?

There's never one.

Adios!
