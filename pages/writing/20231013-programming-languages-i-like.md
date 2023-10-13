---
title: Programming Languages I like
date: 13/10/2023
published: true
---

> **Disclaimer**: Not going to declare a "best programming language" here, you
> can find that drama pretty much all over the web

If you don't know me, short context about stuff I do when I'm bored. I pick up
existing simpler projects that I can find or have built before and then build it
again in another programming language that seems interesting. A lot of these
projects are things you can build as well, so I don't need to go deep into these
but this is just a list of languages that've stuck around for more than a "Hello
World" project.

### One's that stuck

For the one's that don't need a story.

- [Go Lang](https://go.dev/)
- JS
- [Nim Lang](https://nim-lang.org/)

Now for the others,

I'm someone who started with writing `cat` and `ls` clone programs in C lang in
school as practice, because it was a part of our curriculum (not because I was
some genius in school). That just stuck to me for some reason, I liked picking
up hobbies cause they were fun. I tried origami, drawing, Plaster of Paris based
pottery, etc etc.

Programming was one of the hobbies I picked up really quickly (also
surprisingly, something I'm still doing...); Anyway, picked up Python next and
then a little bit of Java. There's no reason to mark them as bad languages, I
just don't like OOP so Java is something I've never picked up again. Python
though, I did do some GUI work with Python for college mini project and then one
of the Dev's of the Numix Theme group, just convinced me to write the whole
thing in Electron again.

And since then I've been shoveling down the rabbit hole even after it ended.

#### JS is your primary language?

Nah, JS stuck because of the number of available jobs, pure and simple. A lot of
jobs in India needed `react` and `AngularJS 1.6` developers when I got out of
college. I started doing react and picked up Angular for a tiny startup that I
was working with (~2017). Post that, it's just been react and more react and a
lot more angular and some more react and that lead to fighting with Typescript
and Javascript's quirks every day for almost 3 years day in and day out.

Think of it as a language that started as a skill to earn and stuck because I
went too deep into it.

Then comes the time where I wished to do a little more in terms of Open source
and instead of just browsing through, I'd like to contribute and I didn't know
which project to contribute to, so I just made my own. I really liked Linux and
CLI tools because they worked everywhere!

As long as you have a terminal, you can run the app/tool/software. I started
doing this with C because the hackers online told me that it'd be easier to
write portable CLI on C. Wrote a few of these but writing the base layer for C
is actually a lot of work. Though, after you're done with that, you pretty much
can do whatever you wish to with it.

Anyway, the goal was to find another language where I could avoid writing the
base layer and still find a good std lib to work with. This is where Zig, V, Go,
and Nim Lang came into picture.

I worked with tiny apps before building something serious and here's what the
result was.

- Zig
  - Verbose
  - Straightforward flow
  - the std lib could be a little more intuitive. Haven't tested again in the
    past 2 years, so this is from my experience in 2019)
  - There was no package manager back then and it took a lot of looking for good
    libraries when working with it.
- Go
  - Straightforward flow
  - Really great standard library
  - The straightforward flow goes to hell when working with channels or anything
    concurrency related, which is technically a problem with most languages and
    hard to simplify, so understandable
  - I wish the versioning didn't need a new module path, once you release
    something greater than version 1
- V Lang
  - Very close in terms of syntax to Go
  - A lot simpler, since it doesn't allow you to do one thing in 100 different
    ways.
  - The ecosystem is highly productive
- Nim Lang
  - Loved the syntax, cause it reminded me of Python but with typescript
  - Really dense standard library
  - A good package manager, one of the problems of working with C was to figure
    out what libs are available on what operating systems
  - Easy to complicate with macros but not always needed.

Out of these, Go and Nim stuck with me due 2 reasons, that aren't listed here.

- Binary Size
- Compilation Ease

Zig is also something that falls in those points but I wasn't a fan of the
verbosity, since I could just write C and it's simpler that way. Personal
preference, I'd recommend you try the language yourself to decide if you like
the language.

I'm by no means a master of any of these languages, I've worked with JS enough
to know how to deal with it's quirks without having to rely on TS but I still
use TS where applicable so that users can enjoy using libraries in their
Code/Development Editors.

### Bonus Languages

These are languages that I like but didn't really make it into the list of my
first choices.

- Ruby
  - I use it to write Fastfile's in fastlane and also any custom behaviour that
    might be needed to make the automations smoother to work with.
  - There's some gems that are well built and maintained in Ruby as compared to
    other languages so in cases where it makes sense it's used as script / tool
    to handle certain scenarios
- Crystal
  - It's very similar to ruby but offsets the speed issue that interpreted
    language have
  - Mostly didn't use it since the std library was still growing, I should
    probably give it a try again soon
- Lua
  - I kinda write a lot in lua since my entire blog runs on hooks written in Lua
  - It's a tiny language and you can actually learn it pretty quickly. It's
    pretty fast as well and addition of libraries is as simple as copying the
    `.lua` file.
  - It comes with a package manager so it's not that hard to extend either, I've
    just not gotten too deep into lua to know any more than the basics of
    writing functional/control flows.
- Zig
  - Same reasons as I mentioned in the original report above.
- ReScript / ReasonML
  - These compile to JS and are actually great languages, I tried ReasonML
    recently again and I like it though the setup of the compiler / transpiler
    itself has gotten a little longer with dependencies on Melange, the making
    sure esy works on the node version you are on, etc etc.
  - ReScript on the other hand is much simpler to work with, though most of my
    work revolves around experimental libraries and stuff, so it was easier to
    just write JS than functional programming based solution since I'm mostly
    unaware of how I'd be solving the problem. If it was for something more
    known like a server with API's and everything, this is actually good choice
- Swift
  - A lot of people like Swift as a language as compared to writing ObjectiveC
    and there's a few reasons for it.
  - It's a very practical language and has just the right amount of quality of
    life features.
  - This is also what makes writing UI's in SwiftUI a joy to do, though there
    are still some glitches in SwiftUI that are being worked on but the language
    itself isn't the reason for it
  - As for why I'm not using it much, it's probably because I rarely develop
    desktop applications anymore. The last one was WallSync and I haven't even
    had to update it since it works on the MacOS version that I'm on and I doubt
    anyone else uses it

I guess that's about it, Rust / CrabLang is probably the only one that I just
didn't like because of the amount of mental gymnastics you need to do but people
do like the language so I guess I'm the odd one out in this case.

That's all the languages I like and why I like them, any more details about the
"Why" would make this a book and I'd like to avoid that.
