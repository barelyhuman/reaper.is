---
title: Don't forget the layers
published: true 
date: 12/09/2025
---

It’s easy to get tunnel vision when working on a codebase that you think is simple and straightforward. But there’s this sneaky layer that most of us ignore until it bites us: the abstractions.

So, I was working on Ping. Everything was fine until, I see my resend account has been sending a lot of mails in the past week and I see that it's sending it to the same email addresses again and again. Normally I'd be okay with this since it's a notification service and it's supposed to notify if the site has gone down but Ping doesn't notify unless the provided url has just gone down, if it stays down, no notifications are sent so as to not spam the users and also to save a little on the email costs. 

I did what any developer does—blame the network, blame the app, maybe even blame the weather. But after poking around, I remembered that the `fetch` implementation runs on node's `net` package and there might be something going wrong there and that's where I stumbled on `getDefaultAutoSelectFamilyAttemptTimeout`. fancy, right? Turns out, it decides how long your system waits before giving up on picking an IP family (IPv4 or IPv6) for a connection.

The default timeout is 250ms which is too short for our use case. The server was far, the connection could vary, and `fetch` was tapping out before it even had a chance. I made changes to `fetch`'s own timeout but that wasn't the case, `undici` was failing much before the `AbortSignal` was triggered and that's what led to me reading the code and going through how the core connection logic works, where I tried a few different timeouts to finally find the problematic timeout being `getDefaultAutoSelectFamilyAttemptTimeout` and fix it. 

Here’s the thing: abstractions are great. They save time, hide complexity, and let us build cool stuff without reinventing the wheel. But if you treat them like black boxes, you’re setting yourself up for pain. The answers are almost always buried in the details—the docs, the source, the weird config options nobody talks about.

So next time you hit a wall, don’t just slap on a quick fix or curse at your screen. Take a breath, dig into the abstraction, and figure out what’s really going on. You’ll probably save yourself a headache—and maybe learn something you can brag about in your next blog post.

