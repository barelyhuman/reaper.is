---
title: Updates 15th and 16th May
published: true 
date: 17/05/2021
---



I think I should add more tutorials and tips than just post updates but I don't know, I just prefer using the blog as an Update Log, I will try writing more tips and considerations from now on. 

As for now. 

This update log is mostly focused on **Taco** cause that's all I worked on this weekend. There is a certain parser I wrote for a bit of work from office and it's a small update so let's start with that.



### Mobile Version Sync 

So, at [Fountane](https://fountane.com) we've been getting a lot of hybrid app requests for mobile development recently and it's a pain to keep the NPM, Android(Gradle) , iOS version and build numbers in sync and this causes an issues when things like an Update server are involved. 

I did look up some NPM alternatives for the same but they weren't being maintained much and I didn't want to sit on a fork of a simple tool I could've written (or so I thought) and I got onto it. I already knew the iOS just needed updates in the Info.plist file so that would be a quick thing. 

- Read the plist file, parse the xml , edit the `CFBundle` properties for the version and build and write it back to the plist, easy. 
- Same goes for Android, read the build properties , update the versionName and versionCode, write it back and done. 

Much to what I thought, there was no parser for gradle files in golang , so I ended up writing one which took me almost a day because I wanted to handle a few edge cases(not all) that would cause issues during the use case. 

And it's a tightly coupled parser right now, as it's part of the version-sync cli  right now, I'll decouple it as soon as I'm done with Taco, don't want to pause work on Taco and pick up new projects right now. 

If you wish to understand the logic behind the parser, I did write a small prototype for the same in JS before I wrote the actual go lang parser so you can find the JS version on [barelyhuman/gradle-parser-proto](https://github.com/barelyhuman/gradle-parser-proto) and the go lang cli tool on [barelyhuman/mobile-version-sync](https://github.com/barelyhuman/mobile-version-sync) , again it's in development and being used for a very specific use case, generalising it is a plan but not till I'm done with the existing project.



### Taco 

Trust me, I try to keep these posts short, they just end up being big since I unconsiously add in stuff that I think people should know. 

Back to the topic, we've got the 

- Auth (will be changing to passwordless before release)
- Projects 
- Tasks and Tasks Status 
- Settings and Plans 
- Integration with TillWhen (This one might come as a shock)

#### Auth 

I'm basically done with the Auth part and it used the traditional email and password but I'll be moving it to the magic link setup that TillWhen has once I'm done with the rest of the features, this was done because it's quick and I didn't want to use TillWhen's code because I wanted the code to be concise for this project and TillWhen has patchy code that I didn't want to just copy over. 



#### Projects 

Simplest one to implement, creation and assignment and visualising of projects is done, here's a preview 

![Preview Projects Taco](/assets/preview-projects-taco.png)

What you see is the light version of the screen, the creation is using keyboard shortcuts for now because this is a **developer preview** and not what the end version will have. You'll have proper buttons to create projects but the keyboard shortcuts are most likely going to come bundled as well. 

The alert icon you see is actually a pulsing icon and I can't really show it well in a picture but it pulses when you are approaching a project deadline.

The menu on the bottom allows you to go to the project details to check on members and tasks as needed. 



#### Tasks and Status 

Already implemented this quite a few times now with [todo](https://todo.reaper.im) and TillWhen also has a beta task list so I don't think I need to explain what and how this is but it's not Kanban, I really don't see the need for someone working to have to go through moving items here and there in a board instead of just marking it as done or any other status, but that's just my thinking and Asana does it well but get's very bloaty in terms of things you can do and you accidentally end up clicking on something you didn't want too. Not what I want from a project manager. 

Here's what the tasks look like right now. 

![Preview Tasks Taco](/assets/preview-tasks-taco.png)

Again, the creation is left on keyboard for now and the assignment to users and projects is still being done since I need to add filters for the same in a way that doesn't add to the bulk of what you see visually. I'm still working on the UX for the same. 

The squircle dots on the left are the visual representation of the current status of the task and are what you click on to move it up or down, since the concept of backlog doesn't exist right now, it's not in the menu, I do plan to add that later since I use the backlog more than I use the actual task list. 



### Settings and Plans 

Nothing huge here, just simple notification settings for now and obviously the ability to update your username, the Plan defaults to `Hobby` for everyone right now since the payment gateway etc will need a little more work and that's not going to be a part of the initial release anyway. 

![Preview Setting General Taco](/assets/preview-setting-general-taco.png) 

![Preview Setting Profile Taco](/assets/preview-setting-profile-taco.png)

![Preview Setting Profile Taco](/assets/preview-setting-billing-taco.png)

Also since payments are going to be involved I'll have to prepare legal documents for the same and hence the whole billing and card addition is going to part of future releases and not the initial one.

 

#### Integration with TillWhen

Sad to say but I might shut down TillWhen after this particular feature is done and added to the release, this is still in works since both apps need to be updated to be able to do this. The overall plan is for you to be able to export all data from TillWhen and import it on Taco and then taco is where you also handle time logs, so yes while this a big thing to do it is something I do have in mind. Reason being it'll be hard to maintain and work on 2 decently sized projects as an Indie developer.

Or i can move everything that Taco does into Tillwhen but then that's more patches here and there which I don't want too. Why is TillWhen Patchy? It was built in 2 days, what do you expect ? 

Also I didn't plan scaling, integrations anything, I got lucky with them because of how I write but that's about it. It's got enough hacky and patchy implementations. The slack integration is a joke on it, exactly why Multi Workspace Slack integration on it has not been done yet. I don't want to break the existing implementation thats working well.

That was a long post...

Fortunately, that's all.

Adios!
