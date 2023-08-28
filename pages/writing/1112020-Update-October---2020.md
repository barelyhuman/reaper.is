---
title: Update October - 2020
date: 1/11/2020
published: true
---

Yeah, I haven't posted in quite sometime and really don't have anything that I'd like you to know from me at this point but this update is just a
chore.

We'll be going over things regarding

- TillWhen - Time Tracker
- Pending - Kanban Board / To be Project Tracker
- A bit about what's up with me

### TillWhen

First Time reader? TillWhen is a time tracker that was built as an alternative to the pricey time trackers out there and would like to be simple
unless someone requests for some crazy cool feature which I'm not sure if I'll build or not but for now, it's simple.

Whats the Update? It now has a beta version of Tasks added to it, so you don't have to use another tool to manage your tasks based on Projects and
it's **Beta** because I still haven't added project based filters and a per task time logger.

#### Project Based Filters

Simple filters that'll help you segregate between tasks for specific projects, pretty simple feature but I haven't pushed it into the live version
yet.

#### Per Task Time Logger

So, there's a dilemma for this feature, should I add them as time trackers per task or should I just redirect the user to the time logger and then
follow the normal flow. The per task one will allow users to have multiple tasks being run simultaneously which would be nice , since I never actually
am doing just one task at a time but then the amount of timers running on the page can slow down on certain older browsers and I wouldn't wanna do
that so this feature is still under consideration.

There's no roadmap to TillWhen but a much awaited feature would be a **bot** for the tillwhen that you could integrate into **slack** and **telegram**
and that's something I plan on doing soon. The Telegram version is under tests and was quite easy to go about,I haven't built a slack bot before so
will have to go through that soon.

### Pending

I doubt that anyone knows about the existence of [Pending(Now shut down)](https://pending.reaper.im) mainly because I never really talked about it but it's a simple
Kanban board at this point. The reason it's in this update is that Pending will be getting a overhaul soon.

It was meant to be a browser based storage but getting the peer to peer data sharing was something that would create friction for normal users and
that's something I didn't want. I mean having people store their project data offline and on their system is fine but it normally involves a team and
thus the requirement of a distributed/central server. I wanted to go the distributed route but I'll start with a central arch because It'll be easier
to start with.

**TLDR;**

Pending is going to turn into a basecamp like central project board instead of being just a browser storage kanban board.

### What's Up with You?

Not much actually, got better at Go, going through the documentation of [Gio](https://gioui.org/) to be able to build decent GUI apps with Go and then
maybe build something small to test the waters.

Also, planning to move towards building system level tooling and get into kernels and build tools so I can leave Web Development to be just a part of
the skillset and not the whole skillset. Kinda tired of frontend development for a now, really into CLI tools and that's probably because I use the
terminal more than I use the GUI apps.

Experimenting with moving the [Music](http://music.barelyhuman.xyz) to be have a cli version so I don't have to open the browser , because the browsers take a lot
more RAM than needed.

A few apps that I switched to, to save some RAM.

- Chrome to Safari (increased battery life...)
- VS Code to Sublime (People use Vim without any plugins, it's not that hard to change back to something as fast as sublime)
- Source Tree / Sublime Merge - I use them alternatively, normally have source tree open but sometimes I use sublime merge for bigger files. This was
  added to arsenal because I got rid of VS Code. Both Apps Combined don't use as much RAM.
- Hyper to iTerm
- Postico from Table Plus (not much of a memory usage difference but I just don't like the bothering pop up from Table Plus every time I try to open a
  new Tab, replace the existing tab instead of bugging the user?)

The search for good cross platform GUI has ended, Gio as I mentioned above but since I'm still learning, it'll take time to get used too. Another good
option is [V Lang](https://vlang.io/) that comes with a ui package that is still in alpha phase but is decent for GUI apps. The language itself is
pretty easy to learn but I'm going to wait for the package to mature a bit more. For people who don't want to learn a new language then your options
include `libui` bindings for your specific language, it's pretty limited in terms of usable widgets but can get the job done.

That's about it from me

Adios!
