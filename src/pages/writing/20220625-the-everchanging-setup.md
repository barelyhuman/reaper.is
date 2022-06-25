---
layout: ../../layouts/Page.astro
title: The everchanging setup
date: 25/06/2022
rss_only: true
---

This one's just for the RSS group, so you won't see this indexed on the blog,
though you can open the link on the blog.

Also, since I have no drafting process and everything is literally just me
talking to the computer, this is for people who already like that style of
writing.

I've been working with Javascript for like 4-5 years now and I'm never really
productive, mostly due to the amount of setup's I've changed over the years. The
constant thinking that "oh that tool looks cooler" has had me switch and I end
up spending a lot of time getting my weird setup to work.

Should be easy to find this happening if you go through any of my project's
commit history.

Though, there's the golang and nimlang codebases which are pure code and 0 time
spent on setup just because I hardly have any options there, and it's
scientifically proven that the more options you have the worse it is to decide
what you want. In most cases I'd like to go with the simplest one but then I do
still spend time on the most complex one to see if I can make it work. (I wasn't
lying about liking the chaos)

The reason for the post was to talk about **if** you should be doing this?

and like every developer who's gained a little consciousness about stuff, _"It
depends."_

**Primarily** on what you wish to achieve with the task.

Building a starter project or a project template to reuse is a good way to
shorten the cycle of testing if something works or not and it's pretty common in
the JS ecosystem trying to figure something that works everywhere. The ESM / CJS
problem isn't something you have in other languages cause the build tooling
isn't at a confusing place there.

The ESM/CJS problem is something that's due to the thought of unifying something
that was probably not necessary since we had already built tooling to make JS
work in both node and browser anyway but the hope that "this will make it
better!" has brought more problems than necessary.

Rant aside, you do need starter projects to reduce your time being spent on the
following stuff

- Build / Test steps
- CI
- Focusing more on the actual functionality.
- Framework/Library level stuff

Which could also be reworded as _"Your starter should handle these scenarios
primarily"_.

And, don't just blindly keep building starters for things you don't work with.
Like, if you haven't worked on a similar project for at least 3 times, don't
create a starter. I've done that in the past and those starters are just there
in my repos for the sake of being there.

I know this works since my nimlang and golang codebases have more functional
code than they have setup code.

Latest example, I wrote [choxy](https://github.com/barelyhuman/choxy) in 20
minutes. I spent 2 days to understand and make sure the false-monorepo approach
followed by [swr](https://gihtub.com/vercel/swr) could be replicated by any
future project that I work which needs a similar setup.

Obviously,spent more time than that to fix bugs in the library but then 2 days
on making sure I can reproduce the setup again if needed, would be considered
unnecessary by most developers since "reaper already has setups that would've
worked equally well on most bundlers"

For me though that was an amazing learning opportunity, considering I know that
theres going to be exactly 1 user of the library at the end of the day and that
user will also jump to using something better when he finds it. (talking about
me, if it wasn't obvious)

To rephrase, I might not use the library again but I will most likely be using
that setup when necessary.

Though, remember that if you wish to be a little more productive in terms of
what you build then having something a little more organized like
[antfu](https://antfu.me) would help you a lot more than going with the flow
like me
