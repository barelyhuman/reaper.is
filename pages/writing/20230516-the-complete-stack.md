---
title: Creating the complete stack
published: false
date: 16/05/2023
---

I guess there was a post similar to this somewhere when I was learning how to do web dev but I can't seem to find it, so this is a replacement post 
trying to share the same information that I received. 

There's a ton of things that even I've not learned yet so please do let me know if there's things missing in the post. 

Let's get started

Most of my love for loopback has been thrown around in tweets, and previous posts on this very blog while comparing it with the more modern options. 
And to be fair, I'll be ignoring modern options unless they do bring something to the table that couldn't be done with the more battle-tested tech. This is going to be a long ass post, so be prepared. 

## The Stack and Deciding on Tech. 

There's basically 3 scenarios here. 

1. You're doing this the first time and have no idea 
2. You've done this before but then people have recommended better tech 
3. You've done this for years and already understand how to pick and choose tech. 

We're going to go with people in points 1,2 first. 

To be put bluntly, there's no "perfect" tech. There's no "the best programming language" nor is there "the best tech stack", it's subjective and you'll always find people of the opposite opinion. To simplify, the right tech is the one you've gotten really used to but also the one that makes sense for the work you're doing. 

Ex: 
- Microservice with limited resource requirement - Go/Rust/Zig/Nim lang, native http, templates bundled with the binary. C and C++ if you're feeling brave. 
- just a REST API for a requirement of 60k req/sec - Literally any language and it's std library implementation can achieve this today
- ML/AI Research - python or R because of the amount of research done in the area by their community. Also, because let's say languages like JS have an upper limit on it's number implementation and precision issues so it's better to do it with R and Python. 
- Kernel level drivers - C / C++ / Rust , Even if you can, please don't use JS here..... 

Point being, a lot of the times you have to evaluate these things to figure out what works, and not get attached to a language. Remember, the point of the programming language is to be able to communicate instructions, you don't need to get attached to it. 

Before people go crazy, yes, there are languages that are easier to learn and pickup when compared to others and in scenarios where your language can handle the use case, just go with it. 

For the people who are specifically interested in web dev, I guess the easiest and also the hardest language to learn out there is Javascript considering all the knick-knacks that come with it but the goal for the language is pretty simple. It's try to be universal. Though it's not your only choice. 

If you're someone who's strictly into backend development, you can still go with other languages that've actually proved their worth in the industry. Python, Ruby, PHP being a few of them. 

**But they are boring!!** 
It's boring because they've made most common tasks, easy. Imagine that writing email,password auth is still a step people do manually. The point of a framework is to laydown a base for you to not thing about 
what and how to do something. and Rails, DJango, Laravel have been observing the community and their usecases for long enough to have added most of the basics of a web server in their starter apps. The same goes with languages like Elixir and their Phoenix Framework where most of their documentation changes are now tied around adding guides for best practices for making development even more productive and it's not quoted as the "THIS IS THE RIGHT WAY" but that "This will make it easier for you to achieve this and scale with" and that's why they are boring, because when writing CRUD apps, you basically have everything layed out. Don't have to do much for the simplest apps. 


Moving back to deciding tech, now with web dev, the frontend is limited to one language - JS , with the exception of languages that compile to JS ([Elm](https://elm-lang.org/) , [Imba](https://imba.io/)). 

So how do you choose between the ever changing number of libs. 
As of writing this post, I'm aware of the following
- (P)React 
- Vue
- RiotJS
- NanoJSX 
- SolidJS 
- Meteor 
- Angular (framework)
- Svelte
- emberjs (framework)
- jQuery
- Moon 
- CycleJS 
- hyperapp

and honestly, that's like the tip of the iceberg, there's so many more out there that people have built and it's rather hard to decide what to use so let me repeat myself. 

**They are just tools!!!**

Pick whatever seems interesting and get to using it or use whatever you've been using for a while. The one you've the most if the fastest you can develop in. I'm slower in Vue when compared to react, I'm faster with Angular cause I'm faster at writing JS methods separately and HTML with emmet separately. Is that going to be the same for you? Hell no. I can write decently with CycleJS but then a beginner with no idea of functional programming might struggle
with the concept of referential transparency and data transformation based development. 

The point being made, get a feel for a select few of them and stick to what you feel is easy to work with. There's the obvious case of **Which one has more jobs** and in that case, it becomes a geographical question and not a tech one. You'll have to search through your job boards for your city/state/country and see which one you'll have to learn. For me that was Angular and React when I started. Though I was a fan of RiotJS back then.

As for people who already have been working with a certain tech for years, you probably don't have to switch unless the library/framework you are using has stopped maintenance altogether, which is rare with the ones that catch attention and if they aren't built by me they are definitely being maintained. 
The tech world moves forward based on an opinion of requirement. Rails has been using sidekiq and improving it for years now, doesn't mean that that's the only solution. I've been using redis with rsmq for years now and that's something that just works for me so I'll stick to it. If you think that the new tech that just arrived solves the hiccups you have with your current tech, then yes, evaluate it. But do remember that, that will still have issues and issues you might not find work arounds for. 

One such example is Sequelize, I used it as the ORM for about 8-9 months and ended up writing more raw queries than ORM queries as work arounds for various cases that the library just didn't want to address, in that case you have 2 options. 
- Fork the library, fix it, and raise a PR with the original hoping they add it to their library. 
- Look for an alternative. 

I went with the 2nd option in that case and have stuck with knex for the past 3.5 years. I evaluated knex in a few non-serious side projects and it worked well, was simple and straightforward and I hardly have used any work around, other than date range queries for postgres. Not that Sequelize is a bad ORM but it just didn't work for me so I switched to something I'm more comfortable with. If you bring in a new ORM for me to use tomorrow, obviously I'm going to be slower in that as compared to using my defacto query builder, knex. 


## The Requirements to make a complete stack. 

Here's a list of things you'll need in almost every web app that's decently sized. 

- Task queue(s)
- Transactional Emails
- A hosting environment 
- Automation to deploy to said hosting environment 
- Some form of observability + Analytics
- Data Caching / Staic Asset Caching
