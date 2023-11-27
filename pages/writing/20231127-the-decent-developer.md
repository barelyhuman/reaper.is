---
title: The Decent Developer
published: true
date: 27/11/2023
---

Over the years, this post has taken a different form everytime I wished to write
about it. It's been written as a guide for other developers to read through.
It's been a cry for help from a developer who wasn't able to achieve anything.
There's also was a version where I just felt I couldn't really produce any value
for anyone anyway.

I don't know if I'll publish this version either because I don't know where this
version is headed either. I never do, most of what I write here is a immediate
jot down of whatever I'm thinking. I don't know if it justifies the spelling and
grammatical errors but they are mostly because it's basically a long form
thought.

## Defining Value

A lot of what I've built over the years were based on simple ideas I wished were
accessible to people, it started off as a journey to build tiny, no nonsense
apps for everyone to use at a very low price tag or even no price tag. This
changed to building for developers since I could understand that market better
and maybe do something for them, over the last few years I've gotten down to
building for myself. The feeling of freedom when you start doing this is really
something else; this did fade for a while since I couldn't give these things
time due to my day job but I'm hoping I'll be able to change that or get it in
control over the next few months.

"What value does it provide?",that's almost always the bottom line for most
people. Does it have to though? If a problem is a niche one, I don't think I
need to build something that solves it for everyone.

You think `musync` is an app anyone needs? It's a spotify to spotify sync since
spotify doesn't like being able to share your Liked Songs as a playlist. So I
basically automated that.

A category fluid changelog generator? Nope, no one needs that either. There's at
least one version of that implementation in every programming language. A
release manager? Nope, also something every programming language provides.

What about the 100 other things I've built? Nope, there's better and more
polished versions out there.

Point being, I don't plan to provide value when I'm building for myself and most
projects built for fun do have a section that defines that it was
packaged/coded/released just for me or because I was tired of copying it around.

## Usefulness

Are they useless? Mostly no.

They do exactly the amount of work I wished for them to do. I don't stop pushing
to anything I'm building unless I feel they are able to do the basic thing I
wished for them to do. I develop MVP's of my ideas as fast as I can and then
move to other things that are blocking my work.

An example of this would be [jinks](https://github.com/barelyhuman/jinks), it's
got 15 commits and a single release, it's a simple implementation that doesn't
need more messing with, why would I keep adding or removing things from
something that's already done and working, it's API was stable the moment I
released it and has been ever since. Is it a useless library? Hell no, it's been
in production for over 2 years now.

But that raises the question, does anyone else need it? Nope, they don't. It's
not that hard to write to begin with and no senior developer writing an app with
the requirement to be able to inject links would need something like this.
They'd rather use a lexical editor's block model so they can allow editing such
descriptions.

I on the other hand wrote it for an app where I knew there wouldn't be a lexical
editor at all and it'd make no sense to add a full lexical rich text parser for
something so simple.

That brings us to the best part

## Requirement Understanding

A lot of your work as a developer is going to involve going through boring parts
and using boring software and sometimes you'll have to write targeted software
and evaluate new tech. Some developers find the latter more interesting and some
find the former a more fun thing.

One of them is more focused on enjoying what they do and one of them is focused
on completing what they have in mind and both parties are right here and have
different goals so comparing them makes no sense in the first place.

The point I wanted to make was, being a developer isn't always fun, 80% of your
time is spent thinking and predicting problems that might show up and
controlling yourself from solving them to early in the implementation. The
remaining 20% is spent thinking about variable names, which honestly isn't a fun
thing to do.

It's not a magic formula but know that a lot of what you code isn't going to
make sense to anyone else unless they understand the requirement and understand
the scope of your implementation. In which case you have 2 things that you can
do.

1. Build it for you and then document the hell out of it so people understand
   the why and what.
2. Write a super generic solution for the problem and then provide it as a
   solution so the others can extend on it.

Or there's a bonus 3rd one.

- Build it to learn, call it an experiment and then forget it. Also let people
  know that it was an experiment so they can use the code as a reference instead
  of depending on it altogether

There's more stuff that I could share but it might get controvertial if it
followed up the points I mentioned here so I'm going to break it down into
another post and publish that someday.

That's all for now in terms of growing to be decent at what you do, keep doing
it for yourself first, you can do it for others once you are happy with what you
build for yourself.

**Adios**!
