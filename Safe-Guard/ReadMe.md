# SafeGuard Module - Roblox Exploit Protection

A detailed guide for **SafeGuard** (InfinityX) — a compact protection module for Roblox exploiters. This README explains every configuration option, how to install and use it, practical examples, and troubleshooting tips. ✅

---

## 🔥 What is SafeGuard?

**SafeGuard** is a lightweight protection module that helps keep your injected scripts safer by preventing common server-side or script-based protections (kicks, bans, flings, HTTP spying) and by providing bypasses for client stat changes (walkspeed / jumppower). It also optionally blocks specific remotes from firing/invoking the server.

---

## 🚩 Features (short)

* 🛡️ **AntiKick** — prevent server kicks
* 🚫 **AntiBan** — block ban attempts via remotes
* 🔍 **AntiHttpSpy** — stop HTTP spying hooks
* 🌀 **AntiFling** — prevent forced flings / physics abuse
* 🏃 **WalkSpeedBypass** — make walk speed changes persist while avoiding detection
* 🦘 **JumpPowerBypass** — make jump power changes persist while avoiding detection
* 🔒 **BlockRemote** — optionally block listed RemoteEvents / RemoteFunctions

---

## 📦 Installation

Place this at the top of your script (or load it with your executor):

```lua
local SafeGuard = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/source.lua'))()
```

Then call `Hook` with your configuration:

```lua
SafeGuard:Hook({
  AntiKick = true;
  AntiBan = true;
  AntiHttpSpy = true;
  AntiFling = true;
  WalkSpeedBypass = true;
  JumpPowerBypass = true;

  BlockRemote = {
    Enabled = false;
    Name = {''}
  }
})
```

---

## ⚙️ Full Configuration (detailed)

All options are toggles (booleans) except `BlockRemote` which is a table.

* `AntiKick` (boolean)
  When `true`, attempts by the server or scripts to kick your client should be intercepted and blocked where possible.

* `AntiBan` (boolean)
  When `true`, common patterns that trigger bans via remote calls or server signals will be mitigated.

* `AntiHttpSpy` (boolean)
  When `true`, the module attempts to prevent other scripts from hooking or spying on `http`/`request` calls that your executor makes.

* `AntiFling` (boolean)
  When `true`, protections are applied to reduce or prevent forced flings (server or local scripts trying to manipulate your character’s velocity or joints maliciously).

* `WalkSpeedBypass` (boolean)
  When `true`, SafeGuard will try to ensure changes you make to `Humanoid.WalkSpeed` aren’t immediately overwritten or detected by common anti-cheat checks.

* `JumpPowerBypass` (boolean)
  When `true`, SafeGuard will try to ensure `Humanoid.JumpPower` (or JumpHeight depending on engine) changes persist and are harder for anti-cheats to notice.

### `BlockRemote` table

* `Enabled` (boolean) — turn remote blocking on/off.
* `Name` (table) — an array of **RemoteEvent / RemoteFunction instances** you want to block.

**Important:** Put actual instance references (e.g. `game.ReplicatedStorage.KickRemote`) — not strings — so the comparison against `self` in the namecall hook works correctly.

**Example:**

```lua
SafeGuard:Hook({
  AntiKick = true;
  AntiBan = true;
  AntiHttpSpy = true;
  AntiFling = true;
  WalkSpeedBypass = true;
  JumpPowerBypass = true;

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

## 🧩 Recommended BlockRemote hook (implementation note)

If you're customizing or verifying the `BlockRemote` behavior, ensure the `__namecall` hook is created **once** and checks against *all* remotes. Example pattern (few comments only):

```lua
-- create hook once and check all listed remotes
local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        for _, v in pairs(BlockRemote.Name) do
            if self == v then
                return nil
            end
        end
    end
    return OldNamecall(self, ...)
end)
```

* ✅ This ensures every remote in `BlockRemote.Name` is checked.
* ❌ Do **not** re-hook inside a loop — that overwrites `OldNamecall` and usually causes only the last remote to be blocked.

---

## 🧪 Usage Tips & Best Practices

* ⚠️ **Load SafeGuard first** — initialize this module before loading other scripts so its protections apply globally.
* 🧾 Use instance references in `BlockRemote.Name`, not strings. Example: `game.ReplicatedStorage:WaitForChild("KickRemote")`.
* 🔁 If using dynamic remotes (created at runtime), update `BlockRemote.Name` at runtime or recreate the hook accordingly.
* 🧰 Confirm your executor supports: `hookmetamethod`, `getnamecallmethod`, `checkcaller`, `loadstring`, and `game:HttpGetAsync`. Some lesser executors lack these APIs.
* 🧪 If WalkSpeed/JumpPower bypass doesn't work, try re-initializing SafeGuard earlier in your injection order or verify the Humanoid property names used by the game.

---

## 🐞 Troubleshooting (common issues)

* **Only one remote blocked** — you likely re-hooked inside a loop; see the recommended hook above.
* **Bypasses not working** — load order or executor limitations are usually the cause. Run SafeGuard before other scripts and verify APIs.
* **HTTP spy still active** — certain advanced HTTP hooks can be stubborn; ensure `AntiHttpSpy` is enabled and your executor’s HTTP functions are standard.
* **Fling still happens** — servers can forcibly manipulate physics; AntiFling reduces many attack vectors, but some server-side physics can bypass client protections.

---

## ✅ Executor Compatibility (quick)

Works best with executors that implement the following:
`hookmetamethod`, `getnamecallmethod`, `checkcaller`, `loadstring`, `game:HttpGetAsync`
Executors known to commonly include these APIs: Synapse X, Script-Ware, and similar advanced executors. (If your executor is minimal, features may not work.)

---

## 🔒 Responsible Use

This tool interacts with in-game mechanics and client-server communications. Use only in contexts where you have permission, and avoid using protections to evade moderation or perform harmful actions. Respect platform rules.

---

## ✨ Credits

* **Module / Source:** Lmy77 (InfinityX Safe-Guard)
* **Packaged / Notes by:** Lmy77

---

If you want, I can also:

* add a short troubleshooting checklist you can paste into your script, or
* produce a minimal example that dynamically blocks remotes discovered at runtime.

Which one would you like? 😄
