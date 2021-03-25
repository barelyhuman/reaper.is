---
title: Go Lang and Web Scraping 
published: true 
date: 2021-02-22T04:44:43.354Z
---

Scraping websites is fun, but then I rarely ever tried doing it since setting up chrome and firefox to run headless on heroku is a daunting task and quite time taking in terms off testing. Which I did do when I made this [Epic Games Online Store Scraper](games.siddharthgelera.com) and as you can see it's quite slow because it takes time to live scrape, and while I could've had a database setup to store the prices the problem is I'd have to run a sync every-time anyway because the store changes price and new free games are added at any point so a live scraper was the plan but then epic started changing the view structure every now and then and it became hard to maintain it and so it's now just there for me as a reference if I ever need to create a scraper using `Nodejs` and `puppeteer` again. 



## Why talk about it now? 

No reason to bring a project that's about a year old , into the picture now, right?
Well, If you know how this blog works internally, it's just a nextjs app that renders the markdown text into react components, I should shift to `mdx` though. I will be cleaning the code of the site soon, it's quite repetetive right now and should be refactored. 

So, back to topic. The whole blog section is just 2 files of `.js` that renders content from `.md` files from the same repo and while I like the approach, since everything I write is in the same repo, it can be taken offline and you can run the blog locally if you like my posts that much.... doubt that. 

But i think being able to take it offline is a big advantage, though I was going throught [BuyMeACoffee.com](https://buymeacoffee.com) the other day and I remembered that I made 2 posts regarding my released projects there when this blog wasn't really deployed and I liked their editor. 

This is where the scraping comes in, they do have exposed api's but it doesn't expose the user posts and quite a few people have asked for it so they might add it in the future releases though for now, we are going to scrape these posts I've got there. 

## You wrote a scraper with Go, why should I care ?

Ah, because it didn't need a huge ass browser to be run on heroku. 

The whole 

> Build everything with the language you wish to learn 

concept really works well for me and since we are on the Go Lang train from the past few months, I gave it a shot and used a browser package the go community offers called [surf](https://github.com/headzoo/surf) and it's basically a programmatic browser , so it doesn't need a headless instance in the first place and acts like a browser. If i'm not wrong someone would've already made a testing suite using its api for web apps. The best part, it's a simple go lang package so it got compiled with the remaining program, so now I have a single binary file of a few MBs running on heroku with no other deps needed. 

No linux setup required , no waiting for 20 more apt updates and packages to install so that chrome can run headless, one single binary and it's fast, like the current instance of the worker is running for free, so we have the 10 second wake up time from heroku but that's about it. It doesn't take any longer than that. 

You can check the api by clicking on the link below. Obviously wait for the 10 seconds if the container has to cold start, but then your reloads will take no time, it spawns a browser, opens the url, scrapes and shows the results in under 2 seconds. I'm impressed, there's no caching logic in that code either (should add though)

[Posts](https://bmc-api-worker.herokuapp.com/posts) - All Posts

[Post Data](https://bmc-api-worker.herokuapp.com/posts/mailer-simple-e-mail-microservice) - Example Post Data

and so I think I'm going to do a lot more scraping now since it was a breeze to setup, use and quite performant without any direct optimizations that I've made. 



## You forgot to tell what you're going to do with the scraper.

Oh yeah, so now since I have the data from there, I realised that their post engine is kinda limited in terms of markdown recognition and also, directly reading from the API conflicts with my thinking of offline availability, so I plan on running a GitHub action every 3-4 days to go through this worker, get the data, create a markdown from the received html data and save it as a file into the repo if it doesn't already have the post. This sticks to the offline thinking for someone who'd like to be able to go through them offline and also I get to use the BuyMeACoffee's editor to make decent posts, won't use it for the posts that need code snippets etc, cause that won't work with their current editor.

That's it for now. 

Adios!