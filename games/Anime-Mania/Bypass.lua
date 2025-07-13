local remoteName = "Ban"
local mt = getrawmetatable(game)
local lscript = game:GetService("Players").LocalPlayer.Backpack:WaitForChild("ClientMain")
local senv = getsenv(lscript)

setreadonly(mt, false)
  local oldNamecall = mt.__namecall
  mt.__namecall = newcclosure(function(self, ...)
      local method = getnamecallmethod()
      if method == "FireServer" and tostring(self) == remoteName then
          return
      end
      return oldNamecall(self, ...)
  end)

  hookfunction(game.Players.LocalPlayer.Kick, newcclosure(function(...)
      return nil
  end))
  mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == game.Players.LocalPlayer and method == "Kick" then
        return nil
    end
    return oldNamecall(self, ...)
  end)
setreadonly(mt, true)
