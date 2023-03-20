---
title: Product Development and a Developer's Role - Part 2

published: true

date: 29/06/2021
---

Do read the first part before you continue to read this.

- [Product Development and a Developer's Role - Part 1](/posts/product-development-and-a-developers-role.html)

---

We stopped at the stack last time and now what remains is the evaluation part. Most of

you would be like, why another post for just the evaluation part , why not just add it

into the first part?

The reason is that while the post is targeted towards the developer's role in each

phase, this phase has a few ways to do things and I wanted to go through each one of

them.

The **developers role stays constant here** , mostly in the boundaries of **bug fixing** and **solution hacking** things that need to be handled right
before the initial launch or whatever phases the product is to go through before the targeted users get to it.

These are the one's I've worked with and there's obviously better or worse ways to evaluate but these are based on just my knowledge at this point, as
that changes, you can expect a better post later on.

## Evaluation Methods

To be fair, there's like a lot of these,

- UAT - User Acceptance Testing
- Dogfooding
- Automations

these are all good but we have to understand where each works and where the other would be a better alternative.

If there's other that you wish I cover on , do consider emailing or reaching me out on my twitter handle `@barelyreaper`

### UAT

**UAT** (User Acceptance Testing) - one of the first methods that I learned about through the first startup I worked for and it worked fine, other
than that people took it very seriously and would fix and deploy things in such a hurry that it would normally need a few rounds of deploy to see them
finally rest, which while is okay, I guess a bit of unit testing would've reduced but then it was a very small startup and the deadlines were hard and
I need to find better excuses.

Anyway, the point of **uat** is to make sure the user's actually understand the app and it makes sense to their business logic (in B2B) or is
intuitive enough for users to browse through easily (in B2C).

#### Pros

- The feedback is almost always immediate
- reduces the risk of having defects in production
- users already understand the system before actually using it for the intended use.

#### Cons

These are more like things people end up doing and barely an issue with the evaluation method itself.

- The developers sometimes go crazy on trying to fix the bugs.

**Solution**: Calm down humans! It's just an evaluation phase, the point of it is to break!

- The environments might not match with production and this is something that the developers should make sure they setup during the start, if it's a
  project that changed roles over time then this might be unavoidable but still try to maintain a similar environment to not run into issues during
  production movement.

**Solution**: Docker, K8s, They exist for a reason, use them!

### Dogfooding

Saw this one coming, didn't you?

This is something I picked up a while back without knowing what it was called. Readers know that I build tools very specific to my requirements and
then 90% of the time I'm the one using them and this is the basic principle of dogfooding.

The builders of the product/tool/app use the app internally before the publish/go live.

This is something basecamp has been doing from the start and the evaluation method works but requires a **good version management** to go with it to
work.

Version management discipline will make sure you have checkpoints throughout the codebase to identify what's still under evaluation and what is stable
enough to move forward with.

If you are using semver a good way is to handle it with pre-release tags which look a little something like:

`vX.X.X-<pre-id>.X`

eg: `v0.0.1-alpha.2`

which translates to "this is the `alpha.2` version before the `0.0.1` release and not the `0.0.2` release".

This gives you a set of idea that everything that's in alpha is being evaluated and everything with a stable non-alpha tag is being used on the stable
releases.

This also means that you don't have to hurry the to fix something, but go through the alpha releases slowly to make sure the defects are at a minimum
in the stable releases.

**Bugs are inevitable**, there's always a corner case, there's always a library that decided to change something, there's always a new requirement.
Don't rush to fix the bugs and never fix them with the first solution that comes to your mind, go through the problem, check if it's a problem at the
implementation you are looking or is something else the root of the issue.

> All code is buggy. It stands to reason, therefore, that the more code you have to write the buggier your apps will be.
>
> \- **Rich Harris** (Creator of Svelte)

#### Pros

- Easier to find bugs as the users are using it with the actual intention
- Lower cost of handling since it can be done on a single environment and doesn't need separate dev/uat/production environments, just dev/production
  is fine.

#### Cons

- Doesn't work for fast paced companies that are on harder deadlines
- Screwing up the version management can screw up the entire concept, needs discipline to follow through.

### Automations

A lot of people depend on various automations for UI testing and API testing and I've talked about this before in a post about testing where I talk
about how I do it and in terms of whether I like this or not, here's a single line answers.

**Doesn't work when requirements change constantly, you are better off manually testing this instead.**

That statement aside, you should still make it a habit to write tests for your API's if you have the luxury of an open deadline. If on a hard
deadline, you can spend that time on actually writing that feature to be as robust as possible.

You can read about how I handle testing here - [Tests vs No Tests](/writing/31052021-Tests-vs-No-Tests)
