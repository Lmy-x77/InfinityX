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

local notify = {}

local TweenService = Services.TweenService
local RunService = Services.RunService
local TextService = Services.TextService
local CoreGui = Services.CoreGui

local CONFIG = {
	Logo = "rbxassetid://92308401887821",
	Width = 320,
	Margin = 20,
	Spacing = 10,
	MaxVisible = 5,
	DefaultDuration = 3,
}

local T = {
	Accent = Color3.fromRGB(140, 80, 255),
	Accent2 = Color3.fromRGB(236, 72, 153),
	Text = Color3.fromRGB(248, 245, 255),
	Muted = Color3.fromRGB(184, 178, 198),
	Dim = Color3.fromRGB(150, 140, 175),
	White = Color3.new(1, 1, 1),
}

local TYPES = {
	info = { Color = Color3.fromRGB(140, 80, 255), Title = "InfinityX" },
	success = { Color = Color3.fromRGB(34, 197, 94), Title = "Success" },
	warning = { Color = Color3.fromRGB(250, 204, 21), Title = "Warning" },
	error = { Color = Color3.fromRGB(239, 68, 68), Title = "Error" },
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
	return CoreGui
end

local parentGui = getParent()

local gui = parentGui:FindFirstChild("InfinityX-Notify")
	or new("ScreenGui", {
		Name = "InfinityX-Notify",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 1000,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parentGui,
	})

local notifications = {}

local function drawIcon(holder, kind, color)
	local function bar(x, y, w, rot)
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

	if kind == "success" then
		bar(6, 13, 6, 45)
		bar(12, 10, 12, -48)
	elseif kind == "error" then
		bar(10, 10, 12, 45)
		bar(10, 10, 12, -45)
	elseif kind == "warning" then
		label({
			Size = UDim2.fromScale(1, 1),
			Text = "!",
			Font = Enum.Font.GothamBlack,
			TextSize = 18,
			TextColor3 = color,
			ZIndex = 6,
			Parent = holder,
		})
	else
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(24, 24),
			BackgroundTransparency = 1,
			Image = CONFIG.Logo,
			ScaleType = Enum.ScaleType.Fit,
			ZIndex = 6,
			Parent = holder,
		})
	end
end

local function stackPosition(acc)
	return UDim2.new(1, -(CONFIG.Width + CONFIG.Margin), 1, -(CONFIG.Margin + acc))
end

local function reflow()
	local acc = 0
	for _, n in ipairs(notifications) do
		tween(n.Holder, 0.4, { Position = stackPosition(acc) }, Enum.EasingStyle.Quint)
		acc = acc + n.Height + CONFIG.Spacing
	end
end

local function dismiss(record)
	if record.Leaving then
		return
	end
	record.Leaving = true

	local index = table.find(notifications, record)
	if index then
		table.remove(notifications, index)
	end
	reflow()

	local holder = record.Holder
	local y = holder.Position.Y
	tween(holder, 0.35, { Position = UDim2.new(1, 30, y.Scale, y.Offset) }, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
	tween(record.Card, 0.3, { GroupTransparency = 1 })
	tween(record.BorderStroke, 0.3, { Transparency = 1 })
	for _, layer in ipairs(record.Glow) do
		tween(layer, 0.3, { BackgroundTransparency = 1 })
	end

	task.delay(0.4, function()
		holder:Destroy()
	end)
end

function notify.notify(text, opts)
	if type(opts) == "number" then
		opts = { Duration = opts }
	elseif type(opts) ~= "table" then
		opts = {}
	end

	text = tostring(text)
	local kind = TYPES[opts.Type] and opts.Type or "info"
	local style = TYPES[kind]
	local color = style.Color
	local duration = tonumber(opts.Duration) or CONFIG.DefaultDuration
	local title = opts.Title or style.Title

	local textWidth = CONFIG.Width - 92
	local textHeight = 14
	pcall(function()
		textHeight = TextService:GetTextSize(text, 12, Enum.Font.Gotham, Vector2.new(textWidth, 10000)).Y
	end)
	local height = math.max(64, 32 + textHeight + 16)

	local holder = new("Frame", {
		Name = "Notification",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(1, 30, 1, -CONFIG.Margin),
		Size = UDim2.fromOffset(CONFIG.Width, height),
		BackgroundTransparency = 1,
		Parent = gui,
	})

	local glow = {}
	for i = 1, 5 do
		local pad = i * 8
		local layer = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.new(1, pad, 1, pad),
			BackgroundColor3 = color,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			ZIndex = 1,
			Parent = holder,
		})
		addCorner(layer, 12 + i * 4)
		table.insert(glow, layer)
	end

	local card = new("CanvasGroup", {
		Name = "Card",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		GroupTransparency = 1,
		ZIndex = 2,
		Parent = holder,
	})
	addCorner(card, 12)

	local bg = new("Frame", {
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

	local sheen = new("Frame", {
		Size = UDim2.new(1, 0, 0, 40),
		BackgroundColor3 = T.White,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = card,
	})
	new("UIGradient", { Rotation = 90, Transparency = NumberSequence.new(0.95, 1), Parent = sheen })

	new("ImageLabel", {
		Name = "Watermark",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, 22, 1, 30),
		Size = UDim2.fromOffset(120, 120),
		BackgroundTransparency = 1,
		Image = CONFIG.Logo,
		ImageTransparency = 0.94,
		Rotation = -14,
		ScaleType = Enum.ScaleType.Fit,
		ZIndex = 2,
		Parent = card,
	})

	local sideBar = new("Frame", {
		Size = UDim2.new(0, 3, 1, 0),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = card,
	})
	new("UIGradient", {
		Rotation = 90,
		Transparency = NumberSequence.new({
			NumberSequenceKeypoint.new(0, 0.6),
			NumberSequenceKeypoint.new(0.5, 0),
			NumberSequenceKeypoint.new(1, 0.6),
		}),
		Parent = sideBar,
	})

	local chip = new("Frame", {
		Name = "IconChip",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 16, 0.5, 0),
		Size = UDim2.fromOffset(38, 38),
		BackgroundColor3 = color,
		BackgroundTransparency = 0.82,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = card,
	})
	addCorner(chip, 11)
	addStroke(chip, color, 1, 0.6)

	local iconHolder = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(20, 20),
		BackgroundTransparency = 1,
		ZIndex = 5,
		Parent = chip,
	})
	drawIcon(iconHolder, kind, color)

	label({
		Name = "Title",
		Position = UDim2.fromOffset(68, 12),
		Size = UDim2.new(1, -(68 + 36), 0, 16),
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextColor3 = T.Text,
		ZIndex = 3,
		Parent = card,
	})
	label({
		Name = "Message",
		Position = UDim2.fromOffset(68, 30),
		Size = UDim2.new(1, -(68 + 24), 0, textHeight),
		Text = text,
		Font = Enum.Font.Gotham,
		TextSize = 12,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		TextColor3 = T.Muted,
		ZIndex = 3,
		Parent = card,
	})

	local closeBtn = new("TextButton", {
		Name = "Close",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 8),
		Size = UDim2.fromOffset(22, 22),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		ZIndex = 6,
		Parent = card,
	})
	addCorner(closeBtn, 6)
	local closeBars = {}
	for _, rot in ipairs({ 45, -45 }) do
		local b = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(9, 2),
			Rotation = rot,
			BackgroundColor3 = T.Dim,
			BorderSizePixel = 0,
			ZIndex = 7,
			Parent = closeBtn,
		})
		addCorner(b, 1)
		table.insert(closeBars, b)
	end
	closeBtn.MouseEnter:Connect(function()
		tween(closeBtn, 0.15, { BackgroundTransparency = 0.9 })
		for _, b in ipairs(closeBars) do
			tween(b, 0.15, { BackgroundColor3 = T.White })
		end
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, 0.15, { BackgroundTransparency = 1 })
		for _, b in ipairs(closeBars) do
			tween(b, 0.15, { BackgroundColor3 = T.Dim })
		end
	end)

	local progress = new("Frame", {
		Name = "Progress",
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.new(1, 0, 0, 3),
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		ZIndex = 4,
		Parent = card,
	})
	new("UIGradient", {
		Transparency = NumberSequence.new(0.1, 0.5),
		Parent = progress,
	})

	local border = new("Frame", {
		Name = "Border",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 3,
		Parent = holder,
	})
	addCorner(border, 12)
	local borderStroke = addStroke(border, T.White, 1.2, 1)
	local borderGradient = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, color),
			ColorSequenceKeypoint.new(0.45, Color3.fromRGB(55, 40, 90)),
			ColorSequenceKeypoint.new(0.75, T.Accent2),
			ColorSequenceKeypoint.new(1, color),
		}),
		Parent = borderStroke,
	})

	task.spawn(function()
		local t0 = os.clock()
		while holder.Parent do
			borderGradient.Rotation = ((os.clock() - t0) * 50) % 360
			RunService.RenderStepped:Wait()
		end
	end)

	local record = {
		Holder = holder,
		Card = card,
		BorderStroke = borderStroke,
		Glow = glow,
		Height = height,
		Leaving = false,
	}
	table.insert(notifications, 1, record)

	while #notifications > CONFIG.MaxVisible do
		dismiss(notifications[#notifications])
	end

	reflow()

	tween(card, 0.4, { GroupTransparency = 0 })
	tween(borderStroke, 0.5, { Transparency = 0.2 })
	for _, layer in ipairs(glow) do
		tween(layer, 0.6, { BackgroundTransparency = 0.988 })
	end
	tween(progress, duration, { Size = UDim2.new(0, 0, 0, 3) }, Enum.EasingStyle.Linear)

	closeBtn.MouseButton1Click:Connect(function()
		dismiss(record)
	end)
	task.delay(duration, function()
		dismiss(record)
	end)

	return function()
		dismiss(record)
	end
end

function notify.info(text, opts)
	opts = type(opts) == "table" and opts or { Duration = opts }
	opts.Type = "info"
	return notify.notify(text, opts)
end

function notify.success(text, opts)
	opts = type(opts) == "table" and opts or { Duration = opts }
	opts.Type = "success"
	return notify.notify(text, opts)
end

function notify.warn(text, opts)
	opts = type(opts) == "table" and opts or { Duration = opts }
	opts.Type = "warning"
	return notify.notify(text, opts)
end

function notify.error(text, opts)
	opts = type(opts) == "table" and opts or { Duration = opts }
	opts.Type = "error"
	return notify.notify(text, opts)
end

function notify.clear()
	for i = #notifications, 1, -1 do
		dismiss(notifications[i])
	end
end

return notify
