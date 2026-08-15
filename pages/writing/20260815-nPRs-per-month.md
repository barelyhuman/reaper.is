---
title: How we afford to merge N PRs per month
published: true
date: 15/08/2026
---

There was a post by the founder of Bruno about our OSS stats in the past year. They are impressive but also not super high since I've seen smaller teams like Nuxt churn out more than this.

https://www.linkedin.com/posts/anoop-m-d-868099100_a-few-fun-stats-from-the-last-12-months-of-activity-7489061044347146240-ea21?utm_source=share&utm_medium=member_desktop&rcm=ACoAACNo8M0B62Dx2Zo9oSppW5w5jHo9Na8Ugw0


There's 1 small reason for this: the test suite. Bruno as a project has a few parallel suites when it comes to test automation

- CLI
- Unit
- App (e2e)
- App (unit)
- OAuth 1
- OAuth 2
- SSL (e2e)

Now for someone from the outside that's just 7 checks/workflows that run on each PR, which is normal right?

Next up is the time that each one of these takes. The App e2e being the slowest of the bunch, taking about 1-2 hours based on which OS we're running on with GitHub.

Then we hired a bunch of people and the influx of internal PRs increased to roughly ~10 PRs a day, 4-5 days a week, and each PR taking 1-2 hours and having the dev / reviewer wait for an hour or two to see if things have gone through, was painful. Let's make it worse: we are on the free tier for GitHub on the usebruno org so we were limited to 20 concurrent Linux machines, so at any given time if a few PRs were actively running, the pool would fill up really quickly.

I've not even gotten to the whole cross-OS testing state because we no longer do it per PR, but that was another thing that slowed down merging PRs in. I'm sure the 125 PR stat you see from the post is heavily nerfed since we didn't sit down to solve this for over a month.

### Infra

For those unaware, I work as a staff engineer at [Bruno](https://usebruno.com) and since the team is small I also manage DevOps. Let's list the problems down.

1. Time it takes to run the E2E suite per PR.
2. Time it takes each PR raised in parallel to wait for runners.

Both easy problems to solve. The 2nd one could be solved by throwing money at the problem (at least for now), so we started with that, raised up a few self-hosted machines on AWS, tied it to the repo and monitored it for a few days. It went up to 6 additional machines that were being used as fallback when GitHub's shared pool would get all used up.

Then the next week or so after observing the usage and how active these machines had to be, I switched to an ASG that was manually managed by me (I was increasing the max and desired based on how many items I'd see queued up). I wrote a tiny `gh` CLI script to monitor the queued Linux tests and then it would notify me using a tiny `osascript` script.

This worked well to figure out what was the highest we'd need on a peak work/release day. The nice part about the manual handling was that I wouldn't have to deal with scale-in and scale-out properties since each runner was just an instance running forever and taking jobs continuously.

Now, those who are aware of pricing, imagine a t3.2xl machine just running all day and night even when no PRs are being created. At night I'd reduce these down to 2 when I left home but still. Pricey pricey.

Come end of June, 2026. I had spent enough time working the quirks of ASGs that I was able to move the `gh` and `osascript` to a lambda function that handles scaling up and down as needed. Each instance was now ephemeral, so they had to manage their own scale-in protection to avoid getting killed by the ASG while they are handling jobs. There's more to it but I'm going to leave it at this since that's all you need to know about how the resource crunch was solved.

### Make the problem tinier

Since resources were no longer an issue, we had another problem: the e2e still takes up 1-2 hours to run and that's not fun to wait for when there's a flaky test and you have to run the whole thing again....

While I was thinking of ways to split the tests into their own modules, I realised that we'd already split them based on areas that need to be checked, so we have SSL, OAuth and other splits already being done. Would it make sense to split even more, and how many times would we want to go modify the CI setup for the E2E setup?

A colleague was working on a PR and was equally irritated by the time it took so he was browsing the Playwright documentation and found out about test sharding. Our only problem now was that not all our tests could run in parallel so the shards wouldn't be symmetric and would make it hard to make this reproducible if there were flaky tests in a particular shard.

So we spent a little time off-work to get the tests that would cause issues to be parallel and be able to run with 2-3 workers. This brought each shard down to roughly 25 mins and that was bearable. For reference, there's ~1000 tests and 4 shards.

### Now the money

All of this worked great for the OSS work but the distribution repo is under the paid GitHub plan and there you are charged for the action minutes, where our Actions minutes were super high and so was the bill. Can't reveal the bill amount for various reasons but there was a ~30% decrease between the May and June bill because now we'd have 25 or more runners running during peak hours, still wouldn't get charged for the full 25 but was still pricey.

Next up, modifying the lambda to figure out the required repo and only register the new self-hosted runner there. This was easy to get done by setting tags on the newly spawned machine and letting the machine read its own meta to decide where to register the runner.

This cut the usage on the paid GitHub account for the runners by 60% since we still used the GitHub runner pool for things like builds and critical runners where the infra failing when there's no one looking at it would cause issues.

### Finally

We're at a state where a high influx of community PRs doesn't bother us since the self-hosted ones take care of it for us. The self-hosted runners are more necessary since it's now 10 jobs per PR which means that 2 PRs would take up the whole github hosted runner queue; while the self-hosted ones are allowed to go up to 35, which only happens at peak times. In normal cases it's around the 16-20 mark since the smaller tests run for roughly 8-10 minutes. Cleanup and re-spawn is pretty quick for us to not worry about it. Also the machines are larger that what github provides so certain tests now finish faster.

This setup wouldn't make sense for your project if you just have the free account and don't worry about paying a per-minute charge to GitHub on the Org plans. It's a lot less effort to manage this with the large runners provided by GitHub in the team plan but considering we were paying a lot in Actions minutes even for the default runners, a month of additional expenditure helped us normalise our pricing across both our free and paid orgs and the pricing is now centralised to AWS for the most part so we only pay for the seats on Github and the basic set of action minutes we want to keep for the critical workflows. 

That's all for now, adios.
