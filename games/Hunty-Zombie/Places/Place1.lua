local allowedplaceid = {103754275310547, 86076978383613}
local currentPlace = game.PlaceId
local function isAllowed(id)
  for _, v in ipairs(allowedplaceid) do
    if v == id then
      return true
    end
  end
  return false
end
if not isAllowed(currentPlace) then
  return
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
local farmsettings = {
  Enabled = false
}
local function u2x(frameObj)
  if frameObj and frameObj:IsA("Frame") then
    return frameObj.Size.X.Scale
  end
  return 0
end
local function getHP(m)
  local head = m:FindFirstChild("Head")
  if not head then return 0 end

  local gui = head:FindFirstChild("EntityHealth")
      or (head:FindFirstChild("face") and head.face:FindFirstChild("EntityHealth"))
  if not gui then return 0 end

  local hb = gui:FindFirstChild("HealthBar")
  if not hb then return 0 end

  local bar = hb:FindFirstChild("Bar")
  if not bar or not bar:IsA("Frame") then return 0 end

  return u2x(bar)
end
local function alive(m)
  return m and m.Parent and getHP(m) > 0
end
function CreatePlataform()
  if not workspace:FindFirstChild('SafeZoneX') then
    local pos = CFrame.new(15, 21, 54)

    local platform = Instance.new("Part")
    platform.Name = 'SafeZoneX'
    platform.Size = Vector3.new(10, 1, 10)
    platform.Position = (pos * CFrame.new(0, -3, 0)).Position
    platform.Anchored = true
    platform.Parent = workspace
    platform.Transparency = 0.5

    local icon = Instance.new("BillboardGui")
    icon.Adornee = platform
    icon.Size = UDim2.new(0, 100, 0, 100)
    icon.AlwaysOnTop = true
    icon.Parent = platform

    local img = Instance.new("ImageLabel")
    img.Size = UDim2.new(1, 0, 1, 0)
    img.BackgroundTransparency = 1
    img.Image = "rbxassetid://72212320253117"
    img.Parent = icon
  end
end
local GuiService = game:GetService("GuiService")
function KeyPress(v)
  game:GetService("VirtualInputManager"):SendKeyEvent(true, v, false, game)
  task.wait()
  game:GetService("VirtualInputManager"):SendKeyEvent(false, v, false, game)
end
function ClickGuiNavigation(path: Instance)
  GuiService.GuiNavigationEnabled = true
  GuiService.AutoSelectGuiEnabled = true
  GuiService.SelectedObject = path
  task.wait(0.1)
  KeyPress(Enum.KeyCode.Return.Name)
end
function GetAllNpcs()
  if game.PlaceId ~= 103754275310547 then return end
  local npcs = {}
  for _, v in pairs(workspace["NPC ANIM"]:GetChildren()) do
    if v:IsA('Model') then
      table.insert(npcs, v.Name)
    end
  end
  return npcs
end
function GetAllPlayers()
  local players = {}
  for _, v in pairs(game.Players:GetPlayers()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
      table.insert(players, v.Name)
    end
  end
  return players
end
function gradient(text, startColor, endColor)
  local result = ""
  local length = #text
  for i = 1, length do
      local t = (i - 1) / math.max(length - 1, 1)
      local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
      local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
      local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
      local char = text:sub(i, i)
      result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
  end
  return result
end


-- esp library
local EspLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Esp%20v2/source.lua", true))()
EspLib.ESPValues.ZombieESP = false
EspLib.ESPValues.DoorsESP = false
EspLib.ESPValues.ItemESP = false
EspLib.ESPValues.PlayerESP = false
local function applyESPToZombie()
	for _, v in pairs(workspace.Entities.Zombie:GetChildren()) do
		if v:IsA('Model') then
			EspLib.ApplyESP(v, {
				Color = Color3.fromRGB(0,255,0),
				Text = 'Zombie',
				ESPName = "ZombieESP",
				HighlightEnabled = true,
			})
		end
	end
end
local function applyESPToPlayers(player)
  if player == game.Players.LocalPlayer then return end
  player.CharacterAdded:Connect(function()
    if EspLib.ESPValues.PlayerESP then
      for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
        if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
          EspLib.ApplyESP(player.Character, {
            Color = Color3.new(0.490196, 0.176471, 0.780392),
            Text = player.Name,
            ESPName = "PlayerESP",
            HighlightEnabled = true,
          })
        end
      end
    end
  end)
  if player.Character then
    for _, plr in pairs(game:GetService("Players"):GetPlayers()) do
      if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
        EspLib.ApplyESP(player.Character, {
          Color = Color3.new(0.490196, 0.176471, 0.780392),
          Text = player.Name,
          ESPName = "PLayerESP",
          HighlightEnabled = true,
        })
      end
    end
  end
end
function applyESPToDoors()
  for _, v in pairs(workspace:GetChildren()) do
    if v:IsA('Model') and (v.Name == 'School' or v.Name == 'Sewers' or v.Name == 'Carnival') then
    if v:FindFirstChild('Doors') then
        for _, x in pairs(v:FindFirstChild('Doors'):GetChildren()) do
          if x:IsA('Model') then
            EspLib.ApplyESP(x, {
              Color = Color3.new(0.152941, 0.400000, 0.772549),
              Text = 'Door',
              ESPName = "DoorsESP",
              HighlightEnabled = true,
            })
          end
        end
      end
    end
  end
end
function applyESPToItems()
  for _, v in pairs(workspace.DropItems:GetChildren()) do
    if v:IsA('Part') then
      EspLib.ApplyESP(v, {
        Color = Color3.new(0.792157, 0.752941, 0.188235),
        Text = v.Name,
        ESPName = "ItemESP",
        HighlightEnabled = true,
      })
    end
  end
end


-- ui library
local isMobile = game.UserInputService.TouchEnabled
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Fluent/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Options = Fluent.Options

function GetSize()
  if isMobile then
    return UDim2.fromOffset(480, 300)
  else
    return UDim2.fromOffset(650, 480)
  end
end

local Window = Fluent:CreateWindow({
    Title = '<font color="rgb(175, 120, 255)" size="14"><b>InfinityX</b> <font color="rgb(180,180,180)" size="13"> - <b>v4.2a</b></font></font>',
    SubTitle = '<font color="rgb(160,160,160)" size="10"><i> -  by lmy77</i></font>',
    Search = true,
    Icon = "rbxassetid://72212320253117",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "InfinityX",
    MinimizeKey = Enum.KeyCode.LeftControl,

    UserInfo = true,
    UserInfoTop = false,
    UserInfoTitle = game.Players.LocalPlayer.Name,
    UserInfoSubtitle = "User",
    UserInfoSubtitleColor = Color3.fromRGB(71, 123, 255)
})
local Minimizer = Fluent:CreateMinimizer({
  Icon = "rbxassetid://72212320253117",
  Size = UDim2.fromOffset(44, 44),
  Position = UDim2.new(0, 320, 0, 24),
  Acrylic = true,
  Corner = 10,
  Transparency = 1,
  Draggable = true,
  Visible = true
})
Fluent:ToggleTransparency(false)


-- tabs
local Tabs = {
  AutoLobby = Window:AddTab({ Title = "| Auto Lobby", Icon = "plus" }),
  Modification = Window:AddTab({ Title = "| Modification", Icon = "crown" }),
  AutoRoll = Window:AddTab({ Title = "| Auto Roll", Icon = "refresh-cw" }),
  Teleport = Window:AddTab({ Title = "| Teleport", Icon = "crosshair" }),
  Misc = Window:AddTab({ Title = "| Misc", Icon = "layers" }),

}
Window:SelectTab(1)


-- source
Tabs.AutoLobby:AddSection("[📊] - Auto Create Lobby")
Tabs.AutoLobby:AddDropdown("InterfaceTheme", {
  Title = "Select map",
  KeepSearch = false,
  Values = { "School", "Sewers", "Carnival", "Island" },
  Default = "--",
  Callback = function(Value)
    selectedmap = Value
  end
})
Tabs.AutoLobby:AddDropdown("InterfaceTheme", {
  Title = "Select difficulty",
  Values = { "Normal", "Hard", "Nightmare" },
  Default = "--",
  Callback = function(Value)
    selecteddifficulty = Value
  end
})
Tabs.AutoLobby:AddDropdown("InterfaceTheme", {
  Title = "Select player size",
  Values = { '1', '2', '3', '4', '5', '6' },
  Default = "--",
  Callback = function(Value)
    selectedPlayerSize = Value
  end
})
Tabs.AutoLobby:AddDropdown("InterfaceTheme", {
  Title = "Select mode",
  Values = { 'Campaign', 'Endless', 'Raid' },
  Default = "--",
  Callback = function(Value)
    selectedModeJ = Value
  end
})
Tabs.AutoLobby:AddToggle("", {
  Title = "Only friends",
  Default = false,
  Callback = function(Value)
    getgenv().OnlyFriends = Value
  end
})
Tabs.AutoLobby:AddToggle("AcrylicToggle", {
  Title = "Auto join game",
  Description = "Activate to create the lobby with the desired settings above",
  Default = false,
  Callback = function(Value)
    autojoin = Value
    while autojoin do task.wait()
      local gui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo
      if gui.Visible == false then
        for _, v in pairs(workspace.Match:GetDescendants()) do
          if v:IsA("TouchTransmitter") and v.Parent.MatchBoard.InfoLabel.Text == 'Start Here' and v.Parent.Name == 'Part' then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
            task.wait()
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
          end
        end
      elseif gui.Visible == true then
        if getgenv().OnlyFriends then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.friendonly)
          wait(1)
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.friendonly)
        end
        if selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps.mapbutton)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes.difbutton)
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 5 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 4 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 3 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 2 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          for i = 0, 1 do
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
            wait(.2)
          end
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Island' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemap)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[8])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          if selectedModeJ == 'Campaign' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes.modebutton)
          elseif selectedModeJ == 'Endless' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[3])
          elseif selectedModeJ == 'Raid' then
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
            wait()
            ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.upmodes:GetChildren()[4])
          end
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        end
      end
    end
  end
})

Tabs.Modification:AddSection("[👑] - Mods Options")
Tabs.Modification:AddDropdown("InterfaceTheme", {
  Title = "Select slot",
  KeepSearch = false,
  Values = {'1', '2', '3', '4', '5', '6'},
  Default = "--",
  Callback = function(Value)
    selectedslotw = Value
  end
})
Tabs.Modification:AddDropdown("InterfaceTheme", {
  Title = "Select weapon",
  KeepSearch = false,
  Values = {'Scythe', 'Dagger', 'Bow', 'Priest', 'Halloween Sword', 'Reapers Scythe'},
  Default = "--",
  Callback = function(Value)
    selectedweaponm = Value
  end
})
Tabs.Modification:AddButton({
  Title = "Get event weapon",
  Callback = function()
    local args = {
      tonumber(selectedslotw),
      selectedweaponm
    }
    game:GetService("ReplicatedStorage").Packets.EquipWeaponByItem:InvokeServer(unpack(args))
  end
})

Tabs.AutoRoll:AddSection("[⚔️] - Weapon Roll")
Tabs.AutoRoll:AddDropdown("InterfaceTheme", {
  Title = "Select weapon",
  KeepSearch = false,
  Values = { "Baseball", "Axes", 'Guitar', 'Dual Gun', 'Zombie Claws', 'Katana', 'Greatsword', 'Scissors', 'Anchor', 'Shoes', 'Ghost', 'Spinal Blade'},
  Default = "--",
  Callback = function(Value)
    selectedweapon = Value
  end
})
Tabs.AutoRoll:AddDropdown("InterfaceTheme", {
  Title = "Select slot",
  KeepSearch = false,
  Values = {'1', '2', '3', '4', '5', '6'},
  Default = "--",
  Callback = function(Value)
    selectedslot = Value
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll selected weapon",
  Default = false,
  Callback = function(Value)
    autoroll = Value
    if autoroll then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while autoroll do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if string.find(string.lower(verify), string.lower(selectedweapon)) then
        Fluent:Notify({
          Title = "Notification",
          Content = "The weapon: " .. selectedweapon .. ' has been collected',
          Duration = 5,
        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.WeaponSpin
        Event:InvokeServer(
          tonumber(selectedslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until legendary",
  Default = false,
  Callback = function(Value)
    autorolll = Value
    if autorolll then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while autorolll do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if verify == 'GUITAR' or verify == 'DUAL GUN' or verify == 'ZOMBIE CLAWS' then
        Fluent:Notify({
          Title = "Notification",
          Content = "The weapon: " .. verify .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.WeaponSpin
        Event:InvokeServer(
          tonumber(selectedslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until mythic",
  Default = false,
  Callback = function(Value)
    autorollm = Value
    if autorollm then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while autorollm do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if verify == 'KATANA' or verify == 'GREATSWORD' or verify == 'SCISSORS' or verify == 'ANCHOR' then
        Fluent:Notify({
          Title = "Notification",
          Content = "The weapon: " .. verify .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.WeaponSpin
        Event:InvokeServer(
          tonumber(selectedslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until divine",
  Default = false,
  Callback = function(Value)
    autorolld = Value
    if autorolld then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while autorolld do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if verify == 'SHOES' or verify == 'GHOST' or verify == 'SPINAL BLADE' then
        Fluent:Notify({
          Title = "Notification",
          Content = "The weapon: " .. verify .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.WeaponSpin
        Event:InvokeServer(
          tonumber(selectedslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddSection("[⭐] - Perks Roll")
Tabs.AutoRoll:AddDropdown("InterfaceTheme", {
  Title = "Select perk",
  KeepSearch = false,
  Values = { "Berserker", "Healer", "Flame", "Critical", "Undead", "Lasthope", "Andrenaline", "Vampire", "DoubleDmg", "DamageShield" },
  Default = "--",
  Callback = function(Value)
    selectedperk = Value
  end
})
Tabs.AutoRoll:AddDropdown("InterfaceTheme", {
  Title = "Select slot",
  KeepSearch = false,
  Values = {'1', '2', '3', '4', '5', '6'},
  Default = "--",
  Callback = function(Value)
    selectedpslot = Value
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll selected perk",
  Default = false,
  Callback = function(Value)
    pautoroll = Value
    if pautoroll then
      local perkgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin
      if perkgui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Perks.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while pautoroll do task.wait()
      local verifyp = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin.Header.Text
      if string.find(string.lower(verifyp), string.lower(selectedperk)) then
        Fluent:Notify({
          Title = "Notification",
          Content = "The perk: " .. selectedperk .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.PerkSpin
        Event:InvokeServer(
          tonumber(selectedpslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until legendary",
  Default = false,
  Callback = function(Value)
    pautorolll = Value
    if pautorolll then
      local perkgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin
      if perkgui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Perks.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while pautorolll do task.wait()
      local verifyp = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin.Header.Text
      if verifyp == 'CRITICAL' or verifyp == 'UNDEAD' or verifyp == 'LASTHOPE' or verifyp == 'ADRENALINE' then
        Fluent:Notify({
          Title = "Notification",
          Content = "The perk: " .. verifyp .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.PerkSpin
        Event:InvokeServer(
          tonumber(selectedpslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until mythic",
  Default = false,
  Callback = function(Value)
    pautorollm = Value
    if pautorollm then
      local perkgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin
      if perkgui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Perks.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while pautorollm do task.wait()
      local verifyp = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin.Header.Text
      if verifyp == 'VAMPIRE' or verifyp == 'DOUBLEDMG' or verifyp == 'DAMAGESHIELD' then
        Fluent:Notify({
          Title = "Notification",
          Content = "The perk: " .. verifyp .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.PerkSpin
        Event:InvokeServer(
          tonumber(selectedpslot),
          nil,
          true
        )
      end
    end
  end
})
Tabs.AutoRoll:AddSection("[🎲] - Trait Roll")
Tabs.AutoRoll:AddDropdown("InterfaceTheme", {
  Title = "Select trait",
  KeepSearch = false,
  Values = { 'Power I', 'Power II', 'Power III', 'Agility I', 'Agility II', 'Agility III', 'Focus I', 'Focus II', 'Focus III', 'Intelligent', 'Fortune', 'Beast', 'Prodigy', 'Critical Chance', 'Critical Dmg'},
  Default = "--",
  Callback = function(Value)
    selectedtrait = Value
  end
})
Tabs.AutoRoll:AddDropdown("InterfaceTheme", {
  Title = "Select slot",
  KeepSearch = false,
  Values = {'1', '2', '3', '4', '5', '6'},
  Default = "--",
  Callback = function(Value)
    selectedtslot = Value
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll selected trait",
  Default = false,
  Callback = function(Value)
    tautoroll = Value
    if tautoroll then
      local traitgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits
      if traitgui.Visible == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-29, 10, 191)
        wait(0.5)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while tautoroll do task.wait()
      local verifyt = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Content.Main.F1.Trait.Frame.TraitName.Text
      if string.find(string.lower(verifyt), string.lower(selectedtrait)) then
        Fluent:Notify({
          Title = "Notification",
          Content = "The trait: " .. selectedtrait .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.RerollTrait
        Event:InvokeServer(
          tonumber(selectedtslot)
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until legendary",
  Default = false,
  Callback = function(Value)
    tautorolll = Value
    if tautorolll then
      local traitgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits
      if traitgui.Visible == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-29, 10, 191)
        wait(0.5)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while tautorolll do task.wait()
      local verifytl = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Content.Main.F1.Trait.Frame.TraitName.Text
      if verifytl == "Intelligent" or verifytl == "Fortune" or verifytl == "Beast" or verifytl == "Critical Chance" then
        Fluent:Notify({
          Title = "Notification",
          Content = "The trait: " .. verifytl .. ' has been collected',
          Duration = 5,

        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.RerollTrait
        Event:InvokeServer(
          tonumber(selectedtslot)
        )
      end
    end
  end
})
Tabs.AutoRoll:AddToggle("TransparentToggle", {
  Title = "Auto roll until secret",
  Default = false,
  Callback = function(Value)
    tautorolls = Value
    if tautorolls then
      local traitgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits
      if traitgui.Visible == false then
        game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Visible = true
        wait(0.5)
      end
      Fluent:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
      })
      wait(1.5)
    end
    while tautorolls do task.wait()
      local verifyts = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Content.Main.F1.Trait.Frame.TraitName.Text
      if verifyts == "Prodigy" or verifyts == "Critical Dmg" then
        Fluent:Notify({
          Title = "Notification",
          Content = "The trait: " .. verifyts .. ' has been collected',
          Duration = 5,
        })
        return
      else
        local Event = game:GetService("ReplicatedStorage").Packets.RerollTrait
        Event:InvokeServer(
          tonumber(selectedtslot)
        )
      end
    end
  end
})

Tabs.Teleport:AddSection("[🧑] - NPC Teleport ")
Tabs.Teleport:AddDropdown("InterfaceTheme", {
  Title = "Select npc",
  KeepSearch = false,
  Values = GetAllNpcs(),
  Default = "--",
  Callback = function(Value)
    selectednpc = Value
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to selected npc",
  Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
      workspace["NPC ANIM"][selectednpc]:FindFirstChild('HumanoidRootPart').CFrame
  end
})
Tabs.Teleport:AddSection("[🧑‍🦱] - Player Teleport ")
Tabs.Teleport:AddDropdown("InterfaceTheme", {
  Title = "Select a player",
  KeepSearch = false,
  Values = GetAllPlayers(),
  Default = "--",
  Callback = function(Value)
    selectednpc = Value
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to selected player",
  Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
      game.Players[SelectedPlayer].Character:FindFirstChild('HumanoidRootPart').CFrame
  end
})
Tabs.Teleport:AddToggle("TransparentToggle", {
  Title = "Spectate selected player",
  Default = false,
  Callback = function(Value)
    Spactate = Value
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
  end
})

Tabs.Misc:AddSection("[💫] - Misc Options")
Tabs.Misc:AddButton({
  Title = "Reedem all codes",
  Callback = function()
    local codes = {
      "Handfan",
      "NewCamp",
      "Beach",
      "Pirate",
      "ChasingDollars",
      "Reaper",
      "RIP67",
      "ScytheRP",
      "NEWBOSSRAID123",
      "HZ4EVER",
    }
    local remote = game:GetService("ReplicatedStorage"):WaitForChild("Packets"):WaitForChild("RedeemCode")
    for _, code in ipairs(codes) do
      remote:InvokeServer(code)
    end
  end
})
Tabs.Misc:AddButton({
  Title = "Open secret quest",
  Callback = function()
    fireproximityprompt(workspace.GUIPrompt.SecretQuests.prompt)
  end
})
Tabs.Teleport:AddButton({
  Title = "Open custom quest",
  Callback = function()
    fireproximityprompt(workspace.GUIPrompt.customquests.prompt)
  end
})
