-- variables
local LibrarySettings = {
  Title = '<font color="rgb(110, 48, 160)" size="24"><b>InfinityX</b></font>',
  Footer = {
    GameName = '<font color="rgb(180,180,255)"><i>Anime Mania [ Lobby ]</i></font> · ',
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
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local RollGroupBox = Tabs.Main:AddLeftGroupbox("Rolls", "refresh-cw")
local TeleportGroupBox = Tabs.Main:AddRightGroupbox("Teleport", "locate")
local MiscGroupBox = Tabs.Main:AddRightGroupbox("Misc", "layers")
RollGroupBox:AddDropdown("PlayersDropdown", {
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
RollGroupBox:AddDropdown("PlayersDropdown", {
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
RollGroupBox:AddToggle("MyToggle", {
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
