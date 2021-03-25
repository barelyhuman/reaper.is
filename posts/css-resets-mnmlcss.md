---
title: Consistent UI's with CSS Resets and announcing Mnml.css
date: 2020-04-22 00:23:34
published: true
---

Another post, another day.
or was it supposed to be the other way....

Anyway, CSS Resets.
Everyone's heard of [Normalize.css](https://necolas.github.io/normalize.css/)? No? Are you serious!

Never-mind, so Normalize has this amazing set of css properties that someone decided to write so that the CSS we write is consistent across browsers and this makes it easier.

Now since this is possible some people figured that it'd be nice to have stylized resets, so you could just link them into the head element and voila! beautiful html without any additional overhead.

A few examples would be

- [Milligram](https://milligram.io/)
- [Water.css](https://kognise.github.io/water.css/)

And these are actually really good, but then there are certain things that I wanted to restyle and also certain helpers that I keep adding into my css, I know tailwind provides them! I'm not going to add a full css library and then setup purifyCss when I can type it out in the same amount of time. So, I picked one up and modified it to have my own set of resets and here's where the shameless plug comes in.

- [mnml.css](https://mnmlcss.js.org/)

Just like the above two, it uses it's own resets. Other projects where I managed to use this.
and since all are available on my github, you can check the code to see the implementations

- [Corona Tracker](https://corona.siddharthgelera.com/)
- [Markdown Editor](https://monotes.barelyhuman.dev/)
- [Hiring Network](https://hireme.barelyhuman.dev/)

you can check the git repo for the available classes and the resets that are modified [git repo](https://github.com/barelyhuman/mnml.css) later today
