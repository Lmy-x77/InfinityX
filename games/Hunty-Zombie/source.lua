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


-- ui library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
WindUI:AddTheme({
  Name = "InfinityX",
  Accent = "#1a1a1d",
  Outline = "#5a1ebc",
  Text = "#cbb2ff",
  Placeholder = "#7a7a7a",
  Background = "#0c0c0f",
  Button = "#7c3aed",
  Icon = "#9d4edd",
})
local Window = WindUI:CreateWindow({
    Title = '<font color="rgb(175, 120, 255)" size="18"><b>InfinityX</b></font>',
    Icon = "rbxassetid://72212320253117",
    Author = '<font color="rgb(160,160,160)" size="10"><i>by lmy77</i></font>',
    Folder = "MySuperHub",
    Size = UDim2.fromOffset(580, 460),
    Transparent = true,
    Theme = "InfinityX",
    Resizable = true,
    SideBarWidth = 140,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function()
            print("clicked")
        end,
    },
})
Window:EditOpenButton({
  Title = "Click here to open "..gradient("InfinityX", Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204)),
  Icon = "monitor",
  CornerRadius = UDim.new(0,16),
  StrokeThickness = 1.2,
  Color = ColorSequence.new(
    Color3.fromRGB(129, 63, 214),
    Color3.fromRGB(63, 61, 204)
  ),
  Enabled = true,
  Dragable = false,
})
Window:Tag({
    Title = "v4.2a",
    Color = Color3.fromRGB(129, 63, 214)
})
Window:SetToggleKey(Enum.KeyCode.K)


-- tabs
local LobbySection = Window:Section({
  Title = "Lobby",
  Opened = true,
})
local CreateLobbyTab = LobbySection:Tab({
  Title = "Auto Lobby",
  Icon = "diamond-plus",
  Locked = false,
})
local ModificationTab = LobbySection:Tab({
  Title = "Modification",
  Icon = "crown",
  Locked = false,
})
local AutoRollTab = LobbySection:Tab({
  Title = "Auto Rollㅤㅤ",
  Icon = "refresh-cw",
  Locked = false,
})
local TeleportTab = LobbySection:Tab({
  Title = "Teleportㅤㅤ",
  Icon = "crosshair",
  Locked = false,
})
local MiscTab = LobbySection:Tab({
  Title = "Miscㅤㅤㅤㅤ",
  Icon = "layers",
  Locked = false,
})
local ArenaSection = Window:Section({
  Title = "Arena",
  Opened = true,
})
local AutoFarmTab = ArenaSection:Tab({
  Title = "Auto Farmㅤ",
  Icon = "workflow",
  Locked = false,
})
local AutomaticTab = ArenaSection:Tab({
  Title = "Automaticㅤ",
  Icon = "network",
  Locked = false,
})
local CharacterTab = ArenaSection:Tab({
  Title = "Characterㅤ",
  Icon = "user",
  Locked = false,
})
local VisualTab = ArenaSection:Tab({
  Title = "Visualㅤㅤㅤㅤ",
  Icon = "eye",
  Locked = false,
})


-- source
CreateLobbyTab:Section({ 
  Title = "Auto Join Game",
  TextXAlignment = "Left",
  TextSize = 17,
})
CreateLobbyTab:Dropdown({
  Title = "Select map",
  Values = { "School", "Sewers", "Carnival" },
  Value = "none",
  Callback = function(option)
    selectedmap = option
  end
})
CreateLobbyTab:Dropdown({
  Title = "Select difficulty",
  Values = { "Normal", "Hard", "Nightmare" },
  Value = "none",
  Callback = function(option)
    selecteddifficulty = option
  end
})
CreateLobbyTab:Dropdown({
  Title = "Select player size",
  Values = { '1', '2', '3', '4', '5', '6' },
  Value = 'none',
  Callback = function(option)
    selectedPlayerSize = option
  end
})
CreateLobbyTab:Toggle({
  Title = "Auto join game",
  Desc = "Activate to create the lobby with the desired settings above",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    autojoin = state
    while autojoin do task.wait()
      local gui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo
      if gui.Visible == false then
        for _, v in pairs(workspace.Match:GetDescendants()) do
          if v:IsA("TouchTransmitter") and v.Parent.MatchBoard.InfoLabel.Text == 'Start Here' then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
            task.wait()
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
          end
        end
      elseif gui.Visible == true then
        if selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'School' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return

        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Sewers' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return

        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Normal' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Hard' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[3])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '1' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '2' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '3' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '4' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '5' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.playerselect.F.l)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        elseif selectedmap == 'Carnival' and selecteddifficulty == 'Nightmare' and selectedPlayerSize == '6' then
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosemodes)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.maps:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.options.buttons.choosediffs)
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.modes:GetChildren()[4])
          wait()
          ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.StartPlaceRedo.Content.iContent.Button)
          GuiService.GuiNavigationEnabled = false
          return
        end
      end
    end
  end
})

ModificationTab:Section({ 
  Title = "Mods Option [ PATCHED ]",
  TextXAlignment = "Left",
  TextSize = 17,
})
ModificationTab:Dropdown({
  Title = "Select slot",
  Values = {'1', '2', '3', '4', '5', '6'},
  Value = "none",
  Callback = function(option)
    selectedslotw = option
  end
})
ModificationTab:Dropdown({
  Title = "Select weapon",
  Values = {'Dagger', 'Scythe'},
  Value = "none",
  Callback = function(option)
    selectedweaponw = option
  end
})
ModificationTab:Button({
  Title = "Get weapon",
  Locked = false,
  Callback = function()
    local args = {
      tonumber(selectedslotw),
      selectedweaponw
    }
    game:GetService("ReplicatedStorage").Packets.EquipWeaponByItem:InvokeServer(unpack(args))
  end
})

AutoRollTab:Section({ 
  Title = "Weapon Roll",
  TextXAlignment = "Left",
  TextSize = 17,
})
AutoRollTab:Dropdown({
  Title = "Select weapon",
  Values = { "Baseball", "Axes", 'Guitar', 'Dual Gun', 'Zombie Claws', 'Katana', 'Greatsword', 'Scissors' },
  Value = "none",
  Callback = function(option)
    selectedweapon = option
  end
})
AutoRollTab:Dropdown({
  Title = "Select slot",
  Values = { "1", "2", '3', '4', '5', '6' },
  Value = "none",
  Callback = function(option)
    selectedslot = option
  end
})
AutoRollTab:Toggle({
  Title = "Auto roll selected",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    autoroll = state
    if autoroll then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while autoroll do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if string.find(string.lower(verify), string.lower(selectedweapon)) then
        WindUI:Notify({
          Title = "Notification",
          Content = "The weapon: " .. selectedweapon .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Toggle({
  Title = "Auto roll until legendary",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    autorolll = state
    if autorolll then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while autorolll do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if verify == 'GUITAR' or verify == 'DUAL GUN' or verify == 'ZOMBIE CLAWS' then
        WindUI:Notify({
          Title = "Notification",
          Content = "The weapon: " .. verify .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Toggle({
  Title = "Auto roll until mythic",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    autorollm = state
    if autorollm then
      local spingui = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28]
      if spingui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Weapon.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while autorollm do task.wait()
      local verify = game:GetService("Players").LocalPlayer.PlayerGui.GUI:GetChildren()[28].Header.Text
      if verify == 'KATANA' or verify == 'GREATSWORD' or verify == 'SCISSORS' then
        WindUI:Notify({
          Title = "Notification",
          Content = "The weapon: " .. verify .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Section({ 
  Title = "Perks Roll",
  TextXAlignment = "Left",
  TextSize = 17,
})
AutoRollTab:Dropdown({
  Title = "Select perk",
  Values = { "Berserker", "Healer", "Flame", "Critical", "Undead", "Vampire", "DoubleDmg" },
  Value = "none",
  Callback = function(option)
    selectedperk = option
  end
})
AutoRollTab:Dropdown({
  Title = "Select slot",
  Values = { "1", "2", '3', '4', '5', '6' },
  Value = "none",
  Callback = function(option)
    selectedpslot = option
  end
})
AutoRollTab:Toggle({
  Title = "Auto roll selected",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    pautoroll = state
    if pautoroll then
      local perkgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin
      if perkgui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Perks.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while pautoroll do task.wait()
      local verifyp = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin.Header.Text
      if string.find(string.lower(verifyp), string.lower(selectedperk)) then
        WindUI:Notify({
          Title = "Notification",
          Content = "The perk: " .. selectedperk .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Toggle({
  Title = "Auto roll until legendary",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    pautorolll = state
    if pautorolll then
      local perkgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin
      if perkgui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Perks.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while pautorolll do task.wait()
      local verifyp = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin.Header.Text
      if verifyp == 'CRITICAL' or verifyp == 'UNDEAD' then
        WindUI:Notify({
          Title = "Notification",
          Content = "The perk: " .. verifyp .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Toggle({
  Title = "Auto roll until mythic",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    pautorollm = state
    if pautorollm then
      local perkgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin
      if perkgui.Visible == false then
        ClickGuiNavigation(game:GetService("Players").LocalPlayer.PlayerGui.GUI.Hud.Left.Row1.Perks.Shape.Fill)
        GuiService.GuiNavigationEnabled = false
        wait(1)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while pautorollm do task.wait()
      local verifyp = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Spin.Header.Text
      if verifyp == 'VAMPIRE' or verifyp == 'DOUBLEDMG' then
        WindUI:Notify({
          Title = "Notification",
          Content = "The perk: " .. verifyp .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Section({
  Title = "Trait Roll",
  TextXAlignment = "Left",
  TextSize = 17,
})
AutoRollTab:Dropdown({
  Title = "Select slot",
  Values = { '1', '2', '3', '4', '5', '6' },
  Value = "none",
  Callback = function(option)
    selectedtslot = option
  end
})
AutoRollTab:Dropdown({
  Title = "Select trait",
  Values = { 'Power I', 'Power II', 'Power III', 'Agility I', 'Agility II', 'Agility III', 'Focus I', 'Focus II', 'Focus III', 'Intelligent', 'Fortune', 'Beast', 'Prodigy' },
  Value = "none",
  Callback = function(option)
    selectedtrait = option
  end
})
AutoRollTab:Toggle({
  Title = "Auto roll selected",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    tautoroll = state
    if tautoroll then
      local traitgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits
      if traitgui.Visible == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-29, 10, 191)
        wait(0.5)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while tautoroll do task.wait()
      local verifyt = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Content.Main.F1.Trait.Frame.TraitName.Text
      if string.find(string.lower(verifyt), string.lower(selectedtrait)) then
        WindUI:Notify({
          Title = "Notification",
          Content = "The trait: " .. selectedtrait .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Toggle({
  Title = "Auto roll until legendary",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    tautorolll = state
    if tautorolll then
      local traitgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits
      if traitgui.Visible == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-29, 10, 191)
        wait(0.5)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while tautorolll do task.wait()
      local verifytl = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Content.Main.F1.Trait.Frame.TraitName.Text
      if verifytl == "Intelligent" or verifytl == "Fortune" or verifytl == "Beats" then
        WindUI:Notify({
          Title = "Notification",
          Content = "The trait: " .. verifytl .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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
AutoRollTab:Toggle({
  Title = "Auto roll until secret",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    tautorolls = state
    if tautorolls then
      local traitgui = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits
      if traitgui.Visible == false then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-29, 10, 191)
        wait(0.5)
      end
      WindUI:Notify({
        Title = "Notification",
        Content = "Staring auto roll...",
        Duration = 3,
        Icon = "rbxassetid://72212320253117",
      })
      wait(1.5)
    end
    while tautorolls do task.wait()
      local verifyts = game:GetService("Players").LocalPlayer.PlayerGui.GUI.Traits.Content.Main.F1.Trait.Frame.TraitName.Text
      if verifyts == "Prodigy" then
        WindUI:Notify({
          Title = "Notification",
          Content = "The trait: " .. verifyts .. ' has been collected',
          Duration = 5,
          Icon = "rbxassetid://72212320253117",
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

TeleportTab:Section({ 
  Title = "NPC Teleport",
  TextXAlignment = "Left",
  TextSize = 17,
})
TeleportTab:Dropdown({
  Title = "Select npc",
  Values = GetAllNpcs(),
  Value = "none",
  Callback = function(option)
    selectednpc = option
  end
})
TeleportTab:Button({
  Title = "Teleport to selected npc",
  Locked = false,
  Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
      workspace["NPC ANIM"][selectednpc]:FindFirstChild('HumanoidRootPart').CFrame
  end
})
TeleportTab:Section({ 
  Title = "Player Teleport",
  TextXAlignment = "Left",
  TextSize = 17,
})
TeleportTab:Dropdown({
  Title = "Select player",
  Values = GetAllPlayers(),
  Value = "none",
  Callback = function(option)
    SelectedPlayer = option
  end
})
TeleportTab:Button({
  Title = "Teleport to selected player",
  Locked = false,
  Callback = function()
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
      game.Players[SelectedPlayer].Character:FindFirstChild('HumanoidRootPart').CFrame
  end
})
TeleportTab:Toggle({
  Title = "Spectate selected player",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    Spactate = state
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

MiscTab:Section({
  Title = "Misc Options",
  TextXAlignment = "Left",
  TextSize = 17,
})
MiscTab:Button({
  Title = "Reedem all codes",
  Locked = false,
  Callback = function()
    local codes = { '500KLIKES', '200K67', 'HZCrafting2', 'HZCrafting', 'B4UPD3', 'EMOTEISHERE', 'UPD3', 'ZOMBIECLAW', 'SCISSORS', 'latehunty' }
    for _, v in pairs(codes) do
      local Event = game:GetService("ReplicatedStorage").Packets.RedeemCode
      Event:InvokeServer(
        v
      )
      task.wait()
    end
  end
})
MiscTab:Button({
  Title = "Open secret quest",
  Locked = false,
  Callback = function()
    fireproximityprompt(workspace.GUIPrompt.SecretQuests.prompt)
  end
})
MiscTab:Button({
  Title = "Open custom quest",
  Locked = false,
  Callback = function()
    fireproximityprompt(workspace.GUIPrompt.customquests.prompt)
  end
})

AutoFarmTab:Section({
  Title = "Farming Zombie",
  TextXAlignment = "Left",
  TextSize = 17,
})
local p1 = AutoFarmTab:Paragraph({
  Title = "Object Status",
  Desc = "nil",
  Image = "chart-line",
  ImageSize = 20,
  Color = Color3.fromHex("#1a1a1d"),
})
spawn(function()
  while true do task.wait()
    p1:SetDesc('Zombies Left: ' .. game:GetService("Players").LocalPlayer.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List.Value.Label.Text)
  end
end)
local tpzombieToggle = AutoFarmTab:Toggle({
  Title = "Auto teleport zombie",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    farmsettings.Enabled = state
    while farmsettings.Enabled do task.wait()
      for _, v in pairs(workspace.Entities.Zombie:GetChildren()) do
        if v:IsA("Model") and alive(v) then
          local hrpZombie = v:FindFirstChild("HumanoidRootPart")
          local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
          local hrp = char and char:FindFirstChild("HumanoidRootPart")

          if hrpZombie and hrp then
            hrp.CFrame = hrpZombie.CFrame * CFrame.new(0, 5, 4.2)
            break
          end
        end
      end
    end
  end
})
AutoFarmTab:Toggle({
  Title = "Auto attack",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    attack = state
    while attack do task.wait()
      if not farmsettings.Enabled then continue end
      for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA('Tool') then
          v:Activate()
          wait(4)
          v:Deactivate()
          wait(1)
        end
      end
    end
  end
})
AutoFarmTab:Toggle({
  Title = "Auto perk",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    perk = state
    while perk do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('E')
    end
  end
})
AutoFarmTab:Toggle({
  Title = "Auto awakening",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    awakening = state
    while awakening do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('G')
    end
  end
})
AutoFarmTab:Toggle({
  Title = "Auto collect items",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    collect = state
    while collect do task.wait()
      if not farmsettings.Enabled then continue end
      for _, v in pairs(workspace.DropItems:GetChildren()) do
        if v:IsA('Part') then
          game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
        end
      end
    end
  end
})
AutoFarmTab:Section({ 
  Title = "Auto Skills",
  TextXAlignment = "Left",
  TextSize = 17,
})
AutoFarmTab:Toggle({
  Title = "Auto use Z",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    skillZ = state
    while skillZ do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('Z')
    end
  end
})
AutoFarmTab:Toggle({
  Title = "Auto use X",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    skillX = state
    while farmsettings.Enabled and skillX do task.wait()
      KeyPress('X')
    end
  end
})
AutoFarmTab:Toggle({
  Title = "Auto use C",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    skillC = state
    while skillC do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('C')
    end
  end
})

AutomaticTab:Section({ 
  Title = "Automatic Options",
  TextXAlignment = "Left",
  TextSize = 17,
})
local p2 = AutomaticTab:Paragraph({
  Title = "Auto Escape Status",
  Desc = "unknown",
  Image = "chart-line",
  ImageSize = 20,
  Color = Color3.fromHex("#1a1a1d"),
})
AutomaticTab:Toggle({
  Title = "Auto find radio / generator",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    radio = state
    while radio do task.wait()
      for _, v in pairs(workspace:GetDescendants()) do
        if (v:IsA("Part") or v:IsA("MeshPart")) and (v.Name == "RadioObjective" or v.Name == "gen") then
          local prompt = v:FindFirstChildWhichIsA("ProximityPrompt")
          if prompt and prompt.Enabled then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame
            fireproximityprompt(prompt)
          end
        end
      end
    end
  end
})
AutomaticTab:Toggle({
  Title = "Auto escape",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    escape = state
    if escape then
      p2:SetDesc('Waiting for survival time')
    end
    while escape do task.wait()
      for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild('MainScreen'):WaitForChild('ObjectiveDisplay'):WaitForChild('ObjectiveElement'):WaitForChild('List'):GetDescendants()) do
        if v:IsA('TextLabel') and v.Name == 'Description' then
          if string.find(string.lower(v.Text), 'survive') then
            if farmsettings.Enabled == true then p2:SetDesc('Disabled teleport to zombie') tpzombieToggle:Set(false) end
            wait(1)
            p2:SetDesc('Teleported to safe zone\nwaiting for: ' .. game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild('MainScreen'):WaitForChild('ObjectiveDisplay'):WaitForChild('ObjectiveElement'):WaitForChild('List'):WaitForChild('Value'):WaitForChild('Label').Text .. ' left')
            CreatePlataform()
            local findzombie = workspace.Entities:FindFirstChild('Zombie')
            if findzombie then
              for _, v in pairs(findzombie:GetChildren()) do
                if v:IsA('Model') then
                  v:Destroy()
                end
              end
              wait(0.5)
              game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(15, 21, 54)
            end
          elseif string.find(string.lower(v.Text), 'escape') then
            for _, v in pairs(workspace:GetDescendants()) do
              if v:IsA('Part') and v.Name == 'HeliObjective' then
                if v.ProximityPrompt.Enabled == true then
                  wait(5)
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 40, 0)
                  wait(2)
                  fireproximityprompt(v.ProximityPrompt)
                  wait(1)
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 1000, 0)
                end
              end
            end
          end
        end
      end
    end
  end
})
AutomaticTab:Toggle({
  Title = "Auto open doors",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    doors = state
    while doors do
      local sewers = workspace:FindFirstChild("Sewers")
      if sewers and sewers:FindFirstChild("Doors") then
        for _, door in ipairs(sewers.Doors:GetChildren()) do
          local args = { buffer.fromstring("\a\001"), {door} }
          game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
          task.wait(0.1)
        end
      end
      local school = workspace:FindFirstChild("School")
      if school and school:FindFirstChild("Doors") then
        for _, door in ipairs(school.Doors:GetChildren()) do
          local args = { buffer.fromstring("\a\001"), {door} }
          game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
          task.wait(0.1)
        end
      end
      local carnival = workspace:FindFirstChild("Carnival")
      if carnival and carnival:FindFirstChild("Doors") then
        for _, door in ipairs(carnival.Doors:GetChildren()) do
          local args = { buffer.fromstring("\a\001"), {door} }
          game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
          task.wait(0.1)
        end
      end
      task.wait(1)
    end
  end
})
AutomaticTab:Toggle({
  Title = "Auto replay",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    autorep = state
    while autorep do task.wait(1)
      game.ReplicatedStorage:WaitForChild("external"):WaitForChild("Packets"):WaitForChild("voteReplay"):FireServer()
    end
  end
})
AutomaticTab:Toggle({
  Title = "Auto change weapon",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    changew = state
    while changew do
      KeyPress(Enum.KeyCode.One.Name)
      wait(15)
    end
  end
})
AutomaticTab:Toggle({
  Title = "Instant prompts",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    instantp = state
    while instantp do task.wait(10)
      for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA('ProximityPrompt') then
          v.HoldDuration = 0
        end
      end
    end
  end
})

CharacterTab:Section({
  Title = "Character Options",
  TextXAlignment = "Left",
  TextSize = 17,
})
CharacterTab:Slider({
  Title = "WalkSpeed",
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
CharacterTab:Slider({
  Title = "JumpPower",
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
CharacterTab:Toggle({
  Title = "Noclip",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    noclip = state
    if noclip then
      for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA('Part') and (v.Name == 'Hitbox' or v.Name == 'HumanoidRootPart') then
          v.CanCollide = false
        end
      end
    else
      for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA('Part') and (v.Name == 'Hitbox' or v.Name == 'HumanoidRootPart') then
          v.CanCollide = true
        end
      end
    end
  end
})

VisualTab:Section({
  Title = "Esp Options",
  TextXAlignment = "Left",
  TextSize = 17,
})
VisualTab:Toggle({
  Title = "Esp zombie",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    EspLib.ESPValues.ZombieESP = state
    if EspLib.ESPValues.ZombieESP then
      applyESPToZombie()
      workspace.Entities.Zombie.ChildAdded:Connect(function(zombie)
        if EspLib.ESPValues.ZombieESP and zombie:IsA('Model') then
          applyESPToZombie()
        end
      end)
    end
  end
})
VisualTab:Toggle({
  Title = "Esp doors",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    EspLib.ESPValues.DoorsESP = state
    if EspLib.ESPValues.DoorsESP then
      applyESPToDoors()
      for _, v in pairs(workspace:GetChildren()) do
        if v:IsA('Model') and (v.Name == 'School' or v.Name == 'Sewers' or v.Name == 'Carnival') then
          v:FindFirstChild('Doors').ChildAdded:Connect(function(item)
            if EspLib.ESPValues.DoorsESP and item:IsA('Model') then
              applyESPToDoors()
            end
          end)
        end
      end
    end
  end
})
VisualTab:Toggle({
  Title = "Esp items",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    EspLib.ESPValues.ItemESP = state
    if EspLib.ESPValues.ItemESP then
      applyESPToItems()
      workspace.DropItems.ChildAdded:Connect(function(item)
        if EspLib.ESPValues.ItemESP and item:IsA('Part') then
          applyESPToItems()
        end
      end)
    end
  end
})
VisualTab:Toggle({
  Title = "Esp players",
  Icon = "check",
  Type = "Checkbox",
  Default = false,
  Callback = function(state)
    EspLib.ESPValues.PlayerESP = state
    if EspLib.ESPValues.PlayerESP then
      for _, v in pairs(game.Players:GetPlayers()) do
        applyESPToPlayers(v)
      end
      game.Players.PlayerAdded:Connect(applyESPToPlayers)
    end
  end
})


-- extra
if game.PlaceId == 103754275310547 then
  Window:SelectTab(1)
  wait()
  ArenaSection:Close()
  LobbySection:Close()
  wait(.2)
  LobbySection:Open()
elseif game.PlaceId == 86076978383613 then
  Window:SelectTab(6)
  wait()
  LobbySection:Close()
  ArenaSection:Close()
  wait(.2)
  ArenaSection:Open()
end
