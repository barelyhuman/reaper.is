---
title: Custom Roms and the need for a custom rom index
published: true
date: 17/08/2021
---

You already know where the post will lead, it'll lead to some side project I
ended up doing during the weekend. But, there's twist, this wasn't done on a
weekend. I did it on a weekday and that's the only twist. Let's get to the post.

It all started with a general day at work, writing features, fighting bugs, with
my brain just imagining me to be a super hero. Once I logged out, I just go sit
with my parents and eat dinner or talk about random crap. During this I observed
dad constantly patting the back of his phone like it was a TV Remote and hitting
it would magically make it work.

I grabbed his phone and randomly started doing intensive tasks to see that the
phone wasn't just slowing down but literally begging for resources to work
properly. Shouldn't be happening to a decent phone but might just have been a
faulty piece and my dad doesn't really tell me that it's not working cause then
I'd instantly order a new one instead of trying to get it fixed.

Anyway, with the new knowledge that the king's telecommunications weren't
working, the prince went ahead to look for another phone and I remembered that I
could just swap the current ROM with a custom one to see if it's the hardware or
it's the software optimizations that are causing the issue. I reset the phone,
the phone still hanged itself to death and then came back to life after 2-3
mins. Pretty irritating!

I then went ahead with the Custom ROM approach to find out that the phone
doesn't support bootloader unlocking and I can't do anything but stare into
darkness with this in my hand. ** Next Steps? **

Look for a phone that's fairly new like released last year and has at least one
of 3 of my favorite roms.

- Lineage
- Pixel Experience
- Evolution X

Sadly, there's no way to combine those 2 searches so I ended up going through
each of their websites, looked up the devices they support and the release date
of each device. Luckily each of those roms have websites that provide all the
information I needed but it was way too many clicks and that makes sense cause
their audience is people who already own the phone , searching if their phone is
supported.

Not people who plan to buy a phone only if it's supported by these 3. I sat for
a few minutes doing this and making note of all the phone I've checked , their
release timelines, the stability of the ROM and then I was like, "Dude... you
are a programmer. Script this out!" , wrote a simple script that could scrape
the lineageOS wiki and device release data and show it in the descending order
and I could easily just select the device I could get for Dad.

Brain didn't really like the idea of a cli script and went "You know, you can
build a website right?". The remaining story doesn't need to be explained. Ended
up building https://cri.reaper.im and it has about 5 ROMs and the devices that
support them. Thus, making it as easy as a click to help me find what to buy.

Check it out, or don't , who cares? I'm going to go get Dad a Pixel 4a.
