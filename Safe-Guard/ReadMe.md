# SafeGuard Module - Roblox Exploit Protection

The **SafeGuard** module is a simple and efficient security system designed for Roblox executors.  
It protects your scripts from being detected, kicked, or banned by the game, while also allowing you to block specific remotes.

---

## 🚀 Features
- 🛡️ **Anti Kick** — Prevents the game from kicking your player.  
- 🚫 **Anti Ban** — Blocks ban attempts executed through remotes.  
- 🔒 **Anti HTTP Spy** — Prevents external scripts from spying on your HTTP requests.  
- ⚙️ **Block Remote** — Blocks specific remotes from firing or invoking servers.

---

## 📦 Installation

1. Copy the following line and paste it into your script:
```lua
local SafeGuard = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/source.lua'))()
```

2. After loading, initialize SafeGuard with your desired settings using:

 ```lua
 SafeGuard:Hook({
   AntiKick = true;
   AntiBan = true;
   AntiHttpSpy = true;

   BlockRemote = {
     Enabled = false;
     Name = {''}
   }
 })
 ```

---

## ⚙️ Configuration

### **AntiKick**

* **Type:** Boolean
* **Default:** `true`
* Prevents the game from kicking your player using internal methods.

### **AntiBan**

* **Type:** Boolean
* **Default:** `true`
* Blocks attempts to ban your account through remote calls.

### **AntiHttpSpy**

* **Type:** Boolean
* **Default:** `true`
* Protects your HTTP requests from being intercepted by other scripts.

### **BlockRemote**

* **Type:** Table
* **Default:**

```lua
BlockRemote = {
  Enabled = false;
  Name = {''}
}
```
* When enabled, blocks the listed RemoteEvents or RemoteFunctions from firing or invoking the server.

**Example:**

```lua
BlockRemote = {
  Enabled = true;
  Name = {
    game.ReplicatedStorage.RemoteEvent1,
    game.ReplicatedStorage.RemoteFunction2
  }
}
```

---

## 🧠 Notes

* Ensure your executor supports `hookmetamethod`, `getnamecallmethod`, and `checkcaller`.
* For safety, always run this script before executing other custom scripts.
* Works best on executors like **Wave**, **Synapse X**, and **Script-Ware**.

---

## 📜 Example Script

```lua
local SafeGuard = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/source.lua'))()

SafeGuard:Hook({
  AntiKick = true;
  AntiBan = true;
  AntiHttpSpy = true;

  BlockRemote = {
    Enabled = true;
    Name = {
      game.ReplicatedStorage.KickRemote,
      game.ReplicatedStorage.BanEvent
    }
  }
})
```

---

## 🧩 Credits

**Developed by:** [SPDM Team]
**Script by:** [Lmy-x77]
**Project:** [InfinityX - SafeGuard Library]

Protect your scripts. Stay undetected.
