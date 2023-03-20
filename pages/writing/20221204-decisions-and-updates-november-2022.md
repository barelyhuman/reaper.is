---
title: Decisions and Updates November 2022
date: 04/12/2022
---

Here's what has happened in the past month and a summary of why they happened.

## Preact Native

I took on an ambitious project to get preact working on react native and for most part go the rendering working with the react native sdk but soon
realised that getting rid of the `react` dependency would lead to rewriting most of what the react team has built over the years.

So, this project has been slowed down immensely, as a matter of fact I haven't pushed the minor fixes I made for almost 3 weeks at this point.

I did start writing a tiny port for the navigation libraries and it still no where close to being remotely functional but hopefully we get there.

Reason for writing the port was to make sure if someone does decide to help or pick up the project, there's enough groundwork done to move forward
with it.

Major problem is still the children update logic on android which is handled with hacks inside the react native codebase but with our DOM styled
abstraction it would make it hard to keep the domain logic seperate from the tree.

## Minit and Twitter

I moved away from using twitter extensively and only open it once a week or so just to check for any updates from people I did join twitter for.

We're mostly back to posting updates as blog posts but for smaller and simpler things I built [minit](https://minit.barelyhuman.xyz) which is just a
ephemeral dumpster where you can throw in random stuff and it'll get deleted after 24 hours. It's text based right now but I think I'll add image
support to it. It's written in the traditional fashion with maybe a little bit of JS for minor interactions

## Mudkip

mudkip the mini documentation generation tool got a small update this month where I added search index generation for the documentation. It's no
algolia level stuff but just a simple score based search index using the search behaviour that sublime text uses and this index is bundled as a
javascript file with the output.

If you don't have JS enabled on your browser the doc website works as normal and the search input isn't shown either.

I enjoyed writing JS in nimlang and it felt like I could do a lot more powerful stuff with it but then I haven't spent that much time on side projects
the past month or so due to the day job's work.

## Other minor contribs

The contributions to other oss projects were close to none, I might have fixed tiny bugs in a few and maybe done some chores here and there but
nothing more.

Hopefully this month I'm able to spend more time on stuff. I do wish to add a few arch changes to tillwhen and also finish the
preact-native-navigation port which is private right now but will be OSS once I'm done.
