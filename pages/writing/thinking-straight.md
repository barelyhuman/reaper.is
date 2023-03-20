---
title: What I do when I can't think straight.
date: 2020-06-22 13:32:20
published: true
---

I assume that I'm not the only one who has moments like these where it's hard to come to a concrete decision.

I can only talk as a developer and I have these moments where I'd like to build something but I start overplanning to avoid all short comings so much
so, that I end up with a dilemma. Should I start the project or is a waste of time?

I rember posting a contradicting article , titled
["Make it, just to get it out of your head"](https://blog.siddharthgelera.com/2020/04/21/get-it-out-of-your-head/). But this scenario is a little
different, because I did start making what I wanted too but the decisions I had to go through to make sure it doesn't fall were too much to handle.

### How do I handle it ?

The solution I use isn't something I'm sure about since it works for me, might not work for you but you can take the general idea into consideration.

**Let's redefine the problem, I can't think straight about a new project that I want to build, due to which I'm unable to write any code or even setup
the architechture to start it off.**

At this point, my general thought process goes down the negative loop hole of _you just aren't good enough_ what I forget to add to that statement is
_"yet"_ , that one word creates a difference in thinking but when you've already lost control such simple things don't come to mind. It's very easy
for motivational speakers to use the `do this when this happens` kind of talk, and I myself say that and I realise how wrong that is.

So, I can't think straight and I can't tell my brain to chill out either, **what do I do now?**, Do something else.

### Trick your brain

Yeah, you read it right. I end up doing something that I'm already good at. Obviously, it's not the first thought that comes to mind but since I've
done it so many times it's more of a habit that I just instantly switch to doing it than wait for my brain to calm down.

Obviously, not everyone has been doing it so let's go back to when I couldn't do this. I'd spend over 2-3 hours just getting back to normal while my
brain kept thinking about what programming language should I use to build this, what framework makes more sense, this will make it a larger app, this
will make it use more ram, but then this will break, this won't work for people with slower computers, etc, etc, etc.

There's no stopping my overthinking cycle when it gets out of control and the only way to slow it down to the point where I can at least think a
little more logically is blasting music at the loudest volumes in my ear drums and even that works only if I'm in the mood to listen to that genre.

#### Give me the solution already!

As mentioned before, this might work only for me but the solution is singing to music while trying to calm the brain down and then build something
I've already built before and rebuild it.

**How can you replicate that?**

Start off with an attempt to calm yourself down. This can involve music, working out, sleeping, looking at the ceiling for the next 30 mins, anything,
anything that works for you (Sadly, you'll have to figure this out).

Once you're done with that , we can move to stage 2, doing something we are already good at. Draw something you already did, sing a song you know,
code something you've coded multiple times before. The idea is to let yourself feel that slight comfort that you can build and improve on stuff that
you've done before.

### Example

I've wanted to build a `postgres` client for all platforms but I wanted to avoid using electron and building it with C++ will take me time since I'll
have to learn a lot before I start actually building the application and I wanted the RAM usage and the total size of the app to be on the lower end
of the scale which is never the case with Electron and I ended up going round and round around such points and ended with nothing.

#### What I rebuilt.

I've been thinking about improving [Orion](https://orion.barelyhuman.dev/) , a music player I built years ago but I never did anything because it
worked well and didn't need any changes functionality wise. But, I didn't really like the design and have been wanting to change it but didn't because
I kept myself busy on building new stuff.

Finally, Trashed the previous code of [Orion](https://music.reaper.im) and rewrote it properly this time, removing all amateur coding standards I used
back then. Changed the design to a new level of minimalism and voila!

While I was at it, I wanted to test a file tree based router I wrote and ended up rewriting the server side of it as well. Replaced Express with
[Routex](https://github.com/barelyhuman/routex).

#### Sane Thinking and Final Decision

After this was all done , I just decided I'd go with my usual choice of [Electron-Vue](https://simulatedgreg.gitbooks.io/electron-vue/en/) and use it
for the builds. If [Hyper](https://hyper.is) can compete with iTerm in terms of memory management then so can I. The size of the app though, will have
to figure that out. I normally try avoid external dependencies so I might be able to get away with it and keep the total app sized in the range of
60-100MB.

### TLDR;

1. Reduce the Overthinking Cycle with whatever works for you

2. Do something you are already good at, it can be anything. gaming, singing, dancing, drawing.

3. Try taking a decision at this point if you get back in to the overthinking loop, start again from step 1.
