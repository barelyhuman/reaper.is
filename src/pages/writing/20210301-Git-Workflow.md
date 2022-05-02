---
layout: ../../layouts/Page.astro
title: Git Workflow
published: true
date: 2021-03-08
---

There's quite a few ways to work with git but here's how I go about maintaining the repositories that I work with or maintain as a solo developer while building personal projects.
I specify **personal projects** since the git workflow while working with a team differs.

Also, I've actually talked about this flow, one on one with a lot of people so It's easier to write it down once for people to refer to.

## Commands

Let's get over the list of commands that you need to know and understand to go ahead with this flow.

- `git pull` (combined with the `--rebase` flag, used when re-syncing with the remote) -`git remote` (manipulate the existing remote urls or adding a remote)
- `git push` (push to the upstream/remote)
- `git merge` (rarely used, but good to know anyway)
- `git rebase` (specially the `-i` option, to edit and re-arrange the commit history)
- `git commit` (make commits, i don't use `-m` ,i prefer writing descriptions for my commits)
- `git status` (current working tree status)
- `git diff` (check diffs in the terminal when working on the raspberry pi)
- `git branch` (creating and deleting branches)
- `git checkout` (to move from branch to branch)
- `git restore` (in newer versions of git, so upgrade if you don't see this command or it errors out)

Now those are basically all the commands I use, `git log` would be another but then I use [`commitlog`](https://github.com/barelyhuman/commitlog) now so that's out of the picture for most part right now.

When I say **know and understand**, I expect that you've at least tried out the command with a few flags that each of these provide.

I'll get into detail.  
For example, you've all probably used `git pull` and `git push ` enough by now. I would like you to go create a test repository make some changes on the remote , either via github's ui or on a different computer and go execute a normal `git pull` on your repository.

At this point , type in `git log` and you'll see the last commit was a fast forwarded `Merge` commit that got created because you tried to sync with a branch that wasn't local. Now a lot of people don't realise this but git defaults to `merging` in case of overlaps and this creates a lot of un-needed history on your repository and also confusion when browsing through them. The option to use? `git pull --rebase` , you could just set your `git` to default to rebasing but we'll get to why I avoid that and use the flag explicitly.

## Flow

Getting to the flow, let's start with an empty repository.

- Create a `dev` branch using the `git branch` command
- Push it to the remote if it isn't already pushed.
- Create a `feat/<new-feature>` or `fix/<new-fix>` branch as need, `<new-feature>` and `<new-fix>` replaced with the name accordingly.
- Best part, write the implementation or fix.

At this point, if I'm working on Github, i'd create a pull request, then rebase merge with the base branch if it's possible, if not then it's a squash merge locally if the number of commits that are to be rebased are over 10 commits.

**Reason** - Rebasing 10 commits, while going through each commit incrementally might not work if you've been working on the feature for a long time or shifting to other projects and there's code snippets you don't fully understand, so rebasing with conflicts over 10 commits might not be easy to go ahead with.

Though this is rarely the case with the repos I maintain, I did have this issue before when I was still learning git.

Now, the current feature implementation when maintained on a seperate branch has a max of 2-3 commits that are all seperated properly, how and why?

`git commit --amend` and `git rebase -i` are the commands that I use the most in my workflow right now, I start off with implementing a prototype for a feature, once the prototype is done and on a feature/fix branch , it's tested right then and there and pushed to remote, because I work from multiple devices so I can't just keep it as a local copy.

**Yes, I push uncompleted features to the upstream!** , but these are to branches that aren't merged and WIP.

Once we are back on the same implementation and making fixes to this, the changes are all made and `git commit --amend` comes into picture here. `--amend` basically modifies the previous commit and creates a new commit sha with the combined changes. Now, anyone experienced with git already knows that a new commit sha on the local and a different commit sha on the remote is a call for problems but this is basically why I never do any of this on the master/main branch even when I don't work with a team.

To push this modified commit you use `git push -f` or force push to the branch.
**Note: Never, I mean, NEVER force push on a branch that multiple people might be working from!**

So now, the remote is updated with the needed changes and now we can make a PR or rebase to the main branch locally and then I delete the branch both locally and on the remote, now I have one clean commit that implements the whole feature.

Obviously there's always going to be bugs, cases you missed, brain farts during commits that you ended up adding to the base branch, what next? force push on the base again? **NOPE!**

The only point of using force push was to maintain the remote sync with a branch that I might work on from various devices, not to edit remote history (that's a side effect when working from multiple devices).

If you are working from a single device, your amends are always going to be local unless the feature implementation is complete and this is how patches are supposed to work.
A more git friendly workflow is what I follow while working on sourcehut.

I work with email patches when working on something like [sourcehut](https://sourcehut.org/) instead of github, and making amends to commits is okay because it's never added to the actual repo, it's a simple email with the diffs that can change again and again, but limited to github's arch the force push on feature/fix branches are my only option right now.

**Next step**,  
So you now have a bug you need to fix, you create another branch with the `fix/random-feature` and follow the same thing, work locally , amend locally as much as you can, then push to remote and raise a PR. wait for the PR to merge, delete branch, update local branches with the base branches

```sh
 > git checkout main && git pull --rebase origin main
```

The overall point is to maintain commits atomic and self sufficient, this allows you to `cherry-pick` onto other branches when needed, allows you to get rid of features when needed (while not always possible).
Maintaining a good git discipline could help you avoid a lot of problems and if you are a power git user, `git bisect` could help you a lot here.

### Rebasing and Branchless workflow

This workflow is something I picked up a few months ago and since I use the macbook for everything right now, because I don't go around that much. The max it changes is from macbook to the raspberry pi that I run and test the cli apps on.

In this workflow, I don't need to really create branches or push to remote for sync with other devices, I picked this up from [Drew DeVault](https://drewdevault.com/).

Basically, You don't push the commit unless it's complete and just keep moving it up in the interactive rebase or squash it while working on something else, so the origin only points to features that have been tested and are okay to be added to the upstream, everything else stays on the local.

Drew talks about it in detail on his post [My unorthodox, branchless git workflow](https://drewdevault.com/2020/04/06/My-weird-branchless-git-workflow.html), which is basically what I'm using other than the patch part , cause most projects of mine are on github, will move them to sourcehut when I can, but I don't want to move every repository I have to sourcehut just one's I think are suitable enough to be maintained longer. Just to have a cleaner collection.

For now, that's it.
BTW, we've got comments now, scroll down to add one.

**Adios!**
