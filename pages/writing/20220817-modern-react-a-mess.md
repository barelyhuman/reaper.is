---
title: Modern React, is a mess.
published: true
date: 17/08/2022
---

Clickbait title, I know. It's kinda true though.

Every 2 days, there's a new thing about react and how to use it, that the whole
"it's just javascript" statement makes no sense to me anymore.

I've made a few statements about moving back to class components and, I've
actually done that for a lot of components at work.

**Another one of your futile rants?**

Maybe, idk, I'm just a dumb guy.

A few months back I figured out that context shouldn't be used for state, and a
few days after that, I read a post about it from library maintainers stating the
same thing.

A little later I found an issue during maintenance of a project where a
component was had excessive re-renders due to a dependency missing in one of the
`useEffect`'s and that was an easy fix, but then we figure out that we shouldn't
be doing data fetches in `useEffect` altogether.

[Source Tweet](https://twitter.com/jody_lecompte/status/1526630424692269058)

Now the thread involves quite a few known people in the react community and I
get the point of not doing it in useEffect but we were introduced to useEffect
as an alternative to `componentDidMount` and if I wish to get data on mount I
will put it in there.

I mean, we can use a data fetching library which also does this but then, we
have to make sure that we don't update the fetched data into a state primitive
due to internal react update paradigms. (also why micro state libraries are
needed)

I could be wrong, I didn't write react, nor did I wish for it to be so
complicated.

It doesn't end there though, there's been changes on how to do stuff in react
quite a bit over the past few years and it feels like it's no more _just a UI
library_.

It's got it's own way of doing things and this brings back the Angular
environment where the community would just go crazy because something wasn't
done the _"Angular Way"_.

Now, react and react native are something I use on a daily basis and I can't
just throw it up into the air since there's no other alternative to react native
for me (I'm going to let flutter mature a little more before I jump on that
train).

**So, any solution after all this rant?** Apparently not, The options include
using libraries that handle these flows for you and falling into dependency hell
and more of reading documentation than being able to write code and that's
bearable, I guess.

Unless. Something breaks.

Then your options are to fork and fix and then you might do something wrong
because "that's not how you do it react!"

Satire aside, the options really are to pick up good libraries to help you with
most tasks and if possible stop using hooks altogether.

**Why would I stop using hooks?**

Based on posts and reading code bases / documentations, the primary reason for
them to exist is to help library developers setup a good flow for you.

For example,

**useSWR** A library to fetch and cache keyed data or more formally an
implementation of stale while re-validate which is a paper that specified the
mechanics of returning stale data while revalidating for new data in the
background.

The library is amazing and can handle most cases today because of the simple API
that allows you to pass in a `fetcher` which is basically the function that'll
define the data fetching logic.

Now, could you implement this yourself? Sure.

To simplify the behavior,

1. A fetcher function that depends on a key
2. The key is what decides what something will be cached under, like an
   identifier
3. The hook is to return the `error`,`data` values and if there's neither then
   the network call is active or it's in `loading` state.

Simple right? Yeah, no...

The library isn't 500 lines for something that simple.

1. It has to maintain a global state for you to be able to fetch the same stale
   data in other components that might also be in the view.
2. You should be able to manage dependencies of each useSWR hook separately.
3. The passed in fetcher needs to be cached so it's passed to a `useRef` and
   monitored.
4. the key is also cached and monitored similarly.
5. You need to see if it's the component's first mount and if the above 2
   (key,fetcher) have changed since that first mount since a react component can
   have up to 4 renders on the "initial" component render.
6. The `error`, `data` isn't a state(`useState` value) inside the custom hook
   but maintained in cache and fetched from it to be sent to you, because if it
   was just the state primitive swr would be causing a lot more renders on every
   `mutate()` call you trigger.
7. There's also cases where you have to handle cancellation of these fetch calls
   since if the calls complete for an unmounted component then that's considered
   a data leak
8. and this goes on (totally not trying to avoid explaining the remaining 100
   lines)

So, can a frontend developer who's work was just to write a simple UI render
after getting data from an API function or SDK do all this in every project?

**But they only have to do it once and then copy it everywhere!**

Yeah and then copy the fixes back to the older projects, right?

Don't claim it to be beginner friendly when it's not, and it's definitely no
more javascript.

**All that bashing to promote your library?**

Nah, my library doesn't even solve all the above problems, and it probably has
more issues that I can even imagine right now and I'll only find out about them
as it starts getting used by more and more people.

So, no.

My libraries have nothing to do with this. Also, I haven't even mentioned any of
them in the post yet.

**But it works!**

It does, and it works beautifully. I've mentioned it before, I don't hate the
library, but that doesn't mean I'm not irritated by the decisions.

Luckily I'm not smart enough to sit and write my own UI library that'd work
everywhere (web,ios,mac,windows) so, I'm going to have to adjust to the
decisions taken by the devs of react but, I can sure put it out there that
something is wrong.

The devs of react will have convincing reasons for those decisions and I might
have missed them while going through the RFC's , so that's wrong on my part.

**Just use class components then!**

Ah yeah, about that. I already am.

Sadly, the amount of HOC's I have to write to get the data from libraries that
only have hooks is rather high but that's okay, that's still a manageable way to
do things (at least, right now)

The only magic point in class components was the `this.setState` call and
everything else was just simple plain javascript, I could control what would
cause renders with `componentDidUpdate` and `componentWillReceiveProps` and
honestly that control is missing so yes, class components is a good option. (
Yeah, `React.memo` exists but the docs ask you to refrain from depending on it)

So, valid options are

1. Class Components + HOC's to get data/actions from hooks
2. Good libraries that you can trust the devs are actively maintaining (so,
   nothing from my github!)

Finally,here's resources on things that'll help you be a better react developer
in case you wish to know the right way to do things

Oh also, on the contrary the react docs do ask you to make ajax / api calls on
useEffect.

1. https://reactjs.org/docs/faq-ajax.html#example-using-ajax-results-to-set-local-state
2. https://tkdodo.eu/blog/avoiding-use-effect-with-callback-refs
3. https://tkdodo.eu/blog/use-state-for-one-time-initializations
4. https://kentcdodds.com/blog/how-to-use-react-context-effectively
5. https://kentcdodds.com/blog/application-state-management-with-react
6. https://www.joshwcomeau.com/react/why-react-re-renders/

You can find more by yourself, but hopefully this has been a nice rant for you
to read.

Adios!

Update: Added another link (6.) above as it does explain quite a bit visually
