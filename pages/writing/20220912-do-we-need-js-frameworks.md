---
title: Don't use UI libraries/frameworks for everything!
published: true
date: 12/09/2022
---

**Do we need JS UI libraries / frameworks?**

Not always.

That's the answer and I'm going to go through why I think so with a short
example of things that people convey that a framework would handle better for
me.

The general argument that comes forward when supporting frameworks in

- Ease of use
- Performance Optimized
- Extendable

and, I'd say all of the them are true but also, you can actually make it less
abstract by not using one. I'd say differently when working with something a lot
more complex where you need to handle a lot of rendering.

Let's get to a simple app example,

I wrote [typer](https://typer.barelyhuman.dev) as a fun side project that I
could just spawn at any time to warmup typing on a new keyboard or for my daily
typing practice. I've got a decent typing speed which could be increased
slightly with some nice coffee.

Either way, I don't intend to get any more faster and doing the same exercise on
something like monkeytype forces me to put it my all to make sure I beat my own
average WPM every time and doing this everyday when it's just supposed to be a
warmup makes no sense to me.

Also , I just hate numbers for figuring out “Am I good enough?”, which might
help others learn how much they have improved but I'm fine with being average so
I'd just like to stay away from having to subconsciously answer that question
everytime I open a typing test website.

**Why is this a good example?**

Well, because the approach I took for the typing website uses a tokenization
concept and then modifying each token to show whether what was typed was correct
or not.

I could write this in react in the something similar to this.

```tsx
function CharNode({ correct, children }) {
  let classList = [];
  if (correct) classList.push("correct");
  if (incorrect) classList.push("incorrect");
  return <span className={classList.join(" ")}>{children}</span>;
}

const isCorrect = (source, character, input, pos) => {
  // logic to see if the character exists in the words typed and matches with what was expected
};

function Typer({ words, inputValue, currPos }) {
  return words
    .split("")
    .map((char, index) => (
      <CharNode correct={isCorrect(words, char, input, pos)}>{char}</CharNode>
    ));
}
```

This is definitely smaller than whatever the vanilla js implements and the
optimizing fact or what keeps the renders small is the fact that the same value
of the `correct` prop will not re-render the `CharNode` in most cases so I could
have 100 characters and this would be fast and at 1000 characters this would
start to slow down very slightly.

The same on the other hand in Vanilla JS would require something like this

```tsx
const words = "hello world";
const nodes = [];

function createCharNode(char) {
  const node = document.createElement("span");
  node.innerText = char;
}

function createContainerNode() {
  const container = document.createElement("div");
  return container;
}

function install() {
  nodes = words.split("").map((x) => createCharNode(x));
  const container = createContainerNode();
  container.appendChildren(...charNodes);
}

function update(inputValue) {
  words.split("").forEach((char, index) => {
    if (char === inputValue[index]) {
      nodes[index].classList.add("correct");
    }

    if (char !== inputValue[index]) {
      nodes[index].classList.add("incorrect");
    }
  });
}
```

That's definitely a lot more code and also not the first implementation thought
that a beginner would have. They'd instead re-render the entire node tree
everytime instead of manipulating each node by `index` or by `id`

Funny thing is, this is going to get slower if the amount of nodes cross 500,
reason being that the update tasks you add are to modify the tree which the
browser has to re-render and the entire cycle can be slowed down if there's a
lot of such updates going through.

The thing react / vue / or anyother framework that works with VDOM is that the
above manipulations are done on a programmatic representation of the DOM that's
faster to manipulate when compared to the actual rendering DOM and once the
updates are done the diffs for the same can be generated for the DOM vs VDOM to
run one update request on the DOM.

The advantage I'd have here over the framework would be the granular control I
can have over optimizing this, like this would get slow at 500 because of the
continuous update invocations.

Which I can throttle to be executed only once every 100ms, thus making it easier
on the browser's execution stack. I could add an async / delayed execution of
each update with something like a debounce to further reduce the continous load
on the browser.

Another advantage or more a side effect of the granular control is that when
profiling this app I'd only be dealing with code I've written for the updates
and make it faster by avoiding even more redundant paints on the browser as
compared to dealing with the abstractions that you can't fix and have to wait
for the framework's team to do it for you.

**Which brings us to the point, should you use one?**

And the answer is, _not always_, using them makes sense when you are dealing
with UI that's got a lot of complicated rendering logic (which is most SPA's
today) but when dealing with simplistic behaviour additions vanilla js should be
fine.

I don't need to add the entire react and react-dom to handle a page which is
just going to search through a small list of items and render them, that's not a
complicated flow.

Neither is it needed for something like a portfolio website where the only
reason you have framework is for the SPA routing solution for your chosen
library/framework (like, really?)

There's been vanilla JS solutions for routing for so long! I don't recommend
using the default `window.history` as it may or may not exist in the browser you
wish to target so a library is recommended here, just because the polyfilling
can be delegated to the library, or you can polyfill it yourself.

Using SSG will be it's own different rant, I saw someone with a portfolio
written in Angular so that's going to be a long one.

**But, I want reactivity!!**

- Yeah, okay, you can write node renders based on events by adding a simple pub
  sub model.
- Storing all shared nodes in a memory tree or even fetching them again with an
  `id` where applicable
- Or, create observables and move node creation into modules

There's quite a few patterns that've existed for a while, the new hyped library
you're using probably still benchmarks itself to the update speed of the browser
DOM but then you also probably will have an easier time writing an array that
handles the render diffing for you instead of writing a specific diffing logic
everytime, but then your custom diffing could be optimized to be a lot more
faster for the specific implementation since you don't have to bring in custom
primitives like state / observable thus reducing code but then having custom
primitive also helps with structure in the code so ...

If you now have an headache, you're welcome :)

Anyway, back to the original answer. It depends on what you are trying to do.

My general thinking is that can this be done with a simple function? If the
answer is yes, it's done with generic javascript implementations and not library
specific methods.

I use library specific methods or instructions when it's something that has to
be done with it.

For example, Fetching data in react cannot be done with a simple javascript
function because you have to store it in the contextual tree and for this ,
people use redux, useSWR, etc etc or store it in component state directly and
use it from there but it can't be a simple function execution and has to be an
effect invoked function with access to the state.

Vue on the other hand, allows you to execute a function and add the data to a
`reactive` variable that the component is listening to and so it's considerable
simpler. Same goes for svelte, solid, etc

In vanilla JS, you choose when to re-render the node so the magic part of the
libraries / frameworks can be ignored in this case and everything is either
reacting to a DOM event or is a function invocation.

The reason I prefer vanilla over libraries is that in most cases when working
with JS I end up breaking the app because a certain library decided it was okay
to add breaking changes in patch versions and I've always pinned deps but then
security vulnerabilities might end up forcing you to refactor.

So, when you are like me who might not look at the codebase again for quite a
while, and then when you are back to it and everything is breaking and the
solutions you find online is "Update to the latest version!" and you read the
docs and see 10 breaking changes so you leave the issue as is and be like "Hah,
the users probably won't see the bug that often"

and when doing it with a server rendered setup I can avoid having JS handle
complex behaviour and use vanilla to handle something that'll work in most
browsers and can be easily picked up after a while since it's "just javascript"
with no magic.

Though, I still end up using react a lot because of my work with react native
and shared react code but that does frustrate when something tiny breaks and all
I can do is wait for the team to fix/review PR , the only good thing is that
something like patch-package exists and I mostly add a lot of such fixes to the
codebase directly.
