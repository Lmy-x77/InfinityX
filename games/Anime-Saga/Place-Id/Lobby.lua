-- variables
local rollSettings = {
  rollAmount = nil,
  delayToOpen = 0.5,
}
local teleportSettings = {
  SelectedWorld = nil,
  SelectedAct = nil,
  SelectedDifficulty = nil
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
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:AddTheme({
  Name = "InfinityX",
  Accent = "#18181b",
  Outline = "#450b9c",
  Text = "#924aff",
  Placeholder = "#999999",
  Background = "#0e0e10",
  Button = "#924aff",
  Icon = "#924aff",
})

WindUI:Popup({
  Title = "Welcome to " .. gradient("InfinityX", Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204)),
  Icon = "info",
  Content = game.Players.LocalPlayer.Name .. ", I hope you enjoy the experience\nHave fun!",
  Buttons = {
      {
          Title = "Cancel",
          --Icon = "",
          Callback = function() end,
          Variant = "Tertiary",
      },
      {
          Title = "Continue",
          Icon = "arrow-right",
          Callback = function() Confirmed = true end,
          Variant = "Primary",
      }
  }
})

repeat wait() until Confirmed

local Window = WindUI:CreateWindow({
  Title = "InfinityX - "..scriptVersion,
  Icon = "rbxassetid://126527122577864",
  Author = game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name,
  Folder = "CloudHub",
  Size = GetSize(),
  Transparent = false,
  Theme = "InfinityX",
  SideBarWidth = 180,
  Background = "",
  User = {
      Enabled = true,
      Anonymous = false,
      Callback = function()
          print("clicked")
      end,
  },
})
Window:EditOpenButton({
  Title = "Click here to open "..gradient("InfinityX", Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204)),
  Icon = "monitor",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 1.5,
  Color = ColorSequence.new(
    Color3.fromRGB(129, 63, 214),
    Color3.fromRGB(63, 61, 204)
  ),
  Enabled = true,
  Dragable = false,
})
local Tabs = {
  Lobby = Window:Tab({
    Title = "| Lobby",
    Icon = "layers",
    Desc = "Lobby tab",
  }),
  Join = Window:Tab({
    Title = "| Join",
    Icon = "merge",
    Desc = "Join tab",
  }),
}
Window:SelectTab(1)



-- source
local Section = Tabs.Lobby:Section({
  Title = "Auto Roll",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Dropdown = Tabs.Lobby:Dropdown({
  Title = "Select amount",
  Desc = "Select the amount of roll you want",
  Value = "nil",
  Multi = false,
  AllowNone = true,
  Values = {1, 10},
  Callback = function(Options)
    rollSettings.rollAmount = Options
  end
})
local Toggle = Tabs.Lobby:Toggle({
  Title = "Auto roll",
  Desc = "Click here to enable auto roll",
  Icon = "check",
  Value = false,
  Callback = function(state)
    roll = state
    while roll do task.wait()
      local ohNumber1 = rollSettings.rollAmount
      game:GetService("ReplicatedStorage").Event.Summon:FireServer(ohNumber1)
      wait(rollSettings.delayToOpen)
    end
  end,
})
local Slider = Tabs.Lobby:Slider({
  Title = "Set delay",
  Step = 0.10,
  Value = {
      Min = 0,
      Max = 5,
      Default = 0.5,
  },
  Callback = function(value)
    rollSettings.delayToOpen = value
  end
})
local Section = Tabs.Lobby:Section({
  Title = "Misc",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Button = Tabs.Lobby:Button({
  Title = "Claim all rewards",
  Desc = "Click here to claim all rewards",
  Callback = function()
    game:GetService("ReplicatedStorage").Event.ClaimReward:FireServer()
  end
})
local Button = Tabs.Lobby:Button({
  Title = "Reedem all codes",
  Desc = "Click here to reedem all codes",
  Callback = function()
    local codes = {'10MVisits', '200kMembers', 'InBugSagaWeTrust', 'BugSaga', '1MVisits', '50KActive', 'SorryForShutdown', 'SorryForDelay', 'Release'}
    for _, v in pairs(codes) do
      local ohString1 = v
      game:GetService("ReplicatedStorage").Event.Codes:FireServer(ohString1)
    end
  end
})
local Section = Tabs.Join:Section({
  Title = "Auto Join Normal",
  TextXAlignment = "Center",
  TextSize = 17,
})
local Dropdown = Tabs.Join:Dropdown({
  Title = "Select world",
  Desc = "Select the world you want to join",
  Value = "nil",
  Multi = false,
  AllowNone = true,
  Values = {'Leaf Village', 'Marine Island', 'Red Light District', 'West City'},
  Callback = function(Options)
    teleportSettings.SelectedWorld = Options
    if teleportSettings.SelectedWorld == 'Leaf Village' then
      teleportSettings.SelectedWorld = 1
    elseif teleportSettings.SelectedWorld == 'Marine Island' then
      teleportSettings.SelectedWorld = 2
    elseif teleportSettings.SelectedWorld == 'Red Light District' then
      teleportSettings.SelectedWorld = 3
    elseif teleportSettings.SelectedWorld == 'West City' then
      teleportSettings.SelectedWorld = 4
    end
  end
})
local Dropdown = Tabs.Join:Dropdown({
  Title = "Select act",
  Desc = "Select the act you want",
  Value = "nil",
  Multi = false,
  AllowNone = true,
  Values = {'Act 1', 'Act 2', 'Act 3', 'Act 4', 'Act 5'},
  Callback = function(Options)
    teleportSettings.SelectedAct = Options
    if teleportSettings.SelectedAct == 'Act 1' then
      teleportSettings.SelectedAct = 1
    elseif teleportSettings.SelectedAct == 'Act 2' then
      teleportSettings.SelectedAct = 2
    elseif teleportSettings.SelectedAct == 'Act 3' then
      teleportSettings.SelectedAct = 3
    elseif teleportSettings.SelectedAct == 'Act 4' then
      teleportSettings.SelectedAct = 4
    elseif teleportSettings.SelectedAct == 'Act 5' then
      teleportSettings.SelectedAct = 5
    end
  end
})
local Dropdown = Tabs.Join:Dropdown({
  Title = "Select difficulty",
  Desc = "Select the difficulty you want",
  Value = "nil",
  Multi = false,
  AllowNone = true,
  Values = {'Normal', 'Hard', 'Nightmare'},
  Callback = function(Options)
    teleportSettings.SelectedDifficulty = Options
    if teleportSettings.SelectedDifficulty == 'Normal' then
      teleportSettings.SelectedDifficulty = 1
    elseif teleportSettings.SelectedDifficulty == 'Hard' then
      teleportSettings.SelectedDifficulty = 2
    elseif teleportSettings.SelectedDifficulty == 'Nightmare' then
      teleportSettings.SelectedDifficulty = 3
    end
  end
})
local Button = Tabs.Join:Button({
  Title = "Create lobby + join",
  Desc = "Click to create a lobby",
  Callback = function()
    local ohString1 = "Create"
    local ohString2 = "Story"
    local ohNumber3 = teleportSettings.SelectedWorld
    local ohNumber4 = teleportSettings.SelectedAct
    local ohNumber5 = teleportSettings.SelectedDifficulty
    local ohBoolean6 = false
    game:GetService("ReplicatedStorage").Event.JoinRoom:FireServer(ohString1, ohString2, ohNumber3, ohNumber4, ohNumber5, ohBoolean6)
    wait(1)
    local args = {
      "TeleGameplay",
      "Story",
      teleportSettings.SelectedWorld,
      teleportSettings.SelectedAct,
      teleportSettings.SelectedDifficulty,
      false
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Event"):WaitForChild("JoinRoom"):FireServer(unpack(args))
  end
})
