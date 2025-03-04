---
title: State of Preact 2025 (Q1) by reaper
published: true
date: 04/03/2025
---

While there isn't an official "State of Preact", here are updates since the
[last time I mentioned working on the ecosystem](/writing/20240213-i-circled-back-to-preact).

The Preact ecosystem continues to thrive, largely due to the effectiveness of
its React compatibility layer. While there's not much to discuss in that aspect,
let's look at a few new tools that were built.

**[preachjs/popper](https://github.com/preachjs/popper)**

A helper library that enables building component primitives for Preact without
adding bulk to the overall bundle. It's low-level, tiny, and gets the job done.

**[barelyhuman/adex](https://github.com/barelyhuman/adex)**

A really tiny plugin that integrates backend, frontend, SSR, and islands for
Preact to be used in any Node-compatible environment. We've made significant
progress since the original post, and I've explored various rendering and
tooling options. This remains the only integrated package that I'm maintaining
with incremental updates. While I hope to add features matching other
frameworks, my current focus is maintaining stability.

**Initial NextJS Migration Scripts**

I successfully migrated an old NextJS project to a Preact-based SSR while
preserving the NextJS API. This is just the beginning; I plan to enhance the
build script to facilitate easier migration for users still using the `pages`
style router and old non-edge API functions.

While the NextJS ecosystem has moved from `pages` to `app` router, I'm
constrained by time and resources to provide comprehensive migration solutions.

**[barelyhuman/uma](https://github.com/barelyhuman/uma)**

This is a simple starter template combining production-grade tools for Preact
SSR apps. It's nearly complete, with a few pending additions to enhance its
utility as a SaaS starter. While not strictly part of the ecosystem, it emerged
from existing efforts in developing Node.js and Fastify-based side projects.

### Future

My goal is to provide sufficient primitives in Preact for creating beautiful UIs
without reimplementing browser-provided components. I collaborate with the
Preact team when possible, but given our small team size, we welcome community
support through code contributions or financial assistance.

That's all for now, adios!
