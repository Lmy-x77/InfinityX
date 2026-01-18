-- detect service
local TextService = game:GetService("TextService")
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
loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Mania/Bypass.lua'))()


-- ui library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/Library.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = true

local Window = Library:CreateWindow({
  Title = '',
  Footer = '<font color="rgb(120,80,200)">Anime Mania (Lobby)</font>',
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
  Main = Window:AddTab("Main", "layers", "Main features script"),
  Settings = Window:AddTab("Config.", "settings", "Ui settings"),
}



-- source
local RollGroupBox = Tabs.Main:AddLeftGroupbox("Rolls", "refresh-cw")
local TeleportGroupBox = Tabs.Main:AddRightGroupbox("Teleport", "locate")
local SlotGroupBox = Tabs.Main:AddLeftGroupbox("Slot", "inbox")
local MiscGroupBox = Tabs.Main:AddRightGroupbox("Misc", "layers")
RollGroupBox:AddDropdown("MethodDropdown", {
	Values = {'Token', 'Gems', 'Coins'},
	Default = '...',
	Multi = false,

	Text = "Select method",
	Tooltip = "Select a method to roll",
	DisabledTooltip = "I am disabled!",

	Searchable = false,

	Callback = function(Value)
		selectedMethod = Value
	end,

	Disabled = false,
	Visible = true,
})
RollGroupBox:AddDropdown("AmountDropdown", {
	Values = {'1', '10'},
	Default = '...',
	Multi = false,

	Text = "Select amount",
	Tooltip = "Select a amount to roll",
	DisabledTooltip = "I am disabled!",

	Searchable = false,

	Callback = function(Value)
		selectedAmount = Value
	end,

	Disabled = false,
	Visible = true,
})
RollGroupBox:AddButton({
	Text = "Roll",
	Func = function()
    if selectedMethod == 'Token' and selectedAmount == '1' then
      local Event = game:GetService("ReplicatedStorage").Remotes.Roll
      Event:InvokeServer(
        nil,
        true
      )
    elseif selectedMethod == 'Token' and selectedAmount == '10' then
      local Event = game:GetService("ReplicatedStorage").Remotes.Rollx10
      Event:InvokeServer(
        nil,
        true
      )

    elseif selectedMethod == 'Gems' and selectedAmount == '1' then
      local Event = game:GetService("ReplicatedStorage").Remotes.Roll
      Event:InvokeServer()
    elseif selectedMethod == 'Gems' and selectedAmount == '10' then
      local Event = game:GetService("ReplicatedStorage").Remotes.Rollx10
      Event:InvokeServer()

    elseif selectedMethod == 'Coins' and selectedAmount == '1' then
      local Event = game:GetService("ReplicatedStorage").Remotes.Roll
      Event:InvokeServer(
        true
      )
    elseif selectedMethod == 'Coins' and selectedAmount == '10' then
      local Event = game:GetService("ReplicatedStorage").Remotes.Rollx10
      Event:InvokeServer(
        true
      )
    end
  end,
	DoubleClick = false,

	Tooltip = "Click to roll selected method and amount",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
RollGroupBox:AddToggle("AutoRoll", {
	Text = "Auto roll",
	Tooltip = "Active to auto roll selected method and amount",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoRoll = Value
    while autoRoll do task.wait()
      if selectedMethod == 'Token' and selectedAmount == '1' then
        local Event = game:GetService("ReplicatedStorage").Remotes.Roll
        Event:InvokeServer(
          nil,
          true
        )
      elseif selectedMethod == 'Token' and selectedAmount == '10' then
        local Event = game:GetService("ReplicatedStorage").Remotes.Rollx10
        Event:InvokeServer(
          nil,
          true
        )

      elseif selectedMethod == 'Gems' and selectedAmount == '1' then
        local Event = game:GetService("ReplicatedStorage").Remotes.Roll
        Event:InvokeServer()
      elseif selectedMethod == 'Gems' and selectedAmount == '10' then
        local Event = game:GetService("ReplicatedStorage").Remotes.Rollx10
        Event:InvokeServer()

      elseif selectedMethod == 'Coins' and selectedAmount == '1' then
        local Event = game:GetService("ReplicatedStorage").Remotes.Roll
        Event:InvokeServer(
          true
        )
      elseif selectedMethod == 'Coins' and selectedAmount == '10' then
        local Event = game:GetService("ReplicatedStorage").Remotes.Rollx10
        Event:InvokeServer(
          true
        )
      end
    end
	end,
})
TeleportGroupBox:AddButton("Teleport to training", function()
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1843, 4068, 253)
end)
TeleportGroupBox:AddButton("Teleport to trait reroll", function()
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1439, 4066, -149)
end)
local selectedSlot = 0
local l1 = SlotGroupBox:AddLabel('')
task.spawn(function()
  while true do task.wait()
    if selectedSlot ~= nil then
      l1:SetText('Cost: ' .. selectedSlot * 50 .. ' gems')
    end
  end
end)
SlotGroupBox:AddInput("SlotsBox", {
  Default = "0",
  Numeric = true,
  Finished = false,
  ClearTextOnFocus = false,

  Text = "Slots",
  Placeholder = "0",

  Callback = function(Value)
    selectedSlot = tonumber(Value)
  end,
})
SlotGroupBox:AddButton("Buy slots", function()
  local Event = game:GetService("ReplicatedStorage").Remotes.BuySlots
  Event:InvokeServer(
    selectedSlot
  )
end)
MiscGroupBox:AddButton("Reedem all codes", function()
  local codes = {'WelcomeNewAnimeManiaPlayers!', 'THANKSFOR175KLIKES', 'SOLOLEVELINGBUFFS', 'MONEYMONEY', 'FIRSTFREECODE'}
  for _, v in ipairs(codes) do
    local args = {
      [1] = v
    }
    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SubmitCode"):InvokeServer(unpack(args))
    task.wait(0.2)
  end
end)
MiscGroupBox:AddButton("Claim all gems / coins", function()
  while true do task.wait()
    for i = 1, 1000 do
      local Event = game:GetService("ReplicatedStorage").Remotes.Claim
      Event:FireServer()
    end
    for i = 1, 1000 do
      local Event = game:GetService("ReplicatedStorage").Remotes.Claim
      Event:FireServer()
    end
  end
end)
MiscGroupBox:AddButton("Rejoin", function()
  game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
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
SaveManager:SetFolder("Obsidian/Anime-Manie-Lobby")
SaveManager:SetSubFolder("Anime-Manie-Lobby")
SaveManager:BuildConfigSection(Tabs.Settings)
ThemeManager:ApplyToTab(Tabs.Settings)
SaveManager:LoadAutoloadConfig()



-- extra functions
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
