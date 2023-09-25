---
title: Working with Twilio Coversations
published: true
date: 23/12/2021
image_url: https://og.barelyhuman.xyz/generate?fontSize=13&title=Working+with+Twilio+Coversations&fontSizeTwo=8&color=%23000&backgroundImageURL=https%3A%2F%2Freaper.im%2Fassets%2Fog-post-background.png
---

Complaining about docs has been a global rant for now but then not everyone has
the time and man power to write documentation, I don't know why Twilio skipped
on this but the only way to figure out working with Conversations is the
incomplete documentation about the basic flow of the events from their
documentation and the somewhat documented types on their typescript generated
typedoc reference.

Now, I actually got done with the usecase pretty well since I've worked with it
before and knew the mistakes I made before so it was easy this time and hardly
took a day or so to get the additional features with integrations to be done,
but I got feedback on a discord channel regarding a helper library I built for
twilio conversations and the feedback was

> While I understand what your library is trying to do, I don't think it's easy
> to look for documentation on the original twilio reference since most of the
> time you don't really know what is to be used for what.

There's more to the feedback but this made sense, since the first time I worked
with programmable chat and conversations, I had to take reference from the then
available example repositories using these services. Which is generally a
secondary approach to learning something. The primary approach for most people
is referencing the documentation or stack overflow.

Anyway, since this comment then got a few more supporting comments regarding
similar issues, we are going to try to have a base flow of what to look for when
working with a simple chat app and then a few additions in case you work with a
more complex one.

**Note**: There's actual code sample after the theory is done for reference, if
just reading doesn't help you

## Nomenclature

clearing this will help us with the remaining of the explanation

- Conversations - to simplify, these are your chat rooms, people join and leave
  conversations and that's how you control who is talking to whom, there's a lot
  more you can do here but keeping it simple for now.
- Participants - every identity/person that joins is a participant. the messages
  are assigned to these participants using something called as an identity and
  you can look up participants by id to perform further actions
- Messages - Self explanatory, but these are always inside a conversation, and
  hence you can get back the conversation from a message if you do want to
  update something in the conversation, for example, update the last read
  message time or to simplify (unread message counter feature)

These are the 3 basic resources you need to work with for a very simple chat
app, and each of these can be manipulated more to create something more complex
once you understand the limitation of each.

## Twilio Client and Initialization

The basic functionality will require you to get a twilio client library and then
listening to various events on that client. There's a good amount of debate on
when you should be initializing the client, we'll get to the simplest options in
a bit but let's get to the flow of working with the client.

1. You request a server for the auth token with the needed twilio grants
2. You use this token to initialize the client
3. You add listeners to handle the conversation events.

That's the flow for init of `client`, you will generally initialize the client
at the soonest possible time in your app based on a few variables involved.

- You do the initialization post the authentication step, generally on the page
  that handles your redirection, so let's say you enter the creds and execute a
  `login` , you take the person on a loading page first and then the actual chat
  room, so your client is created on the loading page, just created, and you
  also add a failsafe for when people share the chatroom link to use this
  loading page before the people see the actual chat room or you can add it to
  the chat room page itself and add a loading on the chat screen, your call
  here.
- Let's say you are working with a more complex app, something that has more
  features than just a login page and a chat page, in this case, the earliest is
  going to be the dashboard page or the overview page that comes up after you
  are done with the signup / process flow etc etc, and this is the page that
  loads everytime the app loads so it makes sense to have it here, again, just
  create the client here, you don't necessarily have to wait for it's
  initialization / connection to complete here

## Conversations and Listing them

While, a lot of backend developers would just create the token and hand it over
to you for you to add listeners for everything that twilio provides, it's
generally easier for the backend to do the conversation listing for the app
initialization stage.

This helps with a few things, in most cases the conversations are going to be 1
on 1 and you'd need more than just the conversation name, your app might need
the user's full details, the profile pics, etc etc , which "surprisingly" the
backend has faster access too. So here's the things I'd recommend that you get
from the backend for the initial chat list.

- List of conversations (obviously)
- User details for each conversation (both Participants, will include details
  like, name, avatar, last message etc)
- And make sure this is on the offset 0, so basically the last 10 conversations
  , sorted by last message in desc

This helps the client/frontend to make one initial call to get the list of
conversations to show and it's faster to render than doing something like

1. Wait for twilio client to connect
2. get conversation list
3. check the identity for _each_ conversation.
4. retrieve user details from the identity of _each_ conversation.
5. fetch avatar url using the user details

This doesn't mean the frontend won't add listeners. Once you are connected to
the client, you are better off handling the events listed below on the frontend.

- `messageAdded` - you add a listener for this and update the conversation's
  last message and unread count based on this event
- `conversationUpdated` - this event can help you with updates on the
  conversation, like removing a participant from the group chat and you wish to
  show that on the list , also if it's a named group chat, the same event can
  help. you take the updated data and only update the state of one single chat
  instead of fetching the entire list from the API, so both are to work in
  conjunction.
- `conversationAdded` - this event fires when you are added to a new
  conversation, so you might want to update the list and bring this to the top,
  and I realise you might have to fetch other details for this, which is fine,
  you fetch for one conversation now instead of the entire list, which is okay,
  still keep the state update non-blocking to make sure the user doesn't suffer
  from a loader when it's not needed.

And there's a ton more of these events for message and conversation, there's
also typing events if you wish to add that to the conversation list as well,
you'll have to modify how your chat works for this which is next.

## Conversations and sending messages

This is also something that would initially load data from the backend while the
listeners get added. The initial data would involve you sending the backend your
participant id and getting the last 4-5 messages and listing them, unless you
plan to something like slack and keep the past `N` messages of each channel in a
cache in the indexedDB (for web) or some `sqlite` in the mobile apps, which is
also fine if you ask me , though let's say we don't want to do that for now, we
can have the backend send through the last few messages, avatar data (if you
aren't caching that), etc.

and then we have the listeners that we would like to listen to.

- `messageAdded` - this is not on the client, but on the conversation instance,
  so you'll only be notified for messages added to this very conversation.
- `messageUpdated` - if you have added a edit message functionality, this is the
  event you monitor
- `messageDeleted` - same as above but for delete events, self explanatory

Done with the boring parts, based on the above you update your state with the
needed data to show the message. As for handling typing and read, unread message
You have to update the last read message time in the conversation which is on
the `conversation` object with the method `setAllMessagesRead` or
`updateLastReadMessageIndex` , unless you trigger one of these messages the
`getUnreadMessagesCount` method on the conversation will always return null.

Now for handling typing indicators, that's very simple and actually documented
so I could redirect, but since I've already written so much. You use the method
`typing` on the conversation instance, which will trigger an event lasting a
duration of 3-4 seconds , unless another typing event is triggered, so you can
add this to your input's `keypress` event and as long the person is actually
typing, this event keeps firing thus letting you to show that the person is
actually typing.

Finally sending the message is as simple as calling the `sendMessage` method on
the conversation instance with the text message or a media message. Do use the
`attributes` optional parameter for the `sendMessage` function to add unqiue
trackable values if needed.

all the reading aside, let's see it in example. I'll be using my helper library
to reduce my work here

```js
// app-init.js

import {
  createClient,
  onInit,
  onTokenAboutToExpire,
} from '@barelyhuman/twilio-conversations'

let client

export async function initializeTwilio() {
  if (client) return client

  const token = await fetchTwilioToken()
  client = createClient(token)

  onInit(() => {
    console.log('Twilio client , connected')
  })

  onTokenAboutToExpire(ttl => {
    // not using the ttl, but it's there if you need it
    fetchTwilioToken().then(token => client.updateToken(_nextToken))
  })
}
```

```js
// chat-list.js
import { onInit, onMessageAdded } from '@barelyhuman/twilio-conversations'
import { initializeTwilio } from '../app-init.js'

async function ChatList() {
  const conversationList = fetchConversations()

  // render the list on screen
  render(conversationList, {
    onClick: conversation =>
      navigateTo('Chat', { conversation: conversation.sid }),
  })

  const client = await initializeTwilio()
  // if the client isn't connected wait for it to happen
  if (client.connectionState !== 'connected') {
    onInit(() => {
      rerenderChatList()
    })
  }

  // add the needed listeners
  onMessageAdded(message => {
    const conversationSId = message.conversation.sid
    const _convToUpdate = conversationList.find(x => x.sid === conversationSId)
    _convToUpdate.lastMessage = message

    // update state with the new element for the specific item in the list
    updateRenderForKey(_convToUpdate.sid, _convToUpdate)
  })
}
```

```js
// Chat.js

import { findConversations } from '@barelyhuman/twilio-conversations'
import { initializeTwilio } from '../app-init.js'

async function Chat(conversation) {
  const existingChatMessages = fetchMessages(conversation)

  render(existingChatMessages, {
    onSend: text => {},
  })

  const client = await initializeTwilio()
  // if the client isn't connected wait for it to happen
  if (client.connectionState !== 'connected') {
    onInit(() => {
      rerenderChatList()
    })
  }

  const conversationResource = findConversations(conversation)

  // this is different based as it's from the helper library
  const {
    conversation,
    onMessageAdded: onMessageAddedToConv,
    onTypingStarted: onTypingStartedInConv,
    onTypingEnded: onTypingEndedInConv,
  } = conversationResource

  // update render since we have the resource now
  render(existingChatMessages, {
    onTextChange: text => {
      conversation.typing()
    },
    onSend: text => {
      const _formattedMessage = {
        id: message.sid,
        text: message.body,
        status: 'pending',
        user: {
          id: myUserId,
        },
      }
      conversation.sendMessage(text)
    },
  })

  // add the needed listeners
  const { unsubscribe: unsubMessageAdd } = onMessageAddedToConv(message => {
    const _formattedMessage = {
      id: message.sid,
      text: message.body,
      status: 'sent',
      user: {
        id: message.author,
      },
    }

    // update state with the new element for the specific item in the list , as it's status is now changed
    updateRenderForKey(message.id, _formattedMessage)
  })

  const { unsubscribe: unsubTypingStart } = onTypingStartedInConv(
    participant => {
      isTyping = true
    }
  )

  const { unsubscribe: unsubTypingEnd } = onTypingEndedInConv(participant => {
    isTyping = false
  })

  // clear the listeners before your componenet unmounts to avoid overloading the event listeners
  onComponentDestroy(() => {
    unsubMessageAdd()
    unsubTypingStart()
    unsubTypingEnd()
  })
}
```

Everything you see here is doable with the most frameworks and the actual twilio
library, the helper only created a global context to be able to use it the
client even when it's not importable and to be able to chain the client
functions as needed. I repeat **you can do everything I've done above with the
twilio library**. No, the above code won't work anywhere since it's pseudocode
and there's doesn't exist a framework that has the above mentioned render
functions the way I used them, these are just examples to be read as examples.
