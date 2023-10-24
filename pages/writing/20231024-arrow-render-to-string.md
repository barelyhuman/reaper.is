---
title: Announcing arrow-render-to-string
date: 24/10/2023
published: true
---

It's rare for me to build something for the external world but here's a package
I ended up building while working on another project which I'll talk about
later.

## ArrowJS

[ArrowJS](http://arrow-js.com) is a simple UI library which takes the most
minimal approach at writing UI libraries. Something I truly wished I had come up
with but I'm happy it exists. If you've seend my tweets/Xeets for the past few
weeks I've been praising ArrowJS for a while.

I bet on it's simplicity enough to build a side project with it and while I was
building the side project, it hit me that a server rendered and client
re-hydrated method would make it much more snappy to use and so I went onto
writing a tiny utility to render the html templates that arrowjs has to pure
html strings. You'll see this in action once knex-studio get's the other set of
updates but for now we're going to just release the `renderToString` utility to
the world.

## arrow-render-to-string

[barelyhuman/arrow-render-to-string](https://github.com/barelyhuman/arrow-render-to-string)
is a simple JS module that should run anywhere that JS does because it's not
using anything runtime specific and is just Javascript.

The current scope of the project is to be able to help you `stringify` ArrowJS's
html templates and do that really quickly. ArrowJS comes with it's on view
mounting in place so there's no need for a `hydration` utility but over-time I
do plan to create a tiny framework that standardise how you write ArrowJS island
based apps.

Well, that's all I have for the announcement, any feedback that you have or any
issues you face just raise them on the repository and I'll check it out!
