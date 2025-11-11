
# 🛰️ RemoteTracker

**RemoteTracker** is a simple and efficient tool designed to monitor and intercept *RemoteEvents* and *RemoteFunctions* in Roblox.  
It helps developers debug and understand client-server communication safely and effectively.

---

## 📦 Installation

Add this to your script:

```lua
local RemoteTracker = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Remote-Tracker/source.lua'))()
```


This automatically loads the latest version from the repository.

---

## ⚙️ Usage

Once loaded, use the `:Hook()` method to intercept a specific *RemoteEvent* or *RemoteFunction*.

### Example:

```lua
RemoteTracker:Hook({
    Path = nil, -- The Remote path
    Type = "", -- Can be "RemoteEvent" or "RemoteFunction"
    Args = {
        Enabled = false, -- Enable argument checking

        -- Numbers to match with numeric args
        -- Example: if args[1] == 12345, the hook will trigger
        Number = {12345},

        -- Strings to match with string args
        -- Example: if args[2] == "Kicked for exploit", the hook will trigger
        String = {"Kicked for exploit"},

        -- Instances to match with instance args
        -- Example: if args[3] == game.Players.LocalPlayer, the hook will trigger
        Instance = {game.Players.LocalPlayer}
    }
})
```

### Parameters:

| Name            | Type       | Description                                                                            |
| --------------- | ---------- | -------------------------------------------------------------------------------------- |
| `Path`          | `Instance` | Path to the *RemoteEvent* or *RemoteFunction* to be tracked.                           |
| `Type`          | `string`   | The remote type (`"RemoteEvent"` or `"RemoteFunction"`).                               |
| `Args`          | `table`    | Table containing argument filters to match specific remote calls.                      |
| `Args.Enabled`  | `boolean`  | Enables or disables the argument filter.                                               |
| `Args.Number`   | `table`    | List of numeric values to match against numeric arguments (`args[1]`, `args[2]`, ...). |
| `Args.String`   | `table`    | List of string values to match against string arguments (`args[1]`, `args[2]`, ...).   |
| `Args.Instance` | `table`    | List of Roblox instances to match against instance arguments.                          |


---

## 🧠 Example

```lua
-- Example 1: Block the remote completely
local event = game.ReplicatedStorage:WaitForChild("KickPlayer")

RemoteTracker:Hook({
    Path = event,
    Type = "RemoteEvent"
})
```
```lua
-- Example 2: Block the remote only when specific arguments match
local event = game.ReplicatedStorage:WaitForChild("KickPlayer")

RemoteTracker:Hook({
    Path = event,
    Type = "RemoteEvent",
    Args = {
        Enabled = true,
        Number = {12389834},
        String = {"Kicked for exploit"},
        Instance = {game.Players.LocalPlayer}
    }
})
```

This will monitor all fired events sent to or from `KickPlayer`.

---

## 🔐 Disclaimer

> This project is for **educational and debugging purposes only**.
> Misuse may violate Roblox’s Terms of Service. Use only in authorized or development environments.

---

## 🧩 Author

Developed by **[Lmy-x77](https://github.com/Lmy-x77)**
Part of the **InfinityX** tool collection.

---

## ⭐ Contribute

Feel free to open *issues* or *pull requests* to improve documentation or functionality.

---
