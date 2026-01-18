-- detect service
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	print("Mobile device")
elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
	print("Computer device")
end



-- start
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
local AppraiserSettings = {
  Time = 0.5
}
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
function GetAllTools()
  local tools = {}
  for _, v in pairs(game:GetService('Players').LocalPlayer.Backpack:GetChildren()) do
    if v:IsA('Tool') and not v.Name:lower():find('shovel') and not v.Name:lower():find('equipment') and not v.Name:lower():find('journal') then
      table.insert(tools, v.Name)
    end
  end
  return tools
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
local function safeFire(eventPath, ...)
  local args = {...}
  local success, err = pcall(function()
      if eventPath then
          local event = eventPath()
          if event then
            local realArgs = {}
            for _, v in ipairs(args) do
              table.insert(realArgs, (type(v) == "function") and v() or v)
            end
            event:FireServer(unpack(realArgs))
          else
            error("Event not found")
          end
      else
          local realArgs = {}
          for _, v in ipairs(args) do
              if type(v) == "function" then
                table.insert(realArgs, v())
              else
                table.insert(realArgs, v)
              end
          end
      end
  end)
  if not success then
    print('Error')
  end
end
function Instant()
  local vector = Vector3
  local finishArgs = {
      0,
    {
      {
        Orientation = vector.zero,
        Transparency = 1,
        Name = "PositionPart",
        Position = vector.new(2048.3315, 108.6206, -321.5524),
        Color = Color3.fromRGB(163, 162, 165),
        Material = Enum.Material.Plastic,
        Shape = Enum.PartType.Block,
        Size = vector.new(0.1, 0.1, 0.1)
      },
      {
        Orientation = vector.new(0, 90, 90),
        Transparency = 0,
        Name = "CenterCylinder",
        Position = vector.new(2048.3315, 108.5706, -321.5524),
        Color = Color3.fromRGB(135, 114, 85),
        Material = Enum.Material.Pebble,
        Shape = Enum.PartType.Cylinder,
        Size = vector.new(0.2, 6.4162, 5.5873)
      }
    }
  }
  safeFire(function()
      return game.ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Dig_Finished")
  end, unpack(finishArgs))
end
function EquipShovel()
  local player = game:GetService("Players").LocalPlayer
  local backpack = player:WaitForChild("Backpack")
  local character = player.Character or player.CharacterAdded:Wait()
  local validShovelsFolder = game.ReplicatedStorage:WaitForChild("PlayerItems"):WaitForChild("Shovels")
  local validShovelNames = {}
  for _, shovel in ipairs(validShovelsFolder:GetChildren()) do
      validShovelNames[shovel.Name] = true
  end
  task.wait(0)
  for _, tool in ipairs(backpack:GetChildren()) do
      if tool:IsA("Tool") and validShovelNames[tool.Name] then
          tool.Parent = character
          break
      end
  end
end
function UnnequipShovel()
  local player = game:GetService("Players").LocalPlayer
  local backpack = player:WaitForChild("Backpack")
  local character = player.Character or player.CharacterAdded:Wait()
  for _, tool in ipairs(character:GetChildren()) do
    if tool:IsA("Tool") then
        tool.Parent = backpack
    end
  end
end
wait(.5)
scriptVersion = '4.2a'



-- ui library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = true

local Window = Library:CreateWindow({
  Title = '',
  Footer = '<font color="rgb(120,80,200)">DIG</font>',
  Icon = 126527122577864,
  Size = UDim2.fromOffset(580, 500),
  Position = UDim2.fromOffset(100, 100),
  Center = true,
  AutoShow = true,
  Resizable = true,
  ShowCustomCursor = false,
  ToggleKeybind = Enum.KeyCode.RightControl,
  NotifySide = "Right",
})
Window:SetSidebarWidth(54)



-- tabs
local Tabs = {
  Farm = Window:AddTab("Farming", "banknote", "Configure it the way you want to dig."),
  Transport = Window:AddTab("Transport", "locate", "Teleport to wherever you want."),
  Misc = Window:AddTab("Misc", "layers", "Additional extra options"),
  Settings = Window:AddTab("Config.", "settings", "UI Settings"),
}



-- source
local DigGroupBox = Tabs.Farm:AddLeftGroupbox("Dig", "shovel")
local DigSettingsGroupBox = Tabs.Farm:AddRightGroupbox("Dig Settings", "settings", "")
local AppraiserGroupBox = Tabs.Farm:AddLeftGroupbox("Appraiser", 'dices')
local TeleportGroupBox = Tabs.Farm:AddRightGroupbox("Teleport", "locate")
DigGroupBox:AddDropdown("DigModeDropdown", {
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
DigGroupBox:AddToggle("AutoDig", {
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
DigGroupBox:AddToggle("AutoWalk", {
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
DigGroupBox:AddToggle("AutoSell", {
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
DigSettingsGroupBox:AddInput("InstantDelay", {
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
DigSettingsGroupBox:AddInput("NormalDelay", {
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
DigSettingsGroupBox:AddInput("LegitDelay", {
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
DigSettingsGroupBox:AddToggle("NotifyNewItem", {
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
DigSettingsGroupBox:AddToggle("AutoShowHud", {
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
AppraiserGroupBox:AddDropdown("ItemsDropdown", {
	Values = GetAllTools(),
	Default = '...',
	Multi = false,

	Text = "Select item",
	Tooltip = "Select a item you want to appraiser",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedItem = Value
	end,

	Disabled = false,
	Visible = true,
})
AppraiserGroupBox:AddToggle("AutoAppraiser", {
  Text = "Auto appraiser",
  Tooltip = 'Activate to appraiser selected item automatically',
  Default = false,
  Callback = function(Value)
    autoAprraiser = Value
    while autoAprraiser do
      for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA('Tool') and v.Name == selectedItem then
          v.Parent = game.Players.LocalPlayer.Character
        end
      end
      wait(0.2)
      game:GetService("ReplicatedStorage").DialogueRemotes.Appraiser_Appraise:InvokeServer()
      task.wait(AppraiserSettings.Time)
    end
  end
})
AppraiserGroupBox:AddButton({
	Text = "Appraiser",
	Func = function()
    for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
      if v:IsA('Tool') and v.Name == selectedItem then
        v.Parent = game.Players.LocalPlayer.Character
      end
    end
    wait(0.2)
    game:GetService("ReplicatedStorage").DialogueRemotes.Appraiser_Appraise:InvokeServer()
	end,
	DoubleClick = false,

	Tooltip = "Click to save your current position",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
AppraiserGroupBox:AddButton({
	Text = "Teleport to npc",
	Func = function()
    TeleportTo(false, nil, false, nil, true, 2060, 113, -465)
	end,
	DoubleClick = false,

	Tooltip = "Click to save your current position",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
AppraiserGroupBox:AddDivider()
AppraiserGroupBox:AddInput("AppraiserSpeed", {
  Default = "",
  Numeric = true,
  Finished = false,
  ClearTextOnFocus = false,

  Text = "Appraiser speed",
  Placeholder = "0.5",

  Callback = function(Value)
    AppraiserSettings.Time = Value
  end,
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
BossesGroupBox:AddDropdown("BossesDropdown", {
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
BossesGroupBox:AddToggle("AutoTpBosses", {
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
BossesGroupBox:AddToggle("AutoAttackBoss", {
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
AreasGroupBox:AddDropdown("AreasDropdown", {
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
PurchasablesGroupBox:AddDropdown("PruchasableDropdown", {
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
NPCsGroupBox:AddDropdown("NpcsDropdown", {
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
DeliveryGroupBox:AddToggle("AutoEventToggle", {
  Text = "Auto event",
  Tooltip = 'Activate to complete event automatically',
  Default = false,
  Callback = function(Value)
    runningPenguinQuest = Value
    if Value then
        task.spawn(function()
            while runningPenguinQuest do
                local args = { "Pizza Penguin" }
                game:GetService("ReplicatedStorage"):WaitForChild("DialogueRemotes"):WaitForChild("StartInfiniteQuest"):InvokeServer(unpack(args))
                task.wait(1)

                local penguin = workspace:FindFirstChild("Active") and workspace.Active:FindFirstChild("PizzaCustomers") and workspace.Active.PizzaCustomers:FindFirstChild("Valued Customer") and workspace.Active.PizzaCustomers["Valued Customer"]:FindFirstChild("Penguin")
                if penguin and penguin:IsA("Model") and penguin.PrimaryPart then
                    local char = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
                    local hrp = char:WaitForChild("HumanoidRootPart")
                    hrp.CFrame = penguin.PrimaryPart.CFrame + Vector3.new(0, 5, 0)
                    task.wait(1)
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Quest_DeliverPizza"):InvokeServer()
                end
                task.wait(1)

                game:GetService("ReplicatedStorage"):WaitForChild("DialogueRemotes"):WaitForChild("CompleteInfiniteQuest"):InvokeServer(unpack(args))

                local char = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
                local hrp = char:WaitForChild("HumanoidRootPart")
                hrp.CFrame = CFrame.new(4173, 1193, -4329)
                task.wait(60)
            end
        end)
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
      safeFire(function()
        return game:GetService("ReplicatedStorage").Remotes.Complete_Code
      end, v)
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
  CharacterGroupBox:AddSlider("WalksSpeedSlider", {
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
  CharacterGroupBox:AddSlider("JumpPowerSlider", {
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
  CharacterGroupBox:AddInput("WalkSpeedBox", {
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
  CharacterGroupBox:AddInput("JumpPowerBox", {
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
CharacterGroupBox:AddToggle("AntiAfk", {
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
VehicleGroupBox:AddDropdown("CarsDropdown", {
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
CreditsGroupBox:AddButton("Discord server", function()
	setclipboard("https://discord.gg/emKJgWMHAr")
    Library:Notify({
        Title = "InfinityX",
        Description = "Discord server copied to clipboard",
        Time = 4,
    })
end)
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("Obsidian")
SaveManager:SetFolder("Obsidian/DIG")
SaveManager:SetSubFolder("DIG")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()



-- extra functions
workspace.World.Interactive.Purchaseable.ChildAdded:Connect(function()
  Options.PurchasebleDropdown:SetValues(GetPurchasable())
end)
workspace.World.Interactive.Purchaseable.ChildRemoved:Connect(function()
  Options.PurchasebleDropdown:SetValues(GetPurchasable())
end)
