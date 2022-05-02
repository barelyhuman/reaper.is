---
layout: ../../layouts/Page.astro
title: Themer and how you can handle dark mode a lot more gracefully
published: true
date: 2021-03-11
---

A few days back I was basically redesigning the long lost [todo](https://todo.reaper.im) app from my repositories and
I ended up liking my selected color scheme and the dark variant of it. This lead to a simple dark and light toggle that I wrote in about 20 lines of JS, by simply changing a key in the local storage and handling that change and edge case accordingly.

10 mins after this, I realised the the [commitlog-web](https://commitlog-web.herokuapp.com) could take advantage of the new color scheme and the web version of it is written in golang and html templates so I needed something vanilla so I just ended up using the above code from the todo implementation. At this point, it's all good, but then a small issue. It'd take the stored theme instead of the system preferred theme only and for someone who's theme changes automatically over the course of the day , this was a problem.

Now most people would be fine with just the `prefers-color-scheme` media query but now I don't assume what scheme the user would want to use for my particular app so I want him to be able to choose between system, light, dark and now this is where `themer` got created.

It's like 200 lines and you can probably understand by reading the source code , but I'll get through the algorithm just in case.

[Source Code](https://github.com/barelyhuman/themer/blob/dev/src/index.js)

Also, you can just install [themer](https://themer.reaper.im) and use it if you'd find that easier but here goes.

**Requirements**

1. Ability to switch between system,light,dark.
2. As a developer, the developer experience to just add in one button , point the library to it and have it work seamlessly.
3. As a developer, the ability to customize the toggles when needed so a function export that can handle the same context.
4. Permanent storage of the selected theme.

**The Plan**

1. Since there's a need for context, we are going to use a Prototype Function declaration for this library (more on that in a few mins).
2. Ability to customize the button, so the button won't be created dynamically but picked from the config provided to the library, though I wanted a quick setup so the library will handle the icons inside the button, just not the button creation and styling.
3. Write a function that can be exposed to the instance so that if needed, the person can create custom toggles programmatically.

**Code Flow**

1. We define a prototype function first. A prototype function is basically the vanilla js way of making/writing classes , give you the ability to add pre-defined methods to an instance created via the function as a constructor, an example of this would be `Date`

So, first piece of code.

```js
function Themer() {}
```

2. We need it to accept a config so that we can select if we want to handle the toggle ourselves or we want the user to handle it for us. Also, we will see if there's an existing theme value the user has or not.

```js
function Themer(config) {
  let element = config.trigger;
  if (element) {
    // Check if the trigger was passed a class string or an id string and convert it to a proper html node ref
    if (typeof config.trigger === "string") {
      element = document.querySelector(config.trigger);
    }
  }

  // existing state for the theme , fallback to system if nothing is found
  let defaultState = localStorage.getItem("theme") || "system";
}
```

3. Now, for the actual toggle, all we do is set the `body` tag to have an attribute called `data-dark-mode` and if this is present, your `css` can over-ride the default light mode variables or you can write custom css with this as a selector.

```css
body[data-dark-mode] button {
  background: white;
  color: #121212;
}
```

though, just resetting the variables would be easier, you can find an [example here](https://github.com/barelyhuman/themer/blob/dev/style.template.css)

4. All that's left is to find out which theme we are on and which the next one is supposed to be and this is done on the click on the trigger, also, remember we have to expose the function so we have to isolate that logic and also we need to make sure the same functions are also executed when the system preference changes if the set theme is on `system`

No use posting the snippet cause that's the whole [index.js](https://github.com/barelyhuman/themer/blob/dev/src/index.js) which you can read.

Hope you liked the post,

Adios!
