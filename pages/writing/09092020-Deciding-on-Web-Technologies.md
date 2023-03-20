---
title: Deciding on Technologies
date: 09/09/2020
published: true
---

**NOTE: This post won't give you options to choose from but instead teaches you how to**

In an ideal world, there'd be one set standard that we could follow for building apps but then there's no such thing as an ideal world in the first
place. In an era where a new frontend framework arises every few days and if you monitor github like I do, you can see one pop up every few hours.

So then, how do you decide on what to use and what not to use?

### The Comfortable one

No bullshitry here, the best answer is to go with the one you are already comfortable with. If I were to instantly select a framework to build a
frontend app, I'd choose nextjs without giving it a second thought. I'd obviously have to make hacky changes later in the development phase to patch
up stuff that doesn't directly work well with the library/framework but most of the times you can just go with this option.

I'd say you stop reading here if you already have a framework, library in your mind at this point. The remaining of the post focuses on understanding
requirements and choosing the **next comfortable one**.

You can use jQuery with .Net or PHP without laravel for all I care as long as you can get the work done without snatching your hair.

### But!

Theres always a time were something is obsolete because the community says so or the maintainers gave up. I'd know, because I gave up jQuery for React
because someone told me, then I got into RiotJS because I thought it was interesting and then we came to VueJs because Angular 1 was a decent
framework and vue inherits a lot of the templating aspects from it but then Angular 2+ ... let's not talk about this. The same goes for backend
options, I've shifted from python flask to Django to Node + Express to Loopback to now, shameless plug
[ftrouter](https://github.com/barelyhuman/ftrouter). I was comfortable with Loopback 3 but then EOL and now I have my own because I went crazy.

### How do you decide then ?

There's 3 major factors

- [Nature of the Project](#nature-of-the-project)

- [Requirements](#requirements)

- [Team](#team)

#### Nature of the Project

If this is a production project, I'd ask you to shift to [Requirements](#requirements) as that dictates the choice in this case. If it's a personal
project and something you want to toy around with, you can literally pick up any new tech that you think you want to try or looks interesting and go
ahead with it and the other points might not even make much of a difference.

#### Requirements

Let's get on how these would change my decision.

_We need a portable binary that has both frontend and server running from it._

With that as a requirement, my obvious goto would be Go Lang with or without any frontend framework but, what if this requirement comes in after
you've started building the base with node and react, and you've only build the node side and the react part hasn't started? I'd switch to Vue or
Svelte , because the output spa html is smaller and that reduces my overall binary size which is always good.

_We need it built in the next 4 days for a prototype_

And now we'd use something like Angular because it's easy to find resources only from where you can copy paste templates and setup stuff pretty
quickly and then it's easy to scale on it as well so that's that.

Point being, your requirement and output dictates what you want. If I had a absurd requirement like

_It should be crazy fast! like I don't care the time you take but it should be epic fast_

At this point, we all know webassembly for computation and maybe even rendering (if I have the time) would be a good selection or you can go old
school and use server's to render plain html and use form actions for http requests and validations. AdonisJS, ROR, Django, etc etc etc are the easier
ways to get this done or maybe a custom GO server responding with html with some templating library. Point is, it depends.

#### Team

While the requirements dictate a good percentage of the selection, if you are working alone, the above section should be enough but then when teams
are involved you gotta consider how well the team already knows the selected tech. If you suddenly decide that the whole team is going to work in Go
Lang or Rust just because it's the new cool thing, you'll be hindering the speed of development and maybe even developer motivation because you still
have a deadline the devs need to hit.

Choose something that the team already knows and grow with it, you could change things like use Koa instead of Express for better async await support
but don't just decide to change the language without actually consulting the team

Still. There's always cases where you have to make the shift because the needed requirement isn't available in the current tech stack. For example,
there's no authorised stripe library in flutter but a slightly more dependable one in react native so I go with React Native on this one.

In such cases, take in consideration how much of a shift it's for everyone. You can adapt to the new structure and go with it no issues, but can
everyone? Take that into consideration and then make the decision to move. If the learning curve is just too high then maybe change the deadlines or
you'll end up with some frustrated devs.

To all developer reading this, there's no harm in learning more languages, programming languages are a skillset and you shouldn't be scared to learn a
new language. It opens a lot of doors. Have one primary language that you try to master but have others on the side for cases where that knowledge can
come in handy. Knowledge of haskell and elm have helped me make app a little more bulletproof and code better abstracted while being composable.

Adios!
