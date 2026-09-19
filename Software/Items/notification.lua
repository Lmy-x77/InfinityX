Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local TweenService = Services.TweenService
local RunService = Services.RunService
local Lighting = Services.Lighting
local UserInputService = Services.UserInputService
local CoreGui = Services.CoreGui

local CONFIG = {
	Title = "Game Not Supported",
	Subtitle = "INFINITYX",
	Description = "InfinityX doesn't support this game yet. Join our <font color=\"#a78bfa\"><b>Discord</b></font> to request support and be notified as soon as it's available.",
	Logo = "rbxassetid://92308401887821",
	Discord = "https://discord.gg/emKJgWMHAr",
	NotifyLib = "https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Notify/source.lua",
}

local T = {
	Background = Color3.fromRGB(13, 10, 20),
	Accent = Color3.fromRGB(140, 80, 255),
	Accent2 = Color3.fromRGB(236, 72, 153),
	AccentSoft = Color3.fromRGB(167, 139, 250),
	Text = Color3.fromRGB(248, 245, 255),
	Muted = Color3.fromRGB(150, 140, 175),
	Danger = Color3.fromRGB(239, 68, 68),
	Success = Color3.fromRGB(34, 197, 94),
	White = Color3.new(1, 1, 1),
}

local WIDTH, HEIGHT = 480, 272

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

do
	local old = parentGui:FindFirstChild("NotSupportedUI")
	if old then
		old:Destroy()
	end
	local oldBlur = Lighting:FindFirstChild("InfinityXBlur")
	if oldBlur then
		oldBlur:Destroy()
	end
end

local gui = new("ScreenGui", {
	Name = "NotSupportedUI",
	IgnoreGuiInset = true,
	ResetOnSpawn = false,
	DisplayOrder = 999,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Parent = parentGui,
})

local blur = new("BlurEffect", { Name = "InfinityXBlur", Size = 0, Parent = Lighting })

local overlay = new("Frame", {
	Name = "Overlay",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(6, 4, 12),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ZIndex = 0,
	Parent = gui,
})

local root = new("Frame", {
	Name = "Root",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(WIDTH, HEIGHT),
	BackgroundTransparency = 1,
	Parent = gui,
})

local rootScale = new("UIScale", { Scale = 0.9, Parent = root })

local glowHolder = new("Frame", {
	Name = "Glow",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ZIndex = 1,
	Parent = root,
})

local glowLayers = {}
local GLOW_TARGET = 0.982

for i = 1, 9 do
	local pad = i * 12
	local layer = new("Frame", {
		Name = "Layer" .. i,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.new(1, pad, 1, pad),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Parent = glowHolder,
	})
	addCorner(layer, 16 + i * 6)
	table.insert(glowLayers, layer)
end

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
	BackgroundColor3 = T.White,
	BorderSizePixel = 0,
	ZIndex = 1,
	Parent = card,
})
new("UIGradient", {
	Rotation = 125,
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 18, 42)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 12, 26)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(10, 8, 17)),
	}),
	Parent = bg,
})

new("ImageLabel", {
	Name = "Watermark",
	AnchorPoint = Vector2.new(1, 1),
	Position = UDim2.new(1, 44, 1, 56),
	Size = UDim2.fromOffset(260, 260),
	BackgroundTransparency = 1,
	Image = CONFIG.Logo,
	ImageTransparency = 0.94,
	Rotation = -14,
	ScaleType = Enum.ScaleType.Fit,
	ZIndex = 2,
	Parent = card,
})

local border = new("Frame", {
	Name = "Border",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	ZIndex = 3,
	Parent = root,
})
addCorner(border, 16)
local borderStroke = addStroke(border, T.White, 1.5, 1)
local borderGradient = new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 80, 255)),
		ColorSequenceKeypoint.new(0.35, Color3.fromRGB(60, 40, 100)),
		ColorSequenceKeypoint.new(0.6, Color3.fromRGB(236, 72, 153)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 80, 255)),
	}),
	Parent = borderStroke,
})

local accent = new("Frame", {
	Name = "TopAccent",
	Size = UDim2.new(1, 0, 0, 2),
	BackgroundColor3 = T.White,
	BorderSizePixel = 0,
	ZIndex = 4,
	Parent = card,
})
local accentGradient = new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 70, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 90, 200)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 70, 255)),
	}),
	Parent = accent,
})

local ring = new("Frame", {
	Name = "LogoRing",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromOffset(52, 52),
	Size = UDim2.fromOffset(56, 56),
	BackgroundTransparency = 1,
	ZIndex = 3,
	Parent = card,
})
addCorner(ring, 16)
local ringStroke = addStroke(ring, T.Accent, 1.5, 0.35)
local ringScale = new("UIScale", { Scale = 1, Parent = ring })

local pulseInfo = TweenInfo.new(2.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1)
TweenService:Create(ringScale, pulseInfo, { Scale = 1.5 }):Play()
TweenService:Create(ringStroke, pulseInfo, { Transparency = 1 }):Play()

local logoChip = new("Frame", {
	Name = "LogoChip",
	Position = UDim2.fromOffset(24, 24),
	Size = UDim2.fromOffset(56, 56),
	BackgroundColor3 = T.White,
	BorderSizePixel = 0,
	ZIndex = 4,
	Parent = card,
})
addCorner(logoChip, 15)
new("UIGradient", {
	Rotation = 135,
	Color = ColorSequence.new(Color3.fromRGB(56, 34, 104), Color3.fromRGB(26, 17, 48)),
	Parent = logoChip,
})
addStroke(logoChip, T.Accent, 1, 0.4)

new("ImageLabel", {
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

local badge = new("Frame", {
	Name = "WarnBadge",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromOffset(74, 74),
	Size = UDim2.fromOffset(20, 20),
	BackgroundColor3 = T.Danger,
	BorderSizePixel = 0,
	ZIndex = 6,
	Parent = card,
})
addCorner(badge, 10)
addStroke(badge, Color3.fromRGB(16, 12, 26), 2, 0)
label({
	Size = UDim2.fromScale(1, 1),
	Text = "!",
	Font = Enum.Font.GothamBlack,
	TextSize = 12,
	TextColor3 = T.White,
	ZIndex = 7,
	Parent = badge,
})

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
	Font = Enum.Font.GothamBold,
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
for _, rot in ipairs({ 45, -45 }) do
	local bar = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(12, 2),
		Rotation = rot,
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
	BackgroundColor3 = Color3.fromRGB(150, 120, 220),
	BorderSizePixel = 0,
	ZIndex = 3,
	Parent = card,
})
new("UIGradient", {
	Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.5, 0.72),
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
	TextColor3 = Color3.fromRGB(184, 178, 198),
	Parent = card,
})

local chipRow = new("Frame", {
	Name = "Chips",
	Position = UDim2.fromOffset(24, 162),
	Size = UDim2.new(1, -48, 0, 28),
	BackgroundTransparency = 1,
	ZIndex = 3,
	Parent = card,
})
new("UIListLayout", {
	FillDirection = Enum.FillDirection.Horizontal,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8),
	Parent = chipRow,
})

local function makeChip(order, key, value, dotColor, pulse)
	local chip = new("Frame", {
		Name = "Chip" .. order,
		LayoutOrder = order,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.fromOffset(0, 28),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = chipRow,
	})
	addCorner(chip, 8)
	addStroke(chip, T.White, 1, 0.92)
	new("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 12), Parent = chip })
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6),
		Parent = chip,
	})

	local dot = new("Frame", {
		LayoutOrder = 1,
		Size = UDim2.fromOffset(6, 6),
		BackgroundColor3 = dotColor,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = chip,
	})
	addCorner(dot, 3)

	if pulse then
		TweenService:Create(
			dot,
			TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
			{ BackgroundTransparency = 0.7 }
		):Play()
	end

	label({
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		Text = key,
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = T.Muted,
		ZIndex = 4,
		Parent = chip,
	})
	label({
		LayoutOrder = 3,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		Text = value,
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = T.Text,
		ZIndex = 4,
		Parent = chip,
	})
end

makeChip(1, "PLACE ID", tostring(game.PlaceId), T.Accent, false)
makeChip(2, "STATUS", "Unsupported", T.Danger, true)

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
	for _, c in ipairs(holder:GetChildren()) do
		c:Destroy()
	end
end

local function drawCopyIcon(holder, color, fill)
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
		BackgroundColor3 = fill,
		BorderSizePixel = 0,
		ZIndex = 6,
		Parent = holder,
	})
	addCorner(front, 3)
	addStroke(front, color, 1.5, 0)
end

local function drawCheckIcon(holder, color)
	clearIcon(holder)
	local function leg(x, y, w, rot)
		local f = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromOffset(x, y),
			Size = UDim2.fromOffset(w, 2),
			Rotation = rot,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			ZIndex = 6,
			Parent = holder,
		})
		addCorner(f, 1)
	end
	leg(4, 10, 6, 45)
	leg(10, 8, 12, -47)
end

local function makeButton(order, width, text, primary)
	local btn = new("TextButton", {
		Name = primary and "Primary" or "Secondary",
		LayoutOrder = order,
		Size = UDim2.fromOffset(width, 38),
		BackgroundColor3 = T.White,
		BackgroundTransparency = primary and 0 or 0.95,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = buttonRow,
	})
	addCorner(btn, 10)
	local scale = new("UIScale", { Scale = 1, Parent = btn })
	local stroke = addStroke(btn, T.White, 1, primary and 0.75 or 0.9)

	local gradient
	if primary then
		gradient = new("UIGradient", {
			Rotation = 15,
			Color = ColorSequence.new(T.Accent, Color3.fromRGB(214, 70, 180)),
			Parent = btn,
		})
	end

	local content = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 5,
		Parent = btn,
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
		LayoutOrder = 1,
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		Visible = primary,
		ZIndex = 5,
		Parent = content,
	})

	local txt = label({
		LayoutOrder = 2,
		AutomaticSize = Enum.AutomaticSize.X,
		Size = UDim2.new(0, 0, 1, 0),
		Text = text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 12,
		TextColor3 = primary and T.White or Color3.fromRGB(205, 198, 222),
		ZIndex = 5,
		Parent = content,
	})

	btn.MouseEnter:Connect(function()
		tween(scale, 0.18, { Scale = 1.03 })
		if primary then
			tween(gradient, 0.3, { Rotation = 45 })
			tween(stroke, 0.18, { Transparency = 0.45 })
		else
			tween(btn, 0.18, { BackgroundTransparency = 0.88 })
			tween(stroke, 0.18, { Transparency = 0.75 })
		end
	end)
	btn.MouseLeave:Connect(function()
		tween(scale, 0.18, { Scale = 1 })
		if primary then
			tween(gradient, 0.3, { Rotation = 15 })
			tween(stroke, 0.18, { Transparency = 0.75 })
		else
			tween(btn, 0.18, { BackgroundTransparency = 0.95 })
			tween(stroke, 0.18, { Transparency = 0.9 })
		end
	end)
	btn.MouseButton1Down:Connect(function()
		tween(scale, 0.1, { Scale = 0.97 })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(scale, 0.12, { Scale = 1.03 })
	end)

	return { Button = btn, Label = txt, Icon = icon, Gradient = gradient, Scale = scale }
end

local dismiss = makeButton(1, 104, "Dismiss", false)
local copyBtn = makeButton(2, 176, "Copy Discord Link", true)
drawCopyIcon(copyBtn.Icon, T.White, T.Accent)

local connections = {}
local startClock = os.clock()

table.insert(
	connections,
	RunService.RenderStepped:Connect(function()
		local t = os.clock() - startClock
		borderGradient.Rotation = (t * 45) % 360
		accentGradient.Offset = Vector2.new(math.sin(t * 0.9) * 0.25, 0)

		local mix = (math.sin(t * 0.7) + 1) / 2
		local glowColor = T.Accent:Lerp(T.Accent2, mix)
		for _, layer in ipairs(glowLayers) do
			layer.BackgroundColor3 = glowColor
		end
	end)
)

do
	local dragging, dragStart, startPos = false, nil, nil

	card.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = root.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	table.insert(
		connections,
		UserInputService.InputChanged:Connect(function(input)
			if
				dragging
				and (
					input.UserInputType == Enum.UserInputType.MouseMovement
					or input.UserInputType == Enum.UserInputType.Touch
				)
			then
				local delta = input.Position - dragStart
				root.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)
	)
end

tween(overlay, 0.45, { BackgroundTransparency = 0.5 })
tween(blur, 0.5, { Size = 18 })
tween(rootScale, 0.6, { Scale = 1 }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
tween(card, 0.45, { GroupTransparency = 0 })
tween(borderStroke, 0.6, { Transparency = 0.1 })
for _, layer in ipairs(glowLayers) do
	tween(layer, 0.8, { BackgroundTransparency = GLOW_TARGET })
end

local closing = false

local function close()
	if closing then
		return
	end
	closing = true

	for _, c in ipairs(connections) do
		c:Disconnect()
	end

	tween(card, 0.3, { GroupTransparency = 1 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	tween(borderStroke, 0.3, { Transparency = 1 })
	tween(rootScale, 0.35, { Scale = 0.92 }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	tween(overlay, 0.35, { BackgroundTransparency = 1 })
	tween(blur, 0.35, { Size = 0 })
	for _, layer in ipairs(glowLayers) do
		tween(layer, 0.3, { BackgroundTransparency = 1 })
	end

	task.wait(0.4)

	blur:Destroy()
	gui:Destroy()
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
	copyBtn.Gradient.Color = ColorSequence.new(
		ok and T.Success or T.Danger,
		ok and Color3.fromRGB(16, 185, 129) or Color3.fromRGB(190, 40, 60)
	)
	tween(copyBtn.Scale, 0.12, { Scale = 1.06 }, Enum.EasingStyle.Back)
	task.delay(0.12, function()
		tween(copyBtn.Scale, 0.2, { Scale = 1 })
	end)

	task.spawn(function()
		local success, lib = pcall(function()
			return loadstring(game:HttpGet(CONFIG.NotifyLib, true))()
		end)
		if success and lib and lib.notify then
			pcall(lib.notify, "Discord link copied to clipboard!")
		end
	end)

	task.wait(1.2)
	close()
end

copyBtn.Button.MouseButton1Click:Connect(copyDiscord)
dismiss.Button.MouseButton1Click:Connect(close)
closeBtn.MouseButton1Click:Connect(close)
