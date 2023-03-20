---
title: Code Deployments and Security
published: true
date: 19/05/2021
---

A simple post focusing on what CI/CD methods I think are worth spending time on and things you can do to avoid letting it out in the open for hackers

The post is specific to server based apps, I will make a separate post about mobile app setups in a different post.

Here's a few CI/CD methods that I know of and the one's we'll be talking about

- Self Hosted CI/CD and Deployments via SSH
- Docker Containers and Deployments via SSH
- AWS's Systematic deployments
- Git style deployments (Heroku, Dokku, etc)

## Self Hosted CI/CD and Deployments via SSH

This is the traditional way of doing deployments. The idea is to have a bastion host and then this host has access to your deployment environments and
takes care of running builds and pushing the builds to the needed server or even better, triggering a build on the needed server and monitoring the
progress.

A good example is the a Jenkins setup

**Quick Note**: Never, I mean never let the bastion host be open via default ports, and obviously, shut down the 80 port as well, use a random set of
ports for both SSH and HTTP.

#### The Cons

- The setup can be time taking and financially intensive since you setup multiple instances , one for jenkins / go ci cd / drone ci cd , and then one
  or more for projects, and then have to upscale in terms of memory and store based on how many builds you want etc and can get costly when doing that
- You technically have a single point of failure, someone hacks the bastion host and you basically gifted them access to all other instances.
- You get a limited number of parallel deployments due to the hardware limitation, easily fixed by increasing the ram etc but not the best solution
  for everyone, not everyone can throw in extra money.

#### The Pros

- SSH keys are on the actual bastion host and these keys are machine specific so you don't have to worry about it getting leaked unless someone
  actually hacks the bastion host which is rare if you're using a good provider and the point of failure can be made a little more secure.
- Good User management, tracking logging, etc etc everything that every self hosted CI/CD will ever tell you. Next setup.

## Docker Containers and Deployments via SSH

With everything moving to cloud native setups this is a lot more common around devs and this mainly involves the Runners / Container that we can find
with most CI/CD services today, examples would be Buddy Works, Gitlab CI, Github Actions, Circle CI etc etc

These basically give you a isolated container that you can run your script in and thus reduces the overlap of past caches (does support caching if you
really need it) effecting a fresh build. These are amazing and obviously a lot more scalable since each runner can run a deployment and you are still
limited as to how many you can based on the service you use but considering Github Actions and Gitlab Runners I've had 3-4 run in parallel and I can't
really complain with that count on a free plan.

### The Cons

- The total isolation makes the build time longer if you are using the generic images from docker hub as you need to setup the environment again and
  again compared to a one time setup on the self hosted or bastion host method. This adds to the build time but easily fixable via writing your own
  Docker Images and using them if your service is docker based. If they have a container service of their own then well the build times are going to
  stay. (really irritating during monkey patch deployments)

- Also brings a learning curve as the scripts need an additional syntax, so if you haven't worked with yaml, you'll have to learn that, if you're on
  AWS ECS, AppSpec JSON, etc etc, while all these config standards are quite simple to learn , it still adds up to the setup time so going to mention
  this as a con

- The SSH Setup and deployments from these normally need a private key pair added to the actual container using some form of config from the platform
  which differs in each service that you use. Which people just blindly add because a post on some blog told them it was okay to throw their private
  keys like that.

### The Pros

- Clean Environment so no trash from earlier runs create an issue and can confirm fresh builds with the most recent clone of the repository
- Don't have to setup the environment again and again if you do create a docker image for one it's easily usable in any other CI/CD environment today
  since almost all of them follow a similar pattern in terms of deployment requirements. I have used multiple github action workflows in gitlab by
  making just changes to the accepted config syntax (again, adds to the time so still a con)

## AWS's Systematic deployments

The nightmare of deployment setups, you start with 100 services and then link those services and then hope everything works but no you forgot to
change the security group for one service and now you'll have to fix that but oh no you forgot which service was to be restarted to make it run so you
restart one by one and it's been 4 hours.

Sarcasm aside. A major contender in terms of a Dev Ops environment and technically they've taken care of all security concerns I normally worry about
but still the amount of setup it takes is better off done with terraform config. Manually is really going to take a lot of time, there's a reason
terraform exists and devops love it.

anyway, no cons and pros here because it's basically a good standard as long as the ports are left on default. Mail me stuff you think should be added
to improve security here and I'll test it out and edit the post as needed.

## Git style deployments (Heroku, Dokku, etc)

This is one of my favorite ways of doing deployments since there's no involvment of keys , heroku can hook onto your git repository to and take care
of deploying on changes.

On the other hand, there's Ansible which can also handle this while using a local ssh key so your private key isn't gifted to any service.

Dokku is another alternative and works in a similar fashion and you can push to a dokku repository and it'll build it there for you.

The only flaw is heroku since it is protected with email and password and people use amazing passwords and don't add 2fa so .... for that i'll blame
the developer and not the service but if someone hacks on the service, you pretty much loose your source code and not someone who hacks on all your
data because in these cases the data is a separate service.

One other problem is the rollback mechanism but it's only on dokku since I have to trigger another rebuild, I can use plugins to cache the rollback
build but doesn't provide it by default so I'm going to rant about it. Kidding, it's a simple fix plus has enough plugins to take care of a lot of
things.

You can't modify a simple line and restart server to test it so this is going to need a commit and push to work which might not be ideal for services
that need to quickly monkey patch security vulnerabilities but works for most other scenarios.

### The Cons

- Builds and Rollbacks are equally timetaking in case on emergencies. Not an issue if you just push changes and don't have a full fledged build phase
  or if you add in a plugin that can handle rollback caches for upto 2 - 3 successful builds.
- Again uses containers so things from containers in a way do apply here.
- Can get pricey if you use heroku, fixable by using self hosted dokku or ansible with a ec2 instance

### The Pros

- Simplest to setup since it has build packs that adapt to your setup and all you need is a Procfile that decides what command is to be run
- Easily scalable, since isolated services and containers

## Security

While I would love for everyone to go ahead with heroku and/or dokku a lot of people already have a setup and wouldn't like to change it just because
I said that something else is better, so instead lets try to fix the minor issues we have with these setups.

The first setup with bastion has the problem of being able to do anything and everything with the connected resources. This can be solved by

- Don't use the default ports for SSH and HTTP on the bastion
- Limit the bastion host keys to only be able to run one command or one script on the connected or deployable servers and if you wish to connect to
  the actual servers with access to do everything have another ssh keypair that has a password protecting the ssh authentication. In short, non
  password protected ssh key to be limited to running a single script on the server and password protected ssh key will allow you to have proper
  access for everything.

"Reaper, they can hack into the password too!", yes they can.

But, the password will take a significant time to crack , you can have logs of those attempts stored to monitor if someone unauthorized tried to log
in. Also, the password attempts can be limited on most ssh daemons so that adds in even more blockage.

The same solution can be used for Docker Container Runners like Gitlab and Github where you provide your private key to the runner.

- **Don't use your personal ssh key and add that to the runner!**
- Generate a nice little key pair for the particular requirement and add that as a base64 encoded string to maintain integrity and then decode the
  masked base64 string in your build config files (.gitlab-ci.yml, .github/workflows/action.yml,etc) and again limit the key on the server to be able
  to only execute a single script.

### HOW DO I LIMIT IT TO EXECUTE ONE SCRIPT !?

Good question.

There's a file called `~/.ssh/authorized_keys` where you add public keys that can access the ssh daemon and connect to the user. What you can do is
add a few parameters before this key to limit what the key has access too. You can find all the parameters on the
[authorized_keys manual](https://www.ssh.com/academy/ssh/authorized_keys/openssh) from openssh and one of them is `command` . Basically you can
provide a string of command(s) that whenever the ssh-key connects, the system is to execute it. So, in our case we are going to add a command that
runs the `execute-deploy.sh` script.

So, it'll look a little something like

```shell
command="echo 'hello'" ssh-rsa [.....]
```

Now everytime the holder of this key tries to ssh, he will just see `hello` and the session will end , if he sends any other command, that'll also
just execute hello and end the ssh session.

In a real life scenario you are going to have something in the lines of :

```shell
command="bash -ic /home/reaper/execute-deploy.sh" ssh-rsa [.....]
```

To break it down

`-c` : run the commands from the following string

`-i`: create an interactive shell, which if you don't provide, will try to run the script in a plain tty environment and all the commands/binaries and
custom path setups you made on the server might not work in the script you execute.

Now all I need to do is pass this private key to the Runners and if the runner tries to connect, it executes a deploy. If gitlab or github ever leak
the private key, the max he can do is execute the script unless he brute forces his way into the server and then decides to kill everything, sadly, I
don't have the knowledge to prevent that right now.

You'll know when I have more ways to help improve things like these.

As for now,

Adios!
