---
title: Browsers and Code Editors
date: 2020-08-23T11:09:52.181Z
published: true
---

There was a hint in the previous [post](/posts/off-grid-digitally.html) where I
mentioned I'd be building a lot of the tools that I use from the ground up and
since I normally build stuff with my requirements in mind they turn out to be
very minimal.

A lot of stuff that I've built is either tied to this website or you can find it
on the [work](https://reaper.is/work) page and I was told that in my idea of
reinventing the wheel for almost all tools was stupid but also interesting but
mostly stupid .

While I agree to that, and you shouldn't be reinventing the wheel when working
on production apps for clients , it's okay if you are doing it to learn. I
consider myself really lucky that I've got all these resources out there that I
can learn from and it actually makes it easier to find better explanation to
stuff if the man page or documentation of a certain library or tool isn't well
documented.

## How's you learning going to be helpful to us?

It won't. You might not be a fan of the minimal approach to things but if you
are , you might have another option to choose for when choosing code editors. I
still VIM is the best there is but then that's just my opinion.

If someone has observed the pattern of my repositories, you'd notice the things
I've built or have forked to go through are for building a code editor. If
unclear let me guide you through the mini-tools I've rebuilt.

- Apex (Mini Web Code Editor)
- Mark (Markdown Editor)
- Snips (My goto code snippets)
- Hen | Hen-Experimental (React Code playground)
- Nova (my half baked attempt at the code editor)

and the forks include

- Atom (For learning how they structured the modular approach)
- Carbon (to figure out how the syntax highlighting was working, should've just
  inspected and I'd know it was codemirror but then I went through a few other
  things like global config and a few nice ideas for better maintainability). I
  might have delete this fork though, don't remember.

Obviously no one is that observant but it's been going on for a while. I also
wanted to take on building a browser but I'll get to why I didn't later in the
post.

The above minitools each have attempts of figuring out how I could abstract each
part of the final code editor into modules of its own thus making the final
editor a lot more pluggable with various tools and to get a basic understanding
of how plugins can be made a lot more scalable.

Apex takes on adding tabspaces etc to an existing textarea on the web which
isn't that helpful when you build the editor using something like Go Lang, but I
just wanted to see how the syntax highlighter actually worked, and yes, I did go
through codemirror and primjs's codebases to see how they were doing it and work
on improving where I could.

Mark on the other hand was a failure because I didn't really complete it to the
point that I wanted to. I wanted it to be like a wysiwyg editor where the
markdown would update as you typed and reflected in the same editing space
something like Typora, but I never went ahead with the idea and instead left it
out there like every other web based markdown editor. So, technically didn't
learn much from it but was still in the right direction so I'm going to give it
a break.

Similary, Hen and Snips were experiments to figure out visualisation methods and
while doing that I added a Mini playground for react components. Took 2
approaches to make it , one with iframe and one with a contained div , though I
think the iframe approach would be a lot more secure but either way, I've got
helper code for both now.

## That's slow.

It is, yes. That's also the reason why I didn't really try making a browser.
Even though there are terminal based options out there that I do like using but,
I like the dev tools experience of Firefox and so it's hard for me to actually
think about building one right now with a day job.

Building both a browser and a code editor in parallel would get me burnt out in
no time but don't worry, there will be a day when I attempt making a browser.

Also, it's going to be slow because

1. I'm not making it to earn from it and only making it because it helps me
   learn and as a result there might be one more editor for people to use.
2. Expecting to live off of donations is very ambitious thing to do, unless you
   build something really useful which doesn't happen everyday, at least not for
   me. I rarely have good ideas for products.
3. If I do build this in a hurry, I won't be satisfied with the result and won't
   use it and the project will sink down in my git repositories like other
   abandoned projects that I thought I'd waste time building.

```
Tip: For people who are expecting to earn via Open Source,
your best bet is to go the Open Core way which a
lot of Open Source purists won't like and the
other one is to offer managed services
while giving away a self hosted solution for free.
Gitlab, SourceHut, Mongo, you get the idea.
```

## What's wrong with the current ones?

Oh there's nothing wrong with the current ones. As I said I like building these
things both to learn and to have my own take on something as solution and try to
not kill the ram. And to think I was going to build it with Electron was the
first mistake but I have a better approach now, it's a very old one but still
the best way to go through building desktop tools in my opinion.

The requirements for the editor though,are very minimal and the existing
solutions. Atom, VSCode, end up offering a lot more that I'm every going to use.
I'm not kidding, I made a post long back about my
[vscode setup](/posts/my-vscode.html) and I've gotten rid of the other themes
and only using Min Theme now and don't even have polacode and music time
anymore. Also, Sublime and VIM are great alternative and I do use them right now
more than I use VSCode. I still want to try building one.

To sum it up, this is all I want

- Bracket Matching
- Syntax highlighting(optional but nice to have it)
- Decent Duo Tone or Monochromatic Dark/Light theme

Why don't I use any other plugins? Well basically because I have everything else
handled by tools that run when i commit or are setup to run as a github action.

My linters run during commit, formatters run during commit and also as a github
action to make sure all files are formatted and not just the ones that were just
staged and I sometimes directly edit from Github's web editor so those changes
are formatted for me automatically from the action.

Stuff like this doesn't need to be done in realtime because I've been coding for
a long time now and silly mistakes like typos and all are rectified during
testing. You'll still see a lot of `typo` messages in my commits because I
commit the functionality before I test it and then add fixes as their own
separate commit. I like being verbose about the mistakes I made.

Anyway, building an editor with just the above 2 functionalities should be
simple right? Well that's the thing, I tried doing it with Nova with 0 knowledge
of how large amounts of text buffers are to be handled and what data structures
i was supposed to use and that botched the project before I even started and
that's when I went the route of building every module slowly and understanding
things I need to learn and think about before going ahead and jumping into
building it.

Don't worry, you'll get updates of my progress with it after I'm done with
`dark` which is the current project I'm working on. Haven't really told anyone
on what's it's going to be but I will once I have an mvp ready for it.

Adios.
