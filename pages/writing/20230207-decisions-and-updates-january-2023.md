---
title: Updates and Decisions January - 2023
published: true
date: 07/02/2023
---

Time as always seems to be moving pretty fast and one more month vanished into
thin year.

To the updates, ~~forks~~ folks.

## Personal

Started with giving a little more time for another hobby, the guitar started
gaining a bit of attention again, no idea how long that's going to last though.

## Dev

Back to what I normally write about, development and shit.

### Module Engine / App Engine / whatever you'd like to call it

Most amount of time was spent on the app-engine/module-loader whatever you wish
to call it, that was mentioned in one of my previous posts.

A version of this was added inline in the
[barelyhuman/preact-ssr-starter](https://github.com/barelyhuman/preact-ssr-starter)
project in case someone wishes to understand the usecase.

For others, it's a simple module loading engine, and a pretty verbose one if you
ask me, people who work with plugins would understand the requirement pretty
quickly but the idea is to make sure I can inject data / functionality into a
dumb object and then use this anywhere the dumb object is imported.

A helper library for the above was also written, called
[barelyhuman/typeable](https://github.com/barelyhuman/typeable) and the point of
this was to be able to generate types on runtime for the above engine so that if
you have different modules adding different properties, there's at the very
least some way to figure out what properties already exist on the instance and
since it is generated as an ambient type file you can import is with JSDoc and
take advantage of this even in older projects with no typescript or if you are
like me and try to avoid typescript but like the intellisense.

### Preact SSR

Yeah, Astro exists, NextJS exists, this, that, whatever!

I enjoy all that and I've build at least one thing with each of these
frameworks. They are greate projects and provide great developer experience but
most of it is really dependent on either one person's decision or a community's
judgment of what is supposed to be "standard" and so it get's hard when that
changes over time and we've had one such incident with react already like I
mentioned in [Modern React, is a mess.](/writing/20220817-modern-react-a-mess)

Either way, you end up having to either lock you codebase to a certain version
to stick to your expectation of the framework or fight the update's breaking
changes till everything "just works".

The whole thing is based on a small trigger where next 13 and react 18 are no
more compatible with preact.

This is what delayed the tillwhen update cause I was fighting the decision of
whether to update or leave tillwhen at the version it was. The older version of
Tillwhen was using `preact/compat` to minimize the overall bundle size and it
did effect the page load times on slower browsers and network quite a bit.

Tillwhen's page load size was now in danger. The app has 250+ users and while
that count might not mean much to you but then the point is that the page load
time would increase for lower network areas and I would like to avoid that.

The preact team may or may not work on the compat this time, and that makes
sense cause to be fair it's like a cat chasing a laser at this point.

Either way, I had to move it up to next 13 for the simple reason of not having
to break my head later when the breaking changes are more and the update process
gets even more tedious, so better now than later.

This is where the SSR template came into place.

There are other templates, but then I didn't really feel like using any, I
wanted one that was simpler to modify and work with and I wanted to make sure if
I ever get time to migrate Tillwhen from NextJS to this, at least the
functionality and pages could be copy pasted with little to no modifications.

Ended up combining a few things I've written before and shoved it down one
repository that you can clone and modify every inch and is built over tiny tools
and libs working with each other so you can remove and add a new one if needed.

Ex: I replaced express with polka in that repository in ~15 minutes.

You can check it out here
[barelyhuman/preact-ssr-starter](https://github.com/barelyhuman/preact-ssr-starter)

### TillWhen

No major update in the actual application other than a color scheme change and I
finally made the UI components a lot more consistent overall and got rid of a
few extra chunks of code (~ 30K lines).

It was fun to delete stuff that wasn't being used and added to the complexity
for no reason.

It was also getting hard to keep track of where the cleaned up code and
libraries were so I ended up writing all the rewritten lib functions and sdks in
coffeescript so it was easier to locate them and then I could restructure the
folders for them.

Compiled these files as normal javascript and that was a little brain hack I
wanted to share.

I should probably look for a tiny language that compiles to javascript but only
has one way to do things intead of 10 different ways to do stuff in JS and
coffeescript, would simplify the decision cycle people like me end up in.

### Editor Switch

Ah , this has happened so many times that It's basically a joke at this point
but we went down to VIM and sublime again. Slowly switched the editor to be
Sublime Text again because RAM issues. (No i'm not getting a new laptop with
extra RAM, not a solution!)

And VIM, cause while I have a neovim installed and all configured, I deal with
remote systems a lot and it's easier to copy my one file config and let it auto
setup everything as compared to waiting for neovim to load everything, though I
can probably create a single file configuration for neovim as well... will do
that someday for now it's just 2 commands

```sh
sudo apt install vim ripgrep
# or
brew vim ripgrep

curl -sf https://gist.githubusercontent.com/barelyhuman/16285b2195cfd25d8c84356676cc807d/raw/3770a3f039aca45a4ad91102eafc03dcfc8606cb/.vimrc > .vimrc

```

and just start vim and it'll handle the setup for me

Again, it's just something I was already comfortable with so I did that, if you
have a single file neovim setup similar to this, I would like to know and try it
out.

### Sad Shit

> idk man you’re gonna have people coming at you with pitchforks if you don’t
> finish preact-native 😉 ~ [mvllow](https://mellow.dev/)

So um, I'm thinking on sunsetting the idea due to my own incapbility to manage
time and multiple projects but as always, the project remains as is, you are
free to fork and use the base if needed, that's the whole point of open source
in the first place.

But it was a fun project nonetheless, The main reason for this decision is
because of the continous changes going on in the react and react native
repository itself making it hard to keep track as to what is the correct way to
do things. It's a similar issue to why it's so hard for people to write new
Typescript compilers. Ever changing source of truth.

The better way out might be for me to write JS - iOS View SDK and JS - Android
View SDK from scratch, not sure if I'm capable enough to pick something that
huge but if I do, you'll know. Either way, I think I'll have find ways to get
Nativescript to suffice my requirements in the future.

That's about it, for now.

Adios!
