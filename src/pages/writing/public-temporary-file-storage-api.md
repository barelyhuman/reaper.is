---
layout: ../../layouts/Page.astro
title: Why I built a temporary file storage and left the API Public?
date: 2020-04-22 00:17:10
published: true
---

Now, this isn't a very complex project and anyone who's worked on basic web servers can build this.

## But Why did I build it?

I had this project where I needed to upload images and Firebase's storage was my first alternative, I kept using it but then the storage quota just asked me to go find a better solution, because the moment you upload over 15-20 images you've completed your storage quota and now I'm stuck with a upload code that won't work and I can no longer upload images to Firebase.

My next alternative was Imgur's API to upload private images but then that limits me to a certain amount of uploads per minute.

And then I started looking for a service that'd allow me to upload images for the sake of testing and then delete those images after a certain threshold time. Sadly, didn't find any or I just sucked at searching. Either way my last search result for this was [file.io](https://file.io) and it was kind off what I wanted but It would delete the file the moment I requested it for the first time.

So, I ended up building one, for the people who'd like to know what services are being used for this, it's just a combination of Next.JS for the demo page and Node.JS and MySQL for the back-end. All of this is hosted on Heroku's free tier for now, since I'm the only one using it and both Heroku and the db would stop working if someone were to overload the API so that's that. I know it's not a good solution but it works since I'm the only one using it.

## But without any authentication, people are going to use up all your storage!

I understand that but as of now I'm the only person who knows about it's existence so that's that and if people do start using it, let me know in the comments so I can add up a full fledged API Key based access system for the API and also move it to a Digital Ocean server to increase the storage and also increase each file's time to deletion.

Files uploaded from the demo site have a 30 second life and will be deleted after that.

Here's a link to the [demo](https://tempx.barelyhuman.dev/)
