local SafeGuard = {}
SafeGuard.__index = SafeGuard

function WalkSpeedBypass()
  local gmt = getrawmetatable(game)
  setreadonly(gmt, false)
  local oldIndex = gmt.__Index
  gmt.__Index = newcclosure(function(self, b)
    if b == 'WalkSpeed' then
      return 16
    end
    return oldIndex(self, b)
  end)
end
function JumpPowerBypass()
  local gmt = getrawmetatable(game)
  setreadonly(gmt, false)
  local oldIndex = gmt.__Index
  gmt.__Index = newcclosure(function(self, b)
    if b == 'JumpPower' then
      return 50
    end
    return oldIndex(self, b)
  end)
end

function SafeGuard:Hook(info)
  local AntiKick = info.AntiKick
  local AntiBan = info.AntiBan
  local AntiHttpSpy = info.AntiHttpSpy
  local AntiFling = info.AntiFling
  local WalkSpeedBypass = info.WalkSpeedBypass
  local JumpPowerBypass = info.JumpPowerBypass
  local BlockRemote = info.BlockRemote or {}

  if AntiKick then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Anti-Kick.lua'))()
  end
  if AntiBan then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Anti-Ban.lua'))()
  end
  if AntiHttpSpy then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Http-Spy.lua'))()
  end
  if AntiFling then
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local Player = Players.LocalPlayer
    RunService.Stepped:Connect(function()
      if not AntiFling then return end
      for _, CoPlayer in pairs(Players:GetChildren()) do
        if CoPlayer ~= Player and CoPlayer.Character then
          for _, Part in pairs(CoPlayer.Character:GetChildren()) do
            if Part.Name == "HumanoidRootPart" then
              Part.CanCollide = false
            end
          end
        end
      end
      for _, Accessory in pairs(workspace:GetChildren()) do
        if Accessory:IsA("Accessory") and Accessory:FindFirstChildWhichIsA("Part") then
          Accessory:FindFirstChildWhichIsA("Part"):Destroy()
        end
      end
    end)
  end
  if WalkSpeedBypass then
    WalkSpeedBypass()
  end
  if JumpPowerBypass then
    JumpPowerBypass()
  end
  if BlockRemote.Enabled then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Block-Remote.lua'))()
  end
end

return SafeGuard
