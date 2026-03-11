# Letter-Constrained Chat Filtering System

> A chat system driven by a consumable letter pool.

---

## Features
**Chat System**
- Filters each message based on the amount of letters available.
- Server-side validation
- Data saving

**Rolling**
- Weighted random letter selection
- Individually boostable letters (giving it a higher change to roll)

---

## Showcase

[![Watch showcase](https://img.youtube.com/vi/jh2TKaVG0Fk/0.jpg)](https://www.youtube.com/watch?v=jh2TKaVG0Fk)

---

## Architecture

```
ReplicatedStorage
 ├─ Modules
 │   ├─ ChatEffects              │ Manages effects only, like hightlighting or updating the count.
 │   ├─ ChatInput                │ Listens for the chat opening and sends text messages.
 │   └─ ChatUI                   │ Creates the letters' UI and text messages and toggles the letters between boosted and unboosted.
 ├─ Remotes
 │   ├─ Events
 │   │   ├─ ClientReady
 │   │   ├─ ReceiveMessage
 │   │   ├─ SendMessage
 │   │   └─ UpdateText
 │   └─ Functions
 │       └─ GetRandomLetter
 ├─ Templates
 │   ├─ Letter                   │ Used to dynamically create the LetterGui on join, to avoid having to change 26 frames at once when wanting to changing the design.
 │   └─ ChatMessage
 └─ EventRegistry                │ Centralized access for events / functions, made for cleaner code.


ServerScriptServie
 ├─ Modules
 │   ├─ Chat
 │   │   └─ ChatServer           │ Module for filtering messages and getting a random letter for the user.
 │   └─ Main
 │       ├─ PrizePool            │ Gets a random letter using a weighted prize pool system.
 │       └─ PlayerData           │ Manages player data creation, saving and loading.
 └─ ChatService                  │ Server-sided connector script which uses ChatServer, PlayerData and PrizePool.


 StarterGui
 ├─ LettersGui
 │   └─ Container
 ├─ ChatGui
 │   └─ Frame
 │       ├─ ScrollContainer
 │       └─ ChatBox
 └─ Roll
     └─ Spin

StarterCharacterScripts
 └─ DisableChat                  │ Simple script that disables Roblox's default chat.


StarterPlayerScripts
 └─ ChatController               │ Client-sided connector script that uses all client chat modules.
```

#### System flow

- Both main scripts (server and client) initialize their respective modules and events, using `EventRegistry` for the events.

- On player join, `ChatUI` dynamically generates the letter UI using the `Letter` template.
- `ChatInput` listens for the chat box opening and captures player input.

- When the player sends a message, `ChatInput` fires the `SendMessage` RemoteEvent.
- `ChatService` receives the message, filters it via `ChatServer`, updates the players letter inventory server-sidedly and client-sidedly (with `ChatEffects`) and broadcasts it with `ReceiveMessage`.
- After receiving `ReceiveMessage`, `ChatUI` creates the message by using the `ChatMessage` template.

---

## Code snippets

Check out [code-snippets.md](code-snippets.lua) for code examples.

---

## Why I Made This

This was a project created as a challenge to push my scripting skills further.

Inspired by a similar mechanic I saw from a friend, I wanted to create my own interpretation with boostable letters and a stronger focus on system architecture.

## What I Learned
This project originally started as one large ServerScript and LocalScript, which I refactored into modular client/server components, added a weighted prize pool system, and seperated UI logic from core mechanics. It taught me the importance of designing systems for expandability rather than instantaneous functionality.

## What I'd Improve

I am happy with the current system architeture, but I believe that the UX layer could be improved with animations, sound design and smoother transitions to improve player feel.

---

> ✅ **Status:** Complete
