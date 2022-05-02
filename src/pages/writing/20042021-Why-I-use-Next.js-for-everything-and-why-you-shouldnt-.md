---
layout: ../../layouts/Page.astro
title: Why I use Next.js for everything and why you shouldn't!
published: true
date: 20/04/2021
---

You can directly read the summary if you'd like to avoid the explanation, [Summary](#summary)

### Context

I became a [Vercel](https://vercel.com) (formerly known as Zeit) fanboy and someone who wanted to join their team somewhere around April 2019 when I first discovered [Zeit.co](https://zeit.co) for app deployments and also found out that most of what I used in terms of libraries and even tools were actually built by them [^1]

[^1]: I used to have [Hyper](https://hyper.is) as my primary terminal, [pkg ](https://github.com/vercel/pkg) to create executable node binaries, [ms](https://www.npmjs.com/package/ms) to handle millisecond formatting and no I wasn't sponsored to say this, I actually did use all these libs a lot back then and I had already tried next.js at this point but it was still not production level as a few issues stopped me from using it for prod. Oh and there was release and also I did get inspired by their design system a few times

And I've attempted writing to them a few times in terms of joining the team but with no success of any response so I'm just going to assume it's a **No**, getting back to the point.

### Next.js

Talking about the foundational framework of TillWhen and a lot of my web apps, mini tools and also the reason I mentioned Vercel first. Vercel is responsible for the Open source framework Next.js which is a SSG (Static Site Generator) based on React much like Gatsby. The reason I picked Next.js was simple

- Easy base app scaffolding (`yarn create next-app <app-name>`)
- Don't have to add a router as the page structure defines routes (an inspiration for the [statico](https://github.com/barelyhuman/statico) generator and also [ftrouter](https://github.com/barelyhuman/ftrouter))
- In built API handlers which are written as modules and are pretty scalable if you understand how to structure the routes[^2]
- The Generated HTML works decently with or without JS unless you decide to handle routing programmatically, which you shouldn't but in case you do it might not work without JS.

[^2]: You can create a huge mess if you write long api paths and don't follow entity based standard while writing routes.

These points aren't unique to Next.js anymore but then the newer frameworks don't really offer anything significant to make me shift to them, If I had to jump out of Next.js I'd jump to Nuxt which is for Vue and just use React as is for other projects, I've given Gatsby a try but I guess I just prefer Next.js.

### Why shouldn't I use Next.js for everything like you do ?

Well, I always say that you decide on tech stack based on intention of what you are building and the target you wish to achieve while building it.

If the target is **to learn**, you're better off choosing a tech you haven't used ever. This is how you understand where the tech prevails and where it's going to be a bad option.

If you choose to **build a quick prototype**, you choose the tech you are most familiar with, this can be a really old tech and probably obsolete at this point but if you are just testing out an idea or working on seeing if the product is going to gain any traction, you still use what you know has worked for you in the past.

If you choose to **build for production**, you take the prototype or concrete requirements and figure out and experiment with tech that was built for this stuff.

_Eg:_ I built a static generator from scratch for my blog, doesn't mean I'd do it for a client. I'll pick up a battle tested (Wordpress, Ghost, etc) to be my base and hand them that, this can be a bit heavier but is a lot more stable in the long run. On the other hand while doing this you also get ideas as to how you can improve your own scratch built tools to fit more and more scenarios.

#### But you use next for everything

True, now the reason for that is most of what I build is to act as quick prototypes of a certain idea that I had or something I wish to see and re-implement just to understand what's going on in the code when a dev actually built it and if I can improve it. Good examples of this are [Hen](https://hen.reaper.im) , [Colors](https://colors.reaper.im), [Pending](pending.reaper.im), other mini tools that I've built over the years. I do use each of them but they aren't unique concepts and just exist because something from some app inspired me and I just wanted to get down and build a clone to understand it and **this is where it's fine to use a fallback default stack,** which in my case happens to be Next.js

The stack may differ for everyone. You might be a Angular + Phoenix or React + Koa or a RoR + React/Angular monolith person, doesn't matter.

**Example**

Let's take Hen into consideration here, it's a simple live preview for component code written in React.

- Do I need a SSG for this? Nope.
- Do I need an inbuilt router ? Nope.
- Do I need `n` number of imports that come with the added framework ? Nope.

I could build Hen with just vanilla JS or just React and that's more than enough. As a matter of fact Hen is built with just React, [Hen Experimental](https://github.com/barelyhuman/hen-experimental) on the other hand is the repository that holds the unstable and testing code for the original Live Preview attempt and was written in Next.js.

Point to take from this?

> **Prototype with a fallback stack and build/re-build it with the shortcomings and advantages with a stack that finds a nice middle ground**

You may or may not have to do this with every app you build but it's generally a good idea to find out what the app requirements need , build a dummy version with tech you are quick with, this can even use existing codebase from previous projects etc etc etc, you get the idea.

Again, you might not have to switch the entire stack and as the experience grows with various technologies you might not even have to build the prototype for a certain set of functionalities, you just know what will work well and what won't but to get there you'll have to experiment first and not take people's word for it (conditional but generally helps to increase your own knowledge and build an independent opinion)

### Summary

- Have a fallback stack
- Don't use it for everything and anything just because you can, unless it fits with the requirement.
- Have a **Prototype First, Production Later** mindset to make sure you build something that's a lot more scalable while avoiding monkey patching stuff in the future.
- Experiment with different technologies to build both knowledge and independent opinion, which can then help you make better decisions (I'm saying this with regards to programming, but you can apply this to life in a way as well)
