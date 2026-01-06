---@diagnostic disable: undefined-global
-- detect service
if game.PlaceId == 79546208627805 then return end
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
  print("Mobile device")
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Items/button.lua",true))()
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
local velocityHandlerName = 'valocityHandler'
local gyroHandlerName = 'gyroHander'
local mfly1
local mfly2
FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1
function missing(t, f, fallback)
  if type(f) == t then return f end
  return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
local Players = game.Players
Mouse = cloneref(Players.LocalPlayer:GetMouse())
function getRoot(char)
  local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
  return rootPart
end
local unmobilefly = function(speaker)
	pcall(function()
		FLYING = false
		local root = getRoot(speaker.Character)
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end
local mobilefly = function(speaker, vfly)
	unmobilefly(speaker)
	FLYING = true

	local root = getRoot(speaker.Character)
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = speaker.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = game.RunService.RenderStepped:Connect(function()
		root = getRoot(speaker.Character)
		camera = workspace.CurrentCamera
		if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
		end
	end)
end
function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until Mouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = Mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = Mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end
function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end
getgenv().EspSettings = {
  Enabled = false,
  Name = true,
  Tracers = true,
  Studs = true,
  Box = true,
  BoxType = "2d",
  Animals = {
    Enabled = false,
    Color = Color3.fromRGB(255, 0, 0)
  },
  Items = {
    Chest = { Enabled = false, Color = Color3.fromRGB(255, 230, 0) },
    Ammo = { Enabled = false, Color = Color3.fromRGB(59, 59, 59) },
    Scrap = { Enabled = false, Color = Color3.fromRGB(99, 99, 99) },
    Food = { Enabled = false, Color = Color3.fromRGB(224, 135, 61) },
    Fuel = { Enabled = false, Color = Color3.fromRGB(121, 121, 121) },
    Tool = { Enabled = false, Color = Color3.fromRGB(255, 242, 63) }
  }
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local animalNames = { "Bunny", "Wolf", "Alpha Worlf", "Bear", "Polar Bear", 'Cultist', 'Crossbow Cultist', 'Deer' }
local scrapNames = { ["Sheet Metal"] = true, ["Broken Fan"] = true, ["Old Radio"] = true, ["Bolt"] = true, ["Tyre"] = true }
local DrawingsCache = {}
local function createDrawingESP(inst, color)
  local info = {}

  if getgenv().EspSettings.Box then
    if getgenv().EspSettings.BoxType == "2d" then
      info.box = Drawing.new("Square")
      info.box.Thickness = 2
      info.box.Transparency = 1
      info.box.Filled = false
      info.box.Color = color
    elseif getgenv().EspSettings.BoxType == "3d" then
      local box3d = Instance.new("BoxHandleAdornment")
      box3d.Name = "ESP3D"
      box3d.Size = Vector3.new(4, 4, 4)
      box3d.Transparency = 0.5
      box3d.AlwaysOnTop = true
      box3d.ZIndex = 10
      box3d.Adornee = inst.Parent
      box3d.Color3 = color
      box3d.Parent = inst.Parent
      info.box3d = box3d
    end
  end

  info.name = Drawing.new("Text")
  info.name.Size = 13
  info.name.Center = true
  info.name.Outline = true
  info.name.Color = color

  info.distance = Drawing.new("Text")
  info.distance.Size = 13
  info.distance.Center = true
  info.distance.Outline = true
  info.distance.Color = color

  info.tracer = Drawing.new("Line")
  info.tracer.Thickness = 1
  info.tracer.Transparency = 1
  info.tracer.Color = color

  DrawingsCache[inst] = info
end
local function removeDrawingESP(inst)
  local d = DrawingsCache[inst]
  if d then
    for _, v in pairs(d) do
      if typeof(v) == 'Instance' then v:Destroy() else v:Remove() end
    end
    DrawingsCache[inst] = nil
  end
end
RunService.RenderStepped:Connect(function()
  if not getgenv().EspSettings.Enabled then
    for inst, _ in pairs(DrawingsCache) do removeDrawingESP(inst) end
    return
  end

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
      local inst = player.Character.HumanoidRootPart
      if not DrawingsCache[inst] then
        createDrawingESP(inst, Color3.fromRGB(255, 0, 0))
      end
    end
  end

  if getgenv().EspSettings.Animals.Enabled then
    for _, v in ipairs(workspace.Characters:GetChildren()) do
      if v:IsA("Model") then
        for _, name in ipairs(animalNames) do
          if v.Name:lower():find(name:lower()) then
            local hrp = v:FindFirstChild("HumanoidRootPart")
            if hrp and not DrawingsCache[hrp] then
              createDrawingESP(hrp, getgenv().EspSettings.Animals.Color)
            end
          end
        end
      end
    end
  end

  for kind, cfg in pairs(getgenv().EspSettings.Items) do
    if cfg.Enabled then
      for _, v in ipairs(workspace.Items:GetChildren()) do
        if v:IsA("Model") then
          local ok = false
          local name = v.Name
          if kind == "Chest" and name:lower():find("chest") then ok = true
          elseif kind == "Ammo" and name:lower():find("ammo") then ok = true
          elseif kind == "Scrap" and scrapNames[name] then ok = true
          elseif kind == "Food" and (v.Name == 'Carrot' or v.Name == 'Berry' or v.Name == 'Apple' or v.Name == 'Morsel' or v.Name == 'Steak') then ok = true
          elseif kind == "Fuel" and (name=="Coal" or name=="Log" or name=="Sapling" or name=="Fuel Canister" or name=="Wolf Corpse") then ok = true
          elseif kind=="Tool" and (name=="Old Flashlight" or name=="Bandage" or name=="Rifle") then ok = true
          end
          if ok then
            local hrp = v:FindFirstChildWhichIsA("BasePart")
            if hrp and not DrawingsCache[hrp] then
              createDrawingESP(hrp, cfg.Color)
            end
          end
        end
      end
    end
  end

  for inst, d in pairs(DrawingsCache) do
    if inst and inst.Parent then
      local pos, onScreen = Camera:WorldToViewportPoint(inst.Position)
      if onScreen then
        if getgenv().EspSettings.Box then
          if getgenv().EspSettings.BoxType == "2d" and d.box then
            local size = 50
            d.box.Position = Vector2.new(pos.X - size/2, pos.Y - size/2)
            d.box.Size = Vector2.new(size, size)
            d.box.Visible = true
          elseif getgenv().EspSettings.BoxType == "3d" and d.box3d then
            d.box3d.Adornee = inst.Parent
          end
        end

        d.name.Position = Vector2.new(pos.X, pos.Y - 40)
        d.name.Text = inst.Parent.Name
        d.name.Visible = getgenv().EspSettings.Name

        if getgenv().EspSettings.Studs and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
          local dist = math.floor((inst.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude)
          d.distance.Position = Vector2.new(pos.X, pos.Y + 25)
          d.distance.Text = tostring(dist) .. "m"
          d.distance.Visible = true
        else
          d.distance.Visible = false
        end

        if getgenv().EspSettings.Tracers then
          d.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
          d.tracer.To = Vector2.new(pos.X, pos.Y)
          d.tracer.Visible = true
        else
          d.tracer.Visible = false
        end
      else
        removeDrawingESP(inst)
      end
    else
      removeDrawingESP(inst)
    end
  end
end)
local KillAuraSettings = {
  Range = 50,
  ToolName = '',
  WeaponName = '',
  Tool = '',
  Tree = ''
}
function GetItems()
  local items = {}
  for _, v in pairs(game:GetService("Players").LocalPlayer.Inventory:GetChildren()) do
    if v:IsA('Model') and (v.Name:lower():find('axe') or v.Name:lower():find('sword') or v.Name == 'Chainsaw') then
      table.insert(items, v.Name)
    end
  end
  return items
end
function GetPlayersName()
  local players = {}
  for _, v in pairs(game:GetService('Players'):GetPlayers()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
      table.insert(players, v.Name)
    end
  end
  return players
end
local itemFolder = workspace:WaitForChild("Items")
local uniqueNames = {}
local ItemTeleportDropdown
local function updateItems()
	local seen = {}
	table.clear(uniqueNames)
	for _, item in ipairs(itemFolder:GetChildren()) do
		if item:IsA("Model") and not seen[item.Name] then
			seen[item.Name] = true
			table.insert(uniqueNames, item.Name)
		end
	end
	if ItemTeleportDropdown then
		ItemTeleportDropdown:SetValues(uniqueNames)
	end
end
function GetStructures()
  local structures = {}
  for _, v in pairs(workspace.Structures:GetChildren()) do
    if v:IsA('Model') then
      table.insert(structures, v.Name)
    end
  end
  return structures
end
workspace.Structures.ChildAdded:Connect(GetStructures)
workspace.Structures.ChildRemoved:Connect(GetStructures)
local interfaces = { 'AmmoCrate', 'GemActivateMenu', 'Scanner', 'Compass', 'CraftingTable', 'Flower' }


-- ui library
local isMobile = game.UserInputService.TouchEnabled
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Fluent/main.lua"))()

local Options = Fluent.Options

function GetSize()
  if isMobile then
    return UDim2.fromOffset(480, 300)
  else
    return UDim2.fromOffset(650, 480)
  end
end

local Window = Fluent:CreateWindow({
	Title = '<font color="rgb(175,120,255)" size="14"><b>InfinityX</b></font> <font color="rgb(180,180,180)" size="13">- <b>v4.2a</b></font>',
  SubTitle = '<font color="rgb(160,160,160)" size="10"><i> -  by lmy77</i></font>',
	TabWidth = 160,
	Size = GetSize(),
	Acrylic = false,
	Theme = "InfinityX",
	MinimizeKey = Enum.KeyCode.K
})


-- tabs
local WelcomeTab = Window:AddTab({ Title = "| Welcome", Icon = "heart" })
local InterfaceTab = Window:AddTab({ Title = "| Interface", Icon = "crosshair" })
local TeleportTab = Window:AddTab({ Title = "| Teleport", Icon = "locate" })
local AttackAuraTab = Window:AddTab({ Title = "| Attack Aura", Icon = "sword" })
local CharacterTab = Window:AddTab({ Title = "| Character", Icon = "user" })
local BringTab = Window:AddTab({ Title = "| Bring Item", Icon = "hammer" })
local VisualTab = Window:AddTab({ Title = "| Visual", Icon = "eye" })
local MiscTab = Window:AddTab({ Title = "| Misc", Icon = "layers" })
local Tabs = {
  Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
Window:SelectTab(1)


-- source
WelcomeTab:AddSection("[👋] - Welcome")
local w1 = WelcomeTab:AddParagraph({
  Title = "Welcome to InfinityX",
  Content = "Dear " .. game.Players.LocalPlayer.Name .. '\nThank you for choosing to use this script.\nWe hope the script meets your expectations.\nIf you have any questions or the script is buggy, let us know on the discord server\nThanks again, and enjoy!\n\nSincerely,\nThe Development Team'
})


InterfaceTab:AddSection("[🔨] - Interface Options")
for _, interfacesName in pairs(interfaces) do
  InterfaceTab:AddButton({
    Title = "Open " .. interfacesName,
    Callback = function()
      local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
      local interface = gui:WaitForChild("Interface"):FindFirstChild(interfacesName)

      if interface then
        interface.Visible = not interface.Visible
      end
    end
  })
end


TeleportTab:AddSection("[🔨] - Item Teleport")
ItemTeleportDropdown = TeleportTab:AddDropdown("Dropdown", {
	Title = "Select item",
	Values = {},
	Multi = false,
	Default = '',
})
updateItems()
itemFolder.ChildAdded:Connect(updateItems)
itemFolder.ChildRemoved:Connect(updateItems)
ItemTeleportDropdown:OnChanged(function(Value)
  KillAuraSettings.ToolName = Value
end)
TeleportTab:AddButton({
  Title = "Teleport to selected item",
  Callback = function()
    game.Players.LocalPlayer.Character:PivotTo(
      workspace:WaitForChild("Items")[KillAuraSettings.ToolName]:GetPivot() * CFrame.new(0, 5, 0)
    )
  end
})
TeleportTab:AddButton({
  Title = "Teleport selected item to you",
  Callback = function()
    local item = workspace:WaitForChild("Items"):FindFirstChild(KillAuraSettings.ToolName)
    if item then
      workspace:WaitForChild("Items")[KillAuraSettings.ToolName]:PivotTo(
        game.Players.LocalPlayer.Character:GetPivot() * CFrame.new(0, 4, 0)
      )
    else
      Fluent:Notify({
        Title = "InfinityX",
        Content = "Item not found",
        Duration = 5
      })
    end
  end
})
TeleportTab:AddToggle("AcrylicToggle", {
  Title = "View item",
  Default = false,
  Callback = function(Value)
    SpactateItem = Value
    if KillAuraSettings.ToolName == 'None' and Spactate then
      Fluent:Notify({
        Title = "InfinityX",
        Content = "Select a item first to use this function",
        Duration = 5
      })
      return
    end
    if SpactateItem then
      local Camera = workspace.CurrentCamera
      local target = workspace:WaitForChild("Items")[KillAuraSettings.ToolName]

      if target and target.PrimaryPart then
        Camera.CameraSubject = target.PrimaryPart
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
TeleportTab:AddSection("[🔥] - Campfire")
TeleportTab:AddButton({
  Title = "Teleport to campfire",
  Callback = function()
    game.Players.LocalPlayer.Character:PivotTo(
      workspace.Map.Campground.MainFire:GetPivot() * CFrame.new(posX, 10, posZ)
    )
  end
})
TeleportTab:AddToggle("AcrylicToggle", {
  Title = "Auto teleport to campfire",
  Description = "Automatically teleports you to the campfire at night",
  Default = false,
  Callback = function(Value)
    tpCampfire = Value
    local lighting = game:GetService("Lighting")
    local alreadyTeleported = false

    while tpCampfire do
      if lighting.ClockTime >= 18 or lighting.ClockTime < 6 then
        if not alreadyTeleported then
          game.Players.LocalPlayer.Character:PivotTo(
            workspace.Map.Campground.MainFire:GetPivot() * CFrame.new(posX, 10, posZ)
          )
          alreadyTeleported = true
        end
      else
        alreadyTeleported = false
      end
      task.wait(1)
    end
  end
})
TeleportTab:AddSection("[🗼] - Structures Teleport")
local StructuresDropdown = TeleportTab:AddDropdown("Dropdown", {
	Title = "Select structure",
	Values = GetStructures(),
	Multi = false,
	Default = '',
})
StructuresDropdown:OnChanged(function(Value)
  SelectedStructure = Value
end)
TeleportTab:AddButton({
  Title = "Teleport to selected structure",
  Callback = function()
    game.Players.LocalPlayer.Character:PivotTo(
      workspace.Structures[SelectedStructure]:GetPivot() * CFrame.new(posX, 10, posZ)
    )
  end
})


AttackAuraTab:AddSection("[🙍] - Character Options")
AttackAuraTab:AddToggle("AcrylicToggle", {
  Title = "Enable attack aura",
  Default = false,
  Callback = function(Value)
    killaura = Value
    while killaura do task.wait()
      for _, v in pairs(workspace.Characters:GetChildren()) do
        if v:IsA('Model') then
          if (v:FindFirstChild("HumanoidRootPart") and (v.HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= KillAuraSettings.Range) then
            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
              v,
              game:GetService("Players").LocalPlayer.Inventory[KillAuraSettings.WeaponName],
              "18_9014810216",
              v:FindFirstChild("HumanoidRootPart").CFrame
            )
          end
        end
      end
    end
  end
})
AttackAuraTab:AddToggle("AcrylicToggle", {
  Title = "Enable tree aura",
  Default = false,
  Callback = function(Value)
    treeaura = Value
    while treeaura do task.wait()
      for _, v in pairs(workspace.Map.Foliage:GetChildren()) do
        if v:IsA("Model") and v.Name:lower():find(KillAuraSettings.Tree) and v:FindFirstChild("Trunk") then
          if (v.Trunk.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <= KillAuraSettings.Range then
            game:GetService("ReplicatedStorage").RemoteEvents.ToolDamageObject:InvokeServer(
              v,
              game:GetService("Players").LocalPlayer.Inventory[KillAuraSettings.WeaponName],
              "18_9014810216",
              v:FindFirstChild("HumanoidRootPart").CFrame
            )
          end
        end
      end
    end
  end
})
AttackAuraTab:AddSection("[⚙️] - Settings")
local selectedItem = nil
local items = GetItems()
if #items > 0 then
	selectedItem = items[math.random(1, #items)]
end
local WeaponsDropdown = AttackAuraTab:AddDropdown("Dropdown", {
  Title = "Select weapon",
  Values = GetItems(),
  Multi = false,
  Default = selectedItem,
})
WeaponsDropdown:OnChanged(function(Value)
  KillAuraSettings.WeaponName = Value
end)
local TreeDropdown = AttackAuraTab:AddDropdown("Dropdown", {
  Title = "Select tree",
  Values = { 'Small Tree', 'Big Tree' },
  Multi = false,
  Default = 'Small Tree',
})
TreeDropdown:OnChanged(function(Value)
  KillAuraSettings.Tree = Value
  if KillAuraSettings.Tree == 'Small Tree' then
    KillAuraSettings.Tree = 'small tree'
  elseif KillAuraSettings.Tree == 'Big Tree' then
    KillAuraSettings.Tree = 'big'
  end
end)
AttackAuraTab:AddInput("Input", {
  Title = "Attack aura range",
  Default = "",
  Placeholder = "50",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    KillAuraSettings.Range = tonumber(Value)
  end
})


CharacterTab:AddSection("[🙍] - Character Options")
CharacterTab:AddInput("Input", {
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
CharacterTab:AddInput("Input", {
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
local NoclipToggle = CharacterTab:AddToggle("AutoMoneyToggle", {
  Title = "Noclip",
  Default = false,
})
NoclipToggle:OnChanged(function(Value)
  Noclip = Value
  if Noclip then
		for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == true then
				v.CanCollide = false
			end
		end
  else
		for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == false then
				v.CanCollide = true
			end
		end
  end
end)
local FlyToggle = CharacterTab:AddToggle("AutoMoneyToggle", {
  Title = "Fly",
  Default = false,
})
FlyToggle:OnChanged(function(Value)
  Fly = Value
  if Fly then
    if not IsOnMobile then
      NOFLY()
      wait()
      sFLY()
    else
      mobilefly(game.Players.LocalPlayer)
    end
  else
    if not IsOnMobile then NOFLY() else unmobilefly(game.Players.LocalPlayer) end
  end
end)
CharacterTab:AddSection("[🍖] - Auto food")
local FoodDropdown = CharacterTab:AddDropdown("Dropdown", {
  Title = "Select food",
  Values = { 'Vegetable', 'Cooked Food' },
  Multi = false,
  Default = SelectedPlayerRandom,
})
FoodDropdown:OnChanged(function(Value)
  SelectedMethod = Value
end)
CharacterTab:AddButton({
  Title = "Eat food",
  Callback = function()
    if SelectedMethod == 'Vegetable' then
      for _, v in pairs(workspace.Items:GetChildren()) do
        if v:IsA('Model') and ((v.Name == 'Carrot' or v.Name == 'Berry' or v.Name == 'Apple')) then
          local Event = game:GetService("ReplicatedStorage").RemoteEvents.RequestConsumeItem
          Event:InvokeServer(
            v
          )
          return
        end
      end
    elseif SelectedMethod == 'Cooked Food' then
      for _, v in pairs(workspace.Items:GetChildren()) do
        if v:IsA('Model') and v.Name:lower():find('cooked') then
          local Event = game:GetService("ReplicatedStorage").RemoteEvents.RequestConsumeItem
          Event:InvokeServer(
            v
          )
          return
        end
      end
    end
  end
})
local AutoEat = CharacterTab:AddToggle("AutoMoneyToggle", {
  Title = "Auto eat food",
  Description = "It automatically eats the selected food for you as soon as your hunger is below 50%",
  Default = false,
})
AutoEat:OnChanged(function(Value)
  autoeat = Value
  while autoeat do
    task.wait()
    local bar = game:GetService("Players").LocalPlayer.PlayerGui.Interface.StatBars.HungerBar.Bar
    local base = game:GetService("Players").LocalPlayer.PlayerGui.Interface.StatBars.HungerBar

    if bar.AbsoluteSize.X < base.AbsoluteSize.X * 0.5 then
      while bar.AbsoluteSize.X < base.AbsoluteSize.X do
        if SelectedMethod == "Vegetable" then
          for _, v in pairs(workspace.Items:GetChildren()) do
            if v:IsA("Model") and (v.Name == "Carrot" or v.Name == "Berry" or v.Name == "Apple") then
              game:GetService("ReplicatedStorage").RemoteEvents.RequestConsumeItem:InvokeServer(v)
              task.wait(0.3)
              if bar.AbsoluteSize.X >= base.AbsoluteSize.X then break end
            end
          end
        elseif SelectedMethod == "Cooked Food" then
          for _, v in pairs(workspace.Items:GetChildren()) do
            if v:IsA("Model") and v.Name:lower():find("cooked") then
              game:GetService("ReplicatedStorage").RemoteEvents.RequestConsumeItem:InvokeServer(v)
              task.wait(0.3)
              if bar.AbsoluteSize.X >= base.AbsoluteSize.X then break end
            end
          end
        end
        task.wait()
      end
    end
  end
end)
CharacterTab:AddSection("[🙅] - Players Options")
local players = GetPlayersName()
if #players > 0 then
	SelectedPlayerRandom = players[math.random(1, #players)]
end
local PlayersDropdown = CharacterTab:AddDropdown("Dropdown", {
  Title = "Select player",
  Values = GetPlayersName(),
  Multi = false,
  Default = SelectedPlayerRandom,
})
PlayersDropdown:OnChanged(function(Value)
  SelectedPlayer = Value
end)
CharacterTab:AddButton({
  Title = "Teleport to player",
  Callback = function()
    if SelectedPlayer == 'None' then
      Fluent:Notify({
        Title = "InfinityX",
        Content = "Select a player first to use this function",
        Duration = 5
      })
      return
    end
    game.Players.LocalPlayer.Character:PivotTo(game.Players[SelectedPlayer].Character:GetPivot())
  end
})
local SpectatePlayer = CharacterTab:AddToggle("AutoMoneyToggle", {
  Title = "Spactate selected player",
  Default = false,
})
SpectatePlayer:OnChanged(function(Value)
  Spactate = Value
  if SelectedPlayer == 'None' and Spactate then
  	Fluent:Notify({
  		Title = "InfinityX",
  		Content = "Select a player first to use this function",
  		Duration = 5
  	})
    return
  end
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
end)


BringTab:AddSection("[🔨] - Bring Options")
BringTab:AddButton({
  Title = "Bring all foods",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and ((v.Name == 'Carrot' or v.Name == 'Berry' or v.Name == 'Apple' or v.Name == 'Morsel' or v.Name == 'Steak') and v.Name ~= 'Berry Bush') then
        v:PivotTo(game.Players.LocalPlayer.Character:GetPivot() * CFrame.new(posX, 5, posZ))
        wait(.02)
      end
    end
  end
})
BringTab:AddButton({
  Title = "Bring all scrap items",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and (v.Name == 'Sheet Metal' or v.Name == 'Broken Fan' or v.Name == 'Old Radio' or v.Name == 'Bolt' or v.Name == 'Tyre') then
        v:PivotTo(game.Players.LocalPlayer.Character:GetPivot() * CFrame.new(posX, 5, posZ))
        wait(.02)
      end
    end
  end
})
BringTab:AddButton({
  Title = "Bring all fuel items",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and ((v.Name == 'Coal' or v.Name == 'Log' or v.Name == 'Sapling' or v.Name == 'Fuel Canister' or v.Name == 'Wolf Corpse')) then
        v:PivotTo(game.Players.LocalPlayer.Character:GetPivot() * CFrame.new(posX, 5, posZ))
        wait(.02)
      end
    end
  end
})
BringTab:AddButton({
  Title = "Bring all tool items",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and ((v.Name == 'Old Flashlight' or v.Name == 'Bandage' or v.Name == 'Rifle')) then
        v:PivotTo(game.Players.LocalPlayer.Character:GetPivot() * CFrame.new(posX, 5, posZ))
        wait(.02)
      end
    end
  end
})
BringTab:AddButton({
  Title = "Bring all ammo",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and v.Name:lower():find('ammo') then
        v:PivotTo(game.Players.LocalPlayer.Character:GetPivot() * CFrame.new(posX, 5, posZ))
        wait(.02)
      end
    end
  end
})
BringTab:AddSection("[🔥] - Campfire")
local p2 = BringTab:AddParagraph({
  Title = "Campfire Stats",
  Content = ""
})
spawn(function()
  while true do task.wait()
    local campfire = workspace.Map.Campground:FindFirstChild('MainFire')
    if campfire then
      local function toStr(v)
        if typeof(v) == "boolean" then
          return v and "yes" or "no"
        end
        return tostring(v)
      end
      local campprogress = campfire:WaitForChild('Center'):WaitForChild('BillboardGui'):WaitForChild('Frame'):WaitForChild('TextLabel').Text
      local clean = campprogress:gsub("<[^>]->", "")
      local campProgress = campfire:WaitForChild("Center"):WaitForChild("BillboardGui"):WaitForChild("Frame"):WaitForChild("TextLabel").Text
      local cleanProgress = campProgress:gsub("<[^>]->", "")

      local isRaining = workspace.Map.Campground.MainFire.Center.BillboardGui.Frame.Warning1.Visible or workspace.Map.Campground.MainFire.Center.BillboardGui.Frame.Warning2.Visible

      p2:SetDesc(string.format("• Time: %s\n• Raining: %s\n• %s",
        workspace.Map.Campground.MainFire.Center.BillboardGui.Frame.RealTimer.Text, 
        toStr(isRaining),
        cleanProgress))
      end
  end
end)
BringTab:AddButton({
  Title = "Bring fuel items to campfire",
  Description = "Log, Coal",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and ((v.Name == 'Coal' or v.Name == 'Log')) then
        v:PivotTo(workspace.Map.Campground.MainFire:GetPivot() * CFrame.new(posX, 10, posZ))
        wait(.02)
      end
    end
  end
})
BringTab:AddButton({
  Title = "Bring food items to campfire",
  Description = "Morsel, Steak",
  Callback = function()
    for _, v in pairs(workspace.Items:GetChildren()) do
      if v:IsA('Model') and ((v.Name == 'Morsel' or v.Name == 'Steak')) then
        v:PivotTo(workspace.Map.Campground.MainFire:GetPivot() * CFrame.new(posX, 10, posZ))
        wait(.02)
      end
    end
  end
})


VisualTab:AddSection("[👀] - Esp")
local EnableEsp = VisualTab:AddToggle("", {
  Title = "Enable",
  Default = false,
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "No fog",
  Default = false,
  Callback = function(Value)
    local lighting = game:GetService("Lighting")
    nofog = Value
    while nofog do task.wait()
      if nofog then
        lighting.FogStart = 1e6
        lighting.FogEnd = 1e6
        lighting.FogColor = Color3.new(1, 1, 1)
      else
        lighting.FogStart = 50
        lighting.FogEnd = 300
        lighting.FogColor = Color3.fromRGB(255, 255, 255)
      end
    end
  end
})
local p1 = VisualTab:AddParagraph({
  Title = "ESP Configuration - [ ESP SETTINGS ]",
  Content = ""
})
spawn(function()
  local function toStr(v)
      return typeof(v) == "boolean" and (v and "Yes" or "No") or tostring(v)
  end

  while true do
      task.wait()
      p1:SetDesc(table.concat({
          " • Name: " .. toStr(getgenv().EspSettings.Name),
          " • Tracers: " .. toStr(getgenv().EspSettings.Tracers),
          " • Studs: " .. toStr(getgenv().EspSettings.Studs),
          " • Box Type: " .. toStr(getgenv().EspSettings.BoxType),
          "",
          "- [ OPTIONS ]",
          " • Animal: " .. toStr(getgenv().EspSettings.Animals.Enabled),
          " • Chest: " .. toStr(getgenv().EspSettings.Items.Chest.Enabled),
          " • Ammo: " .. toStr(getgenv().EspSettings.Items.Ammo.Enabled),
          " • Scrap: " .. toStr(getgenv().EspSettings.Items.Scrap.Enabled),
          " • Food: " .. toStr(getgenv().EspSettings.Items.Food.Enabled),
          " • Fuel: " .. toStr(getgenv().EspSettings.Items.Fuel.Enabled),
          " • Tool: " .. toStr(getgenv().EspSettings.Items.Tool.Enabled)
      }, "\n"))
  end
end)
EnableEsp:OnChanged(function(Value)
  getgenv().EspSettings.Enabled = Value
end)
VisualTab:AddSection("[🗒️] - Esp Options")
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp animals",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Animals.Enabled = Value
  end
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp chest",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Items.Chest.Enabled = Value
  end
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp ammo",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Items.Ammo.Enabled = Value
  end
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp scrap",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Items.Scrap.Enabled = Value
  end
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp food",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Items.Food.Enabled = Value
  end
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp fuel",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Items.Fuel.Enabled = Value
  end
})
VisualTab:AddToggle("AcrylicToggle", {
  Title = "Esp tool",
  Default = false,
  Callback = function(Value)
    getgenv().EspSettings.Items.Tool.Enabled = Value
  end
})
VisualTab:AddSection("[⚙️] - Esp Settings")
VisualTab:AddDropdown("", {
  Title = "Box style",
  Description = "Enter the mode you want to view the player in, either 2d or 3d",
  Values = {'2d', '3d'},
  Default = "2d",
  Callback = function(Value)
    getgenv().EspSettings.BoxType = Value
  end
})
local Tracers = VisualTab:AddToggle("", {
  Title = "Tracers",
  Description = "Creates a line between you and the desired player",
  Default = true,
})
Tracers:OnChanged(function(Value)
  getgenv().EspSettings.Tracers = Value
end)
local Studs = VisualTab:AddToggle("", {
  Title = "Studs",
  Description = "Shows how far you are from another player",
  Default = true,
})
Studs:OnChanged(function(Value)
  getgenv().EspSettings.Studs = Value
end)
local Box = VisualTab:AddToggle("", {
  Title = "Box",
  Description = "Shows a 2d or 3d box for you to visualize the object",
  Default = true,
})
Box:OnChanged(function(Value)
  getgenv().EspSettings.Box = Value
end)


MiscTab:AddSection("[🔧] - Extras Options")
MiscTab:AddButton({
  Title = "Remove all prompts cooldown",
  Callback = function()
    for _, v in pairs(workspace:GetDescendants()) do
      if v:IsA('ProximityPrompt') then
        v.HoldDuration = 0
      end
    end
  end
})
MiscTab:AddButton({
  Title = "Reset mobile button",
  Callback = function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Items/button.lua",true))()
  end
})


Tabs.Settings:AddSection("[⚙️] - Ui Settings")
local InterfaceTheme = Tabs.Settings:AddDropdown("InterfaceTheme", {
  Title = "Theme",
  Description = "Changes the interface theme.",
  Values = Fluent.Themes,
  Default = "InfinityX",
  Callback = function(Value)
    Fluent:SetTheme(Value)
  end
})
Tabs.Settings:AddToggle("AcrylicToggle", {
  Title = "Acrylic",
  Description = "The blurred background requires graphic quality 8+",
  Default = false,
  Callback = function(Value)
    Fluent:ToggleAcrylic(Value)
  end
})
Tabs.Settings:AddToggle("TransparentToggle", {
  Title = "Transparency",
  Description = "Makes the interface transparent.",
  Default = true,
  Callback = function(Value)
    Fluent:ToggleTransparency(Value)
  end
})
local MenuKeybind = Tabs.Settings:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = "K" })
Fluent.MinimizeKeybind = MenuKeybind
Tabs.Settings:AddSection("[🎉] - Credits")
local p1 = Tabs.Settings:AddParagraph({
  Title = "Script Credits",
  Content = "Made by: Lmy77"
})
Tabs.Settings:AddButton({
  Title = "Join discord server",
  Callback = function()
    setclipboard("https://discord.gg/emKJgWMHAr")
  	Fluent:Notify({
  		Title = "InfinityX",
  		Content = "Link copied to your clipboard",
  		Duration = 5
  	})
  end
})


-- extra functions
game:GetService("Players").LocalPlayer.Inventory.ChildAdded:Connect(function()
  WeaponsDropdown:SetValues(GetItems())
end)
game:GetService("Players").LocalPlayer.Inventory.ChildRemoved:Connect(function()
  WeaponsDropdown:SetValues(GetItems())
end)
