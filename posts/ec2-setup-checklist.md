---
title: Checklist for EC2 Base Setup
published: true
date: 2021-02-18T13:46:39.029Z
---

- [ ] Create an ec2 instance (obviously,you braindamaged alien) 
- [ ] Enable SSH (random port) and HTTP 80 on the instance.
- [ ] Increase the ssd/EBS size to a min of (20/40) Gigs
- [ ] Add a swap file to the system
- [ ] Install dokku
- [ ] Write a script for the dokku process for the current app (or use [dokcli](https://github.com/barelyhuman/dokcli), if you're completed it)
- [ ] Create a Dynamic Floating IP
- [ ] Map needed domains to Floating IP
- [ ] Get Repo, configure Repo to deploy to dokku 
- [ ] Refill Cup of Coffee.