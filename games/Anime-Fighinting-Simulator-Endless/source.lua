---@diagnostic disable: undefined-global
-- detect service
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
  print("Mobile device")
elseif not IsOnMobile then
  print("Computer device")
end


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
local SelectedSkills = {}
getgenv().FarmMobSettings = {
  UseM1 = false
}
getgenv().AutoSellChampionsSettings = {
  Enabled = false
}
getgenv().ProtectedChampion = false
local FruitConnection
local ChikaraConnection
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local WEBHOOK_URL = ""
local Strength = game:GetService("Players").LocalPlayer.Stats["1"]
local Durability = game:GetService("Players").LocalPlayer.Stats["2"]
local Chakra = game:GetService("Players").LocalPlayer.Stats["3"]
local Sword = game:GetService("Players").LocalPlayer.Stats["4"]
local Agility = game:GetService("Players").LocalPlayer.Stats["5"]
local Speed = game:GetService("Players").LocalPlayer.Stats["6"]
function GetStats(path)
  local v = typeof(path) == "Instance" and path.Value or path
  v = math.floor(tonumber(v) or 0)
  local s = tostring(v)
  while true do
    s, k = s:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
    if k == 0 then break end
  end
  return s
end
function Teleport(path : Instance, method : number, x,y,z)
  for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v:IsA('Part') and v.Name == 'HumanoidRootPart' then
      if method == 1 then
        v:PivotTo(path:GetPivot())
      elseif method == 2 then
        v.CFrame = CFrame.new(x,y,z)
      end
    end
  end
end
function GetQuestNpc()
  local npcs = {}
  for _, v in pairs(workspace.Scriptable.NPC.Quest:GetChildren()) do
    if v:IsA('Model') then
      table.insert(npcs, v.Name)
    end
  end
  return npcs
end
function GetChampionsNpc()
  local npcs = {}
  for _, v in pairs(workspace.Scriptable.NPC.Shops.Champions:GetChildren()) do
    if v:IsA('Model') then
      table.insert(npcs, v.Name)
    end
  end
  return npcs
end
function GetPlayers()
  local players = {}
  for _, v in pairs(game.Players:GetPlayers()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
      table.insert(players, v.Name)
    end
  end
  return players
end
function GetTrainingAreas()
  local areas = {}
  for _, v in pairs(workspace.Map.TrainingAreas:GetChildren()) do
    if v:IsA('Model') then
      table.insert(areas, v.Name)
    end
  end
  return areas
end
function AutoFarmMobs(mob : string)
  local plr = game.Players.LocalPlayer
  local char = plr.Character
  if not char then return end
  for _, v in pairs(workspace.Scriptable.Mobs:GetChildren()) do
    if v:IsA("Model") and v.Name == mob and v.PrimaryPart then
      local cf = v.PrimaryPart.CFrame
      local behind = cf * CFrame.new(0, 0, 3.5)
      char:PivotTo(behind)
    end
  end
end
function GetChampions()
  local champions = {}
  for _, v in pairs(game:GetService("Players").LocalPlayer.Champions:GetChildren()) do
    for _, x in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List:GetChildren()) do
      if x:IsA('Frame') and x.Name == v.Name then
        table.insert(champions,
          x.Container.ChampionName.Text
        )
      end
    end
  end
  return champions
end
function GetPlayersOffSafeZone()
  local players = {}
  for _, v in ipairs(game.Players:GetPlayers()) do
    if v ~= game.Players.LocalPlayer then
      local character = v.Character
      if character then
        local pvpFolder = character:FindFirstChild("PVPFolder")
        if pvpFolder then
          local safezone = pvpFolder:FindFirstChild("Safezone")
          if safezone and safezone:IsA("BoolValue") and safezone.Value == false then
            table.insert(players, v.Name)
          end
        end
      end
    end
  end
  return players
end
function SendWebhook(embed)
  request({
    Url = WEBHOOK_URL,
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({
      username = "InfinityX - Logger",
      avatar_url = "https://i.imgur.com/4M34hi2.png",
      embeds = { embed }
    })
  })
end


-- esp library
local EspLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Esp%20v2/source.lua", true))()
EspLib.ESPValues.PlayersESP = false
EspLib.ESPValues.ChikaraBoxesESP = false
EspLib.ESPValues.FruitESP = false
EspLib.ESPValues.NPCsESP = false
EspLib.ESPValues.MobsESP = false
function ApplyEspToPlayers()
  for _, v in pairs(game.Players:GetPlayers()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
      EspLib.ApplyESP(v.Character, {
        Color = Color3.fromRGB(135, 52, 173),
        Text = v.Character.Name,
        ESPName = "PlayersESP",
        HighlightEnabled = true,
      })
    end
  end
end
function ApplyEspToChikara()
  for _, v in pairs(workspace.Scriptable.ChikaraBoxes:GetChildren()) do
    if v:IsA('UnionOperation') and v.Name == 'ChikaraCrate' then
      EspLib.ApplyESP(v, {
        Color = Color3.fromRGB(173, 52, 102),
        Text = v.Name,
        ESPName = "ChikaraBoxesESP",
        HighlightEnabled = true,
      })
    end
  end
end
function ApplyEspToFruit()
  for _, v in pairs(workspace.Scriptable.Fruits:GetChildren()) do
    if v:IsA('Model') then
      EspLib.ApplyESP(v, {
        Color = Color3.fromRGB(173, 52, 52),
        Text = v.Name,
        ESPName = "FruitESP",
        HighlightEnabled = true,
      })
    end
  end
end
function ApplyEspToNPCs()
  for _, v in pairs(workspace.Scriptable.NPC:GetDescendants()) do
    if v:IsA('Model') then
      EspLib.ApplyESP(v, {
        Color = Color3.fromRGB(52, 135, 173),
        Text = v.Name,
        ESPName = "NPCsESP",
        HighlightEnabled = true,
      })
    end
  end
end
function ApplyEspToMobs()
  for _, v in pairs(workspace.Scriptable.Mobs:GetDescendants()) do
    if v:IsA('Model') then
      EspLib.ApplyESP(v, {
        Color = Color3.fromRGB(52, 173, 68),
        Text = v.Name,
        ESPName = "MobsESP",
        HighlightEnabled = true,
      })
    end
  end
end


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
local Window = WindUI:CreateWindow({
  Title = "InfinityX",
  Author = "Anime Fighinting Simulator",
  Folder = "InfinityX-WindUi",
  Icon = "rbxassetid://72212320253117",
  NewElements = true,
  Size = UDim2.fromOffset(850, 560),
  Transparent = true,
  HideSearchBar = true,
})
Window:EditOpenButton({
  Title = ".gg/emKJgWMHAr",
  Icon = "rbxassetid://72212320253117",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 2,
  Color = ColorSequence.new(
    Color3.fromRGB(129, 63, 214),
    Color3.fromRGB(63, 61, 204)
  ),
  OnlyMobile = false,
  Enabled = true,
  Draggable = true,
})
Window:Tag({
  Title = "BETA 4.2a",
  Icon = "history",
  Color = Color3.fromRGB(204, 0, 204),
  Radius = 13,
})
Window:Tag({
  Title = "discord.gg/emKJgWMHAr",
  Icon = "link",
  Color = Color3.fromRGB(255, 255, 255),
  Radius = 13,
})
Window:Tag({
  Title = "by lmy77",
  Icon = "circle-user-round",
  Color = Color3.fromRGB(255, 0, 0),
  Radius = 13,
})
Window:CreateTopbarButton(
  "ChangelogButton",
  "circle-question-mark",
  function()
    local Dialog = Window:Dialog({
      Icon = "circle-question-mark",
      Title = "What's new?",
      Content = [[
<font size="24" color="#00E5FF"><b>✨ NEW UPDATE ✨</b></font>

<font size="15" color="#FFFFFF">━━━━━━━━━━━━━━━━━━━━━━</font>
<font size="20" color="#00FF88"><b>🚀 New Features</b></font>
<font size="15" color="#E0E0E0">
• <font color="#FFD166"><b>Added Auto Farm Player</b></font> – an advanced combat automation system that automatically detects players outside the safe zone, tracks their position, and efficiently eliminates them. Designed with smart target selection, smooth movement handling, and stability to maximize farming performance while minimizing detection and errors. Ideal for fast progression and competitive gameplay.  
• <font color="#7C7CFF"><b>Added Webhook System</b></font> – a powerful and advanced notification system that sends real-time updates directly to your webhook. Provides detailed information such as important events, rewards, actions, and status updates, ensuring full control and monitoring even when you are away from the game. Built for reliability, clarity, and professional-grade tracking.  
</font>
<font size="15" color="#FFFFFF">━━━━━━━━━━━━━━━━━━━━━━</font>
]],
      Buttons = {
        {
          Title = "Close",
          Callback = function()
            print("Closed!")
          end,
        },
      },
    })
  end,
  990
)


-- tabs
local AutoFarmTab = Window:Tab({
  Title = "| Auto Farm",
  Icon = "swords",
  Locked = false,
})
local EspTab = Window:Tab({
  Title = "| Visual",
  Icon = "eye",
  Locked = false,
})
local PlayerTab = Window:Tab({
  Title = "| Player",
  Icon = "circle-user-round",
  Locked = false,
})
local ShopTab = Window:Tab({
  Title = "| Shop",
  Icon = "shopping-cart",
  Locked = false,
})
local QuestTab = Window:Tab({
  Title = "| Quest",
  Icon = "clipboard-list",
  Locked = false,
})
local TeleportTab = Window:Tab({
  Title = "| Teleports",
  Icon = "map-pin",
  Locked = false,
})
local MiscTab = Window:Tab({
  Title = "| Misc",
  Icon = "layers",
  Locked = false,
})
Window:Divider()
local WebhookTab = Window:Tab({
  Title = "| Webhook",
  Icon = "webhook",
  Locked = false,
})
local ConfigTab = Window:Tab({
  Title = "| Config Usage",
  Icon = "settings",
  Locked = false,
})
AutoFarmTab:Select()


-- source
local Section = AutoFarmTab:Section({
  Title = "Farming Configuration",
})
local Paragraph = AutoFarmTab:Paragraph({
  Title = "Stats Viwer",
  Desc = "",
  Color = "Grey",
  Locked = false,
})
task.spawn(function()
  while true do task.wait()
    Paragraph:SetDesc('💪 Strength: '.. GetStats(Strength) ..'\n🛡️ Durability: '.. GetStats(Durability) ..'\n🔥 Chakra: '.. GetStats(Chakra) .. '\n⚔️ Sword: '.. GetStats(Sword) .. '\n🪽 Agility: '.. GetStats(Agility) .. '\n🏃‍♀️ Speed: '.. GetStats(Speed))
  end
end)
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select stat",
  Desc = "Select the stat you want to farm",
  Values = { "Strength", 'Durability', 'Chakra', 'Agility', 'Speed', 'Sword' },
  Value = "Strength",
  Callback = function(option)
    SelectedStat = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Start auto farm",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    AutoFarm = state

    if not AutoFarm then return end

    task.spawn(function()
      while AutoFarm do task.wait()
        if SelectedStat == 'Strength' and Strength.Value >= 100 and Strength.Value < 10000 then
          Teleport(nil, 2, -6, 71, 134)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 10000 and Strength.Value < 100000 then
          Teleport(1343, 195, -141)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 100000 and Strength.Value < 1000000 then
          Teleport(nil, 2, -1257, 65, 486)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 1000000 and Strength.Value < 10000000 then
          Teleport(nil, 2, -917, 85, 179)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 10000000 and Strength.Value < 100000000 then
          Teleport(nil, 2, -2245, 617, 533)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 100000000 and Strength.Value < 1000000000 then
          Teleport(nil, 2, -42, 65, -1248)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 1000000000 and Strength.Value < 100000000000 then
          Teleport(nil, 2,721, 149, 925)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 100000000000 and Strength.Value < 5000000000000 then
          Teleport(nil, 2, 1842, 139, 96)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 5000000000000 and Strength.Value < 250000000000000 then
          Teleport(nil, 2, 621, 662, 413)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 250000000000000 and Strength.Value < 150000000000000000 then
          Teleport(nil, 2, 4289, 163, -601)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 150000000000000000 and Strength.Value < 25000000000000000000 then
          Teleport(nil, 2, 798, 231, -1004)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value >= 25000000000000000000 and Strength.Value < 10000000000000000000000 then
          Teleport(nil, 2, 3873, 138, 873)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        elseif SelectedStat == 'Strength' and Strength.Value > 10000000000000000000000 then
          Teleport(nil, 2, 3858, 669, -1076)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)


        elseif SelectedStat == 'Durability' and Durability.Value >= 100 and Durability.Value < 10000 then
          Teleport(nil, 2, 67, 69, 878)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 10000 and Durability.Value < 100000 then
          Teleport(nil, 2, -1655, 63, -520)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 100000 and Durability.Value < 1000000 then
          Teleport(nil, 2, -93, 101, 2029)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 1000000 and Durability.Value < 10000000 then
          Teleport(nil, 2, -628, 179, 720)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 10000000 and Durability.Value < 100000000 then
          Teleport(nil, 2, -1108, 211, -962)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 100000000 and Durability.Value < 1000000000 then
          Teleport(nil, 2, -333, 72, -1650)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 1000000000 and Durability.Value < 100000000000 then
          Teleport(nil, 2, 2508, 1543, -380)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 100000000000 and Durability.Value < 5000000000000 then
          Teleport(nil, 2, -2802, -228, 355)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 5000000000000 and Durability.Value < 250000000000000 then
          Teleport(nil, 2, 2187, 517, 581)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 250000000000000 and Durability.Value < 150000000000000000 then
          Teleport(nil, 2, 1671, 423, -1293)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 150000000000000000 and Durability.Value < 25000000000000000000 then
          Teleport(nil, 2, 155, 772, -699)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value >= 25000000000000000000 and Durability.Value < 10000000000000000000000 then
          Teleport(nil, 2, 2565, 267, 1851)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)
        elseif SelectedStat == 'Durability' and Durability.Value > 10000000000000000000000 then
          Teleport(nil, 2, 1673, 2305, -78)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 2)


        elseif SelectedStat == 'Chakra' and Chakra.Value >= 100 and Chakra.Value < 10000 then
          Teleport(nil, 2, 4, 64, -124)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 10000 and Chakra.Value < 100000 then
          Teleport(nil, 2, 1424, 146, -581)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 100000 and Chakra.Value < 1000000 then
          Teleport(nil, 2, 914, 140, 794)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 1000000 and Chakra.Value < 10000000 then
          Teleport(nil, 2, 1551, 387, 685)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 10000000 and Chakra.Value < 100000000 then
          Teleport(nil, 2, 346, -149, -1844)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 100000000 and Chakra.Value < 1000000000 then
          Teleport(nil, 2, 1022, 249, -618)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 1000000000 and Chakra.Value < 100000000000 then
          Teleport(nil, 2, 3054, 110, 1105)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 100000000000 and Chakra.Value < 5000000000000 then
          Teleport(nil, 2, 1710, 577, 1743)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 5000000000000 and Chakra.Value < 250000000000000 then
          Teleport(nil, 2, -16, 61, -475)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 250000000000000 and Chakra.Value < 25000000000000000 then
          Teleport(nil, 2, -411, 1255, 663)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 25000000000000000 and Chakra.Value < 150000000000000000 then
          Teleport(nil, 2, -411, 1255, 663) -- find
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 150000000000000000 and Chakra.Value < 25000000000000000000 then
          Teleport(nil, 2, -732, 2791, 628)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 25000000000000000000 and Chakra.Value < 10000000000000000000000 then
          Teleport(nil, 2, 3242, -441, -233)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)
        elseif SelectedStat == 'Chakra' and Chakra.Value >= 10000000000000000000000 then
          Teleport(nil, 2, 341, 237, 1867)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 3)


        elseif SelectedStat == 'Agility' and Agility.Value >= 100 and Agility.Value < 10000 then
          Teleport(nil, 2, 37, 69, 459)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 5)
        elseif SelectedStat == 'Agility' and Agility.Value >= 10000 and Agility.Value < 100000 then
          Teleport(nil, 2, -424, 122, -81)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 5)
        elseif SelectedStat == 'Agility' and Agility.Value >= 100000 and Agility.Value < 5000000 then
          Teleport(nil, 2, 3479, 60, 143)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 5)
        elseif SelectedStat == 'Agility' and Agility.Value >= 5000000 then
          Teleport(nil, 2, 4111, 69, 879)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 5)


        elseif SelectedStat == 'Speed' and Speed.Value >= 100 and Speed.Value < 10000 then
          Teleport(nil, 2, -102, 62, -496)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 6)
        elseif SelectedStat == 'Speed' and Speed.Value >= 10000 and Speed.Value < 100000 then
          Teleport(nil, 2, -424, 122, -81)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 6)
        elseif SelectedStat == 'Speed' and Speed.Value >= 100000 and Speed.Value < 5000000 then
          Teleport(nil, 2, 3479, 60, 143)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 6)
        elseif SelectedStat == 'Speed' and Speed.Value >= 5000000 then
          Teleport(nil, 2, 4111, 69, 879)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 6)


        elseif SelectedStat == 'Sword' then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 4)
        end
      end
    end)
  end
})
local Section = AutoFarmTab:Section({
  Title = "Player Farming",
})
local PlayersFarmDropdown = AutoFarmTab:Dropdown({
  Title = "Select player",
  Desc = "Select the player you want to farm, the script collect all player off the safe zone",
  Values = GetPlayersOffSafeZone(),
  Value = "",
  Callback = function(option)
    SelectedPlayerToFarm = option
  end
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select skills",
  Desc = "Select the skills you want to use to kill selected player",
  Values = { "Z","X","C","E","R","T","Y","U","F","G","H","J","K","L","V","B","N","M" },
  Value = {"Z","X","C"},
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedSkillsToPF = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Start auto player farm",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    AutoFarmPlayer = state
    if not AutoFarmPlayer then return end

    task.spawn(function()
      while AutoFarmPlayer do task.wait()
        game.Players.LocalPlayer.Character:PivotTo(game.Players[SelectedPlayerToFarm].Character:GetPivot())
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        for _, skill in ipairs(SelectedSkills) do
          local key = Enum.KeyCode[skill]
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("UsePower", skill)
          if key then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("UseSpecialPower", key)
          end
        end
      end
    end)
  end
})
local Button = AutoFarmTab:Button({
  Title = "Viwer player power",
  Locked = false,
  Callback = function()
    local stats1 = game.Players[SelectedPlayerToFarm].Stats['1'].Value
    local stats2 = game.Players[SelectedPlayerToFarm].Stats['2'].Value
    local stats3 = game.Players[SelectedPlayerToFarm].Stats['3'].Value
    local stats4 = game.Players[SelectedPlayerToFarm].Stats['4'].Value
    local total = stats1 + stats2 + stats3 + stats4
    WindUI:Notify({
      Title = "Notification",
      Content = "The total power of ".. SelectedPlayerToFarm .. ' is: ' ..GetStats(total),
      Duration = 5,
      Icon = "bell-ring",
    })
  end
})
local Button = AutoFarmTab:Button({
  Title = "Refresh dropdown",
  Locked = false,
  Callback = function()
    PlayersFarmDropdown:Refresh(GetPlayersOffSafeZone())
  end
})
local Section = AutoFarmTab:Section({
  Title = "Mob Farming",
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select mob",
  Desc = "Select the mob you want to farm",
  Values = { "Sarka", "Gen", "Igicho", "Remgonuk", "Booh", "Saytamu", "Riru" },
  Value = "Sarka",
  Callback = function(option)
    SelectedMob = option
  end
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select skills",
  Desc = "Select the skills you want to use",
  Values = { "Z","X","C","E","R","T","Y","U","F","G","H","J","K","L","V","B","N","M" },
  Value = {"Z","X","C"},
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedSkills = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Use m1",
  Desc = "Enable this toggle so that Auto Farm uses M1 attacks when farming mobs",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    getgenv().FarmMobSettings.UseM1 = state
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Start auto mob farm",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    AutoFarmMob = state
    if not AutoFarmMob then return end

    task.spawn(function() task.wait()
      while AutoFarmMob do
        local MobSelected = nil
        if SelectedMob == "Sarka" then
          MobSelected = '1'
        elseif SelectedMob == "Gen" then
          MobSelected = '2'
        elseif SelectedMob == "Igicho" then
          MobSelected = '3'
        elseif SelectedMob == "Remgonuk" then
          MobSelected = '4'
        elseif SelectedMob == "Booh" then
          MobSelected = '5'
        elseif SelectedMob == "Saytamu" then
          MobSelected = 6
        elseif SelectedMob == "Riru" then
          MobSelected = '1001'
        end
        AutoFarmMobs(MobSelected)
        for _, skill in ipairs(SelectedSkills) do
          local key = Enum.KeyCode[skill]
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("UsePower", skill)
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("UseSpecialPower", key)
        end
        if getgenv().FarmMobSettings.UseM1 then
          game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer('Train', 1)
        end
      end
    end)
  end
})
local Section = AutoFarmTab:Section({
  Title = "Auto Summon Champion",
})
local ChampionsDropdown = AutoFarmTab:Dropdown({
  Title = "Select champion",
  Desc = "Select the champion you want to auto summon",
  Values = GetChampions(),
  Value = "",
  Callback = function(option)
    SelectedAutoSummonChampion = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto summon selected champion",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    AutoSummmonChampion = state

    if not AutoSummmonChampion then return end

    task.spawn(function()
      while AutoSummmonChampion do task.wait()
        local findChampion = game.Players.LocalPlayer.Character:FindFirstChild('ChampWeld')
        for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List:GetDescendants()) do
          if v:IsA('TextLabel') and v.Name == 'ChampionName' and v.Text == SelectedAutoSummonChampion then
            local champion = v.Parent.Parent.Name
            for _, x in pairs(game:GetService("Players").LocalPlayer.Champions:GetChildren()) do
              if x.Name == champion then
                if not findChampion then
                  local args = {
                    "SummonChamp",
                    x
                  }
                  game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
                end
              end
            end
          end
        end
      end
    end)
  end
})
local Button = AutoFarmTab:Button({
  Title = "Refresh dropdown",
  Locked = false,
  Callback = function()
    ChampionsDropdown:Refresh(GetChampions())
  end
})
local Section = AutoFarmTab:Section({ 
  Title = "Chikara / Fruit Farming",
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto collect chikara box",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    ChikaraBox = state

    if not ChikaraBox then return end

    task.spawn(function()
      while ChikaraBox do task.wait()
        for _, v in pairs(workspace.Scriptable.ChikaraBoxes:GetDescendants()) do
          if v:IsA('Part') and v.Name == 'ClickBox' then
            fireclickdetector(v.ClickDetector)
            wait(2)
          end
        end
      end
    end)
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto collect fruit",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    Fruit = state

    if not Fruit then return end

    task.spawn(function()
      while Fruit do task.wait()
        for _, v in pairs(workspace.Scriptable.Fruits:GetDescendants()) do
          if v:IsA('ClickDetector') and v.Name == 'ClickDetector' then
            fireclickdetector(v)
            wait(2)
          end
        end
      end
    end)
  end
})


local Section = EspTab:Section({ 
  Title = "Esp Options",
})
local Toggle = EspTab:Toggle({
  Title = "Esp players",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.PlayersESP = state

    task.spawn(function()
      if EspLib.ESPValues.PlayersESP then
        ApplyEspToPlayers()
      end
      game.Players.PlayerAdded:Connect(function(player)
        if EspLib.ESPValues.PlayersESP and player ~= LocalPlayer then
          ApplyEspToPlayers()
        end
      end)
    end)
  end
})
local Toggle = EspTab:Toggle({
  Title = "Esp chikara boxes",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.ChikaraBoxesESP = state

    task.spawn(function()
      if EspLib.ESPValues.ChikaraBoxesESP then
        ApplyEspToChikara()
      end
      workspace.Scriptable.ChikaraBoxes.ChildAdded:Connect(function(chikara)
        if EspLib.ESPValues.ChikaraBoxesESP and chikara:IsA('UnionOperation') then
          ApplyEspToChikara()
        end
      end)
    end)
  end
})
local Toggle = EspTab:Toggle({
  Title = "Esp all fruits",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.FruitESP= state

    task.spawn(function()
      if EspLib.ESPValues.FruitESP then
        ApplyEspToFruit()
      end
      workspace.Scriptable.Fruits.ChildAdded:Connect(function(fruit)
        if EspLib.ESPValues.FruitESP and fruit:IsA('Model') then
          ApplyEspToFruit()
        end
      end)
    end)
  end
})
local Toggle = EspTab:Toggle({
  Title = "Esp all npcs",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.NPCsESP = state

    task.spawn(function()
      if EspLib.ESPValues.NPCsESP then
        ApplyEspToNPCs()
      end
      workspace.Scriptable.NPC.DescendantAdded:Connect(function(npcs)
        if EspLib.ESPValues.NPCsESP and npcs:IsA('Model') then
          ApplyEspToNPCs()
        end
      end)
    end)
  end
})
local Toggle = EspTab:Toggle({
  Title = "Esp all mobs",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.MobsESP = state

    task.spawn(function()
      if EspLib.ESPValues.MobsESP then
        ApplyEspToMobs()
      end
      workspace.Scriptable.Mobs.ChildAdded:Connect(function(mobs)
        if EspLib.ESPValues.MobsESP and mobs:IsA('Model') then
          ApplyEspToMobs()
        end
      end)
    end)
  end
})
local Section = EspTab:Section({ 
  Title = "Notify Options",
})
local Toggle = EspTab:Toggle({
  Title = "Notify chikara box",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    ChikaraNotify = state

    task.spawn(function()
      if ChikaraNotify then
        local count = 0
        for _, v in pairs(workspace.Scriptable.ChikaraBoxes:GetChildren()) do
          if v:IsA("UnionOperation") and v.Name == "ChikaraCrate" then
            count += 1
          end
        end
        if count > 0 then
          WindUI:Notify({
            Title = "Chikara Notification",
            Content = "There are already chikara boxes on the map, quantity: "..count,
            Duration = 3,
            Icon = "bell-ring",
          })
        end
        workspace.Scriptable.ChikaraBoxes.ChildAdded:Connect(function(chikara)
          if ChikaraNotify and chikara:IsA('UnionOperation') then
            WindUI:Notify({
              Title = "Chikara Notification",
              Content = "A box of chikara has just spawned",
              Duration = 6,
              Icon = "bell-ring",
            })
          end
        end)
      end
    end)
  end
})
local Toggle = EspTab:Toggle({
  Title = "Notify fruit",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    FruitNotify = state

    task.spawn(function()
      if FruitNotify then
        for i, v in pairs(workspace.Scriptable.Fruits:GetChildren()) do
          if v:IsA('Model') then
            WindUI:Notify({
              Title = "Fruit Notification",
              Content = "There are already fruit on the map, name: "..v.Name,
              Duration = 3,
              Icon = "bell-ring",
            })
          end
        end
        workspace.Scriptable.Fruits.ChildAdded:Connect(function(fruit)
          if FruitNotify and fruit:IsA('Model') then
            WindUI:Notify({
              Title = "Fruit Notification",
              Content = "A fruit has just spawned, name: "..v.Name,
              Duration = 6,
              Icon = "bell-ring",
            })
          end
        end)
      end
    end)
  end
})
local Button = EspTab:Button({
  Title = "Fast teleport to fruit",
  Locked = false,
  Callback = function()
    for _, v in pairs(workspace.Scriptable.Fruits:GetChildren()) do
      if v:IsA('Model') then
        Teleport(v, 1, nil,nil,nil)
        return
      end
    end
  end
})


local Section = PlayerTab:Section({ 
  Title = "Player Configuration",
})
local Slider = PlayerTab:Slider({
  Title = "WalkSpeed",
  Desc = "Manage player movement speed settings",
  Step = 1,
  Value = {
    Min = 16,
    Max = 500,
    Default = 16,
  },
  Callback = function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
  end
})
local Slider = PlayerTab:Slider({
  Title = "JumpPower",
  Desc = "Manage player movement jump settings",
  Step = 1,
  Value = {
    Min = 50,
    Max = 500,
    Default = 50,
  },
  Callback = function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
  end
})
local Toggle = PlayerTab:Toggle({
  Title = "Noclip",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    Noclip = state
    if Noclip then
      for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
          task.spawn(function() while Noclip do task.wait() v.CanCollide = false end end)
        end
      end
    else
      for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == false then
          v.CanCollide = true
        end
      end
    end
  end
})
local Button = PlayerTab:Button({
  Title = "Respawn player",
  Callback = function(option)
    game.Players.LocalPlayer.Character.Humanoid.Health = 0
  end
})


local Section = ShopTab:Section({ 
  Title = "Chest Open Options",
})
local Dropdown = ShopTab:Dropdown({
  Title = "Select chest",
  Desc = "",
  Values = {'Christmas', 'Gold', 'Dark', 'Eletric', 'Sayan', 'Burning', 'Easter'},
  Value = "Christmas",
  Callback = function(option)
    SelectedChest = option
  end
})
local Button = ShopTab:Button({
  Title = "Open selected chest",
  Locked = false,
  Callback = function()
    local args = {
      "BuyBox",
      SelectedChest
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
  end
})
local Toggle = ShopTab:Toggle({
  Title = "Auto open selected chest",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state) 
    AutoChest = state

    if not AutoChest then return end

    task.spawn(function()
      while AutoChest do
        local args = {
          "BuyBox",
          SelectedChest
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer(unpack(args))
        task.wait(.5)
      end
    end)
  end
})
local Section = ShopTab:Section({ 
  Title = "Champions Options",
})
local Dropdown = ShopTab:Dropdown({
  Title = "Select gacha",
  Desc = "Select the gacha you want to roll",
  Values = {'1 - 5k Chikara', '2 - 15k Chikara'},
  Value = "",
  Callback = function(option)
    SelectedGacha = option
  end
})
local Dropdown = ShopTab:Dropdown({
  Title = "Select Champions",
  Desc = "Select the champions you want to get",
  Values = { "Sunji", "Levee", "Keela", "Sarka", "Pilcol", "Toju", "Canakey", "Loofi", "Asto", "Junwon", "Tojaro", "Juyari", "Narnto", "Boras", "Igicho", "Remgonuk", "Bright Yagami", "Saytamu Serious", "Giovanni", "Booh", "Gen", "Shunro", "Kroll", "Eskano", "Mallyodas", "Saytamu" },
  Value = {""},
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedChampionsToRoll = option
  end
})
ShopTab:Toggle({
	Title = "Auto sell unlocked champions",
	Icon = "check",
	Type = "Checkbox",
	Value = false,
	Callback = function(state)
		AutoSellChampions = state
		if not state then return end

		task.spawn(function()
			while AutoSellChampions do task.wait(1)
				if getgenv().ProtectedChampion then continue end

				for _,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List:GetDescendants()) do
					if v:IsA("TextLabel") and v.Name == "ChampionName" then
						for _,n in ipairs(SelectedChampionsToRoll) do
							if v.Text == n then
								getgenv().ProtectedChampion = true
								break
							end
						end
					end
				end

				if not getgenv().ProtectedChampion then
					for _,c in ipairs(game:GetService("Players").LocalPlayer.Champions:GetChildren()) do
						if c.Value ~= 1 then
							game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteEvent"):FireServer("SellChamp", c)
						end
					end
				end
			end
		end)
	end
})
ShopTab:Toggle({
	Title = "Auto roll champions",
	Icon = "check",
	Type = "Checkbox",
	Value = false,
	Callback = function(state)
		getgenv().AutoSellChampionsSettings.Enabled = state
		if not state then return end

		task.spawn(function()
			local GachaSelected = nil
			if SelectedGacha == '1 - 5k Chikara' then
				GachaSelected = '1'
			elseif SelectedGacha == '2 - 15k Chikara' then
				GachaSelected = '2'
			end

			while getgenv().AutoSellChampionsSettings.Enabled do task.wait(1)
				for _,v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List:GetDescendants()) do
					if v:IsA("TextLabel") and v.Name == "ChampionName" then
						for _,n in ipairs(SelectedChampionsToRoll) do
							if v.Text == n then
								getgenv().ProtectedChampion = true
								WindUI:Notify({
									Title = "Champion Notification",
									Content = "You've acquired a selected champion: "..v.Text,
									Duration = 3,
									Icon = "bell-ring",
								})
								return
							end
						end
					end
				end

				game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("BuyContainerChamp", GachaSelected)
			end
		end)
	end
})


task.spawn(function()
	local Players = game:GetService("Players")
	local Quests = Players.LocalPlayer.Quests

	local Paragraphs = {}
	local Buttons = {}

	local function CleanName(name)
		return name:match("^[^%d]+"):gsub("%s+$", "")
	end

	local function FindNPC(questName)
		local target = CleanName(questName):lower()
		for _, obj in ipairs(workspace.Scriptable.NPC:GetDescendants()) do
			if obj:IsA("Model") and obj.Name:lower():find(target, 1, true) then
				return obj
			end
		end
	end

	local function UpdateParagraph(quest, Paragraph)
		if not Paragraph then return end

		Paragraph:SetTitle('<font size="22">📜 Quest Viewer - '..quest.Name..'</font>')

		local text = '<font size="18">'
		for i, prog in ipairs(quest.Progress:GetChildren()) do
			local req = quest.Requirements:GetChildren()[i]
			if req then
				text ..=
					'🔹 <b>Objective '..i..'</b>\n'..
					'📈 Progress: <font color="#4CAF50">'..GetStats(prog.Value)..
					'</font> / <font color="#FF9800">'..GetStats(req.Value)..
					'</font>\n\n'
			end
		end

		text ..=
			(quest.Completed.Value
				and '✅ <font color="#00FF7F"><b>Quest Completed</b></font>'
				or '⏳ <font color="#FF5555"><b>Quest in Progress</b></font>')
			..'</font>'

		Paragraph:SetDesc(text)
	end

	local function DestroyQuestUI(quest)
		if Buttons[quest] then
			pcall(function() Buttons[quest]:Destroy() end)
			Buttons[quest] = nil
		end

		if Paragraphs[quest] then
			pcall(function() Paragraphs[quest]:Destroy() end)
			Paragraphs[quest] = nil
		end
	end

	local function CreateParagraph(quest)
		if Paragraphs[quest] then return end

		local Paragraph = QuestTab:Paragraph({
			Title = "",
			Desc = "",
			Color = "Grey",
			Locked = false,
		})

		local TeleportButton = QuestTab:Button({
			Title = "Teleport to NPC",
			Desc = "🔒 Complete the quest to unlock",
			Locked = true,
			Callback = function()
				local npc = FindNPC(quest.Name)
				if npc then
					Players.LocalPlayer.Character:PivotTo(npc:GetPivot() * CFrame.new(0, 0, -3))
				end
			end
		})

		QuestTab:Divider()

		Paragraphs[quest] = Paragraph
		Buttons[quest] = TeleportButton

		task.spawn(function()
			local unlocked = false
			while quest.Parent == Quests and Paragraphs[quest] do
				UpdateParagraph(quest, Paragraph)

				if quest.Completed.Value and not unlocked then
					unlocked = true
					TeleportButton:Unlock()
					TeleportButton:SetDesc("🚀 Click to teleport to the quest NPC")
				end

				task.wait(0.2)
			end
		end)
	end

	for _, quest in ipairs(Quests:GetChildren()) do
		CreateParagraph(quest)
	end

	Quests.ChildAdded:Connect(CreateParagraph)
	Quests.ChildRemoved:Connect(DestroyQuestUI)
end)


local Section = TeleportTab:Section({ 
  Title = "NPC Teleport Options",
})
local Dropdown = TeleportTab:Dropdown({
  Title = "Select NPC [ QUEST ]",
  Desc = "",
  Values = GetQuestNpc(),
  Value = "Boom",
  Callback = function(option)
    SelectedQNPC = option
  end
})
local Button = TeleportTab:Button({
  Title = "Teleport selected NPC [ QUEST ]",
  Locked = false,
  Callback = function()
    for _, v in pairs(workspace.Scriptable.NPC.Quest:GetChildren()) do
      if v:IsA('Model') and v.Name == SelectedQNPC then
        Teleport(v, 1, nil,nil,nil)
      end
    end
  end
})
local Dropdown = TeleportTab:Dropdown({
  Title = "Select NPC [ CHAMPIONS ]",
  Desc = "",
  Values = GetChampionsNpc(),
  Value = "1",
  Callback = function(option)
    SelectedCNPC = option
  end
})
local Button = TeleportTab:Button({
  Title = "Teleport selected NPC [ CHAMPIONS ]",
  Locked = false,
  Callback = function()
    for _, v in pairs(workspace.Scriptable.NPC.Shops.Champions:GetChildren()) do
      if v:IsA('Model') and v.Name == SelectedCNPC then
        Teleport(v, 1, nil,nil,nil)
      end
    end
  end
})
local Dropdown = TeleportTab:Dropdown({
  Title = "Select NPC [ SPECIAL ]",
  Desc = "",
  Values = {'Grimoires', 'Kagunes', 'Quirks', 'Stands'},
  Value = "Grimoires",
  AllowNone = true,
  Callback = function(option)
    SelectedSNPC = option
  end
})
local Button = TeleportTab:Button({
  Title = "Teleport selected NPC [ SPECIAL ]",
  Locked = false,
  Callback = function()
    if SelectedSNPC == 'Grimoires' then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Grimoires["1"], 1, nil,nil,nil)
    elseif SelectedSNPC == 'Kagunes' then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Kagunes["1"], 1, nil,nil,nil)
    elseif SelectedSNPC == 'Quirks' then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Quirks["1"], 1, nil,nil,nil)
    elseif SelectedSNPC == 'Stands' then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Stands["1"], 1, nil,nil,nil)
    end
  end
})
local Section = TeleportTab:Section({ 
  Title = "Training Area Teleport",
})
local TrainingAreaDropdown = TeleportTab:Dropdown({
  Title = "Select area",
  Desc = "",
  Values = GetTrainingAreas(),
  Value = "Tree1",
  AllowNone = true,
  Callback = function(option)
    SelectedArea = option
  end
})
local Button = TeleportTab:Button({
  Title = "Teleport selected area",
  Locked = false,
  Callback = function()
    game.Players.LocalPlayer.Character:PivotTo(workspace.Map.TrainingAreas[SelectedArea]:GetPivot())
  end
})
local Button = TeleportTab:Button({
  Title = "Refresh dropdown",
  Locked = false,
  Callback = function()
    TrainingAreaDropdown:Refresh(GetTrainingAreas())
  end
})
local Section = TeleportTab:Section({ 
  Title = "Player Teleport Options",
})
local PlayersDropdown = TeleportTab:Dropdown({
  Title = "Select player",
  Desc = "",
  Values = GetPlayers(),
  Value = "",
  AllowNone = true,
  Callback = function(option)
    SelectedPlayer = option
  end
})
local Toggle = TeleportTab:Toggle({
  Title = "Spectate player",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    Spactate = state

    task.spawn(function()
      if Spactate then
        local Players = game:GetService("Players")
        local Camera = workspace.CurrentCamera
        local playerToSpec = SelectedPlayer
        local target = Players:FindFirstChild(playerToSpec)
        if target and target.Character and target.Character:FindFirstChild("Humanoid") then
          Camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
        end
      else
        local Players = game:GetService("Players")
        local Camera = workspace.CurrentCamera
        local localPlayer = Players.LocalPlayer
        if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
          Camera.CameraSubject = localPlayer.Character:FindFirstChild("Humanoid")
        end
      end
    end)
  end
})
local Button = TeleportTab:Button({
  Title = "Teleport player",
  Locked = false,
  Callback = function()
    game.Players.LocalPlayer.Character:PivotTo(game.Players[SelectedPlayer].Character:GetPivot())
  end
})
local Button = TeleportTab:Button({
  Title = "Refresh dropdown",
  Locked = false,
  Callback = function()
    PlayersDropdown:Refresh(GetPlayers())
  end
})


local Section = MiscTab:Section({ 
  Title = "Misc Options",
})
local Button = MiscTab:Button({
  Title = "Reedem all codes",
  Locked = false,
  Callback = function()
    local codes = {
      'SecretCode',
      'Krampus',
      '10kLikes',
      'ChristmasDelay',
      '1MVisits',
      'ChristmasTime',
      'Gullible67',
      '100kVisits',
      '5kLikes',
      '2kLikes',
      '1kLikes',
      '10kVisits',
      '1WeekAnniversary',
      'MobsUpdate',
      '1000Members',
      '400CCU',
      'FreeChikara3',
      'FreeChikara2',
      'FreeChikara',
      'YenCode',
      '100CCU',
      '100Favs',
      '',

    }
    for _, v in pairs(codes) do
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer(
        "Code",
        v
      ) wait(.5)
    end
  end
})
local Button = MiscTab:Button({
  Title = "Rejoin server",
  Locked = false,
  Callback = function()
    game:GetService("TeleportService"):Teleport(
      game.PlaceId,
      game:GetService("Players").LocalPlayer
    )
  end
})
local Button = MiscTab:Button({
  Title = "Server Hop",
  Locked = false,
  Callback = function()
    for _, v in pairs(game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/".. game.PlaceId .."/servers/Public?sortOrder=Asc&limit=100")).data) do
      if v.playing < v.maxPlayers and v.id ~= game.JobId then
        game:GetService("TeleportService"):TeleportToPlaceInstance(
          game.PlaceId,
          v.id,
          game:GetService("Players").LocalPlayer
        )
        break
      end
    end
  end
})
local Button = MiscTab:Button({
  Title = "Rejoin smallest server",
  Locked = false,
  Callback = function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")
    local PlaceId = game.PlaceId
    local JobId = game.JobId
    local function GetServer()
      local servers = {}
      local req = request({
        Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PlaceId)
      })
      local data = HttpService:JSONDecode(req.Body)
      for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= JobId then
          table.insert(servers, v.id)
        end
      end
      if #servers > 0 then
        return servers[math.random(1, #servers)]
      end
    end
    local serverId = GetServer()
    if serverId then
      TeleportService:TeleportToPlaceInstance(PlaceId, serverId, Players.LocalPlayer)
    end
  end
})
local Toggle = MiscTab:Toggle({
  Title = "Unlock FPS",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    fps = state
    function UnlockFPS()
      local RefreshRate = 60
      if game:GetService("UserInputService").TouchEnabled then
          RefreshRate = 120
      elseif game:GetService("UserInputService").KeyboardEnabled then
          RefreshRate = 240
      end
      setfpscap(RefreshRate * 2)
    end
    while fps do task.wait(.2)
      UnlockFPS()
    end
  end
})
local Toggle = MiscTab:Toggle({
  Title = "Anti Afk",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    AntiAfk = state

    if not AntiAfk then return end

    task.spawn(function()
      if AntiAfk then
        for _,v in pairs(getconnections(game:GetService("Players").LocalPlayer.Idled)) do
          v:Disable()
        end
        game:GetService("RunService").Heartbeat:Connect(function()
          game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
          game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        end)
      end
    end)
  end
})
local Section = MiscTab:Section({ 
  Title = "Server Information",
})
task.spawn(function()
	local Players = game:GetService("Players")
	local TeleportService = game:GetService("TeleportService")
	local LocalPlayer = Players.LocalPlayer

	local Paragraph = MiscTab:Paragraph({
		Title = '<font size="22">🖥️ Server Information</font>',
		Desc = "",
		Color = "Grey",
		Locked = false,
	})

	local function GetFriendsInServer()
		local count = 0
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= LocalPlayer and LocalPlayer:IsFriendsWith(plr.UserId) then
				count += 1
			end
		end
		return count
	end

	task.spawn(function()
		while true do
			local players = Players:GetPlayers()
			local maxPlayers = Players.MaxPlayers
			local ping = math.floor(LocalPlayer:GetNetworkPing() * 1000)

			local text =
				'<font size="18">'
				..'🆔 <b>Job ID:</b> <font color="#4CAF50">'..game.JobId..'</font>\n\n'
				..'🌍 <b>Place ID:</b> <font color="#4CAF50">'..game.PlaceId..'</font>\n\n'
				..'👥 <b>Players:</b> <font color="#4CAF50">'..#players..'</font> / <font color="#FF9800">'..maxPlayers..'</font>\n\n'
				..'🤝 <b>Friends in Server:</b> <font color="#4CAF50">'..GetFriendsInServer()..'</font>\n\n'
				..'📡 <b>Ping:</b> <font color="#4CAF50">'..ping..' ms</font>\n\n'
				..'⏱️ <b>Server Time:</b> <font color="#4CAF50">'..os.date("%X")..'</font>\n\n'
				..'🛡️ <b>Membership:</b> <font color="#4CAF50">'..tostring(LocalPlayer.MembershipType)..'</font>'
				..'</font>'

			Paragraph:SetDesc(text)
			task.wait(1)
		end
	end)
end)
local Button = MiscTab:Button({
  Title = "Copy JobId",
  Locked = false,
  Callback = function()
    setclipboard(tostring(game.JobId))
  end
})
local Button = MiscTab:Button({
  Title = "Copy PlaceId",
  Locked = false,
  Callback = function()
    setclipboard(tostring(game.PlaceId))
  end
})
local Input = MiscTab:Input({
  Title = "Enter JobId",
  Value = "",
  Type = "Input",
  Placeholder = "fc4e02ec-5f16-4392-9a10-0a54390djkasnbc124",
  Callback = function(input)
    SelectedJobId = tostring(input)
  end
})
local Button = MiscTab:Button({
  Title = "Join Jobid",
  Locked = false,
  Callback = function()
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, SelectedJobId)
  end
})


local Section = WebhookTab:Section({
  Title = "Webhook Configuration",
})
local Paragraph = WebhookTab:Paragraph({
  Title = "How to use",
  Desc = "Copy the URL of your webhook on your Discord server and paste it into the input field, then select the options you want to send there. Remember that this function only notifies your server if something has been generated. If you want it to be collected, make sure you activate automatic collection in the options on the “Auto Farm” tab to avoid any confusion.",
  Color = "Grey",
  Locked = false,
})
local Dropdown = WebhookTab:Dropdown({
  Title = "Send a message if",
  Desc = "Select the method you want to send the message via the webhook",
  Values = {'A fruit spawned', 'A chikara boxes spawned'},
  Value = "",
  AllowNone = true,
  Callback = function(option)
    SelectedMethodToNotify = option
  end
})
local Input = WebhookTab:Input({
  Title = "Webhook url",
  Desc = "Copy the url of your webhook and add it to this input",
  Value = "",
  Type = "Input",
  Placeholder = "Enter discord webhook",
  Callback = function(input) 
    WEBHOOK_URL = tostring(input)
  end
})
local Toggle = WebhookTab:Toggle({
  Title = "Enable webhook report",
  Icon = "check",
  Type = "Checkbox",
  Value = false,
  Callback = function(state)
    Webhook = state

    if not Webhook then
      if FruitConnection then FruitConnection:Disconnect() FruitConnection = nil end
      if ChikaraConnection then ChikaraConnection:Disconnect() ChikaraConnection = nil end
      return
    end

    task.spawn(function()
      if SelectedMethodToNotify == 'A fruit spawned' then
        if FruitConnection then FruitConnection:Disconnect() end

        local AutoCollectFruit = Fruit
        SendWebhook({
          title = "🍍 Auto Collect Fruit Stats",
          color = AutoCollectFruit and 0x2ECC71 or 0xE74C3C,
          fields = {
            { name = "Status", value = tostring(AutoCollectFruit), inline = true },
            { name = "Player", value = LocalPlayer.Name, inline = true },
            { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
            { name = "JobId", value = game.JobId, inline = false }
          },
          footer = { text = "InfinityX • Auto Collect System" },
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })

        FruitConnection = workspace.Scriptable.Fruits.ChildAdded:Connect(function(model)
          if not Webhook then return end
          if not model:IsA("Model") then return end

          local pos = model:GetPivot().Position
          SendWebhook({
            title = "🍎 Fruit Detected",
            color = 0xF1C40F,
            fields = {
              { name = "Fruit Name", value = model.Name, inline = true },
              { name = "Position (Vector3)", value = tostring(pos), inline = false },
              { name = "X", value = tostring(math.floor(pos.X)), inline = true },
              { name = "Y", value = tostring(math.floor(pos.Y)), inline = true },
              { name = "Z", value = tostring(math.floor(pos.Z)), inline = true },
              { name = "Server JobId", value = game.JobId, inline = false },
              { name = "Detected By", value = LocalPlayer.Name, inline = true }
            },
            footer = { text = "Wave • Fruit Tracker" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
          })
        end)

      elseif SelectedMethodToNotify == 'A chikara boxes spawned' then
        if ChikaraConnection then ChikaraConnection:Disconnect() end

        local AutoChikaraBox = ChikaraBox
        SendWebhook({
          title = "💎 Auto Collect Chikara Box Stats",
          color = AutoChikaraBox and 0x9B59B6 or 0xE74C3C,
          fields = {
            { name = "Status", value = tostring(AutoChikaraBox), inline = true },
            { name = "Crystal", value = "Purple Chikara Box", inline = true },
            { name = "Player", value = LocalPlayer.Name, inline = true },
            { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
            { name = "JobId", value = game.JobId, inline = false }
          },
          footer = { text = "Wave • Chikara Box System" },
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })

        ChikaraConnection = workspace.Scriptable.ChikaraBoxes.ChildAdded:Connect(function(obj)
          if not Webhook then return end
          if not obj:IsA("UnionOperation") then return end

          local pos = obj.Position
          SendWebhook({
            title = "🔮 Chikara Box Spawned",
            color = 0x8E44AD,
            fields = {
              { name = "Name", value = obj.Name, inline = true },
              { name = "Type", value = "Chikara Crystal (Purple)", inline = true },
              { name = "Position", value = tostring(pos), inline = false },
              { name = "X", value = tostring(math.floor(pos.X)), inline = true },
              { name = "Y", value = tostring(math.floor(pos.Y)), inline = true },
              { name = "Z", value = tostring(math.floor(pos.Z)), inline = true },
              { name = "Detected By", value = LocalPlayer.Name, inline = true },
              { name = "Server JobId", value = game.JobId, inline = false }
            },
            footer = { text = "InfinityX • Chikara Box Tracker" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
          })
        end)
      end
    end)
  end
})


local Section = ConfigTab:Section({ 
  Title = "Save Configuration [ BETA ]",
})
local ConfigManager = Window.ConfigManager
local ConfigName = "default"
local ConfigNameInput = ConfigTab:Input({
  Title = "Config Name",
  Icon = "file-cog",
  Callback = function(value)
    ConfigName = value
  end
})
ConfigTab:Space()
local AutoLoadToggle = ConfigTab:Toggle({
  Title = "Enable Auto Load to Selected Config",
  Value = false,
  Callback = function(v)
    Window.CurrentConfig:SetAutoLoad(v)
  end
})
ConfigTab:Space()
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil
local AllConfigsDropdown = ConfigTab:Dropdown({
  Title = "All Configs",
  Desc = "Select existing configs",
  Values = AllConfigs,
  Value = DefaultValue,
  Callback = function(value)
    ConfigName = value
    ConfigNameInput:Set(value)
    AutoLoadToggle:Set(ConfigManager:GetConfig(ConfigName).AutoLoad or false)
  end
})
ConfigTab:Space()
ConfigTab:Button({
  Title = "Save Config",
  Icon = "",
  Justify = "Center",
  Callback = function()
    Window.CurrentConfig = ConfigManager:Config(ConfigName)
    if Window.CurrentConfig:Save() then
      WindUI:Notify({
        Title = "Config Saved",
        Desc = "Config '" .. ConfigName .. "' saved",
        Icon = "check",
      })
    end
    AllConfigsDropdown:Refresh(ConfigManager:AllConfigs())
  end
})
ConfigTab:Space()
ConfigTab:Button({
    Title = "Load Config",
    Icon = "",
    Justify = "Center",
    Callback = function()
      Window.CurrentConfig = ConfigManager:CreateConfig(ConfigName)
      if Window.CurrentConfig:Load() then
        WindUI:Notify({
          Title = "Config Loaded",
          Desc = "Config '" .. ConfigName .. "' loaded",
          Icon = "refresh-cw",
        })
      end
    end
})
ConfigTab:Space()
ConfigTab:Button({
  Title = "Print AutoLoad Configs",
  Icon = "",
  Justify = "Center",
  Callback = function()
    print(HttpService:JSONDecode(ConfigManager:GetAutoLoadConfigs()))
  end
})
