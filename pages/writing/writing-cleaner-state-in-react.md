---

title: Writing cleaner state in React and React Native
published: true
date: 30/08/2021
---

Ever since hooks got introduced in React, it made it a lot more easier to handle composition in react components and also helped the developers of react handle the component context a lot better. Also, as consumers of the library, we could finally avoid having to write `this.methodName = this.methodName.bind(this)` which was a redundant part of the code to which a few developers ended up writing their own wrappers around the component context.

## But that's old news, why bring it up now?

Well, as developers there's always some of us who just go ahead follow the standard as is even when it makes maintenance hard and in case of hooks, people seem to just ignore the actual reason for their existence all together.

If you witnessed the talk that was given during the release of hooks, this post might be not bring anything new to your knowledge. If you haven't seen the talk

1. You should.
2. I'm serious, go watch it!

For the rebels, who are still here reading this, here's a gist of how hooks are to be used.

## Context Scope and hook instances

If you've not seen how hooks are implemented then to be put simply, the hook will get access to the component it's nested inside and has no context of it's own, which then gives you ability to write custom functions that can contain hook logic and now you have your own custom hook.

Eg: I can write something like this

```jsx
import { useEffect, useState } from "react";

function useTimer() {
  const [timer, setTimer] = useState(1);

  useEffect(() => {
    const id = setInterval(() => {
      setTimer(timer + 1);
    }, 1000);

    return () => clearInterval(id);
  }, [timer, setTimer]);

  return {
    timer,
  };
}

export default function App() {
  const { timer } = useTimer();

  return <>{timer}</>;
}
```

And that gives me a simple timer, though the point is that now I can use this timer not just in this **component** but any component I wish to have a timer in.

The advantages of doing this

- I now have an abstracted stateful logic that I can reuse
- The actual hook code can be separated into a different file and break nothing since the hook's logic and it's internal state is isolated.

This gives us smaller Component code to deal with while debugging.

## What does any of that have to do with state!?

Oh yeah, the original topic was about state...
Now the other part of having hooks is the sheer quantity that people spam the component code with it and obviously the most used one is `useState`.

As mentioned above, one way is to segregate it to a separate custom hook but if you have like 10-20 `useState` because you are using a form and for some weird reason don't have formik setup in you codebase then you custom hook will also get hard to browse through.

And, that's where I really miss the old `setState` from the days of class components and there's been various attempts at libraries that recreate the setState as a hook and I also created one which we'll get to soon but the solution is basically letting the state clone itself and modify just the fields that were modified, not that hard right?

You can do something like the following

```jsx
const [userDetails, setUserDetails] = useState({
  name: "",
  age: 0,
  email: "",
});

// in some handler
setUserDetails({ ...userDetails, name: "Reaper" });
```

And that works (mostly) but also adds that additional `...userDetails` everytime you want to update state. I say it works mostly cause these objects come with the same limitations that any JS Object has, the cloning is shallow and nested states will loose a certain set of data unless cloned properly and that's where it's easier to just use library's that make it easier for you to work with this.

I'm going to use mine as an example but you can find more such on NPM.

```jsx
import { useSetState } from "@barelyhuman/set-state-hook";
import { useEffect } from "react";

function useCustomHook() {
  const [state, setState] = useSetState({
    nested: {
      a: 1,
    },
  });

  useEffect(() => {
    /* 
      setState({
        nested: {
          a: state.nested.a + 1
        }
      });
    // or 
    */

    setState((prevState, draftState) => {
      draftState.nested.a = prevState.nested.a + 1;
      return draftState;
    });
  }, []);

  return { state };
}

export default function App() {
  const { state } = useCustomHook();
  return <div className="App">{state.nested.a}</div>;
}
```

and I can use it like I would with the default class styled `setState` but if you go through it carefully, I actually mutated the original `draftState` and that's because `@barelyhuman/set-state-hook` actually create's a clone for you so you can mutate the clone and when you return it still creates a state update without actually mutating the older state.

## Summary

- Use custom hooks to avoid spaghetti state and effect management code
- Use a setState replicator if you are using way to many `useState` hooks

make it easier on your brain to read the code you write.
