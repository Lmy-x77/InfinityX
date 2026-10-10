local Services = setmetatable({}, {
  __index = function(self, name)
    local ok, service = pcall(function()
      return cloneref(game:GetService(name))
    end)
    if ok then
      rawset(self, name, service)
      return service
    end
    error("Invalid Service: " .. tostring(name))
  end,
})

local Players = Services.Players
local TweenService = Services.TweenService
local RunService = Services.RunService
local Lighting = Services.Lighting
local CoreGui = Services.CoreGui
local MarketplaceService = Services.MarketplaceService

local CONFIG = {
  Title = "Game Not Supported",
  Subtitle = "INFINITYX",
  Description = "InfinityX doesn't support this game yet. Join our <font color=\"#D4C2FF\"><b>Discord</b></font> to request support and be notified as soon as it's available.",
  Logo = "rbxassetid://92308401887821",
  Discord = "https://discord.gg/emKJgWMHAr",
  NotifyLib = "https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Notify/source.lua",
}

local T = {
  Background = Color3.fromRGB(30, 23, 50),
  Surface = Color3.fromRGB(44, 33, 72),
  Accent = Color3.fromRGB(184, 158, 255),
  AccentSoft = Color3.fromRGB(216, 200, 255),
  Text = Color3.fromRGB(248, 245, 255),
  Muted = Color3.fromRGB(176, 165, 207),
  Line = Color3.fromRGB(135, 112, 196),
  Danger = Color3.fromRGB(239, 104, 117),
  Success = Color3.fromRGB(109, 196, 138),
  White = Color3.new(1, 1, 1),
}

local WIDTH, HEIGHT = 480, 332

local function new(class, props, children)
  local inst = Instance.new(class)
  local parent = props.Parent
  props.Parent = nil
  for key, value in pairs(props) do
    inst[key] = value
  end
  if children then
    for _, child in ipairs(children) do
      child.Parent = inst
    end
  end
  inst.Parent = parent
  return inst
end

local function addCorner(parent, radius)
  return new("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end

local function addStroke(parent, color, thickness, transparency)
  return new("UIStroke", {
    Color = color,
    Thickness = thickness,
    Transparency = transparency,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = parent,
  })
end

local function tween(object, duration, properties, style, direction)
  local animation = TweenService:Create(object, TweenInfo.new(
    duration,
    style or Enum.EasingStyle.Quart,
    direction or Enum.EasingDirection.Out
  ), properties)
  animation:Play()
  return animation
end

local function label(props)
  props.BackgroundTransparency = 1
  props.BorderSizePixel = 0
  props.ZIndex = props.ZIndex or 3
  return new("TextLabel", props)
end

local function getParent()
  local ok, result = pcall(function()
    return gethui and gethui()
  end)
  if ok and result then
    return result
  end
  return CoreGui
end

local parentGui = getParent()
local old = parentGui:FindFirstChild("NotSupportedUI")
if old then
  old:Destroy()
end
local oldBlur = Lighting:FindFirstChild("InfinityXBlur")
if oldBlur then
  oldBlur:Destroy()
end

local gui = new("ScreenGui", {
  Name = "NotSupportedUI",
  IgnoreGuiInset = true,
  ResetOnSpawn = false,
  DisplayOrder = 999,
  ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
  Parent = parentGui,
})

local blur = new("BlurEffect", {
  Name = "InfinityXBlur",
  Size = 0,
  Parent = Lighting,
})

local overlay = new("Frame", {
  Name = "Overlay",
  Size = UDim2.fromScale(1, 1),
  BackgroundColor3 = Color3.fromRGB(24, 17, 44),
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 0,
  Parent = gui,
})
new("UIGradient", {
  Rotation = 28,
  Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(86, 62, 142)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(110, 80, 176)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(58, 40, 104)),
  }),
  Parent = overlay,
})

local stars = {}
for i = 1, 34 do
  local streak = math.random() < 0.16
  local size = streak and math.random(16, 34) or math.random(2, 3)
  local star = new("Frame", {
    Name = "Star",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(math.random(), math.random()),
    Size = UDim2.fromOffset(size, streak and 1 or size),
    Rotation = streak and math.random(-18, 18) or 0,
    BackgroundColor3 = math.random() < 0.7 and T.AccentSoft or T.White,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = gui,
  })
  addCorner(star, size)
  table.insert(stars, { Object = star, Streak = streak })
end

local root = new("Frame", {
  Name = "Root",
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.5, 0.5),
  Size = UDim2.fromOffset(WIDTH, HEIGHT),
  BackgroundTransparency = 1,
  ZIndex = 2,
  Parent = gui,
})
local rootScale = new("UIScale", { Scale = 0.92, Parent = root })

local card = new("CanvasGroup", {
  Name = "Card",
  Size = UDim2.fromScale(1, 1),
  BackgroundTransparency = 1,
  GroupTransparency = 1,
  ZIndex = 2,
  Parent = root,
})
addCorner(card, 16)

local bg = new("Frame", {
  Name = "Background",
  Size = UDim2.fromScale(1, 1),
  BackgroundColor3 = T.Background,
  BorderSizePixel = 0,
  ZIndex = 1,
  Parent = card,
})
addCorner(bg, 16)
new("UIGradient", {
  Rotation = 125,
  Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(78, 58, 124)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(52, 38, 88)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 28, 66)),
  }),
  Parent = bg,
})

local sheen = new("Frame", {
  Name = "Sheen",
  Size = UDim2.new(1, 0, 0, 84),
  BackgroundColor3 = T.White,
  BackgroundTransparency = 0.94,
  BorderSizePixel = 0,
  ZIndex = 2,
  Parent = card,
})
addCorner(sheen, 16)
new("UIGradient", {
  Rotation = 90,
  Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.7),
    NumberSequenceKeypoint.new(1, 1),
  }),
  Parent = sheen,
})

new("ImageLabel", {
  Name = "Watermark",
  AnchorPoint = Vector2.new(1, 1),
  Position = UDim2.new(1, 30, 1, 35),
  Size = UDim2.fromOffset(220, 220),
  BackgroundTransparency = 1,
  Image = CONFIG.Logo,
  ImageTransparency = 0.96,
  Rotation = -14,
  ScaleType = Enum.ScaleType.Fit,
  ZIndex = 2,
  Parent = card,
})

local border = new("Frame", {
  Name = "Border",
  Size = UDim2.fromScale(1, 1),
  BackgroundTransparency = 1,
  ZIndex = 8,
  Parent = root,
})
addCorner(border, 16)
local borderStroke = addStroke(border, T.Line, 1, 0.3)

local accent = new("Frame", {
  Name = "TopAccent",
  Size = UDim2.new(1, 0, 0, 2),
  BackgroundColor3 = T.Accent,
  BorderSizePixel = 0,
  ZIndex = 5,
  Parent = card,
})
new("UIGradient", {
  Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(122, 92, 200)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(226, 208, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(122, 92, 200)),
  }),
  Parent = accent,
})

-- Anéis pulsantes atrás da logo
local pulseRings = {}
for i = 1, 2 do
  local ring = new("Frame", {
    Name = "LogoRing" .. i,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(52, 52),
    Size = UDim2.fromOffset(56, 56),
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = card,
  })
  addCorner(ring, 14)
  local ringStroke = addStroke(ring, T.Accent, 1.5, 0.35)
  local ringScale = new("UIScale", { Scale = 1, Parent = ring })
  table.insert(pulseRings, { Scale = ringScale, Stroke = ringStroke, Delay = (i - 1) * 1.1 })
end

local logoChip = new("Frame", {
  Name = "LogoChip",
  Position = UDim2.fromOffset(24, 24),
  Size = UDim2.fromOffset(56, 56),
  BackgroundColor3 = T.Surface,
  BorderSizePixel = 0,
  ZIndex = 4,
  Parent = card,
})
addCorner(logoChip, 14)
new("UIGradient", {
  Rotation = 135,
  Color = ColorSequence.new(Color3.fromRGB(74, 54, 122), Color3.fromRGB(34, 24, 58)),
  Parent = logoChip,
})
addStroke(logoChip, T.Line, 1, 0.3)

local logo = new("ImageLabel", {
  Name = "Logo",
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.5, 0.5),
  Size = UDim2.fromOffset(36, 36),
  BackgroundTransparency = 1,
  Image = CONFIG.Logo,
  ScaleType = Enum.ScaleType.Fit,
  ZIndex = 5,
  Parent = logoChip,
})
local logoScale = new("UIScale", { Scale = 1, Parent = logo })
TweenService:Create(
  logoScale,
  TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
  { Scale = 1.08 }
):Play()

for _, ringData in ipairs(pulseRings) do
  task.delay(ringData.Delay, function()
    if not gui.Parent then
      return
    end
    local info = TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1)
    TweenService:Create(ringData.Scale, info, { Scale = 1.5 }):Play()
    TweenService:Create(ringData.Stroke, info, { Transparency = 1 }):Play()
  end)
end

label({
  Name = "Title",
  Position = UDim2.fromOffset(96, 27),
  Size = UDim2.new(1, -152, 0, 24),
  Text = CONFIG.Title,
  Font = Enum.Font.GothamBold,
  TextSize = 20,
  TextXAlignment = Enum.TextXAlignment.Left,
  TextColor3 = T.Text,
  Parent = card,
})

label({
  Name = "Subtitle",
  Position = UDim2.fromOffset(96, 53),
  Size = UDim2.new(1, -152, 0, 14),
  Text = CONFIG.Subtitle,
  Font = Enum.Font.GothamMedium,
  TextSize = 11,
  TextXAlignment = Enum.TextXAlignment.Left,
  TextColor3 = T.AccentSoft,
  Parent = card,
})

local closeBtn = new("TextButton", {
  Name = "Close",
  AnchorPoint = Vector2.new(1, 0),
  Position = UDim2.new(1, -16, 0, 16),
  Size = UDim2.fromOffset(28, 28),
  BackgroundColor3 = T.White,
  BackgroundTransparency = 1,
  AutoButtonColor = false,
  Text = "",
  BorderSizePixel = 0,
  ZIndex = 6,
  Parent = card,
})
addCorner(closeBtn, 8)

local closeBars = {}
for _, rotation in ipairs({ 45, -45 }) do
  local bar = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(12, 2),
    Rotation = rotation,
    BackgroundColor3 = T.Muted,
    BorderSizePixel = 0,
    ZIndex = 7,
    Parent = closeBtn,
  })
  addCorner(bar, 1)
  table.insert(closeBars, bar)
end

closeBtn.MouseEnter:Connect(function()
  tween(closeBtn, 0.15, { BackgroundTransparency = 0.9 })
  for _, bar in ipairs(closeBars) do
    tween(bar, 0.15, { BackgroundColor3 = T.White })
  end
end)
closeBtn.MouseLeave:Connect(function()
  tween(closeBtn, 0.15, { BackgroundTransparency = 1 })
  for _, bar in ipairs(closeBars) do
    tween(bar, 0.15, { BackgroundColor3 = T.Muted })
  end
end)

local divider = new("Frame", {
  Name = "Divider",
  Position = UDim2.fromOffset(24, 96),
  Size = UDim2.new(1, -48, 0, 1),
  BackgroundColor3 = T.Line,
  BackgroundTransparency = 0.3,
  BorderSizePixel = 0,
  ZIndex = 3,
  Parent = card,
})
new("UIGradient", {
  Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.3),
    NumberSequenceKeypoint.new(1, 1),
  }),
  Parent = divider,
})

label({
  Name = "Description",
  Position = UDim2.fromOffset(24, 110),
  Size = UDim2.new(1, -48, 0, 40),
  Text = CONFIG.Description,
  RichText = true,
  Font = Enum.Font.Gotham,
  TextSize = 13,
  LineHeight = 1.15,
  TextWrapped = true,
  TextXAlignment = Enum.TextXAlignment.Left,
  TextYAlignment = Enum.TextYAlignment.Top,
  TextColor3 = Color3.fromRGB(206, 196, 230),
  Parent = card,
})

local function drawGameIcon(holder, color)
  new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(13, 13),
    Size = UDim2.fromOffset(15, 10),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = holder,
  }, {
    new("UICorner", { CornerRadius = UDim.new(0, 5) }),
    new("UIStroke", { Color = color, Thickness = 1.5 }),
  })
  for _, size in ipairs({ Vector2.new(5, 2), Vector2.new(2, 5) }) do
    local bar = new("Frame", {
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.fromOffset(9, 13),
      Size = UDim2.fromOffset(size.X, size.Y),
      BackgroundColor3 = color,
      BorderSizePixel = 0,
      ZIndex = 7,
      Parent = holder,
    })
    addCorner(bar, 1)
  end
  local dot = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(17, 13),
    Size = UDim2.fromOffset(3, 3),
    BackgroundColor3 = color,
    BorderSizePixel = 0,
    ZIndex = 7,
    Parent = holder,
  })
  addCorner(dot, 2)
end

local function drawUserIcon(holder, color)
  local head = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(13, 9),
    Size = UDim2.fromOffset(6, 6),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = holder,
  })
  addCorner(head, 3)
  addStroke(head, color, 1.5, 0)
  local body = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(13, 18),
    Size = UDim2.fromOffset(11, 5),
    BackgroundTransparency = 1,
    ZIndex = 6,
    Parent = holder,
  })
  addCorner(body, 4)
  addStroke(body, color, 1.5, 0)
end

local function textIcon(glyph)
  return function(holder, color)
    label({
      Size = UDim2.fromScale(1, 1),
      Text = glyph,
      Font = Enum.Font.GothamBold,
      TextSize = 12,
      TextColor3 = color,
      ZIndex = 6,
      Parent = holder,
    })
  end
end

local function makeTile(parent, options)
  local tile = new("Frame", {
    Name = options.Name,
    LayoutOrder = options.Order or 0,
    Position = options.Position or UDim2.new(),
    Size = options.Size,
    BackgroundColor3 = T.White,
    BackgroundTransparency = 0.94,
    BorderSizePixel = 0,
    ZIndex = 3,
    Parent = parent,
  })
  addCorner(tile, 9)
  local tileStroke = addStroke(tile, T.Line, 1, 0.6)

  local iconBox = new("Frame", {
    Position = UDim2.fromOffset(8, 8),
    Size = UDim2.fromOffset(26, 26),
    BackgroundColor3 = T.Accent,
    BackgroundTransparency = 0.82,
    BorderSizePixel = 0,
    ZIndex = 4,
    Parent = tile,
  })
  addCorner(iconBox, 8)
  addStroke(iconBox, T.Line, 1, 0.45)
  if options.Icon then
    options.Icon(iconBox, T.AccentSoft)
  end

  local rightPad = options.RightPad or 0
  label({
    Position = UDim2.fromOffset(44, 6),
    Size = UDim2.new(1, -(52 + rightPad), 0, 12),
    Text = options.Key,
    Font = Enum.Font.GothamMedium,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextColor3 = T.Muted,
    ZIndex = 4,
    Parent = tile,
  })
  local value = label({
    Position = UDim2.fromOffset(44, 20),
    Size = UDim2.new(1, -(52 + rightPad), 0, 16),
    Text = options.Value,
    Font = Enum.Font.GothamSemibold,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextColor3 = T.Text,
    ZIndex = 4,
    Parent = tile,
  })

  tile.MouseEnter:Connect(function()
    tween(tile, 0.18, { BackgroundTransparency = 0.89 })
    tween(tileStroke, 0.18, { Transparency = 0.35 })
  end)
  tile.MouseLeave:Connect(function()
    tween(tile, 0.18, { BackgroundTransparency = 0.94 })
    tween(tileStroke, 0.18, { Transparency = 0.6 })
  end)

  return tile, value
end

local gameTile, gameValue = makeTile(card, {
  Name = "GameTile",
  Position = UDim2.fromOffset(24, 158),
  Size = UDim2.new(1, -48, 0, 42),
  Key = "GAME",
  Value = "Loading...",
  Icon = drawGameIcon,
  RightPad = 118,
})

local statusPill = new("Frame", {
  Name = "StatusPill",
  AnchorPoint = Vector2.new(1, 0.5),
  Position = UDim2.new(1, -10, 0.5, 0),
  AutomaticSize = Enum.AutomaticSize.X,
  Size = UDim2.fromOffset(0, 24),
  BackgroundColor3 = T.Danger,
  BackgroundTransparency = 0.88,
  BorderSizePixel = 0,
  ZIndex = 4,
  Parent = gameTile,
})
addCorner(statusPill, 12)
addStroke(statusPill, T.Danger, 1, 0.65)
new("UIPadding", {
  PaddingLeft = UDim.new(0, 10),
  PaddingRight = UDim.new(0, 12),
  Parent = statusPill,
})
new("UIListLayout", {
  FillDirection = Enum.FillDirection.Horizontal,
  VerticalAlignment = Enum.VerticalAlignment.Center,
  SortOrder = Enum.SortOrder.LayoutOrder,
  Padding = UDim.new(0, 6),
  Parent = statusPill,
})

local statusDot = new("Frame", {
  LayoutOrder = 1,
  Size = UDim2.fromOffset(6, 6),
  BackgroundColor3 = T.Danger,
  BorderSizePixel = 0,
  ZIndex = 5,
  Parent = statusPill,
})
addCorner(statusDot, 3)
TweenService:Create(statusDot, TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
  BackgroundTransparency = 0.65,
}):Play()

label({
  LayoutOrder = 2,
  AutomaticSize = Enum.AutomaticSize.X,
  Size = UDim2.new(0, 0, 1, 0),
  Text = "UNSUPPORTED",
  Font = Enum.Font.GothamBold,
  TextSize = 10,
  TextColor3 = Color3.fromRGB(255, 175, 183),
  ZIndex = 5,
  Parent = statusPill,
})

local statRow = new("Frame", {
  Name = "Stats",
  Position = UDim2.fromOffset(24, 208),
  Size = UDim2.new(1, -48, 0, 42),
  BackgroundTransparency = 1,
  ZIndex = 3,
  Parent = card,
})
new("UIListLayout", {
  FillDirection = Enum.FillDirection.Horizontal,
  SortOrder = Enum.SortOrder.LayoutOrder,
  Padding = UDim.new(0, 8),
  Parent = statRow,
})

local tileSize = UDim2.new(1 / 3, -6, 0, 42)
makeTile(statRow, {
  Name = "PlaceIdTile",
  Order = 1,
  Size = tileSize,
  Key = "PLACE ID",
  Value = tostring(game.PlaceId),
  Icon = textIcon("#"),
})

local _, playersValue = makeTile(statRow, {
  Name = "PlayersTile",
  Order = 2,
  Size = tileSize,
  Key = "PLAYERS",
  Value = "-",
  Icon = drawUserIcon,
})

local executorName = "Unknown"
pcall(function()
  if identifyexecutor then
    executorName = tostring(identifyexecutor())
  end
end)

makeTile(statRow, {
  Name = "ExecutorTile",
  Order = 3,
  Size = tileSize,
  Key = "EXECUTOR",
  Value = executorName,
  Icon = textIcon("</>"),
})

task.spawn(function()
  local ok, info = pcall(function()
    return MarketplaceService:GetProductInfo(game.PlaceId)
  end)
  if gui.Parent then
    gameValue.Text = (ok and info and info.Name) or game.Name
  end
end)

task.spawn(function()
  while gui.Parent do
    playersValue.Text = #Players:GetPlayers() .. " / " .. Players.MaxPlayers
    task.wait(2)
  end
end)

local buttonRow = new("Frame", {
  Name = "Buttons",
  Position = UDim2.new(0, 24, 1, -62),
  Size = UDim2.new(1, -48, 0, 38),
  BackgroundTransparency = 1,
  ZIndex = 3,
  Parent = card,
})
new("UIListLayout", {
  FillDirection = Enum.FillDirection.Horizontal,
  HorizontalAlignment = Enum.HorizontalAlignment.Right,
  VerticalAlignment = Enum.VerticalAlignment.Center,
  SortOrder = Enum.SortOrder.LayoutOrder,
  Padding = UDim.new(0, 10),
  Parent = buttonRow,
})

local function clearIcon(holder)
  for _, child in ipairs(holder:GetChildren()) do
    child:Destroy()
  end
end

local function drawCopyIcon(holder, color, fillColor)
  clearIcon(holder)
  local back = new("Frame", {
    Position = UDim2.fromOffset(1, 1),
    Size = UDim2.fromOffset(9, 9),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = holder,
  })
  addCorner(back, 3)
  addStroke(back, color, 1.5, 0)
  local front = new("Frame", {
    Position = UDim2.fromOffset(6, 6),
    Size = UDim2.fromOffset(8, 8),
    BackgroundColor3 = fillColor,
    BorderSizePixel = 0,
    ZIndex = 6,
    Parent = holder,
  })
  addCorner(front, 3)
  addStroke(front, color, 1.5, 0)
end

local function drawCheckIcon(holder, color)
  clearIcon(holder)
  local function leg(x, y, width, rotation)
    local bar = new("Frame", {
      AnchorPoint = Vector2.new(0.5, 0.5),
      Position = UDim2.fromOffset(x, y),
      Size = UDim2.fromOffset(width, 2),
      Rotation = rotation,
      BackgroundColor3 = color,
      BorderSizePixel = 0,
      ZIndex = 6,
      Parent = holder,
    })
    addCorner(bar, 1)
  end
  leg(4, 10, 6, 45)
  leg(10, 8, 12, -47)
end

local function makeButton(order, width, text, primary)
  local button = new("TextButton", {
    Name = primary and "Primary" or "Secondary",
    LayoutOrder = order,
    Size = UDim2.fromOffset(width, 38),
    BackgroundColor3 = primary and T.Accent or T.White,
    BackgroundTransparency = primary and 0 or 0.94,
    AutoButtonColor = false,
    Text = "",
    BorderSizePixel = 0,
    ZIndex = 4,
    Parent = buttonRow,
  })
  addCorner(button, 9)
  local scale = new("UIScale", { Scale = 1, Parent = button })
  local buttonStroke = addStroke(button, primary and T.AccentSoft or T.Line, 1, primary and 0.45 or 0.5)

  local gradient
  if primary then
    gradient = new("UIGradient", {
      Rotation = 15,
      Color = ColorSequence.new(Color3.fromRGB(184, 154, 255), Color3.fromRGB(128, 94, 214)),
      Parent = button,
    })
  end

  local content = new("Frame", {
    Position = primary and UDim2.fromOffset(40, 0) or UDim2.fromOffset(0, 0),
    Size = primary and UDim2.new(1, -54, 1, 0) or UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ZIndex = 5,
    Parent = button,
  })
  new("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 8),
    Parent = content,
  })

  local icon = new("Frame", {
    Position = UDim2.fromOffset(16, 11),
    Size = UDim2.fromOffset(16, 16),
    BackgroundTransparency = 1,
    Visible = primary,
    ZIndex = 5,
    Parent = button,
  })

  local buttonLabel = label({
    LayoutOrder = 1,
    AutomaticSize = Enum.AutomaticSize.X,
    Size = UDim2.new(0, 0, 1, 0),
    Text = text,
    Font = Enum.Font.GothamSemibold,
    TextSize = 12,
    TextColor3 = primary and T.White or Color3.fromRGB(222, 213, 242),
    ZIndex = 5,
    Parent = content,
  })

  button.MouseEnter:Connect(function()
    tween(scale, 0.18, { Scale = 1.03 })
    if primary then
      tween(gradient, 0.3, { Rotation = 35 })
      tween(buttonStroke, 0.18, { Transparency = 0.2 })
    else
      tween(button, 0.18, { BackgroundTransparency = 0.88 })
      tween(buttonStroke, 0.18, { Transparency = 0.3 })
    end
  end)
  button.MouseLeave:Connect(function()
    tween(scale, 0.18, { Scale = 1 })
    if primary then
      tween(gradient, 0.3, { Rotation = 15 })
      tween(buttonStroke, 0.18, { Transparency = 0.45 })
    else
      tween(button, 0.18, { BackgroundTransparency = 0.94 })
      tween(buttonStroke, 0.18, { Transparency = 0.5 })
    end
  end)
  button.MouseButton1Down:Connect(function()
    tween(scale, 0.1, { Scale = 0.97 })
  end)
  button.MouseButton1Up:Connect(function()
    tween(scale, 0.12, { Scale = 1.03 })
  end)

  return { Button = button, Label = buttonLabel, Icon = icon, Gradient = gradient, Scale = scale }
end

local dismiss = makeButton(1, 104, "Dismiss", false)
local copyBtn = makeButton(2, 170, "Copy Discord Link", true)
drawCopyIcon(copyBtn.Icon, T.White, T.Accent)

local connections = {}
local startClock = os.clock()
table.insert(connections, RunService.RenderStepped:Connect(function()
  if not gui.Parent then
    return
  end
  local time = os.clock() - startClock
  accent.BackgroundTransparency = 0.04 + math.abs(math.sin(time * 0.6)) * 0.12
  for index, item in ipairs(stars) do
    local star = item.Object
    if star.Parent then
      local phase = time * (item.Streak and 0.65 or 0.9) + index
      star.BackgroundTransparency = 0.28 + (math.sin(phase) + 1) * 0.3
      if item.Streak then
        star.Position = UDim2.fromScale(
          (star.Position.X.Scale + 0.00008) % 1,
          star.Position.Y.Scale
        )
      end
    end
  end
end))

-- UI fixa: sem sistema de arrastar.

local closing = false
local function close()
  if closing then
    return
  end
  closing = true
  for _, connection in ipairs(connections) do
    connection:Disconnect()
  end
  tween(card, 0.28, { GroupTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
  tween(borderStroke, 0.28, { Transparency = 1 })
  tween(rootScale, 0.32, { Scale = 0.94 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
  tween(overlay, 0.32, { BackgroundTransparency = 1 })
  tween(blur, 0.32, { Size = 0 })
  for _, item in ipairs(stars) do
    tween(item.Object, 0.25, { BackgroundTransparency = 1 })
  end
  task.wait(0.36)
  if blur.Parent then
    blur:Destroy()
  end
  if gui.Parent then
    gui:Destroy()
  end
end

local copying = false
local function copyDiscord()
  if copying or closing then
    return
  end
  copying = true

  local ok = pcall(function()
    setclipboard(CONFIG.Discord)
  end)

  copyBtn.Label.Text = ok and "Copied!" or "Copy failed"
  drawCheckIcon(copyBtn.Icon, T.White)
  if copyBtn.Gradient then
    copyBtn.Gradient.Color = ColorSequence.new(
      ok and T.Success or T.Danger,
      ok and Color3.fromRGB(54, 145, 105) or Color3.fromRGB(170, 58, 72)
    )
  end
  tween(copyBtn.Scale, 0.12, { Scale = 1.06 }, Enum.EasingStyle.Back)
  task.delay(0.12, function()
    if copyBtn.Scale.Parent then
      tween(copyBtn.Scale, 0.2, { Scale = 1 })
    end
  end)

  task.spawn(function()
    local success, lib = pcall(function()
      return loadstring(game:HttpGet(CONFIG.NotifyLib, true))()
    end)
    if success and lib and lib.notify then
      pcall(lib.success, "Discord link copied to clipboard!")
    end
  end)

  task.wait(1.2)
  close()
end

-- Cometas ocasionais cruzando o fundo
local function spawnComet()
  local size = gui.AbsoluteSize
  if size.X <= 0 or size.Y <= 0 then
    return
  end

  local angle = math.rad(math.random(32, 52))
  local dirX = math.random() < 0.5 and 1 or -1
  local rotation = dirX == 1 and math.deg(angle) or (180 - math.deg(angle))
  local length = math.random(110, 190)

  local startX = dirX == 1 and math.random() * size.X * 0.8 or size.X - math.random() * size.X * 0.8
  local startY = -60
  local distance = (size.Y + 140) / math.sin(angle)
  local endX = startX + math.cos(angle) * distance * dirX
  local endY = startY + math.sin(angle) * distance

  local comet = new("Frame", {
    Name = "Comet",
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromOffset(startX, startY),
    Size = UDim2.fromOffset(length, 2),
    Rotation = rotation,
    BackgroundColor3 = T.AccentSoft,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = gui,
  })
  addCorner(comet, 1)
  new("UIGradient", {
    Transparency = NumberSequence.new({
      NumberSequenceKeypoint.new(0, 1),
      NumberSequenceKeypoint.new(0.7, 0.55),
      NumberSequenceKeypoint.new(1, 0),
    }),
    Parent = comet,
  })

  local head = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(1, 0, 0.5, 0),
    Size = UDim2.fromOffset(4, 4),
    BackgroundColor3 = T.White,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = comet,
  })
  addCorner(head, 2)

  local duration = 0.7 + math.random() * 0.4
  local flight = tween(comet, duration, { Position = UDim2.fromOffset(endX, endY) }, Enum.EasingStyle.Linear)
  flight.Completed:Connect(function()
    comet:Destroy()
  end)
end

task.spawn(function()
  task.wait(2)
  while gui.Parent and not closing do
    spawnComet()
    if math.random() < 0.25 then
      task.wait(0.25 + math.random() * 0.3)
      if gui.Parent and not closing then
        spawnComet()
      end
    end
    task.wait(3 + math.random() * 5)
  end
end)

tween(overlay, 0.5, { BackgroundTransparency = 0.72 })
tween(blur, 0.5, { Size = 18 })
tween(rootScale, 0.62, { Scale = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
tween(card, 0.48, { GroupTransparency = 0 })
tween(borderStroke, 0.55, { Transparency = 0.15 })
for index, item in ipairs(stars) do
  task.delay(index * 0.012, function()
    if item.Object.Parent then
      tween(item.Object, 0.6, { BackgroundTransparency = 0.3 + math.random() * 0.35 }, Enum.EasingStyle.Sine)
    end
  end)
end

copyBtn.Button.MouseButton1Click:Connect(copyDiscord)
dismiss.Button.MouseButton1Click:Connect(close)
closeBtn.MouseButton1Click:Connect(close)
