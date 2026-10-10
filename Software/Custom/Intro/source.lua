local Services = setmetatable({}, {
  __index = function(self, name)
    local ok, service = pcall(function()
      return cloneref(game:GetService(name))
    end)
    if ok then
      rawset(self, name, service)
      return service
    end
  end,
})
local Players = Services.Players
local TweenService = Services.TweenService
local Lighting = Services.Lighting
local RunService = Services.RunService
local player = Players.LocalPlayer
local camera = workspace.CurrentCamera
local CONFIG = {
  Word = "INFINITYX",
  Subtitle = "VERSION 4.2A",
  Logo = "rbxassetid://92308401887821",
  Messages = { "Preparing environment", "Loading components", "Almost ready" },
  ProgressDuration = 3.2,
  HoldDuration = 0.35,
  ParticleCount = 42,
}
local C = {
  Background = Color3.fromRGB(13, 12, 20),
  Surface = Color3.fromRGB(23, 21, 33),
  Accent = Color3.fromRGB(183, 155, 255),
  AccentSoft = Color3.fromRGB(139, 111, 204),
  Text = Color3.fromRGB(242, 240, 249),
  Muted = Color3.fromRGB(166, 162, 187),
  Line = Color3.fromRGB(112, 94, 148),
  White = Color3.new(1, 1, 1),
}
local function create(class, props, children)
  local object = Instance.new(class)
  local parent = props.Parent
  props.Parent = nil
  for key, value in pairs(props) do
    object[key] = value
  end
  if children then
    for _, child in ipairs(children) do
      child.Parent = object
    end
  end
  object.Parent = parent
  return object
end
local function corner(parent, radius)
  return create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = parent })
end
local function stroke(parent, color, thickness, transparency)
  return create("UIStroke", {
    Color = color,
    Thickness = thickness,
    Transparency = transparency,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = parent,
  })
end
local function animate(object, duration, properties, style, direction)
  local animation = TweenService:Create(object, TweenInfo.new(
    duration,
    style or Enum.EasingStyle.Quart,
    direction or Enum.EasingDirection.Out
  ), properties)
  animation:Play()
  return animation
end
local function textLabel(props)
  props.BackgroundTransparency = 1
  props.BorderSizePixel = 0
  return create("TextLabel", props)
end
local function getParent()
  local ok, result = pcall(function()
    return gethui and gethui()
  end)
  if ok and result then
    return result
  end
  return player:WaitForChild("PlayerGui")
end
local parentGui = getParent()
for _, name in ipairs({ "InfinityXIntro", "InfinityXIntroBlur", "InfinityXIntroCC" }) do
  local old = parentGui:FindFirstChild(name) or Lighting:FindFirstChild(name)
  if old then
    old:Destroy()
  end
end
local blur = create("BlurEffect", { Name = "InfinityXIntroBlur", Size = 0, Parent = Lighting })
local colorCorrection = create("ColorCorrectionEffect", {
  Name = "InfinityXIntroCC",
  Saturation = -0.08,
  Contrast = 0.03,
  TintColor = Color3.fromRGB(239, 233, 255),
  Parent = Lighting,
})
animate(blur, 0.7, { Size = 12 }, Enum.EasingStyle.Quad)
local gui = create("ScreenGui", {
  Name = "InfinityXIntro",
  IgnoreGuiInset = true,
  ResetOnSpawn = false,
  DisplayOrder = 1000,
  ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
  Parent = parentGui,
})
local background = create("Frame", {
  Name = "Background",
  Size = UDim2.fromScale(1, 1),
  BackgroundColor3 = C.Background,
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 1,
  Parent = gui,
})
create("UIGradient", {
  Rotation = 24,
  Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(17, 17, 27)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(39, 29, 59)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(12, 12, 20)),
  }),
  Parent = background,
})
local vignette = create("Frame", {
  Size = UDim2.fromScale(1, 1),
  BackgroundColor3 = Color3.fromRGB(5, 5, 10),
  BackgroundTransparency = 0.58,
  BorderSizePixel = 0,
  ZIndex = 2,
  Parent = background,
})
create("UIGradient", {
  Rotation = 0,
  Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.45),
    NumberSequenceKeypoint.new(0.5, 1),
    NumberSequenceKeypoint.new(1, 0.45),
  }),
  Parent = vignette,
})
local glow = create("Frame", {
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.5, 0.48),
  Size = UDim2.fromOffset(560, 390),
  BackgroundColor3 = C.AccentSoft,
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 2,
  Parent = background,
})
corner(glow, 190)
local glowSecondary = create("Frame", {
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.22, 0.78),
  Size = UDim2.fromOffset(360, 260),
  BackgroundColor3 = Color3.fromRGB(91, 74, 154),
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 2,
  Parent = background,
})
corner(glowSecondary, 130)
create("UIGradient", {
  Rotation = 35,
  Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(0.5, 0.58),
    NumberSequenceKeypoint.new(1, 1),
  }),
  Parent = glowSecondary,
})
create("UIGradient", {
  Rotation = 90,
  Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0.02),
    NumberSequenceKeypoint.new(0.5, 0.25),
    NumberSequenceKeypoint.new(1, 1),
  }),
  Parent = glow,
})
local ambient = create("Frame", {
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.5, 0.5),
  Size = UDim2.fromScale(0.7, 0),
  BackgroundColor3 = C.Line,
  BackgroundTransparency = 0.86,
  BorderSizePixel = 0,
  ZIndex = 2,
  Parent = background,
})
local function makeParticle(index)
  local streak = math.random() < 0.22
  local width = streak and math.random(20, 62) or math.random(2, 4)
  local height = streak and 1 or width
  local particle = create("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(math.random(), math.random()),
    Size = UDim2.fromOffset(width, height),
    Rotation = streak and math.random(-22, 22) or 0,
    BackgroundColor3 = math.random() < 0.72 and C.Accent or (math.random() < 0.5 and Color3.fromRGB(224, 215, 255) or Color3.fromRGB(194, 180, 231)),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ZIndex = streak and 3 or 4,
    Parent = background,
  })
  if not streak then
    corner(particle, width)
  else
    create("UIGradient", {
      Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.18),
        NumberSequenceKeypoint.new(1, 1),
      }),
      Parent = particle,
    })
  end
  task.spawn(function()
    task.wait(math.random() * 1.8)
    while particle.Parent do
      local x = math.random(3, 97) / 100
      local y = math.random(5, 105) / 100
      local duration = math.random(55, 110) / 10
      local driftX = streak and math.random(-10, 10) / 100 or math.random(-4, 4) / 100
      local driftY = streak and math.random(-12, -5) / 100 or math.random(-22, -10) / 100
      particle.Position = UDim2.fromScale(x, y)
      particle.BackgroundTransparency = 1
      animate(particle, duration * 0.2, {
        BackgroundTransparency = streak and math.random(28, 48) / 100 or math.random(12, 38) / 100,
      }, Enum.EasingStyle.Sine)
      local drift = TweenService:Create(particle, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
        Position = UDim2.fromScale(math.clamp(x + driftX, 0, 1), math.clamp(y + driftY, -0.08, 1.08)),
      })
      drift:Play()
      task.wait(duration * 0.72)
      animate(particle, duration * 0.28, { BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)
      drift.Completed:Wait()
    end
  end)
  return particle
end
for i = 1, CONFIG.ParticleCount do
  makeParticle(i)
end
local frame = create("Frame", {
  Name = "IntroContent",
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.5, 0.51),
  Size = UDim2.fromOffset(560, 280),
  BackgroundTransparency = 1,
  ZIndex = 5,
  Parent = background,
})
local contentScale = create("UIScale", { Scale = 1, Parent = frame })
local function updateScale()
  local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
  contentScale.Scale = math.clamp(math.min(viewport.X / 900, viewport.Y / 650), 0.62, 1.05)
end
updateScale()
local scaleConnection
if camera then
  scaleConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateScale)
end
local topLabel = textLabel({
  Position = UDim2.fromOffset(2, 6),
  Size = UDim2.new(1, 0, 0, 15),
  Font = Enum.Font.GothamMedium,
  Text = "INDEPENDENT SOFTWARE  /  ROBLOX",
  TextSize = 10,
  TextColor3 = C.Muted,
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Left,
  ZIndex = 7,
  Parent = frame,
})
local logoPanel = create("Frame", {
  Position = UDim2.fromOffset(0, 42),
  Size = UDim2.fromOffset(112, 112),
  BackgroundColor3 = C.Surface,
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 7,
  Parent = frame,
})
corner(logoPanel, 26)
local panelStroke = stroke(logoPanel, C.Accent, 1, 1)
create("UIGradient", {
  Rotation = 135,
  Color = ColorSequence.new(Color3.fromRGB(29, 24, 43), Color3.fromRGB(12, 13, 19)),
  Parent = logoPanel,
})
local logoImage = create("ImageLabel", {
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromScale(0.5, 0.5),
  Size = UDim2.fromOffset(76, 76),
  BackgroundTransparency = 1,
  Image = CONFIG.Logo,
  ImageTransparency = 1,
  ScaleType = Enum.ScaleType.Fit,
  ZIndex = 9,
  Parent = logoPanel,
})
local logoScale = create("UIScale", { Scale = 0.78, Parent = logoImage })
local logoHalo = create("Frame", {
  AnchorPoint = Vector2.new(0.5, 0.5),
  Position = UDim2.fromOffset(56, 98),
  Size = UDim2.fromOffset(150, 150),
  BackgroundColor3 = C.Accent,
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 4,
  Parent = frame,
})
corner(logoHalo, 75)
local verticalLine = create("Frame", {
  Position = UDim2.fromOffset(137, 51),
  Size = UDim2.fromOffset(1, 94),
  BackgroundColor3 = C.Line,
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 8,
  Parent = frame,
})
local eyebrow = textLabel({
  Position = UDim2.fromOffset(162, 44),
  Size = UDim2.new(1, -162, 0, 18),
  Font = Enum.Font.GothamMedium,
  Text = "INFINITYX  /  CLIENT",
  TextSize = 11,
  TextColor3 = C.Accent,
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Left,
  ZIndex = 8,
  Parent = frame,
})
local word = textLabel({
  Position = UDim2.fromOffset(158, 62),
  Size = UDim2.new(1, -158, 0, 54),
  Font = Enum.Font.GothamBold,
  Text = CONFIG.Word,
  TextSize = 43,
  TextColor3 = C.Text,
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Left,
  ZIndex = 8,
  Parent = frame,
})
create("UIGradient", {
  Rotation = 0,
  Color = ColorSequence.new(Color3.fromRGB(250, 248, 255), Color3.fromRGB(184, 169, 220)),
  Parent = word,
})
local subtitle = textLabel({
  Position = UDim2.fromOffset(161, 112),
  Size = UDim2.new(1, -161, 0, 20),
  Font = Enum.Font.Gotham,
  Text = CONFIG.Subtitle .. "   •   STABLE RELEASE",
  TextSize = 11,
  TextColor3 = C.Muted,
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Left,
  ZIndex = 8,
  Parent = frame,
})
local divider = create("Frame", {
  Position = UDim2.fromOffset(0, 181),
  Size = UDim2.new(1, 0, 0, 1),
  BackgroundColor3 = C.Line,
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 7,
  Parent = frame,
})
local status = textLabel({
  Position = UDim2.fromOffset(0, 199),
  Size = UDim2.new(1, -100, 0, 18),
  Font = Enum.Font.Gotham,
  Text = CONFIG.Messages[1],
  TextSize = 11,
  TextColor3 = C.Muted,
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Left,
  ZIndex = 8,
  Parent = frame,
})
local percent = textLabel({
  AnchorPoint = Vector2.new(1, 0),
  Position = UDim2.new(1, 0, 0, 199),
  Size = UDim2.fromOffset(70, 18),
  Font = Enum.Font.GothamMedium,
  Text = "0%",
  TextSize = 11,
  TextColor3 = C.Text,
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Right,
  ZIndex = 8,
  Parent = frame,
})
local track = create("Frame", {
  Position = UDim2.fromOffset(0, 226),
  Size = UDim2.new(1, 0, 0, 3),
  BackgroundColor3 = Color3.fromRGB(37, 35, 47),
  BackgroundTransparency = 1,
  BorderSizePixel = 0,
  ZIndex = 8,
  Parent = frame,
})
corner(track, 2)
local fill = create("Frame", {
  Size = UDim2.new(0, 0, 1, 0),
  BackgroundColor3 = C.Accent,
  BorderSizePixel = 0,
  ZIndex = 9,
  Parent = track,
})
corner(fill, 2)
create("UIGradient", {
  Color = ColorSequence.new(Color3.fromRGB(196, 178, 244), C.AccentSoft),
  Parent = fill,
})
local footer = textLabel({
  Position = UDim2.fromOffset(0, 248),
  Size = UDim2.new(1, 0, 0, 16),
  Font = Enum.Font.Gotham,
  Text = "INITIALIZING  •  PLEASE WAIT",
  TextSize = 9,
  TextColor3 = Color3.fromRGB(128, 123, 151),
  TextTransparency = 1,
  TextXAlignment = Enum.TextXAlignment.Left,
  ZIndex = 8,
  Parent = frame,
})
animate(background, 0.65, { BackgroundTransparency = 0 })
animate(glow, 1.2, { BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)
animate(glowSecondary, 1.4, { BackgroundTransparency = 1 }, Enum.EasingStyle.Sine)
animate(ambient, 1, { Size = UDim2.new(0.7, 0, 0, 1) }, Enum.EasingStyle.Quad)
task.wait(0.18)
animate(topLabel, 0.45, { TextTransparency = 0 })
animate(logoPanel, 0.65, { BackgroundTransparency = 0 }, Enum.EasingStyle.Quart)
animate(panelStroke, 0.8, { Transparency = 0.45 })
animate(logoImage, 0.65, { ImageTransparency = 0 })
animate(logoScale, 0.7, { Scale = 1 }, Enum.EasingStyle.Quart)
animate(logoHalo, 0.9, { BackgroundTransparency = 0.89 }, Enum.EasingStyle.Sine)
animate(verticalLine, 0.55, { BackgroundTransparency = 0.35 })
task.wait(0.12)
animate(eyebrow, 0.5, { TextTransparency = 0 })
animate(word, 0.65, { TextTransparency = 0, Position = UDim2.fromOffset(158, 62) }, Enum.EasingStyle.Quart)
animate(subtitle, 0.65, { TextTransparency = 0 })
task.wait(0.35)
animate(divider, 0.5, { BackgroundTransparency = 0.55 })
animate(status, 0.35, { TextTransparency = 0 })
animate(percent, 0.35, { TextTransparency = 0 })
animate(track, 0.4, { BackgroundTransparency = 0 })
animate(footer, 0.4, { TextTransparency = 0 })
local progressStart = os.clock()
local messageIndex = 1
local lastMessage = 0
local progressConnection
progressConnection = RunService.RenderStepped:Connect(function()
  if not gui.Parent then
    progressConnection:Disconnect()
    return
  end
  local alpha = math.clamp((os.clock() - progressStart) / CONFIG.ProgressDuration, 0, 1)
  fill.Size = UDim2.new(alpha, 0, 1, 0)
  percent.Text = tostring(math.floor(alpha * 100 + 0.5)) .. "%"
  local nextIndex = math.min(#CONFIG.Messages, math.floor(alpha * #CONFIG.Messages) + 1)
  if nextIndex ~= messageIndex and os.clock() - lastMessage > 0.25 then
    messageIndex = nextIndex
    lastMessage = os.clock()
    animate(status, 0.12, { TextTransparency = 1 })
    task.delay(0.13, function()
      if status.Parent then
        status.Text = CONFIG.Messages[messageIndex]
        animate(status, 0.2, { TextTransparency = 0 })
      end
    end)
  end
end)
task.wait(CONFIG.ProgressDuration + CONFIG.HoldDuration)
if progressConnection then
  progressConnection:Disconnect()
end
animate(frame, 0.45, { Position = UDim2.fromScale(0.5, 0.48) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
for _, object in ipairs({ topLabel, eyebrow, word, subtitle, status, percent, footer }) do
  animate(object, 0.35, { TextTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
end
for _, object in ipairs({ logoPanel, verticalLine, divider, track, fill, logoHalo, glow, glowSecondary, ambient }) do
  if object:IsA("Frame") then
    animate(object, 0.4, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
  end
end
animate(logoImage, 0.35, { ImageTransparency = 1 })
animate(blur, 0.55, { Size = 0 }, Enum.EasingStyle.Quad)
animate(colorCorrection, 0.55, { Saturation = 0, Contrast = 0, TintColor = Color3.new(1, 1, 1) }, Enum.EasingStyle.Quad)
animate(background, 0.55, { BackgroundTransparency = 1 }, Enum.EasingStyle.Quad)
task.wait(0.6)
if scaleConnection then
  scaleConnection:Disconnect()
end
if blur.Parent then
  blur:Destroy()
end
if colorCorrection.Parent then
  colorCorrection:Destroy()
end
if gui.Parent then
  gui:Destroy()
end
