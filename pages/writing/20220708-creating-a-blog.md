---
title: Creating a blog
date: 08-07-2022
published: true
---

If you've been around, you know this very blog has been re-done about 4 times now.

It started with a simple nodejs script turning markdown to html, then we had the next.js version that I played around a lot with, then the statico
version that actually kinda sufficed what we had and now back to the over-powered astro framework for something so simple.

Any sensible developer wouldn't be spending time doing this again and again but then , me and sensible doesn't really go together, does it?

### What do I use to create my blog?

Well, this question has been coming up a lot recently and being directed towards me in my peers and to be fair, I really don't know.

There's so much cool stuff to use that it's hard to decide but I'll still try to minimize the options for you so it's easier to decide.

#### Quick and Simple

The quickest way to get a blog is using [`hugo`](https://gohugo.io/getting-started/quick-start/) and the theme that I like is
[Paper](https://themes.gohugo.io/themes/hugo-paper/) and [Anubis](https://themes.gohugo.io/themes/hugo-theme-anubis/), these really are very minimal
and easy to read on.

#### For the Terminal Club

I sometimes go in full terminal mode and do all work from the terminal, though this keeps changing over time so having a blog in the same way sounds
like a fun idea. Though, it's not for me because I'll get bored after a while.

Either way, the option is [prose.sh](https://prose.sh/), the basic concept is to ssh into the domain, get a username and then you can use your
username to log into a directory that'll create a blog for you on [prose.sh](https://prose.sh). You don't manage anything, just content.

I like the overall idea and as a minimalist , the blog's style is quite lovely but as I said, I'd get bored with it quickly and would move the content
around again so it makes no sense.

#### For the Frontend Devs

Now, this is the club that needs to show it all off because the website does act like a portfolio and they have to make a good impression.

**You do frontend to, don't you!? Why bash us!?** I do and no one's bashing you.

Now, lately most frontend developer website have started to look the same since everyone just picks up Chakra UI, Next.js and done.

Oh wait, change theme colors and done.

That's a fair approach to it if you aren't used to designing and it looks pretty decent and if I'm interviewing a frontend dev I do expect them to
have website or a blog.

So, what do you do? I would recommend building something with simple html,css and js without involving react but then go ahead use
react/vue/solid/alpha/beta/gamma/.... whatever.

Point being, try to keep compatibility with older versions of browsers like, at least 0.5% browserlist compatibility.

#### For the Backend Devs

Most backend devs that I know would be better off not touching code at all for stuff like this.

Go ahead with hugo and a markdown editor that can commit to git. Should suffice most of your use case.

If you do wish to spend a little time on it, then do a little more work and get a frontend that renders notion's pages and just write on notion and
let it index on your website. This gives you the freedom to write from any device that notion can be installed on and you hardly worry about
publishing or build processes.

## End Notes

You can use astro as well though astro is still being actively developed and I wouldn't recommend it for developers who are serious about blogging.

I use it cause I'll loose 0 readers even if my blog stops working tomorrow, since there's only 1 person that reads it.

Also, if it does break, all posts are in the source repo.

Though, back to serious blogging.

90% of the time your blog's looks don't really matter (unless you are also creating a portfolio) and people would still read if you're providing
value.

Simple example would be an example post from [danluu](https://danluu.com/simple-architectures/)

Though, I'd recommend at least adding a few styles for readability, examples would be

- [https://paco.me/](https://paco.me/)
- [https://cmhb.de/](https://cmhb.de/)

which are by people who spend a lot of thought on the prose and it's design so you can enjoy reading it.

as always, 0.5 value from the post and that's about it for this one.

Adios.
