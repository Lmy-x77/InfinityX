Services = setmetatable({}, {
	__index = function(self, name)
		local success, cache = pcall(function()
			return cloneref(game:GetService(name))
		end)
		if success then
			rawset(self, name, cache)
			return cache
		else
			print("Invalid Service: " .. tostring(name))
		end
	end,
})

local Players = Services.Players
local TweenService = Services.TweenService
local Lighting = Services.Lighting

local player = Players.LocalPlayer
local camera = workspace.CurrentCamera

local CONFIG = {
	Word = "INFINITYX",
	Subtitle = "VERSION 4.2A",
	Logo = "rbxassetid://92308401887821",
	Messages = { "Initializing modules...", "Loading interface...", "Almost ready..." },
	LetterStagger = 0.045,
	WordHoldDuration = 0.85,
	ProgressDuration = 3.0,
	HoldDuration = 0.45,
	ReferenceWidth = 800,
	ReferenceHeight = 600,
	MinScale = 0.55,
	MaxScale = 1.15,
}

local T = {
	Background = Color3.fromRGB(12, 9, 19),
	Accent = Color3.fromRGB(140, 80, 255),
	Accent2 = Color3.fromRGB(236, 72, 153),
	Text = Color3.fromRGB(248, 245, 255),
	Muted = Color3.fromRGB(160, 150, 185),
	White = Color3.new(1, 1, 1),
}

local function new(class, props, children)
	local inst = Instance.new(class)
	local parent = props.Parent
	props.Parent = nil
	for k, v in pairs(props) do
		inst[k] = v
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

local function tween(obj, duration, props, style, direction)
	local t = TweenService:Create(
		obj,
		TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
end

local function label(props)
	props.BackgroundTransparency = 1
	props.BorderSizePixel = 0
	return new("TextLabel", props)
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
do
	local old = parentGui:FindFirstChild("InfinityXIntro")
	if old then
		old:Destroy()
	end
	local oldBlur = Lighting:FindFirstChild("InfinityXIntroBlur")
	if oldBlur then
		oldBlur:Destroy()
	end
	local oldCC = Lighting:FindFirstChild("InfinityXIntroCC")
	if oldCC then
		oldCC:Destroy()
	end
end

local blur = new("BlurEffect", { Name = "InfinityXIntroBlur", Size = 0, Parent = Lighting })

local colorCorrection = new("ColorCorrectionEffect", {
	Name = "InfinityXIntroCC",
	Saturation = 0,
	Contrast = 0,
	TintColor = Color3.new(1, 1, 1),
	Parent = Lighting,
})

tween(blur, 0.8, { Size = 26 }, Enum.EasingStyle.Quad)
tween(colorCorrection, 0.8, {
	Saturation = -0.05,
	Contrast = 0.04,
	TintColor = Color3.fromRGB(235, 225, 255),
}, Enum.EasingStyle.Quad)

local gui = new("ScreenGui", {
	Name = "InfinityXIntro",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 1000,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = parentGui,
})

local bg = new("Frame", {
	Name = "Background",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = T.Background,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 1,
	Parent = gui,
})

local bgGradient = new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 16, 48)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(70, 38, 120)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 12, 34)),
	}),
	Rotation = 0,
	Parent = bg,
})

task.spawn(function()
	while bg.Parent do
		local t = TweenService:Create(bgGradient, TweenInfo.new(8, Enum.EasingStyle.Linear), {
			Rotation = bgGradient.Rotation + 360,
		})
		t:Play()
		t.Completed:Wait()
	end
end)

new("Frame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(8, 6, 14),
	BackgroundTransparency = 0.35,
	BorderSizePixel = 0,
	ZIndex = 2,
	Parent = bg,
})

local function makeOrb(size, pos, color, driftTo, dur)
	local orb = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = pos,
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = color,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = bg,
	})
	addCorner(orb, size)
	tween(orb, 1.4, { BackgroundTransparency = 0.88 })

	task.spawn(function()
		while orb.Parent do
			local t = TweenService:Create(
				orb,
				TweenInfo.new(dur, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
				{ Position = driftTo }
			)
			t:Play()
			t.Completed:Wait()
			driftTo, pos = pos, driftTo
		end
	end)

	return orb
end

makeOrb(360, UDim2.fromScale(0.2, 0.28), T.Accent, UDim2.fromScale(0.26, 0.34), 6)
makeOrb(300, UDim2.fromScale(0.82, 0.7), T.Accent2, UDim2.fromScale(0.76, 0.64), 7)

local function makeBracket(cornerAnchor, xSign, ySign)
	local margin = 42
	local arm = 26
	local thick = 2

	local holder = new("Frame", {
		AnchorPoint = cornerAnchor,
		Position = UDim2.new(cornerAnchor.X, xSign * margin, cornerAnchor.Y, ySign * margin),
		Size = UDim2.fromOffset(arm, arm),
		BackgroundTransparency = 1,
		ZIndex = 3,
		Parent = bg,
	})

	local h = new("Frame", {
		Position = UDim2.new(cornerAnchor.X, 0, cornerAnchor.Y, 0),
		AnchorPoint = cornerAnchor,
		Size = UDim2.fromOffset(arm, thick),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = holder,
	})
	local v = new("Frame", {
		Position = UDim2.new(cornerAnchor.X, 0, cornerAnchor.Y, 0),
		AnchorPoint = cornerAnchor,
		Size = UDim2.fromOffset(thick, arm),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = holder,
	})

	tween(h, 0.7, { BackgroundTransparency = 0.55 })
	tween(v, 0.7, { BackgroundTransparency = 0.55 })

	return holder
end

makeBracket(Vector2.new(0, 0), 1, 1)
makeBracket(Vector2.new(1, 0), -1, 1)
makeBracket(Vector2.new(0, 1), 1, -1)
makeBracket(Vector2.new(1, 1), -1, -1)

local stack = new("Frame", {
	Name = "Stack",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.48),
	AutomaticSize = Enum.AutomaticSize.XY,
	Size = UDim2.fromOffset(0, 0),
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = bg,
})
new("UIListLayout", {
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 18),
	Parent = stack,
})

local stackScale = new("UIScale", { Scale = 1, Parent = stack })

local function updateStackScale()
	local vp = camera and camera.ViewportSize or Vector2.new(CONFIG.ReferenceWidth, CONFIG.ReferenceHeight)
	local factor = math.min(vp.X / CONFIG.ReferenceWidth, vp.Y / CONFIG.ReferenceHeight)
	stackScale.Scale = math.clamp(factor, CONFIG.MinScale, CONFIG.MaxScale)
end

updateStackScale()

local scaleConnection
if camera then
	scaleConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(updateStackScale)
end

local logoWrap = new("Frame", {
	LayoutOrder = 1,
	Size = UDim2.fromOffset(96, 96),
	BackgroundTransparency = 1,
	Parent = stack,
})

for i = 1, 3 do
	local size = 64 + i * 14
	local ring = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 5,
		Parent = logoWrap,
	})
	addCorner(ring, size / 2)
end

local logoChip = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(64, 64),
	BackgroundColor3 = Color3.fromRGB(255, 255, 255),
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = logoWrap,
})
addCorner(logoChip, 20)
new("UIGradient", {
	Rotation = 135,
	Color = ColorSequence.new(Color3.fromRGB(56, 34, 104), Color3.fromRGB(20, 13, 38)),
	Parent = logoChip,
})
local logoChipStroke = addStroke(logoChip, T.Accent, 1.5, 1)

local logoScale = new("UIScale", { Scale = 0.6, Parent = logoChip })
logoChip.BackgroundTransparency = 1

new("ImageLabel", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(38, 38),
	BackgroundTransparency = 1,
	Image = CONFIG.Logo,
	ImageTransparency = 1,
	ScaleType = Enum.ScaleType.Fit,
	ZIndex = 7,
	Parent = logoChip,
})
local logoImage = logoChip:FindFirstChildOfClass("ImageLabel")

local wordmark = new("Frame", {
	LayoutOrder = 2,
	Size = UDim2.fromOffset(0, 74),
	AutomaticSize = Enum.AutomaticSize.X,
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = stack,
})
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 1),
	Parent = wordmark,
})

local letters = {}
for i = 1, #CONFIG.Word do
	local char = CONFIG.Word:sub(i, i)

	local letterLabel = label({
		LayoutOrder = i,
		Size = UDim2.fromOffset(40, 74),
		Text = char,
		Font = Enum.Font.GothamBold,
		TextSize = 52,
		TextColor3 = T.White,
		TextTransparency = 1,
		TextStrokeTransparency = 1,
		TextStrokeColor3 = T.Accent,
		ZIndex = 6,
		Parent = wordmark,
	})
	new("UIGradient", {
		Rotation = 90,
		Color = ColorSequence.new(Color3.fromRGB(225, 205, 255), Color3.fromRGB(175, 130, 255)),
		Parent = letterLabel,
	})
	new("UIScale", { Scale = 0.5, Parent = letterLabel })

	table.insert(letters, letterLabel)
end

local underline = new("Frame", {
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 1, -6),
	Size = UDim2.new(0, 0, 0, 2),
	BackgroundColor3 = T.White,
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = wordmark,
})
new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Accent),
		ColorSequenceKeypoint.new(0.5, T.Accent2),
		ColorSequenceKeypoint.new(1, T.Accent),
	}),
	Parent = underline,
})

local subtitlePill = new("Frame", {
	LayoutOrder = 3,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromOffset(0, 26),
	BackgroundColor3 = T.Accent,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = stack,
})
addCorner(subtitlePill, 13)
local subtitleStroke = addStroke(subtitlePill, T.Accent, 1, 1)
local subtitleScale = new("UIScale", { Scale = 0.7, Parent = subtitlePill })
new("UIPadding", { PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14), Parent = subtitlePill })
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 7),
	Parent = subtitlePill,
})

local subtitleLabel = label({
	LayoutOrder = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.new(0, 0, 1, 0),
	Text = CONFIG.Subtitle,
	Font = Enum.Font.GothamMedium,
	TextSize = 12,
	TextColor3 = T.Muted,
	TextTransparency = 1,
	ZIndex = 6,
	Parent = subtitlePill,
})

local progressGroup = new("Frame", {
	LayoutOrder = 4,
	Size = UDim2.fromOffset(240, 34),
	BackgroundTransparency = 1,
	ZIndex = 5,
	Parent = stack,
})

local track = new("Frame", {
	Position = UDim2.fromOffset(0, 0),
	Size = UDim2.new(1, 0, 0, 3),
	BackgroundColor3 = T.White,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 5,
	Parent = progressGroup,
})
addCorner(track, 2)

local fill = new("Frame", {
	Size = UDim2.new(0, 0, 1, 0),
	BackgroundColor3 = T.White,
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = track,
})
addCorner(fill, 2)
new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Accent),
		ColorSequenceKeypoint.new(1, T.Accent2),
	}),
	Parent = fill,
})

local statusLabel = label({
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 12),
	Size = UDim2.new(1, 0, 0, 16),
	Text = "",
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextColor3 = T.Muted,
	TextTransparency = 1,
	ZIndex = 5,
	Parent = progressGroup,
})

tween(bg, 0.6, { BackgroundTransparency = 0 })

task.wait(0.2)

tween(logoScale, 0.48, { Scale = 1 }, Enum.EasingStyle.Back)
tween(logoChip, 0.4, { BackgroundTransparency = 0 })
tween(logoChipStroke, 0.4, { Transparency = 0.25 })
if logoImage then
	tween(logoImage, 0.42, { ImageTransparency = 0 })
end

task.wait(0.38)

for _, letterLabel in ipairs(letters) do
	local scale = letterLabel:FindFirstChildOfClass("UIScale")
	tween(letterLabel, 0.42, { TextTransparency = 0, TextStrokeTransparency = 0.6 }, Enum.EasingStyle.Quart)
	if scale then
		tween(scale, 0.42, { Scale = 1 }, Enum.EasingStyle.Back)
	end
	task.wait(CONFIG.LetterStagger)
end

task.wait(0.12)

tween(underline, 0.42, { Size = UDim2.new(1, 0, 0, 2) }, Enum.EasingStyle.Quart)

task.wait(CONFIG.WordHoldDuration)

tween(subtitleScale, 0.42, { Scale = 1 }, Enum.EasingStyle.Back)
tween(subtitlePill, 0.32, { BackgroundTransparency = 0.86 })
tween(subtitleStroke, 0.32, { Transparency = 0.55 })
tween(subtitleLabel, 0.32, { TextTransparency = 0 })

task.wait(0.28)

tween(track, 0.25, { BackgroundTransparency = 0.82 })
tween(fill, CONFIG.ProgressDuration, { Size = UDim2.new(1, 0, 1, 0) }, Enum.EasingStyle.Linear)
tween(statusLabel, 0.25, { TextTransparency = 0 })

do
	local perMessage = CONFIG.ProgressDuration / #CONFIG.Messages
	for _, msg in ipairs(CONFIG.Messages) do
		tween(statusLabel, 0.15, { TextTransparency = 1 })
		task.wait(0.15)
		statusLabel.Text = msg
		tween(statusLabel, 0.15, { TextTransparency = 0 })
		task.wait(math.max(perMessage - 0.3, 0.15))
	end
end

task.wait(CONFIG.HoldDuration)

for _, letterLabel in ipairs(letters) do
	local scale = letterLabel:FindFirstChildOfClass("UIScale")
	tween(letterLabel, 0.48, { TextTransparency = 1, TextStrokeTransparency = 1 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	if scale then
		tween(scale, 0.48, { Scale = 1.15 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
	end
end

tween(underline, 0.35, { Size = UDim2.new(0, 0, 0, 2) }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
tween(logoScale, 0.42, { Scale = 1.2 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
tween(logoChip, 0.42, { BackgroundTransparency = 1 })
tween(logoChipStroke, 0.42, { Transparency = 1 })
if logoImage then
	tween(logoImage, 0.42, { ImageTransparency = 1 })
end
tween(subtitleScale, 0.4, { Scale = 1.08 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
tween(subtitlePill, 0.35, { BackgroundTransparency = 1 })
tween(subtitleStroke, 0.35, { Transparency = 1 })
tween(subtitleLabel, 0.35, { TextTransparency = 1 })
tween(track, 0.35, { BackgroundTransparency = 1 })
tween(fill, 0.35, { BackgroundTransparency = 1 })
tween(statusLabel, 0.35, { TextTransparency = 1 })

tween(bg, 0.6, { BackgroundTransparency = 1 })
tween(blur, 0.6, { Size = 0 })
tween(colorCorrection, 0.6, { Saturation = 0, Contrast = 0 })

task.wait(0.6)

if scaleConnection then
	scaleConnection:Disconnect()
end

gui:Destroy()
blur:Destroy()
colorCorrection:Destroy()
