---
layout: ../../layouts/Page.astro
title: Multithreading in Nim - Notes
date: 03/05/2022
published: true
---

Well, this topic has made a few people leave Nim and a few people just couldn't find
enough examples to help them with it so they gave up.

Either way, nim developers who stuck around have found out different ways to get it done
a few of them include changing the memory model of the compiler and if you wish to, you can
even change the garbage collector separately to make multithreading a little more easy.

Now, I'm not going deep into any of the topics since this is just a collection of
notes and snippets that I can refer back to instead of searching the documentation again
for something similar.

### High Level Threading

High level threading can be done by importing `threadpool` and then using `spawn` to
create threads and the running of these are handled by the threadpool

A simple example would look like this

```nim
import "std/threadpool"

proc worker(value: int): int =
    return value

let result:FlowVar[int] = spawn worker(1)
var fromFlow = ^result
echo fromFlow
```

To explain.

1. "std/threadpool" adds in macros and types required for handling `FlowVar` and `^` syntaxes.
2. the procedure worker is what's going to be run in a thread, for now we are just going to run 1 thread which will return the value passed to it, pretty useless but get's the point across.
3. result, as mentioned above gives us a `FlowVar` generic which has been casted to the type `int` since we are expecting a number from the thread.
4. `spawn` is used to create a thread and the worker runs with the passed value `1`
5. We wait for the thread to complete it's work by using `^` and this is a blocking operation so if you have a sequence of such `FlowVar`s you'll avoid blocking it till all
   workers are spawned and then block when you have all the FlowVars types returned from the spawned threads.

### Low Level threading

This is the approach I chose to go ahead with for [mudkip](https://github.com/barelyhuman/mudkip) , for those who don't know, mudkip is a simple doc generator I'm writing to keep consistency and speed for me when I'm writing documentation.

The approach is similar to the above one but we're going to dig deeper since instead of
the macros handling the pointer passing for us, we'll be doing it manually.

The below snippet is from mudkip at this point and might change in the future but for now
let's look at the code.

```nim
## Import the needed standard lib helpers
import "std/os"
import "std/locks"

## Define the base structure of what the file meta
## is going to contain
type FileMeta = object
  path: string
  lastModifiedTime: times.Time
  outputPath: string

## We then take in consideration of what the thread would contain.
## in this case we want the thread to have access to a
## shared state between threads, the point of the shared state is
## so that if a new file get's added and the chunks change, the threads
## process the new chunks accordingly
type ThreadState = object
  page: int
  statePtr: ptr seq[seq[FileMeta]]

var
  ## we now declare a channel variable, which will be needed to pass through a very
  ## simple string message around, you can solely depend on channels for passing
  ## data around in the threads but that can get complex to handle very quickly.
  chan: Channel[string]

  ## Next we are defining `threads` of the type `ThreadState`, this is necessary when
  ## working with low level procedure `createThread` since you need to cast the type
  ## of the parameters you send with it.
  threads: array[4, Thread[ThreadState]]

  ## Up next, we have the actual state and a pointer reference to it
  ## the pointer reference is what we'll be passing to the workers
  ## while the original is guarded with a lock so that when locked
  ## no other thread can modify it. Even though in our case the threads only
  ## read and never write to the state but if you do plan to write to the state
  ## then make sure you `acquire` and, `release` the lock when done with the mutation
  sharedFilesState {.guard: lock.}: seq[seq[FileMeta]]
  sharedFilesStatePtr = addr(sharedFilesState)

## Just taking the length which I use for creating chunks
## of the list of files I need to process
let maxThreads = len(threads)

## This is the worker function which takes in the `ThreadState`
## param that we defined before and it handles the base of the file
## watching logic.
## Each worker runs at an interval of 750ms to check if any file
## in the batch it's been given has changed.
## if it has changed then it'll send the main thread a request to
## update the state and also to reprocess the file.
## This is done with the channel, the channel sends the path to the file
## and since I'm not handling anything else in the thread, the main thread
## reprocessed the path that it gets and updates the state for me
proc watchBunch(tstate: ThreadState){.thread.} =
  while true:
    let data = tstate.statePtr[]
    let batchToProcess = data[tstate.page]

    for fileMeta in batchToProcess:
      let latestModTime = getLastModificationTime(fileMeta.path)
      if latestModTime != fileMeta.lastModifiedTime:
        chan.send(fileMeta.path)

    # force add a 750ms sleep to avoid forcing commands every millisecond
    sleep(750)

## This is not the entire implementation so you can read the whole thing on
## the repo.
## If the procedure gets a `poll` param with true, we open the channel to start
## listening for messages.
proc mudkip(poll:bool)=
    if poll:
    echo "Watching: ", input
    chan.open()

    ## Then we go through each index of threads and use `createThread` to cast to
    ## type `[ThreadState]` and pass it a new threadstate which tells the worker
    ## which index of the chunk does it have to work with. Which is passed with
    ## the `page` property in state and the whole set of chunks are passed as
    ## a reference pointer, `sharedFilesStatePtr` on the `statePtr` property.
    for i in 0..high(threads):
      createThread[ThreadState](threads[i], watchBunch, ThreadState(
        page: i,
        statePtr: sharedFilesStatePtr
      ))

    ## Then we on the main thread keep waiting for messages on the channel
    ## as soon as we receive one, we update the shared state in `updateFileMeta`
    ## and we process the file with `fileToHTML`
    ## this one is timed 500ms instead of 750ms to have a small rest period for
    ## the CPU, or we'll overload it with polling instructions.
    while true:
      # wait on the channel for updates
      let tried = chan.tryRecv()
      if tried.dataAvailable:
        updateFileMeta(input, output)
        echo getCurrentTimeStamp() & info("Recompiling: "), tried.msg
        fileToHTML(tried.msg, output)
      sleep(500)


proc ctrlCHandler()=
    ## Finally we close the channel, sync all the threads and deinit the lock as it
    ## won't be used anymore.
    chan.close()
    deinitLock(lock)
    quit()

## This just registers the above handler as the ctrlC action
setControlCHook(ctrlCHandler)
```

That's definitely a lot to read but that's still a simple implementation. I could've made it more functional will a threadpool but in my case the threadpool would still be blocking the main thread with `^` and I didn't want to do it with it. I wanted to have the main thread also listening for stuff since it's what actually handles processing the file,
the threads are just there to listen for changes and not to actually process the files since
that would need a lot more communication between the threads to work properly.

Also, since the main thread only processes one file per thread request, it's still fast enough to handle this on most systems.
