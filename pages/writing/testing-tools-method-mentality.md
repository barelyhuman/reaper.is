---
title: Testing - Tools, Methods, Mentality
published: true
date: 06/12/2021
image_url: https://og.reaper.im/api?fontSize=13&title=Testing+-+Tools%2C+Methods%2C+Mentality&fontSizeTwo=8&color=%23000&backgroundImageURL=https%3A%2F%2Freaper.im%2Fassets%2Fog-post-background.png
---

If you are in a dilemma of whether to write tests or not, I did cover a bit
about that in a
[previous post](https://reaper.is/posts/31052021-Tests-vs-No-Tests.html)

As for what this post is going to cover, here's the overview

- The tools (the one's I normally use)
- The methods (what method of testing will you need for a certain scenario)
- How you think in tests

No other fluff, to the topic!

## Tools

Almost every testing tool out there, at least for NodeJS is mostly agnostic.
Agnostic in terms of what you can use it for, you can use them for web, mobile
(react-native, ionic,etc) or even desktop (electron). The setup for each varies
and each setup could be it's own individual post and I might just write them
someday. The tools I normally end up picking are the following:

- [uvu](https://github.com/lukeed/uvu) - A test runner by Luke Edwards, which
  supports most standard setup's today and is the fastest and most of the time's
  the first one I pick
- [avajs](https://github.com/avajs/ava) - Another one but, this is mostly
  switched to, when I'm working with react based projects since ava supports
  having 2 separate babel config by just adding that config in the
  `package.json` file, while this is possible in `uvu`, it requires a separate
  programmatic `setup.js` file which I avoid doing since ava makes that a little
  more simpler
- [jest](https://jestjs.io/) - And when everything else fails to suffice the
  use-case or if you don't want to even setup test runners, jest normally comes
  with the `create-react-app` setup, so this is what I use when working with
  full fledged react apps, instead of the above two.

**The overview**

- uvu, ava -> Small Libraries, cli apps, tooling , anything other than a react
  web app
- jest -> Full scale react apps

There's obviously a whole bunch of other test runners out there, the above 3 are
my choice because the test runner and assertion is both handled by the same tool
and if you want to use other assertion libraries, you are free to do so with
`uvu` and `ava` , i've not tried that with jest so I wouldn't know.

Overall, I like uvu's assertion API so I end up using that in most places.

Now, the other kind of testing setups I've used in the past have
[Mocha](https://mochajs.org/) and [Chai](https://www.chaijs.com/) as a
combination, one is a testing framework and the other is an assertion library.
This combination is battle tested and is a part of really huge projects if you'd
like to take that stability into picture, on the other hand while `uvu` and
`ava` are stable, the source code is easier for me to go through and thus, fix
if I do need to do that at any given point.

## Methods

Getting to how and when would you use the tools, no matter which one you choose
to go with. I'm not going to go through every method there is but the one's that
I've worked with cause I'm limited by my knowledge.

- Functional/Unit
- Snapshots
- Event Flows

Each can be used for a specific type of project or you can mix and match since
they are just methods aka, when you use them is to your own instinct. As for
when I use each, you'll get to know that anyway.

### Functional / Unit Testing

The most common use case is writing tests for singular functions or the base
`input=>output` flows, where the same input gives you the same output, this can
include anything from library functions to http requests to the god damn space.

You'd add these to stress test your functions for null values, invalid values,
random values, and obviously the happy (valid) values to make sure you get the
correct output on each.

You can find example for this on the
[tocolor](https://github.com/barelyhuman/tocolor/blob/5c638ebf8bcefbeb6e7eb97e8886a487574d669c/tests/index.test.js)
repo's tests, an example from it

```js
test("hex to rgb", () => {
  Object.keys(colors).forEach((color) => {
    const convertedColor = hexToRGB(colors[color]);
    const ref = MATCH_MAPPERS[color].rgb;
    assert.equal(convertedColor.r, ref.r);
    assert.equal(convertedColor.g, ref.g);
    assert.equal(convertedColor.b, ref.b);
  });
});
```

Where `test` defines or describes what's going to be tested, `assert.equal` is
what checks if the generated value from the helper is equal to the expected
value, this will fail if they don't match, thus letting me know that
`hex to rgb` conversion is failing.

### Snapshots

While working with web and webviews, snapshots are what start to become common,
a snapshot is a simple JSON structure _in some test libraries_ and the entire
View DOM in others.

The point of snapshots is that you are trying compare 2 exactly same structures
and if the structures differ, you need to either fix or update the snapshot. An
example to help with this would be from
[sindresorhus/react-extras](https://github.com/sindresorhus/react-extras) as I
don't have any public repo's with snapshot testing

```jsx
const snapshotJSX = (t, jsx) => t.snapshot(render.create(jsx).toJSON());

test("<If>", (t) => {
  snapshotJSX(
    t,
    <If condition={true}>
      <button>🦄</button>
    </If>
  );
  snapshotJSX(
    t,
    <If condition={false}>
      <button>🦄</button>
    </If>
  );

  let evaluated = false;
  snapshotJSX(
    t,
    <If
      condition={false}
      render={() => <button>{(evaluated = true)}</button>}
    />
  );
  t.false(evaluated);
});
```

react-extras provide you with a simple `If` utility component which takes in a
condition and renders based on the condition. The above is basically a test for
that which takes in 2 predefined values and make a **snapshot** out of them or
to be simpler, a JSON structure of the rendered dom.

If the utility is working correctly, the first `If` render would render the 🦄
as expected and the 2nd would render nothing, this will create snapshot where
the render only has 1 button. **If** the utility fails and both are rendered the
test runner will give you an error stating that the snapshots have changed and
based on that you either fix your utility or if you have made a change that adds
a new rendering element, then you update the snapshots by forcing the runner to
consider that the snapshot is correct and it needs to update it's stored data.

A few of these tools create a markdown of the snapshots as well, so you can
visually see it , you can find one for the above code snippet
[here](https://github.com/sindresorhus/react-extras/blob/fc24dedc82947eae4853e78d251da2a742728660/test/snapshots/test.js.md)

### Event Flows

This is not with regards to web but anything that depends on async code or event
based code, there's not much to change here when compared to the
[Functional / Unit Testing](#functional--unit-testing) but instead of checking
to values instantly, you wait for the events to occur (which should be obvious).

In web you can use the DOM handler utilities that the frameworks provide,
Angular has these for checking if something has rendered or not, or if a certain
reactive variable has changed.

React comes with it's own set of utilities , specifically the `act` function,
you can read more about it on the
[docs](https://reactjs.org/docs/testing-recipes.html), but to simplify I use an
abstraction library on top of this called
[testing-library/react](https://testing-library.com/docs/react-testing-library/intro/)
which is by [Kent C. Dodds](https://kentcdodds.com/) and it adds a lot of flow
based utility functions on top of the existing react testing helpers.

The same team provides similar abstractions and flow helpers for other
frameworks like Svelte, Vue as well, so the concept below can be applied to
others.

Let's take [barelyhuman/react-async](https://github.com/barelyhuman/react-async)
as an example for this

```jsx
test("<AsyncView data={fetchPostSuccess} />", async (t) => {
  const networkData = await fetchPostSuccess();
  const { getByText } = render(
    <AsyncView data={fetchPostSuccess}>
      {({ data, loading }) => {
        if (loading) {
          return <p>loading</p>;
        }
        return <p>{data.title}</p>;
      }}
    </AsyncView>
  );
  await waitFor(() => {
    t.truthy(getByText(networkData.title));
  });
});
```

The above test is trying to test the success case of an API call from the
`AsyncView` component provided by the library. The flow of the above is as
follows

1. Fetch data with a fetch request
2. Use the same fetcher in `AsyncView`
3. Render the above `AsyncView` to the DOM
4. Wait for the fetched title to appear on the DOM

The fetcher is basically pulls data from a mock server and compares it to what
is rendered by `AsyncView` once it's gotten the data. If it's the same, then
`AsyncView` is working as intended.

You could however, use snapshot testing for this. It will suffice as a valid
test case here and the only reason I didn't do it is to avoid storing that extra
markdown and snapshots file.

The other case is triggering events on DOM, which is also common and you could
have similar use-cases when working with backend where you would want to trigger
a redis message and handling from the test case, in which case you will have to
use the redis listener and dispatcher in the same test case and wait for each to
complete like any other async function.

For the web however, I do have an example so you can refer to that

```jsx
test("useAsync | refetch", async (t) => {
  const { getByText, queryByText } = render(<RefetchView index={0} />);
  await waitFor(() => {
    t.truthy(getByText("hello"));
  });
  const buttonEl = queryByText("hello");
  buttonEl.click();
  await waitFor(() => {
    t.truthy(getByText("world"));
  });
});
```

The above is for the `useAsync` utility from the same library as above, and to
test the hook, we create another component that is rendering the data from the
hook. Using static data in this case but since we need to check if refetch get's
new data based on existing params or not, we've made the rendering a little
different. This is mostly how you will be testing hooks since they need the
React context to work, for any other function you could just go with Unit
Testing but since hooks are dependent on the React context for the reactivity or
handling changes, you are limited to actually rendering it inside a component.

As for the test itself, the flow is as follows

- Render the original component
- Wait for the original rendered data after `loading` has completed.
- Grab the button using utilities
- Fire a click event on the button to trigger a refetch call
- Wait for the new data to be rendered on the DOM

All of these are Open source so you can check that out in the tests folder in
the [repo](https://github.com/barelyhuman/react-async)

### Mentality

Writing tests isn't hard but figuring out how a certain flow can be tested can
get to you pretty quickly and so it's easier to do TDD but then TDD also
requires you write script the tests first and that does require time.

The general mistake is to test the entire flow in a single test, which often
backfires pretty quickly and it's very hard to manage them anyway.

While writing tests, there's a small checklist I'd like you to consider

- [ ] Test case is isolated
- [ ] Cleanup/Resets handled
- [ ] Dependent Data is handled separately

#### Isolated test cases && Handling Dependent Data

If observed, the above test cases handle very specific and very contained cases
and that's natural when working with components but even if you working with a
lot of helper functions / library functions, you keep you test cases limited to
that function. The whole point of unit testing is to point of which exact unit
is causing issues and not testing the entire flow.

Though, I understand that testing the entire flow can be necessary and this is
where dependent data based testing comes in. A very simple example of this would
be working with REST API's or GraphQL or whatever network based data interface
you use right now. General flow of any data based transaction would look like
the following

1. Send a request with certain params
2. Get response with a structured data
3. Use the structured data to visualise or manipulate again.

Point _3_, can be handled via Unit tests by passing in valid, invalid, arbitrary
data and that cuts the failure of those particular cases. Point 1 and Point 2 ,
deal with reading a datastore, which can give dynamic results so it's not the
result that matters but the behaviour and the final response.

So, if I want to create a todo and list the todo, my request takes in the task
and its status and when calling the listing api, I get back an
`{id,task,status}` as the base parameters that I'll be using. How would you test
this?

1. Write a single test case sending and receiving the todo data and validate it.
2. Write 2 tests, one to test creation and one to test listing and validate that
   the required response parameters are there

Most people pick up point 1 and write tests and while this works well for
smaller cases like the todo app, it is a disaster for larger flows, like a
checkout flow which will need you to validate the following

- Items
- Order data
- Payment Credentials
- Payment success
- Order Confirmation

one single test, doing all that... amazing.

On the other hand, if you use point 2, you now have unit tests that can be
replicated as much as needed for various cases and to manage the dependant data,
do not clean the data on each test but instead after the end test.

Taking the above checkout flow in picture

1. Clean DB
2. test to add items into the cart
3. test to list the items
4. test to create an order
5. ... create payment request
6. ... validate payment request
7. ... check payment success / failure
8. ... confirmation of the order

Now, why would you spend time writing 7 tests instead of 1?

- Your tests can now be modified singularly without risking breaking other tests
  since they still look for data from a single source instead of what you
  defined in the test itself.
- Easier to remove cases when you change flows since one doesn't depend on the
  other and all just depend on the source of data.

Eg: Client comes in and says it's going to be a free product, don't need the
payment gateway anymore.

- Make changes in the code to remove the payment gateway
- Add `test.skip` or whatever your tool specifies for skipping tests, to Point
  5 - Point 7 , and leave the rest as is.

I still have test cases in case we decide to add payment again and I didn't have
to test things in and out if I'd have done everything in one test case.

#### Cleanup/Resets

This is something even I forget doing when I write tests in a hurry and that's
why I don't personally like TDD , since you start hurrying since the feature is
a lot more important than the test. The client won't see the tests he's going to
see the feature and so I hurry down on writing the tests and forget to write the
cleanup cases or reset cases.

Most testing tools provide a way to to handle these.

1. beforeAll
2. beforeEach
3. afterAll
4. afterEach

these are hook functions that get triggered based on the name that you see. If I
wrote a single `checkout.test.js` for the above mentioned flow of checkout, then
I'd have a `beforeAll` hook that would clean the DB and then everything would
execute as mentioned.

If on the other hand, I have multiple checkout test cases to handle then I'd
have a specific `before` call on the Point 1 test case to clean up the db before
starting that and then the next set would do the same.

Another case is where you want to test every case with a fresh clean DB, in that
case you add a `beforeEach` hook, and that will execute before each test case is
executed thus, giving you a clean DB for each test case.

How these hooks are to be invoked are dependent on the framework you use and so
are to be read about from each's documentation.

That's about it for this post, hopefully that's helped someone.

Adios!
