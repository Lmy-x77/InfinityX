-- detect service
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



-- variables
local amounts = {5, 10, 25, 50, 100}
local collectMoneySettings ={
  EspColor = Color3.fromRGB(0, 255, 0),
}
local function AntiRagdoll()
  local scriptTarget = game.Players.LocalPlayer.Character:FindFirstChild('Ragdoll').RagdollInput
  local v1 = require(game:GetService("ReplicatedStorage").Modules.CombatSystem)
  local v2 = v1.knockoutCharacter
  local bypass;
  for _, func in pairs(getgc(true)) do
    if typeof(func) == "function" and getfenv(func).script == scriptTarget then
      for i = 1, debug.getinfo(func).nups do
        debug.setupvalue(func, i, function() return nil end)
      end
      hookfunction(func, function() end)
    end
  end
  for _, conn in pairs(getconnections(scriptTarget.AncestryChanged)) do conn:Disable() end
  for _, conn in pairs(getconnections(scriptTarget.Changed)) do conn:Disable() end
  for _, conn in pairs(getconnections(scriptTarget:GetPropertyChangedSignal("Parent"))) do conn:Disable() end
  bypass = hookmetamethod(game, "__namecall", function(method, ...)
    if getnamecallmethod() == "FireServer" and method == game.Players.LocalPlayer.Character.Ragdoll.RagdollEvent then
      return
    end
    return bypass(method, ...)
  end)
  hookfunction(v2, function() end)
end
local function FireTool(ToolName)
  for i,v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
      if v.Name == ToolName then
          v.Parent = game.Players.LocalPlayer.Character
      end
   end
  for i,v in pairs (game.Players.LocalPlayer.Character:GetChildren()) do
      if v.Name == ToolName then
          v:Activate()
      end
  end
end
local function EquipTool(ToolName)
  for i, v in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
      if v:IsA('Tool') and v.Name == ToolName then
          game.Players.LocalPlayer.Character.Humanoid:EquipTool(v);
      end
  end
end
local function GetPlayersName()
  local plrs = {}
  for i, v in pairs(game.Players:GetChildren()) do
      if v.Name ~= game.Players.LocalPlayer.Name then
          table.insert(plrs, v.Name)
      end
  end
  return plrs
end
local scriptVersion = "4.2a"



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
  Footer = "Gang Up On People Simulator · ".. scriptVersion .. " · discord.gg/emKJgWMHAr",
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
  LPlayer = Window:AddTab("Character", "user"),
  Money = Window:AddTab("Money", "banknote"),
  Shop = Window:AddTab("Shop", "shopping-cart"),
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local MoneyGroupBox = Tabs.Farm:AddLeftGroupbox("Money Farm", "hand-coins")
local PlayerGroupBox = Tabs.Farm:AddRightGroupbox("Player Farm", "users")
local MiscGroupBox = Tabs.Farm:AddLeftGroupbox("Misc", "layers")
MoneyGroupBox:AddToggle("MyToggle", {
	Text = "Collect all money",
	Tooltip = "Active to collect all money in the map",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoMoney = Value
    if autoMoney then
      Library:Notify({
        Title = "InfinityX",
        Description = "Auto collect money activated",
        Time = 4,
      })
    end
    while autoMoney do task.wait()
      for i, v in pairs(workspace.Particles:GetChildren()) do
        if v:IsA('Model') and v.Name == 'Money' then
          game.Players.LocalPlayer.Character:PivotTo(v:GetPivot())
          task.wait(.2)
        end
      end
    end
	end,
})
MoneyGroupBox:AddToggle("MyToggle", {
	Text = "Collect money + deposit",
	Tooltip = "Active to collect all and deposit money in the map",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    autoMoneyDeposit = Value
    if autoMoney then
      Library:Notify({
        Title = "InfinityX",
        Description = "Auto collect money and deposit activated",
        Time = 4,
      })
    end
    while autoMoneyDeposit do task.wait()
      for i, v in pairs(workspace.Particles:GetChildren()) do
        if v:IsA('Model') and v.Name == 'Money' then
          game.Players.LocalPlayer.Character:PivotTo(v:GetPivot())
          task.wait(.2)
        end
      end
      local args = {[1] = {["Amount"] = 1,["Mode"] = "D"}}
      game:GetService("ReplicatedStorage").RemoteEvent.ATM:FireServer(unpack(args))
    end
	end,
})
MoneyGroupBox:AddToggle("MyToggle", {
	Text = "Esp money",
	Tooltip = "Active to view all money in the map",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    espMoney = Value
    if espMoney then
      Library:Notify({
        Title = "InfinityX",
        Description = "Esp money activated",
        Time = 4,
      })
      for _, v in pairs(workspace.Particles:GetChildren()) do
        if v:IsA('Model') and v.Name == 'Money' then
            local espBoat = Instance.new('Highlight', v)
            espBoat.Name = "EspMoney"
            espBoat.FillColor = collectMoneySettings.EspColor

            local billboard = Instance.new("BillboardGui", v.PrimaryPart)
            billboard.Name = "MoneyName"
            billboard.Size = UDim2.new(0, 100, 0, 40)
            billboard.StudsOffset = Vector3.new(0, 3, 0)
            billboard.AlwaysOnTop = true

            local label = Instance.new("TextLabel", billboard)
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.Text = "💵 Money"
            label.TextColor3 = collectMoneySettings.EspColor
            label.TextStrokeTransparency = 0
            label.Font = Enum.Font.GothamBold
            label.TextScaled = true
        end
      end
    else
      for _, v in pairs(workspace.Particles:GetDescendants()) do
          if v:IsA("Highlight") and v.Name == "EspMoney" then
              v:Destroy()
          end
      end
      for _, v in pairs(workspace.Particles:GetDescendants()) do
          if v:IsA("BillboardGui") and v.Name == "MoneyName" then
              v:Destroy()
          end
      end
    end
    workspace.Particles.ChildAdded:Connect(function(money)
      if espMoney and money:IsA("Model") and not money:FindFirstChild("EspBoat") then
        local espBoat = Instance.new("Highlight", money)
        espBoat.Name = "EspMoney"
        espBoat.FillColor = collectMoneySettings.EspColor

        local primary = money:WaitForChild("Bundle", 5)
        if not primary then return end

        local billboard = Instance.new("BillboardGui", primary)
        billboard.Name = "MoneyName"
        billboard.Size = UDim2.new(0, 100, 0, 40)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true

        local label = Instance.new("TextLabel", billboard)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "💵 Money"
        label.TextColor3 = collectMoneySettings.EspColor
        label.TextStrokeTransparency = 0
        label.Font = Enum.Font.GothamBold
        label.TextScaled = true
      end
    end)
	end,
}):AddColorPicker("ColorPicker1", {
  Default = Color3.fromRGB(0, 255, 0),
  Title = "Esp money color",
  Transparency = 0,

  Callback = function(Value)
    collectMoneySettings.EspColor = Value
  end,
})
PlayerGroupBox:AddDropdown("PlayersDropdown", {
	Values = GetPlayersName(),
	Default = '...',
	Multi = false,

	Text = "Select a player",
	Tooltip = "Select a player to farm",
	DisabledTooltip = "I am disabled!",

	Searchable = true,

	Callback = function(Value)
		selectedPlayer = Value
    print(selectedPlayer)
	end,

	Disabled = false,
	Visible = true,
})
PlayerGroupBox:AddDropdown("MyDropdown", {
	Values = { 'Slap', 'Kick', 'Stomp' },
	Default = '...',
	Multi = false,

	Text = "Select a mode",
	Tooltip = "Select a mode to farm",
	DisabledTooltip = "I am disabled!",

	Searchable = false,

	Callback = function(Value)
		selectedMode = Value
    print(selectedMode)
	end,

	Disabled = false,
	Visible = true,
})
PlayerGroupBox:AddButton({
	Text = "Teleport to player",
	Func = function()
    Library:Notify({
        Title = "InfinityX",
        Description = "Teleported to player",
        Time = 2,
    })
    game.Players.LocalPlayer.Character:PivotTo(game.Players[selectedPlayer].Character:GetPivot())
    wait(.1)
    game.Players.LocalPlayer.Character:PivotTo(game.Players[selectedPlayer].Character:GetPivot())
    wait(.1)
    game.Players.LocalPlayer.Character:PivotTo(game.Players[selectedPlayer].Character:GetPivot())
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to a player selected",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
PlayerGroupBox:AddToggle("MyToggle", {
	Text = "Start player farm",
	Tooltip = "Active to farm players",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    playerFarm = Value
    if autoMoney then
      Library:Notify({
        Title = "InfinityX",
        Description = "Player farm activated",
        Time = 4,
      })
    end
    while playerFarm do task.wait()
      game.Players.LocalPlayer.Character:PivotTo(game.Players[selectedPlayer].Character:GetPivot())
      EquipTool('Fight')
      local A_1 = selectedMode
      local Event = game:GetService("Workspace")[game.Players.LocalPlayer.Name].Fight.FightScript.FightEvent
      Event:FireServer(A_1)
    end
	end,
})
MiscGroupBox:AddToggle("MyToggle", {
	Text = "Slap farm",
	Tooltip = "Active to slap farm",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    slapFarm = Value
    if slapFarm then
      Library:Notify({
        Title = "InfinityX",
        Description = "Slap farm activated",
        Time = 4,
      })
    end
    while slapFarm do task.wait()
      for i, v in pairs(workspace.Map.GasStation:GetChildren()) do
        if v:IsA('Model') and v.Name ~= 'Door' and v.Name ~= 'VestCollector' then
            game.Players.LocalPlayer.Character:PivotTo(v:GetPivot())
        end
      end
      EquipTool('Fight')
      local A_1 = 'Slap'
      local Event = game.Players.LocalPlayer.Character.Fight.FightScript.FightEvent
      Event:FireServer(A_1)
    end
	end,
})


local CharacterGroupBox = Tabs.LPlayer:AddLeftGroupbox("Character", "user")
local BypassGroupBox = Tabs.LPlayer:AddRightGroupbox("Bypass", "shield-off")
local SafeZoneGroupBox = Tabs.LPlayer:AddLeftGroupbox("Safe Zone", "shield")
local FunGroupBox = Tabs.LPlayer:AddRightGroupbox("Fun", "star")
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
CharacterGroupBox:AddToggle("AntiFlyToggle", {
	Text = "Fly",
	Tooltip = "Active to fly",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    Fly = Value
    if Fly then
      Library:Notify({
        Title = "InfinityX",
        Description = "Fly activated",
        Time = 4,
      })
      game.Players.LocalPlayer.Character:FindFirstChild('AntiFly').Disabled = true

      game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
      local Head = game.Players.LocalPlayer.Character:WaitForChild("Head")
      Head.Anchored = true
      if CFloop then CFloop:Disconnect() end
      CFloop = game:GetService('RunService').Heartbeat:Connect(function(deltaTime)
          local moveDirection = game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').MoveDirection * (2 * 2)
          local headCFrame = Head.CFrame
          local cameraCFrame = workspace.CurrentCamera.CFrame
          local cameraOffset = headCFrame:ToObjectSpace(cameraCFrame).Position
          cameraCFrame = cameraCFrame * CFrame.new(-cameraOffset.X, -cameraOffset.Y, -cameraOffset.Z + 1)
          local cameraPosition = cameraCFrame.Position
          local headPosition = headCFrame.Position

          local objectSpaceVelocity = CFrame.new(cameraPosition, Vector3.new(headPosition.X, cameraPosition.Y, headPosition.Z)):VectorToObjectSpace(moveDirection)
          Head.CFrame = CFrame.new(headPosition) * (cameraCFrame - cameraPosition) * CFrame.new(objectSpaceVelocity)
      end)
    else
      if CFloop then
        CFloop:Disconnect()
        game.Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
        local Head = game.Players.LocalPlayer.Character:WaitForChild("Head")
        Head.Anchored = false
      end
    end
	end,
})
BypassGroupBox:AddToggle("AntiFlyToggle", {
	Text = "Anti fly",
	Tooltip = "Active to bypass anti fly",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AntiFly = Value
    if AntiFly then
      Library:Notify({
        Title = "InfinityX",
        Description = "Anti fly activated",
        Time = 4,
      })
      game.Players.LocalPlayer.Character:FindFirstChild('AntiFly').Disabled = true
    end
    while AntiFly do task.wait()
      for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if v:IsA('Script') and v.Name == 'AntiFly' then
          v.Disabled = true
        end
      end
    end
	end,
})
BypassGroupBox:AddToggle("MyToggle", {
	Text = "Anti ragdoll",
	Tooltip = "Active to bypass ragdoll",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AntiRagdollBool = Value
    if AntiRagdollBool and hookmetamethod and getnamecallmethod then
      Library:Notify({
        Title = "InfinityX",
        Description = "Anti ragdoll activated",
        Time = 4,
      })

      AntiRagdoll()

      game.Players.LocalPlayer.CharacterAdded:Connect(function()
        if AntiRagdoll then
          AntiRagdoll()
        end
      end)

      while AntiRagdollBool do task.wait()
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
          if v:IsA('Script') and v.Name == 'Ragdoll' then
            v.Disabled = true
            v:FindFirstChild('RagdollInput').Disabled = true
            if v:FindFirstChild('Activate').Value == true then
              v.Activate.Value = false
            end
            if game.Players.LocalPlayer.Character.Humanoid.PlatformStand == true then
              game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
            end
          end
        end
      end
    elseif AntiRagdollBool and not hookmetamethod and not getnamecallmethod then
      Library:Notify({
        Title = "InfinityX",
        Description = "Your exploit does not support this feature",
        Time = 4,
      })
    end
	end,
})
BypassGroupBox:AddToggle("MyToggle", {
	Text = "Anti dead",
	Tooltip = "If the game tries to kill you on suspicion of an exploit, this function blocks it",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AntiDead = Value
    if AntiDead then
      Library:Notify({
        Title = "InfinityX",
        Description = "Anti dead activated",
        Time = 4,
      })
      while AntiDead do task.wait()
        local Players = game:GetService("Players")
        local localPlayer = Players.LocalPlayer

        local function setup()
          local char = localPlayer.Character or localPlayer.CharacterAdded:Wait()
          local hum = char:FindFirstChildOfClass("Humanoid")
          if not hum then return end

          hum:GetPropertyChangedSignal("Health"):Connect(function()
            if hum.Health <= 0 then
              hum.Health = 100
              warn("Bloqueio de morte ativado.")
            end
          end)

          hum.BreakJointsOnDeath = false
        end

        if localPlayer.Character then setup() end
      end
    end
	end,
})
BypassGroupBox:AddToggle("MyToggle", {
	Text = "No fall damage",
	Tooltip = "Active to bypass fall damage",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AntiFallDamage = Value
    if AntiFallDamage and hookmetamethod and getnamecallmethod then
      Library:Notify({
        Title = "InfinityX",
        Description = "No fall damage activated",
        Time = 4,
      })
      local bypass;
      bypass = hookmetamethod(game, "__namecall", function(method, ...)
        if getnamecallmethod() == "FireServer" and method == game.Players.LocalPlayer.Character.FallDamage.FallDamage then
          return
        end
        return bypass(method, ...)
      end)
      while AntiFallDamage do task.wait()
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
          if v:IsA('Script') and v.Name == 'FallDamage' then
            v.Disabled = true
            v:WaitForChild('LocalFallDamage').Disabled = true
          end
        end
      end
    elseif AntiFallDamage and not hookmetamethod and not getnamecallmethod then
      Library:Notify({
        Title = "InfinityX",
        Description = "Your exploit does not support this feature",
        Time = 4,
      })
    end
	end,
})
if not IsOnMobile then
  SafeZoneGroupBox:AddSlider("MySlider", {
    Text = "Enter Health",
    Default = 0,
    Min = 0,
    Max = 100,
    Rounding = 1,
    Compact = false,

    Callback = function(Value)
      selectedHealth = Value
    end,
  })
elseif IsOnMobile then
  SafeZoneGroupBox:AddInput("MyTextbox", {
    Default = "0",
    Numeric = true,
    Finished = false,
    ClearTextOnFocus = false,

    Text = "Enter health",
    Placeholder = "0",

    Callback = function(Value)
      selectedHealth = Value
    end,
  })
end
SafeZoneGroupBox:AddToggle("MyToggle", {
	Text = "Auto safe zone",
	Tooltip = "Active to teleport you to the safe zone",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AutoSafeZone = Value
    while AutoSafeZone do task.wait()
      if game.Players.LocalPlayer.Character.Humanoid.Health < selectedHealth then
          game.Players.LocalPlayer.Character:PivotTo(workspace.Map.Terrain:GetChildren()[8]:GetPivot())
      end
    end
	end,
})
FunGroupBox:AddToggle("MyToggle", {
	Text = "Lag server [+1000 cash]",
	Tooltip = "This code only works on certain servers",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        infMoney = Value
        task.spawn(function()
          while infMoney do task.wait()
            game:GetService("ReplicatedStorage").RemoteEvent.   PurchaseRequest:FireServer("Bonus", "Call Police")
            for i, v in pairs(game:GetService('Players'):GetChildren()) do
              if v and v.Character and v ~= game.Players.LocalPlayer then
                game:GetService("ReplicatedStorage").RemoteEvent. CallPolice:FireServer(v)
              end
            end
            warn('code is running')
          end
        end)
        wait(4)
        if infMoney then
          Library:Notify({
            Title = "InfinityX",
            Description = "Lag server loaded!",
            Time = 4,
          })

          local Signals = {"Activated", "MouseButton1Down",     "MouseButton2Down", "MouseButton1Click", "MouseButton2Click"}
          for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.Shop.MainFrame.FunFrame["Call Police Helicopter"]:GetChildren()) do
          if v:IsA('TextButton') then
            for i, Signal in pairs(Signals) do
              firesignal(v[Signal])
            end
          end
        end
      end
	end,
})
FunGroupBox:AddToggle("MyToggle", {
	Text = "Spam all attacks",
	Tooltip = "Active to spam all attacks",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AttackAura = Value
    while AttackAura do task.wait()
        EquipTool('Fight')
        local A_1 = 'Slap'
        local Event = game:GetService("Workspace")[game.Players.LocalPlayer.Name].Fight.FightScript.FightEvent
        Event:FireServer(A_1)
        local A_1 = 'Kick'
        local Event = game:GetService("Workspace")[game.Players.LocalPlayer.Name].Fight.FightScript.FightEvent
        Event:FireServer(A_1)
    end
	end,
})
FunGroupBox:AddToggle("MyToggle", {
	Text = "Big hitbox",
	Tooltip = "Active to view all players big hitbox",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    bigHitbox = Value
    if bigHitbox then
      _G.Size = 30
      _G.Disabled = true
      if hitboxLoop then hitboxLoop:Disconnect() end
      hitboxLoop = game:GetService('RunService').RenderStepped:connect(function()
        if _G.Disabled then
          for i, v in next, game:GetService('Players'):GetPlayers() do
            if v.Name ~= game:GetService('Players').LocalPlayer.Name then
              pcall(function()
                v.Character.HumanoidRootPart.Size = Vector3.new(_G.Size,_G.Size,_G.Size)
                v.Character.HumanoidRootPart.Transparency = 0.7
                v.Character.HumanoidRootPart.BrickColor = BrickColor.new("Really red")
                v.Character.HumanoidRootPart.Material = "Neon"
                v.Character.HumanoidRootPart.CanCollide = false
              end)
            end
          end
        end
      end)
    else
      if hitboxLoop then
        hitboxLoop:Disconnect()
        for i, v in next, game:GetService('Players'):GetPlayers() do
          if v.Name ~= game:GetService('Players').LocalPlayer.Name then
            pcall(function()
              local hrp = v.Character.HumanoidRootPart
              hrp.Size = Vector3.new(2, 2, 1)
              hrp.Transparency = 1
              hrp.BrickColor = BrickColor.new("Medium stone grey")
              hrp.Material = Enum.Material.Plastic
              hrp.CanCollide = true
            end)
          end
        end
      end
    end
	end,
})
FunGroupBox:AddButton("Get all tools", function()
  for i, v in pairs(game:GetService("ReplicatedStorage").RoleplayItems:GetChildren()) do
    if v:IsA('Tool') then
      local cloneTool = v:Clone()
      cloneTool.Parent = game.Players.LocalPlayer.Backpack
    end
  end
end)


local WithdrawnGroupBox = Tabs.Money:AddLeftGroupbox("Withdrawn", "hand-coins")
local DepositGroupBox = Tabs.Money:AddRightGroupbox("Deposit", "hand-coins")
local StatusGroupBox = Tabs.Money:AddLeftGroupbox("Status", "chart-line")
for _, amount in ipairs(amounts) do
    WithdrawnGroupBox:AddButton(tostring(amount), function()
        local args = {
            {
                ["Amount"] = amount,
                ["Mode"] = "W"
            }
        }
        game:GetService("ReplicatedStorage").RemoteEvent.ATM:FireServer(unpack(args))
    end)

    DepositGroupBox:AddButton(tostring(amount), function()
        local args = {
            {
                ["Amount"] = amount,
                ["Mode"] = "D"
            }
        }
        game:GetService("ReplicatedStorage").RemoteEvent.ATM:FireServer(unpack(args))
    end)
end
local BankInfo = StatusGroupBox:AddLabel("You ".. game:GetService("Players").LocalPlayer.PlayerGui.ATMGui.Frame.BG.Bank.Text)
local HandInfo = StatusGroupBox:AddLabel("You Have: ".. game:GetService("Players").LocalPlayer.PlayerGui.CashEffect.CashDisplay.Text)
task.spawn(function()
    while true do task.wait()
      BankInfo:SetText("You ".. game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild('ATMGui'):WaitForChild('Frame'):WaitForChild('BG'):WaitForChild('Bank').Text)
      HandInfo:SetText("You Have: ".. game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild('CashEffect'):WaitForChild('CashDisplay').Text)
    end
end)
DepositGroupBox:AddToggle("MyToggle", {
	Text = "Auto deposit",
	Tooltip = "Active to deposit all money in your bank",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AutoDeposit = Value
    while AutoDeposit do task.wait()
      local args = {
        {
          ["Amount"] = 100,
          ["Mode"] = "D"
        }
      }
      game:GetService("ReplicatedStorage").RemoteEvent.ATM:FireServer(unpack(args))
    end
	end,
})


local ShopGroupBox = Tabs.Shop:AddLeftGroupbox("Items", "shopping-basket")
local AutoShopGroupBox = Tabs.Shop:AddRightGroupbox("Auto Collect Items", "shopping-basket")
ShopGroupBox:AddButton("Giant Ray", function()
  local A_1 = "Giant Ray"
  local A_2 = game:GetService("Workspace").Map.BuyButtons.CashButtons["Giant Ray"]
  local Event = game:GetService("ReplicatedStorage").RemoteEvent.PurchaseRequest
  Event:FireServer(A_1, A_2)
end)
ShopGroupBox:AddButton("Shrink Ray", function()
  local A_1 = "Shrink Ray"
  local A_2 = game:GetService("Workspace").Map.BuyButtons.CashButtons["Shrink Ray"]
  local A_3 = {
    ["Color"] = {
      [1] = 1,
      [2] = 0,
      [3] = 0.01568627543747425
    }
  }
  local Event = game:GetService("ReplicatedStorage").RemoteEvent.PurchaseRequest
  Event:FireServer(A_1, A_2, A_3)
end)
ShopGroupBox:AddButton("Antigravity Hammer", function()
  local ohString1 = "Antigravity Hammer"
  local ohInstance2 = workspace.Map.BuyButtons.CashButtons["Antigravity Hammer"]
  local ohTable3 = {
    ["Color"] = {
      [1] = 1,
      [2] = 0,
      [3] = 0.01568627543747425
    }
  }
  game:GetService("ReplicatedStorage").RemoteEvent.PurchaseRequest:FireServer(ohString1, ohInstance2, ohTable3)
end)
ShopGroupBox:AddButton("Gravity Hammer", function()
  local ohString1 = "Gravity Hammer"
  local ohInstance2 = workspace.Map.BuyButtons.CashButtons["Gravity Hammer"]
  local ohTable3 = {
    ["Color"] = {
      [1] = 1,
      [2] = 0,
      [3] = 0.01568627543747425
    }
  }
  game:GetService("ReplicatedStorage").RemoteEvent.PurchaseRequest:FireServer(ohString1, ohInstance2, ohTable3)
end)
AutoShopGroupBox:AddToggle("MyToggle", {
	Text = "Shotgun",
	Tooltip = "Active to collect shotgun automatically",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AutoBuyShotGun = Value
    while AutoBuyShotGun do task.wait()
      for i, v in pairs(workspace.Map:GetDescendants()) do
        if v:IsA('Model') and v.Name == 'ShotgunCollector' then
          for i, x in pairs(v:GetDescendants()) do
            if x:IsA('TouchTransmitter') then
              game.Players.LocalPlayer.Character:PivotTo(x.Parent:GetPivot())
            end
          end
        end
      end
    end
	end,
})
AutoShopGroupBox:AddToggle("MyToggle", {
	Text = "Revolver",
	Tooltip = "Active to collect revolver automatically",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
    AutoBuyGun = Value
    while AutoBuyGun do task.wait()
      for i, v in pairs(workspace.Map:GetDescendants()) do
        if v:IsA('Model') and v.Name == 'GunCollector' then
          for i, x in pairs(v:GetDescendants()) do
            if x:IsA('TouchTransmitter') then
              game.Players.LocalPlayer.Character:PivotTo(x.Parent:GetPivot())
            end
          end
        end
      end
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
