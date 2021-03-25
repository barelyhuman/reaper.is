---  
title:  Handling heavy memory tasks asynchronously  
published: true  
date: 2021-03-16  
---


This is going to be both a post to point you to a library I made and also point you to a solution for handling heavier tasks. 

**Disclaimer: This is one of many solutions that you can use, I'm just talking about this one since I end up using this a lot more than other solutions, I will mention other solutions though**

As programmers we are given problems that need to be solved or we discover a problem and then sit down to solve it. Once such problem has always been load management, we've got various tools that handle it for us at different levels. 

You've got load balancers for network requests, you've got the ability to scale vertically and horizontally in terms of parallel containers or k8 nodes but let's come to the small section of this, handling load in your actual code. 

I'm not sure if you've come across this but a lot of times you've got like 100s of functions that need to be run parallely or sequentially or even cases where the memory can't handle this run. 

### Context
A few days back I was working on a small dummy replication server on my Raspberry Pi which hardly had about 100-250mb ram left with all the other hosted services running on it. The replication server was to run my spotify , get all playlists, go through each playlist to get all the tracks and then match these on Apple Music and then sync them to my Apple Music. Why do this? I accidentally deleted my Apple Cloud library (My bluetooth keyboard malfunctioned and instead of deleting a single track, I deleted the entire library) and I need all the tracks back so I wasn't going to do it one by one and I could use SongShift but then it's slow and I'd have to setup multiple runners on it for each playlist and then run them manually so I figured I'd just write a small server for it.

### Problem 
- Limited amount of RAM: 100-250MB 
- Number of tracks to process: 2500
- Matching each track takes about : 1s
- total time to be 2500 seconds if done sequentially 
- memory usage per track search = 500kb , so about 125MB total to import all

The problem? I have close to no ram left on the rasp when this runs and using the other hosted services becomes hard cause they need to shift to swap and then it lags. 

### Solution? 

There's quite a few solutions here 
- Message Queues
- In Memory Batches
- DB Queues

#### Message queues 
Good solution but then I need to add RabbitMQ or redis + msg queue, setup a worker to listen to the queue and a server sending the instructions to the queue, limit the queue to not process more than 10-20 tracks at once. 

#### DB Queues 
Similar to the message queues but instead I add rows to a `queued` table of any existing database on the device and the worker keeps checking it after 10-20 mins to see if it has any new queued tasks and mark them complete when done with , this is simpler to implement and would be a viable solution if you need a  solution that's crash resistant. Message queues though might loose it's messages on crash in certain cases so this might be the most reliable solution to go with. 

#### In Memory Batches
Now, as the name says, its similar to the above two but we do it in-memory and yes, I'll loose all progress on a crash but this particular use case doesn't need to know if it's started again so we can go ahead with this and it's simpler if you are doing the same operation again and again.


### Implementation
You cut down the array of items into slices of certain amount, let's say I want to process only 20 tracks at once, then I run the async process and wait for the first 20 to complete. We then add the next 20 and process them and continue in the same manner but do it only in memory and this reduced the usage down to about 10mb of usage while this is running, leaving the remaining memory free to be used by other hosted apps.

For synchronous you could just slice the array and run a while loop waiting for one to complete before the other starts but incase of async this can be a little more code to write than normal so you might want to use a library. 

I would recommend using one of the following 
- [p-map](https://www.npmjs.com/package/p-map)
- [bluebird's promise.map](http://bluebirdjs.com/docs/api/promise.map.html)
- [conch](https://barelyhuman.github.io/conch/)

Though, **p-map** and **bluebird's promise.map** will allow you to maintain a queue that always have the mentioned number of promises waiting to be completed so it works like an in memory queue, on the other hand **conch** will maintain batches and will process it one batch after the other instead of a continous queue, both work well in the case , I just prefer the batching.

Another live example of this being used would be [music](https://music.reaper.im)'s import logic, which does something similar but to search youtube with the provided spotify link