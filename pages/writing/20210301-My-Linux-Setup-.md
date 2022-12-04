---
title: My Linux Setup
published: true
date: 2021-03-22
---

I haven't talked much about my linux setup on this blog, so let's go through a
few things I wanted to answer.

## Favorite Linux ?

No, specific one, I've hopped through a lot of them over the years, the most
used one's are a custom spin of Debian and Arch. I do have backup thumbdrive's
with actual OS installs, so not live linux USB's, but drives that contain the
entire system (dev environment, needed setup, drivers, etc)

Let's list them out

- 128GB Sandisk Drive - Arch Linux
- 64GB Sandisk Drive - Fedora
- 128GB Hp Drive - Custom Debian

and then the internal HDD of my laptop dual boots between Windows 10 (cause I
play games and the linux drivers for the hybrid hardware is still iffy) and Arch
Linux (this is there just as a backup in case my drives aren't with me)

## Setup?

I've basically got 2 setups one using
[Openbox](http://openbox.org/wiki/Main_Page) and one using
[Sway](https://swaywm.org/), the openbox one is on most of the installs since
I've just started using sway and I'm liking the i3 environment, I've used i3
before for a lot of setups but I keep jumping back to openbox because I feel
comfortable using openbox and i3 needs you to remember a good set of keyboard
shortcuts which I do mess up sometimes so I just like the option of being able
to use the mouse in case of doubt. Obviously, it becomes a 2nd nature once
you've used i3/sway enough.

The setup is pretty minimal, there's the basic desktop following the duo tone
colors I use everywhere, an off-white tone ranging in #dddddd - #eeeeee and a
dark gray tone ranging in #121212-#333333, should probably create a good color
pallete to share with people, the accent color is a random color I picked from
[colors](http://colors.reaper.im/) and changes quite frequently so it's also an
environment variable so I can change it at any time by executing an
`echo export ACCENT_COLOR=colorhex` to the shell profile and reload the sway /
openbox config.

Basically what the profile looks after a while.

```sh
export ACCENT_COLOR=#3CA60C
export ACCENT_COLOR=#B07AB2
export ACCENT_COLOR=#9FD0B1
... goes on till I clear it up
```

The primary **application launcher** on both is `dmenu` and sometimes I setup
rofi when I have the time, the **browser of choice** is firefox and chromium as
backup (because I develop web apps), the same on Mac with safari as an
additional test browser.

**I don't use a login manager / display manager** (lxdm,lightdm,etc) , I use the
shell profile to check for a logged in user and then take access of the display.
This either launches Openbox with xinitrc or launches Sway with Wayland
environment in place.

**Wallpapers are just solid colors** on the linux setups, again a dark gray in
the above range. On the mac though, I change them frequently with a random one
from [wallhaven](https://wallhaven.cc/)

## New User, what do I use?

I'd direct you towards [Linux Mint](https://linuxmint.com/) to start off with,
and there's also [Solus](https://getsol.us/home/) but it may or may not directly
work with your hardware so try both of them out with a live disk and then
initiate an install, an unresponsive wifi/network hardware is quite common so
you might need more than just the default install to get either of them working,
though Linux Mint generally hasn't given me an issue yet but, don't directly
execute an install without testing your hardware on the live disk

I guess that's about what I wish to say about linux right now, I will be going
over Linux Distro's that I found interesting but didn't make it to the list of
favorites.
