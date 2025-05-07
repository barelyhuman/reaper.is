---
title: Migrating from Cloud storage solutions
date: 07-05-2025
published: true
---

A few weeks back, I started getting the 99% storage notification from Google
Photos, which reminded me that I had a PiGallery server running on my Raspberry
Pi that I hadn't used in a while.

Got me thinking about moving away from the dependency on Google photos as a
backup server considering a small change in how the countries function would
lead to me loosing all my photos overnight.

I knew I was going to self host but the Raspberry PI I had was low in power and
running software similar to Google Photos with Face tagging and image processing
would overheat it and probably even crash.

There were also things that I had to consider, which led to the PiGallery setup
getting left out:

- **Convenience of usage**: The ease of using services like Google Photos and
  iCloud Photo's backup.
- **Sync scripts**: These need maintenance, and any API changes end up adding
  more friction to the process.
- **Migration from existing services**: This is hard, and quite a few people
  just drop the idea because there's very few blogs and posts online that show
  you the options to migrate.

The post might be slightly longer than my usual stuff, so bear with me.

### Requirements

- Simple Image and Video Hosting
- Ability to sync from phone to the server
- Bonus points if it supports Facial and Location tagging and the ability to
  search using the same

### Solutions

- **OneDrive / Box / Dropbox**:
  - Syncing gets limited for mobile users since iOS requires manually moving
    everything to the cloud folder in Files.
  - It can easily get pricey and would just make Google Photos both easier and
    cheaper to use.

- **Self-hosted gallery**:
  - You could self-host a few tools that take care of syncing and visualizing,
    though the setup itself is slightly time-consuming since you have to get a
    few tools to work together.

- **A tool that does it all**:
  - There are a few of these that handle everything from the mobile app to
    syncing and facial tagging for you, and I ended up using one called Immich.

### Setup

The setup itself is pretty simple if you have already worked with Docker and
Docker Compose. If not, you should probably try setting that up locally before
setting it up on a server.

As for me, I used my ThinkPad as the server since I wasn't going to expose the
whole thing to any network outside my house, so a local broadcast of the service
was all I needed to do.

Here are the things that were done:

- Make sure the Linux system is connected using a static IP to connect to the
  web.
- Configure Docker and Docker Compose properly so Linux can start them up after
  a restart.
- Configure an auto-login user, so if the battery gives up during a power
  outage, it's easy to just press the power button and leave it to boot
  everything.

Next up:

- We run the Docker Compose file for Immich as its documentation explains, with
  close to no changes. I've just changed the port and database password.

Wait for it to start running, and then access the web version to set up the
admin account.

### Migration

#### Google Photos

This took two attempts. The first involved me writing my own script to download
every photo on Google Photos using Playwright, which worked but was kind of
time-consuming, and verifying that everything got downloaded was a lot of work.
So, I would suggest you skip this and just use Google Takeout instead.

The problem with Google Takeout is that each photo's metadata, specifically the
date and location, gets split out by Google Photos and hence needs to be
re-added using an EXIF modifier. This makes migration to other apps a be a
little more time consuming, but Immich has a supporting CLI tool called
[immich-go](https://github.com/simulot/immich-go) that allows you to use the
same API key model of Immich to upload Takeout zips directly to the server while
fixing the images as they come through. This makes the migration super easy for
users to do. You might need to keep the laptop active while this is going on.

**Steps**

- Create an API key for your account using account settings on the immich web
  portal
- Use this key with the CLI commands of immich-go
- Make sure you use the right command to import from google takeout zips

```sh
$ immich-go upload from-google-photos --server=http://your-ip:2283 --api-key=your-api-key /path/to/your/takeout-*.zip
```

#### iCloud Photos

This was easier since all you need to do is set up the Immich app on your mobile
device, connect it to the LAN IP of the server (in my case, the ThinkPad), and
select the folders you wish to back up and click on `Start Backup`. You can turn
on auto backup and background backup jobs in the settings as well.

You might want to change iCloud Photos settings on your device to _Download and
Keep Originals_ to ensure the high-quality images are uploaded to your Immich
server.

In case you don't have a phone with iCloud Photos and want to do it from your
MacBook, you can modify the same preference from the Photos app preferences and
then select all images and export them to a folder on your laptop. Then you can
use the immich-go CLI mentioned in the Google Photos section to upload the
photos to the Immich server.

### Cleanup

The iCloud cleanup is pretty easy. You keep the originals and then turn off
iCloud Photos for your device, which will delete all the photos from your iCloud
account. In my case, I wanted to reduce the used storage for iCloud but not
completely delete everything, so I just got rid of all the photos older than one
year. For Google Photos, however, I deleted everything, so now my mail started
syncing properly again, and I have enough space for new immediate backups if I
need them.

iCloud makes sure to keep the images in shared albums in check but if you use a
lot of shared albums then just make sure you delete images carefully or use
filters on macOS to only delete images that are not in any album.
