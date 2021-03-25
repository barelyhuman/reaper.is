---
title: Using existing GitHub repositories as boilerplate
date: 2020-04-22 00:19:17
published: true
---

A tool that I made is called [GitScaff](https://github.com/barelyhuman/gitscaff), it's a simple wrapper around the `git clone` command but makes it a little simpler to clone repositories as templates from existing GitHub/Gitlab repositories and supports private repositories and Gitlab repository grouping so if you have boilerplate that is a private repository, you can still use this utility, because at the end of the day it is still a simple `git clone`

## Why though?

No real reason, I was using `degit` for a while and then it created an issue because I couldn't use it for cloning private template repositories and it didn't support gitlab's repository grouping either so it kinda bummed me out to have to clone and then get rid of the .git folder and all which i could do with a single command using an alias (which i should have...) in Linux.

Anyways, I had time to kill so I built this to do that for me.
