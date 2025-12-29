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
  for _, v in pairs(workspace.Scriptable.Mobs:GetChildren()) do
    if v:IsA('Model') and v.Name == mob then
      game.Players.LocalPlayer.Character:PivotTo(
        v:GetPivot()
      )
    end
  end
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
  Folder = "wasd",
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
  Value = {"Z"},
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedSkills = option
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

    task.spawn(function()
      while AutoFarmMob do task.wait()
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
          if key then
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("UseSpecialPower", key)
            task.wait(0.1)
          end
          task.wait(0.1)
        end
      end
    end)
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
  Title = "Shop Options",
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
      'Puzzle Code',
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
