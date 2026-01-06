-- variables
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Cmdr = RS:WaitForChild("CmdrClient")
local CmdrFunction = Cmdr:WaitForChild("CmdrFunction")
local CmdrEvent = Cmdr:WaitForChild("CmdrEvent")
local function ExecuteCmd(command)
  pcall(function()
    ExecuteCmd(command)
  end)
  pcall(function()
    CmdrEvent:FireServer(command)
  end)
end
_G.loopkill = _G.loopkill or {}
_G.loopresp = _G.loopresp or {}


-- ui libray
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Command/source.lua"))()
local Window = Library:CreateWindow({
  Name = '🚀 <b><font color="rgb(170,85,255)">InfinityX</font></b>',
  IntroText = '👑 <b><font color="rgb(170,85,255)">InfinityX</font></b>\n<font color="rgb(200,200,200)">Premium Admin Command System</font>',
  IntroIcon = '',
  IntroBlur = true,
  IntroBlurIntensity = 15,
  Theme = Library.Themes.purple,
  Position = 'bottom',
  Draggable = true,
  Prefix = 'LeftControl'
})


-- source
Window:AddCommand('respawn', {'Player Name, All or Others'}, 'Execute respawn command', function(Arguments, Speaker)
  local arg = Arguments[1]
  if arg == "All" or arg == "all" then
    for _, plr in ipairs(Players:GetPlayers()) do
      ExecuteCmd("respawn " .. plr.Name)
    end
  elseif arg == 'Others' or arg == 'others' then
    for _, v in pairs(game.Players:GetChildren()) do
      if v.Name ~= game.Players.LocalPlayer.Name then
        ExecuteCmd("respawn " .. v.Name)
      end
    end
  else
    local findPlr = arg:lower()
    for _, plr in pairs(Players:GetPlayers()) do
      if plr.Name:lower():find(findPlr) then
        ExecuteCmd("respawn " .. plr.Name)
      end
    end
  end
end)
Window:AddCommand('kick', {'Player Name, All or Others'}, 'Execute kick command', function(Arguments, Speaker)
  local arg = Arguments[1]
  if arg == "All" or arg == "all" then
    for _, v in pairs(game.Players:GetChildren()) do
      ExecuteCmd("kick " .. v.Name)
    end
  elseif arg == 'Others' or arg == 'others' then
    for _, v in pairs(game.Players:GetChildren()) do
      if v.Name ~= game.Players.LocalPlayer.Name then
        ExecuteCmd("kick " .. v.Name)
      end
    end
  else
    local findPlr = arg:lower()
    for _, plr in pairs(Players:GetPlayers()) do
      if plr.Name:lower():find(findPlr) then
        ExecuteCmd("kick " .. plr.Name)
      end
    end
  end
end)
Window:AddCommand('kill', {'Player Name, All or Others'}, 'Execute kill command', function(Arguments, Speaker)
  local arg = Arguments[1]
  if arg == "All" or arg == "all" then
    for _, v in pairs(game.Players:GetChildren()) do
      ExecuteCmd("kill " .. v.Name)
    end
  elseif arg == 'Others' or arg == 'others' then
    for _, v in pairs(game.Players:GetChildren()) do
      if v.Name ~= game.Players.LocalPlayer.Name then
        ExecuteCmd("kill " .. v.Name)
      end
    end
  else
    local findPlr = arg:lower()
    for _, plr in pairs(Players:GetPlayers()) do
      if plr.Name:lower():find(findPlr) then
        ExecuteCmd("kill " .. plr.Name)
      end
    end
  end
end)
Window:AddCommand('loopkill', {'Player Name, All or Others', 'true / false'}, 'Kill in while', function(Arguments, Speaker)
    local target = Arguments[1]
    local state = Arguments[2]

    if state == "true" then
      if _G.loopkill[target] then return end
      _G.loopkill[target] = true

      task.spawn(function()
        while _G.loopkill[target] do task.wait()
          if target:lower() == "all" or target:lower() == "All" then
            for _, plr in ipairs(Players:GetPlayers()) do
              ExecuteCmd("kill " .. plr.Name)
            end
          elseif target:lower() == "others" or target:lower() == "Others" then
            for _, plr in ipairs(Players:GetPlayers()) do
              if plr ~= Players.LocalPlayer then
                ExecuteCmd("kill " .. plr.Name)
              end
            end
          else
            local findPlr = target:lower()
            for _, plr in ipairs(Players:GetPlayers()) do
              if plr.Name:lower():find(findPlr) then
                ExecuteCmd("kill " .. plr.Name)
              end
            end
          end
        end
      end)
    elseif state == "false" then
      _G.loopkill[target] = false
    end
end)
Window:AddCommand('looprespawn', {'Player Name, All or Others', 'true / false'}, 'Respawn in while', function(Arguments, Speaker)
  local target = Arguments[1]
  local state = Arguments[2]

  if state == "true" then
    if _G.loopresp[target] then return end
    _G.loopresp[target] = true

    task.spawn(function()
      while _G.loopresp[target] do task.wait()
        if target:lower() == "all" or target:lower() == "All" then
          for _, plr in ipairs(Players:GetPlayers()) do
            ExecuteCmd("respawn " .. plr.Name)
          end
        elseif target:lower() == "others" or target:lower() == "Others" then
          for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= Players.LocalPlayer then
              ExecuteCmd("respawn " .. plr.Name)
            end
          end
        else
          local findPlr = target:lower()
          for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Name:lower():find(findPlr) then
              ExecuteCmd("respawn " .. plr.Name)
            end
          end
        end
      end
    end)
  elseif state == "false" then
    _G.loopkill[target] = false
  end
end)
Window:AddCommand('teleport', {'player1, player2'}, 'Teleports a player or set of players to one target.', function(Arguments, Speaker)
  local arg = Arguments[1]
  ExecuteCmd("teleport ".. arg)
end)
Window:AddCommand('announce', {'announcement text'}, 'Teleports a player or set of players to one target.', function(Arguments, Speaker)
  local arg = Arguments[1]
  ExecuteCmd("announce ".. arg)
end)
Window:CreateNotification('Notification', 'Press "LeftControl" to active ui', 5)
