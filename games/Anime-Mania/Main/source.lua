-- variables
local isMobile = game.UserInputService.TouchEnabled
local function GetHumanoidRootPart()
  local player = game:GetService("Players").LocalPlayer
  local char = player.Character or player.CharacterAdded:Wait()
  return char:FindFirstChild("HumanoidRootPart")
end
function KeyPress(v)
  return game:GetService("VirtualInputManager"):SendKeyEvent(true, v, false, game)
end
function GetCharName()
  local charNames = {}
  for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('CharacterSelection'):WaitForChild('TeamNew'):GetDescendants()) do
    if v:IsA('TextLabel') and v.Name == 'CharName' and v.Text ~= '' then
      table.insert(charNames, v.Text)
    end
  end
  return charNames
end
local LibrarySettings = {
  Title = '<font color="rgb(110, 48, 160)" size="' .. (isMobile and '14' or '24') .. '"><b>'.. (isMobile and ' InfinityX' or 'InfintyX') ..'</b></font>',
  Footer = {
    GameName = '<font color="rgb(180,180,255)"><i>Anime Mania [ Arena ]</i></font> · ',
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
  Farm = Window:AddTab("Farm", "banknote"),
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local WaveGroupBox = Tabs.Farm:AddLeftGroupbox("Clear Wave", "waves")
local SkillsGroupBox = Tabs.Farm:AddRightGroupbox("Skills", "atom")
local CharacterSelectionGroupBox = Tabs.Farm:AddLeftGroupbox("Select Character", "users")
local MiscGroupBox = Tabs.Farm:AddRightGroupbox("Misc", "layers")
WaveGroupBox:AddToggle("MyToggle", {
	Text = "Teleport to all mobs",
	Tooltip = "Active to teleport character to all mobs",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    tpMobs = Value
    while tpMobs do task.wait()
      if GetHumanoidRootPart() then
        for _, v in pairs(workspace.Living:GetChildren()) do
          if v:IsA('Model') and not game.Players:FindFirstChild(v.Name) then
            if v:FindFirstChild('HumanoidRootPart') then
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5.5, 0) * CFrame.Angles(math.rad(270), 0, 0)
            end
          end
        end
      end
    end
	end,
})
WaveGroupBox:AddToggle("MyToggle", {
	Text = "Use all skills",
	Tooltip = "Active to use all skills",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    skills = Value
    while skills do task.wait()
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer({'Skill', 1})
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer({'Skill', 2})
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer({'Skill', 3})
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer({'Skill', 4})
    end
	end,
})
WaveGroupBox:AddToggle("MyToggle", {
	Text = "Auto team assist",
	Tooltip = "Active to use team assist",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    assist = Value
    while assist do task.wait()
      local args = {[1] = {[1] = "Skill", [2] = "TeamAssist"}}
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer(unpack(args))
    end
	end,
})
WaveGroupBox:AddToggle("MyToggle", {
	Text = "Auto m1",
	Tooltip = "Active to use m1",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    m1 = Value
    while m1 do task.wait()
      game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer({'Light'}, false)
    end
	end,
})
WaveGroupBox:AddToggle("MyToggle", {
	Text = "God mode",
	Tooltip = "Active to dont die",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    gd = Value

    local RunService = game:GetService('RunService')
    local ReplicatedStorage = game:GetService('ReplicatedStorage')

    local success, clCheck = pcall(function()
        return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("clCheck")
    end)
    if not success or not clCheck then
        return
    end

    RunService.RenderStepped:Connect(function()
        if gd then
          local successInvoke, errorMessage = pcall(function()
              clCheck:InvokeServer('Dash')
          end)

          if not successInvoke then
            warn("Error: ".. errorMessage)
          end
        end
    end)
	end,
})
local skills = {1, 2, 3, 4}
for _, v in pairs(skills) do
  SkillsGroupBox:AddToggle("MyToggle", {
    Text = "Auto use ".. v .. " skill",
    Tooltip = "Active to use ".. v .. " skill automatically",
    DisabledTooltip = "I am disabled!",

    Default = false,
    Disabled = false,
    Visible = true,
    Risky = false,

    Callback = function(Value)
      local skillsSelected = Value
      while skillsSelected do task.wait()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Input"):FireServer({'Skill', v})
      end
    end,
  })
end
CharacterSelectionGroupBox:AddDropdown("PlayersDropdown", {
	Values = GetCharName(),
	Default = '...',
	Multi = false,

	Text = "Select character",
	Tooltip = "Select character you want to use",
	DisabledTooltip = "I am disabled!",

	Searchable = false,

	Callback = function(Value)
		selectedCharacter = Value
  end,

	Disabled = false,
	Visible = true,
})
CharacterSelectionGroupBox:AddToggle("MyToggle", {
	Text = "Auto select",
	Tooltip = "Active to select a selected character in dropdown",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoSelect = Value

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local function moveAndClick(button)
      if not button or not button:IsA("ImageButton") or not button.Visible then return end
      local pos = button.AbsolutePosition + (button.AbsoluteSize / 2)

      if UserInputService.TouchEnabled then
        if not movemouseabs and not mouse1click then
          Library:Notify({
            Title = "InfinityX",
            Description = "Your mobile exploit dont support this function, i reccomend use the KRNL for more experience",
            Time = 6,
          })
          return
        end
        mousemoveabs(pos.X, pos.Y)
        mouse1click()
      else
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
      end
    end

    task.spawn(function()
      while true do
        if autoSelect then
          local player = Players.LocalPlayer
          if player then
            local gui = player:WaitForChild("PlayerGui"):WaitForChild("SelectCharacterScreen")
            if gui then
              for _, v in pairs(gui:GetDescendants()) do
                if v:IsA('TextLabel') and v.Name == 'CharName' and v.Text == selectedCharacter and v.Visible then
                  v.Size = UDim2.new(10, 0, 10, 0)
                  moveAndClick(v.Parent)
                end
              end
            end
          end
        end
        task.wait(1)
      end
    end)
	end,
})
CharacterSelectionGroupBox:AddToggle("MyToggle", {
	Text = "Auto replay",
	Tooltip = "Active to replay mode automatically",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoReplay = Value

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local function moveAndClick(button)
      if not button or not button:IsA("ImageButton") or not button.Visible then return end
      local pos = button.AbsolutePosition + (button.AbsoluteSize / 2)

      if UserInputService.TouchEnabled then
        if not movemouseabs and not mouse1click then
          Library:Notify({
            Title = "InfinityX",
            Description = "Your mobile exploit dont support this function, i reccomend use the KRNL for more experience",
            Time = 6,
          })
          return
        end
        mousemoveabs(pos.X, pos.Y)
        mouse1click()
      else
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
      end
    end

    task.spawn(function()
      while true do
        if autoReplay then
          local player = Players.LocalPlayer
          if player then
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
              local result = gui:FindFirstChild("Result")
              if result then
                for _, v in pairs(result:GetDescendants()) do
                  if v:IsA("ImageButton") and v.Name == "Replay" and v.Visible then
                    v.Size = UDim2.new(10, 0, 10, 0)
                    moveAndClick(v)
                  end
                end
              end
            end
          end
        end
        task.wait(1)
      end
    end)
	end,
})
CharacterSelectionGroupBox:AddToggle("MyToggle", {
	Text = "Auto next",
	Tooltip = "Active to replay mode automatically",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoNext = Value

    local Players = game:GetService("Players")
    local UserInputService = game:GetService("UserInputService")
    local VirtualInputManager = game:GetService("VirtualInputManager")

    local function moveAndClick(button)
      if not button or not button:IsA("ImageButton") or not button.Visible then return end
      local pos = button.AbsolutePosition + (button.AbsoluteSize / 2)

      if UserInputService.TouchEnabled then
        if not movemouseabs and not mouse1click then
          Library:Notify({
            Title = "InfinityX",
            Description = "Your mobile exploit dont support this function, i reccomend use the KRNL for more experience",
            Time = 6,
          })
          return
        end
        mousemoveabs(pos.X, pos.Y)
        mouse1click()
      else
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, true, game, 0)
        task.wait(0.05)
        VirtualInputManager:SendMouseButtonEvent(pos.X, pos.Y, 0, false, game, 0)
      end
    end

    task.spawn(function()
      while true do
        if autoNext then
          local player = Players.LocalPlayer
          if player then
            local gui = player:FindFirstChild("PlayerGui")
            if gui then
              local result = gui:FindFirstChild("Result")
              if result then
                for _, v in pairs(result:GetDescendants()) do
                  if v:IsA("ImageButton") and v.Name == "Nex" and v.Visible then
                    v.Size = UDim2.new(10, 0, 10, 0)
                    moveAndClick(v)
                  end
                end
              end
            end
          end
        end
        task.wait(1)
      end
    end)
	end,
})
MiscGroupBox:AddToggle("MyToggle", {
	Text = "Auto next wave [Dungeon]",
	Tooltip = "Teleport you to wave point",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AutoWave = Value
    while AutoWave do task.wait()
      for _, v in pairs(workspace.FX:GetChildren()) do
        if v:IsA('MeshPart') and v.Name == 'WaveSilo' then
          if GetHumanoidRootPart() then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
          end
        end
      end
    end
	end,
})
MiscGroupBox:AddToggle("MyToggle", {
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
