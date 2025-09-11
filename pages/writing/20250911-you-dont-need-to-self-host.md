---
title: You don't need to self host
published: true
date: 11/09/2025
---

I host quite a few things, both on Digital Ocean as droplets (their name for a
compute instance) and on my
[Thinkpad](/writing/20250507-migrating-from-cloud-photos) for keeping things in
my control. The post is for people who find things like these cool and would
like to self host and provide apps for free to others.

To summarise, it all costs money and it's not a small amount.

Tiny example, I have a service called [Ping](http://ping.tinytown.studio) and
here's what it costs to keep it running

- Server - $12/month
- Database Backups - $5/month

Which is about $204 a year to run and makes me $0. I'm not adding domain charges
since it's not specific to the project but costs about $25/year.

Similar to this, let's say you own the server like an old laptop. That adds in
electricity charges, and to avoid exposing your IP to the internet, you need
something like Cloudflare Tunnels (free), or you can set up a ~$4 droplet that
can do it for multiple such self-owned servers.

My current Thinkpad takes about 60W to trickle charge and the current battery
power holds up for 4-5 hours, I'll leave the rest of the calculation to you
since the cost differs from place to place.

Things like [goblin.run](http://goblin.run), ping, my other micro services
(hits,music, etc), all cost about $60/month which is $720 a year.

None of them earn me a single penny. This post is not to brag but to let people
know that it's not cheap to run these. There are alternatives to minimize costs,
like using Cloudflare / Oracle's free tiers, but they all have their own issues
which would further add to my maintenance time and cost.

I could also have a single large VPS for $60 and run it with something like
[selfprivacy.org](http://selfprivacy.org), [coolify](http://coolify.io), or
[/dev/push](http://devpu.sh) that would also provide decent centralized logging
and observability, which I hardly ever add to the free products. I'm not a fan
of tracing and telemetry and would rather spend time writing better simulators
to identify the issues than constantly track user actions somewhere (a topic for
another day).

Point being, it's fun, but don't think it'll be truly free to run it
all by yourself. People seem to think infra is cheap and yes you can use your Vercel /
Netlify Free tiers for something small but as soon as the traffic reaches a point where it's important for your service/app to be up you end up with a large bill. 

That's all for now, Adios!
