---
title: Side projects that've proven their worth
published: true
date: 31/05/2021
---

I'm no "HUSTLE EVERYDAY!" kind of person but I like keeping myself busy or I go
into the feedback loop and then ruin my mood for no logical reason.

This has led to a lot of hobbies in the past and a lot of side projects after I
found my liking towards code and being able to build stuff, this includes all
the Custom rooms I built for the hell of it, the mini tools I've built over the
past few years, things I learnt, things I want to learn now, the list is never
ending.

Over the years, I've rebuilt quite a few things and I still do. They say "Don't
reinvent the wheel" , which is true but that's only when you are building
something that involves the existing concept of the wheel.

Let's say I'm building an E-Shop, I could go with existing partners like
shopify, wordpress plugins for the same or there might be other alternatives to
the same that I don't know off and it's totally fine to go with these options,
your time to market is reduced exponentially when compared to something that
would've been built from scratch and totally makes sense if you are limited by
time.

**But**, now I want to compete with the existing solutions out there in the
market by building a custom framework that's better than them in some form in my
opinion , I will have to reinvent the wheel, I'll have to understand the
concepts , I'll have to go through every problem these products faced, I'll
understand their decisions a lot more. This might even change my approach to
building a new competitor in the first place but the point remains.

> You have to reinvent the wheel when you want to understand how the wheel
> works.

This might take longer but will make sure you understand it better and that's
what the end goal is, at least for me.

The chance of me being the best there is in terms of a developer is quite low
but the chance of me being able to at least learn everything I wish too is a lot
greater if I move towards it.

With the whole philosophy out of the way, it's time to discuss the actual title.
The sideprojects I'm currently proud of.

A few names come to mind when we talk about them

- [commitlog](https://github.com/barelyhuman/commitlog)
- [Hen](https://hen.reaper.im)
- [Mark](https://mark.reaper.im)
- [Music](https://music.reaper.im)
- [statico](https://github.com/barelyhuman/statico)

There's obviously others that I've built but these are the top 5 right now, the
sole reason being that they are the one's I use the most. We'll go through each
one by one and the whole first part was just to make sure I could bring it to
your notice that each one of them was "re-invented" with my understanding of how
it would've been done.

### commitlog

A really simple concept of being able to use the commit messages as changelog
and it now has the additional release version management inbuilt, though it
needs modifications in how it manages the version right now.

The concept isn't new or something innovative, there's a dozen tools on github
that do the same, the sole reason was to move away from the NodeJS only
[release](https://github.com/vercel/release) which needed a node pkg to be
initialised to work with the version management and that would mean I'd have to
add package.json files to a non nodejs project , for example a ruby or a golang
project and that lead me to creating a cli that worked with basically any
project because it's dependency is just Git and itself.

### Hen

The alternatives of this are way more powerful than hen is ever going to be
because each of them expect it to be a business plan and they have to put in all
that to compete with each other, Hen on the other hand is a quick REPL for me to
test out new component designs that don't really need a full environment and
file management, it's a single code editor panel which renders the output on the
right.

This started off as a simple experiment to see how easy / hard would it be to
create a live renderer of React components while maintaining isolation of
concerns and not letting people do whatever they want to the website. Obviously,
you can't use hen's code in production since it assumes the tool to be only
frontend compatible and while the rendering is done in an `iframe` and isolates
the executed code, the website cookies can still be transferred since the iframe
acts as a part of the domain. But then these are all handled on the other
alternatives using various headers that identify the source of the execution,
which you can obviously add to the code if you plan to use it but it doesn't do
it since there's nothing on there for people to use

### Mark

My primary markdown editor, I'm still improving on things on this and at some
point it'll have a live preview instead of side by side preview but that needs
me to focus on it and right now all I do is use it to write posts, this very
post you are reading was written on it and so are the devlogs on
[barelyhuman.dev](https://barelyhuman.dev)

This started off as another random project that I thought would be super simple
to implement considering there's so many markdown parsers available outside
though I do plan on writing my own markdown parser someday.

I've tried Typora and I do like it but it's going to become a paid app once they
are done with the beta, and If I can afford the price I will buy it but if I
can't, mark isn't going anywhere now, is it?

### Music

The oldest of the bunch, was named Orion to start with and is now just
[music.reaper.im](https://music.reaper.im) but the concept of this was I needed
something that could loop youtube videos while I'm gaming and something that's
super light to work in the steam browser which was quite limited back then and
even though now the app is a little more heavier when compared to it's older
versions, steam handles it quite well and I did add the ability to import
Spotify playlist tracks into the player a few weeks back.

### Statico

I was called stupid for building this from scratch but then I've been called
stupid for a lot of things...

Anyway, the concept.

Build a small and quick handler that could convert a folder full of markdown
files into html files that you could simply serve, this started as the base for
[reaper.im](https://reaper.is) which was powered by
[Next.js](https://nextjs.org/) before and my hub for experimenting with things
and features but then I realised that the site was unnecessarily heavy in terms
of what it actually accomplished and with the other generators I'd have to use
themes provided by others or sit and write the theme in the standards they've
set which is pretty easy considering my design preferences but I though how hard
could it be to write a simple tool that would do this.

That brought the base idea to life with reaper.im being the sole focus of
support for the tool, literally just to support the reaper.im , I had written a
SSG(Static Site Generator) and now there's 2 sites that I know off that use it.

Obviously both are sites belong to me but the barelyhuman.dev needed
modifications to the tool so it could adapt to more setups than just the one
that this site had and now statico can be used with basically any simple SSG
requirement, the complex one's I don't know off because I've not tested and the
deploy time with it is 12~14 seconds. the 10 seconds being the environment
getting ready and cloning the repo etc, the binary just runs for 2-4 seconds
based on the amount of files you have and the number of indexes it needs to
generate.

---

Overall, build whatever you wish too, as long as you see the need for it and it
**might** just work out for the best. This is just a cut down list , the total
number of things I've built both small and big would take time to go through on
a blog post. You can go through them on my
[Github](https://github.com/barelyhuman) if you'd like to, follow or star any
repo that you think you like.

Oh also, the weekly updates will now be on the
[barelyhuman](https://barelyhuman.dev) logs section since that's the identity
most of these tools are built under, this blog is mostly going to be posts like
these and a few educational ones when possible.

That's it for now,

Adios!
