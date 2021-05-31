---
title: Tests vs No Tests
published: true
date: 31/05/2021
---

Every developer has mixed feelings about writing tests, some think it's for the testers to do, some would like to avoid writing these at all costs and some would judge you if you didn't write any.

Then there's people like me who know that you cannot be on one point of the spectrum in this case, tests are important for every software but there's also a time, place and project where tests are to be written.

We are going to go through the **tools I use** for tests and **when do I take writing tests seriously**.

### Tools

Let's start with tools cause that's going to be a really small set compared to the mentality part.

Most test suites come with everything packed but then there's others where the **test runner** and the **assertion** is taken care of by 2 different packages. We've had [Jest](https://jestjs.io/) in the JS community for a while, which takes care of everything for you but I don't really go with the whole batteries included setup for anything other than survival gear.

So, I use a combination of [Mocha](https://mochajs.org/) and [Chai](https://www.chaijs.com/) for most of my testing, I have used [Ava](https://github.com/avajs/ava) for certain cases but it's mostly mocha and chai, older setups I had used [Karma](https://karma-runner.github.io/latest/index.html) but I've not worked with it in like the past few years.

#### Backend / API Testing

As mentioned, it's mostly Mocha and Chai and Chai comes with an added plugin of [chai-http](https://www.chaijs.com/plugins/chai-http/) which is what I use for testing the API's.

I'm not a TDD person, i write tests mostly after I'm done with the actual base API and not write the fail cases first and then write the feature next because most of my workflow depends on an incremental and iterative approach to the solution, so the TDD is more like torture in my case. Works well for people who do work on stricter paths, just not for me.

#### Frontend / Web Render Testing

This is a hard part, testing every click and action for a web app can be time taking and has sometimes taken longer than the acutal implementation and so I just setup the tests to check for renders instead of everything. The other stuff

- event handling
- state changes
  is tested manually and I write them down in the readme to make sure I test them accordingly.

So I use snapshots of the render, a concept I picked from [Sindre](https://github.com/sindresorhus) where you can render the component using `react-test-render` and then test if the needed props are making the needed change in behaviour. This can be hiding/showing based on a prop, rendering a certain prop in a certain element, changing a certain state or triggering a certain prop. 

Considering the atomic nature of how react components are written , this takes care of almost everything that could break. The only thing that remains is the business logic, which can be simple functions you export from helper packages and then test them as well. 

This blocks most cases of failures. 

You can obiously check event handlers as well but as I said, I prefer doing them manually.

This is for react, I've not tried testing setups for other UI libraries or frameworks but my approach would be similar if I did.

### When do you write tests?

There's quite a few people that consider that everything should have tests or that makes you a bad developer.

In that case, I am a bad developer.

But then , I'm not going away without an explanation(should already know that by now).

I say the decision of writing tests depends on a few factors

- Requirements
- Deadline
- Nature of the project

#### Requirements

If the requirements you are working with are variable in nature, i.e. if they are bound to change at variable points in the development cycle then writing tests is going to be a huge waste of time as the tests may or may not get invalidated as you go through. Still once you see a certain requirement is going to stay for longer, it's preferrable you write a test for it as the other changes you make over time shouldn't break that requirement.

On the other hand if you are clear in terms of what you are building and what the end product is going to prioritise, you are better off writing tests to maintain that stability and reduce the manual load of checking trivial stuff.

#### Deadline

This is pretty self explanatory, the lower the time you have, the less you need to focus on tests because if you don't have something to test in the first place, the test scripts make no sense.

#### Nature of the project

Is your project a simple single functionality tool? You don't need to write tests but that doesn't mean you don't have to, you can go ahead and write a test if it's a small thing and it builds up to a being a good habit later.

If your project is a prototype that you will throw in the trash right after testing the concept you had in mind, then the test is totally unnecessary though there's a **but** in this case. Like if you are going to keep building on that prototype to be the final case, write a test for it before you add in more features to it.

---

I don't mind tests as they reduce your load and that's good, since you don't have to keep confirming things that should be already working, and this saves you from the whole **Don't deploy on a Friday night** to a limit, cause the test coverage is going to fall short to a certain percentage every now and then but if you can avoid the majority of setbacks it still gives you a lot of peace of mind.

I can say that considering I've had TillWhen deployments fail and save me a few times.

That's all for now,

Adios
