-- detect service
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
  print("Mobile device")
elseif not IsOnMobile then
  print("Computer device")
end



-- start
pcall(function()
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Tower-of-Hell/Bypass.lua"))()
end)
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
function GetTools()
  local toolsNames = {}
  for _, v in pairs(game:GetService("ReplicatedStorage").Assets.Gear:GetChildren()) do
    if v:IsA('Tool') then
      table.insert(toolsNames, v.Name)
    end
  end
  return toolsNames
end
function GetItem(kind, item, method)
  local Event = game:GetService("ReplicatedStorage").Remotes.Economy.buyShopItem
  return Event:InvokeServer({kind = kind, item = item, method = method})
end
local LibrarySettings = {
  Title = '<font color="rgb(110, 48, 160)" size="24"><b>InfinityX</b></font>',
  Footer = {
    GameName = '<font color="rgb(180,180,255)"><i>Tower of Hell</i></font> · ',
    Version = '<font color="rgb(160,160,160)">Version 4.2a</font> · ',
    DiscordLink = '<font color="rgb(100,200,255)">Join us: discord.gg/emKJgWMHAr</font>'
  }
}



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
  Title = LibrarySettings.Title,
  Footer = LibrarySettings.Footer.GameName .. LibrarySettings.Footer.Version .. LibrarySettings.Footer.DiscordLink,
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
  Main = Window:AddTab("Main", "layers"),
  Shop = Window:AddTab("Shop", "shopping-cart"),
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local TowerGroupBox = Tabs.Main:AddLeftGroupbox("Tower", "tower-control")
local CharacterGroupBox = Tabs.Main:AddRightGroupbox("Character", "user")
local ToolGroupBox = Tabs.Main:AddRightGroupbox("Item Sniper", "hammer")
TowerGroupBox:AddButton("Finish tower", function()
  if game.PlaceId == 1962086868 then
    game:GetService("TweenService"):Create(
      game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
      TweenInfo.new(25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
      {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
    ):Play() wait(25.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
  elseif game.PlaceId == 3582763398 then
    game:GetService("TweenService"):Create(
      game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
      TweenInfo.new(35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
      {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
    ):Play() wait(35.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
  end
end)
TowerGroupBox:AddButton("Finish tower + rejoin", function()
  if game.PlaceId == 1962086868 then
    game:GetService("TweenService"):Create(
      game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
      TweenInfo.new(25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
      {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
    ):Play() wait(25.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
    wait(1.5)
    game:GetService("TeleportService"):TeleportToPlaceInstance(
      game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer
    )
  elseif game.PlaceId == 3582763398 then
    game:GetService("TweenService"):Create(
      game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
      TweenInfo.new(35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
      {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
    ):Play() wait(35.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
    wait(1.5)
    game:GetService("TeleportService"):TeleportToPlaceInstance(
      game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer
    )
  end
end)
TowerGroupBox:AddDivider()
TowerGroupBox:AddLabel({
  Text = "The finish tower is working, but be careful, after several tests even taking time to get kicked or banned the code is still not 100% secure, so use with moderation.\n\n(I recommend using it on a private server, but still be careful when using it)",
  DoesWrap = true
})
CharacterGroupBox:AddToggle("MyToggle", {
	Text = "God mode",
	Tooltip = "Active to dont die in kill parts",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    gm = Value
    while gm do task.wait()
      game:GetService("ReplicatedStorage").GameValues.killbricksDisabled.Value = gm
    end
	end,
})
CharacterGroupBox:AddToggle("MyToggle", {
	Text = "Anti afk",
	Tooltip = "Active for dont have kiked at 20 minutes idled",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

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
	end,
})
CharacterGroupBox:AddDivider()
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
CharacterGroupBox:AddInput("MyTextbox", {
  Default = "0",
  Numeric = true,
  Finished = false,
  ClearTextOnFocus = false,

  Text = "Extra jumps",
  Placeholder = "0",

  Callback = function(Value)
    for _, v in pairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
      if v:IsA('IntValue') and v.Name == 'globalJumps' then
        v.Value = Value
      end
    end
  end,
})
ToolGroupBox:AddDropdown("", {
	Values = GetTools(),
	Default = '...',
	Multi = false,

	Text = "Select toll",
	Tooltip = "Select a tool you want to get",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
		selectedTool = Value
	end,

	Disabled = false,
	Visible = true,
})
ToolGroupBox:AddButton("Get selected tool", function()
  for _, v in pairs(game:GetService("ReplicatedStorage").Assets.Gear:GetChildren()) do
    if v:IsA('Tool') and v.Name == selectedTool then
      local tclone = v:Clone()
      tclone.Parent = game.Players.LocalPlayer.Backpack
    end
  end
end)
ToolGroupBox:AddButton("Get all tools", function()
  for _, v in pairs(game:GetService("ReplicatedStorage").Assets.Gear:GetChildren()) do
    if v:IsA('Tool') then
      local tclone = v:Clone()
      tclone.Parent = game.Players.LocalPlayer.Backpack
    end
  end
end)


local GearsGroupBox = Tabs.Shop:AddLeftGroupbox("Gears", "hammer")
local MutatorGroupBox = Tabs.Shop:AddLeftGroupbox("Mutator", "atom")
local StatusGroupBox = Tabs.Shop:AddRightGroupbox("Status", "chart-line")
GearsGroupBox:AddDropdown("", {
	Values = {'speed', 'gravity', 'fusion', 'trowel', 'hook', 'hourglass'},
	Default = '...',
	Multi = false,

	Text = "Select gear",
	Tooltip = "Select a tool you want to get",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
		selectedGear = Value
	end,

	Disabled = false,
	Visible = true,
})
GearsGroupBox:AddButton("Buy selected gear", function()
	GetItem('gear', selectedGear, 'regular')
end)
MutatorGroupBox:AddDropdown("", {
	Values = {'invincibility', 'speed', 'gravity', 'fog', 'negative', 'lengthen', 'time', 'invisibility', 'double jump', 'bunny', 'checkpoints', 'double coins'},
	Default = '...',
	Multi = false,

	Text = "Select mutator",
	Tooltip = "Select a mutator you want to get",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
		selectedMutator = Value
	end,

	Disabled = false,
	Visible = true,
})
MutatorGroupBox:AddButton("Buy selected mutator", function()
  local regularMutators = {'invincibility', 'speed', 'gravity', 'fog', 'negative', 'lengthen', 'time'}
  local productMutators = {'invisibility', 'double jump', 'bunny', 'checkpoints', 'double coins'}
  if table.find(regularMutators, selectedMutator) then
    GetItem('mutator', selectedMutator, 'regular')
  end
  if table.find(productMutators, selectedMutator) then
    GetItem('mutator', selectedMutator, 'product')
  end
end)
local l1 = StatusGroupBox:AddLabel({
  Text = "",
  DoesWrap = true
})
local l2 = StatusGroupBox:AddLabel({
  Text = "",
  DoesWrap = true
})
local l3 = StatusGroupBox:AddLabel({
  Text = "",
  DoesWrap = true
})
task.spawn(function()
  while true do task.wait()
    local shop2 = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('shop2')
    if shop2 then
      l1:SetText('Your money: ' .. game:GetService("Players").LocalPlayer.PlayerGui.shop2.shop.yxle.Frame.yxles.Text)
      l2:SetText('Your level: ' .. game:GetService("Players").LocalPlayer.PlayerGui.levels.Frame.level.level.Text)
      l3:SetText('Time: ' .. game:GetService("Players").LocalPlayer.PlayerGui.timer.timeLeft.Text)
    end
  end
end)


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
