---

title: Status, Vercel and How I built it.
published: true
date: 03/07/2021
---

By **Status** i mean this website [barelyhuman/status](https://status.barelyhuman.dev)

The reason I built it was simple, I needed a simple setup to see if the web services were all up and running, the list is quite small because those are the currrent one's I would like to keep a track off.

Now this was built in a quick 60 min - 80 min time span and I'm going to explain the things I did and why I did them.

## Stack

- Go lang (templates and http server)
- Vercel

That's basically it. No seriously, that's about it.

## Mental Model

The idea was to have a simple go binary that would render a html page with each website that needs to be checked and its particular status.
This is basically why the website takes a bit longer to load after the browser cache has expired

The go binary is the microservice that vercel will use as an entry point, so on a very basic scale, since I won't be using code to show how this is being done, we'll go through the list of things that it does.

1. Get the list of sites to be queried
2. Ping each site to check if it's up, in certain cases ping the backend api of the web service to check if the api is up.
3. Check for the status to be 200, if not then the site/api is probably down
4. Render the html with the above data
5. Upload this as a microservice endpoint to Vercel

## Problems

1. Vercel doesn't allow a root endpoint without configuration so the endpoint for the micro service would be `/api/pinger` and the final url would be `https://status.barelyhuman.dev/api/pinger` , which while not a big deal, is a few more keystrokes than just `https://status.barelyhuman.dev` and thats one issue.

2. The html templates files are additional assets and those don't always work in the vercel api functions and that iffy deployment and checks would be a deal breaker for a service which is trying to show the current status of other services.

3. Vercel has a time limit on each request of 10 seconds , post the initial execution request, so about 12-13 seconds whole. If I ping a website on the Indian Server from a US server, the services that are hosted in EU / IN would add up about 2 seconds, thus making the website be shown as **Timed Out** if it accidentally crosses the 12 second mark.

4. Avoid showing people what the urls of each of these api's are, which while you can dig down a bit and find out, I'd prefer to have at least a layer of protection on top.

## Solutions and Hacks

1. The first one was simple, i do a browser rewrite for the `/` url to `/api/pinger` and done, checked if vercel supported that and boom , done.

```json
{
  "rewrites": [{ "source": "/", "destination": "/api/pinger" }]
}
```

2. The templates are just strings at the end of the day and go will build everything into a single binary so if I just write them as strings assigned to a variable, I can achieve the same result, so tried that and it worked as expected. I've explained about it in this [discussion thread](https://github.com/vercel/vercel/discussions/6316#discussioncomment-901041)

3. Pinging each site in a linear fashion would be a bad idea but that was the initial prototype. I wanted to test if everything was already working. Checked if it was and then I went ahead and deployed the prototype. Right after I realised, that these would fail if the request is coming from the US server to the Indian hosted backend, thus making it slower, and that basically actually happened. It pinged barelyhuman's blog properly but failed to get the status for the Taco backend and crashed, a reload showed both the results but I don't want it to crash for something so trivial.
   I then just setup a go routine to parallelize the fetching of each service's status and now the site handles 4 without any issue, not a big number but since it's parallel it theoretically should create any problems for more either.
   I can optimize this better by limiting the time of each response to be under 4 seconds but then a busy server might not respond at once so I'm rethinking if I should/shouldn't do it.

4. The html render and the website links are all fetched from the environment variables so that's a secret on the vercel portal for now so as long as no one hacks into vercel, I'm a little safe, obviously you can look through each app but those are proxies and rate-limited proxies (not boasting, there's ways around each) but for now that's a simple barrier to keep the urls safe.
