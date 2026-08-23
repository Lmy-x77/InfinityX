-- Credits by: InfernusScripts/Null-Fire
-- Modified ESP Library by lmy77

local function getGlobalTable()
  return typeof(getfenv().getgenv) == "function"
    and typeof(getfenv().getgenv()) == "table"
    and getfenv().getgenv()
    or _G
end

if getGlobalTable().ESPLib then
  return getGlobalTable().ESPLib
end

local RunService = game:GetService("RunService")

local ESPChange = Instance.new("BindableEvent")

local espLib

espLib = {
  ESPValues = setmetatable({}, {
    __index = function(_, name)
      if typeof(espLib.Values) ~= "table" then
        espLib.Values = {}
      end

      return espLib.Values[name] == true
    end,

    __newindex = function(_, name, value)
      if typeof(espLib.Values) ~= "table" then
        espLib.Values = {}
      end

      value = value == true

      if espLib.Values[name] == value then
        return
      end

      espLib.Values[name] = value
      ESPChange:Fire()
    end
  }),

  Values = {},
  ESPApplied = {}
}

local connections = {}
local speed = 24

local function GetRGBValue()
  return Color3.new(
    math.sin(os.clock() * speed) * 0.5 + 0.5,
    math.sin(os.clock() * speed + 2.094) * 0.5 + 0.5,
    math.sin(os.clock() * speed + 4.188) * 0.5 + 0.5
  )
end

local function DisconnectAll(obj)
  if connections[obj] then
    for _, connection in pairs(connections[obj]) do
      if connection and typeof(connection) == "RBXScriptConnection" then
        connection:Disconnect()
      end
    end
  end

  connections[obj] = nil
end

local function GetTextOffset(textPos)
  textPos = string.lower(tostring(textPos or "below"))

  if textPos == "above" then
    return Vector3.new(0, 3.5, 0)
  end

  if textPos == "center" then
    return Vector3.new(0, 0, 0)
  end

  return Vector3.new(0, -3.5, 0)
end

local function NormalizeObject(obj)
  if not obj then
    return nil
  end

  if obj:IsA("Model") then
    return obj
  end

  return obj:FindFirstAncestorOfClass("Model") or obj
end

local function RemoveESPFolder(obj)
  if not obj then
    return
  end

  local folder = obj:FindFirstChild("ESPFolder")

  if folder then
    folder:Destroy()
  end
end

local function RemoveFromApplied(obj)
  local index = table.find(espLib.ESPApplied, obj)

  if index then
    table.remove(espLib.ESPApplied, index)
  end
end

local function AddToApplied(obj)
  if not table.find(espLib.ESPApplied, obj) then
    table.insert(espLib.ESPApplied, obj)
  end
end

local function applyESP(obj, settings)
  obj = NormalizeObject(obj)

  if not obj then
    return
  end

  settings = settings or {}

  local espName = settings.ESPName or ""
  local text = settings.Text or obj.Name
  local textPos = settings.TextPos or "Below"

  local highlightEnabled = settings.HighlightEnabled
  if highlightEnabled == nil then
    highlightEnabled = true
  end

  local circleVisible = settings.CircleVisible
  if circleVisible == nil then
    circleVisible = true
  end

  local color = settings.Color or Color3.new(1, 1, 1)

  -- Remove ESP antigo
  DisconnectAll(obj)
  RemoveESPFolder(obj)
  RemoveFromApplied(obj)

  AddToApplied(obj)

  local folder = Instance.new("Folder")
  folder.Name = "ESPFolder"
  folder.Parent = obj

  --
  -- Highlight
  --

  if highlightEnabled then
    local highlight = Instance.new("Highlight")

    highlight.Name = "Highlight"
    highlight.Adornee = obj
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    highlight.FillColor = color
    highlight.OutlineColor = color

    highlight.FillTransparency = 0.8
    highlight.OutlineTransparency = 0.5

    highlight.Enabled = espLib.ESPValues[espName]
    highlight.Parent = folder
  end

  --
  -- Billboard
  --

  local billboard = Instance.new("BillboardGui")

  billboard.Name = "BillboardGui"
  billboard.Adornee = settings.Object or obj

  billboard.AlwaysOnTop = true
  billboard.ClipsDescendants = false

  billboard.Size = UDim2.fromOffset(200, 50)
  billboard.MaxDistance = math.huge

  billboard.StudsOffset = GetTextOffset(textPos)

  billboard.Enabled = espLib.ESPValues[espName]
  billboard.Parent = folder

  --
  -- Circle
  --

  local circle = Instance.new("Frame")

  circle.Name = "Circle"

  circle.AnchorPoint = Vector2.new(0.5, 0.5)
  circle.Position = UDim2.fromScale(0.5, 0.5)

  circle.Size = UDim2.fromOffset(10, 10)

  circle.BackgroundColor3 = color
  circle.BorderSizePixel = 0

  circle.Visible = circleVisible
  circle.Parent = billboard

  local corner = Instance.new("UICorner")
  corner.CornerRadius = UDim.new(1, 0)
  corner.Parent = circle

  local gradient = Instance.new("UIGradient")

  gradient.Rotation = 90

  gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
    ColorSequenceKeypoint.new(1, Color3.new(0.5, 0.5, 0.5))
  })

  gradient.Parent = circle

  local circleStroke = Instance.new("UIStroke")

  circleStroke.Thickness = 2.5
  circleStroke.Parent = circle

  --
  -- Text
  --

  local label = Instance.new("TextLabel")

  label.Name = "TextLabel"

  label.BackgroundTransparency = 1

  label.Size = UDim2.fromScale(1, 1)
  label.Position = UDim2.fromScale(0, 0)

  label.Text = text

  label.TextColor3 = color

  label.Font = Enum.Font.Code

  label.TextSize = 14
  label.TextScaled = false

  label.TextStrokeTransparency = 0
  label.TextStrokeColor3 = Color3.new(0, 0, 0)

  label.RichText = true

  label.TextXAlignment = Enum.TextXAlignment.Center
  label.TextYAlignment = Enum.TextYAlignment.Center

  label.Visible = true
  label.Parent = billboard

  --
  -- Connections
  --

  connections[obj] = {}

  local function UpdateEnabled()
    if not obj or not obj.Parent then
      return
    end

    local enabled = espLib.ESPValues[espName]

    local currentHighlight = folder:FindFirstChild("Highlight")

    if currentHighlight then
      currentHighlight.Enabled = enabled
    end

    billboard.Enabled = enabled
  end

  local function UpdateColor()
    if not obj or not obj.Parent then
      return
    end

    local currentColor = color

    if espLib.ESPValues.RGBESP then
      currentColor = GetRGBValue()
    end

    local currentHighlight = folder:FindFirstChild("Highlight")

    if currentHighlight then
      currentHighlight.FillColor = currentColor
      currentHighlight.OutlineColor = currentColor
    end

    circle.BackgroundColor3 = currentColor
    label.TextColor3 = currentColor
  end

  connections[obj].change = ESPChange.Event:Connect(function()
    UpdateEnabled()
  end)

  connections[obj].destroying = obj.Destroying:Connect(function()
    DisconnectAll(obj)
    RemoveFromApplied(obj)
  end)

  connections[obj].rgb = RunService.RenderStepped:Connect(function()
    if espLib.ESPValues.RGBESP then
      UpdateColor()
    end
  end)

  UpdateEnabled()
  UpdateColor()
end

local function deapplyESP(obj)
  obj = NormalizeObject(obj)

  if not obj then
    return
  end

  DisconnectAll(obj)
  RemoveESPFolder(obj)
  RemoveFromApplied(obj)
end

espLib.ApplyESP = applyESP
espLib.DeapplyESP = deapplyESP

getGlobalTable().ESPLib = espLib

return espLib
