---
title: Should you use Hasura?
published: true
date: 20/08/2021
---

For those who don't know, I work with [Fountane](https://fountane.com/) and we are a creative studio that helps business gain digital presence or even
technical presence.

This normally involves either auditing their existing websites for better seo and user experience, or even building web/mobile apps for them from the
ground up.

This obviously requires a bit of work but a lot of clients are in the hurry to get into the market for various reasons that we might not be able to
understand but a lot of projects that come to us have a really tight deadline and this is where **Hasura** came into the picture.

## From Scratch REST APIs

We used to build APIs like any other firm, build optimized REST standard APIs and while this worked it was slow since a lot of the code couldn't be
reused (other than maybe the auth part) and writing CRUD for every model again and again was a slow process and often pushed the deadline a bit which
was sub-optimal for a studio that was fast growing.

## Loopback

For developers who have had similar problems , a lot of them moved to Nest, Loopback , other frameworks that try to replicate the Angular Arch where
everything is pluggable to the original base and not very hard to do.

I used and liked loopback 3 for a project and it worked great. The generation of CRUD was no longer needed and I could use the Angular generated
services from loopback to automate the SDK creation for API calling and everything but this went south when Loopback 3 announced EOL and Loopback 4
was a drastic change and little more learning curve than I'd like the team to go through.

I could've just forked loopback and maintain a personal copy for this but then loopback is not just the core repo, its the connectors, the additional
pluggable modules , everything, that would be a project in itself.

## The requirements and Hasura

Well, my buddy [Gautam aka https://backend.engineer](https://backend.engineer) like the loopback arch and wanted graphql for the newer apps and we
ended up deciding on hasura and trying it out for a project or two to see the mileage of the framework and
[Pandey](https://twitter.com/ashishpandeyone) was given the work to architect a monolith (webhook server and hasura, no web app here) for this.

A week or so later, this was done and ready to be transferred to projects that were still in the arch phase

At this point, we have 4 projects that use hasura and what you are going to read next is my review of whether you should **use hasura or not** and
obviously the occasional knowledge transfer as to where it makes sense and where it doesn't.

## The good parts

These are simple and pretty much why people pick it up.

1. Easy CRUD for all generated models
2. A Web UI to handle most of the work
3. Handles permissions, roles, and migrations for you
4. Comes with the ability to construct actions / queries/ mutations for you

You can literally read about it from their website since that's what they market and also the reason why we picked it up in the first place.

## The pain points, or things I didn't like

The list is purely based on my experience and things I wish could be improved and obviously I have better alternatives instead of this.

#### 1. The Migration and Metadata System

While most of it is automated and it looks graceful and is atomic if done well, it's not very intuitive and goes against the norms of migrations if
you were doing it with something like knex but then that's with every framework, like Loopback had it's own way to handle table updates and migrations
so I can be a little lighter on this.

The actual **pain point** though is that the migrations get overwritten very easily when 2 or more people are working on their local systems and this
creates an issue since they can be timed to be the same they can conflict and there's no way to find out what went wrong, this in turn breaks the
**metadata** of the entire console and now you have missing permissions and actions. Post this, you will have to go through your git history to read
through the metadata to find out what went wrong and also through migrations and manually merge this.

If the developer is good with SQL then modifying and merging these `.sql` migration files shouldn't be an issue but then I don't see why I need a
framework cause it does end up adding to the total work time and sometimes can take a lot longer than expected.

The other part is the structure of the metadata, while it's a simple JSON that you can browse through, this can get super messy when the application
get's a bit bigger and it's the worst when you accidentally mess up the permissions in the meta data.

#### 2. No Dynamic value comparison in Permissions

Yeah yeah, I can send new headers with `X-hasura-<variable-name>` and then use that for the dynamic comparison but that's a super hacky way to get it
done.

Beats the point of already sending all the needed data in the Payload and then sending it again in the header because the framework decided that it
can't add a `$payload.id` in the permissions meta and and and, You can't do the above without modfying your auth handlers to handle the additional
dynamic variables.

This not only changes how people handle permissions but is also very limiting for a full fledged industrial application and if you have a super
complex permission check, it's easier to write a custom action instead of asking hasura to handle it cause it will require a dynamic comparision based
on dependent outputs of other tables and that very hard to maintain, it's unreadable , and you are better off just writing it as a custom action.

#### 3. Closed Box model

You can say that , this is because I liked loopback a bit more so I expect hasura to be the same but I understand each framework has it's own set of
opinions and depends on the creator's thoughts of how they want to build something and while I see why they did that, considering most of it is in
Haskell and extending it would need knowledge of Haskell.

Though, being able to extend the model's methods would actually align perfectly with how graphql works when you build one from scratch and also
reduces the amount of permission handling that they have on the Web UI and instead be simple middleware functions that you can write based on the
context of the query.

That would help maintain a smaller and more maintainable architecture compared to what it is now. The hasura arch was with the thought of having
microservices in place and gateways that handle these microservices but when most of the app you are building requires a lot of logic and permissions
then this closed box becomes counterproductive and you end up spending more time trying to figure out what goes where instead of actually getting done
with the application.

## Solution

I don't have a **concrete solution** to match with this right now but if the CRUD and models is all that I wanted to solve, It would be better to
setup Prima and Express Graphql (if you still use express) or use AdonisJS with apollo server or basically anything with apollo server or your
language specific scratch graphql implementation.

This could be a combination of Python + Flask/Rapid API/DJango + GraphQL + ORM + CRUD Generator plugin (which you can find for most Setups at this
point and it's not hard to write re-usable CRUD handlers that replicate the actions for the ORM that you are using).

This gives you the ability to scale on the small arch and manage things while keeping control on what this can do. I can't do that to hasura without
picking up a new language, forking it and then changing all these.

Your opinion on the usage of Hasura might totally differ but to conclude

## Should you use Hasura?

It's not a bad framework at all, it just doesn't suffice the requirements of our use case and the overhead of hacking into the problems that come
aren't worth spending time on when you are on tighter deadlines.

On the other hand if you are in for a quick way to the market with simple and trivial implementations it perfectly fits the usecase as you can reuse
most of the work you did before into it very easily and most of it can be setup using interconnected docker setup's so it's pretty easy to replicate
the environment no matter where you deploy it.

Though the same can be done if you create your own setup and that's a lot more easy to maintain than a framework that you need to hack into to make
things work (I made grator because the migrations would fail when moving into new systems and I wouldn't want to keep making such tools just because
the framework wasn't handling it)
