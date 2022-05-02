---
layout: ../../layouts/Page.astro
title: Building stuff you don't like
date: 20-09-2020
published: true
---

I've advocated working on projects that you'd like to learn to build and also projects that you think you'll use, in the past but then there's another category of projects that exist. The ones we don't like. Now, it should pretty obvious that this category is pretty dense.

This can have projects that you don't like at all and also projects that you think you'll like to do but then end up deciding otherwise because you either lost confidence in the project or to be precise hit with the realisation that there's a similar project that's built a lot better than you ever can.

This is quite common with me and let's see the solutions I've discovered.

Let's start with projects you don't like at all. I'd say just put them in a project bucket list and don't touch them for now, we might approach these when we think we are out of ideas to build something.

Now to the projects that we started but then left them half baked.

I can always bring in TillWhen as an example here but I won't this time. I will link you to it though. [TillWhen - Just a Time Tracker](https://tillwhen.barelyhuman.dev)

So let's see, how can I explain this without sounding like a jerk, which is very hard to do.

It's okay to drop projects in the middle and the main culprit most of the times is the amount of effort you have to put into the project. At least after my research on how **I drop projects**, the general process I follow when dealing with an idea is to note it down somewhere with the set of MVP Features that I'd need.

The next step is to start the project and decide the stack for it, and this part takes a good amount of time because now I have 2 options, use something new to learn it and then use something that's been setup properly already and use that instead.

After deciding the above, I end up either creating a project or dumping a project based on two factors.

- Nature of the Project
- Time of acceptance

## Nature of Project

Now this is very simple, if the project is more for experimenting, then the new stack, new arch approach works really well and I learn a few things but most commonly end up dropping the project when the new stack creates more problems than required. It's not that the stack can't handle the issue , its the amount of work I'd have to put to fix something small that I could've solved with a stack I'm used to.

If I take up a project that's supposed to be a proper product and be released then using a new stack and experimenting with it will be a bad idea because I know I'll loose interest because of the above point.

On the other hand, if you want to try building a small addition then don't start from scratch and try adding that addition to an existing product to see how it works out and do it on a different branch of your git or version control workflow , so you don't have to commit to the new experimental addition.

## Time of Acceptance

I'm the kind of guy who likes to work on projects that put up a challenge, a simple CRUD app to manage team projects is not a challenge at all but I ended up trying to build one and have been forcefully pushing myself to build it.

This whole post is a way to just remind me that it's okay to drop the project. But, I also have to realise that not all projects that are out there can be left this way.

I should focus on extending existing projects and maybe even work on integrating different projects with each other. This is where Time of acceptance comes into play. This differs from project to project but there's a general average you can find out. Mine is 3 days. If I can't build an MVP in 3 days you can forget that project. There's no way I'm going to work on it for more than that unless it's a challenging issue and I'd like to break my head longer.

Simply put, Time of Acceptance is basically the amount of time people take to accept that this project is not worth it anymore, and this can be a subconscious decision and this might take longer for the conscious to realise.

## Avoiding Half Baked Projects

It's good to try new stacks, new arch, building new arch and also trying out new languages but when you are forced to build a minor part of a production project into a new stack it can be quite daunting and push you away from it, so as I mentioned in a few posts back, have a default stack that you fall to for building production apps and only try new stacks on something small that you've already built so you know the parts that need attention and then you can look at how that language would handle that issue or how the new stack makes it harder or easier for you to approach it.

If I would've done the project management app in an existing setup stack with login, tab, and other architecture and cosmetics figured out, I would've built it in a few hours but since I've been slacking off the whole thing on trying out new languages , trying out new database schema designing techniques , the project is just a huge experiment.

And that's mainly because It wasn't started with the honest mentality to actually be a product for the people, it started as an experiment and is going to be left out to be one.

The only way to avoid this from happening is to avoid the effort you put into building it. Use generators, use project templates and/or tools that already do something you are trying to do. Like, can a telegram bot achieve this, can I use an existing program and just integrate with it to make it easier.

Like if building JARVIS is something you'd like to do then start with an existing NLP engine and use that instead of going crazy like me and attempting to build an NLP engine from scratch. While the latter would help you learn about processing text efficiently and data structures to help you work with huge amounts of existing buffers of data to figure out what the entered text meant but then that's about it. You could've just read about it for future references but no, you decided to build it again because using Facebook's Wit.AI wasn't a good option back then.

Most products you see from huge companies are built well because there was a team who was paid to dedicatedly work on it and you have the option to jump from project to project and that'll always get in the way unless you have a razor sharp focus, which I don't.

Also, the solutions provided above are all with respect to people who work as solo developers and are building things because they think it's fun and don't really expect a return from it.

Proof of this? TillWhen

The donation button there is just a small add-on that I don't even expect people to use. It's there on the website as a formality.

The UX was so intentionally decided that I put the page outside the actual app environment, you can't see it till you actually logout. I didn't really want people to pay for something like a time tracker and just added that so if there's someone who'd like to help the developer, they could.

I do update TillWhen and add improvements for performance and stuff but that's because I can see TillWhen growing, not at a very high pace but it's cool and that acts as a return for me.

On the whole, your side projects can turn into disasters and it's okay.

You can end up not wanting to complete them and that's okay too.

To solve it though, use smart arch decisions to reduce your **initial** work for the prototype.

Don't try building everything from scratch for something that you might not even work on from a few days from now.

but!

This doesn't mean you will not try out new languages, tech stacks, etc. Have dedicated projects that you'd build with during the learning process so it doesn't effect a potentially good project that you could've built.

#### Examples of this?

A music player, a todo app, a god damn random colour hex generator if you want.

Now these projects are small enough to be built in a few days or maybe even hours but the point is they are easy and that gives you time to learn something new and/or experiment with.

I needed to figure out ways to handle ACLs better and I created a whole project for it when I could've just tested it on an older project on a dummy branch and this stupid decision to build the whole base arch contributes to this post just as much as the project management app that I talked about in the first few paragraphs.

That's it for this one

Adios.
