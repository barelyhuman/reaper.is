## Now

This is more of a page to remind me what I'm supposed to be prioritizing right
now

- working on improving tillwhen's base functionalities instead of rewriting the
  entire UI , like I planned earlier
- done with the base API and Flags for
  [commitlog](https://github.com/barelyhuman/commitlog), now need to add a
  parser for a global and local config for it
- working on a more functional way to deal with react and hooks

> **NOTE**: (for future self) Do not! and I say DO FUCKING NOT do more than 3
> projects at a time, you just can't handle it.

> ^ Wasn't a challenge.

## Future

Things I wish to build, these are open ideas that you can build as well, the
only request I have is, do keep them **open source**.

### CLI tools

#### `codename`: stirup

A simple tool to run a script on a dedicated ssh server ( not ansible, something
a lot more concise. BASH can already do this but requires a lot of boilerplate
code)

The script can proxy rsync internally to also provide things like copying files
up and archiving them if needed.

#### `codename`: dynmnt

A simple wrapper on top of linux interface events to manage mounted devices and
be able to run task based on mount or unmount.

The tasks don't have to be bash scripts but any command that the user wishes to
add.

The use case for this was to allow raspberry pi to restart my docker compose
setups when an external drive is connected so it can read and write to it but
might scale to other use cases.

It's going to be easier to write this in C, Go, due to existing interfaces

### Libraries

#### `codename`: typeless-gql

This is still a concept and the chances of this being achievable might be
limited by present tech but we want a simple solution

An attempt to avoid having to run the `codegen` manually for graphql and allow
type completion by just being able to inject the graphql document into our
abstraction.

example API

```js
import { createSchemaGQL } from "typeless-gql";

const gql = createSchemaGQL("/path/to/schema.gql");

const TypedOperationNode = gql`
  query ping {
    pong
  }
`;

const response = someExecutionLibrary(TypedOperationNode);
response.data.pong;
// should autocomplete at `data` and `pong`
```

### Docker Images

#### `codename`: postgres-git-backup

A simple docker image that takes in postgres configuration and schedule a backup
task for the provided configuration but instead of saving to s3 / local, have
the ability to push to a git repo or a git lfs based repo (both should be
supported)
