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
 │   └─ Chat
 │       ├─ ChatEffects           │ Manages effects only, like hightlighting or updating the count.
 │       ├─ ChatInput             │ Listens for the chat opening and sends text messages.
 │       └─ ChatUI                │ Creates the letters' UI, creates text messages and toggles the letters between boosted and unboosted.
 ├─ Remotes
 │   ├─ Events
 │   │   ├─ ClientReady
 │   │   ├─ ReceiveMessage
 │   │   ├─ SendMessage
 │   │   └─ UpdateText
 │   └─ Functions
 │       └─ GetRandomLetter
 ├─ Templates
 │   ├─ Letter                   │ Used to dynamically create the letterGui on join, to avoid having to change 26 frames at once when changing the design.
 │   └─ ChatMessage
 ├─ EventRegistry                │ Centralized access for events / functions, made for cleaner code
 └─ ModuleRegistry               │ Centralized access for modules, to avoid unorganized require() spams everywhere.

ServerScriptServie
 ├─ Modules
 │   ├─ Chat
 │   │   └─ ChatServer           │ Module for filtering messages and getting a random letter for the user.
 │   └─ Main
 │       ├─ PrizePool            │ Gets a random letter using a weighted prize pool system.
 │       └─ PlayerData           │ Manages player data creation, saving and loading.
 ├─ ChatService                  │ Server-sided connector script (uses ChatServer, PlayerData and PrizePool).
 └─ ModuleRegistry               │ Same as above, centralized access for modules.

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
 └─ ChatController               │ Client-sided connector script (uses all client chat modules).
```

---

## Code snippets

Check out [code-snippets.md](code-snippets.lua) for code examples.

---

## Why I Made This
This was a project created as a challenge to push my scripting skills further.

Inspired by a similar mechanic I saw from a friend, I wanted to create my own interpretation with a stronger focus on system architecture.

I intentionally chose a system that required server authority, data saving and real-time UI updates.

## What I Learned
This project originally started as one large ServerScript and LocalScript, which I refactored into modular client/server components, added a weighted prize pool system, and seperated UI logic from core mechanics.

That refactor greatly improved scalability, maintainability and clarity, which taught me the importance of designing systems for growth rather than instantaneous functionality.

## What I'd Improve

Even though the system architecture is steady, the UX layer could be improved with animations, sound design and smoother transitions to improve player feel.

---

> ✅ **Status:** Complete
