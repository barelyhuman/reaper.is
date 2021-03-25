---
title: Crypto Nonce and Association Flow - Integrating Slack Bot with Internal Services
published: true 
date: 15/11/2020
---

This is base note for the slack bot integration that TillWhen is being built on for reference in future (in case I forget, how I did it)

This is just for the internal testing of the app in my workspace, the official published slack bot will have the oauth flow.

**The Base Flow** 

1. Slash command send a request with the user_id in the post body that is used to generate a login url with a cypto nonce involved.
2. The login url redirects to the existing app which sends an app login request if the session doesn't already exist and also takes care of pairing the slack user id with the app's user id. If already paired then look at Step 4.
3. If the user is paired for the first time with the service, a DM is sent to the user confirming the association and also the nonce based login page will show a pairing successful message.
4. Generate an API Access token for the associated user to be used with the slack bot's slash commands and use that to identify the session and even block the session if needed.

**The Changes needed in App**

1. Add an `integrations` table (database) and tab(TillWhen Dashboard)
2. Add an Integrations Login page to the flow (TillWhen App)
3. Create API's for generating integration login , and api access tokens for access handling.
4. Write an auth check middleware for integrations and assign it to each slash command
5. Make sure to prioritize expiry token on both API tokens and integration's crypto nonces.
