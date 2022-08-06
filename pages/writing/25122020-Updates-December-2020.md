---

title: Updates December 2020
published: true
date: 25/12/2020
---

Ahoy Human!

It's Chirstmas and I've slept for 18 hours now.....

Anyway,

Back to what we are here for, Updates (cause I'm some celebrity with a huge following waiting for me to post this),
I won't start with TillWhen this time, people are already bored of it so I'll add it to the last.

## Language Updates

Most people already understand that I've been trying to move out of the web dev scene for a while and while I did use Javascript for the desktop apps while hating on electron (hyprocrite much!?) but recently I've started using Fyne with Golang to build app and the latest example of this is the [Spotify Lite App](https://github.com/barelyhuman/spotify-lite-go/releases) about which you can read [here](/posts/10122020-Moving-away-from-web-apps---Story-of-Another-experiment.html).

- Start Practicing Go Lang more frequently
- Attempting to build CLI and Desktop apps in GO
- Doing light learning of Rust while I'm at it, because rust is a little harder in terms of getting used too.
- JS and TS is still on a decent side though I've started properly adding types to my Typescript apps instead of using the `any` type just because I'm lazy to specify a type definition there.

## Project Updates

### New / Still Planning

#### Pfer

Another app that i'll be building but this is going to be a web app since I need available on all platforms and I don't have the patience to wait for Apple to approve everything so we're going with web app for this one. This is a simple playlist sync and transfer app for Spotify Playlists.

I'm not sure about you guys but I have this thing were I add everything from my Saved Library to a Playlist so I can share that playlist around and it's a good amount of work if you don't use the desktop app and I wouldn't want to download 100MB app , login, sync playlist with saved songs, delete app and repeat whenever I want to do this sync.

Pfer is basically going to be a simple web-app for that purpose, there's not link for you to visit right now, I'm still deciding on how I'll be making it, I want to build something serverless and drop the whole thing on Vercel's servers, though the 10 second action timeout might create a block in certain cases and thus I'm still thinking on how I'll be splitting the actions.

### Existing Ones

#### Spotify Lite

- Changed auth mode to use PKCE, since the client creds don't allow refreshing and I totally forgot about it when writing the initial app, it's fixed on the current release which at the time of writing this is 0.4.0
- Added a few helper and loading screens , this was needed since I cannot use the spotify web API's for playback control, unless the user is a premium user , I probably missed it during reading their reference but my premium ended and the app stopped letting me control the playback so that fixed it for you guys. This is basically why using something you've built helps in figuring out issues no one else will.

#### TillWhen

Here's our favorite one! So TillWhen's slack app is being tested by real people on the beta instance right now and you can do that as well, you can sign up on https://beta.tillwhen.barelyhuman.dev and try out the slack integration from Profile > Integrations > Add to Slack.
Remember it's a beta instance, I might clear the database, or i break the god damn server if I wish to when ever I want so don't use it to save time logs that matter to you.

Oh, and make sure you report those issues on https://github.com/barelyhuman/tillwhen-issues/issues , and then I can move onto fixing them.

I'm sad though that no one's donated yet... I'm kidding, though Its good TillWhen has 140 users right now, which is good considering I only promoted it on ProductHunt and maybe , just maybe on HackerNews and LinkedIn.

## Sleep and Work Updates

It's all going good, the works going great, I've improved my sleep cycle quite a bit with the solution I wrote a few posts back, you can find it here](/posts/12102020-The-Fight-with-Ones-brain---My-Sleep-Solution.html) , No I'm still not on any social websites though my self hosted Email Server idea didn't really go well, though I might use SourceHut's Email Lists , modify it a bit but I'm still not sure about it.

As for repositories, I've started mirroring repositories on Gitlab and bitbucket for most repos that I have or care about, bitbucket one's are still on private though I like the overall interface of bitbucket but the runners on Github and Gitlab are more functional in my opinion so it's a little hard for me to just jump out of them immediately.

That's about it for now.

Adios!
