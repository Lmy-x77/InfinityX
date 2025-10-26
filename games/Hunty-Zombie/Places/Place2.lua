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
setclipboard(tostring(game.PlaceId))

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


-- tabs
local Tabs = {
  AutoFarm = Window:AddTab({ Title = "| Autofarm", Icon = 'layout-template' }),
  Automatic = Window:AddTab({ Title = "| Automatic", Icon = "network" }),
  Character = Window:AddTab({ Title = "| Character", Icon = "user" }),
  Visual = Window:AddTab({ Title = "| Visual", Icon = "eye" }),
  Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" }),

}
Window:SelectTab(1)


-- source
Tabs.AutoFarm:AddSection("[👺] - Farming Zombie")
local p1 = Tabs.AutoFarm:AddParagraph({
  Title = "Kill Zombies Objective",
  Content = "unknown"
})
spawn(function()
  while true do task.wait()
    p1:SetDesc('Zombies Left: ' .. game:GetService("Players").LocalPlayer.PlayerGui.MainScreen.ObjectiveDisplay.ObjectiveElement.List.Value.Label.Text)
  end
end)
Tabs.AutoFarm:AddDropdown("InterfaceTheme", {
  Title = "Select auto attack mode",
  KeepSearch = false,
  Values = { "Normal", "Remote", "Fast" },
  Default = "Normal",
  Callback = function(Value)
    selectedmethodtoattack = Value
  end
})
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto teleport to zombies",
  Default = false,
  Callback = function(Value)
    farmsettings.Enabled = Value
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
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto attack",
  Default = false,
  Callback = function(Value)
    attack = Value
    while attack do task.wait()
      if not farmsettings.Enabled then continue end
      if selectedmethodtoattack == 'Normal' then
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
          if v:IsA('Tool') then
            v:Activate()
            wait(4)
            v:Deactivate()
            wait(1)
          end
        end
      elseif selectedmethodtoattack == 'Remote' then
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local ByteNetReliable = ReplicatedStorage:WaitForChild('ByteNetReliable')
        local workspace = game:GetService('Workspace')
        local args = {
          buffer.fromstring('\t\004\001'),
          { workspace:GetServerTimeNow() },
        }
        ByteNetReliable:FireServer(unpack(args))
      elseif selectedmethodtoattack == 'Fast' then
        local ReplicatedStorage = game:GetService('ReplicatedStorage')
        local ByteNetReliable = ReplicatedStorage:WaitForChild('ByteNetReliable')
        local Workspace = game:GetService('Workspace')
        local fireCount = 75
        local packet = buffer.fromstring('\t\004\001')
        local tickQueue = table.create(fireCount)
        local queueIndex = 1
        local function queueTicks(baseTick)
          for i = 1, fireCount do
            tickQueue[i] = baseTick
          end
          queueIndex = 1
        end
        while attack do task.wait()
          if queueIndex > fireCount then
            queueTicks(Workspace:GetServerTimeNow())
          end
          local tickToFire = tickQueue[queueIndex]
          queueIndex += 1
          ByteNetReliable:FireServer(packet, { tickToFire })
        end
      end
    end
  end
})
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto perk",
  Default = false,
  Callback = function(Value)
    perk = Value
    while perk do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('E')
    end
  end
})
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto awakening",
  Default = false,
  Callback = function(Value)
    awakening = Value
    while awakening do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('G')
    end
  end
})
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto collect items",
  Default = false,
  Callback = function(Value)
    collect = Value
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
Tabs.AutoFarm:AddSection("[☄️] - Auto Skills")
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto use Z",
  Default = false,
  Callback = function(Value)
    skillZ = Value
    while skillZ do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('Z')
    end
  end
})
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto use X",
  Default = false,
  Callback = function(Value)
    skillX = Value
    while farmsettings.Enabled and skillX do task.wait()
      KeyPress('X')
    end
  end
})
Tabs.AutoFarm:AddToggle("TransparentToggle", {
  Title = "Auto use C",
  Default = false,
  Callback = function(Value)
    skillC = Value
    while skillC do task.wait()
      if not farmsettings.Enabled then continue end
      KeyPress('C')
    end
  end
})

Tabs.Automatic:AddSection("[🤖] - Automatic Options")
local p2 = Tabs.Automatic:AddParagraph({
  Title = "Auto escape status",
  Content = "unknown"
})
Tabs.Automatic:AddToggle("TransparentToggle", {
  Title = "Auto find radio/ generator",
  Default = false,
  Callback = function(Value)
    radio = Value
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
Tabs.Automatic:AddToggle("TransparentToggle", {
  Title = "Auto escape",
  Default = false,
  Callback = function(Value)
    escape = Value
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
          elseif string.find(string.lower(v.Text), 'defeat') then
            for _, v in pairs(workspace.Entities.Zombie:GetChildren()) do
              if v:IsA('Model') and v.Name == '1' and alive(v) then
                p2:SetDesc('Boss Status: Alive\nTeleported player to kill the boss')
                local hrpZombie = v:FindFirstChild("HumanoidRootPart")
                local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")

                if not alive(v) then
                  p2:SetDesc('Boss Status: Dead\nTeleport to player to safe zone\nWaiting to escape...')
                  CreatePlataform()
                  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(15, 21, 54)
                end
                if hrpZombie and hrp then
                  hrp.CFrame = hrpZombie.CFrame * CFrame.new(0, 10, 4.2)
                  break
                end
              end
            end
          end
        end
      end
    end
  end
})
Tabs.Automatic:AddToggle("TransparentToggle", {
  Title = "Auto open doors",
  Default = false,
  Callback = function(Value)
    doors = Value
    while doors do
      local sewers = workspace:FindFirstChild("Sewers")
      if sewers and sewers:FindFirstChild("Doors") then
        for _, door in ipairs(sewers.Doors:GetChildren()) do
          local args = { buffer.fromstring("\b\001"), {door} }
          game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
          task.wait(0.1)
        end
      end
      local school = workspace:FindFirstChild("School")
      if school and school:FindFirstChild("Doors") then
        for _, door in ipairs(school.Doors:GetChildren()) do
          local args = { buffer.fromstring("\b\001"), {door} }
          game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
          task.wait(0.1)
        end
      end
      local carnival = workspace:FindFirstChild("Carnival")
      if carnival and carnival:FindFirstChild("Doors") then
        for _, door in ipairs(carnival.Doors:GetChildren()) do
          local args = { buffer.fromstring("\b\001"), {door} }
          game.ReplicatedStorage:WaitForChild("ByteNetReliable"):FireServer(unpack(args))
          task.wait(0.1)
        end
      end
      task.wait(1)
    end
  end
})
Tabs.Automatic:AddToggle("TransparentToggle", {
  Title = "Auto replay",
  Default = false,
  Callback = function(Value)
    autorep = Value
    while autorep do task.wait(1)
      game.ReplicatedStorage:WaitForChild("external"):WaitForChild("Packets"):WaitForChild("voteReplay"):FireServer()
    end
  end
})
Tabs.Automatic:AddToggle("TransparentToggle", {
  Title = "Auto change weapon",
  Default = false,
  Callback = function(Value)
    changew = Value
    while changew do
      KeyPress(Enum.KeyCode.One.Name)
      wait(.5)
    end
  end
})
Tabs.Automatic:AddToggle("TransparentToggle", {
  Title = "Instant prompt",
  Default = false,
  Callback = function(Value)
    instantp = Value
    while instantp do task.wait(10)
      for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA('ProximityPrompt') then
          v.HoldDuration = 0
        end
      end
    end
  end
})

Tabs.Character:AddSection("[🙍] - Character Options")
Tabs.Character:AddInput("Input", {
  Title = "WalkSpeed",
  Default = "",
  Placeholder = "16",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
  end
})
Tabs.Character:AddInput("Input", {
  Title = "JumpPower",
  Default = "",
  Placeholder = "50",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
  end
})
Tabs.Character:AddToggle("Toggle", {
  Title = "Noclip",
  Default = false,
  Callback = function(Value)
    noclip = Value
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
Tabs.Character:AddButton({
  Title = "Change range of bow",
  Callback = function()
    local Bow = require(game:GetService("ReplicatedFirst").GameCore.Shared.AbilityService.CombatData.Bow)
    for _, hitbox in pairs(Bow.hitboxes) do
      if typeof(hitbox) == "table" then
        if hitbox.lifetime then hitbox.lifetime = math.huge end
        if hitbox.vel then hitbox.vel = hitbox.vel.Unit * 999999 end
        hitbox.ignoreWalls = true
        hitbox.static = false
        hitbox.hitOnce = false
      end
    end
    local old = Bow.newHitbox
    Bow.newHitbox = function(data, ...)
      local hb = old and old(data, ...) or data
      if hb and hb.RaycastParams then
        hb.RaycastParams.FilterType = Enum.RaycastFilterType.Blacklist
        hb.RaycastParams.FilterDescendantsInstances = {workspace.Terrain, workspace.Map}
      end
      return hb
    end
  end
})

Tabs.Visual:AddSection("[👀] - ESP Options")
Tabs.Visual:AddToggle("Toggle", {
  Title = "ESP Zombies",
  Default = false,
  Callback = function(Value)
    EspLib.ESPValues.ZombieESP = Value
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
Tabs.Visual:AddToggle("Toggle", {
  Title = "ESP Doors",
  Default = false,
  Callback = function(Value)
    EspLib.ESPValues.DoorsESP = Value
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
Tabs.Visual:AddToggle("Toggle", {
  Title = "ESP Items",
  Default = false,
  Callback = function(Value)
    EspLib.ESPValues.ItemESP = Value
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
Tabs.Visual:AddToggle("Toggle", {
  Title = "ESP Players",
  Default = false,
  Callback = function(Value)
    EspLib.ESPValues.PlayerESP = Value
    if EspLib.ESPValues.PlayerESP then
      for _, v in pairs(game.Players:GetPlayers()) do
        applyESPToPlayers(v)
      end
      game.Players.PlayerAdded:Connect(applyESPToPlayers)
    end
  end
})

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("InfinityX")
SaveManager:SetFolder("InfinityX/Library-Settings")
SaveManager:BuildConfigSection(Tabs.Settings)
Fluent:ToggleTransparency(false)
SaveManager:LoadAutoloadConfig()
