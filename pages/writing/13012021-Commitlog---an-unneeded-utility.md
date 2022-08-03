---

title: commitlog - An unneeded changelog generator utility
date: 13/01/2021
published: true
---

Ahoy people!

Another post, another project, another story as to why it was built.

We'll be talking about [commitlog](https://github.com/barelyhuman/commitlog), fork or star the project just to let me know you liked / are using the project so I know if I should be dedicating my weekend hours to the project or just focus on experimenting with newer projects.

I've been working with mini tools/projects a lot for the past year, somewhere around the time when I announced TillWhen and a few UI repositories that I wrote to support TillWhen. They all depend on the _tags as releases_ git flow and as any person using it, changelogs are an important part of the flow.

The changelogs in this flow are pretty much the difference between the 2 tag references and/or if anything breaking was added that's notified with an added description. Most of these are nodejs based projects so [vercel's release](https://github.com/vercel/release) was my primary solution to the problem of generating a changelog.

I was lazy to copy paste commits messages from one tag to another and had a tool do that for me, while I write posts worth 300 words. Ironic. I know.

Anyway, writing a Changelog is a redundant task and a lot of companies moved away from using them a while back, vercel's solution was built for their internal usage and ended up getting adapted quickly by the node dev community. Here's what release does for you if you haven't used it before.

It creates a cli utility that takes all your commits from a certain point to the other , generally between the last semver change to current commit ignoring any (.dev , .canary) type tags and asks you to specify whether a commit is a (major/minor/patch) change and you are asked about it per commit so if your last semver change was 100 commits away, Good Luck!

Though you shouldn't have such a major change anyway but I can see myself having 100 atomic commits and or canary tags that separate the 2 tags which can be 10-20 each with 3-4 commits on average and that's a lot of questions already. At this point, this data is then pushed to the projects GitHub release creation page with the new semver/dev/canary tag created for you and changes pushed.

It generates and fills the github release description for you in this fashion

```markdown
## Major

c13e227 - some commit message for major change

## Minor

c13e227 - some commit message for minor change

## Patch

c13e227 - some commit message for a patch type change
```

Now there's definitely a easier way to avoid the questions, where you provide the commit message with the change type in it's message, so the commit message can be `some commit message for major (major)` and the tool will not ask you to specify that commit's type or you can tell the cli to not ask any questions and it doesn't classify the commits at all resulting in something like

```markdown
c13e227 - some commit message for major change
c13e227 - some commit message for minor change
c13e227 - some commit message for a patch type change
```

Now while I like _release_, and have been using it for the node projects, as I started moving to golang and gomod based projects I had a small hiccup. _release_ depends on `package.json` to check for semver definition and this means I have to initialise my go projects with a package.json just so I can maintain changelogs which wasn't really pleasant , I could've just taken a fork , fixed this case and used it but then I had a few other things that I thought needed changing and so I ended up writing commitlog.

So, now let's list the issues I had

- Needs a node project init on any other programming language (not a fan of the node_modules folder in the local setup)
- has it's own standard for classification of commit types (not a deal breaker but still an issue)
- limited to GitHub releases (I'm moving to personal git servers and sourcehut so....)
- asks too many questions when you forget to specify the type of change in the commit message (can be silenced with `-s` but then the others aren't classified either)

4 issues, that's good enough to write one for myself and learn how to do it in a language I'm not comfortable in yet aka, Go lang.

## Commits Standard

I use a simple extract from [commitlint](https://github.com/conventional-changelog/commitlint#what-is-commitlint) where the commits are prefixed with a simple commit type and that's a generic commit format that almost everyone should be following , you don't have to add commitlint to your project but just writing messages with the commit standard is good enough, again it's not really needed but, it's an easier way to track commits. No more dealing with 100 questions but just making sure that I write proper commit messages, even if I don't they'd still get classified as Other Commits and the proper one's still get classified as they are supposed to be.

## No Language / Git Platform Dependency

It's a binary that can be run directly without any other programming language or need for any file to maintain the semver for you, since it doesn't really do anything GitHub/GitLab specific and hence it doesn't need any network to complete it's task, instead it just uses the existing tags to define what is to be considered a start point and end point and classifies all commits in-between and outputs a markdown to the stdout , so you can pipe this to other programs like `grep` `cat` `echo` or direct it to a file with `>` in unix systems

## No type? No problem

You forgot to mention the type in a commit or a certain commit has no dedicated type? it'll be categorised into `Other Changes` and you still have to just run the command , nothing blocking you and thus makes it easier for CI/CD aka, runs on any platform that can run the binary.

The only example you need to see is commitlog's own repository, every release changelog you see in the repository was generated by commitlog itself and you can check the GitHub actions workflow YAML to see how the binaries are packaged / how the changelogs are generated and published.

#### Did I really need to make one?

Nope, the creators of commitlint have their own cli tool as well , you can check it here: [conventional-changelog/conventional-changelog](https://github.com/conventional-changelog/conventional-changelog) and it solves mostly all problems mentioned above.

Don't have to justify why I made one because I've done that with a lot of tools already, but yeah, the go version binary is a lot more portable but still 5MB because 3MB is the go-runtime that's packaged with the binary.

Though I should probably make a version in portable C to reduce the binary from 5 MB to like something in KB's and maybe a lot smaller of a memory footprint. A project for later.

For now. Adios!
