local cloneref = cloneref or function(object)
  return object
end

local Players = cloneref(game:GetService("Players"))
local RunService = cloneref(game:GetService("RunService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local Workspace = cloneref(game:GetService("Workspace"))

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

if getgenv().AimbotController and getgenv().AimbotController.Destroy then
  pcall(function()
    getgenv().AimbotController:Destroy()
  end)
end

local function merge(defaults, source)
  local result = {}

  for key, value in pairs(defaults) do
    if type(value) == "table" then
      result[key] = merge(value, type(source[key]) == "table" and source[key] or {})
    else
      result[key] = value
    end
  end

  for key, value in pairs(source) do
    if result[key] == nil then
      result[key] = value
    end
  end

  return result
end

local DefaultConfig = {
  Enabled = true,
  TeamCheck = true,
  WallCheck = true,
  OnlyPlayerMode = false,
  Player = "",
  AimPart = "Head",
  AimMethod = "MouseLock",
  TargetPriority = "Closest to cursor",
  Smoothness = 0.25,
  Prediction = true,
  PredictionX = 0.165,
  Keybind = Enum.UserInputType.MouseButton2,
  HoldToActivate = true,
  Fov = {
    Enabled = true,
    FovSize = 120,
    FovColor = Color3.fromRGB(255, 255, 255),
    Transparency = 0,
  },
  TargetIndicator = {
    Enabled = true,
    Radius = 10,
    Color = Color3.fromRGB(255, 60, 60),
    Transparency = 0,
  },
}

local sourceConfig = getgenv().AimbotSettings or getgenv().Aimbot or {}
local Config = merge(DefaultConfig, sourceConfig)

getgenv().Aimbot = Config
getgenv().AimbotSettings = Config

local Aimbot = {
  Config = Config,
  Connections = {},
  Drawings = {},
  Holding = false,
  CurrentTarget = nil,
  CurrentTargetPosition = nil,
  UI = {},
  Started = false,
  Destroyed = false,
}

local function safeCall(callback, ...)
  local success, result = pcall(callback, ...)
  if success then
    return result
  end
end

local function track(connection)
  table.insert(Aimbot.Connections, connection)
  return connection
end

local function removeDrawing(drawing)
  if not drawing then
    return
  end

  safeCall(function()
    if drawing.Remove then
      drawing:Remove()
    elseif drawing.Destroy then
      drawing:Destroy()
    end
  end)
end

local function getTargetName()
  if typeof(Config.Player) == "Instance" and Config.Player:IsA("Player") then
    return Config.Player.Name:lower()
  end

  local value = tostring(Config.Player or "")
  return value:lower()
end

local function keyMatches(input, key)
  if typeof(key) == "EnumItem" then
    return input.UserInputType == key or input.KeyCode == key
  end

  if type(key) ~= "string" then
    return false
  end

  local normalized = key:gsub("%s+", "")

  local mouseButtons = {
    MB1 = Enum.UserInputType.MouseButton1,
    MB2 = Enum.UserInputType.MouseButton2,
    MB3 = Enum.UserInputType.MouseButton3,
  }

  if mouseButtons[normalized] then
    return input.UserInputType == mouseButtons[normalized]
  end

  local keyCode = Enum.KeyCode[normalized]
  if keyCode then
    return input.KeyCode == keyCode
  end

  local inputType = Enum.UserInputType[normalized]
  if inputType then
    return input.UserInputType == inputType
  end

  return false
end

local function getKeyName(key)
  if typeof(key) == "EnumItem" then
    if key.EnumType == Enum.UserInputType then
      if key == Enum.UserInputType.MouseButton1 then
        return "MB1"
      elseif key == Enum.UserInputType.MouseButton2 then
        return "MB2"
      elseif key == Enum.UserInputType.MouseButton3 then
        return "MB3"
      end
    end

    return key.Name
  end

  return tostring(key)
end

local function getAimPart(character)
  if Config.AimPart == "Head" then
    return character:FindFirstChild("Head")
  elseif Config.AimPart == "UpperTorso" then
    return character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
  elseif Config.AimPart == "HumanoidRootPart" then
    return character:FindFirstChild("HumanoidRootPart")
  end

  return character:FindFirstChild("Head")
end

local function isValid(player)
  if player == LocalPlayer then
    return false
  end

  if Config.TeamCheck and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then
    return false
  end

  local character = player.Character
  if not character then
    return false
  end

  local humanoid = character:FindFirstChildOfClass("Humanoid")
  if not humanoid or humanoid.Health <= 0 then
    return false
  end

  local root = character:FindFirstChild("HumanoidRootPart")
  if not root then
    return false
  end

  return true
end

local RaycastParams = RaycastParams.new()
RaycastParams.FilterType = Enum.RaycastFilterType.Exclude
RaycastParams.IgnoreWater = true

local function isVisible(character, part)
  RaycastParams.FilterDescendantsInstances = {
    LocalPlayer.Character,
    Camera,
  }

  local origin = Camera.CFrame.Position
  local direction = part.Position - origin
  local result = Workspace:Raycast(origin, direction, RaycastParams)

  return result == nil or result.Instance:IsDescendantOf(character)
end

local function getPredictedPosition(part, character)
  if not Config.Prediction then
    return part.Position
  end

  local root = character:FindFirstChild("HumanoidRootPart")
  if not root then
    return part.Position
  end

  local velocity = root.AssemblyLinearVelocity
  if velocity.Magnitude < 1 then
    return part.Position
  end

  local ping = safeCall(function()
    return LocalPlayer:GetNetworkPing()
  end) or 0.05

  local travelTime = math.max(ping + Config.PredictionX, 0)

  return part.Position + velocity * travelTime
end

local function getScreenDistance(position)
  local screenPoint, onScreen = Camera:WorldToViewportPoint(position)

  if not onScreen then
    return nil
  end

  local mouse = UserInputService:GetMouseLocation()
  local screenPosition = Vector2.new(screenPoint.X, screenPoint.Y)

  return (screenPosition - mouse).Magnitude
end

local function getTargetScore(player, part, predictedPosition)
  local screenDistance = getScreenDistance(predictedPosition)

  if not screenDistance then
    return nil
  end

  if screenDistance > Config.Fov.FovSize then
    return nil
  end

  local character = player.Character
  if not character then
    return nil
  end

  local humanoid = character:FindFirstChildOfClass("Humanoid")
  local root = character:FindFirstChild("HumanoidRootPart")

  if Config.TargetPriority == "Lowest health" then
    local healthPercent = humanoid and humanoid.MaxHealth > 0
      and humanoid.Health / humanoid.MaxHealth
      or 1

    return healthPercent * 1000 + screenDistance
  elseif Config.TargetPriority == "Closest distance" then
    local distance = root and (root.Position - Camera.CFrame.Position).Magnitude or math.huge
    return distance
  end

  return screenDistance
end

local function findTarget()
  if Config.OnlyPlayerMode then
    local targetPlayer = Config.Player

    if typeof(targetPlayer) ~= "Instance" or not targetPlayer:IsA("Player") then
      local targetName = getTargetName()

      if targetName == "" then
        return nil, nil
      end

      for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Name:lower() == targetName then
          targetPlayer = player
          break
        end
      end
    end

    if typeof(targetPlayer) ~= "Instance" or not isValid(targetPlayer) then
      return nil, nil
    end

    local character = targetPlayer.Character
    local part = character and getAimPart(character)

    if not part then
      return nil, nil
    end

    if Config.WallCheck and not isVisible(character, part) then
      return nil, nil
    end

    local predictedPosition = getPredictedPosition(part, character)

    if not getTargetScore(targetPlayer, part, predictedPosition) then
      return nil, nil
    end

    return part, predictedPosition, targetPlayer
  end

  local bestPart
  local bestPosition
  local bestPlayer
  local bestScore = math.huge

  for _, player in ipairs(Players:GetPlayers()) do
    if not isValid(player) then
      continue
    end

    local character = player.Character
    local part = getAimPart(character)

    if not part then
      continue
    end

    if Config.WallCheck and not isVisible(character, part) then
      continue
    end

    local predictedPosition = getPredictedPosition(part, character)
    local score = getTargetScore(player, part, predictedPosition)

    if not score then
      continue
    end

    if score < bestScore then
      bestScore = score
      bestPart = part
      bestPosition = predictedPosition
      bestPlayer = player
    end
  end

  return bestPart, bestPosition, bestPlayer
end

local function aimMouseLock(position)
  if not mousemoverel then
    return
  end

  local point, onScreen = Camera:WorldToViewportPoint(position)
  if not onScreen then
    return
  end

  local mouse = UserInputService:GetMouseLocation()
  local targetPosition = Vector2.new(point.X, point.Y)
  local delta = targetPosition - mouse

  local factor = math.clamp(Config.Smoothness, 0.01, 1)

  mousemoverel(
    delta.X * factor,
    delta.Y * factor
  )
end

local function aimCamera(position)
  local desired = CFrame.new(
    Camera.CFrame.Position,
    position
  )

  local factor = math.clamp(Config.Smoothness, 0.01, 1)

  Camera.CFrame = Camera.CFrame:Lerp(
    desired,
    factor
  )
end

local function aimSnap(position)
  Camera.CFrame = CFrame.new(
    Camera.CFrame.Position,
    position
  )
end

local function processAim(part, position)
  if not part or not position then
    Aimbot.CurrentTarget = nil
    Aimbot.CurrentTargetPosition = nil

    if Aimbot.Drawings.Target then
      Aimbot.Drawings.Target.Visible = false
    end

    return
  end

  Aimbot.CurrentTarget = part
  Aimbot.CurrentTargetPosition = position

  if Aimbot.Drawings.Target and Config.TargetIndicator.Enabled then
    local point, onScreen = Camera:WorldToViewportPoint(position)

    if onScreen then
      Aimbot.Drawings.Target.Visible = true
      Aimbot.Drawings.Target.Position = Vector2.new(point.X, point.Y)
      Aimbot.Drawings.Target.Radius = Config.TargetIndicator.Radius
    else
      Aimbot.Drawings.Target.Visible = false
    end
  elseif Aimbot.Drawings.Target then
    Aimbot.Drawings.Target.Visible = false
  end

  if Config.AimMethod == "MouseLock" then
    aimMouseLock(position)
  elseif Config.AimMethod == "Camera" then
    aimCamera(position)
  elseif Config.AimMethod == "Snap" then
    aimSnap(position)
  end
end

function Aimbot:CreateDrawings()
  if self.Drawings.Fov then
    return
  end

  local fovCircle = Drawing.new("Circle")
  fovCircle.Thickness = 1
  fovCircle.NumSides = 128
  fovCircle.Filled = false
  fovCircle.Transparency = 1
  fovCircle.Visible = false

  local targetIndicator = Drawing.new("Circle")
  targetIndicator.Thickness = 2
  targetIndicator.NumSides = 32
  targetIndicator.Filled = false
  targetIndicator.Transparency = 1
  targetIndicator.Visible = false

  self.Drawings.Fov = fovCircle
  self.Drawings.Target = targetIndicator

  fovCircle.Color = Config.Fov.FovColor
  fovCircle.Transparency = 1 - Config.Fov.Transparency

  targetIndicator.Color = Config.TargetIndicator.Color
  targetIndicator.Transparency = 1 - Config.TargetIndicator.Transparency
  targetIndicator.Radius = Config.TargetIndicator.Radius
end

function Aimbot:CreateUI(MainBox, TargetBox, VisualsBox)
  if self.UI.Created then
    return self.UI
  end

  TargetBox = TargetBox or MainBox
  VisualsBox = VisualsBox or MainBox

  local ui = {}

  ui.StatusLabel = MainBox:AddLabel("Status: Disabled")
  ui.TargetLabel = MainBox:AddLabel("Target: N/A")

  ui.Enabled = MainBox:AddToggle("AimbotEnabled", {
    Text = "Enabled",
    Default = Config.Enabled,
    Callback = function(value)
      Config.Enabled = value
    end
  })

  ui.Enabled:AddKeyPicker("AimbotKeybind", {
    Default = getKeyName(Config.Keybind),
    Mode = "Hold",
    Text = "Aimbot key",
    NoUI = false,
    Callback = function(value)
      self.Holding = value
    end,
    ChangedCallback = function(newKey)
      Config.Keybind = newKey
    end
  })

  MainBox:AddToggle("AimbotHoldToActivate", {
    Text = "Hold to activate",
    Default = Config.HoldToActivate,
    Callback = function(value)
      Config.HoldToActivate = value
      self.Holding = false
    end
  })

  MainBox:AddToggle("AimbotTeamCheck", {
    Text = "Team check",
    Default = Config.TeamCheck,
    Callback = function(value)
      Config.TeamCheck = value
    end
  })

  MainBox:AddToggle("AimbotWallCheck", {
    Text = "Wall check",
    Default = Config.WallCheck,
    Callback = function(value)
      Config.WallCheck = value
    end
  })

  MainBox:AddToggle("AimbotPrediction", {
    Text = "Prediction",
    Default = Config.Prediction,
    Callback = function(value)
      Config.Prediction = value
    end
  })

  MainBox:AddToggle("AimbotOnlyPlayer", {
    Text = "Only selected player",
    Default = Config.OnlyPlayerMode,
    Callback = function(value)
      Config.OnlyPlayerMode = value
    end
  })

  MainBox:AddSlider("AimbotSmoothness", {
    Text = "Smoothness",
    Default = Config.Smoothness,
    Min = 0.05,
    Max = 1,
    Rounding = 2,
    Callback = function(value)
      Config.Smoothness = value
    end
  })

  MainBox:AddSlider("AimbotPredictionX", {
    Text = "Prediction",
    Default = Config.PredictionX,
    Min = 0,
    Max = 0.5,
    Rounding = 3,
    Callback = function(value)
      Config.PredictionX = value
    end
  })

  TargetBox:AddDropdown("AimbotAimPart", {
    Text = "Aim part",
    Values = {
      "Head",
      "UpperTorso",
      "HumanoidRootPart"
    },
    Default = Config.AimPart,
    Callback = function(value)
      Config.AimPart = value
    end
  })

  TargetBox:AddDropdown("AimbotAimMethod", {
    Text = "Aim method",
    Values = {
      "MouseLock",
      "Camera",
      "Snap"
    },
    Default = Config.AimMethod,
    Callback = function(value)
      Config.AimMethod = value
    end
  })

  TargetBox:AddDropdown("AimbotTargetPriority", {
    Text = "Target priority",
    Values = {
      "Closest to cursor",
      "Lowest health",
      "Closest distance"
    },
    Default = Config.TargetPriority,
    Callback = function(value)
      Config.TargetPriority = value
    end
  })

  TargetBox:AddDropdown("AimbotPlayer", {
    Text = "Player",
    SpecialType = "Player",
    ExcludeLocalPlayer = true,
    Callback = function(value)
      Config.Player = value
    end
  })

  ui.FovToggle = VisualsBox:AddToggle("AimbotFov", {
    Text = "FOV",
    Default = Config.Fov.Enabled,
    Callback = function(value)
      Config.Fov.Enabled = value
    end
  })

  ui.FovColor = ui.FovToggle:AddColorPicker("AimbotFovColor", {
    Default = Config.Fov.FovColor,
    Title = "FOV color",
    Transparency = Config.Fov.Transparency,
    Callback = function(value)
      Config.Fov.FovColor = value
      if self.Drawings.Fov then
        self.Drawings.Fov.Color = value
      end
    end
  })

  ui.FovColor:OnChanged(function()
    Config.Fov.FovColor = ui.FovColor.Value
    Config.Fov.Transparency = ui.FovColor.Transparency or 0

    if self.Drawings.Fov then
      self.Drawings.Fov.Color = ui.FovColor.Value
      self.Drawings.Fov.Transparency = 1 - Config.Fov.Transparency
    end
  end)

  VisualsBox:AddSlider("AimbotFovSize", {
    Text = "FOV size",
    Default = Config.Fov.FovSize,
    Min = 20,
    Max = 500,
    Rounding = 0,
    Callback = function(value)
      Config.Fov.FovSize = value
    end
  })

  ui.TargetToggle = VisualsBox:AddToggle("AimbotTargetIndicator", {
    Text = "Target indicator",
    Default = Config.TargetIndicator.Enabled,
    Callback = function(value)
      Config.TargetIndicator.Enabled = value
    end
  })

  ui.TargetColor = ui.TargetToggle:AddColorPicker("AimbotTargetColor", {
    Default = Config.TargetIndicator.Color,
    Title = "Target color",
    Transparency = Config.TargetIndicator.Transparency,
    Callback = function(value)
      Config.TargetIndicator.Color = value
      if self.Drawings.Target then
        self.Drawings.Target.Color = value
      end
    end
  })

  ui.TargetColor:OnChanged(function()
    Config.TargetIndicator.Color = ui.TargetColor.Value
    Config.TargetIndicator.Transparency = ui.TargetColor.Transparency or 0

    if self.Drawings.Target then
      self.Drawings.Target.Color = ui.TargetColor.Value
      self.Drawings.Target.Transparency = 1 - Config.TargetIndicator.Transparency
    end
  end)

  VisualsBox:AddSlider("AimbotTargetRadius", {
    Text = "Target radius",
    Default = Config.TargetIndicator.Radius,
    Min = 4,
    Max = 30,
    Rounding = 0,
    Callback = function(value)
      Config.TargetIndicator.Radius = value

      if self.Drawings.Target then
        self.Drawings.Target.Radius = value
      end
    end
  })

  self.UI = {
    Created = true,
    StatusLabel = ui.StatusLabel,
    TargetLabel = ui.TargetLabel,
    Enabled = ui.Enabled,
    FovToggle = ui.FovToggle,
    FovColor = ui.FovColor,
    TargetToggle = ui.TargetToggle,
    TargetColor = ui.TargetColor,
  }

  return self.UI
end

function Aimbot:Start()
  if self.Started or self.Destroyed then
    return
  end

  self.Started = true
  self:CreateDrawings()

  track(UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
      return
    end

    if keyMatches(input, Config.Keybind) then
      self.Holding = true
    end
  end))

  track(UserInputService.InputEnded:Connect(function(input)
    if keyMatches(input, Config.Keybind) then
      self.Holding = false
    end
  end))

  track(Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
    Camera = Workspace.CurrentCamera
  end))

  track(RunService.RenderStepped:Connect(function()
    if self.Destroyed then
      return
    end

    if not Camera then
      return
    end

    if self.Drawings.Fov then
      self.Drawings.Fov.Visible = Config.Fov.Enabled
      self.Drawings.Fov.Position = UserInputService:GetMouseLocation()
      self.Drawings.Fov.Radius = Config.Fov.FovSize
      self.Drawings.Fov.Color = Config.Fov.FovColor
      self.Drawings.Fov.Transparency = 1 - Config.Fov.Transparency
    end

    if not Config.Enabled then
      self.CurrentTarget = nil
      self.CurrentTargetPosition = nil

      if self.Drawings.Target then
        self.Drawings.Target.Visible = false
      end

      if self.UI.StatusLabel then
        self.UI.StatusLabel:SetText("Status: Disabled")
      end

      if self.UI.TargetLabel then
        self.UI.TargetLabel:SetText("Target: N/A")
      end

      return
    end

    if Config.HoldToActivate and not self.Holding then
      self.CurrentTarget = nil
      self.CurrentTargetPosition = nil

      if self.Drawings.Target then
        self.Drawings.Target.Visible = false
      end

      if self.UI.StatusLabel then
        self.UI.StatusLabel:SetText("Status: Waiting for key")
      end

      if self.UI.TargetLabel then
        self.UI.TargetLabel:SetText("Target: N/A")
      end

      return
    end

    local part, position, player = findTarget()

    processAim(part, position)

    if self.UI.StatusLabel then
      if part and player then
        self.UI.StatusLabel:SetText("Status: Aiming")
      else
        self.UI.StatusLabel:SetText("Status: Searching")
      end
    end

    if self.UI.TargetLabel then
      self.UI.TargetLabel:SetText(
        "Target: " .. (player and player.Name or "N/A")
      )
    end
  end))

  track(Players.PlayerRemoving:Connect(function(player)
    if Config.Player == player then
      Config.Player = ""
    end
  end))
end

function Aimbot:Stop()
  if not self.Started then
    return
  end

  self.Started = false
  self.Holding = false
  self.CurrentTarget = nil
  self.CurrentTargetPosition = nil

  for index, connection in ipairs(self.Connections) do
    safeCall(function()
      connection:Disconnect()
    end)

    self.Connections[index] = nil
  end

  if self.Drawings.Fov then
    self.Drawings.Fov.Visible = false
  end

  if self.Drawings.Target then
    self.Drawings.Target.Visible = false
  end
end

function Aimbot:Destroy()
  if self.Destroyed then
    return
  end

  self.Destroyed = true
  self:Stop()

  for key, drawing in pairs(self.Drawings) do
    removeDrawing(drawing)
    self.Drawings[key] = nil
  end

  if getgenv().AimbotController == self then
    getgenv().AimbotController = nil
  end

  if getgenv().DestroyAimbot then
    getgenv().DestroyAimbot = nil
  end
end

function Aimbot:SetConfig(values)
  if type(values) ~= "table" then
    return
  end

  Config = merge(Config, values)
  self.Config = Config

  getgenv().Aimbot = Config
  getgenv().AimbotSettings = Config
end

function Aimbot:GetTarget()
  return self.CurrentTarget
end

function Aimbot:GetTargetPlayer()
  if self.CurrentTarget then
    return Players:GetPlayerFromCharacter(self.CurrentTarget.Parent)
  end

  return nil
end

getgenv().AimbotController = Aimbot
getgenv().DestroyAimbot = function()
  Aimbot:Destroy()
end

Aimbot:Start()

return Aimbot
