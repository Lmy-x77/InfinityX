-- detect service
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	print("Mobile device")
elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
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
local Mutations = {
  Ripe = false,
  Gold = false,
  Rainbow = false,
  Wet = false,
  Windstruck = false,
  Moonlit = false,
  Chilled = false,
  Bloodlit = false,
  Twisted = false,
  Frozen = false,
  Shocked = false,
  Celestial = false
}
local selectedSeedPack = nil
local selectedSeedPackLower = ""
local seedPackNames = {
  "Crafters Seed Pack",
  "Exotic Seed Pack",
  "Exotic Crafters Seed Pack",
  "Exotic Flower Seed Pack",
  "Exotic Summer Seed Pack",
  "Flower Seed Pack",
  "Night Seed Pack",
  "Night Premium Seed Pack",
  "Normal Seed Pack",
  "Rainbow Exotic Crafters Seed Pack",
  "Seed Sack Basic",
  "Seed Sack Premium",
  "Summer Seed Pack"
}
local AllCropsNames = {
  "Carrot",
  "Strawberry",
  "Chocolate Carrot",
  "Blueberry",
  "Orange Tulip",
  "Nightshade",
  "Rose",
  "Manuka Flower",
  "Lavender",
  "Wild Carrot",
  "Crocus",
  "Red Lollipop",
  "Tomato",
  "Corn",
  "Cauliflower",
  "Raspberry",
  "Glowshroom",
  "Daffodil",
  "Mint",
  "Bee Balm",
  "Foxglove",
  "Pear",
  "Succulent",
  "Nectarshade",
  "Dandelion",
  "Candy Sunflower",
  "Apple",
  "Green Apple",
  "Avocado",
  "Papaya",
  "Watermelon",
  "Pumpkin",
  "Cranberry",
  "Bamboo",
  "Durian",
  "Moonflower",
  "Starfruit",
  "Lilac",
  "Cantaloupe",
  "Nectar Thorn",
  "Violet Corn",
  "Lumira",
  "Peach",
  "Lemon",
  "Coconut",
  "Pineapple",
  "Banana",
  "Kiwi",
  "Passionfruit",
  "Cactus",
  "Easter Egg",
  "Dragon Fruit",
  "Bell Pepper",
  "Blood Banana",
  "Mango",
  "Prickly Pear",
  "Egg Plant",
  "Celestiberry",
  "Moon Melon",
  "Moonglow",
  "Nectarine",
  "Pink Lily",
  "Cocovine",
  "Purple Dahlia",
  "Suncoil",
  "Honeysuckle",
  "Bendboo",
  "Parasol Flower",
  "Cherry Blossom",
  "Soul Fruit",
  "Grape",
  "Loquat",
  "Pepper",
  "Cacao",
  "Feijoa",
  "Cursed Fruit",
  "Lotus",
  "Moon Mango",
  "Hive Fruit",
  "Moon Blossom",
  "Rosy Delight",
  "Dragon Pepper",
  "Candy Blossom",
  "Mushroom",
  "Beanstalk",
  "Sugar Apple",
  "Ember Lily",
  "Elephant Ears"
}
local currentHighlight = nil
local currentBillboard = nil
local lastBiggest = nil
local function removeHighlight()
  if currentHighlight then
      currentHighlight:Destroy()
      currentHighlight = nil
  end
  if currentBillboard then
      currentBillboard:Destroy()
      currentBillboard = nil
  end
end
function GetPlayersName()
  local plrs = {}
  for i, v in pairs(game.Players:GetChildren()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
      table.insert(plrs, v.Name)
    end
  end
  return plrs
end
function GetDinoCrafts()
  local crafts = {}
  for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('RecipeSelection_UI').Frame.ScrollingFrame:GetChildren()) do
      if v:IsA('Frame') and v.Name ~= 'ItemPadding' then
          if not string.find(v.Name, "_") then
              table.insert(crafts, v.Name)
          end
      end
  end
  return crafts
end
function GetDinoPets()
  local pets = {}
  local mscript = require(game:GetService("ReplicatedStorage").Data.PetRegistry.PetList)
  for _, v in pairs(mscript) do
    if type(v) == 'table' then
      table.insert(pets, _)
    end
  end
  return pets
end
local function highlightBiggestFruit()
  local farm = nil
  for _, f in ipairs(workspace.Farm:GetChildren()) do
      local important = f:FindFirstChild("Important")
      local data = important and important:FindFirstChild("Data")
      local owner = data and data:FindFirstChild("Owner")
      if owner and owner.Value == game.Players.LocalPlayer.Name then
          farm = f
          break
      end
  end
  if not farm then
      print("No owned farm found.")
      removeHighlight()
      lastBiggest = nil
      return
  end

  local plants = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Plants_Physical")
  if not plants then
      print("No Plants_Physical found.")
      removeHighlight()
      lastBiggest = nil
      return
  end

  local biggest, maxWeight = nil, -math.huge
  for _, fruit in ipairs(plants:GetChildren()) do
      local weightObj = fruit:FindFirstChild("Weight")
      if weightObj and tonumber(weightObj.Value) and tonumber(weightObj.Value) > maxWeight then
          biggest = fruit
          maxWeight = tonumber(weightObj.Value)
      end
  end

  if biggest ~= lastBiggest then
      removeHighlight()
      lastBiggest = biggest
      if biggest and biggest:IsA("Model") then
          local highlight = Instance.new("Highlight")
          highlight.FillColor = Color3.fromRGB(140, 0, 255)
          highlight.OutlineColor = Color3.fromRGB(90, 0, 150)
          highlight.FillTransparency = 0.3
          highlight.OutlineTransparency = 0
          highlight.Adornee = biggest
          highlight.Parent = biggest
          currentHighlight = highlight

          local head = biggest:FindFirstChildWhichIsA("BasePart")
          if head then
              local bb = Instance.new("BillboardGui")
              bb.Size = UDim2.new(0, 100, 0, 40)
              bb.AlwaysOnTop = true
              bb.StudsOffset = Vector3.new(0, 3, 0)
              bb.Adornee = head
              bb.Parent = head

              local label = Instance.new("TextLabel")
              label.Size = UDim2.new(1, 0, 1, 0)
              label.BackgroundTransparency = 1
              label.TextColor3 = Color3.fromRGB(140, 0, 255)
              label.TextStrokeTransparency = 0.2
              label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
              label.TextScaled = true
              label.Font = Enum.Font.FredokaOne
              label.Text = "Weight: " .. string.format("%.2f", maxWeight) .. "kg"
              label.Parent = bb

              currentBillboard = bb
          end
      end
  end
end
function FireTool(ToolName)
  for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v.Name == ToolName then
      v.Parent = game.Players.LocalPlayer.Character
    end
   end
  for i, v in pairs (game.Players.LocalPlayer.Character:GetChildren()) do
    if v.Name == ToolName then
      v:Activate()
    end
  end
end
function GetPets()
  local petsName = {}
  for _, v in pairs(workspace.PetsPhysical:GetDescendants()) do
    if v:IsA('Part') and v:GetAttribute('OWNER') == game.Players.LocalPlayer.Name then
      table.insert(petsName, v:FindFirstChildWhichIsA('Model').Name)
    end
  end
  return petsName
end
local function getFormattedTimerText()
  local textLabel = GetTimeEvent()
  local originalText = textLabel.Text

  local minutes = 0
  local seconds = 0

  local minuteMatch = string.match(originalText, "(%d+) Minu?te?s?")
  if minuteMatch then
      minutes = tonumber(minuteMatch)
  end

  local secondMatch = string.match(originalText, "(%d+) Second?s?")
  if secondMatch then
      seconds = tonumber(secondMatch)
  end

  local formattedString = ""

  if minutes > 0 then
      formattedString = minutes .. "m"
  end

  if seconds > 0 then
      if minutes > 0 then
          formattedString = formattedString .. " "
      end
      formattedString = formattedString .. seconds .. "s"
  end

  if formattedString == "" and (minutes == 0 and seconds == 0) then
      return "0s"
  elseif formattedString == "" then
      return originalText
  end

  return formattedString
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
function RemoveTools()
  local itemNames = {}
  local scrollingFrame = game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame

  for _, v in pairs(scrollingFrame:GetChildren()) do
      if v:IsA("Frame") and not v.Name:match("_Padding$") and v.Name ~= 'ItemPadding' then
          table.insert(itemNames, v.Name) -- Adiciona apenas o nome do item
      end
  end

  local finalOutput = {}

  table.insert(finalOutput, 'Shovel [Destroy Plants]')

  for _, name in ipairs(itemNames) do
      table.insert(finalOutput, name)
  end

  return finalOutput
end
function GetGears()
  local gearName = {}
  for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.ScrollingFrame:GetChildren()) do
    if v:IsA("Frame") and not v.Name:match("_Padding$") and v.Name ~= 'ItemPadding' then
      table.insert(gearName, v.Name)
    end
  end
  return gearName
end
function GetSeed()
  local seedName = {}
  for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.ScrollingFrame:GetChildren()) do
    if v:IsA("Frame") and not v.Name:match("_Padding$") and v.Name ~= 'ItemPadding' then
      table.insert(seedName, v.Name)
    end
  end
  return seedName
end
scriptVersion = "4.2a"



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
  Footer = "Grow a Garden · ".. scriptVersion .. " · discord.gg/emKJgWMHAr",
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
  Shop = Window:AddTab("Shop", "shopping-cart"),
  Event = Window:AddTab("Event", "star"),
  Pets = Window:AddTab("Pets", "dog"),
  LPlayer = Window:AddTab("Character", "user"),
  Misc = Window:AddTab("Misc", "layers"),
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local FruitGroupBox = Tabs.Farm:AddLeftGroupbox("Fruit", "grape")
local MutationGroupBox = Tabs.Farm:AddRightGroupbox("Mutations", "dna")
local TeleportGroupBox = Tabs.Farm:AddLeftGroupbox("Teleport", "locate")
FruitGroupBox:AddToggle("MyToggle", {
	Text = "Auto plant",
	Tooltip = "Active to plant all seeds in your inventory",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    plant = Value
    while plant do task.wait()
      for _, v in pairs(workspace.Farm:GetDescendants()) do
        if v:IsA('StringValue') and v.Value == game.Players.LocalPlayer.Name then
          for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA('Tool') and tool.Name:lower():find('seed') then
              game.Players.LocalPlayer.Character.Humanoid:EquipTool(tool)
              task.wait(0.1)
            end
          end
          local equipped = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool")
          if equipped then
            local name = equipped.Name
            local crop = name:match("^(%w+)%s+Seed")
            if crop then
              local plantPosition = v.Parent.Parent.Plant_Locations.Can_Plant.Position
              local ohVector31 = Vector3.new(plantPosition.X, plantPosition.Y, plantPosition.Z)
              local ohString2 = crop
              game:GetService("ReplicatedStorage").GameEvents.Plant_RE:FireServer(ohVector31, ohString2)
            end
          end
        end
      end
    end
	end,
})
FruitGroupBox:AddToggle("MyToggle", {
	Text = "Auto collect",
	Tooltip = "Active to collect all plants in your garden",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    collect = Value
    if collect then
      for _, v in pairs(workspace.Farm:GetDescendants()) do
        if v:IsA('StringValue') and v.Value == game.Players.LocalPlayer.Name then
          for _, x in pairs(v.Parent.Parent.Plants_Physical:GetDescendants()) do
            if x:IsA('ProximityPrompt') and x.Name == 'ProximityPrompt' then
              x.MaxActivationDistance = math.huge
            end
          end
        end
      end
    end
    while collect do task.wait()
      if not collect then
        for _, v in pairs(workspace.Farm:GetDescendants()) do
          if v:IsA('StringValue') and v.Value == game.Players.LocalPlayer.Name then
            for _, x in pairs(v.Parent.Parent.Plants_Physical:GetDescendants()) do
              if x:IsA('ProximityPrompt') and x.Name == 'ProximityPrompt' then
                x.MaxActivationDistance = 10
              end
            end
          end
        end
        return
      end
      for _, v in pairs(workspace.Farm:GetDescendants()) do
        if v:IsA('StringValue') and v.Value == game.Players.LocalPlayer.Name then
          for _, x in pairs(v.Parent.Parent.Plants_Physical:GetDescendants()) do
            if x:IsA('ProximityPrompt') and x.Name == 'ProximityPrompt' then
              if not collect then return end
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.Parent.CFrame
              x.MaxActivationDistance = math.huge
              fireproximityprompt(x)
            end
          end
        end
      end
    end
	end,
})
FruitGroupBox:AddToggle("MyToggle", {
	Text = "Auto sell inventory",
	Tooltip = "Active to sell all plants in your inventory",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    sell = Value
    if sell then
      savedPosition = ''
      savedPosition = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
      local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
      local hrp = char:FindFirstChild("HumanoidRootPart")
      if not hrp then return end
      hrp.CFrame = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
      task.wait(0.25)
      game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
      task.wait(0.2)
      if savedPosition then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(savedPosition)
        Library:Notify("Returned to saved position!")
      end
    end
	end,
})
FruitGroupBox:AddToggle("MyToggle", {
	Text = "Auto sell in hand",
	Tooltip = "Active to sell all plants in your hand",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    sellInventory = Value
    if sellInventory then
      for _, tool in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if tool:IsA("Tool") and not tool.Name:lower():find('seed') then
          local shouldEquip = true

          for mutationName, isActive in pairs(Mutations) do
            if isActive and tool.Name:lower():find(mutationName:lower()) then
              shouldEquip = false
              break
            end
          end

          if shouldEquip then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(86.57965850830078, 2.999999761581421, 0.4267919063568115)
            tool.Parent = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
            game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Item"):FireServer()
          end
        end
      end
    end
	end,
})
FruitGroupBox:AddButton({
	Text = "Sell inventory",
	Func = function()
    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("Sell_Inventory"):FireServer()
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to sell all plants in your inventory",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
FruitGroupBox:AddDivider()
FruitGroupBox:AddToggle("MyToggle", {
	Text = "Show biggest fruit",
	Tooltip = "Active to show all your biggest fruit",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    espBiggest = Value
    if espBiggest then
        highlightBiggestFruit()
        conn = RunService.RenderStepped:Connect(function()
            if highlightToggle then
                highlightBiggestFruit()
            end
        end)
    else
        if conn then conn:Disconnect() end
        removeHighlight()
        lastBiggest = nil
    end
	end,
})
FruitGroupBox:AddButton({
	Text = "Teleport to biggest fruit",
	Func = function()
    local farm = nil
    for _, f in ipairs(workspace.Farm:GetChildren()) do
        local important = f:FindFirstChild("Important")
        local data = important and important:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner.Value == game.Players.LocalPlayer.Name then
            farm = f
            break
        end
    end

    local plants = farm and farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Plants_Physical")
    if not plants then
        print("No Plants_Physical found.")
        return
    end

    local biggest, maxWeight = nil, -math.huge
    for _, fruit in ipairs(plants:GetChildren()) do
        local weightObj = fruit:FindFirstChild("Weight")
        if weightObj and tonumber(weightObj.Value) and tonumber(weightObj.Value) > maxWeight then
            biggest = fruit
            maxWeight = tonumber(weightObj.Value)
        end
    end

    local part = biggest and biggest:FindFirstChild("PrimaryPart") or biggest:FindFirstChildWhichIsA("BasePart")
    if part then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
    else
        warn("WFT??.")
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to a biggest plant",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
FruitGroupBox:AddButton({
	Text = "Collect biggest fruit",
	Func = function()
    local farm = nil
    for _, f in ipairs(workspace.Farm:GetChildren()) do
        local important = f:FindFirstChild("Important")
        local data = important and important:FindFirstChild("Data")
        local owner = data and data:FindFirstChild("Owner")
        if owner and owner.Value == game.Players.LocalPlayer.Name then
            farm = f
            break
        end
    end

    local plants = farm and farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Plants_Physical")
    if not plants then
        print("No Plants_Physical found.")
        return
    end

    local biggest, maxWeight = nil, -math.huge
    for _, fruit in ipairs(plants:GetChildren()) do
        local weightObj = fruit:FindFirstChild("Weight")
        if weightObj and tonumber(weightObj.Value) and tonumber(weightObj.Value) > maxWeight then
            biggest = fruit
            maxWeight = tonumber(weightObj.Value)
        end
    end

    local part = biggest and biggest:FindFirstChild("PrimaryPart") or biggest:FindFirstChildWhichIsA("BasePart")
    if part then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
        wait(.25)
        for _, v in pairs(biggest:GetDescendants()) do
          if v:IsA('ProximityPrompt') then
            fireproximityprompt(v)
            return
          end
        end
    else
        warn("WFT??.")
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to collect biggest plant",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
for mutationName, _ in pairs(Mutations) do
  MutationGroupBox:AddToggle("Toggle_" .. mutationName, {
    Text = mutationName,
    Tooltip = "Active to not sell " .. mutationName .. " mutation plants",
    DisabledTooltip = "I am disabled!",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
      Mutations[mutationName] = Value
      Library:Notify({
        Title = "InfinityX",
        Description = "Mutation " .. mutationName .. " is set to: " .. tostring(Value),
        Time = 4,
      })
    end,
  })
end
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


local SeedGroupBox = Tabs.Shop:AddLeftGroupbox("Seeds", "sprout")
local GearGroupBox = Tabs.Shop:AddRightGroupbox("Gears", "hammer")
local UiGroupBox = Tabs.Shop:AddLeftGroupbox("Ui", "panel-top")
local ButtonsGroupBox = Tabs.Shop:AddRightGroupbox("Buttons", "box")
SeedGroupBox:AddDropdown("", {
	Values = GetSeed(),
	Default = '...',
	Multi = true,

	Text = "Select a seed",
	Tooltip = "Select a seed you want to buy",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedSeeds = keysOf(Value)
    Library:Notify("Selected seeds: " .. table.concat(selectedSeeds, ", "))
	end,

	Disabled = false,
	Visible = true,
})
SeedGroupBox:AddToggle("MyToggle", {
	Text = "Auto buy seed",
	Tooltip = "Active to buy all selected seeds",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoBuySeeds = Value
    if autoBuySeeds then
      task.spawn(function()
        local event = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock")

        while autoBuySeeds do
          if #selectedSeeds > 0 then
            for _, seedName in ipairs(selectedSeeds) do
              event:FireServer(seedName)
            end
          end
          task.wait(0.25)
        end
      end)
    end
	end,
})
SeedGroupBox:AddButton({
	Text = "Buy selected seed",
	Func = function()
    local event = game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock")
    if #selectedSeeds > 0 then
      for _, seedName in ipairs(selectedSeeds) do
        event:FireServer(seedName)
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to buy all selected seeds",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
GearGroupBox:AddDropdown("", {
	Values = GetGears(),
	Default = '...',
	Multi = true,

	Text = "Select a gear",
	Tooltip = "Select a gear you want to buy",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedGears = keysOf(Value)
    Library:Notify("Selected gears: " .. table.concat(selectedGears, ", "))
	end,

	Disabled = false,
	Visible = true,
})
GearGroupBox:AddToggle("MyToggle", {
	Text = "Auto buy gear",
	Tooltip = "Active to buy all selected seeds",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoBuyGears = Value
    if autoBuyGears then
      task.spawn(function()
          local event = game:GetService("ReplicatedStorage").GameEvents:WaitForChild("BuyGearStock")

          while autoBuyGears do
            if #selectedGears > 0 then
              local toBuy = {}

              if table.find(selectedGears, "All") then
                for _, gearName in ipairs(gearList) do
                  if gearName ~= "All" then
                    table.insert(toBuy, gearName)
                  end
                end
              else
                toBuy = selectedGears
              end

              for _, gearName in ipairs(toBuy) do
                event:FireServer(gearName)
              end
            end
            task.wait(0.5)
          end
      end)
    end
	end,
})
GearGroupBox:AddButton({
	Text = "Buy selected gear",
	Func = function()
    local event = game:GetService("ReplicatedStorage").GameEvents:WaitForChild("BuyGearStock")
    if #selectedGears > 0 then
      local toBuy = {}

      if table.find(selectedGears, "All") then
        for _, gearName in ipairs(gearList) do
          if gearName ~= "All" then
            table.insert(toBuy, gearName)
          end
        end
      else
        toBuy = selectedGears
      end

      for _, gearName in ipairs(toBuy) do
        event:FireServer(gearName)
      end
    end
	end,
	DoubleClick = false,

	Tooltip = "Click to buy all selected seeds",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
UiGroupBox:AddButton("Cosmetic Shop", function()
  local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("CosmeticShop_UI")
  if ui then
    ui.Enabled = not ui.Enabled
  end
end)
UiGroupBox:AddButton("Gear Shop", function()
  local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Gear_Shop")
  if ui then
    ui.Enabled = not ui.Enabled
  end
end)
UiGroupBox:AddButton("Seed Shop", function()
  local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("Seed_Shop")
  if ui then
    ui.Enabled = not ui.Enabled
  end
end)
UiGroupBox:AddButton("Daily Quest", function()
  local ui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("DailyQuests_UI")
  if ui then
    ui.Enabled = not ui.Enabled
  end
end)
ButtonsGroupBox:AddToggle("PetButtonsToggle", {
	Text = "Show pets button",
	Tooltip = "Active to show pets button",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    petsButton = Value
    if petsButton then
      local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('Teleport_UI'):FindFirstChild('Frame'):FindFirstChild('Pets')
      if ui then ui.Visible = true end
    else
      local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('Teleport_UI'):FindFirstChild('Frame'):FindFirstChild('Pets')
      if ui then ui.Visible = false end
    end
	end,
})
ButtonsGroupBox:AddToggle("GearButtonsToggle", {
	Text = "Show gear button",
	Tooltip = "Active to show gear button",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    gearButton = Value
    if gearButton then
      local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('Teleport_UI'):FindFirstChild('Frame'):FindFirstChild('Gear')
      if ui then ui.Visible = true end
    else
      local ui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('Teleport_UI'):FindFirstChild('Frame'):FindFirstChild('Gear')
      if ui then ui.Visible = false end
    end
	end,
})
Toggles.PetButtonsToggle:SetValue(true)
Toggles.GearButtonsToggle:SetValue(true)


local DinoGroupBox = Tabs.Event:AddLeftGroupbox("🦖 Dino Event")
local DinoQuestGroupBox = Tabs.Event:AddRightGroupbox("🚩 Dino Quest")
local DinoCraftGroupBox = Tabs.Event:AddLeftGroupbox("🔨 Dino Craft")
local DinoEggGroupBox = Tabs.Event:AddRightGroupbox("🥚 Dino Egg")
DinoGroupBox:AddButton("Teleport to event", function()
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-100, 4, -31)
end)
local Quest1 = DinoQuestGroupBox:AddLabel({
  Text = "1",
  DoesWrap = true
})
local p1 = DinoQuestGroupBox:AddLabel({
  Text = "p1",
  DoesWrap = true
})
DinoQuestGroupBox:AddDivider()
local Quest2 = DinoQuestGroupBox:AddLabel({
  Text = "2",
  DoesWrap = true
})
local p2 = DinoQuestGroupBox:AddLabel({
  Text = "p2",
  DoesWrap = true
})
DinoQuestGroupBox:AddDivider()
local Quest3 = DinoQuestGroupBox:AddLabel({
  Text = "3",
  DoesWrap = true
})
local p3 = DinoQuestGroupBox:AddLabel({
  Text = "p3",
  DoesWrap = true
})
spawn(function()
  while true do task.wait()
    local taskNames = {}
    local progressQuest = {}

    for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('DinoQuests_UI').Frame.Main.Holder.Tasks:GetChildren()) do
      if v:IsA('Frame') and v.Name:match('Segment') then
        for _, x in pairs(v:GetChildren()) do
          if x:IsA('TextLabel') and x.Name == 'TASK_NAME' then
            table.insert(taskNames, x.Text)
          end
        end
      end
    end
    for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('DinoQuests_UI').Frame.Main.Holder.Tasks:GetChildren()) do
      if v:IsA('Frame') and v.Name:match('Segment') then
        for _, x in pairs(v:GetChildren()) do
          if x:IsA('TextLabel') and x.Name == 'PROGRESS' then
            table.insert(progressQuest, x.Text)
          end
        end
      end
    end

    if taskNames[1] and progressQuest[1] then
      Quest1:SetText("1 - " .. taskNames[1])
      p1:SetText("  - " .. progressQuest[1])
    end
    if taskNames[2] and progressQuest[2] then
      Quest2:SetText("2 - " .. taskNames[2])
      p2:SetText("  - " .. progressQuest[2])
    end
    if taskNames[3] and progressQuest[3] then
      Quest3:SetText("3 - " .. taskNames[3])
      p3:SetText("  - " .. progressQuest[3])
    end
  end
end)
DinoCraftGroupBox:AddDropdown("DinoCraftDropdown", {
	Values = GetDinoCrafts(),
	Default = '...',
	Multi = false,

	Text = "Select craft",
	Tooltip = "Select a craft you want to make",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedQuest = Value
	end,

	Disabled = false,
	Visible = true,
})
DinoCraftGroupBox:AddButton("Place selected quest", function()
  local args = {
    "SetRecipe",
    workspace:WaitForChild("Interaction"):WaitForChild("UpdateItems"):WaitForChild("DinoEvent"):WaitForChild("DinoCraftingTable"),
    "DinoEventWorkbench",
    selectedQuest
  }
  game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("CraftingGlobalObjectService"):FireServer(unpack(args))  
end)
DinoCraftGroupBox:AddButton("Cancel quest", function()
  local args = {
    "Cancel",
    workspace:WaitForChild("Interaction"):WaitForChild("UpdateItems"):WaitForChild("DinoEvent"):WaitForChild("DinoCraftingTable"),
    "DinoEventWorkbench"
  }
  game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("CraftingGlobalObjectService"):FireServer(unpack(args))
end)
DinoCraftGroupBox:AddDivider()
DinoCraftGroupBox:AddButton("Refresh craft list", function()
  Options.DinoCraftDropdown:SetValues(GetDinoCrafts())
end)
DinoEggGroupBox:AddDropdown("DinoPetsDropdown", {
	Values = GetDinoPets(),
	Default = "...",

  Searchable = true,

	Text = "Select pet",
  Tooltip = 'Select pet your want to add to dna machine',

	Callback = function(Value)
		selectedDinoPet = Value
	end,
})
DinoEggGroupBox:AddButton("Teleport dna machine", function()
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-114, 4, -13)
end)
DinoEggGroupBox:AddButton("Place pet", function()
  for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA('Tool') and v.Name:find(selectedDinoPet) then
      v.Parent = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
      task.wait(0.25)
      local args = {
        "MachineInteract"
      }
      game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("DinoMachineService_RE"):FireServer(unpack(args))      
    end
  end
end)
DinoEggGroupBox:AddButton("Collect egg", function()
  local args = {
    "ClaimReward"
  }
  game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("DinoMachineService_RE"):FireServer(unpack(args))  
end)
local EggTime = DinoEggGroupBox:AddLabel({
  Text = "Time: ",
  DoesWrap = true
})
spawn(function()
  spawn(function()
    while true do
      task.wait()
      local findBoard = workspace.Interaction.UpdateItems.DinoEvent.DNAmachine.SideTable:GetChildren()[4]:FindFirstChild('BillboardPart'):FindFirstChild('BillboardGui')
      if findBoard and findBoard.Enabled then
        local textLabel = findBoard:FindFirstChildWhichIsA('TextLabel')
        if textLabel then
          local text = textLabel.Text
          if string.find(text, "%d") then
            EggTime:SetText('Time: ' .. text)
          else
            EggTime:SetText('Time: nil')
          end
        end
      end
    end
  end)
end)


local FeedGroupBox = Tabs.Pets:AddLeftGroupbox("Feed", "beef")
local EggGroupBox = Tabs.Pets:AddRightGroupbox("Eggs", "egg")
FeedGroupBox:AddDropdown("", {
	Values = AllCropsNames,
	Default = '...',
	Multi = true,

	Text = "Select plant",
	Tooltip = "Select a plant you want to feed pet",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedPlantFeed = keysOf(Value)
	end,

	Disabled = false,
	Visible = true,
})
FeedGroupBox:AddDropdown("PetsDropdown", {
	Values = GetPets(),
	Default = "...",

	Text = "Select pet",
  Tooltip = 'Select pet your want to feed',

	Callback = function(Value)
		selectedPet = Value
	end,
})
FeedGroupBox:AddToggle("PetButtonsToggle", {
	Text = "Auto feed pet",
	Tooltip = "Active to auto feed selected pet",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    feedPet = Value
    while feedPet do task.wait()
      if #selectedPlantFeed > 0 then
        if not feedPet then return end
        for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
          if tool:IsA('Tool') and tool.Name ~= RemoveTools() then
            local foundMatch = false
            for _, plantName in ipairs(selectedPlantFeed) do
              if tool.Name:lower():find(plantName:lower()) then
                foundMatch = true
                break
              end
            end

            if foundMatch then
              tool.Parent = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
              wait(.25)
              local args = {
                  "Feed",
                  selectedPet
              }
              game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("ActivePetService"):FireServer(unpack(args))
            end
          end
        end
      end
    end
	end,
})
FeedGroupBox:AddButton("Refresh pet list", function()
  Options.PetsDropdown:SetValues(GetPets())
end)
local autoBuyPetsToggle = false
EggGroupBox:AddToggle("auto_buy_pets_toggle", {
    Text = "Auto Buy All Eggs",
    Tooltip = 'Active to buy all pets eggs in stock',
    Default = false,
    Callback = function(val)
      autoBuyPetsToggle = val
      if val then
        Library:Notify("Auto buy all pets enabled.")
        task.spawn(function()
          while autoBuyPetsToggle do
            for i = 1, 3 do
              for _, pet in ipairs({1, 2, 3}) do
                game.ReplicatedStorage.GameEvents.BuyPetEgg:FireServer(pet)
                task.wait()
              end
            end
            task.wait(60)
          end
        end)
      end
    end
})


local CharacterGroupBox = Tabs.LPlayer:AddLeftGroupbox("Character", "user-round-pen")
local TradeGroupBox = Tabs.LPlayer:AddRightGroupbox("Trade", "refresh-cw")
local TeleportBGroupBox = Tabs.LPlayer:AddLeftGroupbox("Teleport", "locate")
local StatusGroupBox = Tabs.LPlayer:AddRightGroupbox("Status", "chart-line")
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
CharacterGroupBox:AddButton("Rejoin server", function()
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
TradeGroupBox:AddDropdown("PlayersDropdown", {
	Values = GetPlayersName(),
	Default = '...',
	Multi = false,

	Text = "Select a player",
	Tooltip = "Select a player to send trade",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
		selectedPlayer = Value
    print(selectedPlayer)
	end,

	Disabled = false,
	Visible = true,
})
TradeGroupBox:AddToggle("IgnoreFavToggle", {
  Text = "Ignore favorited",
  Tooltip = 'Ignore all your plants favorited',
  Default = false,
  Callback = function(Value)
    igonoreFav = Value
    print(igonoreFav)
  end
})
Toggles.IgnoreFavToggle:SetValue(true)
TradeGroupBox:AddToggle("", {
  Text = "Auto send trade",
  Tooltip = 'Active to send trade to selected player',
  Default = false,
  Callback = function(Value)
    autoSendTrade = Value
    while autoSendTrade do task.wait()
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players[selectedPlayer].Character.HumanoidRootPart.CFrame
      for _, item in pairs(AllCropsNames) do
        for _, tool in ipairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
            local toolNameLower = tool.Name:lower()
            local itemLower = item:lower()

            if tool:IsA('Tool') and toolNameLower:find(itemLower) and not toolNameLower:find('seed') then
                if igonoreFav == true then
                    if tool:GetAttribute('d') == false then
                      tool.Parent = game.Players.LocalPlayer.Character
                      wait()
                    end
                elseif igonoreFav == false then
                  tool.Parent = game.Players.LocalPlayer.Character
                  wait()
                end
            end
        end
      end
      fireproximityprompt(
        game.Players[selectedPlayer].Character.HumanoidRootPart:FindFirstChild('ProximityPrompt')
      )
      wait()
    end
  end
})
TeleportBGroupBox:AddButton("Teleport to seed shop", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(87, 3, -27)
end)
TeleportBGroupBox:AddButton("Teleport to sell shop", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(87, 3, 0)
end)
TeleportBGroupBox:AddButton("Teleport to gear shop", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-285, 3, -14)
end)
TeleportBGroupBox:AddButton("Teleport to pet shop", function()
	game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-285, 3, 1)
end)
local SeedRestockLabel = StatusGroupBox:AddLabel({
  Text = "Seed: ",
  DoesWrap = true
})
local PetsRestockLabel = StatusGroupBox:AddLabel({
  Text = "Pets: ",
  DoesWrap = true
})
local GearRestockLabel = StatusGroupBox:AddLabel({
  Text = "Gear: ",
  DoesWrap = true
})
task.spawn(function()
  while true do task.wait(1)
    SeedRestockLabel:SetText(game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop.Frame.Frame.Timer.Text)
    PetsRestockLabel:SetText('New pets eggs in '.. workspace.NPCS["Pet Stand"].Timer.SurfaceGui.ResetTimeLabel.Text)
    GearRestockLabel:SetText(game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop.Frame.Frame.Timer.Text)
  end
end)


local SeedPackGroupBox = Tabs.Misc:AddLeftGroupbox("Seed Pack", "sprout")
local OptionsGroupBox = Tabs.Misc:AddRightGroupbox("Other Options", "menu")
SeedPackGroupBox:AddDropdown("", {
	Values = seedPackNames,
	Default = '...',
	Multi = false,

	Text = "Select seed pack",
	Tooltip = "Select a seed pack you want to open",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
    selectedSeedPack = Value
    selectedSeedPackLower = selectedSeedPack and selectedSeedPack:lower() or ""
    print(selectedSeedPackLower)
	end,

	Disabled = false,
	Visible = true,
})
SeedPackGroupBox:AddToggle("", {
  Text = "Auto open seed pack",
  Tooltip = 'Activate to open all seed packets automatically',
  Default = false,
  Callback = function(Value)
    autoSeedPack = Value
    while autoSeedPack do task.wait()
      for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if v:IsA('Tool') and selectedSeedPackLower ~= "" and v.Name:lower():find(selectedSeedPackLower) then
          FireTool(v.Name)
        end
      end
    end
  end
})
SeedPackGroupBox:AddButton("Open all seed pack", function()
  for _, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
    if v:IsA('Tool') and v.Name:lower():find('seed pack') then
      print(v.Name)
    end
  end
end)
OptionsGroupBox:AddToggle("AntiAfkToggle", {
  Text = "Anti afk",
  Tooltip = 'Activate to dont has kicked after 20 minutes',
  Default = false,
  Callback = function(Value)
    antiAfk = Value
    if antiAfk then
      print('Anti Afk [ LOADED! ]')
      local VirtualUser = game:GetService("VirtualUser")
      game:GetService("Players").LocalPlayer.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      end)
    end
  end
})
OptionsGroupBox:AddToggle("FpsToggle", {
  Text = "Unlock fps",
  Tooltip = 'Activate to dont has more lag',
  Default = false,
  Callback = function(Value)
    assert(setfpscap, 'Your exploit dont support this function')
    local fps = Value
    if fps then print('Unlock Fps [ LOADED! ]') end
    local function UnlockFPS()
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
Toggles.AntiAfkToggle:SetValue(true)


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
game.Players.PlayerAdded:Connect(function()
  Options.PlayersDropdown:SetValues(GetPlayersName())
end)
game.Players.PlayerRemoving:Connect(function()
  Options.PlayersDropdown:SetValues(GetPlayersName())
end)

Library:Notify({
    Title = "InfinityX",
    Description = "Welcome ".. game.Players.LocalPlayer.Name .."",
    Time = 6,
})
Library:Notify({
    Title = "InfinityX",
    Description = "Script Loaded!",
    Time = 6,
})
wait(1.5)
Library:Notify({
    Title = "InfinityX",
    Description = "If there are any errors in the script, please let us know on the discord server. have fun 🥰",
    Time = 10,
})
