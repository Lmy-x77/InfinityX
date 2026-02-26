-- start
print[[                                                                     
 /$$$$$$            /$$$$$$  /$$           /$$   /$$               /$$   /$$
|_  $$_/           /$$__  $$|__/          |__/  | $$              | $$  / $$
  | $$   /$$$$$$$ | $$  \__/ /$$ /$$$$$$$  /$$ /$$$$$$   /$$   /$$|  $$/ $$/
  | $$  | $$__  $$| $$$$    | $$| $$__  $$| $$|_  $$_/  | $$  | $$ \  $$$$/ 
  | $$  | $$  \ $$| $$_/    | $$| $$  \ $$| $$  | $$    | $$  | $$  >$$  $$ 
  | $$  | $$  | $$| $$      | $$| $$  | $$| $$  | $$ /$$| $$  | $$ /$$/\  $$
 /$$$$$$| $$  | $$| $$      | $$| $$  | $$| $$  |  $$$$/|  $$$$$$$| $$  \ $$
|______/|__/  |__/|__/      |__/|__/  |__/|__/   \___/   \____  $$|__/  |__/
                                                         /$$  | $$          
                                                        |  $$$$$$/          
                                                         \______/           
]]



-- variables
getgenv().infiniteSpinSettings = {
  Keep = false,
  Delete = false
}
local infiniteSpinSettings = {
  Keep = false,
  Delete = false
}
local rollSettings = {
  timeToExecute = 2
}
function gradient(text, startColor, endColor)
  local result = ""
  local length = #text
  for i = 1, length do
      local t = (i - 1) / math.max(length - 1, 1)
      local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
      local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
      local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
      local char = text:sub(i, i)
      result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
  end
  return result
end
function GetSize()
  if game:GetService('UserInputService').TouchEnabled and not game:GetService('UserInputService').KeyboardEnabled and not game:GetService('UserInputService').MouseEnabled then
      return UDim2.fromOffset(600, 350)
  else
      return UDim2.fromOffset(830, 525)
  end
end
scriptVersion = "3.2a"



-- ui library
local WindUI
local ok, result = pcall(function()
  return require("./src/Init")
end)
if ok then
  WindUI = result
else
  WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()
end
WindUI:AddTheme({
  Name = "InfinityX",

  Accent = Color3.fromHex("#A855F7"),
  Dialog = Color3.fromHex("#12071C"),
  Outline = Color3.fromHex("#3B1E5C"),
  Text = Color3.fromHex("#F8F7FF"),
  Placeholder = Color3.fromHex("#B3A6D6"),
  Background = Color3.fromHex("#08040F"),
  Button = Color3.fromHex("#7C3AED"),
  Icon = Color3.fromHex("#C084FC"),
})
local Window = WindUI:CreateWindow({
  Title = "InfinityX",
  Author = "Anime Fighinting Simulator",
  Folder = "InfinityX/Settings",
  Icon = "rbxassetid://90772127577731",
  Theme = "InfinityX",
  NewElements = true,
  Size = UDim2.fromOffset(680, 580),
  Transparent = false,
  HideSearchBar = true,
  SideBarWidth = 180,
})
Window:EditOpenButton({
  Title = ".gg/emKJgWMHAr",
  Icon = "rbxassetid://90772127577731",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 2,
  Color = ColorSequence.new(
    Color3.fromRGB(146, 84, 228),
    Color3.fromRGB(99, 61, 204)
  ),
  OnlyMobile = false,
  Enabled = true,
  Draggable = true,
})


-- tabs
local Tabs = {
  Main = Window:Tab({
    Title = "| Main",
    Icon = "layers",
    Desc = "Main tab",
  }),
  Op = Window:Tab({
    Title = "| Op",
    Icon = "star",
    Desc = "Op tab",
  }),
  Misc = Window:Tab({
    Title = "| Misc",
    Icon = "layers",
    Desc = "Misc tab",
  }),
}
Window:SelectTab(1)



-- source
local Section = Tabs.Main:Section({
  Title = "Auto Farm",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Toggle = Tabs.Main:Toggle({
  Title = "Auto roll",
  Icon = "check",
  Value = false,
  Callback = function(state)
    autoRoll = state
    if autoRoll then
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
    end
    while autoRoll do task.wait()
      game:GetService("ReplicatedStorage"):WaitForChild("L5_z%Q1!Rx_"):FireServer()
      wait(2)
    end
  end,
})
local Toggle = Tabs.Main:Toggle({
  Title = "Collect all potions",
  Desc = 'Collect all the potions on the map',
  Value = false,
  Callback = function(state)
    collectPotions = state
    while collectPotions do task.wait()
      for _, v in pairs(game:GetService("ReplicatedStorage").Potions:GetChildren()) do
        if v:IsA('Part') then
          for _, x in pairs(workspace:GetChildren()) do
            if x:IsA('Part') and x.Name == tostring(v) then
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.CFrame
              fireproximityprompt(x.ProximityPrompt)
            end
          end
        end
      end
    end
  end
})
local Toggle = Tabs.Main:Toggle({
  Title = "Auto find black market",
  Desc = 'When the black market appears, it teleports you to it',
  Value = false,
  Callback = function(state)
    blackMarket = state
    game.Workspace.DescendantAdded:Connect(function(descendant)
      if blackMarket then
        if descendant:IsA('Model') and descendant.Name:lower():find('darkmarket') then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = descendant.PrimaryPart.CFrame
        end
      end
    end)
  end
})
local Button = Tabs.Main:Button({
  Title = "Get skip roll",
  Desc = 'Change your spins to be able to active skip roll',
  Callback = function()
    if game:GetService("Players").LocalPlayer.PlayerGui.Game.MainRoll.Main_RollingFrame.SkipAnim.Status.Text == 'OFF' then
      local savedValue = game:GetService("Players").LocalPlayer.leaderstats.Rolls.Value
      wait(.2)
      game:GetService("Players").LocalPlayer.leaderstats.Rolls.Value = 100
      wait(.2)
      local Signals = {"Activated", "MouseButton1Down", "MouseButton2Down", "MouseButton1Click", "MouseButton2Click"}
      for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Game.MainRoll.Main_RollingFrame.SkipAnim:GetChildren()) do
        if v:IsA("TextButton") and v.Name == 'Button' then
          for i,Signal in pairs(Signals) do
            firesignal(v[Signal])
          end
        end
      end
      wait(.2)
      game:GetService("Players").LocalPlayer.leaderstats.Rolls.Value = savedValue
    end
  end
})
local Button = Tabs.Main:Button({
  Title = "Get auto roll",
  Desc = 'Change your spins to be able to use auto roll',
  Callback = function()
    game:GetService("Players").LocalPlayer.leaderstats.Rolls.Value = 200
  end
})
local Section = Tabs.Op:Section({
  Title = "Infinite Spins",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Paragraph = Tabs.Op:Paragraph({
  Title = "WARING [ Don't use this function too much, it's not working properly because of Update and it's also not secure ]",
  Desc = "How it works is that it runs 450 automatic spins for you for free and then rejoins the server. Why 450? because if it goes beyond that because it's too fast, the game detects it and bans you. To prevent this, the script has security and activates it and rejoins you.\n\nI don't recommend abusing this function, the script has been tested several times and hasn't been banned, but just to be on the safe side, don't abuse it too much or even don't use it on your main account.\n\nRemembering that this is only for pharma spins and not auras",
  Locked = false,
})
local Toggle = Tabs.Op:Toggle({
  Title = "Start",
  Icon = "check",
  Value = false,
  Callback = function(state)
    infSpin = state
    if infSpin then
      if infiniteSpinSettings.Delete == false and infiniteSpinSettings.Keep == false then
        local Dialog = Window:Dialog({
          Icon = "droplet",
          Title = "Prompt",
          Content = "Please activate any of the toggles in order to run the code correctly",
          Buttons = {
            {
              Title = "OK!", 
              Callback = function() end,
              Variant = "Primary"
            }
          }
        }) Dialog:Open()
        return
      end
      if infiniteSpinSettings.Delete == true and infiniteSpinSettings.Keep == true then
        local Dialog = Window:Dialog({
          Icon = "droplet",
          Title = "Prompt",
          Content = "You can only leave one of the options below selected, not both",
          Buttons = {
            {
              Title = "OK!", 
              Callback = function() end,
              Variant = "Primary"
            }
          }
        }) Dialog:Open()
        return
      end

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
    end
  end,
})
local Toggle = Tabs.Op:Toggle({
  Title = "Start + Auto execute",
  Icon = "check",
  Value = false,
  Callback = function(state)
    autoExecute = state
    queueteleport = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
    if autoExecute then
      if infiniteSpinSettings.Delete == false and infiniteSpinSettings.Keep == false then
        local Dialog = Window:Dialog({
          Icon = "droplet",
          Title = "Prompt",
          Content = "Please activate any of the toggles in order to run the code correctly",
          Buttons = {
            {
              Title = "OK!", 
              Callback = function() end,
              Variant = "Primary"
            }
          }
        }) Dialog:Open()
        return
      end
      if infiniteSpinSettings.Delete == true and infiniteSpinSettings.Keep == true then
        local Dialog = Window:Dialog({
          Icon = "droplet",
          Title = "Prompt",
          Content = "You can only leave one of the options below selected, not both",
          Buttons = {
            {
              Title = "OK!", 
              Callback = function() end,
              Variant = "Primary"
            }
          }
        }) Dialog:Open()
        return
      end

      loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/HuzzRng/create_info.lua",true))()
      wait(.5)
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/HuzzRng/auto_execute.lua",true))()

      local TeleportCheck = false
      Game.Players.LocalPlayer.OnTeleport:Connect(function(State)
        if (not TeleportCheck) and queueteleport then
          TeleportCheck = true
          queueteleport('repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.LoadingScreen.Enabled == false wait(2) loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/HuzzRng/create_info.lua",true))() wait(0.5) getgenv().infiniteSpinSettings = {Keep = false, Delete = false} loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/HuzzRng/auto_execute.lua",true))()')
        end
      end)
    end
  end,
})
local Section = Tabs.Op:Section({
  Title = "Settings",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Toggle = Tabs.Op:Toggle({
  Title = "Collect all auras",
  Desc = "Activate to collect all the auras that are rotated in the infinite spin",
  Icon = "check",
  Value = false,
  Callback = function(state)
    infiniteSpinSettings.Keep = state
    getgenv().infiniteSpinSettings.Keep = state
  end,
})
local Toggle = Tabs.Op:Toggle({
  Title = "Delete all auras",
  Desc = "Activate to delete all the auras that are rotated in the infinite spin",
  Icon = "check",
  Value = false,
  Callback = function(state)
    infiniteSpinSettings.Delete = state
    getgenv().infiniteSpinSettings.Delete = state
  end,
})
local Section = Tabs.Main:Section({
  Title = "Auto Roll Settings",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Toggle = Tabs.Main:Toggle({
  Title = "Collect auras",
  Value = false,
  Callback = function(state)
    collectAuras = state
    while collectAuras do task.wait()
      local args = {
        "keep"
      }
      game:GetService("ReplicatedStorage"):WaitForChild("ConfirmAura"):FireServer(unpack(args))
      wait(rollSettings.timeToExecute)
    end
  end
})
local Toggle = Tabs.Main:Toggle({
  Title = "Delete auras",
  Value = false,
  Callback = function(state)
    deleteAuras = state
    while deleteAuras do task.wait()
      local args = {
        "delete"
      }
      game:GetService("ReplicatedStorage"):WaitForChild("ConfirmAura"):FireServer(unpack(args))
      wait(rollSettings.timeToExecute)
    end
  end
})
local Slider = Tabs.Main:Slider({
  Title = "Set time to use",
  Desc = "This shows how long the above functions will run for. if you want to increase it, use the slider",
  Step = 1,
  Value = {
      Min = 1,
      Max = 10,
      Default = 2,
  },
  Callback = function(value)
    rollSettings.timeToExecute = value
  end
})
local Section = Tabs.Misc:Section({
  Title = "Misc Options",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Button = Tabs.Misc:Button({
  Title = "Reedem all codes",
  Callback = function()
    local codes = {'FREESTUFF!!', 'NAHIDLOSE!!', 'TYFOR200K!!'}
    for _, v in pairs(codes) do
      local args = {
        v
      }
      game:GetService("ReplicatedStorage").RedeemCodeEvent:FireServer(unpack(args))
    end
  end
})
local Toggle = Tabs.Misc:Toggle({
  Title = "Anti afk",
  Desc = "Dont have kiked at 20 minutes idled",
  Icon = "check",
  Value = false,
  Callback = function(state)
    afk = state
    if afk then
      local VirtualUser = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      end)
    end
  end,
})
