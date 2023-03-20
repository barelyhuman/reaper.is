---
title: Moving away from web apps - Story of Another experiment
date: 10/12/2020
published: true
---

The world is moving towards making everything available via the browser and I'm moving the other way where I want to build desktop apps.

I'm not the only one that thinks this way.

Also, it's always easier to build apps that don't need a web-server to exist and can handle data and work in and around the system, makes it easier to
keep personal data safe and thus less things to worry about for the developer. Again, just my opinion.

## Yeah okay, What experiment are we talking about?

So I've been crying and ranting about electron being heavy, apps being ram hungry, my mac giving up it's life trying to keep up with all the things I
multi-task with, for a really long time now.

On the other hand I did mention about learning rust and go quite a times as well. So quick update, haven't been working on rust much but definitely
have tried out a little more in go and this post is basically going to lead to that and why it was the chosen solution.

## Reaper and Laziness

I'm quite a lazy person and that's why sitting in one place while typings lines and lines of code everyday is something I enjoy but this laziness can
get to your head and then you start using your head more than you use your body.

**example**: thinking of every possible way to get the remote from the dining table without moving anything but the hand and the broom stick that was
lying on the floor in front of you.

Similar situation lead to the experiment , this time the distance was a full king sized bed with a table on one side and my old phone connected to the
charger on the other side.

This is a daily setup, this phone is put on charge after my main device is charged overnight and is responsible for playing my spotify playlists over
the day, problem is, to change playlist and or tracks I need to either open it on the laptop or my main device which is again on some corner of the
bed because I don't like distractions when i'm working.

Last option? The open.spotify.com web app, but then this page takes a good 300-400MB worth of ram on Safari and close 290-340MB on chrome with the GPU
helper using up to about 50-100MB so yeah, back to 300-400MB of RAM usage which while I could afford if I wasn't running anything else of the system
but in my normal dev workflows there's a few code editors, a few docker containers, figma for design reference(which takes 1GB because of the amount
of designs in that one window) and a few simulators because I do too muhc React Native dev right now for office projects.

In summary,

RAM Available - 8GB( ignoring the paging cache ) RAM Used - 7.1 ( Swap prevents the remaining from being used) SWAP Used - 1.5-3Gig (based on which
emulator/simulator is running)

At that point , opening another webpage that takes up 400MB worth of ram is bascially pushing the macbook at it's limit which in turn slows down
everything else that's moved to the swap and certain electron apps don't like working from swap because they weren't built with that in mind but
that's on the devs and not electron.

So now, I either get up, walk to the other side of the bed and change the tracks or find my main device and change it on that. Either way, it wastes
time and i'm too lazy.

## Spotify Lite!

The name is as original as it can get, that reminds me , I'm to put a disclaimer on the readme for this.

Back to the topic, so what did I build ? A simple GUI interface with 4 buttons and a Text showing the current playing track.

Oh ah, a config screen that you'll see when you first open the app and it's available only for Mac right because it was built it 5 hours, how much do
you expect from me!?

Anyway, yeah, it's a mac client for now, but since both the framework and the language used can cross compile, I might get linux and windows releases
out soon as well, though I'd first sit and clean up my code, right now its a disaster.

Close to what a 5 year old would scribble all over the house, only he understands the code, same vibe.

The simple principle of building it is already explained above but why build a desktop app over a web app that could've done the same thing and I
could've built it in half the time?

To Learn.

I wanted to learn go and get better at it, I always slow down the moment strict typing comes into the picture and I would like to change that, yes
I've worked with TypeScript but I just write `any` and escape from situations where I don't want to define the types which is bad , both for code and
speed so to improve my speed with types involved this is was necessary.

The experience was good, I had a good 5 hours to spare since I woke up early, I did hit some segfaults because of lack of knowledge of channels and go
routines but have a better understanding now so it's all good.

Still most web app oauth flows don't have PKCE protocol well implemented and need a redirect url which a desktop app can't really provide so I ended
up going with the usual OAuth2 flow but the user has to set it up for himself which I think is fine since It adds to the security. Your client token
and secrets are not stored on some external servers but your own device and you can delete the app from your dashboard whenever you want to avoid
Spotify lite from using it.

All teasing aside, I'll link you to the repo.

https://github.com/barelyhuman/spotify-lite-go

That's all for now, Adios!
