---
layout: ../../layouts/Page.astro
title: Why are you providing it for free?
date: 2020-06-10 16:46:46
published: true
---

## Intro

Every time someone get's to know about what I'm building, a few questions arise.

- Why?
- It's so simple, anyone can make that, why are you wasting your time on it?
- Who would use that?
- You should charge for it.
- You are just wasting your time.
- Isn't that going to cost you?

I'd like to answer a few.

**Let's start.**

## Simple | To the Point Apps

The simplest example to this would be the task list I created about 2 years ago, it has had a few improvements. Like the ability to share the task list with others but that's about it.

The task list lives in your browser and is built with minimal and well thought code and no web frameworks. Makes it easier for someone to later improve the code for more performance, or maybe add additional functionalities without disrupting the existing ones. I rarely have to worry about bugs with something this small, its hardly 200 lines of code.

If you'd like to check the source (https://github.com/barelyhuman/rmnd-r)

Normally, that should be enough for people to understand why, but for others, I'll get a little into details.

1. A decided flow of business logic (rare among projects done for clients).
2. Lesser code to maintain, aka fewer bugs to fix.
3. Easy to scale , if you maintain the modular approach.

While the above 3 are something every projects should follow, developers normally mess up at point 2.

Why? A lot of developers have given up on the point of writing efficient software because "Everyone has 8GB ram and a TB of storage, so my 200MB APP with a full Chromium browser shouldn't be a problem for you." and obviously the other group with their "VS Code is so fast. It uses electron too!"

Now, while both of them are kind of right, you forget to see the whole picture. A full stack developer like me who has XCode, Android Studio and VS Code or Atom(I use atom so...) and Chrome and PostBird for Postgres and SequelPro for MySql and RoboT for mongo and Hyper for terminal and .....
you get the idea, your tool isn't the only thing I have on my system. The 200MB keeps adding up, and my RAM keeps getting eaten up by your so called "everyone has enough RAM nowadays" argument.

This is not just against electron. It's against the general mentality that the client can handle this amount of ram usage and this amount of space usage.

While VS Code is actually performant, people forget the amount of time it took Microsoft to get it to this point, go through their talks on it and you'll notice how much effort and hacking it took them to squeeze out that performance.

Why does this relate to my argument?
People prefer writing code that just works instead of efficient or well structured optimised code. Why? No time, strict deadlines, constant changes from clients. There's a huge list of factors.

**What does this do to the developer?**

The developer's now coding to make the software just work. He won't look at other things that need to be checked. He'll just get this change done and this laziness ends up with adding multiple lines of dependent code into a certain module that's being used by 10 different modules. Should I be blaming him? Nope, I can't. But, the approach of modifications to modules can be changed.

Not everyone has the patience and a large company backing them up for developing and optimising their software project. Plus, people try to make one app do everything. To the point where things start depending on each other so much that it becomes hard for a developer to make sure what he writes doesn't impact any another piece of code.

People with larger projects know this and have _partially_ solved this issue with tests and code reviews. I say _partially_ because when you actually go through this, you still spend time rewriting tests for something you built but then someone else's code change made your part of the implementation a little close to uh... un-reactive.

I don't wanna be a hypocrite , so I'll let you know that I myself have developed apps on Electron. I don't hate electron. I just think it's a little too excessive to packages the whole browser with the app, most people have chrome installed on their systems and we could use an installed version but that's a discussion for another day.

Now how do you solve this?
Treat everything as a package. Everything that can be reused should be it's own package. You don't literally have to create everything into a NPM package or a Rust Crate and post it but treat them that way. As in, you write it once, and the functionality is frozen. Everything else will be on top of it and not a modification to the original package. Yes, your new package now depends on the previous one but if there's 3 other components using it, you don't have to worry about breaking those components.

Modules and Components exist so you write isolated code that can be re-used by other modules without breaking it's own flow. DRY (Don't Repeat Yourself) , heard of it?

Hence, the small apps. I don't have to spend a lot of time deciding what goes where and can maintain a good sane structure. By small I don't mean write apps that do just one thing, but write apps that follow the above mentioned package or everything is a module based approach.

By the way, we were talking about this [Task List](https://rmnd-r.siddharthgelera.com/)

## Why don't you market them !?

There's not much that I can write for this question. I'm just not good at talking people into using something. I'm not skilled enough to act like I built a Lamborghini when I know I built a Maruti.

Also, most of the time I build things because I think they'd help me reduce my work. I've had the stupidest ideas and I just built them to get it out of my head. Never have I thought that any of my ideas would help the industry or others.

- Youtube based music player
- Idea Storage app
- The markdown editor
- Minimal CSS Resets

Just to name a few.

I don't know anyone who'd need these, because there's so many more well built apps that are being sold by companies with professional sales team. I can't compete with them. But, I can use my own apps.

So, ideas like these don't need marketing and if you do end up at my GitHub page , you'll see a lot of such apps.

## For Free? Really? Isn't it costing you?

I'd put it this way, my education had a very minute part in my development life. I was coding before I got into college and almost everything I learned involves blog posts and tutorials from the kind people serving the open source community. I've been a fan of open source and services that provide a hobby/free plan for the longest time. Why do you think I keep dreaming about joining Github and Mozilla.

**But GitHub has a paid plan, TillWhen doesn't!**

I realise that, but GitHub also has a huge user base and needs powerful servers which you can't afforded with your job's salary and hence needs a pricing model. Also, GitHub's been making more and more features free to use for solo developers as their revenue from the team based users have been increasing.

On the other hand, TillWhen hardly has 20+ users, I don't need a state of the art server. I can handle it with my day job's salary. You can donate to it if you'd like to but that's optional.

But, providing it for free helps me sleep better. Less money to worry about!

The other projects I have are all hosted for free with platforms like Heroku, Netlify and it's shared resources, and since I'm the only one using these apps, the usage doesn't break the free usage limits on either of the platforms.

The only pricing I pay yearly is the domain charges. Everything else I've managed to obtain for free. Thus, I don't mind giving it away for free.
