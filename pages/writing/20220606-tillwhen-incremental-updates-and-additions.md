---
date: 06/06/2022
title: We're polishing TillWhen, finally.
published: true
---

About 2 years ago (25 May 2020), I decided to speed code a timetracking app in a
weekend.

- Picked the login system off of my older web projects in Koa
- Used a simple layout components without any styles
- Picked the crud to table helpers based on user ownership from older projects
  as well

The amount of code I wrote for that app was close to 200-300 lines and that was
mostly the tab animation which I removed right after cause I wasn't happy with
it.

Either way, the MVP of the app was done in 2 days.

The next few weeks it had a few additions from various libraries, both for UI
and backend functionalities.

considerably, it's the simplest app I've built and it's not that hard to build
but then I promised to polish the app to be a lot more consistent and was never
able to keep up to it.

## Excuses

**Cover Up**: I got busy with work related stuff and other projects

**Truth**: I gave up on the product since, I didn't use it myself and in my
opinion if I can't be on the dogfooding side of the product then there's a good
chance I won't find issues that the customers might be facing.

## Why return to it?

Recently, my primary domain [reaper.im](https://reaper.is) has lost it's
original nameservers and the owner of the tld has probably changed thus making
it hard to get back. (obviously, since you are probably reading this on another
domain).

This issue lead to breaking [mailer.reaper.im](https://mailer.reaper.im) and
that was the service I used for sending mails, it's just nodemailer as an API
and was being used to send mails for the magic links that tillwhen uses to
login.

And to fix that I moved the tillwhen code to use it's own nodemailer instead of
the service and while doing that my OCD kicked in and I saw a lot of stuff that
I could improve and I just instantly created a `v2` branch and started working
on some minor stuff.

## Stack

The stack is still the same as before

- Next.js
- Postgres
- AntD and Semantic React for UI Elements

As you can see, I have 2 huge libraries being bundled with the app, most of you
can't see the speed lag because almost all pages are server rendered and nextjs
is good at handling caching for these kind of things.

### Updates

As for what's we're changing

1. rewriting the UI elements with tailwind and more generic css
2. rewriting the API's so you can write extensions for the app
3. moving a lot of the validation to the database layer
4. writing faster queries for strictly server rendered pages

#### UI

The most work is going to be removing the AntD and SemanticUI components and
rewritting more elements in my style / theme.

The initial version was just

> copy component code => change color => randomly place it on the right side =>
> done

That's not how I prefer it but then I needed the app up in 2 days to challenge
myself. Now since we have over 200 users, I really thing they deserve a little
more than just a working tracker.

The 2nd part to focus on was the refetched data that isn't being cached or even
stored in a global state so we've got [jotai](http://jotai.org) and
[jotai-form](https://github.com/jotai-labs/jotai-form) which are libraries that
I sometimes help with and jotai-form doesn't have a full fledged form validation
solution yet.Which is my responsibilty, and I'm writing the experimental
solution as a part of tillwhen and if it works out as expected, it'll be added
to the official package.

As for the API requests, it's mostly written in `axios` and whether I wish to
change it or not is totally dependent on the time I decide to spend on them,
since they are just being used in 3 components and I could rewrite them in
`fetch` pretty quickly.

#### Backend

The backend code, which is a huge set of `koa` and `express` API handlers glued
with Next.js' API routes code which while works basically follows the flow like
so.

> Page => Next.js Route => API => express handler => Page's serverSideProps =>
> Page

Which, is honestly not how anyone should write nextjs code, I wrote it cause it
was quicker and I didn't want to handle the context level code that would then
need changing the express handlers greatly, and this glue worked fine for the
initial expectation of 0 users.

Since there are more users, the memory and requests are now something to be
reduced and so we'll be rewritting the APIs properly in a way so that you can
also extend and write extensions if you wish to.

This also includes writing faster raw queries instead of using the knex
generated queries for when a page is strictly server rendered and not client
code dependent, one such page is the `/dashboad` stats. The page has only 1
client interaction and that is also re-rendering the page from server data.
Right now it has 3 queries running in parallel to get the data which can be
reduced to 2 simpler and more faster SQL queries. I'm a big fan of ORM's but
that doesn't mean that raw queries are to be avoided altogether, there's place
where that's the best option to speed up stuff.

## Process

How are we making these changes?

The older code is still on the `main` branch and the new code is on a branch
called `v2/initial` where the changes are being made.

No, I haven't deleted the whole codebase in that branch, it's still incremental.
So the API's have a new subfolder `v2` and the newer API's go in there.

For the UI components, there were minor abstractions that I wrote in the
previous codebase which I can now move to a folder called `old` inside
`components` and vscode took care of changing the import paths for me.

The new components were then added as needed, first being coded on the tailwind
playground and then being imported into the component file.

Since the database will not be changed and only have more constraints added to
it, that'll be done with SQL scripts that I can run using
[gator](https://github.com/barelyhuman/gator) or using knex's raw query runners.

Probably will be using gator since it was written for things like these.

While the code in current codebase is a mess, a lot of the things were placed
properly and the containing folders were named appropriately and this made it
easy for me to find stuff when modifying them.

Also, I've started using eslint a lot more than I use prettier so that's
handling a lot of code style for me. I avoided eslint since all I needed most of
the times was a code formatter and not a modifier but there's been a few tricks
that I used various cli's for and all that's being handled with eslint so I
think I'll be using eslint more.

## Conclusion

There's no deep meaningful statement to be made here, just stating the things
I've been doing.
