````markdown
# 🛰️ RemoteTracker

**RemoteTracker** is a simple and efficient tool designed to monitor and intercept *RemoteEvents* and *RemoteFunctions* in Roblox.  
It helps developers debug and understand client-server communication safely and effectively.

---

## 📦 Installation

Add this to your script:

```lua
local RemoteTracker = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Remote-Tracker/source.lua'))()
````

This automatically loads the latest version from the repository.

---

## ⚙️ Usage

Once loaded, use the `:Hook()` method to intercept a specific *RemoteEvent* or *RemoteFunction*.

### Example:

```lua
RemoteTracker:Hook({
    Path = nil, -- Remote path
    Type = nil  -- Remote type: "RemoteEvent" or "RemoteFunction"
})
```

### Parameters:

| Name   | Type       | Description                                                  |
| ------ | ---------- | ------------------------------------------------------------ |
| `Path` | `Instance` | Path to the *RemoteEvent* or *RemoteFunction* to be tracked. |
| `Type` | `string`   | The remote type (`"RemoteEvent"` or `"RemoteFunction"`).     |

---

## 🧠 Example

```lua
local event = game.ReplicatedStorage:WaitForChild("KickPlayer")

RemoteTracker:Hook({
    Path = event,
    Type = "RemoteEvent"
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
