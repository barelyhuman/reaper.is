---
title: Getting Better at Development - Part 2
published: true
date: 2021-03-25
---

I've written about [getting better at development](/posts/06012020-Getting-better-at-development.html) and while I don't know what traction that post
got, It doesn't matter since I think it won't hurt to write another one

We'll be talking about a few things here,

1. Master your development environment
2. Learn to use Vim
3. Prototype

## Master your Development Environment

A very simple concept that I did write about a while ago but it was more of a rant than an explanation so let's go through it again.

Your dev environment may not be the most optimal one out there and will always have things that can be improved.

I personally depend on the terminal a lot even when my code editor can do the same tasks by adding a plugin and I should get used to using the code
editor but then there's a conflict where I change my editor quite often. I shift from Vim to Sublime, Sublime to VSCode, VSCode to Vim / Sublime,or
try a new code editor its a never ending cycle, .

While this looks like I'm going to contradict my own point, the reason to go ahead and master you environment doesn't always include mastering the
tool you use but being able to move freely and quickly through the most used things but in cases where you are using a tool a lot, make sure you go
ahead a become a power user. Why?

Let's take an example, git is very common tool today, but the max I see people use it for is

- git add
- git commit
- git push
- git clone
- git pull

That's all they know and never go curious as to what other options they have, like you don't have to go through the whole progit book or read the
entire [git-scm doc](https://git-scm.com/doc),I'll still link it in case you do want too, but at least try to figure out how much more powerful git
can be, you can manipulate history, you can manipulate commits by travelling back in time! but then people are stuck with just Pull Requests on the
Web portals instead of learning how to use patches.

And I get it , not everyone's workflow involves using all this, but everyone has been at a point where they want to not commit a file but don't know
how to unstage a file they accidentally staged, the answer is `git reset <filepath>`. or `git restore --staged <file-path>` if you've got the newer
versions.

But you wouldn't know that unless you actually went ahead and got curious about what all the tool you are using can offer. The same applies to the
code editors you use, the Database GUI's or even source control tools you use. For the longest time I've used sourcetree from atlassian for handing
projects and commits just because I like their differ UI , started using Sublime Merge because of the same reasons and the merge conflict handling of
sublime merge is amazing, though I hardly get conflicts on personal projects (cause I develop alone, not cause I'm that good!) but the tool comes
handy when working with a team from work, still I prefer going ahead and referring the git doc every now and then to see any new sub command addition
or checking what other commands I have available.

This helps me decide if I should do a normal squash or a fixup on commits in my [git workflow](/posts/20210301-Git-Workflow.html).

There's a million reasons to learn the tool properly but just take this one.

> Learn it to improve your own skills and not wait for it to become a requirement you get from projects.

## Learn to use Vim!

I really don't have to get into detail here but learn to use a terminal editor, it can be **emacs**,**vim**,**nano** anything! The same as above
applies here as well, learn how to extend the usability,learn as many keyboard shortcuts as possible, learn how to modify configs to better match your
workflow, as a minimalist I can work from just the ctrlp plugin and vim for basically everything, doesn't mean I shouldn't know what other plugins I
can add to improve usability and speed of dev.

A coder with a good typing speed is definitely a plus but that and being able to move around vim/emacs like it's no big deal for you to manipulate
text is an amazing skill to have, you might get a lot faster by being able to just do that.

Two simple reasons to learn on the above.

- almost all environments have one of them available
  - grub boot editor has base emacs
  - vi/vim is available on all linux setups, whether you install it or not it's most likely in the base package
  - nano is available for most sub-set linux utilities and a lot more beginner friendly if vim is too scary
- they help you think in patterns
  - once you start using vim macros, you start thinking in the sense as to what can be done to do this task just once. When you get better with the
    keyboard shortcuts you can get to a point where you will finally understand that insert mode isn't really needed to manipulate existing text

## Prototype

Enough about tools and things to learn, let's see how you can improve your project building mentality. The simple answer is prototype it.

The detailed version though.

Build something with the sole purpose of testing the idea, not with the mentality of perfecting it. This is to

- test out if the thought or idea you had is possible
- is there something limiting or blocking it
- is there actually a blocker in terms of requirement, that you didn't think of while plotting the idea, there's often times that you realise that
  something you wanted to build requires more features than you thought initially.

All these come naturally once you have written a prototype version, where things aren't built to be perfect but to test the idea. You can also test
the market if you've built something that doesn't exist out there and you want to check the attention, again doesn't have to be perfect it's a
prototype after all.

The point is, now after building this, you have enough idea as to things that are required, things that work, things that are iffy and conflicts in
thought that you need to be aware off and finally the base scope of the project is now crystal clear.

Next Step? Rebuild it from scratch while keeping everything in mind or refactor the code to match all of this, both these approaches have their own
issues.

### Refactor

We'll start with the easier one, refactoring the code to now be well structured and you **add or remove services,tech,code** to accommodate the new
requirements and be a little more robust for later expansion, if you've been doing this enough, chances are the initial prototype already followed
your general scalability in mind and this is a very easy phase for you.

Chances are you already knew that the language you are using is perfect for the usecase and you have a good idea of what is needed from the start and
the additional requirements you figured while building are just hiccups and not a huge pain to fix.

### Starting from Scratch

This is hard to do for a lot of people but you can always start from scratch once you are done with the prototype though this approach needs you to
make sure you understand why are you starting from scratch?

- There's a better tech that can handle the work you've done ?
- Need to change the language all together?
- It's easier to re-write than patch broken stuff?

If you say yes to two or more of the above, it's better to start from scratch.

If there's a better stack for it you should definitely pick it up and setup a solid base for the project , which will be good for the long run. If you
need to change the language all together, then well it's easier that writing interop code that will need a lot more maintenance while you're doing the
migration plus you end up breaking and fixing a lot more than needed.

A lot of devs wouldn't want to start from scratch because

1. It's boring to do it again
2. You can do it with well thought out refactoring(could get hectic in a very big project)

Either way, use your best judgement or ask people for an opinion on what they would've done, the point is, always prototype before building the real
thing and know that you might have to scratch it or heavily refactor it to make it a polished product which can then be pushed into the market.

A non-prototyped product is going to have more failure points and patches than one that was built again while keeping all of it in mind.

Keep an open mind to learning and that's about it for now.

Adios!
