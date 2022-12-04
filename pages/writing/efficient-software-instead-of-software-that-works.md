---
title: Efficient Software vs Software that just works
date: 2020-04-22 00:26:34
published: true
---

I landed on this post today.

[Link](https://dev.to/tux0r/does-your-website-really-need-to-be-larger-than-windows-95-16mm)

This is a post from 2018 and I landed on this looking for a good way to build
multi platform apps while maintaining a really small footprint. The arguments
and discussions in its comments were hilarious and kinda pleasing it lead me to
a rust based webview for pure web apps but on a desktop.

Anyway, was close to locking on programming the whole thing in C/C++ and use
some abstractions to support all 3 platforms, and all this headache because, I
realized that a lot of tools that I have installed are built with the chromium
engine as a window layer with Electron on the top. A few to name would be VS
Code, Postman, Spotify , WebTorrent which ended up taking a lot of space on my
disk vs softwares like Sublime and Transmission that hardly take up any space
and the only reason I don't use Sublime is because the packages I need are
obsolete and need a little tweaking to get them to work. So I, just end up
letting vscode eat my ram and battery.

For anyone else, the disk/ram/battery usage is important to me because I have a
entry level Macbook Pro with just 121gb of user storage and that fills up
quickly when you are a nodejs developer. Cause well, just 20 Repositories have
over GB's worth of just node_modules and then I even decided to download XCode
and Android Studio because someone wanted a Flutter and React Native application
as well.

I agree with tux0r and being a fellow minimalist it would be a nice if software
was efficient and more focused on being performant while being small instead of

"Yeah, this library, that lib, add all of them up and ship it, if the user needs
the software he'll download the 200GB installation candidate!"

Now, tux0r's argument was specific to websites being a huge ram hog but in the
comments he ends up supporting desktop apps for heavier tasks and most of the
people end up supporting electron and JS as a language.

Now I know its not going to be ideal for business as they want everything quick
and not always _done right_ but a lot of us do build projects for fun and we
should actually try to build something that is a lot faster to use while not
being a ram hogger. Cause , a lot of people don't upgrade for a long time and
they can't really enjoy the software you built.

On a different note, I'm still unable to decide what I should be doing for that
multi platform desktop app I wanted to build...
