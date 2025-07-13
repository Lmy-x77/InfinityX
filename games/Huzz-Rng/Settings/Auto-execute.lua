if game:GetService("Players").LocalPlayer.PlayerGui.Game.MainRoll.Main_RollingFrame.SkipAnim.Status.Text == 'OFF' then
  local Signals = {"Activated", "MouseButton1Down", "MouseButton2Down", "MouseButton1Click", "MouseButton2Click"}
  for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Game.MainRoll.Main_RollingFrame.SkipAnim:GetChildren()) do
    if v:IsA("TextButton") and v.Name == 'Button' then
      for i,Signal in pairs(Signals) do
        firesignal(v[Signal])
      end
    end
  end
end

wait(2)
local mt = getrawmetatable(game)
setreadonly(mt, false)
  local oldNamecall = mt.__namecall
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

if game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild('__Fdd_V22_#') then
  game:GetService("Players").LocalPlayer.PlayerScripts["__Fdd_V22_#"]:Destroy()
  game:GetService("Players").LocalPlayer.PlayerScripts["__GLB2_V1_A4$#"]:Destroy()
  game:GetService("Players").LocalPlayer.PlayerScripts["__GLB_V1_#!@"]:Destroy()
  game:GetService("Players").LocalPlayer.PlayerScripts["___LSLC_V1_##@"]:Destroy()
  game:GetService("Players").LocalPlayer.PlayerScripts["__binSvc_v2\""]:Destroy()
end

local rolls = game:GetService("Players").LocalPlayer.leaderstats:WaitForChild("Rolls")
local target = rolls.Value + 450
local triggered = false

rolls:GetPropertyChangedSignal("Value"):Connect(function()
    if rolls.Value >= target then
      triggered = true
      game:GetService("Players").LocalPlayer.Character.Humanoid.Health = 0
    end
end)

repeat task.wait()
  game:GetService("ReplicatedStorage"):WaitForChild("L5_z%Q1!Rx_"):FireServer()
  if infiniteSpinSettings.Delete == true then
    local args = {
      "delete"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("ConfirmAura"):FireServer(unpack(args))
  end
  if infiniteSpinSettings.Keep == true then
    local args = {
      "keep"
    }
    game:GetService("ReplicatedStorage"):WaitForChild("ConfirmAura"):FireServer(unpack(args))
  end
  task.wait()
until triggered

game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
