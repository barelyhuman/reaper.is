---
title: Updates 22nd and 23rd May
date: 24/05/2021
published: true
---

It's been a super productive week and weekend both in terms of work and stuff I learned over the week while going through a lot of articles and
setups, we'll discuss over a few things over the course of the next few posts.

Let's get back to the dev logs.

## Taco Datepicker

We'll start with the datepicker, on the previous log I talked about the progress on Taco and everything and the datepicker was picked from TillWhen's
implementation and while it suffices the base requirement for an Alpha project the codebase is very hacky cause built it too quickly.

Anyway, had to create a better and cleaner version both in terms of design and code so I picked this up and probably the first time I've worked after
office hours on something and not felt lazy.

Anyway, this is now a separate repository on my [Github](https://github.com/barelyhuman/taco-datepicker) and while I plan to release the whole Taco-UI
as a package, for now we're going to keep the taco datepicker as the only one available to public because the rest of the components are pretty
unstable and I wouldn't want people experiencing issues the moment they start using it.

## Taco

Next up is the actual product, Taco, in terms of update, I most spent time working on ways to make the mono repo work with the deployment process and
avoid having to create docker images for every small change. Have a process in place, let me know if you'd like to know about the deployment process
and setup.

For now, the alpha servers that I planned to release on 1st of June are up and usable with a testing account for now, you can create your own account
but the feature set isn't complete and a lot of things are disabled by default since **it is a testing instance** , you're better off waiting till 1st
for me to make the instance usable and after 2-3 weeks of monitoring on that instance is when I'll be launching it properly.

Hopefully, it beats TillWhen...

## Statico

This is the static markdown folder converter that I use for this very blog and the changes are still being tested and worked on , the main reason for
a change is so that people can easily generate indexed and custom markdown pages and also because I want to move these weekly logs into it's own
section instead of mixing up with the normal posts, the same applies for the checklists, they are technically a part of posts but the primary
link-backs are from the [Misc](/misc.html) section and makes no sense to have them in the posts as well.

So overall the static generator is going to have a better config file to work with and while I'm doing that I can work on making it faster.

## Commitlog

The one project I spent a lot of time dreaming about finally has a proper direction, the changelogs are now going to be cleaner, it has a `release`
subcommand that can help manage the version but is limited to working with just git, I want to make it use a `.commitlog.version` file so it can use
that to decide how to increase and decrease version instead of doing all the heavy lifting of reading the repo again and going through the revs to
find the latest revision.

The support for commitlint standards stay since I still do use the standards personally but not strictly and that's why commitlog doesn't force you
either.

## Smaller Projects

### add-config

I've been working with a lot of projects from work and I end up making a similar type of config files to maintain switching between environments and
since you shouldn't add any secret data in the frontend anyway, the config method works well. Manually doing it again and again can get exhausting and
so [add-config](https://github.com/barelyhuman/add-config) is simple nodejs cli that can do it for you, **"Why not write it in go or write a bash
script!?"** simply because most of the projects I work with are node based and I don't need to download a binary over curl to set this up on a new
system, it's a simple `npx ` invoke and I have the config in place. I can write a bash script but then you copy around that bash script as well, the
point is to be quick with things like these so you can spend time to do other things.

### dokcli

This tool has been in the arsenal for a while now and I use it on almost all dev environment setups since the dokku app creation and config handling
isn't as un-attented as I'd like it to be, so a simple cli I built as a toy to learn go has been coming in handy, though there was an error, I left
the url scheme in the creation script and forgot that dokku won't allow me to add a domain with the scheme in the string (`http://` or `https://`) so
just added a simple parser to handle that and now the scripts won't give you an error, also separate domain and app setup scripts because dokku
doesn't recommend setting the domain before a proper deployment so you can run the domain setup later. The same has been added to the non-config
execution and dokku will ask you regarding the domain and since I was doing all this, i also added letsencrypt support to the config and non-config
invocation so it'll setup letsencrypt for the domain as well on execution of the scripts.

That was a lot of stuff, I'm impressed, anyway that's it for now.

Adios!
