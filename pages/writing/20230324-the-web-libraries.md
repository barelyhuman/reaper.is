---
title: The Web Libraries
date: 24/03/2023
published: true
---

Another rant? Not really.

We're just going through a few thoughts on the recent evaluations I did with
regards to frontend development since I wasn't feeling like working on anything
serious.

##### TLDR;

None of them are perfect, go with the one you find the least friction with, for
me that's `preact` + `@preact/signals` and if something simple, `cycle.js` or
just vanilla js with some reactive streaming library

---

The whole idea started with a simple thought of writing a simpler rendering
library, one which would keep the state, network, dom, away from the view side
of things and I ended up writing something similar to how cyclejs does things
but instead of streams, it was mostly callbacks to start with.

This moved ahead to a simple `h` or hyperscript implementation that was donated
by [Jason](http://jasonformat.com) which I used for a bit, modified it to handle
a simpler implementation of signals and then got rid of it. I didn't want to
build another jsx library. I get it that people like JSX and it's made it easier
for them to imagine the view but I honestly prefer template + directives (VueJS,
Angular 1).

The preference arises from clear separation of logic and view and the reactivity
is hidden underneath. I think the traction svelte has gained proves my point
about this.

Either way, after spending a few days on it I felt like I'm overthinking it and
I should just use a reactivity implementation and use the DOM directly.

This is where the current version of [typer](https://typer.barelyhuman.dev)
stands, it uses a simple pull-push signal context similar to Solid.js (and it
was inspired by the Author's own blog posts) and wrote typer using that. The
friction of writing it with effects and signal was basically null. Everything
just worked. All I had to be sure about was that at the end of the day it's JS
and there's no Functional programming optimizations that the interpreter does
for me so I should be vary of exceeding the stack size.

I spent like 10 mins refactoring it from it's previous implementation which used
element polling and modifying it to work with the signal implementation and it
was good to go. This was pushed and is what powers the current Typer
implementation. Doesn't end there though, at this point I wanted to see what
libraries can I recreate this with and with what level of friction.

## PreactJS

I'm leaving react out the picture cause it's basically going to be the same
amount of time.

First up, preactjs, the implementation got even smaller because I no more had to
monitor effects , I just had to make sure my props were correct and that the
signal's value was set.

The best part about using (p)react for something like this is that handling
resets, become really easy since you just reset the state and everything renders
itself accordingly.

This in vanilla JS requires you to clear quite a few DOM elements and regenerate
them manually, which you can accidentally make recursive and then it'd slow down
the app once there's enough instances in the memory.

## SolidJS

The experience with Solid js isn't much different since I was already using
preact with signals so this was pretty much the same, except that I didn't have
to wrap my head around the prop pass down, since in SolidJS, the function only
renders once and ended up making a tiny mistake of writing the function
execution in the definition phase instead of the render phase of the function.

```jsx
function Component({ signalProp }) {
	const x = signalProp * 2
	return <>{x}</>
}
```

People who write Solid, can see the mistake already, the `signalProp` is never
computed again and `x` is rendered with the same value as it was first rendered
with.

but that's on me and not the library so, that's okay. We've spent enough time
figuring out which hook effect executes and which doesn't a dozen time befores.
It's all good.

## Svelte

One of the current favorite libraries of web devs and surprisingly even backend
devs, which is rare.

The only way to start or the recommended way was to use ViteJS with the svelte
plugin or just use SvelteKit, which is fine but I'm not a fan of the `+page`
filenames, I remembers devs going, "Don't make too many `index.js` files it
becomes hard to find!" and now I have a shitload of folders all with their own
`+page.js` , `+page.server.js` files and I honestly made changes in the wrong
file twice while writing this simple thing.

Either way, the friction of actually writing the app was close to none and the
adaptors help with output so I guess I got the client only output I wished for.

## Cycle.js

I've rarely used cyclejs for one main reason, the amount of thought you have to
put into the streams when you are dealing with complicated cases is something
that you can avoid with the normal imperative coding styles in the other
libraries.

Don't get me wrong, I don't mean streams are weak or harder to work with, you
just have to switch your mental model to think in streams and I'll give you a
simple example.

I was building Typer with cyclejs and here's a simple thing that typer does or
basically how typer works.

```js
const words = getRandomWords(5)
const spanNodes = wordsToNodes(words)
renderSpanNodes(spanNodes)

const input = getInputElement()
input.on('keypress', evt => {
	if (evt.code === 'Escape') resetState()
	updateSpanNodes(evt.target.value)
})
```

Now, this is psuedocode but that's mostly what the app does.

If you see, we maintain the state external to the render and events handlers so
the reset actually just resets the DOM and everything else just stays as is, I
don't have to attach handlers again or re-render the entire tree and this is the
cool thing about writing in plain DOM. The reasons for libraries to exist is
that this can get quite tedious if you're building an app out of it (still
doable though, just hard).

Next up, how do you think I'd do this in cycle.js or to be specific, with
reactive streams ?

```js
// create an stream of input value events
const input$ = xs.of(inputEvents).startsWith('')
const escape$ = xs.from(input$).map(event => event.code === 'Escape')

const words$ = xs.from(escape$).fold((acc, i) => {
	if (i === true) return generateRandomWords()
	return acc
}, generateRandomWords())

const value$ = xs.from(input$).map(e => e.target.value)

xs.combine(value$, words$).map(([inputValue, words]) => {
	// view construction
	return div()
})
```

Confused? Yeah, let me explain.

When working with streams, you have to figure out what all areas of data are
going to change over time. In our case, the input value and the words will
change over time.

1. So I need 2 streams, one that's the words and one that streams the input's
   value.
2. Next, I also need a stream that can inform if the escape key was pressed, we
   use this to restart the typer.
3. So, overall I need 3 streams, one for input, one for words and one for the
   escape key presses.

We've basically created those 3 streams. Each one of them is dependent on the
other because I can't reset words until escape is pressed, so the `words$`
stream is listening to the `escape$` stream with gives true or false based on
what keycode is being pressed.

Similarly, `escape$` cannot exist without the original `input$` stream.

This can now be used to generate our views using `inputValue` and `words`, since
those are the 2 deciding factors for this app.

It's not that hard, but it does require you to understand how `fold` works,
because you can't just add a map over that stream because then it'd reset the
`word$` every time you pressed `Esc` but also reset it to the older set of words
if you pressed anything else after the `Esc` key.

Either ways, I wrote the typer with cyclejs and it's always been fun to write
stuff in cyclejs other than the problem I mentioned above which is, a change in
mental model.

It did take me longer than the signals version to write this, I think I spent an
hour because I messed up the computation for valid and invalid characters but I
guess it's okay to spend an hour to refactor the whole thing.

We also added a `speed$` stream which is also a combination of the `input$` and
the `escape$` stream, which you can consider as a replacement to the `computed`
property in signals. except, mine runs on every input event.

Overall, if I you had to use cyclejs for a larger application you are better off
with the reducer styled state instead of pure state streams. You can read about
that on the [`@cycle/state` docs](https://cycle.js.org/api/state.html)

## Vanilla JS + DOM

And finally the last one, which is no library. This solution probably is the
easiest one with huge amount of documentation all over the web. Best part, no
tooling required!!

Jokes aside, it's fun to write in Vanilla JS and to spice it up I rewrote the
same thing in FP (Functional Programming) style without using any of my usual
libaries (monet.js, ramda) and it did end up being longer because of the `IO`
Monad and destructuring the `IO` Monad every 2 lines but I guess that's the
whole point of FP.

You move the side effects as far away from the actual code as possible, the
frictional part is that the effect needs to run for you to debug and so you end
up with a lot of functions and effects running before you are even done with the
implementation. This is easily solvable with a quick refactor after you've
implemented everything but I'd really recommend not using FP when working with
the DOM, it makes it really hard to deal with unless you wrap everything in a
`Maybe` or `Either` and avoid using `IO` altogether. It's not that you
shouldn't, it's just that it takes too much energy to make sure it's all working
and you end up debugging twice as much. Though FP does give you the confidence
you need, as long as you remember the type defs and return type defs of each
function you write, which is JS is hard to do. Try out
[elm lang](https://elm-lang.org) if you wish to do pure FP with the HTML DOM,
you write in Pure FP and elm takes care of talking to JS and the DOM for you.

After all this, I still didn't really do anything productive but with an
imaginary implementation where

- JSX is optional
- I can write stuff as simple functions
- DOM is abstracted for me (could be streams, could be generators, idk)
- I don't need build tooling
- If possible template directives.
- network and async isn't an after thought, or provide ports / adaptors approach
  to be able to easily offload network instead of being forced to use a library
  specific dynamic.

I think the closest to all of that is [Alpine.js](https://alpinejs.dev) though
it doesn't promote itself as SPA library, you can write one with it. It's easier
to use it for server-sided rendering though.

I guess that's about it for today.

Adios!
