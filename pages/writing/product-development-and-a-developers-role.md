---
title: Product Development and a Developer's Role - Part 1
published: true
date: 21/06/2021
---

As a developer and a CS Student we are normally taught about the waterfall
method during college and we just naturally grab the "Development =>
Maintenance" phase to be the part where the developer is going to be active at
and we leave it at that. We take that to be the ownership part of the project
which is the first big mistake. Anyway, we'll get to the whole thing in a min.

Talking about Product Development can lead to more than one or two posts and so
I'm going to leave it on the response on this to decide if I need to write more
about this topic.

If observed, I never really mention my work place projects in my portfolio and
it's mostly the tools and apps I've built over time which are all available on
my GitHub, and the reason I do this is my role during the product development in
most of the places that I've worked was limited to the development phase, I
normally had no say in what the designer would do or what the client wanted or
even being able to push back to the client if a requirement they mentioned
overlapped existing requirements thus delaying the project more.

Not to blame the managements of any of these companies but it was my own
thinking back then that it's not a part of my job to do that, my job was to
inform the managers that so and so was happening and then they'd do the above
but well sadly that didn't happen always.

Anyway, to the product development knowledge and the reason you need to know
about this is so you as a developer can rethink where and how you are supposed
to be there in the project to handle the respective problems.

There's basically the following stages that are taken in consideration before I
start building anything (might come as a surprise but no, I don't just jump into
writing code for something without going through these).

- **Requirement Notes** - Writing down the overall scope of the project
- **Requirement Filtering** - Figure out **what part of the core** that needs to
  be **built first**
- **Team Selection** - I work alone so.... this is the shortest phase
- **UX and UI** - Pickup the **filtered requirements** and build the base UX
  around it, if it's a prototype then I avoid going through the UI phase and
  **just use exisiting designed components**
- **Decide the stack and arch** - decide the tech that'd go with the
  requirement, this one takes a bit of to and fro
- **Code** - the favorite part of the whole thing
- **Evaluate** - this is either easy or irritating based on how I'm evaluating
- **Repeat**

### Requirement Notes

This isn't publicly talked about because this is mostly scraps of paper that I
kept writing on and then I switched to the iPad and wrote on that instead and
recently I've moved to using the Notes section that I've added on Taco for the
same. Basically built that for this.

The phase involves making note of everything you **currently** have in mind for
the project's overall scope this can be all fancy or this can be all basic in
terms of features but the point is to have it written down so you know what the
app is going to be about, otherwise it's just a idea you jumped to build and
then forgot what all you wanted to build and that backfires pretty quickly. I
seem to remember things I don't want to but then important things like these
just slip past when I need them so, **just note it down!**

**Developer's Involvement: Helps clarify what is technically feasible and if the
requirement is even valid to go through or is the deadline proposed by the
client even achievable**

This can then be be reduced to set of core requirements that is what the next
phase is about.

### Requirement Filtering

Here you throw the idea down the drain and stop thinking of it as _my baby
product_ , and take in a logical approach and ask yourself a few questions.

- What parts of these requirements can be taken care by manual work?
- Are there existing tools that I can use to handle certain things?
- How important is this requirement right now?
- Do I have enough money to spend on so and so?

Based on the answers you will normally have a good idea as to what can be kept
as a core functionality and what can be added later to make it easier for the
targetted user.

**Example**

I used [linear](https://linear.app) as a task manager while I was building the
base of taco, which is basically another issue tracking / task tracking app. I
had a few less detailed tasks written on the iPad. There were even plans to
integrate with existing platforms, ability to import data from around every
other app. I had a lot of fancy stuff I wanted to add to it but obviously the
idea of scaling could go all the way to the moon and not always needed. The
problem Taco wanted to solve was to have all the basic tools in place to handle
tasks and collaborations between teams, not to be the most feature rich project
manager out there.

I cut down the requirements to the absolute basics and now all we have is the
tasks built first, the projects section was built next and then the teams part
is under work right now.

**Developer's Involvement: This part can mostly be avoided since the business
perspective is mostly what's to be seen here but the developer can still help
clarify things or even provide solutions based on past experiences**

Next, you setup priorities based on your evaluation method and then get to
deciding who's going to do what.

### Team Selection

If this was being done in a company then you'd have to figure out who's
available and what's to be handed to whom but since I work alone on these
project the team selection is pretty simple.

- Architecture - Reaper
- Design - Reaper
- Theming - Reaper
- Backend - Reaper
- Frontend - Reaper
- Sleeping - Reaper

**Developer's Involvement: Helps give a '_base idea_' of the timeline and how
much extra work might be needed**

You get the idea.

Though the **Architechture** phase is a bit time taking since that base decides
how the project would flow and scale and one setup doesn't always work for every
project no matter how similar the projects are, we'll get to that.

This step is where I decide how much time it'd take me to build the whole thing
considering the arch would take about a week to solidify , design would involve
about 2 weeks or so for the core features since it's just the tasks part that
needs to be built first but that gets all the base design components to be built
by then so I can reuse them in other places.

**You have deadlines for your own projects?** How do you think taco's first
alpha was built in a 6 days!? It has a testing mode, profile management, project
relations, task handling, and animation for toggles and the project deadline
pulse and obviously components accompanying each with api's handling each.

That's in 6 days with about 4-6 hours of work each day. That's not the fastest
in the world, not am I boasting. I'm just saying the deadline is responsible to
keep me in track for the project, my productivity can go down significantly
based on the following

- No music playing while working
- Constantly getting pulled into something else
- No deadline to raise my anxiety

There's definitely more but that's all you need to know for now.

### UX and UI

This phase either lasts forever or is done within a week based on what I'm doing
, if I'm building the core then I have a set number of pages that I need to
design the UX for and based on that the components that need to be designed.

Then I just reuse these components as much as possible because **minimalist**

Back to using Taco as an example.

The tasks page has

- Banners

- List Elements

- Side bar Navigation

- Accordions (the expanded task view)

- Status Menu

- Search Input

- Buttons

- Navigation Menu

- Page Headers

- Task Type Headers

Now lets group them in terms of things I can make common styles out of

- Menus [Navigation, Status]
- Buttons
- Headers [Page and Task]
- Banners [List Elements, Banners,Accordions]
- Inputs [Search]
- Sidebar Navigation

So my menu component has to be dynamic in terms of it's trigger but the menu
style is going to be the same, the buttons are well going to be generic, headers
are going to have a font size and font weight based on where they are being
placed, the banner style can be used for the list items, the actual banners and
even scalable to be alerts by changing the background colour, inputs, sidebar
navigation structure can be reused in other pages, like the settings page.

**Developer's Involvement: feasibility of what component can be built in the
given base timeline and what needs to be added as extra in the timeline based on
the complexity of the designs, this can increase or decrease the timeline
significantly**

So Now I have elements that cover 80% of the app UX and the 20% include cards,
tables, graphs that are going to be a part of the projects and dashboard. This
would've taken like 2-3 days to sketch and finalise and then 1-2 days to
individually implement.

### The Stack

Though I mentioned implementing the components before I decided the stack the
reason is because the stack is actually decided after a prototype phase which
I've explained about quite a bit in previous posts[^1].

[^1]:
    https://reaper.is/posts/20042021-Why-I-use-Next.js-for-everything-and-why-you-shouldnt-.html

The prototype gives you an idea of what needs to exist and what doesn't and
where it would create an issue, in my case I've built enough todo apps to know
what's going to break where and TillWhen gave me the remaining needed knowledge
for the scaling issues.

So the stack was already in my head thus implementing the components was going
to be in React and that's what I did. The stack phase is inclusive of the setup
that needs to be done for the same.

This includes the codebase setup, the configurations , CI/CD for the same and
environments that you'd be deploying the project on.

In my case

- Alpha Instance
- Live Instance

The codebase setup can be a time taking process if you're setting it up for the
first time but if you've done it before you can manage or create templates on
GitHub to reuse, i'm not sure how many people know about this so I'm just
mentioning it here. I have quite a few templates up and I picked up my mono repo
template , made a few modifications to the folder structure, added the needed
dependencies and then got onto the configuration phase.

A big misconception developers have is that there is to be different branches
that maintain different configurations, like `master` is to maintain the
configurations for production and `dev` will maintain the development
environment config. NO!

The codebase and configuration are to remain the same, the values of these
configuration change based on where you are deploying and thus remote configs
can help you with this but you are better of understanding how to implement this
yourself. The branch approach adds up additional overhead of making sure you
have the right config before you deploy and if you are using CI/CD for
everything that is a disaster when your un-checked configuration deploys to
prod. Don't add that headache to your work.

I can be blamed for telling people to do that but in my defence the meaning of
maintaining different branches is to make sure that the code on those branches
are based on what you want to deploy.

**Example**

`master` is to have the code that's been tested and can be sent through to the
prod

`dev` is the codebase you add untested merges to and what deploys to the staging
environment

this doesn't mean you add hard coded configurations in each branch which differ,
a wrong `git rebase` commit and boom your configurations need to be setup again.

Make it easier for yourself to handle such cases before you even start coding
the project.

The decision on the actual stack can vary based on requirements, so that can be
a long post but I think I'll write about it sometime. To just go through what
needs to be checked would be,

- how well does the community support the languages you chose or the frameworks
  you chose.
- If you are going to use existing libraries or codebases, are these still being
  supported by the maintainers or do you need to fork it to make fixes (this
  decides the timelines)

There's no **Developer's Involvement** section here since the developer is going
to be doing this part. Though make sure you add the project setup time in the
timeline as a developer, people don't realise that it's a good amount of work
and its your responsibility to make sure you don't forget about this.

This is all for this post, the next post should be out soon in the next few
days.

Adios.
