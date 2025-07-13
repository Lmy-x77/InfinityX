-- detect service
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	print("Mobile device")
elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
	print("Computer device")
end



-- start
local Event = game:GetService("ReplicatedStorage").Remotes.Notification_Universal_Top
firesignal(Event.OnClientEvent,
    "Loading script...",
    game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.NPC_TravelingMerchant
)
wait(.5)
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
local DigFarmSettings = {
  InstantDelay = 0.5,
  NormalDelay = 2,
  LegitDelay = 1,
}
function TeleportTo(Model, modelPath, Part, partPath, Pos, x, y, z)
  if Model then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = modelPath:FindFirstChild('PrimaryPart').CFrame
  end
  if Part then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = partPath.CFrame
  end
  if Pos then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(x, y, z)
  end
end
local function keysOf(dict)
  local list = {}
  for k, v in pairs(dict) do
    if v then
      table.insert(list, k)
    end
  end
  return list
end
function GetPurchasable()
  local PurcheShovels = {}
  local seenNames = {}

  for _, v in pairs(workspace.World.Interactive.Purchaseable:GetChildren()) do
    if v:IsA('Model') and v.Name:lower():find('shovel') then
      local shovelName = v.Name
      if not seenNames[shovelName] then
        table.insert(PurcheShovels, shovelName)
        seenNames[shovelName] = true
      end
    end
  end

  return PurcheShovels
end
function GetNPCs()
  local NpcsFinder = {}
  local NpcsName = {}

  for _, v in pairs(workspace.World.NPCs:GetChildren()) do
    if v:IsA('Model') then
      local npcName = v.Name
      if not NpcsName[npcName] then
        table.insert(NpcsFinder, npcName)
        NpcsName[npcName] = true
      end
    end
  end

  return NpcsFinder
end
function EquipShovel()
  for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA('Tool') and v.Name:lower():find('shovel') then
      local Event = game:GetService("ReplicatedStorage").Remotes.Backpack_Equip
      Event:FireServer(
        v
      )
    end
  end
end
function UnnequipShovel()
  for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
    if v:IsA('Tool') and v.Name:lower():find('shovel') then
      local Event = game:GetService("ReplicatedStorage").Remotes.Backpack_Equip
      Event:FireServer(
        v
      )
    end
  end
end
local function FireShovel()
  for i,v in pairs (game.Players.LocalPlayer.Character:GetChildren()) do
    if v.Name:lower():find('shovel') then
      v:Activate()
    end
  end
end
function EnableUi()
  if game:GetService("Players").LocalPlayer.PlayerGui.HUD.Enabled == false then
    game:GetService("Players").LocalPlayer.PlayerGui.HUD.Enabled = true
  end
  if game:GetService("Players").LocalPlayer.PlayerGui.Backpack.Enabled == false then
    game:GetService("Players").LocalPlayer.PlayerGui.Backpack.Enabled = true
    game:GetService("Players").LocalPlayer.PlayerGui.Backpack.Backpack.Visible = true
  end
end
function Instant()
  local Event = game:GetService("ReplicatedStorage").Remotes.Dig_Finished
  Event:FireServer(
    0,
    {{}}
  )
end
function GetBosses()
  local bossName = {}
  for _, v in pairs(game:GetService("ReplicatedStorage").Resources.Gameplay.Bosses:GetChildren()) do
    if v:IsA('Model') then
      table.insert(bossName, v.Name)
    end
  end
  return bossName
end
function GetCars()
  local carsName = {}
  for _, v in pairs(game:GetService("ReplicatedStorage").PlayerItems.Vehicles:GetChildren()) do
    if v:IsA('Folder') then
      table.insert(carsName, v.Name)
    end
  end
  return carsName
end
if not bypassed then
  if hookmetamethod and getnamecallmethod and hookfunction then
    pcall(function()
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/Dig/Bypass/source.lua",true))()
    end)

    local Event = game:GetService("ReplicatedStorage").Remotes.Notification_Universal_Top
    firesignal(Event.OnClientEvent,
        "<font color = '#03fc13'>Sucess:</font> Bypass in execution",
        game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.NPC_TravelingMerchant
    )
    wait(1.2)

  else

    local Event = game:GetService("ReplicatedStorage").Remotes.Notification_Universal_Top
    firesignal(Event.OnClientEvent,
        "<font color = '#fc3a4a'>Error:</font> Your exploit does not support bypassing",
        game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.NPC_TravelingMerchant
    )
    print('Your exploit does not support bypassing')
    wait(1.2)
  end
elseif bypassed then
  firesignal(Event.OnClientEvent,
  "<font color = '#03fc13'>Sucess:</font> Bypass already applied",
  game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.NPC_TravelingMerchant
  )
  print('Bypass already applied')
end
pcall(function() getgenv().bypassed = true end)
local Event = game:GetService("ReplicatedStorage").Remotes.Notification_Universal_Top
firesignal(Event.OnClientEvent,
    "Script loaded successfully!",
    game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.NPC_TravelingMerchant
)
wait(.5)
scriptVersion = '4.2a'



-- ui library
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()

function getDpiScale()
    if IsOnMobile then
        return Library:SetDPIScale(75)
    elseif not IsOnMobile then
        Library:SetDPIScale(100)
    end
end
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = true

local Window = Library:CreateWindow({
  Title = "InfinityX",
  Footer = "Dig · ".. scriptVersion .. " · discord.gg/emKJgWMHAr",
  Icon = 126527122577864,
  NotifySide = "Right",
  ShowCustomCursor = false,
  Center = true,
  MobileButtonsSide = "Left",
  Resizable = false,
  Size = UDim2.fromOffset(650, 410),
  ToggleKeybind = Enum.KeyCode.K
})



-- tabs
local Tabs = {
  Farm = Window:AddTab("Farming", "banknote"),
  Transport = Window:AddTab("Transport", "locate"),
  Misc = Window:AddTab("Misc", "layers"),
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local DigGroupBox = Tabs.Farm:AddLeftGroupbox("Dig", "shovel")
local DigSettingsGroupBox = Tabs.Farm:AddRightGroupbox("Dig Settings", "settings")
local TeleportGroupBox = Tabs.Farm:AddLeftGroupbox("Teleport", "locate")
DigGroupBox:AddDropdown("", {
	Values = {'Legit', 'Normal', 'Instant'},
	Default = '...',
	Multi = false,

	Text = "Select mode",
	Tooltip = "Select a mode to dig",
	DisabledTooltip = "I am disabled!",

	Searchable = false,

	Callback = function(Value)
    selectedMode = Value
	end,

	Disabled = false,
	Visible = true,
})
DigGroupBox:AddToggle("", {
  Text = "Auto dig",
  Tooltip = 'Activate to dig automatically',
  Default = false,
  Callback = function(Value)
    autoDigToggle = Value
    if autoDigToggle then
      Library:Notify({
        Title = "InfinityX",
        Description = "Auto dig enabled",
        Time = 4,
      })
    else
      UnnequipShovel()
    end
    while autoDigToggle do task.wait()
      if selectedMode == 'Legit' then
        local digUi = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Dig")
        if not digUi then
          EquipShovel() wait(1) FireShovel()
        elseif digUi then
          for _, v in pairs(digUi:GetDescendants()) do
            if v:IsA('Frame') and v.Name == 'Holder' then
              local PlayerBar = v:FindFirstChild('PlayerBar')
              local AreaStrong = v:FindFirstChild('Area_Strong')
              if PlayerBar and AreaStrong then
                PlayerBar.Position = AreaStrong.Position
                FireShovel()
                task.wait(DigFarmSettings.LegitDelay)
              end
            end
          end
        end
      elseif selectedMode == 'Normal' then
        local digUi = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Dig")
        if not digUi then
          EquipShovel() wait(1) FireShovel()
        elseif digUi then
          for _, v in pairs(digUi:GetDescendants()) do
            if v:IsA('Frame') and v.Name == 'Holder' then
              local PlayerBar = v:FindFirstChild('PlayerBar')
              local Area_Hit = v:FindFirstChild('Area_Hit')

              if PlayerBar and Area_Hit then
                local pbCenter = PlayerBar.AbsolutePosition.X + PlayerBar.AbsoluteSize.X / 2
                local ahStart = Area_Hit.AbsolutePosition.X
                local ahEnd = ahStart + Area_Hit.AbsoluteSize.X

                if pbCenter >= ahStart and pbCenter <= ahEnd then
                  FireShovel()
                  wait(DigFarmSettings.NormalDelay)
                  Instant()
                end
              end
            end
          end
        end
      elseif selectedMode == 'Instant' then
        local digUi = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Dig")
        if not digUi then
          EquipShovel() wait(1) FireShovel()
        elseif digUi then
          for _, v in pairs(digUi:GetDescendants()) do
            if v:IsA('Frame') and v.Name == 'Holder' then
              local PlayerBar = v:FindFirstChild('PlayerBar')
              local Area_Hit = v:FindFirstChild('Area_Hit')

              if PlayerBar and Area_Hit then
                wait(DigFarmSettings.InstantDelay)
                Instant()
              end
            end
          end
        end
      end
    end
  end
})
DigGroupBox:AddToggle("", {
  Text = "Auto walk",
  Tooltip = 'Activate to walk in a random direction',
  Default = false,
  Callback = function(Value)
    autoWalk = Value
    local humanoid = game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")
    local hrp = humanoid.Parent:WaitForChild("HumanoidRootPart")

    while autoWalk do
      if autoWalk then
        local offset = Vector3.new(math.random(-10, 10), 0, math.random(-10, 10))
        local newPos = hrp.Position + offset
        humanoid:MoveTo(newPos)
      end
      task.wait(2)
    end
  end
})
DigGroupBox:AddToggle("", {
  Text = "Auto sell",
  Tooltip = 'Activate to sell all yours items automatically',
  Default = false,
  Callback = function(Value)
    autoSell = Value
    if autoSell then
      Library:Notify({
        Title = "InfinityX",
        Description = "Auto sell enabled",
        Time = 4,
      })
      local sellNpc = workspace.World.NPCs:FindFirstChild('Rocky')
      if not sellNpc then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2120, 112, -315)
        local findNpc = workspace.World.NPCs:WaitForChild('Rocky')
        if findNpc then
          for i = 1, 10 do
            local Event = game:GetService("ReplicatedStorage").DialogueRemotes.SellAllItems
            Event:FireServer(
              workspace.World.NPCs.Rocky
            )
          end
        end
      elseif sellNpc then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(2120, 112, -315)
        wait(2)
        for i = 1, 10 do
          local Event = game:GetService("ReplicatedStorage").DialogueRemotes.SellAllItems
          Event:FireServer(
            workspace.World.NPCs.Rocky
          )
        end
      end
    end
  end
})
DigSettingsGroupBox:AddInput("MyTextbox", {
  Default = "0.5",
  Numeric = true,
  Finished = false,
  ClearTextOnFocus = false,

  Text = "Instant delay",
  Placeholder = "0.5",

  Callback = function(Value)
    DigFarmSettings.InstantDelay = tonumber(Value) or 0.5
  end,
})
DigSettingsGroupBox:AddInput("MyTextbox", {
  Default = "2",
  Numeric = true,
  Finished = false,
  ClearTextOnFocus = false,

  Text = "Normal delay",
  Placeholder = "2",

  Callback = function(Value)
    DigFarmSettings.NormalDelay = tonumber(Value) or 2
  end,
})
DigSettingsGroupBox:AddInput("MyTextbox", {
  Default = "1",
  Numeric = true,
  Finished = false,
  ClearTextOnFocus = false,

  Text = "Legit delay",
  Placeholder = "1",

  Callback = function(Value)
    DigFarmSettings.LegitDelay = tonumber(Value) or 1
  end,
})
DigSettingsGroupBox:AddToggle("NotifyItemsToggle", {
  Text = "Notifies new item",
  Tooltip = 'Shows the new items added to your inventory',
  Default = false,
  Callback = function(Value)
    notifyItem = Value
    game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(Item)
      if Item:IsA('Tool') and notifyItem then
        Library:Notify({
          Title = "InfinityX",
          Description = "New item added: " .. Item.Name,
          Time = 4,
        })
      end
    end)
  end
})
DigSettingsGroupBox:AddToggle("EnableUiToggle", {
  Text = "Auto show hud",
  Tooltip = 'Activate to show hud even when disabled',
  Default = false,
  Callback = function(Value)
    enableUi = Value
    while enableUi do task.wait()
      EnableUi()
    end
  end
})
TeleportGroupBox:AddButton({
	Text = "Save positon",
	Func = function()
    savedPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
	end,
	DoubleClick = false,

	Tooltip = "Click to save your current position",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
TeleportGroupBox:AddButton({
	Text = "Teleport to saved position",
	Func = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPos)
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to saved position",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})


local BossesGroupBox = Tabs.Transport:AddLeftGroupbox("Bosses", "angry")
local AreasGroupBox = Tabs.Transport:AddRightGroupbox("Areas", "land-plot")
local PurchasablesGroupBox = Tabs.Transport:AddLeftGroupbox("Purchasables", "store")
local NPCsGroupBox = Tabs.Transport:AddRightGroupbox("NPCs", "users")
local EnchantmentGroupBox = Tabs.Transport:AddLeftGroupbox("Enchantment", "sparkles")
local DeliveryGroupBox = Tabs.Transport:AddRightGroupbox("Delivery", "pizza")
BossesGroupBox:AddDropdown("", {
	Values = GetBosses(),
	Default = '...',
	Multi = true,

	Text = "Select boss",
	Tooltip = "Select a boss you want to farm",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedBoss = keysOf(Value)
	end,

	Disabled = false,
	Visible = true,
})
BossesGroupBox:AddToggle("EnableUiToggle", {
  Text = "Auto teleport boss",
  Tooltip = 'Activate to teleport to selected boss',
  Default = false,
  Callback = function(Value)
    autoBoss = Value
    while autoBoss do task.wait()
      if #selectedBoss > 0 then
        for _, bossName in ipairs(selectedBoss) do
          for _, v in pairs(workspace.World.Zones:GetDescendants()) do
            if v.Name:find(bossName) then
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position)
            end
          end
        end
      end
    end
  end
})
BossesGroupBox:AddToggle("EnableUiToggle", {
  Text = "Auto hit boss",
  Tooltip = 'Activate to teleport to selected boss',
  Default = false,
  Callback = function(Value)
    autoBoss = Value
    while autoBoss do task.wait()
      if #selectedBoss > 0 then
        for _, bossName in ipairs(selectedBoss) do
          for _, v in pairs(workspace.World.Zones:GetDescendants()) do
            if v.Name:find(bossName) then
              EquipShovel()
              local Event = game:GetService("ReplicatedStorage").Remotes.Dig_Boss_OnHit
              Event:FireServer(
                true
              )
            end
          end
        end
      end
    end
  end
})
BossesGroupBox:AddButton({
	Text = "Remove boss VFX",
	Func = function()
    for _, v in pairs(game:GetService("ReplicatedStorage").ClientManagers.BossRenderer.AttacksClient:GetChildren()) do
      if v:IsA('ModuleScript') then
        local mscript = require(v)
        for _, func in pairs(mscript) do
          if type(func) == 'function' then
            hookfunction(func, function(...) return nil end)
          end
        end
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to remove all boss visual effects and attacks",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
AreasGroupBox:AddDropdown("", {
	Values = {'Alona Jungle', 'Azure Hallow', 'Boss Area (Molten Monstrosity)', 'Cinder Approach', 'Cinder Cavern', 'Cinder Shores', 'Combat Guild', 'Copper Mesa', 'Fernhill Forest', 'Fox Town', 'Glacial Cavern', 'Jail Cells', 'Monks Workshop', 'Mount Charcoal', 'Mount Cinder', 'Npc (Sydney)', 'Penguins Pizza', 'Phoenix Tribe', 'Rooftop Woodlands', 'Saltys Saloon', 'Solstice Shrine', 'Sovering Chasm', 'Spiders Keep', 'The Interlude', 'Tom Bakery', 'Verdant Vale', 'Volcano'},
	Default = '...',
	Multi = false,

	Text = "Select area",
	Tooltip = "Select a area you want to teleport",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedArea = Value
	end,

	Disabled = false,
	Visible = true,
})
AreasGroupBox:AddButton({
	Text = "Teleport to selected area",
	Func = function()
    if selectedArea == 'Alona Jungle' then
      TeleportTo(false, nil, false, nil, true, -7660, 342, -2302)
    elseif selectedArea == 'Azure Hallow' then
      TeleportTo(false, nil, false, nil, true, 4050, -668, 2473)
    elseif selectedArea == 'Boss Area (Molten Monstrosity)' then
      TeleportTo(false, nil, false, nil, true,-8797, 436, -1919)
    elseif selectedArea == 'Cinder Approach' then
      TeleportTo(false, nil, false, nil, true, 5063, 226, -303)
    elseif selectedArea == 'Cinder Cavern' then
      TeleportTo(false, nil, false, nil, true, 2805, 6, -905)
    elseif selectedArea == 'Cinder Shores' then
      TeleportTo(false, nil, false, nil, true, 1474, 77, 238)
    elseif selectedArea == 'Combat Guild' then
      TeleportTo(false, nil, false, nil, true, 2508, 82, 1285)
    elseif selectedArea == 'Copper Mesa' then
      TeleportTo(false, nil, false, nil, true, -5867, 78, -2416)
    elseif selectedArea == 'Fornhill Forest' then
      TeleportTo(false, nil, false, nil, true, 2117, 82, 7)
    elseif selectedArea == 'Fox Town' then
      TeleportTo(false, nil, false, nil, true, 2076, 112, -360)
    elseif selectedArea == 'Glacial Cavern' then
      TeleportTo(false, nil, false, nil, true, 4896, 1121, -2730)
    elseif selectedArea == 'Jail Cells' then
      TeleportTo(false, nil, false, nil, true, -374, -282, -1449)
    elseif selectedArea == 'Monks Workshop' then
      TeleportTo(false, nil, false, nil, true, 4540, -360, -1618)
    elseif selectedArea == 'Mount Charcoal' then
      TeleportTo(false, nil, false, nil, true, -8240, 341, -1978)
    elseif selectedArea == 'Mount Cinder' then
      TeleportTo(false, nil, false, nil, true, 4626, 1099, -1536)
    elseif selectedArea == 'Npc (Sydney)' then
      TeleportTo(false, nil, false, nil, true, 763, 266, 652)
    elseif selectedArea == 'Penguins Pizza' then
      TeleportTo(false, nil, false, nil, true, 4206, 1191, -4362)
    elseif selectedArea == 'Phoenix Tribe' then
      TeleportTo(false, nil, false, nil, true, -7947, 342, -1834)
    elseif selectedArea == 'Rooftop Woodlands' then
      TeleportTo(false, nil, false, nil, true, 4278, 226, -154)
    elseif selectedArea == 'Saltys Saloon' then
      TeleportTo(false, nil, false, nil, true, -6117, 116, -1950)
    elseif selectedArea == 'Solstice Shrine' then
      TeleportTo(false, nil, false, nil, true, 5316, -422, -1943)
    elseif selectedArea == 'Sovering Chasm' then
      TeleportTo(false, nil, false, nil, true, -7015, 106, -1759)
    elseif selectedArea == 'Spiders Keep' then
      TeleportTo(false, nil, false, nil, true, 3681, -360, -2572)
    elseif selectedArea == 'The Interlude' then
      TeleportTo(false, nil, false, nil, true, 2748, -1168, 248)
    elseif selectedArea == 'Tom Bakery' then
      TeleportTo(false, nil, false, nil, true, 5587, 250, -81)
    elseif selectedArea == 'Verdant Vale' then
      TeleportTo(false, nil, false, nil, true, 3780, 82, 1609)
    elseif selectedArea == 'Volcano' then
      TeleportTo(false, nil, false, nil, true, -8183, 342, -1994)
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to selected area",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
PurchasablesGroupBox:AddDropdown("PurchasebleDropdown", {
	Values = GetPurchasable(),
	Default = '...',
	Multi = false,

	Text = "Select purchasable",
	Tooltip = "Select a purchasable you want to buy",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedPurchasable = Value
	end,

	Disabled = false,
	Visible = true,
})
PurchasablesGroupBox:AddButton({
	Text = "Teleport to purchasable",
	Func = function()
    for _, v in pairs(workspace.World.Interactive.Purchaseable:GetChildren()) do
      if v:IsA('Model') and v.Name == selectedPurchasable then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.WorldPivot.Position)
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to selected purchasable",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
NPCsGroupBox:AddDropdown("", {
	Values = GetNPCs(),
	Default = '...',
	Multi = false,

	Text = "Select npc",
	Tooltip = "Select a npc you want to teleport",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedNpc = Value
	end,

	Disabled = false,
	Visible = true,
})
NPCsGroupBox:AddButton({
	Text = "Teleport to npc",
	Func = function()
    for _, v in pairs(workspace.World.NPCs:GetChildren()) do
      if v:IsA('Model') and v.Name == selectedNpc then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.WorldPivot.Position)
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to selected npc",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
EnchantmentGroupBox:AddButton({
	Text = "Teleport to altar",
	Func = function()
    TeleportTo(false, nil, false, nil, true, 4148, -669, 2551)
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to selected npc",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
DeliveryGroupBox:AddToggle("EnableUiToggle", {
  Text = "Auto event",
  Tooltip = 'Activate to complete event automatically',
  Default = false,
  Callback = function(Value)
    autoEvent = Value

    local back = false
    local start = true
    if not autoEvent then
      back = false
      start = true
    end
    while autoEvent do task.wait()
      if not autoEvent then return end
      local findCostumer = workspace.Active.PizzaCustomers:FindFirstChildWhichIsA('Model')
      if (not findCostumer or start) and not back then
        for _, v in pairs(workspace.World.NPCs:GetChildren()) do
          if v:IsA('Model') and v.Name == 'Pizza Penguin' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.WorldPivot.Position)

            local h1 = v:WaitForChild('HumanoidRootPart')
            if h1 then
              wait(2)
              local Event = game:GetService("ReplicatedStorage").DialogueRemotes.StartInfiniteQuest
              Event:InvokeServer(
                "Pizza Penguin"
              )
              start = false
            end
          end
        end
      elseif findCostumer and not back and not start then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(findCostumer.WorldPivot.Position)

        local h2 = findCostumer:WaitForChild('HumanoidRootPart')
        if h2 then
          wait(2)
          local Event = game:GetService("ReplicatedStorage").Remotes.Quest_DeliverPizza
          Event:InvokeServer()
          wait(.2)
          back = true
        end
      end
      if back and not start then
        for _, v in pairs(workspace.World.NPCs:GetChildren()) do
          if v:IsA('Model') and v.Name == 'Pizza Penguin' then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.WorldPivot.Position)

            local h3 = v:WaitForChild('HumanoidRootPart')
            if h3 then
              wait(2)
              local Event = game:GetService("ReplicatedStorage").DialogueRemotes.CompleteInfiniteQuest
              Event:InvokeServer(
                "Pizza Penguin"
              )
              back = false
              start = true
            end
          end
        end
      end
    end
  end
})


local CodesGroupBox = Tabs.Misc:AddLeftGroupbox("Codes", "code")
local CharacterGroupBox = Tabs.Misc:AddRightGroupbox("Character", "user-round-pen")
local VehicleGroupBox = Tabs.Misc:AddLeftGroupbox("Vehicles", "car")
local MerchantGroupBox = Tabs.Misc:AddLeftGroupbox("Merchant", "sparkle")
local MagnetGroupBox = Tabs.Misc:AddRightGroupbox("Magnets", "magnet")
CodesGroupBox:AddButton({
	Text = "Reedem all codes",
	Func = function()
    local validCodes = {'release', 'evilcode', 'plsdevshovel'}
    for _, v in pairs(validCodes) do
      local Event = game:GetService("ReplicatedStorage").Remotes.Complete_Code
      Event:InvokeServer(
        v
      )
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to reedem all codes",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
if not IsOnMobile then
  CharacterGroupBox:AddSlider("MySlider", {
    Text = "WalkSpeed",
    Default = 16,
    Min = 16,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    end,

    Tooltip = "Chence your walkspeed",
    DisabledTooltip = "I am disabled!",

    Disabled = false,
    Visible = true,
  })
  CharacterGroupBox:AddSlider("MySlider", {
    Text = "JumpPower",
    Default = 50,
    Min = 50,
    Max = 500,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
      game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    end,

    Tooltip = "Chence your jumppower",
    DisabledTooltip = "I am disabled!",

    Disabled = false,
    Visible = true,
  })
elseif IsOnMobile then
  CharacterGroupBox:AddInput("MyTextbox", {
      Default = "",
      Numeric = true,
      Finished = false,
      ClearTextOnFocus = false,

      Text = "WalkSpeed",
      Placeholder = "16",

      Callback = function(Value)
          game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
      end,
  })
  CharacterGroupBox:AddInput("MyTextbox", {
      Default = "",
      Numeric = true,
      Finished = false,
      ClearTextOnFocus = false,

      Text = "JumpPower",
      Placeholder = "50",

      Callback = function(Value)
          game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
      end,
  })
end
CharacterGroupBox:AddDivider()
CharacterGroupBox:AddButton("Reset character", function()
  game.Players.LocalPlayer.Character:BreakJoints()
end)
CharacterGroupBox:AddButton("No water damage", function()
  local Event = game:GetService("ReplicatedStorage").Remotes.Player_Damage_FromClient
  local hook
  hook = hookmetamethod(game, "__namecall", function(self, ...)
    if not checkcaller() and self == Event and getnamecallmethod() == "FireServer" then
      return nil
    end
    return hook(self, ...)
  end)
end)
CharacterGroupBox:AddButton("Rejoin smallest server", function()
  Library:Notify({
    Title = "InfinityX",
    Description = "Rejoining server...",
    Time = 4,
  })
  wait(0.5)
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
end)
CharacterGroupBox:AddToggle("EnableUiToggle", {
  Text = "Anti afk",
  Tooltip = 'Activate to teleport to selected boss',
  Default = false,
  Callback = function(Value)
    afk = Value
    if afk then
      local VirtualUser = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      end)
    end
  end
})
VehicleGroupBox:AddDropdown("", {
	Values = GetCars(),
	Default = '...',
	Multi = false,

	Text = "Select car",
	Tooltip = "Select a car you want to buy",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedCar = Value
	end,

	Disabled = false,
	Visible = true,
})
VehicleGroupBox:AddButton("Buy selected car", function()
  local Event = game:GetService("ReplicatedStorage").Remotes.Vehicle_Purchase
  Event:InvokeServer(
    selectedCar
  )
end)
VehicleGroupBox:AddButton("Spawn selected car", function()
  local Event = game:GetService("ReplicatedStorage").Remotes.Vehicle_Spawn
  Event:FireServer(
    selectedCar,
    workspace.World.NPCs["Ava Carter"].HumanoidRootPart,
    {}
  )
end)
VehicleGroupBox:AddButton("Teleport to amy", function()
  TeleportTo(false, nil, false, nil, true, 2020, 112, -348)
end)
MerchantGroupBox:AddButton({
	Text = "Teleport traveling merchant",
	Func = function()
    for _, v in pairs(workspace.World.NPCs:GetChildren()) do
      if v:IsA('Model') and v.Name == 'Merchant Cart' then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v:FindFirstChild('Traveling Merchant').WorldPivot.Position)
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to traveling merchant",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
MagnetGroupBox:AddButton({
	Text = "Teleport to magnus",
	Func = function()
    for _, v in pairs(workspace.World.NPCs:GetChildren()) do
      if v:IsA('Model') and v.Name == 'Magnus' then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.WorldPivot.Position)
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to traveling merchant",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})


local UiSettingsGroubBox = Tabs.Settings:AddLeftGroupbox("Ui Settings", "brush")
local CreditsGroupBox = Tabs.Settings:AddRightGroupbox("Credits", "scroll-text")
UiSettingsGroubBox:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
if IsOnMobile then
    UiSettingsGroubBox:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "75%",

        Text = "DPI Scale",

        Callback = function(Value)
            Value = Value:gsub("%%", "")
            local DPI = tonumber(Value)

            Library:SetDPIScale(DPI)
        end,
    })
elseif not IsOnMobile then
    UiSettingsGroubBox:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "100%",

        Text = "DPI Scale",

        Callback = function(Value)
            Value = Value:gsub("%%", "")
            local DPI = tonumber(Value)

            Library:SetDPIScale(DPI)
        end,
    })
end
UiSettingsGroubBox:AddDivider()
UiSettingsGroubBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "K", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind
UiSettingsGroubBox:AddButton("Unload", function()
	Library:Unload()
end)
CreditsGroupBox:AddLabel("Script made by Lmy77")
CreditsGroupBox:AddButton("Discor server", function()
	setclipboard("https://discord.gg/emKJgWMHAr")
    Library:Notify({
        Title = "InfinityX",
        Description = "Discord server copied to clipboard",
        Time = 4,
    })
end)



-- extra functions
getDpiScale()
game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.Boss_Alert.Volume = 6
local Event = game:GetService("ReplicatedStorage").Remotes.Notification_Universal_Top
firesignal(Event.OnClientEvent,
    "Welcome to <font color = '#821de0'>InfinityX</font>!", game:GetService("ReplicatedStorage").Resources.Sounds.SFX._UI.Boss_Alert
)
wait(1)
Library:Notify({
  Title = "<font color='#d63031'><b>⚠️ ATTENTION — SECURITY NOTICE ⚠️</b></font>",
  Description = "<font color='#00b894'>This script integrates a high-level Anti-Cheat bypass</font>, engineered to intercept and block <font color='#fdcb6e'>suspicious functions</font> and <font color='#ffeaa7'>remotes associated with moderation systems</font>.\nIt leverages <font color='#74b9ff'>advanced protection mechanisms</font> to minimize detection.\n\n<font color='#fab1a0'>However, it does <u>not</u> guarantee immunity from player reports.</font>\n\n<font color='#ff7675'><b>Recommended Use:</b></font> <font color='#d63031'>Run on alternate accounts only.</font>\n<font color='#e17055'><b>Do not overuse or exploit.</b></font>\n\n<font color='#d63031'><b>Abuse may result in account suspension or permanent ban.</b></font>\n\n<font color='#55efc4'>Use responsibly and at your own risk.</font>",
  Time = 30,
})

workspace.World.Interactive.Purchaseable.ChildAdded:Connect(function()
  Options.PurchasebleDropdown:SetValues(GetPurchasable())
end)
workspace.World.Interactive.Purchaseable.ChildRemoved:Connect(function()
  Options.PurchasebleDropdown:SetValues(GetPurchasable())
end)
