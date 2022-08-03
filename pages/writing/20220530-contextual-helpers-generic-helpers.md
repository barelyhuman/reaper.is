---

title: Contextual Helpers are easier to write but ...
date: 30/05/2022
published: true
---

Clickbait title for the win.

Anyway, what's this about?

I've only been a programmer for about 4.5 years (as of writing this post) and no doubt there that we all grow after making enough
mistakes that we reflect upon and correct.

True for everything in life but I'm going to keep it limited to programming

## Contextual Helpers

Or, helpers that are limited to a context or more specifically business logic. These are small functions that are very dependent on
the data structure that's specific to the application you are building. To simplify, let's say I have a job listing app and I'm working on the page where these are to be visualized.

```ts
interface JobListing {
  role: string
  joiningDate: Date
  name: string
  // ... remaining fields
}
```

Assuming , we have the above structure / type for whatever I receive from the backend, I might have a formatter for the response to model it for consistency across the app or I might just use these fields as is. Though, often I'll need to write helpers that are very specific to this data.

_For example_, let's say I need to show all the `Software Developer` roles with the hex `#18181b` then what?

```jsx
import { Text } from '@components'
import { standardDate } from '@utils/date'

const getPositionStyledText = (role) => {
  let color = '#000'
  switch (role.toLowerCase()) {
    case 'software developer': {
      color = '#18181b'
      break
    }
  }

  return {
    style: { color },
  }
}

const JobRoleText = ({ role }) => {
  const textStyle = getPositionStyledText(role)
  return <Text style={textStyle.style}>{role}</Text>
}

const JobListingCard = ({job})=>{
    return <>
        <p>{job.name}</p>
        <p>{standardDate(job.joiningDate)}</p>
        <JobRoleText role={job.role}>
    </>
}
```

Now we have 2 things that are very specific to this project, the component and the helper for the component, you can move the function inside but then that function would get redefined every time and will need to be inside a `useCallback` to avoid that so it's easier to just have it outside.

Back to the point,
This is a bloc helper, or a business logic helper and these are often just limited to the app you write them for, moving them to other apps might need a lot of modification and so these are left alone and people generally start from scratch

## Generic Helpers

As the name suggests, these are more geared towards being reused and don't really have business logic tied to them. Thing is, these are a little harder to write compared to the contextual one's because here you have to decide and design the API of the helper in a way to make it generic enough to be reused.

I'm going to give a small example and reuse the above styling helper again but this time written with a more generic API.

```tsx
import { Text } from '@components'

type ColorMap = Record<string, string>

function createColorMap(definitions: ColorMap, defaultColor: string): string {
  return (toMatch) => {
    if (!colorMap[toMatch])
      return defaultColor

    return colorMap[toMatch]
  }
}

// and the usage would look like so
const roleColor = {
  'software developer': '#18181b',
}

const roleColorMatcher = createColorMap(roleColor, '#000')

const JobRoleText = ({ role }: { role: string }) => {
  const textColor = roleColorMatcher(role.toLowerCase())
  return <Text color={textColor}>{role}</Text>
}
```

before we go to the explanation

1. The above is not the best API to write a colorMap, it can be improved a ton more
2. This is an example, take it like one!

To the mounta.. explanation.

We asked 3 things, which will help you create most of the helpers you write.

1. What is base operation of helper?
2. How do I get the data?
3. Can it even be made generic?

Let's start with the 3rd question first, because that's important to understand.

### Can it be generic?

Not all helpers can be made generic, and even if they can be, the API of the helper might not be as simple as the one with the context.
What do I mean by that?

Back to examples, let's say I have a few cases where the `provider` can be an organization or a middleman or a startup
each having the `type` = 1 | 2

```js
function getJobNameWithProvider(job) {
  if (job.type === 1) {
    if (job.org.type === 'startup')
      return `${job.org.name} | ${job.name} (Startup)`
    return `${job.org.name} | ${job.name}`
  }

  if (job.type === 2)
    return `${job.poster.name} | ${job.name}`
}
```

I could also use a `switch` statement to add all this to a single string but for now, this is complicated enough to explain what I'm trying to.

Here if I do make a generic helper, I'll be picking random fields based on conditions and if I do make a generic helper it would look pretty much like the `createColorMap` function but it's the API that's troublesome.

```js
function createConditionalPicker(pickerMap) {
  return (passerObj, condition) => {
    if (pickerMap[condition])
      return pickerMap[condition](passerObj)
    return null
  }
}

// and usage would look like so
const jobNamePicker = createConditionalPicker({
  1: job =>
    job.org.type === 'startup'
      ? `${job.org.name} | ${job.name} (Startup)`
      : `${job.org.name} | ${job.name}`,
  2: job => `${job.poster.name} | ${job.name}`,
})

const job = {
  type: 1,
  org: {
    name: 'BarelyHuman',
    type: 'startup',
  },
}

const jobName = jobNamePicker(job, job.type)
// BarelyHuman | undefined (Startup), since I haven't handled null cases above
```

You can technically use the `createConditionalPicker` to even create the color mapper above, but that's not the point.

So, here we have 2 things,

1. You are still writing your own business logic
2. The API needs to be explained well to a new developer joining the project.

Looks like I almost wrote a monad though...

back to the concept, in cases like these it's easier to read and modify the original contextual helper than trying to make it generic. This will come with practice so you'll be making un-needed generic helpers quite often.

### How do I get the data?

The 2nd question dictates how you design the API.

The above 2 helpers were curried functions since the setup data would be same and it'd make no sense to resend the entire object again
and again when it's reference could be used and thus the returned function takes in the parameters that would actually access the reference point

If you are going to be working with different data every time, then you are better off with simpler functions.

If you are working with modifications on data, then we would need helpers that allow pipes, for example the above
name picker could be written with something like `@useless/asyncPipe`

```js
import asyncPipe from '@barelyhuman/useless/asyncPipe'

const jobDetails = await asyncPipe(
  async () => await getJobDetails(jobId),
  async (job) => {
    if (job.type === 1) {
      if (job.org.type === 'startup')
        job.jobNameWithProvider = `${job.org.name} | ${job.name} (Startup)`
      else job.jobNameWithProvider = `${job.org.name} | ${job.name}`
    }
    if (job.type === 2)
      job.jobNameWithProvider = `${job.poster.name} | ${job.name}`

    return job
  }
)
```

here the `asyncPipe` is the generic helper and we aren't really creating a generic helper for the job name, instead we make the
modifications on the source data, which is how I would be doing the jobName field anyway but had to think of something simple to
explain the 3rd question.

Now, people would ask, why would you write these functions inside a pipe?
Good question.

The point of using a pipe to make sure the structure is modifiable, because the pipe assume a set of data to be passed down at
all times. This isn't close to the original functional programming pipe but more to how coffeescript implements pipes.

The above in production code looks like this.

```js
async function addProviderNameToJob(job) {
  if (job.type === 1) {
    if (job.org.type === 'startup')
      job.jobNameWithProvider = `${job.org.name} | ${job.name} (Startup)`
    else job.jobNameWithProvider = `${job.org.name} | ${job.name}`
  }
  if (job.type === 2)
    job.jobNameWithProvider = `${job.poster.name} | ${job.name}`

  return job
}

const jobDetails = await asyncPipe(
  async () => await getJobDetails(jobId),
  addProviderNameToJob
)
```

At this point, the `addProviderNameToJob` is optional, I can remove it and add it anywhere in the pipe and still expect the same result
because you'd conceptually pass the same job down the pipe. The `asyncPipe` from `@useless` isn't tightly tied to a source for other reasons but based on functional concepts. You'd have one source and multiple sinks for that source.

The sinks are what consume the source, make modifications to it and return it. I can add another modification in the middle if it does the same thing, **consumes the source, modifies it and returns it**

```js
async function addProviderNameToJob(job) {
  if (job.type === 1) {
    if (job.org.type === 'startup')
      job.jobNameWithProvider = `${job.org.name} | ${job.name} (Startup)`
    else job.jobNameWithProvider = `${job.org.name} | ${job.name}`
  }
  if (job.type === 2)
    job.jobNameWithProvider = `${job.poster.name} | ${job.name}`

  return job
}

async function addBarelyHumanToJob(job) {
  job.isFromBarelyHuman = true
  return job
}

const jobDetails = await asyncPipe(
  async () => await getJobDetails(jobId),
  addBarelyHumanToJob,
  addProviderNameToJob
)
```

Pretty stupid for an example, but I hope you get the point, my business logic can be separated in chunks and still be added or removed at will.

Don't be fooled, you can do all that without even using `asyncPipe` but it's a little more structured for my mental model.

### What is base operation of helper?

Last question, what is the base operation.
The base operation for the color mapper was to compare a string to another string (switch cases or if case) which can be moved into
comparing a value in map.

You basically move out the base operation and write that into a generic function and then move the data dependent decisions out to the
developer using the API.

Combine this with the answers to the other 2 questions and you'll have an helper design in your head or on the paper.
Then run a few tests and voila, generic helpers!!

## Conclusion

It's always going to be easier to write business logic specific helpers but if something can be split into a generic helper which you
see happening in most projects that you write, spend a little more time and make a generic helper out of it.

Do keep in mind that not everything needs to be generic, some things are easier to read and modify when left with their context.
