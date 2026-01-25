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


-- verify
local AllowedIds = {1048095073, 9366083217, 3252154084}
local Player = game.Players.LocalPlayer
local Allowed = false
for _, id in ipairs(AllowedIds) do
    if Player.UserId == id then
        Allowed = true
        break
    end
end
if not Allowed then
    pcall(Player.Kick, Player, "The script is being updated. For more information, join the Discord server.")
    task.wait(9e9)
else
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Custom/Intro/BetaTester.lua'))()
end
function CloseScript()
  local GameVersion = game:GetService("Players").LocalPlayer.PlayerGui.Main.MainHUD.Version.Text
  if GameVersion ~= 'v4.3.1' then
    pcall(game.Players.LocalPlayer.Kick, game.Players.LocalPlayer,
      "The script is being updated. For more information, join the Discord server."
    )
    task.wait(9e9)
  end
end; CloseScript()
if not BYPASS_LOADED then
  pcall(function()
    loadstring(game:HttpGet('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Fighinting-Simulator-Endless/bypass.lua'))()
    local SafeGuard = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/source.lua'))()
    SafeGuard:Hook({ AntiFluff = true })
  end)
else
  print('[DEBUG] - Bypass already loaded')
end
pcall(function() getgenv().BYPASS_LOADED = true end)


-- variables
local SkillKeys = { "Z","X","C","E","R","T","Y","U","F","G","H","J","K","L","V","B","N","M" }
local SelectedSkills = {}
getgenv().StatsFarm = { Delay = false }
getgenv().AfkFarmSettings = { Desync = true }
getgenv().FarmMobSettings = { UseM1 = false }
getgenv().AutoSellChampionsSettings = { Enabled = false }
getgenv().ProtectedChampion = false
getgenv().AutoBuySpecials = {
  ["Stands"] = {
    ["The Arm"] = 1,
    ["Heirophant Lime"] = 2,
    ["Magician's Crimson"] = 3,
    ["Purple Smog"] = 4,
    ["Killer King"] = 5,
    ["Celestial Diamond"] = 6,
    ["Time Crusader"] = 7,
    ["Guardian's Arm"] = 8,
    ["Crafted in Heaven"] = 9
  },
  ["Quirks"] = {
    ["Belly Laser"] = 1,
    ["Blue Inferno"] = 2,
    ["Frostfire Rift"] = 3,
    ["Bio-Reconstruct"] = 4,
    ["Unity Drive"] = 5,
    ["Hell Flame"] = 6
  },
  ["Kagunes"] = {
    ["Eye Patch"] = 1,
    ["Jason"] = 2,
    ["Centipede"] = 3,
    ["One Eye"] = 4
  },
  ["Grimoires"] = {
    ["Water Grimoire"] = 1,
    ["Wind Grimoire"] = 2,
    ["Demon Grimoire"] = 3,
    ["Tree Grimoire"] = 4
  },
  ["Bloodlines"] = {
    ["Copy Eyes"] = 1,
    ["White Eye"] = 2,
    ["Itachu's Copy Eyes"] = 3,
    ['Ripple Eyes'] = 4
  }
}
local FruitConn
local Applied = {}
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
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Remote = RS.Remotes.RemoteEvent
local Char = LP.Character or LP.CharacterAdded:Wait()
local HRP = Char:WaitForChild("HumanoidRootPart")
local Stats = {
	[1] = LP.Stats["1"],
	[2] = LP.Stats["2"],
	[3] = LP.Stats["3"],
	[4] = LP.Stats["4"],
	[5] = LP.Stats["5"],
	[6] = LP.Stats["6"],
}
local Areas = {
	[1] = {
		{100,1e4,{nil,2,-6,71,134}},
		{1e4,1e5,{nil,2,1343,195,-141}},
		{1e5,1e6,{nil,2,-1257,65,486}},
		{1e6,1e7,{nil,2,-917,85,179}},
		{1e7,1e8,{nil,2,-2245,617,533}},
		{1e8,1e9,{nil,2,-42,65,-1248}},
		{1e9,1e11,{nil,2,721,149,925}},
		{1e11,5e12,{nil,2,1842,139,96}},
		{5e12,2.5e14,{nil,2,621,662,413}},
		{2.5e14,5e16,{nil,2,4289,163,-601}},
		{5e16,1e18,{nil,2,798,231,-1004}},
		{1e18,1e20,{nil,2,3873,138,873}},
		{1e20,1e21,{nil,2,3858,669,-1076}},
		{1e21,1e23,{nil,2,2385,246,-624}},
    {1e23,1e24,{nil,2,-2345,508,1857}},
    {1e24,math.huge,{nil,2,-2045,1464,-2122}},
	},
	[2] = {
		{100,1e4,{nil,2,67,69,878}},
		{1e4,1e5,{nil,2,-1655,63,-520}},
		{1e5,1e6,{nil,2,-93,101,2029}},
		{1e6,1e7,{nil,2,-628,179,720}},
		{1e7,1e8,{nil,2,-1108,211,-962}},
		{1e8,1e9,{nil,2,-333,72,-1650}},
		{1e9,1e11,{nil,2,2508,1543,-380}},
		{1e11,5e12,{nil,2,-2802,-228,355}},
		{5e12,2.5e14,{nil,2,2187,517,581}},
		{2.5e14,5e16,{nil,2,1671,423,-1293}},
		{5e16,1e18,{nil,2,155,772,-699}},
		{1e18,1e20,{nil,2,2568,92,1762}},
		{1e20,1e21,{nil,2,1673,2305,-78}},
		{1e21,1e23,{nil,2,3529,258,1451}},
		{1e23,1e24,{nil,2,-2358,86,-87}},
    {1e24,math.huge,{nil,2,-1185,83,-1889}},
	},
	[3] = {
		{100,1e4,{nil,2,4,64,-124}},
		{1e4,1e5,{nil,2,1424,146,-581}},
		{1e5,1e6,{nil,2,914,140,794}},
		{1e6,1e7,{nil,2,1551,387,685}},
		{1e7,1e8,{nil,2,346,-149,-1844}},
		{1e8,1e9,{nil,2,1022,249,-618}},
		{1e9,1e11,{nil,2,3054,110,1105}},
		{1e11,5e12,{nil,2,1710,577,1743}},
		{5e12,2.5e14,{nil,2,-16,61,-475}},
		{2.5e14,5e16,{nil,2,-411,1255,663}},
		{5e16,1e18,{nil,2,-732,2791,628}},
		{1e18,1e20,{nil,2,3242,-441,-233}},
		{1e20,1e21,{nil,2,341,237,1867}},
		{1e21,1e23,{nil,2,-1123,607,1492}},
    {1e23,1e24,{nil,2,1413,232,-714}},
    {1e24,math.huge,{nil,2,3361,59,-1676}},
	},
	[5] = {
		{100,1e4,{nil,2,37,69,459}},
		{1e4,1e5,{nil,2,-424,122,-81}},
		{1e5,5e6,{nil,2,3479,60,143}},
		{5e6,math.huge,{nil,2,4111,69,879}},
	},
	[6] = {
		{100,1e4,{nil,2,-102,62,-496}},
		{1e4,1e5,{nil,2,-424,122,-81}},
		{1e5,5e6,{nil,2,3479,60,143}},
		{5e6,math.huge,{nil,2,4111,69,879}},
	},
}
local function TeleportBest(id)
	if id == 4 then return end

	local statValue = Stats[id].Value
	local list = Areas[id]
	if not list then return end

	for _, area in ipairs(list) do
		local min, max, tp = area[1], area[2], area[3]
		if statValue >= min and statValue < max then
			Teleport(unpack(tp))
			return
		end
	end
end
local function GetBoomQuest()
	for _,q in ipairs(LP.Quests:GetChildren()) do
		if q.Name:find("Boom") then
			return q
		end
	end
end
local BoomNPC = workspace.Scriptable.NPC.Quest:FindFirstChild("Boom")
local function TurnInBoom()
  if BoomNPC then
	  HRP:PivotTo(BoomNPC:GetPivot())
	  local click
	  repeat
	  	click = BoomNPC:FindFirstChild("ClickBox", true)
	  	task.wait(0.1)
	  until click and click:FindFirstChildOfClass("ClickDetector")
	  fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
  else
    Teleport(nil, 2, -36, 80, 3)
	  local click
	  repeat
	  	click = BoomNPC:FindFirstChild("ClickBox", true)
	  	task.wait(0.1)
	  until click and click:FindFirstChildOfClass("ClickDetector")
	  fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
  end
end
local ReindeerNPC = workspace.Scriptable.NPC.Quest:FindFirstChild("Reindeer")
local function TurnInReindeer()
	if ReindeerNPC then
		Teleport(nil, 2, -33, 105, 37)
		local click
		repeat
			click = ReindeerNPC:FindFirstChild("ClickBox", true)
			task.wait(0.1)
		until click and click:FindFirstChildOfClass("ClickDetector")
		fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
  else
    Teleport(nil, 2, -33, 105, 37)
	  local click
	  repeat
	  	click = ReindeerNPC:FindFirstChild("ClickBox", true)
	  	task.wait(0.1)
	  until click and click:FindFirstChildOfClass("ClickDetector")
	  fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
	end
end
local function GetReindeerQuest()
	for _, q in ipairs(LP.Quests:GetChildren()) do
		if q:FindFirstChild("QuestType") and q.Name:find("Reindeer") then
			return q
		end
	end
end
local function GetWeakerPlayersOffSafeZone()
	local list = {}
	local myPower = LP.OtherData.TotalPower.Value
	for _, v in ipairs(Players:GetPlayers()) do
		if v ~= LP and v:FindFirstChild("OtherData") then
			if v.OtherData.TotalPower.Value < myPower then
				local char = v.Character
				if char then
					local pvp = char:FindFirstChild("PVPFolder")
					if pvp and pvp:FindFirstChild("Safezone") and pvp.Safezone.Value == false then
						table.insert(list, v)
					end
				end
			end
		end
	end
	return list
end
local function KillPlayer(plr)
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health ~= 0 then
		HRP:PivotTo(plr.Character.HumanoidRootPart:GetPivot())
		Remote:FireServer("Train", 1)
	end
end
local function KillPlayerSword(plr)
	if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character.Humanoid.Health ~= 0 then
		HRP:PivotTo(plr.Character.HumanoidRootPart:GetPivot())
		Remote:FireServer("Train", 4)
	end
end
local SwordMasterNPC = workspace.Scriptable.NPC.Quest:FindFirstChild("Sword Master")
local function TurnInSwordMaster()
	if SwordMasterNPC then
		HRP:PivotTo(SwordMasterNPC:GetPivot())
		local click
		repeat
			click = SwordMasterNPC:FindFirstChild("ClickBox", true)
			task.wait(0.1)
		until click and click:FindFirstChildOfClass("ClickDetector")
		fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
  else
		Teleport(nil, 2, 326, 70, -1993)
		local click
		repeat
			click = SwordMasterNPC:FindFirstChild("ClickBox", true)
			task.wait(0.1)
		until click and click:FindFirstChildOfClass("ClickDetector")
		fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
	end
end
local function EquipBestSword()
  local Sword = game:GetService("Players").LocalPlayer.OtherData.Sword.Value
  local Event = game:GetService("ReplicatedStorage").Remotes.RemoteFunction
  Event:InvokeServer(
    "SwordEquip",
    Sword
  )
end
local function GetSwordMasterQuest()
	for _, q in ipairs(LP.Quests:GetChildren()) do
		if q:FindFirstChild("QuestType") and q.Name:find("Sword") then
			return q
		end
	end
end
local function GetKitiroQuest()
	for _, q in ipairs(LP.Quests:GetChildren()) do
		if q:FindFirstChild("QuestType") and q.Name:find("Kitiro") then
			return q
		end
	end
end
local MAX_DISTANCE = 60
local currentNPC
local function GetNPC1Alive()
	for _, v in ipairs(workspace:GetDescendants()) do
		if v:IsA("Model") and v.Name == "1" and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("PVPFolder") and v.PVPFolder:FindFirstChild("NewHealth") and v.PVPFolder.NewHealth.Value > 0 then
			return v
		end
	end
end
local function KillNPC1()
	if not currentNPC
		or not currentNPC.Parent
		or currentNPC.PVPFolder.NewHealth.Value <= 0 then
		currentNPC = GetNPC1Alive()
		if currentNPC then
			HRP:PivotTo(currentNPC.HumanoidRootPart:GetPivot())
		end
	end

	if not currentNPC then return end

	local dist = (HRP.Position - currentNPC.HumanoidRootPart.Position).Magnitude
	if dist <= MAX_DISTANCE then
		Remote:FireServer("Train", 1)
	else
		HRP:PivotTo(currentNPC.HumanoidRootPart:GetPivot())
	end
end
local function TurnInKitiro()
	if KitiroNpc then
		HRP:PivotTo(KitiroNpc:GetPivot())
		local click
		repeat
			click = KitiroNpc:FindFirstChild("ClickBox", true)
			task.wait(0.1)
		until click and click:FindFirstChildOfClass("ClickDetector")
		fireclickdetector(click:FindFirstChildOfClass("ClickDetector"))
	else
		Teleport(nil, 2, 326, 70, -1993)
	end
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
local function ApplyEspToPlayer(plr)
  if plr == LocalPlayer then return end

  local function onChar(char)
    if not EspLib.ESPValues.PlayersESP then return end
    if not char then return end

    EspLib.ApplyESP(char, {
      Color = Color3.fromRGB(135, 52, 173),
      Text = plr.Name,
      ESPName = "PlayersESP",
      HighlightEnabled = true,
    })
  end

  if plr.Character then
    onChar(plr.Character)
  end

  plr.CharacterAdded:Connect(onChar)
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
local function ApplyFruit(fruit)
  if Applied[fruit] then return end
  Applied[fruit] = true

  EspLib.ApplyESP(fruit, {
    Color = Color3.fromRGB(173, 52, 52),
    Text = fruit.Name,
    ESPName = "FruitESP",
    HighlightEnabled = true,
  })
end
local function ApplyEspToFruit()
  for _, v in ipairs(workspace.Scriptable.Fruits:GetChildren()) do
    if v:IsA("Model") then
      ApplyFruit(v)
    end
  end
end
function ApplyEspToNPCs()
  for _, v in pairs(workspace.Scriptable.NPC:GetDescendants()) do
    if v:IsA("Model") and v.Name ~= "Model" and v.Name ~= "NPCModel" then
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
WindUI:AddTheme({
  Name = "InfinityX",

  Accent = Color3.fromHex("#6c1bb9"),
  Dialog = Color3.fromHex("#450a0a"),
  Outline = Color3.fromHex("#fca5a5"),
  Text = Color3.fromHex("#fef2f2"),
  Placeholder = Color3.fromHex("#6f757b"),
  Background = Color3.fromHex("#0c0404"),
  Button = Color3.fromHex("9F2ED1"),
  Icon = Color3.fromHex("#9F2ED1"),
})
local Window = WindUI:CreateWindow({
  Title = "InfinityX",
  Author = "Anime Fighinting Simulator",
  Folder = "InfinityX/Settings",
  Icon = "rbxassetid://72212320253117",
  Theme = "InfinityX",
  NewElements = true,
  Size = UDim2.fromOffset(680, 580),
  Transparent = false,
  HideSearchBar = true,
  SideBarWidth = 180,
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
<font size="20" color="#00FF88"><b>🚀 New Features & Changes</b></font>
<font size="15" color="#E0E0E0">
• <font color="#FFD166"><b>Added Auto Quests</b></font> – <font size="16">automatic completion for Boom and Reindeer quests.</font>
• <font color="#FFD166"><b>Added UI Customization</b></font> – <font size="16">new customization options and cleaner interface.</font>
• <font color="#FFD166"><b>Added Anti-AFK System</b></font> – <font size="16">prevents AFK kicks with improved bypass.</font>
• <font color="#FFD166"><b>Added Auto Buy Next Class</b></font> – <font size="16">automatically purchases the next class.</font>
• <font color="#00FFCC"><b>Improved Farming & Teleports</b></font> – <font size="16">better area selection, faster and more stable teleports.</font>
• <font color="#00FFCC"><b>Improved Auto Upgrade & Config</b></font> – <font size="16">smoother upgrades and improved config tab.</font>
• <font color="#00FFCC"><b>Improved Verification Bypass</b></font> – <font size="16">higher stability and success rate.</font>
• <font color="#FF6B6B"><b>UI Cleanup</b></font> – <font size="16">removed unnecessary UI tags and layout clutter.</font>
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
  Title = "┌ Auto Farm",
  Icon = "swords",
  Locked = false,
})
local UpgradeTab = Window:Tab({
  Title = "├ Upgrade",
  Icon = "chevrons-up",
  Locked = false,
})
local SkillTab = Window:Tab({
  Title = "├ Auto Skill",
  Icon = "zap",
  Locked = false,
})
local EspTab = Window:Tab({
  Title = "├ Visual",
  Icon = "eye",
  Locked = false,
})
local PlayerTab = Window:Tab({
  Title = "├ Player",
  Icon = "circle-user-round",
  Locked = false,
})
local ShopTab = Window:Tab({
  Title = "├ Shop",
  Icon = "shopping-cart",
  Locked = false,
})
local SpecialTab = Window:Tab({
  Title = "├ Special",
  Icon = "sparkles",
  Locked = false,
})
local QuestTab = Window:Tab({
  Title = "├ Quest",
  Icon = "clipboard-list",
  Locked = false,
})
local TeleportTab = Window:Tab({
  Title = "├ Teleports",
  Icon = "map-pin",
  Locked = false,
})
local MiscTab = Window:Tab({
  Title = "└ Misc",
  Icon = "layers",
  Locked = false,
})
Window:Divider()
local WebhookTab = Window:Tab({
  Title = "┌ Webhook",
  Icon = "webhook",
  Locked = false,
})
local ConfigTab = Window:Tab({
  Title = "└ Config Usage",
  Icon = "settings",
  Locked = false,
})
AutoFarmTab:Select()


-- source
local Section = AutoFarmTab:Section({
  Title = "Farming Configuration",
})
local Paragraph = AutoFarmTab:Paragraph({
  Title = "Stats Viewer",
  Desc = "",
  Locked = false,
})
task.spawn(function()
  while true do task.wait(1)
    Paragraph:SetDesc('💪 Strength: '.. GetStats(Strength) ..'\n🛡️ Durability: '.. GetStats(Durability) ..'\n🔥 Chakra: '.. GetStats(Chakra) .. '\n⚔️ Sword: '.. GetStats(Sword) .. '\n🪽 Agility: '.. GetStats(Agility) .. '\n🏃‍♀️ Speed: '.. GetStats(Speed))
  end
end)
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select stat",
  Desc = "Select the stat you want to farm",
  Values = { "Strength", 'Durability', 'Chakra', 'Agility', 'Speed', 'Sword' },
  Value = "Strength",
  Flag = "StatDropdown",
  Callback = function(option)
    SelectedStat = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Start auto farm",
  Desc = "Activate to farm in the best area the stats you selected.",
  Icon = "check",
  Type = "Checkbox",
  Flag = "StatFarm",
  Value = false,
  Callback = function(state)
    AutoFarm = state
    if not AutoFarm then return end

    local Remote = game:GetService("ReplicatedStorage").Remotes.RemoteEvent
    local StatMap = {
      Strength = 1,
      Durability = 2,
      Chakra = 3,
      Sword = 4,
      Agility = 5,
      Speed = 6,
    }
    local Stats = {
      [1] = Strength,
      [2] = Durability,
      [3] = Chakra,
      [4] = Sword,
      [5] = Agility,
      [6] = Speed,
    }
    local function TeleportBestByStat(statId)
      if statId == 4 then return end
      local value = Stats[statId].Value
      local list = Areas[statId]
      if not list then return end
      for _,area in ipairs(list) do
        local min, max, tp = area[1], area[2], area[3]
        if value >= min and value < max then
          Teleport(unpack(tp))
          return
        end
      end
    end

    task.spawn(function()
      while AutoFarm do task.wait()
        local char = game.Players.LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")

        if not hum or hum.Health <= 0 and getgenv().StatsFarm.Delay then
          task.wait(6)
          repeat task.wait()
            char = game.Players.LocalPlayer.Character
            hum = char and char:FindFirstChildOfClass("Humanoid")
          until hum and hum.Health > 0 or not AutoFarm
        end

        local statId = StatMap[SelectedStat]
        if not statId then continue end
        TeleportBestByStat(statId)
        Remote:FireServer("Train", statId)
      end
    end)
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Delay on dead",
  Desc = "Every time a player dies with auto-farm stats enabled, it takes a while before they can teleport back to the selected training zone.",
  Icon = "check",
  Type = "Checkbox",
  Flag = "StatFarm",
  Value = false,
  Callback = function(state)
    getgenv().StatsFarm.Delay = state
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
  Flag = "PlayerDropdownA",
  Callback = function(option)
    SelectedPlayerToFarm = option
  end
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select skills",
  Desc = "Select the skills you want to use to kill selected player",
  Values = SkillKeys,
  Value = {"Z","X","C"},
  Flag = "SkillsDropdownA",
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
  Flag = "PlayerFarm",
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
  Title = "Viewer player power",
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
  Title = "Boss Farming",
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select boss",
  Desc = "Select the boss you want to farm",
  Values = { "Kurama" },
  Value = "Kurama",
  Flag = "MobDropdown",
  Callback = function(option)
    SelectedBoss = option
  end
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select skills",
  Desc = "Select the skills you want to use",
  Values = SkillKeys,
  Value = {"Z","X","C"},
  Flag = "SkillsDropdownBoss",
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedBossSkills = option
  end
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select tp mode",
  Desc = "Select the tp mode you want to use",
  Values = {"Center", "Bottom", "Top"},
  Value = "Center",
  Flag = "TeleportMode",
  Multi = false,
  Callback = function(option)
    SelectedTeleportMode = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Start auto boss farm",
  Icon = "check",
  Type = "Checkbox",
  Flag = "BossFarmToggle",
  Value = false,
  Callback = function(state)
    local arenaPart = workspace.Scriptable.BossArena:FindFirstChild('InArena')
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer

    local function createArena()
      if arenaPart then return arenaPart end

      arenaPart = Instance.new("Part", workspace.Scriptable.BossArena)
      arenaPart.Name = "InArena"
      arenaPart.Anchored = true
      arenaPart.CanCollide = false
      arenaPart.Transparency = 0.5

      local p1 = Vector3.new(1913, 3122, 468)
      local p2 = Vector3.new(2586, 3302, 1146)
      local extraDown = 200

      local size = Vector3.new(
        math.abs(p2.X - p1.X),
        math.abs(p2.Y - p1.Y),
        math.abs(p2.Z - p1.Z)
      )

      arenaPart.Size = Vector3.new(size.X, size.Y + extraDown, size.Z)
      arenaPart.Position = ((p1 + p2) / 2) - Vector3.new(0, extraDown / 2, 0)

      return arenaPart
    end

    local function isPlayerInArena()
      if not arenaPart then return false end

      local char = player.Character
      if not char then return false end

      local hrp = char:FindFirstChild("HumanoidRootPart")
      if not hrp then return false end

      local relative = arenaPart.CFrame:PointToObjectSpace(hrp.Position)
      local half = arenaPart.Size / 2

      return math.abs(relative.X) <= half.X
        and math.abs(relative.Y) <= half.Y
        and math.abs(relative.Z) <= half.Z
    end

    local function farmKurama(mode)
      local char = game.Players.LocalPlayer.Character
      if not char then return end

      local hrp = char:FindFirstChild("HumanoidRootPart")
      if not hrp then return end

      local boss = workspace.Scriptable.BossArena:FindFirstChild("Demon Fox")
      if not boss then return end

      local bossHRP = boss:FindFirstChild("HumanoidRootPart")
      if not bossHRP then return end

      if mode == "Top" then
        hrp.CFrame = bossHRP.CFrame * CFrame.new(0, 60, 0)
      elseif mode == "Bottom" then
        hrp.CFrame = bossHRP.CFrame * CFrame.new(0, -60, 0)
      elseif mode == "Center" then
        hrp.CFrame = bossHRP.CFrame
      end
    end

    AutoKurama = state
    if not AutoKurama then return else createArena() end

    task.spawn(function()
      while AutoKurama do task.wait()
        if not isPlayerInArena() then
          local ClickBox = workspace.Scriptable.BossArena:FindFirstChild('ClickBox')
          if ClickBox then fireclickdetector(ClickBox:FindFirstChildWhichIsA('ClickDetector')) end
        elseif isPlayerInArena() then
          while AutoKurama and workspace.Scriptable.BossArena:FindFirstChild("Demon Fox") do task.wait()
            farmKurama(SelectedTeleportMode)
          end
        end
      end
    end)
  end
})
AutoFarmTab:Toggle({
	Title = "Auto use skills",
	Icon = "check",
	Type = "Checkbox",
	Flag = "SkillsBossToggle",
	Value = false,
	Callback = function(state)
		SkillsBoss = state
		if not SkillsBoss then return end

		task.spawn(function()
      while SkillsBoss do task.wait()
        while SkillsBoss and workspace.Scriptable.BossArena:FindFirstChild("Demon Fox") do task.wait()
          for _, skill in ipairs(SelectedBossSkills) do
            local key = Enum.KeyCode[skill]
            game:GetService("ReplicatedStorage").Remotes.RemoteFunction:InvokeServer("UsePower", skill)
            game:GetService("ReplicatedStorage").Remotes.RemoteFunction:InvokeServer("UseSpecialPower", key)
          end
        end
      end
		end)
	end
})
AutoFarmTab:Toggle({
	Title = "No lava damage",
	Icon = "check",
	Type = "Checkbox",
	Flag = "SkillsBossToggle",
	Value = false,
	Callback = function(state)
    NoLava = state
    if not NoLava then return end

    task.spawn(function()
      while NoLava do task.wait()
        for _, v in pairs(workspace.Scriptable.BossArena.Lava:GetDescendants()) do
          if v:IsA('TouchTransmitter') then
            v:Destroy(); break
          end
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
  Values = { "Sarka", "Gen", "Igicho", "Remgonuk", "Booh", "Saytamu", "Riru", "Paien", "Minetu" },
  Value = "Sarka",
  Flag = "MobDropdown",
  Callback = function(option)
    SelectedMob = option
  end
})
local Dropdown = AutoFarmTab:Dropdown({
  Title = "Select skills",
  Desc = "Select the skills you want to use",
  Values = SkillKeys,
  Value = {"Z","X","C"},
  Flag = "SkillsDropdownB",
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
  Flag = "MobFarmM1",
  Value = false,
  Callback = function(state)
    getgenv().FarmMobSettings.UseM1 = state
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Start auto mob farm",
  Icon = "check",
  Type = "Checkbox",
  Flag = "MobFarm",
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
          MobSelected = '6'
        elseif SelectedMob == "Riru" then
          MobSelected = '1001'
        elseif SelectedMob == "Paien" then
          MobSelected = '1002'
        elseif SelectedMob == "Minetu" then
          MobSelected = '1003'
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
  Flag = "ChampionDropdown",
  Callback = function(option)
    SelectedAutoSummonChampion = option
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto summon selected champion",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoSummonChampions",
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
  Title = "Auto Npcs Quest",
})
AutoFarmTab:Toggle({
	Title = "Auto boom quest",
  Desc = "Automatically completes Boom quests.",
	Icon = "check",
	Type = "Checkbox",
  Flag = "AutoBoomQuestToggle",
	Value = false,
	Callback = function(state)
		AutoBoom = state
		task.spawn(function()
			while AutoBoom do
				local Q = GetBoomQuest()
				if Q then
					if Q.Completed.Value then
						TurnInBoom()
						task.wait(1)
					else
            for id = 1,6 do
              local prog = Q.Progress:FindFirstChild(tostring(id))
              local req = Q.Requirements:FindFirstChild(tostring(id))
              local stat = Stats[id]
              if prog and req then
                if prog.Value >= req.Value then
                  continue
                end
                local need
                if prog.Value == 0 then
                  need = req.Value
                else
                  need = req.Value - prog.Value
                end
                local target = stat.Value + need
                while AutoBoom do
                  if not Q.Requirements:FindFirstChild(tostring(id)) then
                    break
                  end
                  if stat.Value >= target then
                    break
                  end
                  TeleportBest(id)
                  Remote:FireServer("Train", id)
                  task.wait()
                end
                break
              end
            end
					end
        else
          TurnInBoom()
          task.wait(1)
				end
				task.wait()
			end
		end)
	end
})
AutoFarmTab:Toggle({
	Title = "Auto reindeer quest",
	Desc = "Automatically completes Reindeer quests.",
	Icon = "check",
	Type = "Checkbox",
	Flag = "AutoReindeerQuestToggle",
	Value = false,
	Locked = false,
	Callback = function(state)
		AutoReindeer = state
		task.spawn(function()
			while AutoReindeer do
				local Q = GetReindeerQuest()
				if Q then
					if Q.Completed.Value then
						TurnInReindeer()
						task.wait(1)
					else
						local qType = Q.QuestType.Value
						if qType == "KillPlayer" then
							for _, plr in ipairs(GetWeakerPlayersOffSafeZone()) do
								if not AutoReindeer or Q.Completed.Value then break end
								KillPlayer(plr)
								task.wait()
							end
						elseif qType == "KillPlayerSword" then
							for _, plr in ipairs(GetWeakerPlayersOffSafeZone()) do
								if not AutoReindeer or Q.Completed.Value then break end
								KillPlayerSword(plr)
								task.wait()
							end
						elseif qType == "GainIncrement" then
							for id = 1,6 do
								local prog = Q.Progress:FindFirstChild(tostring(id))
								local req = Q.Requirements:FindFirstChild(tostring(id))
								if prog and req then
									while AutoReindeer and prog.Value < req.Value do
										TeleportBest(id)
										Remote:FireServer("Train", id)
										task.wait()
									end
								end
								if Q.Completed.Value then break end
							end
						else
							for id = 1,6 do
								local prog = Q.Progress:FindFirstChild(tostring(id))
								local req = Q.Requirements:FindFirstChild(tostring(id))
								local stat = Stats[id]
								if prog and req and prog.Value < req.Value then
									local target = stat.Value + (req.Value - prog.Value)
									while AutoReindeer and stat.Value < target do
										TeleportBest(id)
										Remote:FireServer("Train", id)
										task.wait()
									end
									break
								end
							end
						end
					end
				else
					TurnInReindeer()
					task.wait(1)
				end
				task.wait()
			end
		end)
	end
})
AutoFarmTab:Toggle({
  Title = "Auto kitiro quest",
  Desc = "Automatically completes Kitiro quests.",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoKitiroQuestToggle",
  Value = false,
  Locked = false,
  Callback = function(state)
    AutoKitiro = state
    if not AutoKitiro then teleported = false return end
    task.spawn(function()
      while AutoKitiro do
        local Q = GetKitiroQuest()
        if Q then
          if Q.Completed.Value then
            TurnInKitiro()
            task.wait(1)
          else
            local qType = Q.QuestType.Value
            if qType == "GainIncrement" then
              for id = 1,6 do
                local prog = Q.Progress:FindFirstChild(tostring(id))
                local req = Q.Requirements:FindFirstChild(tostring(id))
                if prog and req then
                  while AutoKitiro and prog.Value < req.Value do
                    TeleportBest(id)
                    Remote:FireServer("Train", id)
                    task.wait()
                  end
                end
                if Q.Completed.Value then break end
              end
            elseif qType == "KillNPC" then
              while AutoKitiro and not Q.Completed.Value do
                KillNPC1()
                task.wait()
              end
            else
              for id = 1,6 do
                local prog = Q.Progress:FindFirstChild(tostring(id))
                local req = Q.Requirements:FindFirstChild(tostring(id))
                local stat = Stats[id]
                if prog and req and stat and prog.Value < req.Value then
                  local target = stat.Value + (req.Value - prog.Value)
                  while AutoKitiro and stat.Value < target do
                    TeleportBest(id)
                    Remote:FireServer("Train", id)
                    task.wait()
                  end
                  break
                end
              end
            end
          end
        else
          TurnInKitiro()
          task.wait(1)
        end
        task.wait()
      end
    end)
  end
})
AutoFarmTab:Toggle({
	Title = "Auto sword master quest",
	Desc = "Automatically completes Sword Master quests.",
	Icon = "check",
	Type = "Checkbox",
	Flag = "AutoSwordMasterQuestToggle",
	Value = false,
	Locked = false,
	Callback = function(state)
		AutoSwordMaster = state
    if not AutoSwordMaster then return end
		task.spawn(function()
			while AutoSwordMaster do
				local Q = GetSwordMasterQuest()
				if Q then
					if Q.Completed.Value then
						TurnInSwordMaster()
						task.wait(1)
					else
						local prog = Q.Progress:FindFirstChild("4")
						local req = Q.Requirements:FindFirstChild("4")
						local stat = Stats[4]
						if prog and req and stat then
							local target = stat.Value + (req.Value - prog.Value)
							while AutoSwordMaster and stat.Value < target do
								TeleportBest(4)
								EquipBestSword()
                Remote:FireServer("Train", 4)
								task.wait()
							end
						end
					end
				else
					TurnInSwordMaster()
					task.wait(1)
				end
				task.wait()
			end
		end)
	end
})
local Section = AutoFarmTab:Section({ 
  Title = "Chikara / Fruit Farming",
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto collect dragon orb",
  Desc = "Collect all the dragon orb that appears",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoDragonOrb",
  Value = false,
  Callback = function(state)
    DragonOrb = state

    if not DragonOrb then return end
    if not fireclickdetector then
      WindUI:Notify({
        Title = "<font size='14'><b>Executor Compatibility Warning</b></font>",
        Content = [[
<font size='14' color='#FF6B6B'><b>Unsupported Function Detected</b></font>

<font size='14' color='#E0E0E0'>
The executor you are currently using does not support the function
</font>
<font size='12' color='#FFD166'><b>fireclickdetector()</b></font>
<font size='11' color='#E0E0E0'>
This feature requires full ClickDetector interaction support. Please switch to a compatible executor to ensure proper functionality and avoid unexpected behavior.
</font>
        ]],
        Duration = 10,
        Icon = "bell-ring",
      })
      return
    end

    task.spawn(function()
      while DragonOrb do task.wait()
        for _, v in pairs(workspace.MouseIgnore:GetDescendants()) do
          if v:IsA('ClickDetector') and v.Name == 'ClickDetector' then
            fireclickdetector(v)
            break
          end
        end
      end
    end)
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto collect fruit",
  Desc = "Collect all the fruit that appears",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoFruit",
  Value = false,
  Callback = function(state)
    Fruit = state

    if not Fruit then return end
    if not fireclickdetector then
      WindUI:Notify({
        Title = "<font size='14'><b>Executor Compatibility Warning</b></font>",
        Content = [[
<font size='14' color='#FF6B6B'><b>Unsupported Function Detected</b></font>

<font size='14' color='#E0E0E0'>
The executor you are currently using does not support the function
</font>
<font size='12' color='#FFD166'><b>fireclickdetector()</b></font>
<font size='11' color='#E0E0E0'>
This feature requires full ClickDetector interaction support. Please switch to a compatible executor to ensure proper functionality and avoid unexpected behavior.
</font>
        ]],
        Duration = 10,
        Icon = "bell-ring",
      })
      return
    end

    task.spawn(function()
      while Fruit do task.wait()
        for _, v in pairs(workspace.Scriptable.Fruits:GetDescendants()) do
          if v:IsA('ClickDetector') and v.Name == 'ClickDetector' then
            fireclickdetector(v)
            wait(2)
            break
          end
        end
      end
    end)
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Auto collect chikara box",
  Desc = "Collect all the chikaras on the island you are on",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoChikara",
  Value = false,
  Callback = function(state)
    ChikaraBox = state

    if not ChikaraBox then return end
    if not fireclickdetector then
      WindUI:Notify({
        Title = "<font size='14'><b>Executor Compatibility Warning</b></font>",
        Content = [[
<font size='14' color='#FF6B6B'><b>Unsupported Function Detected</b></font>

<font size='14' color='#E0E0E0'>
The executor you are currently using does not support the function
</font>
<font size='12' color='#FFD166'><b>fireclickdetector()</b></font>
<font size='11' color='#E0E0E0'>
This feature requires full ClickDetector interaction support. Please switch to a compatible executor to ensure proper functionality and avoid unexpected behavior.
</font>
        ]],
        Duration = 10,
        Icon = "bell-ring",
      })
      return
    end

    task.spawn(function()
      while ChikaraBox do task.wait()
        for _, v in pairs(workspace.Scriptable.ChikaraBoxes:GetDescendants()) do
            if v:IsA('ClickDetector') then
            fireclickdetector(v)
            wait(2)
            break
          end
        end
      end
    end)
  end
})
local Button = AutoFarmTab:Button({
  Title = "Afk-Farm Chikara",
  Desc = "This script teleports you to various places, it's best to run it on a private server",
  Locked = false,
  Callback = function()
    local Dialog = Window:Dialog({
      Icon = "circle-question-mark",
      Title = "InfinityX",
      Content = "<b>Warning</b>\n\nRunning this script will <b>close the hub</b> and <b>start the AFK Farm</b>.\n\nThis script uses a <b>Desync system</b>.\n\n<b>Some executors may not be able to run this script.</b>\n\nAre you sure you want to continue?",
      Buttons = {
        {
          Title = "Execute",
          Callback = function()
            WindUI:Notify({
              Title = "Notification",
              Content = "Starting afk farm...",
              Duration = 2,
              Icon = "bell-ring",
            }); wait(2)
            Window:Destroy(); wait(1)

            if getgenv().AfkFarmSettings.Desync then
              Teleport(nil, 2, 14, 105, -13) wait(.5)
              setfflag("NextGenReplicatorEnabledWrite4", "false"); wait(1)
              setfflag("NextGenReplicatorEnabledWrite4", "true"); wait(1)
            end

            loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Fighinting-Simulator-Endless/modules/Afk-Farm.lua'))()
          end,
        },
        {
          Title = "Close",
          Callback = function()
            print("Closed!")
          end,
        },
      },
    })
  end
})
local Toggle = AutoFarmTab:Toggle({
  Title = "Use Desync",
  Desc = "Use desync in afk farm chikara",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoChikara",
  Value = true,
  Callback = function(state)
    getgenv().AfkFarmSettings.Desync = state
  end
})


local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LP = Players.LocalPlayer
local Event = RS.Remotes.RemoteFunction
local StatMap = {
	Strength = 1,
	Durability = 2,
	Chakra = 3,
	Sword = 4,
	Agility = 5,
	Speed = 6
}
local Upgrades = LP:WaitForChild("Upgrades")
local UpgradeRefs = {
	[1] = Upgrades["1"],
	[2] = Upgrades["2"],
	[3] = Upgrades["3"],
	[4] = Upgrades["4"],
	[5] = Upgrades["5"],
	[6] = Upgrades["6"],
}
local SelectedStatsNumbers = {}
local SelectedDelay = 2
local AutoUpgrade = false
local Section = UpgradeTab:Section({
  Title = "Upgrade Configuration",
})
local AutoUpgradeParagraph = UpgradeTab:Paragraph({ Title = "Upgrade Viewer", Desc = "", Locked = false, })
task.spawn(function()
	while true do
		task.wait(2)
		AutoUpgradeParagraph:SetDesc(
			'💪 Strength: '..GetStats(UpgradeRefs[1])..
			'\n🛡️ Durability: '..GetStats(UpgradeRefs[2])..
			'\n🔥 Chakra: '..GetStats(UpgradeRefs[3])..
			'\n⚔️ Sword: '..GetStats(UpgradeRefs[4])..
			'\n🪽 Agility: '..GetStats(UpgradeRefs[5])..
			'\n🏃‍♀️ Speed: '..GetStats(UpgradeRefs[6])
		)
	end
end)
UpgradeTab:Dropdown({
	Title = "Select stats",
	Values = {"Strength","Durability","Chakra","Sword","Agility","Speed"},
	Multi = true,
	AllowNone = true,
  Flag = "StatsUpgradeDropdown",
	Callback = function(options)
		table.clear(SelectedStatsNumbers)
		for _, stat in ipairs(options) do
			local id = StatMap[stat]
			if id then
				SelectedStatsNumbers[#SelectedStatsNumbers+1] = id
			end
		end
	end
})
UpgradeTab:Slider({
	Title = "Level up delay",
	Step = 1,
	Value = {Min = 2, Max = 60, Default = 2},
  Flag = "LevelUpDelay",
	Callback = function(v)
		SelectedDelay = tonumber(v) or 2
	end
})
UpgradeTab:Toggle({
	Title = "Auto upgrade stats",
  Type = "Checkbox",
  Flag = "AutoUpgradeStatsToggle",
	Value = false,
	Callback = function(state)
		AutoUpgrade = state
		if not state then return end

		task.spawn(function()
			while AutoUpgrade do
				for i = 1, #SelectedStatsNumbers do
					Event:InvokeServer("Upgrade", SelectedStatsNumbers[i])
					if SelectedDelay > 0 then
						task.wait(SelectedDelay)
					end
				end
				task.wait(0.2)
			end
		end)
	end
})


local SkillStates = {}
local Section = SkillTab:Section({
  Title = "Auto Use Skills Options",
})
for _, v in pairs(SkillKeys) do
  SkillStates[v] = false
  SkillTab:Toggle({
    Title = "Auto use " .. v,
    Icon = "check",
    Type = "Checkbox",
    Flag = "AutoUse"..tostring(v),
    Value = false,
    Callback = function(state)
      SkillStates[v] = state
      if not state then return end
      task.spawn(function()
        while SkillStates[v] do task.wait(2)
          local key = Enum.KeyCode[v]
          local rf = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction")
          rf:InvokeServer("UsePower", v)
          if key then
            rf:InvokeServer("UseSpecialPower", key)
          end
        end
      end)
    end
  })
end


local Section = EspTab:Section({ 
  Title = "Esp Options",
})
local playerAddedConn
EspTab:Toggle({
  Title = "Esp players",
  Icon = "check",
  Type = "Checkbox",
  Flag = "EspPlayer",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.PlayersESP = state

    if state then
      for _, p in ipairs(Players:GetPlayers()) do
        ApplyEspToPlayer(p)
      end

      if not playerAddedConn then
        playerAddedConn = Players.PlayerAdded:Connect(function(p)
          ApplyEspToPlayer(p)
        end)
      end
    else
      if playerAddedConn then
        playerAddedConn:Disconnect()
        playerAddedConn = nil
      end
    end
  end
})
local Toggle = EspTab:Toggle({
  Title = "Esp chikara boxes",
  Icon = "check",
  Type = "Checkbox",
  Flag = "EspChikara",
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
EspTab:Toggle({
  Title = "Esp all fruits",
  Icon = "check",
  Type = "Checkbox",
  Flag = "EspFruit",
  Value = false,
  Callback = function(state)
    EspLib.ESPValues.FruitESP = state

    if state then
      ApplyEspToFruit()

      if not FruitConn then
        FruitConn = workspace.Scriptable.Fruits.ChildAdded:Connect(function(fruit)
          if EspLib.ESPValues.FruitESP and fruit:IsA("Model") then
            ApplyFruit(fruit)
          end
        end)
      end
    else
      if FruitConn then
        FruitConn:Disconnect()
        FruitConn = nil
      end
      table.clear(Applied)
    end
  end
})
local Toggle = EspTab:Toggle({
  Title = "Esp all npcs",
  Icon = "check",
  Type = "Checkbox",
  Flag = "EspNpcs",
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
  Flag = "EspMobs",
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
  Flag = "NotifyChikara",
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
  Flag = "NotifyFruit",
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
local Toggle = PlayerTab:Button({
  Title = "FE Invisible",
  Locked = false,
  Callback = function()
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/universal/invisible.lua'))()
  end
})
local Toggle = PlayerTab:Toggle({
  Title = "Noclip",
  Icon = "check",
  Type = "Checkbox",
  Flag = "Noclip",
  Value = false,
  Callback = function(state)
    Noclip = state
    local starter = false

    if Noclip then
      starter = true
      for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true then
          task.spawn(function() while Noclip do task.wait() v.CanCollide = false end end)
        end
      end
    else
      if not starter then return end
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
  Values = {'Christmas', 'Gold', 'Dark', 'Electric', 'Sayan', 'Burning', 'Easter'},
  Value = "Christmas",
  Flag = "ChestDropdown",
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
  Flag = "OpenChest",
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
  Value = "1 - 5k Chikara",
  Flag = "GachaDropdown",
  Callback = function(option)
    SelectedGacha = option
  end
})
local Dropdown = ShopTab:Dropdown({
  Title = "Select Champions",
  Desc = "Select the champions you want to get",
  Values = { "Sunji", "Levee", "Keela", "Sarka", "Pilcol", "Toju", "Canakey", "Loofi", "Asto", "Junwon", "Tojaro", "Juyari", "Narnto", "Vetega", "Genas", "Boras", "Igicho", "Remgonuk", "Sasoke ", "Itachu", "Goju", "Bright Yagimi", "Saytamu Serious", "Giovanni", "Booh", "Gen", "Shunro", "Kroll", "Eskano", "Mallyodas", "Gokro", "Saytamu" },
  Value = {"Sunji", "Levee", "Keela"},
  Flag = "ChampionDropdownB",
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
  Flag = "AutoSellUnlockedChampions",
	Value = false,
	Callback = function(state)
		AutoSellChampions = state
		if not state then return end

		task.spawn(function()
			while AutoSellChampions do
				task.wait(1)
				getgenv().ProtectedChampion = false

				for _,v in ipairs(game.Players.LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List:GetDescendants()) do
					if v:IsA("TextLabel") and v.Name == "ChampionName" then
						for _,n in ipairs(SelectedChampionsToRoll) do
							if v.Text == n then
								getgenv().ProtectedChampion = true
								break
							end
						end
					end
					if getgenv().ProtectedChampion then break end
				end

				if getgenv().ProtectedChampion then continue end

				for _,c in ipairs(game.Players.LocalPlayer.Champions:GetChildren()) do
					if c.Value ~= 1 then
						game.ReplicatedStorage.Remotes.RemoteEvent:FireServer("SellChamp", c)
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
  Flag = "AutoChampions",
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
ShopTab:Button({
	Title = "Lock all champions",
	Callback = function()
    for _, v in pairs(game:GetService("Players").LocalPlayer.Champions:GetChildren()) do
      local args = {
        "LockChamp",
        v
      }
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer(unpack(args))
      wait(1)
    end
	end
})
local Section = ShopTab:Section({ 
  Title = "Gacha Powers Options",
})
local Dropdown = ShopTab:Dropdown({
  Title = "Select gacha powers",
  Desc = "Select the gacha power you want to roll",
  Values = { 'Jutsu Leveling', 'Nen Leveling', 'Soul Leveling', 'Nichiyin Leveling', 'Seiyen Leveling', 'Hero Leveling' },
  Value = "Jutsu Leveling",
  Flag = "GPDropdown",
  Callback = function(option)
    SelectedGachaPower = option
  end
})
ShopTab:Toggle({
	Title = "Auto roll gacha power",
	Icon = "check",
	Type = "Checkbox",
  Flag = "AutoRollGP",
	Value = false,
	Callback = function(state)
		AutoRollGachaPower = state
		if not AutoRollGachaPower then return end

		task.spawn(function()
      local remote = game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction")
      if AutoRollGachaPower then
        while AutoRollGachaPower do task.wait(0.5)
          if SelectedGachaPower == 'Jutsu Leveling' then
            remote:InvokeServer('BuyGacha', 'G1')
          elseif SelectedGachaPower == 'Nen Leveling' then
            remote:InvokeServer('BuyGacha', 'G2')
          elseif SelectedGachaPower == 'Soul Leveling' then
            remote:InvokeServer('BuyGacha', 'G3')
          elseif SelectedGachaPower == 'Nichiyin Leveling' then
            remote:InvokeServer('BuyGacha', 'G4')
          elseif SelectedGachaPower == 'Seiyen Leveling' then
            remote:InvokeServer('BuyGacha', 'G5')
          elseif SelectedGachaPower == 'Hero Leveling' then
            remote:InvokeServer('BuyGacha', 'G6')
          end
        end
      end
		end)
	end
})
local Section = ShopTab:Section({ 
  Title = "Class Shop",
})
local ClassParagraph = ShopTab:Paragraph({
  Title = "Class Viewer",
  Desc = "nil",
  Locked = false,
})
task.spawn(function()
  local function updateClassDesc()
    local char = game.Players.LocalPlayer.Character
    if not char then return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local overhead = hrp:FindFirstChild("Overhead")
    if not overhead then return end

    local class = overhead:FindFirstChild("Class")
    if not class then return end

    ClassParagraph:SetDesc("Current Class: " .. class.Text)
  end

  while true do task.wait(2)
    updateClassDesc()
  end
end)
ShopTab:Toggle({
	Title = "Auto buy next class",
	Icon = "check",
	Type = "Checkbox",
  Flag = "AutoRollGP",
	Value = false,
	Callback = function(state)
		Class = state
		if not Class then return end

		task.spawn(function()
      while Class do task.wait(2)
        local Event = game:GetService("ReplicatedStorage").Remotes.RemoteFunction
        Event:InvokeServer(
          "Class"
        )
      end
		end)
	end
})


local DropdownLists = {}
for category, items in pairs(getgenv().AutoBuySpecials) do
  DropdownLists[category] = {}
  for name in pairs(items) do
    table.insert(DropdownLists[category], name)
  end
end
local Section = SpecialTab:Section({ 
  Title = "Stands Options",
})
SpecialTab:Dropdown({
  Title = "Select Stands",
  Desc = "Select the stands you want to get in the auto roll",
  Values = DropdownLists.Stands,
  Value = {},
  Flag = "SD",
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedStands = option
  end
})
local Toggle = SpecialTab:Toggle({
  Title = "Auto roll stands",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoRollS",
  Value = false,
  Callback = function(state)
    AutoStands = state
    if not AutoStands then return end

    task.spawn(function()
      while AutoStands do task.wait()
        local ownedValue = game.Players.LocalPlayer:WaitForChild("Specials"):FindFirstChild('Stands')
        if not ownedValue then return end
        for _, name in pairs(SelectedStands) do
          local id = getgenv().AutoBuySpecials['Stands'][name]
          if ownedValue.Value == id then
            WindUI:Notify({
              Title = "Auto Buy",
              Content = "Stands already owned: " .. name,
              Duration = 4,
              Icon = "bell-ring",
            })
            return
          end
        end
        game:GetService('ReplicatedStorage'):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("BuyContainer", "Stands", 1)
      end
    end)
  end
})
local Section = SpecialTab:Section({ 
  Title = "Quirks Options",
})
SpecialTab:Dropdown({
  Title = "Select Quirks",
  Desc = "Select the quirks you want to get in the auto roll",
  Values = DropdownLists.Quirks,
  Value = {},
  Flag = "QD",
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedQuirks = option
  end
})
local Toggle = SpecialTab:Toggle({
  Title = "Auto roll quirks",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoRollQ",
  Value = false,
  Callback = function(state)
    AutoQuirks = state
    if not AutoQuirks then return end

    task.spawn(function()
      while AutoQuirks do task.wait()
        local ownedValue = game.Players.LocalPlayer:WaitForChild("Specials"):FindFirstChild('Quirks')
        if not ownedValue then return end
        for _, name in pairs(SelectedQuirks) do
          local id = getgenv().AutoBuySpecials['Quirks'][name]
          if ownedValue.Value == id then
            WindUI:Notify({
              Title = "Auto Buy",
              Content = "Quirks already owned: " .. name,
              Duration = 4,
              Icon = "bell-ring",
            })
            return
          end
        end
        game:GetService('ReplicatedStorage'):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("BuyContainer", "Quirks", 1)
      end
    end)
  end
})
local Section = SpecialTab:Section({ 
  Title = "Kagunes Options",
})
SpecialTab:Dropdown({
  Title = "Select Kagunes",
  Desc = "Select the kagunes you want to get in the auto roll",
  Values = DropdownLists.Kagunes,
  Value = {},
  Flag = "KQ",
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedKagunes = option
  end
})
local Toggle = SpecialTab:Toggle({
  Title = "Auto roll kagunes",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoRollK",
  Value = false,
  Callback = function(state)
    AutoKagunes = state
    if not AutoKagunes then return end

    task.spawn(function()
      while AutoKagunes do task.wait()
        local ownedValue = game.Players.LocalPlayer:WaitForChild("Specials"):FindFirstChild('Kagunes')
        if not ownedValue then return end
        for _, name in pairs(SelectedKagunes) do
          local id = getgenv().AutoBuySpecials['Kagunes'][name]
          if ownedValue.Value == id then
            WindUI:Notify({
              Title = "Auto Buy",
              Content = "Kagunes already owned: " .. name,
              Duration = 4,
              Icon = "bell-ring",
            })
            return
          end
        end
        game:GetService('ReplicatedStorage'):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("BuyContainer", "Kagunes", 1)
      end
    end)
  end
})
local Section = SpecialTab:Section({ 
  Title = "Grimoires Options",
})
SpecialTab:Dropdown({
  Title = "Select Grimoires",
  Desc = "Select the grimoires you want to get in the auto roll",
  Values = DropdownLists.Grimoires,
  Value = {},
  Flag = "GD",
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedGrimoires = option
  end
})
local Toggle = SpecialTab:Toggle({
  Title = "Auto roll grimoires",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoRollG",
  Value = false,
  Callback = function(state)
    AutoGrimoires = state
    if not AutoGrimoires then return end

    task.spawn(function()
      while AutoGrimoires do task.wait()
        local ownedValue = game.Players.LocalPlayer:WaitForChild("Specials"):FindFirstChild('Grimoires')
        if not ownedValue then return end
        for _, name in pairs(SelectedGrimoires) do
          local id = getgenv().AutoBuySpecials['Grimoires'][name]
          if ownedValue.Value == id then
            WindUI:Notify({
              Title = "Auto Buy",
              Content = "Grimoires already owned: " .. name,
              Duration = 4,
              Icon = "bell-ring",
            })
            return
          end
        end
        game:GetService('ReplicatedStorage'):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("BuyContainer", "Grimoires", 1)
      end
    end)
  end
})
local Section = SpecialTab:Section({ 
  Title = "Bloodlines Options",
})
SpecialTab:Dropdown({
  Title = "Select Bloodlines",
  Desc = "Select the bloodlines you want to get in the auto roll",
  Values = DropdownLists.Bloodlines,
  Value = {},
  Flag = "BD",
  Multi = true,
  AllowNone = true,
  Callback = function(option)
    SelectedBloodlines = option
  end
})
local Toggle = SpecialTab:Toggle({
  Title = "Auto roll bloodlines",
  Icon = "check",
  Type = "Checkbox",
  Flag = "AutoRollB",
  Value = false,
  Callback = function(state)
    AutoBloodlines = state
    if not AutoBloodlines then return end

    task.spawn(function()
      while AutoBloodlines do task.wait()
        local ownedValue = game.Players.LocalPlayer:WaitForChild("Specials"):FindFirstChild('Bloodlines')
        if not ownedValue then return end
        for _, name in pairs(SelectedBloodlines) do
          local id = getgenv().AutoBuySpecials['Bloodlines'][name]
          if ownedValue.Value == id then
            WindUI:Notify({
              Title = "Auto Buy",
              Content = "Bloodlines already owned: " .. name,
              Duration = 4,
              Icon = "bell-ring",
            })
            return
          end
        end
        game:GetService('ReplicatedStorage'):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer("BuyContainer", "Bloodlines", 1)
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
local NPCQuestDropdown = TeleportTab:Dropdown({
  Title = "Quest NPC",
  Desc = "Select an NPC related to quests",
  Values = GetQuestNpc(),
  Value = "Boom",
  Flag = "NpcQuestTD",
  Callback = function(option)
    SelectedQNPC = option
  end
})
TeleportTab:Button({
  Title = "Teleport to Quest NPC",
  Locked = false,
  Callback = function()
    for _, v in pairs(workspace.Scriptable.NPC.Quest:GetChildren()) do
      if v:IsA("Model") and v.Name == SelectedQNPC then
        Teleport(v, 1, nil, nil, nil)
      end
    end
  end
})
local NPCChampionDropdown = TeleportTab:Dropdown({
  Title = "Champion NPC",
  Desc = "Select an NPC from the champions area",
  Values = GetChampionsNpc(),
  Value = "1",
  Flag = "NpcChampionTD",
  Callback = function(option)
    SelectedCNPC = option
  end
})
TeleportTab:Button({
  Title = "Teleport to Champion NPC",
  Locked = false,
  Callback = function()
    for _, v in pairs(workspace.Scriptable.NPC.Shops.Champions:GetChildren()) do
      if v:IsA("Model") and v.Name == SelectedCNPC then
        Teleport(v, 1, nil, nil, nil)
      end
    end
  end
})
local Dropdown = TeleportTab:Dropdown({
  Title = "Special NPC",
  Desc = "Select a special shop NPC",
  Values = { "Grimoires", "Kagunes", "Quirks", "Stands", "Bloodlines" },
  Value = "Grimoires",
  Flag = "NpcSpecialTD",
  AllowNone = true,
  Callback = function(option)
    SelectedSNPC = option
  end
})
TeleportTab:Button({
  Title = "Teleport to Special NPC",
  Locked = false,
  Callback = function()
    if SelectedSNPC == "Grimoires" then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Grimoires["1"], 1, nil, nil, nil)
    elseif SelectedSNPC == "Kagunes" then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Kagunes["1"], 1, nil, nil, nil)
    elseif SelectedSNPC == "Quirks" then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Quirks["1"], 1, nil, nil, nil)
    elseif SelectedSNPC == "Stands" then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Stands["1"], 1, nil, nil, nil)
    elseif SelectedSNPC == "Bloodlines" then
      Teleport(workspace.Scriptable.NPC.Shops.Special.Bloodlines["1"], 1, nil, nil, nil)
    end
  end
})
local Button = TeleportTab:Button({
  Title = "Refresh all dropdowns",
  Locked = false,
  Callback = function()
    NPCQuestDropdown:Refresh(GetQuestNpc())
    NPCChampionDropdown:Refresh(GetChampionsNpc())
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
  Flag = "TrainingD",
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
  Title = "Force map loading",
  Locked = false,
  Callback = function()
    Teleport(nil, 2, -7, 140, 4)
    wait(0.5)
    Teleport(nil, 2, 1565, 142, -143)
    wait(0.5)
    Teleport(nil, 2, 3584, 60, -1202)
    wait(0.5)
    Teleport(nil, 2, 3558, 60, 686)
    wait(0.5)
    Teleport(nil, 2, 265, 61, 1701)
    wait(0.5)
    Teleport(nil, 2, -54, 64, -1308)
    wait(0.5)
    Teleport(nil, 2, -1087, 61, 80)
    wait(0.5)
    Teleport(nil, 2, -20, 65, -136)
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
  Title = "Gacha Powers Teleport Options",
})
local Dropdown = TeleportTab:Dropdown({
  Title = "Select gacha powers",
  Desc = "Select the gacha you want to teleport",
  Values = { 'Jutsu Leveling', 'Nen Leveling', 'Soul Leveling', 'Nichiyin Leveling', 'Seiyen Leveling' },
  Value = "Jutsu Leveling",
  Flag = "GPDropdownB",
  Callback = function(option)
    SelectedGachaPowerTP = option
  end
})
TeleportTab:Button({
	Title = "Teleport selected gacha power",
	Callback = function(state)
    if SelectedGachaPowerTP == 'Jutsu Leveling' then
      Teleport(nil, 2, -14, 62, -449)
    elseif SelectedGachaPowerTP == 'Nen Leveling' then
      Teleport(nil, 2, -1094, 61, -133)
    elseif SelectedGachaPowerTP == 'Soul Leveling' then
      Teleport(nil, 2, 315, -154, -2081)
    elseif SelectedGachaPowerTP == 'Nichiyin Leveling' then
      Teleport(nil, 2, -343, 121, -1196)
    elseif SelectedGachaPowerTP == 'Seiyen Leveling' then
      Teleport(nil, 2, -2252, 618, 506)
    elseif SelectedGachaPowerTP == 'Hero Leveling' then
      Teleport(nil, 2, 1241, 141, -93)
    end
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
  Flag = "PlayersDropdownAB",
  AllowNone = true,
  Callback = function(option)
    SelectedPlayer = option
  end
})
local Toggle = TeleportTab:Toggle({
  Title = "Spectate player",
  Icon = "check",
  Type = "Checkbox",
  Flag = "SpectatePlayer",
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
      'SATURDAYBUGSPATCH',
      '175KLIKES',
      '200KLIKES',
      'SMALLCHIKARACODE',
      'BIGCHIKARACODE',
      'FIGHTINGPASS',
      'KURAMAUPDATE',
      'WednesdayYenCode',
      'WednesdayBoostsCode',
      'NewFridayYenCode',
      'NewFridayBoostsCode',
      'ThursdayYenNewCode',
      'ThursdayBoostsNewCode',
      'KuramaUpdateSoon',
      'BUGSPATCH4',
      'BUGSPATCH3',
      'BUGSPATCH2',
      'BUGSPATCH1',
      '50KFAVORITES',
      '125KLIKES',
      '25MVisits',
      'KURAMANEXTWEEK',
      '150KLIKES',
      'UPDATETHISWEEKEND',
      '100KLIKES',
      'NEWCHIKARACODE',
      'MORECHIKARA',
      'MOREYEN',
      'ALMOST100KKLIKES',
      '75KLIKES',
      'MinorBugs',
      'BadActors',
      'JanuaryIncident',
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
    }
    for _, v in pairs(codes) do
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("RemoteFunction"):InvokeServer(
        "Code",
        v
      )
      wait(1)
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
  Flag = "UnlockFPS",
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
local AntiAfkConn
local Toggle = MiscTab:Toggle({
	Title = "Anti Afk",
	Icon = "check",
	Type = "Checkbox",
  Flag = "AntiAFK",
	Value = false,
	Callback = function(state)
		AntiAfk = state
    if AntiAfk then
      local Players = game:GetService("Players")
      local VirtualUser = game:GetService("VirtualUser")
      local player = Players.LocalPlayer
      player.Idled:Connect(function()
          VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
          task.wait(1)
          VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
      end)
      if hookmetamethod then
        pcall(function()
          local mt = getrawmetatable(game)
          local oldNamecall = mt.__namecall
          local oldIndex = mt.__index
          setreadonly(mt, false)
          mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if self == LocalPlayer and (method == "Kick" or method == "kick") then
              return
            end
            return oldNamecall(self, ...)
          end)
          mt.__index = newcclosure(function(self, key)
            if self == LocalPlayer and (key == "Kick" or key == "kick") then
              return
            end
            return oldIndex(self, key)
          end)
          setreadonly(mt, true)

          local old
          old = hookmetamethod(game, "__namecall", function(self, ...)
            local args = {...}
            local method = getnamecallmethod()
            if method == "FireServer" and self.Name == "RemoteEvent" and args[1] == "AntiAfk" then
              return
            end
            return old(self, ...)
          end)
        end)
      end
      loadstring(game:HttpGet("https://raw.githubusercontent.com/hassanxzayn-lua/Anti-afk/main/antiafkbyhassanxzyn"))();
    end
	end
})
local Toggle = MiscTab:Toggle({
	Title = "Mobile Auto Clicker",
	Icon = "check",
	Type = "Checkbox",
  Flag = "AntiAFK",
	Value = false,
	Callback = function(state)
    AutoClicker = state
    if not AutoClicker then return end

    if AutoClicker then
      loadstring(game:HttpGet("https://raw.githubusercontent.com/rrixh/uwuware/main/Kustom/autoklicker-mobile_lulaslollipop",true))();
    end
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
  Locked = false,
})
local Dropdown = WebhookTab:Dropdown({
  Title = "Send a message if",
  Desc = "Select the method you want to send the message via the webhook",
  Values = {'A fruit spawned', 'A chikara boxes spawned', 'A champion collected', 'A mob boss drop', 'A boss power unlocked'},
  Value = "",
  Flag = "WebhookDropdown",
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
  Flag = "WebhookReport",
  Value = false,
  Callback = function(state)
    Webhook = state

    if Webhook and WEBHOOK_URL == "" then
      WindUI:Notify({
        Title = "Webhook Notification",
        Content = "Please, enter a webhook url first",
        Duration = 4,
        Icon = "bell-ring",
      })
      return
    end

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
            footer = { text = "InfinityX • Fruit Tracker" },
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
          footer = { text = "InfinityX • Chikara Box System" },
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

      elseif SelectedMethodToNotify == 'A champion collected' then
        if ChampionConnection then ChampionConnection:Disconnect() end
        local AutoChampion = getgenv().AutoSellChampionsSettings.Enabled
        SendWebhook({
          title = "👑 Auto Roll Champions Stats",
          color = AutoChampion and 0xF1C40F or 0xE74C3C,
          fields = {
            { name = "Status", value = tostring(AutoChampion), inline = true },
            { name = "System", value = "Champion Roll", inline = true },
            { name = "Player", value = LocalPlayer.Name, inline = true },
            { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
            { name = "JobId", value = game.JobId, inline = false }
          },
          footer = { text = "InfinityX • Champion System" },
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })

        ChampionConnection = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List.DescendantAdded:Connect(function(v)
            if not Webhook then return end
            if not v:IsA("TextLabel") or v.Name ~= "ChampionName" then return end
            for _, n in ipairs(SelectedChampionsToRoll) do
              if v.Text == n then
                SendWebhook({
                  title = "🏆 Champion Collected",
                  color = 0x2ECC71,
                  fields = {
                    { name = "Champion Name", value = v.Text, inline = true },
                    { name = "Collected By", value = LocalPlayer.Name, inline = true },
                    { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
                    { name = "Server JobId", value = game.JobId, inline = false }
                  },
                  footer = { text = "InfinityX • Champion Roll Tracker" },
                  timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                })
                break
              end
            end
        end)

      elseif SelectedMethodToNotify == 'A mob boss drop' then
        if BossConnection then BossConnection:Disconnect() end

        SendWebhook({
          title = "💀 Auto Farm Boss Stats",
          color = AutoFarmMob and 0x2ECC71 or 0xE74C3C,
          fields = {
            { name = "Status", value = tostring(AutoFarmMob), inline = true },
            { name = "System", value = "Boss Drop", inline = true },
            { name = "Player", value = LocalPlayer.Name, inline = true },
            { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
            { name = "JobId", value = game.JobId, inline = false }
          },
          footer = { text = "InfinityX • Boss System" },
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })

        BossConnection = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Champions.Container.List.DescendantAdded:Connect(function(v)
          if not Webhook then return end
          if not v:IsA("TextLabel") or v.Name ~= "ChampionName" then return end
          if v.Text == "Riru" or v.Text == "Paien" then
            SendWebhook({
              title = "🔥 Boss Drop Collect",
              color = 0xE67E22,
              fields = {
                { name = "Boss", value = v.Text, inline = true },
                { name = "Collected By", value = LocalPlayer.Name, inline = true },
                { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
                { name = "Server JobId", value = game.JobId, inline = false }
              },
              footer = { text = "InfinityX • Boss Drop Tracker" },
              timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
            })
          end
        end)

      elseif SelectedMethodToNotify == 'A boss power unlocked' then
        if BossDropConnection then BossDropConnection:Disconnect() end

        SendWebhook({
          title = "💀 Unlocked Boss Power Stats",
          color = AutoKurama and 0x2ECC71 or 0xE74C3C,
          fields = {
            { name = "Status", value = tostring(AutoKurama), inline = true },
            { name = "System", value = "Boss Drop", inline = true },
            { name = "Player", value = LocalPlayer.Name, inline = true },
            { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
            { name = "PlaceId", value = tostring(game.PlaceId), inline = true },
            { name = "JobId", value = game.JobId, inline = false }
          },
          footer = { text = "InfinityX • Boss System" },
          timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
        })

        BossDropConnection = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Boss.Container.Power.Amount:GetPropertyChangedSignal('TextColor3'):Connect(function(v)
          if not Webhook then return end
          SendWebhook({
            title = "🔥 Boss Power Drop Collect",
            color = 0xE67E22,
            fields = {
              { name = "Power", value = game:GetService("Players").LocalPlayer.PlayerGui.Main.Frames.Boss.Container.Power.Amount.Text, inline = true },
              { name = "Collected By", value = LocalPlayer.Name, inline = true },
              { name = "UserId", value = tostring(LocalPlayer.UserId), inline = true },
              { name = "Server JobId", value = game.JobId, inline = false }
            },
            footer = { text = "InfinityX • Boss Power Drop Tracker" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
          })
        end)
      end
    end)
  end
})


local Section = ConfigTab:Section({
  Title = "Save Configuration",
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
-- ConfigTab:Space()
-- local AutoLoadToggle = ConfigTab:Toggle({
--   Title = "Enable Auto Load to Selected Config",
--   Value = false,
--   Callback = function(v)
--     local cfg = ConfigManager:GetConfig(ConfigName)
--     if cfg then
--       cfg:SetAutoLoad(v)
--     end
--   end
-- })
ConfigTab:Space()
local function RefreshConfigs()
  local all = ConfigManager:AllConfigs()
  AllConfigsDropdown:Refresh(all)
end
local AllConfigs = ConfigManager:AllConfigs()
local DefaultValue = table.find(AllConfigs, ConfigName) and ConfigName or nil
AllConfigsDropdown = ConfigTab:Dropdown({
  Title = "All Configs",
  Desc = "Select existing configs",
  Values = AllConfigs,
  Value = DefaultValue,
  Callback = function(value)
    ConfigName = value
    ConfigNameInput:Set(value)

    local cfg = ConfigManager:GetConfig(value)
    AutoLoadToggle:Set(cfg and cfg.AutoLoad or false)
  end
})
ConfigTab:Space()
ConfigTab:Button({
  Title = "Load Config",
  Justify = "Center",
  Callback = function()
    local cfg = ConfigManager:CreateConfig(ConfigName)
    if cfg:Load() then
      Window.CurrentConfig = cfg
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
  Title = "Save Config",
  Justify = "Center",
  Callback = function()
    local cfg = ConfigManager:Config(ConfigName)
    if cfg:Save() then
      WindUI:Notify({
        Title = "Config Saved",
        Desc = "Config '" .. ConfigName .. "' saved",
        Icon = "check",
      })
    end
    RefreshConfigs()
  end
})
ConfigTab:Space()
ConfigTab:Button({
  Title = "Print AutoLoad Configs",
  Justify = "Center",
  Callback = function()
    print(HttpService:JSONDecode(ConfigManager:GetAutoLoadConfigs()))
  end
})
ConfigTab:Section({
  Title = "Join our Discord server!",
  TextSize = 20,
})
ConfigTab:Paragraph({
  Title = "infinityx script development",
  Desc = "The server of the creator of InfinityX and anothers Projects.\nBy lmy77",
  Buttons = {
    {
      Title = "Copy link",
      Icon = "link",
      Callback = function()
        setclipboard("https://discord.gg/emKJgWMHAr")
      end
    }
  }
})
