---
layout: ../../layouts/Page.astro
title: Weekend Updates -  March 6th and 7th, 2021
published: true
date: 2021-03-15
---

## TillWhen

This week, I wasn't really feeling like developing or working on TillWhen so there are no specific updates there other than a small patch that adds to the authentication check during first render of the app.

## New Additions

The past week was mostly me working on [themer](http://themer.reaper.im/) and making fixes and making the code more cleaner and readable in case someone else wants to fix something that isn't working as they expected it to.

Another project that was created yesterday was [conch](https://github.com/barelyhuman/conch), a micro library to handle sequential batch processing of promises for systems that can't handle processing like a 100 promises at once, and also something I needed to regulate for cases where I have to preserve memory usage, though the current logic can be improved a lot.

## Modified / Feature Upgrades

Other than adding themer to most maintained projects, [music](https://music.reaper.im) got a UI upgrade and now supports importing spotify playlists into the queue, you can either replace the entire queue with the playlist or add the tracks from the playlist to the existing queue. The keyboard shortcuts it had still work but are not listed on the UI right now , since I haven't figured a good way to show them on the current UI style without making it look odd.

Minor work includes template updates to the [ftrouter-templates](https://github.com/barelyhuman/ftrouter-templates) repo, and this includes an experimental cli command that was added to the current `master` branch of [ftrouter](https://github.com/barelyhuman/ftrouter), it now allows you to init a folder though this is not in any of the official releases tags, also I finally plan to sort the of ftrouter using some cli tool framework first before I release ftrouter onto the npm registry. You can still install it using the git repo as the repo consists of the compiled source.

```sh
mkdir -p new-project
cd new-project
ftrouter --init # which is a shorthand for `ftrouter --init -d .`
```

For an example on how ftrouter works you can check the [music-server](https://github.com/barelyhuman/music-server) or the minimal template's example which includes both query and param cases as well.

That's all that I was able to do this weekend, though I plan on focusing a little more on TillWhen next week, let's see if I do.
