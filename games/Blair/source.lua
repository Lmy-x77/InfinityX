---@diagnostic disable: undefined-global
-- detect service
local Players = game:GetService("Players")
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
if game.PlaceId == 6137321701 then
  loadstring(game:HttpGetAsync(
    'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Blair/Notification.lua'
  ))()
  return
end
local findprompt = workspace.Map.Van.Van.Door.Center:FindFirstChild('ProximityPrompt')
if findprompt then
  game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Van.Van.Door.Center.CFrame
  wait(0.5)
  fireproximityprompt(workspace.Map.Van.Van.Door.Center.ProximityPrompt)
end
wait(2)


-- variables
fcRunning = false
local Camera = workspace.CurrentCamera
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	local newCamera = workspace.CurrentCamera
	if newCamera then
		Camera = newCamera
	end
end)
local INPUT_PRIORITY = Enum.ContextActionPriority.High.Value
Spring = {} do
	Spring.__index = Spring

	function Spring.new(freq, pos)
		local self = setmetatable({}, Spring)
		self.f = freq
		self.p = pos
		self.v = pos*0
		return self
	end

	function Spring:Update(dt, goal)
		local f = self.f*2*math.pi
		local p0 = self.p
		local v0 = self.v

		local offset = goal - p0
		local decay = math.exp(-f*dt)

		local p1 = goal + (v0*dt - offset*(f*dt + 1))*decay
		local v1 = (f*dt*(offset*f - v0) + v0)*decay

		self.p = p1
		self.v = v1

		return p1
	end

	function Spring:Reset(pos)
		self.p = pos
		self.v = pos*0
	end
end
local cameraPos = Vector3.new()
local cameraRot = Vector2.new()
local velSpring = Spring.new(5, Vector3.new())
local panSpring = Spring.new(5, Vector2.new())
Input = {} do

	keyboard = {
		W = 0,
		A = 0,
		S = 0,
		D = 0,
		E = 0,
		Q = 0,
		Up = 0,
		Down = 0,
		LeftShift = 0,
	}

	mouse = {
		Delta = Vector2.new(),
	}

	NAV_KEYBOARD_SPEED = Vector3.new(1, 1, 1)
	PAN_MOUSE_SPEED = Vector2.new(1, 1)*(math.pi/64)
	NAV_ADJ_SPEED = 0.75
	NAV_SHIFT_MUL = 0.25

	navSpeed = 1

	function Input.Vel(dt)
		navSpeed = math.clamp(navSpeed + dt*(keyboard.Up - keyboard.Down)*NAV_ADJ_SPEED, 0.01, 4)

		local kKeyboard = Vector3.new(
			keyboard.D - keyboard.A,
			keyboard.E - keyboard.Q,
			keyboard.S - keyboard.W
		)*NAV_KEYBOARD_SPEED

		local shift = UserInputService:IsKeyDown(Enum.KeyCode.LeftShift)

		return (kKeyboard)*(navSpeed*(shift and NAV_SHIFT_MUL or 1))
	end

	function Input.Pan(dt)
		local kMouse = mouse.Delta*PAN_MOUSE_SPEED
		mouse.Delta = Vector2.new()
		return kMouse
	end

	do
		function Keypress(action, state, input)
			keyboard[input.KeyCode.Name] = state == Enum.UserInputState.Begin and 1 or 0
			return Enum.ContextActionResult.Sink
		end

		function MousePan(action, state, input)
			local delta = input.Delta
			mouse.Delta = Vector2.new(-delta.y, -delta.x)
			return Enum.ContextActionResult.Sink
		end

		function Zero(t)
			for k, v in pairs(t) do
				t[k] = v*0
			end
		end

		function Input.StartCapture()
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamKeyboard",Keypress,false,INPUT_PRIORITY,
				Enum.KeyCode.W,
				Enum.KeyCode.A,
				Enum.KeyCode.S,
				Enum.KeyCode.D,
				Enum.KeyCode.E,
				Enum.KeyCode.Q,
				Enum.KeyCode.Up,
				Enum.KeyCode.Down
			)
			game:GetService("ContextActionService"):BindActionAtPriority("FreecamMousePan",MousePan,false,INPUT_PRIORITY,Enum.UserInputType.MouseMovement)
		end

		function Input.StopCapture()
			navSpeed = 1
			Zero(keyboard)
			Zero(mouse)
			game:GetService("ContextActionService"):UnbindAction("FreecamKeyboard")
			game:GetService("ContextActionService"):UnbindAction("FreecamMousePan")
		end
	end
end
local function StepFreecam(dt)
	local vel = velSpring:Update(dt, Input.Vel(dt))
	local pan = panSpring:Update(dt, Input.Pan(dt))

	local zoomFactor = math.sqrt(math.tan(math.rad(70/2))/math.tan(math.rad(cameraFov/2)))

	cameraRot = cameraRot + pan*Vector2.new(0.75, 1)*8*(dt/zoomFactor)
	cameraRot = Vector2.new(math.clamp(cameraRot.x, -math.rad(90), math.rad(90)), cameraRot.y%(2*math.pi))

	local cameraCFrame = CFrame.new(cameraPos)*CFrame.fromOrientation(cameraRot.x, cameraRot.y, 0)*CFrame.new(vel*Vector3.new(1, 1, 1)*64*dt)
	cameraPos = cameraCFrame.p

	Camera.CFrame = cameraCFrame
	Camera.Focus = cameraCFrame*CFrame.new(0, 0, -GetFocusDistance(cameraCFrame))
	Camera.FieldOfView = cameraFov
end
local PlayerState = {} do
	mouseBehavior = ""
	mouseIconEnabled = ""
	cameraType = ""
	cameraFocus = ""
	cameraCFrame = ""
	cameraFieldOfView = ""

	function PlayerState.Push()
		cameraFieldOfView = Camera.FieldOfView
		Camera.FieldOfView = 70

		cameraType = Camera.CameraType
		Camera.CameraType = Enum.CameraType.Custom

		cameraCFrame = Camera.CFrame
		cameraFocus = Camera.Focus

		mouseIconEnabled = UserInputService.MouseIconEnabled
		UserInputService.MouseIconEnabled = true

		mouseBehavior = UserInputService.MouseBehavior
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end

	function PlayerState.Pop()
		Camera.FieldOfView = 70

		Camera.CameraType = cameraType
		cameraType = nil

		Camera.CFrame = cameraCFrame
		cameraCFrame = nil

		Camera.Focus = cameraFocus
		cameraFocus = nil

		UserInputService.MouseIconEnabled = mouseIconEnabled
		mouseIconEnabled = nil

		UserInputService.MouseBehavior = mouseBehavior
		mouseBehavior = nil
	end
end
function StartFreecam(pos)
	if fcRunning then
		StopFreecam()
	end
	local cameraCFrame = Camera.CFrame
	if pos then
		cameraCFrame = pos
	end
	cameraRot = Vector2.new()
	cameraPos = cameraCFrame.p
	cameraFov = Camera.FieldOfView

	velSpring:Reset(Vector3.new())
	panSpring:Reset(Vector2.new())

	PlayerState.Push()
	game:GetService("RunService"):BindToRenderStep("Freecam", Enum.RenderPriority.Camera.Value, StepFreecam)
	Input.StartCapture()
	fcRunning = true
end
function StopFreecam()
	if not fcRunning then return end
	Input.StopCapture()
	game:GetService("RunService"):UnbindFromRenderStep("Freecam")
	PlayerState.Pop()
	workspace.Camera.FieldOfView = 70
	fcRunning = false
end
function DeadStatus()
  if game:GetService("Players").LocalPlayer.Dead == true then
    return 'yes'
  elseif game:GetService("Players").LocalPlayer.Dead == true == false then
    return 'no'
  end
end
function GetZones()
  local zones = {}
  for _, v in pairs(workspace.Map.Zones:GetChildren()) do
    if (v:IsA('Part') or v:IsA('UnionOperation') or v:IsA('MeshPart')) then
      table.insert(zones, v.Name)
    end
  end
  return zones
end
function GetCursedObjects()
  local objects = {}
  for _, v in pairs(workspace.Map.CursedSpawns:GetChildren()) do
    if v:IsA("Part") then
      table.insert(objects, v.Name)
    end
  end
  return objects
end
function GetCurrentCursedObject()
  local cursedfunc = GetCursedObjects()
  for _, v in pairs(workspace:GetDescendants()) do
    if (v:IsA("Model") or v:IsA('Tool')) and table.find(cursedfunc, v.Name) then
      return v
    end
  end
  return "Not spawned"
end
function CheckCursedObjects()
  local cursedNames = {
    "Music Box",
    "Spirit Board",
    "SummoningCircle",
    "Tarot Cards"
  }
  for _, v in pairs(workspace:GetDescendants()) do
    if (v:IsA("Model") or v:IsA("Tool")) and table.find(cursedNames, v.Name) then
      return true
    end
  end
  return false
end
function CreateEsp(path: Instance, name: string, color)
  if not path:FindFirstChild("Esp") then
      local box = Instance.new("BoxHandleAdornment")
      box.Name = "Esp"
      box.Color3 = color or Color3.fromRGB(255, 0, 0)
      box.Transparency = 0.5
      box.AlwaysOnTop = true
      box.ZIndex = 5
      if path:IsA("Model") then
        box.Size = path:GetExtentsSize()
      elseif path:IsA("BasePart") then
        box.Size = path.Size
      else
        box.Size = Vector3.new(4, 4, 4)
      end
      box.Adornee = path
      box.Parent = path
  end

  if not path:FindFirstChild("EspName") then
      local billboard = Instance.new("BillboardGui")
      billboard.Name = "EspName"
      billboard.Adornee = path
      billboard.Size = UDim2.new(0, 200, 0, 50)
      billboard.StudsOffset = Vector3.new(0, 3, 0)
      billboard.AlwaysOnTop = true
      billboard.Parent = path

      local label = Instance.new("TextLabel")
      label.Size = UDim2.new(1, 0, 1, 0)
      label.BackgroundTransparency = 1
      label.TextColor3 = color or Color3.fromRGB(255, 0, 0)
      label.TextStrokeTransparency = 0
      label.Text = name
      label.Font = Enum.Font.SourceSansBold
      label.TextScaled = true
      label.Parent = billboard
  end
end
function GetWritingBook()
  local itemsFolder = workspace.Map:FindFirstChild("Items")
  if not itemsFolder then
      return "no"
  end

  for _, v in pairs(itemsFolder:GetChildren()) do
    if v:IsA("Tool") and v.Name == "Ghost Writing Book" then
      local writtenValue = v:FindFirstChild("Written")
      if writtenValue and writtenValue.Value == true then
        return "yes"
      end
    end
  end

  return "no"
end
local GetFreezeTemperatureStatus = "no"
local FreezeTemperatureConnection = nil
function StartFreezeTemperatureCheck()
  if FreezeTemperatureConnection then
    FreezeTemperatureConnection:Disconnect()
  end

  FreezeTemperatureConnection = game:GetService("RunService").Stepped:Connect(function()
    local lowestValue = math.huge
    local lowestParent = nil

    for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
      if v:IsA("NumberValue") and v.Name:lower():find("temperature") and v.Parent.Parent.Name ~= "Outside" then
        if v.Value < lowestValue then
          lowestValue = v.Value
          lowestParent = v
        end
      end
    end

    if lowestParent and lowestValue < 0 then
      GetFreezeTemperatureStatus = "yes"
    else
      GetFreezeTemperatureStatus = "no"
    end
  end)
end
StartFreezeTemperatureCheck()
function GetGhostRoomTemperature()
  local lowestValue = math.huge
  local lowestParent = nil

  for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
    if v:IsA("NumberValue") and v.Name:find("LocalBaseTemp") and v.Parent.Parent.Name ~= "Outside" then
      if v.Value < lowestValue then
        lowestValue = v.Value
        lowestParent = v.Parent.Parent
      end
    end
  end

  if lowestParent then
    local tempValue = lowestParent:FindFirstChildWhichIsA("NumberValue")
    if tempValue then
      local temp = math.floor(tempValue.Value * 1000 + 0.5) / 1000
      return temp, lowestParent.Name
    end
  end

  return nil, nil
end
local lastRoom = "Unknown"
function GetOrbs()
  local findpart = workspace.Map.Orbs:FindFirstChild('OrbPart')
  if findpart then
    return 'yes'
  else
    return 'no'
  end
end
function GetPrints()
  if #workspace.Map.Prints:GetChildren() > 0 then
    return 'yes'
  else
    return 'no'
  end
end
local GetSpiritBoxStatus = 'no'
local spiritBoxConnection = nil
function GetSpritBox()
  local player = game:GetService("Players").LocalPlayer
  local playerGui = player:WaitForChild("PlayerGui")
  local radioFrame = playerGui:WaitForChild("Radio"):WaitForChild("Frame")
  spiritBoxConnection = radioFrame.ChildAdded:Connect(function(Message)
    if Message:IsA('Frame') and Message.Name == 'Message' then
      GetSpiritBoxStatus = 'yes'
      if spiritBoxConnection then
        spiritBoxConnection:Disconnect()
      end
    end
  end)
end
GetSpritBox()


-- ui library
local isMobile = game.UserInputService.TouchEnabled
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Fluent/source.lua"))()

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
	TabWidth = 160,
	Size = GetSize(),
	Acrylic = false,
	Theme = "InfinityX",
	MinimizeKey = Enum.KeyCode.K
})


-- tabs
local Tabs = {
  Game = Window:AddTab({ Title = "| Game", Icon = "server" }),
  Esp = Window:AddTab({ Title = "| Esp", Icon = "eye" }),
  Teleport = Window:AddTab({ Title = "| Teleport", Icon = "target" }),
  Character = Window:AddTab({ Title = "| Character", Icon = "user" }),
  Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" })
}
Window:SelectTab(1)


-- source
Tabs.Game:AddSection("[🎲] - Status")
local p4 = Tabs.Game:AddParagraph({
  Title = "Game Status",
  Content = "None"
})
spawn(function()
  while true do
    task.wait()

    local temp, room = GetGhostRoomTemperature()
    if room then
      lastRoom = room
    end

    local freeze = GetFreezeTemperatureStatus or "?"
    local orbs = GetOrbs() or "?"
    local book = GetWritingBook() or "?"
    local prints = GetPrints() or "?"
    local spirit = GetSpiritBoxStatus or "?"

    p4:SetDesc(
      "• Freeze Temperature: " .. freeze ..
      "\n• Orbs | Particle: " .. orbs ..
      "\n• Writing Book: " .. book ..
      "\n• Prints | UV: " .. prints ..
      "\n• Spirit Box: " .. spirit ..
      "\n\n• Ghost Room Current Temperature: " .. (temp or "?") ..
      "\n• Current Ghost Room: " .. lastRoom
    )
  end
end)
Tabs.Game:AddButton({
  Title = "Create status frame",
  Description = "If you don't want to leave the ui open all the time, this function creates a frame showing the status in the “Game Status” Dropdown on your screen.",
  Callback = function()
    local find = game:GetService("CoreGui"):FindFirstChild('GameStatus')
    if find then return end
    if not find then
      loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Blair/ui.lua"))()
    end
  end
})
Tabs.Game:AddButton({
  Title = "Close ui",
  Callback = function()
    local find = game:GetService("CoreGui"):FindFirstChild('GameStatus')
    if not find then return end
    if find then
      find:Destroy()
    end
  end
})

Tabs.Esp:AddSection("[👀] - Esp Options")
Tabs.Esp:AddToggle("AcrylicToggle", {
  Title = "Ghost esp",
  Default = false,
  Callback = function(Value)
    espghost = Value
    while espghost do task.wait()
      if espghost then
        for _, v in pairs(workspace:GetChildren()) do
          if v:IsA('Model') and v.Name == 'Ghost' then
            CreateEsp(v, 'Ghost', Color3.new(0.588235, 0.011765, 0.011765))
          end
        end
      elseif espghost then
        for _, v in pairs(workspace:GetChildren()) do
          if v:IsA('Model') and v.Name == 'Ghost' then
            if v:FindFirstChildWhichIsA('BoxHandleAdornment') then
              v:FindFirstChildWhichIsA('BoxHandleAdornment'):Destroy()
              v:FindFirstChildWhichIsA('BillboardGui'):Destroy()
            end
          end
        end
      end
    end
  end
})
Tabs.Esp:AddToggle("AcrylicToggle", {
  Title = "BooBooDoll esp",
  Default = false,
  Callback = function(Value)
    espBooBooDoll = Value
    if espBooBooDoll then
      if workspace:FindFirstChild('BooBooDoll') then  
        CreateEsp(workspace:FindFirstChild('BooBooDoll'), workspace:FindFirstChild('BooBooDoll').Name, Color3.new(0.541176, 0.541176, 0.541176))
      end
    elseif not espBooBooDoll then
      for _, v in pairs(workspace:GetChildren()) do
        if v:IsA('MeshPart') and v.Name == 'BooBooDoll' then
          if v:FindFirstChild('Esp') then
            v:FindFirstChildWhichIsA('BoxHandleAdornment'):Destroy()
            v:FindFirstChildWhichIsA('BillboardGui'):Destroy()
          end
        end
      end
    end
  end
})
Tabs.Esp:AddToggle("AcrylicToggle", {
  Title = "Cursed object esp",
  Default = false,
  Callback = function(Value)
    espobject = Value
    if espobject then
      if not CheckCursedObjects() then return end
      CreateEsp(GetCurrentCursedObject(), GetCurrentCursedObject().Name, Color3.new(0.913725, 0.196078, 0.196078))
    elseif not espobject then
      for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA('Model') or v:IsA('Tool') and table.find(GetCursedObjects(), v.Name) then
          if v:FindFirstChild('Esp') then
            v:FindFirstChildWhichIsA('BoxHandleAdornment'):Destroy()
            v:FindFirstChildWhichIsA('BillboardGui'):Destroy()
          end
        end
      end
    end
  end
})
Tabs.Esp:AddToggle("AcrylicToggle", {
  Title = "Ghost room esp",
  Default = false,
  Callback = function(Value)
    espghostroom = Value
    local lowestValue = math.huge
    local lowestParent = nil
    for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
      if v:IsA("NumberValue") and v.Name:find("LocalBaseTemp") and (v.Parent.Parent.Name ~= "Outside" and v.Parent.Parent.Name ~= "Graveyard") then
        if v.Value < lowestValue then
          lowestValue = v.Value
          lowestParent = v.Parent.Parent
        end
      end
    end
    if espghostroom and lowestParent then
      CreateEsp(workspace.Map.Zones[lowestParent.Name], workspace.Map.Zones[lowestParent.Name].Name, Color3.new(0.078431, 0.478431, 0.545098))
    elseif not espghostroom then
      for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
        if (v:IsA('BillboardGui') and v.Name == 'EspName' or v:IsA('BoxHandleAdornment') and v.Name == 'Esp') then
          v:Destroy()
        end
      end
    end
  end
})
Tabs.Esp:AddToggle("AcrylicToggle", {
  Title = "All items esp",
  Default = false,
  Callback = function(Value)
    espitems = Value
    if espitems then
      for _, v in pairs(workspace.Map.Items:GetChildren()) do
        if v:IsA('Tool') then
          CreateEsp(v, v.Name, Color3.new(0.192156, 0.6, 0.654901))
        end
      end
    else
      for _, v in pairs(workspace.Map.Items:GetDescendants()) do
        if (v:IsA('BillboardGui') and v.Name == 'EspName' or v:IsA('BoxHandleAdornment') and v.Name == 'Esp') then
          v:Destroy()
        end
      end
    end
  end
})

Tabs.Teleport:AddSection("[🌍] - Zone Teleport")
local ZonesTeleportDropdown = Tabs.Teleport:AddDropdown("", {
  Title = "Select zone",
  Description = "Select the zone you want to teleport",
  Values = GetZones(),
  Default = "",
  Callback = function(Value)
    selectedzone = Value
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to selected zone",
  Callback = function()
    game:GetService("Players").LocalPlayer.Zone.Value = workspace.Map.Zones[selectedzone]
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Zones[selectedzone].CFrame
  end
})
Tabs.Teleport:AddSection("[👿] - Cursed Objects Teleport")
local p3 = Tabs.Teleport:AddParagraph({
  Title = "Object Viewer",
  Content = "• Not spawned"
})
spawn(function()
  while true do task.wait(1)
    if CheckCursedObjects() then
      p3:SetDesc('• Current cursed object is: ' .. GetCurrentCursedObject().Name)
    end
  end
end)
local ZonesTeleportDropdown = Tabs.Teleport:AddDropdown("", {
  Title = "Select object",
  Description = "Select the cursed object you want to teleport",
  Values = GetCursedObjects(),
  Default = "",
  Callback = function(Value)
    selectedobject = Value
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to selected object",
  Callback = function()
    local plr = game:GetService("Players").LocalPlayer
    local hrp = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
    local obj = workspace:FindFirstChild(selectedobject)

    if hrp and obj then
      local part = obj:FindFirstChildWhichIsA("Part") or obj:FindFirstChildWhichIsA("MeshPart") or obj:FindFirstChildWhichIsA("UnionOperation")
      if part then
        hrp.CFrame = part.CFrame
      end
    end
  end
})
Tabs.Teleport:AddSection("[🏃] - Fast Teleport")
Tabs.Teleport:AddButton({
  Title = "Teleport to van",
  Callback = function()
    game:GetService("Players").LocalPlayer.Zone.Value = workspace.Map.Zones.Outside
    game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Van.Van.Door.Center.CFrame
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to ghost room",
  Callback = function()
    local lowestValue = math.huge
    local lowestParent = nil
    for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
      if v:IsA("NumberValue") and v.Name:find('LocalBaseTemp') and v.Parent.Parent.Name ~= 'Outside' then
        if v.Value < lowestValue then
          lowestValue = v.Value
          lowestParent = v.Parent.Parent
        end
      end
    end
    if lowestParent then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map.Zones[lowestParent.Name].CFrame
    end
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to BooBooDoll",
  Callback = function()
    local find = workspace:FindFirstChild('BooBooDoll')
    if not find then return end

    if find then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = find.CFrame  
    end
  end
})

Tabs.Character:AddSection("[📊] - Character Status")
local p1 = Tabs.Character:AddParagraph({
  Title = "Your Status",
  Content = "None"
})
spawn(function()
  while true do task.wait()
    p1:SetDesc(
      '• Sanity: ' .. math.floor(game:GetService("Players").LocalPlayer.Sanity.Value + 0.5)..
      '\n• Zone: ' .. tostring(game:GetService("Players").LocalPlayer.Zone.Value)..
      '\n• Lives: ' .. game:GetService("Players").LocalPlayer.Lives.Value..
      '\n• Dead: ' .. DeadStatus()
    )
  end
end)
local p2 = Tabs.Character:AddParagraph({
  Title = "Item Status",
  Content = "None"
})
spawn(function()
  while true do task.wait()
    p2:SetDesc(
      '• Slot1: ' .. tostring(game:GetService("Players").LocalPlayer.Slot1.Value)..
      '\n• Slot2: ' .. tostring(game:GetService("Players").LocalPlayer.Slot2.Value)..
      '\n• Slot3: ' .. tostring(game:GetService("Players").LocalPlayer.Slot3.Value)..
      '\n• Slot4: ' .. tostring(game:GetService("Players").LocalPlayer.Slot4.Value)..
      '\n• Slot5: ' .. tostring(game:GetService("Players").LocalPlayer.Slot5.Value)
    )
  end
end)
Tabs.Character:AddSection("[🙍] - Character Options")
Tabs.Character:AddToggle("AcrylicToggle", {
  Title = "Freecam",
  Description = 'Allows the player to control the camera and go wherever they want',
  Default = false,
  Callback = function(Value)
    fc = Value
    if fc then
      StartFreecam()
    else
      StopFreecam()
    end
  end
})
Tabs.Character:AddToggle("AcrylicToggle", {
  Title = "Self-protection",
  Description = 'When the ghost gets close to you, you will be teleported to the van automatically',
  Default = false,
  Callback = function(Value)
    local sp = Value
    while sp do
      task.wait()
      for _, v in pairs(workspace:GetChildren()) do
        if v:IsA("Model") and v.Name == "Ghost" then
          local ghostPos = v:FindFirstChild("HumanoidRootPart")
          local myPos = game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
          if ghostPos and myPos then
            local dist = (ghostPos.Position - myPos.Position).Magnitude
            if dist < 40 then
              local plr = game:GetService("Players").LocalPlayer
              plr.Zone.Value = workspace.Map.Zones.Outside
              plr.Character.HumanoidRootPart.CFrame = workspace.Map.Van.Van.Door.Center.CFrame
            end
          end
        end
      end
    end
  end
})
Tabs.Character:AddToggle("AcrylicToggle", {
  Title = "Get night vision",
  Description = 'Press space to active night vision',
  Default = false,
  Callback = function(Value)
    nightvision = Value
    while nightvision do task.wait()
      game:GetService("Players").LocalPlayer.NightVision.Value = Value
    end
  end
})
Tabs.Character:AddToggle("AcrylicToggle", {
  Title = "Admin mode attribute",
  Description = "This mode gives you more speed in everything, it doesn't give you admin permissions, only admin speeds",
  Default = false,
  Callback = function(Value)
    if not Value then return end
    local l_l_Players_0_PlayerFromCharacter_0 = game.Players:GetPlayerFromCharacter(game.Players.LocalPlayer.Character);
    l_l_Players_0_PlayerFromCharacter_0:SetAttribute('AdminMode', Value)
  end
})
Tabs.Character:AddButton({
  Title = "Fullbright",
  Description = 'Removes all shadows and dark parts of the map',
  Callback = function()
    game.Lighting.Brightness = 2
    game.Lighting.ClockTime = 14
    game.Lighting.FogEnd = 100000
    game.Lighting.GlobalShadows = false
    game.Lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
  end
})
Tabs.Character:AddSection("[🏃] - Character Speed")
Tabs.Character:AddInput("Input", {
  Title = "WalkSpeed",
  Default = "",
  Placeholder = "6.5",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    for _, v in pairs(getgc(true)) do
      if type(v) == 'table' and rawget(v, 'WalkingSpeed') then
        rawset(v, 'WalkingSpeed', Value)
      end
    end
  end
})
Tabs.Character:AddInput("Input", {
  Title = "CrouchingSpeed",
  Default = "",
  Placeholder = "3",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    for _, v in pairs(getgc(true)) do
      if type(v) == 'table' and rawget(v, 'CrouchingSpeed') then
        rawset(v, 'CrouchingSpeed', Value)
      end
    end
  end
})
Tabs.Character:AddInput("Input", {
  Title = "BackwardsSpeed",
  Default = "",
  Placeholder = "6",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    for _, v in pairs(getgc(true)) do
      if type(v) == 'table' and rawget(v, 'BackwardsSpeed') then
        rawset(v, 'BackwardsSpeed', Value)
      end
    end
  end
})
Tabs.Character:AddInput("Input", {
  Title = "SidewaysSpeed",
  Default = "",
  Placeholder = "6",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    for _, v in pairs(getgc(true)) do
      if type(v) == 'table' and rawget(v, 'SidewaysSpeed') then
        rawset(v, 'SidewaysSpeed', Value)
      end
    end
  end
})
Tabs.Character:AddInput("Input", {
  Title = "DiagonalSpeed",
  Default = "",
  Placeholder = "6",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    for _, v in pairs(getgc(true)) do
      if type(v) == 'table' and rawget(v, 'DiagonalSpeed') then
        rawset(v, 'DiagonalSpeed', Value)
      end
    end
  end
})
Tabs.Character:AddInput("Input", {
  Title = "RunningSpeed",
  Default = "",
  Placeholder = "13",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    for _, v in pairs(getgc(true)) do
      if type(v) == 'table' and rawget(v, 'RunningSpeed') then
        rawset(v, 'RunningSpeed', Value)
      end
    end
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
