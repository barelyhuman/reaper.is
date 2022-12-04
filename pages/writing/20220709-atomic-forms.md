---
title: Atomic Forms in React
date: 09/07/2022
---

I've mostly worked with Formik for most of my react form validations and the one
thing that always feels out of place is the re-initialization of state based on
the initial values.

Now, I understand why it needs to be a flag since you don't want it to be
considered a `dirty` field unless `touched`. This works but it also causes a few
rendering issues and as a human who can forget, you often end up writing stuff
that causes a 100 re-renders.

I could've sat and thought out a solution for this but I never did cause I was
busy trying to churn out libraries after libraries that no one needs (it's fun
though, you should try it).

Either way, on Apr 25th , 2022 , Dai Shi decided to play with an idea and
created jotai-form.

> [Initial Annoucement](https://twitter.com/dai_shi/status/1518562466627821570)

Now, this looked interesting

**What's interesting about this?**

Well, that'd need me to explain why and where you should be using
[jotai](https://jotai.org) so for now I'll just leave it at that. It's
**interesting!**.

Being able to write atoms that store form state isn't that hard but then adding
validations to it would need to add derived atoms and then handling async and
sync validators separately would require work. Then a form group level validator
would require even more work and you'd end up copying these derived atoms and
validator utils to every project you use jotai in or you could use `jotai-form`.

The library is its initial development right now but it basically handles atomic
form state for you.

To **elaborate**. Atomic state with it's validator isolated from other states.
Don't have to worry about the form's state needing a re-init since it isn't
abstracted from you and is just a state like you'd use with `useState`, but
instead you use `useAtom` here.

**But this would make the `dirty` field logic break!?**

True, also why the utils from the library allow you to change the logic used for
the dirty field calculation. You can modify it to match with your way of working
with the atoms.

**Done with the teasing? Show me an example!**

Sure, since the docs aren't added yet, you can use this example as a quick start
or use the repository's `examples` folder instead.

```js
import { atomWithValidate } from "jotai-form";
import { useAtom } from "jotai";
import * as Yup from "Yup";

// define an atom that needs to be validated
const nameAtom = atomWithValidate("", {
  validate: (name) => {
    if (name === "Reaper") {
      // throw an error to say that the value is invalid
      throw new Error("Nah, invalid name, you can't be Reaper");
    }
    return name;
  },
});

// you can also use form validation libraries if you wish to
// yes it supports async validations
// you can use a backend API for the validation for stuff
const nameYupAtom = atomWithValidate("", {
  validate: async (name) => {
    return await Yup.string().required().validate(name);
  },
});

const Form = () => {
  const [name, setName] = useAtom(nameAtom);
  return (
    <>
      <input value={name.value} onChange={(e) => setName(e.target.value)} />
      <span>{!name.isValid && `${name.error}`}</span>
      <button disabled={!name.isValid}> Save Name </button>
    </>
  );
};
```

- The state is still just simple singular state.
- I get to add async validations for cases where the validation logic depends on
  data from the database
- I can add an `export` on the atom and make it a globally available form state
  and I get validation with it wherever I wish to use it.
  ([conditions apply](https://twitter.com/dai_shi/status/1447892237753278466))

This might look like a lot of boilerplate code but it's actually not. It's more
separation of concerns and these are named as atoms.

I've been using the above library for TillWhen and it's what's responsible for
the multiple timers running on the screen. Though you won't know that since I
haven't published that version yet.

Anyhow being able to segregate form validation from the component's own render
cycles makes it a lot more functional oriented and in my opinion that's good for
not having to guess if your form is the reason for the re-renders.

I mean, the form might be the reason but that's very easier to check since the
state is exposed to you and is not abstracted which makes it harder to debug as
to what change is causing the re-render. Instead, you can just add a `useEffect`
on the form state to see if it's the one causing the undefined behaviour.

Anyway, I like the library and also why I'm contributing to it. That's about it
for the post.

Adios!
