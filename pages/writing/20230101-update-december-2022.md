---
title: Decisions and Updates December 2022
date: 01/01/2023
---

**Happy New Year** humans!

Honestly, haven't done much this entire month and to be fair, I almost gave up on development and coding altogether for a while.

It has nothing to do with getting overwhelmed but for once I just forgot the whole reason I wrote code in the first place. I started comparing myself
to not be enough for whatever I was doing and not being useful to anyone and this was my mental state for a week or so.

This isn't fun when you start getting impressed by everything that others have built but then you see whatever you've built isn't as impressive.

The **reset** for all of this was basically me remembering I had to update one of my packages to implement something that was to be done a while back
and just started working on it and while doing it I forgot about all the inadequate work I've done.

Partly because most of that package deals with color conversions and maths so I had no time to think about whether I was useless or useful, I was too
busy getting the functionality to work.

So, here's the decisions and updates for the past month.

### @barelyhuman/tocolor

Worked on updates for the L\*a\*b\* color variants and XYZ color variants. The base implementations are done but the documentation is still something
I need to update for it, so it's on the `next` tag on `npm` right now.

### typeapi

A simple typescript based website, that can simply list the exported types and functions from a node package.

This was built for `@barelyhuman/tocolor` since I am writing stuff in typescript, I wanted to reuse the exported types data.

[Example API Reference for @barelyhuman/tocolor](https://typeapi.barelyhuman.dev/package/@barelyhuman/tocolor@next)

This isn't open source right now, cause it's not up to the MVP stage yet and I'm still working on it. It cannot handle relative exports and everything
yet and I still have to add all of that but this is something that's usable for most tiny libraries that export all types in one file.

---

Other minor stuff that I need to complete now is the libraries that I normally contribute to, which were also pushed back due to the aforementioned
stuff.
