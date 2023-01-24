---
title: commitlog - A recap
published: false
date: 24/01/2023
---

It's been about 2 years since I wrote [commitlog#b0f1b1d2bc4265cb72b70b3ae5b60f8e65f47b12](https://github.com/barelyhuman/commitlog/commit/b0f1b1d2bc4265cb72b70b3ae5b60f8e65f47b12) and it's gone through a few changes from when it was first written.

The post basically goes through things learnt during these additions.

## Reasoning

The reason is same as what's written on the README, I built it as a replacement to commitlint and commitlint-changelog generator but for all languages. Since, I worked with quite a few languages and this was my first project in golang.

As expected, the initial codebase was a mess and since it was my first project I did request for a review from other gophers over reddit. This got the initial 2 Merge / Pull Requests that corrected a few things.

## The Initial idea and feature(s)

The initial feature set was singular.

- Generate a categorized log based loosely based on the commitlint standards.

Specifically since I did follow the commitlint standards a bit.

The CLI basically used system level git bindings thanks to [go-git](https://github.com/go-git/go-git) and built a categorizer that output stuff in markdown.

## Growth

### v0.X

This moved up to being able to handle git revisions, handling reference names similar to git's own sub-commands and tag based separation. A few short codes were also added to help you specifically define what the range of commits would be.

The next addition was release management since that was also something that differed between languages and I'd like something simple that handled it
all.

This is where `.commitlog.release` entered the picture and at this point most of projects use this for maintaining versions

### v2

Over time, my usage of commitlint standards went down and using the generalised categorization was something I rarely used, but I understood the need for it. This is where v2 enters with the following changes.

- ability to define custom categorization patterns , can be scaled to support monorepos
- ability to handle the semver versioning spec
- better handling of git revisions
- removed all the fluff from the previous version
- a lot more structure to the codebase
- the package is simpler in terms of being used programmatically, if needed

All these don't seem like much but since these were all added slowly, they were done properly.

## Lessons

- People prefer CLI to handle most of everything for them without having to pass options and this is where v2 failed since it added an additional step to be able to do the categorization.
- Dumping your idea down and being able to consistently maintain it is easier when you use the tool everyday.
- A good CLI is a silent one. Being able to turn on verbose mode is definitely required but it's a lot more important for the CLI to not spam the terminal unless asked for.

And the advice I always give, _**build something you enjoy building**_, people liking it is the last thing you need to worry about. Unless you're building a business out of it, then definitely try to get people to like it but I'm not that smart in that area so you might want to look for someone else for tips on that.

## Future

There's no reason for me to stop using it.

I did feel like I'd need something for monorepo and should add monorepo support to it but it can already generate logs for monorepos if you maintain a standard for writing commits per package, then you can kinda already do `commitlog -g --categories='feat(commitlog):,fix(commitlog)'` and it should lay out the commits that start with `feat(commitlog)` and `fix(commitlog)` for you. It's that simple. If you have categorized your commits then well you do need specific monorepo tools that handle more context based on the languages they support. Commitlog tries not to tie itself to a specific language so it makes no sense for me to add contextual categorization.

You are always free to fork and add that if you do think it's something you wish to do. It's licensed MIT for that very reason.

As for maintenance and fixes to the project, there's always tiny knick knacks that happen while I'm using it and I do tend to fix them locally first and the releases you see is normaly about a few months later when I'm sure of that thing working as expected.

Either way, if you do start using it for some reason, do raise an issue for anything that you think needs to be fixed.

That's all for now I guess,

Adios!
