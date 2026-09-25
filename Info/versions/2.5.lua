local UiLibrary = {}
UiLibrary.__index = UiLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
	Width = 440,
	MaxContentHeight = 420,
	ReferenceWidth = 1024,
	ReferenceHeight = 600,
	MinScale = 0.8,
	MaxScale = 1.05,
	Logo = "rbxassetid://92308401887821",
	ParticleCountDesktop = 46,
	ParticleCountMobile = 22,
}

local T = {
	Background = Color3.fromRGB(12, 9, 19),
	Accent = Color3.fromRGB(140, 80, 255),
	Accent2 = Color3.fromRGB(236, 72, 153),
	AccentSoft = Color3.fromRGB(167, 139, 250),
	Text = Color3.fromRGB(248, 245, 255),
	Muted = Color3.fromRGB(150, 140, 175),
	White = Color3.new(1, 1, 1),
	Success = Color3.fromRGB(34, 197, 94),
	Warning = Color3.fromRGB(250, 204, 21),
	Error = Color3.fromRGB(239, 68, 68),
}

local KIND_COLORS = {
	info = T.Accent,
	success = T.Success,
	warning = T.Warning,
	error = T.Error,
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

local function addCardBackground(parent)
	local bg = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = T.White,
		BorderSizePixel = 0,
		ZIndex = 0,
		Parent = parent,
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
	return bg
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

local function computeScale()
	local camera = workspace.CurrentCamera
	local vp = camera and camera.ViewportSize or Vector2.new(CONFIG.ReferenceWidth, CONFIG.ReferenceHeight)
	local factor = math.min(vp.X / CONFIG.ReferenceWidth, vp.Y / CONFIG.ReferenceHeight)
	local scale = math.clamp(factor, CONFIG.MinScale, CONFIG.MaxScale)

	if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
		scale *= 0.9
	end

	return scale
end

local function drawCloseIcon(holder, color)
	for _, rot in ipairs({ 45, -45 }) do
		local bar = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(12, 2),
			Rotation = rot,
			BackgroundColor3 = color,
			BorderSizePixel = 0,
			Parent = holder,
		})
		addCorner(bar, 1)
	end
end

local function drawChevronIcon(holder, color)
	local left = new("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(0.5, 1, 0.5, -2),
		Size = UDim2.fromOffset(7, 2),
		Rotation = 45,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = holder,
	})
	local right = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.5, -1, 0.5, -2),
		Size = UDim2.fromOffset(7, 2),
		Rotation = -45,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = holder,
	})
	addCorner(left, 1)
	addCorner(right, 1)
end

local function makeIconButton(parent, order)
	local btn = new("TextButton", {
		LayoutOrder = order,
		Size = UDim2.fromOffset(26, 26),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		Parent = parent,
	})
	addCorner(btn, 8)

	btn.MouseEnter:Connect(function()
		tween(btn, 0.15, { BackgroundTransparency = 0.9 })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, 0.15, { BackgroundTransparency = 1 })
	end)

	return btn
end

local function makeGlowOrb(parent, size, pos, color, driftTo, dur)
	local orb = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = pos,
		Size = UDim2.fromOffset(size, size),
		BackgroundColor3 = color,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = parent,
	})
	addCorner(orb, size)
	tween(orb, 1.4, { BackgroundTransparency = 0.9 })

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

local function makeBracket(parent, cornerAnchor, xSign, ySign)
	local margin = 36
	local arm = 24
	local thick = 2

	local holder = new("Frame", {
		AnchorPoint = cornerAnchor,
		Position = UDim2.new(cornerAnchor.X, xSign * margin, cornerAnchor.Y, ySign * margin),
		Size = UDim2.fromOffset(arm, arm),
		BackgroundTransparency = 1,
		ZIndex = 2,
		Parent = parent,
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

	tween(h, 0.8, { BackgroundTransparency = 0.6 })
	tween(v, 0.8, { BackgroundTransparency = 0.6 })
end

local function spawnParticle(parent)
	local size = math.random(2, 4)
	local particle = new("Frame", {
		Size = UDim2.fromOffset(size, size),
		Position = UDim2.fromScale(math.random(), 1.05),
		BackgroundColor3 = math.random() > 0.5 and T.Accent or T.Accent2,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 3,
		Parent = parent,
	})
	addCorner(particle, size)

	task.spawn(function()
		task.wait(math.random() * 4)

		while particle.Parent do
			local startX = math.random()
			local sway = (math.random() - 0.5) * 0.14
			local duration = math.random(90, 170) / 10
			local maxOpacity = math.random(35, 70) / 100

			particle.Position = UDim2.fromScale(startX, 1.05)

			tween(particle, duration * 0.18, { BackgroundTransparency = 1 - maxOpacity })

			local drift = TweenService:Create(
				particle,
				TweenInfo.new(duration, Enum.EasingStyle.Linear),
				{ Position = UDim2.fromScale(math.clamp(startX + sway, 0, 1), -0.05) }
			)
			drift:Play()

			task.wait(duration * 0.8)
			tween(particle, duration * 0.2, { BackgroundTransparency = 1 })
			drift.Completed:Wait()
		end
	end)

	return particle
end

local function buildBackground(gui)
	local bg = new("Frame", {
		Name = "Background",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = T.Background,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 1,
		Parent = gui,
	})

	local gradient = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 15, 46)),
			ColorSequenceKeypoint.new(0.5, Color3.fromRGB(64, 34, 112)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 11, 30)),
		}),
		Rotation = 0,
		Parent = bg,
	})

	task.spawn(function()
		while bg.Parent do
			local t = TweenService:Create(gradient, TweenInfo.new(10, Enum.EasingStyle.Linear), {
				Rotation = gradient.Rotation + 360,
			})
			t:Play()
			t.Completed:Wait()
		end
	end)

	new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = Color3.fromRGB(8, 6, 14),
		BackgroundTransparency = 0.4,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = bg,
	})

	makeGlowOrb(bg, 420, UDim2.fromScale(0.16, 0.24), T.Accent, UDim2.fromScale(0.22, 0.3), 7)
	makeGlowOrb(bg, 360, UDim2.fromScale(0.86, 0.74), T.Accent2, UDim2.fromScale(0.8, 0.68), 8)
	makeGlowOrb(bg, 260, UDim2.fromScale(0.5, 0.9), T.Accent, UDim2.fromScale(0.56, 0.84), 9)

	makeBracket(bg, Vector2.new(0, 0), 1, 1)
	makeBracket(bg, Vector2.new(1, 0), -1, 1)
	makeBracket(bg, Vector2.new(0, 1), 1, -1)
	makeBracket(bg, Vector2.new(1, 1), -1, -1)

	local particleCount = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled)
		and CONFIG.ParticleCountMobile
		or CONFIG.ParticleCountDesktop

	for _ = 1, particleCount do
		spawnParticle(bg)
	end

	return bg
end

local function createNotifier(parentGui)
	local layer = new("Frame", {
		Name = "Notifications",
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.new(1, -16, 1, -16),
		Size = UDim2.fromOffset(280, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 50,
		Parent = parentGui,
	})
	new("UIListLayout", {
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		HorizontalAlignment = Enum.HorizontalAlignment.Right,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 8),
		Parent = layer,
	})

	return function(title, content, duration, kind)
		duration = duration or 3.5
		local accent = KIND_COLORS[kind] or T.Accent

		local card = new("Frame", {
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ClipsDescendants = true,
			ZIndex = 50,
			Parent = layer,
		})
		addCorner(card, 10)
		local bg = addCardBackground(card)
		bg.ZIndex = 50
		local stroke = addStroke(card, accent, 1, 1)
		stroke.ZIndex = 51

		local bar = new("Frame", {
			Size = UDim2.new(0, 3, 1, 0),
			BackgroundColor3 = accent,
			BorderSizePixel = 0,
			ZIndex = 51,
			Parent = card,
		})

		local column = new("Frame", {
			Position = UDim2.fromOffset(13, 8),
			Size = UDim2.new(1, -24, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			BackgroundTransparency = 1,
			ZIndex = 51,
			Parent = card,
		})
		new("UIListLayout", { Padding = UDim.new(0, 2), Parent = column })
		new("UIPadding", { PaddingBottom = UDim.new(0, 8), Parent = column })

		local titleLabel = label({
			Size = UDim2.new(1, 0, 0, 15),
			Text = title,
			Font = Enum.Font.GothamBold,
			TextSize = 13,
			TextColor3 = T.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 51,
			Parent = column,
		})
		local bodyLabel = label({
			Size = UDim2.new(1, 0, 0, 0),
			AutomaticSize = Enum.AutomaticSize.Y,
			Text = content,
			Font = Enum.Font.Gotham,
			TextSize = 12,
			TextWrapped = true,
			TextColor3 = T.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			ZIndex = 51,
			Parent = column,
		})

		local scale = new("UIScale", { Scale = 0.9, Parent = card })
		bg.BackgroundTransparency = 1
		card.BackgroundTransparency = 1

		tween(scale, 0.28, { Scale = 1 }, Enum.EasingStyle.Back)
		tween(bg, 0.28, { BackgroundTransparency = 0 })
		tween(stroke, 0.28, { Transparency = 0.4 })

		task.delay(duration, function()
			if not card.Parent then
				return
			end
			tween(bg, 0.25, { BackgroundTransparency = 1 })
			tween(stroke, 0.25, { Transparency = 1 })
			tween(titleLabel, 0.25, { TextTransparency = 1 })
			tween(bodyLabel, 0.25, { TextTransparency = 1 })
			tween(bar, 0.25, { BackgroundTransparency = 1 })
			task.wait(0.25)
			card:Destroy()
		end)
	end
end

function UiLibrary:CreateWindow(titleText, options)
	options = options or {}
	local self = setmetatable({}, UiLibrary)

	self._order = 1

	local parentGui = getParent()

	local old = parentGui:FindFirstChild(options.Name or "InfinityXInfoWindow")
	if old then
		old:Destroy()
	end

	local gui = new("ScreenGui", {
		Name = options.Name or "InfinityXInfoWindow",
		IgnoreGuiInset = true,
		ResetOnSpawn = false,
		DisplayOrder = 50,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		Parent = parentGui,
	})
	self._Gui = gui

	local background = buildBackground(gui)
	self._Background = background
	tween(background, 0.6, { BackgroundTransparency = 0 })

	local main = new("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = options.Position or UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(options.Width or CONFIG.Width, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ZIndex = 10,
		Parent = background,
	})
	self._Main = main

	local card = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 10,
		Parent = main,
	})
	addCorner(card, 20)
	local cardBg = addCardBackground(card)
	self._CardBg = cardBg
	local border = addStroke(card, T.White, 1, 1)
	self._Border = border
	local borderGradient = new("UIGradient", {
		Rotation = 105,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.Accent),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(60, 45, 95)),
			ColorSequenceKeypoint.new(1, T.Accent2),
		}),
		Parent = border,
	})
	tween(border, 0.4, { Transparency = 0.3 })

	local accent = new("Frame", {
		Size = UDim2.new(1, 0, 0, 3),
		BackgroundColor3 = T.White,
		BorderSizePixel = 0,
		ZIndex = 11,
		Parent = card,
	})
	local accentGradient = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.Accent),
			ColorSequenceKeypoint.new(0.5, T.Accent2),
			ColorSequenceKeypoint.new(1, T.Accent),
		}),
		Parent = accent,
	})
	TweenService:Create(
		accentGradient,
		TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
		{ Offset = Vector2.new(0.4, 0) }
	):Play()

	local scaleUI = new("UIScale", { Scale = computeScale(), Parent = main })
	self._ScaleConnection = workspace.CurrentCamera
		and workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			scaleUI.Scale = computeScale()
		end)

	local content = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ZIndex = 12,
		Parent = card,
	})
	new("UIPadding", {
		PaddingTop = UDim.new(0, 20),
		PaddingBottom = UDim.new(0, 20),
		PaddingLeft = UDim.new(0, 20),
		PaddingRight = UDim.new(0, 20),
		Parent = content,
	})
	new("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 14),
		Parent = content,
	})

	local header = new("Frame", {
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = content,
	})
	new("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 12),
		Parent = header,
	})

	if options.ShowLogo ~= false then
		local logo = new("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(38, 38),
			BackgroundColor3 = T.White,
			BorderSizePixel = 0,
			Parent = header,
		})
		addCorner(logo, 12)
		new("UIGradient", {
			Rotation = 135,
			Color = ColorSequence.new(Color3.fromRGB(56, 34, 104), Color3.fromRGB(20, 13, 38)),
			Parent = logo,
		})
		addStroke(logo, T.Accent, 1, 0.5)
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(22, 22),
			BackgroundTransparency = 1,
			Image = options.Logo or CONFIG.Logo,
			ScaleType = Enum.ScaleType.Fit,
			Parent = logo,
		})
	end

	local textColumn = new("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(0, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = header,
	})
	new("UIFlexItem", { FlexMode = Enum.UIFlexMode.Grow, Parent = textColumn })
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 1), Parent = textColumn })

	local titleLabel = label({
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 20),
		Text = titleText,
		Font = Enum.Font.GothamBold,
		TextSize = 18,
		TextColor3 = T.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = textColumn,
	})
	self._TitleLabel = titleLabel

	if options.Subtitle then
		self._SubtitleLabel = label({
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 14),
			Text = options.Subtitle,
			Font = Enum.Font.GothamMedium,
			TextSize = 12,
			TextColor3 = T.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = textColumn,
		})
	end

	if options.Closable ~= false then
		local closeBtn = makeIconButton(header, 3)
		local closeIconHolder = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(18, 18),
			BackgroundTransparency = 1,
			Parent = closeBtn,
		})
		drawCloseIcon(closeIconHolder, T.Muted)

		closeBtn.MouseButton1Click:Connect(function()
			self:Destroy()
		end)
	end

	local divider = new("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.88,
		BorderSizePixel = 0,
		Parent = content,
	})

	local scrollFrame = new("ScrollingFrame", {
		LayoutOrder = 3,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 0,
		ScrollBarImageColor3 = T.Accent,
		ScrollBarImageTransparency = 1,
		ScrollingEnabled = false,
		Parent = content,
	})
	new("UIPadding", { PaddingRight = UDim.new(0, 6) }).Parent = scrollFrame
	local listLayout = new("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
		Parent = scrollFrame,
	})

	self._ScrollFrame = scrollFrame
	self._Layout = listLayout
	self._Container = scrollFrame
	self._Divider = divider

	self._Notify = createNotifier(gui)

	self:_Resize()

	return self
end

function UiLibrary:_Resize()
	local list = self._Layout
	local scrollFrame = self._ScrollFrame

	task.defer(function()
		if not scrollFrame or not scrollFrame.Parent then
			return
		end

		local contentHeight = list.AbsoluteContentSize.Y
		local capped = math.min(contentHeight, CONFIG.MaxContentHeight)
		local needsScroll = contentHeight > CONFIG.MaxContentHeight + 1

		tween(scrollFrame, 0.22, { Size = UDim2.new(1, 0, 0, capped) })
		tween(scrollFrame, 0.22, { ScrollBarImageTransparency = needsScroll and 0.4 or 1 })

		scrollFrame.ScrollBarThickness = needsScroll and 4 or 0
		scrollFrame.ScrollingEnabled = needsScroll
	end)
end

function UiLibrary:AddInfo(title, value, color, options)
	options = options or {}
	local window = self

	local align = options.align == "center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left

	local row = new("Frame", {
		LayoutOrder = window._order,
		Size = UDim2.new(1, 0, 0, 56),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Parent = window._Container,
	})
	window._order += 1
	addCorner(row, 14)
	local stroke = addStroke(row, T.White, 1, 0.9)
	local rowScale = new("UIScale", { Scale = 1, Parent = row })

	local iconChip = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 8, 0.5, 0),
		Size = UDim2.fromOffset(40, 40),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 0.82,
		BorderSizePixel = 0,
		Parent = row,
	})
	addCorner(iconChip, 13)
	addStroke(iconChip, T.Accent, 1, 0.55)
	label({
		Size = UDim2.fromScale(1, 1),
		Text = string.upper(string.sub(title, 1, 1)),
		Font = Enum.Font.GothamBold,
		TextSize = 16,
		TextColor3 = T.AccentSoft,
		Parent = iconChip,
	})

	local textOffset = 60
	label({
		Position = UDim2.fromOffset(textOffset, 10),
		Size = UDim2.new(1, -(textOffset + 12), 0, 14),
		Text = string.upper(title),
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = T.Muted,
		TextXAlignment = align,
		Parent = row,
	})
	local valueLabel = label({
		Position = UDim2.fromOffset(textOffset, 27),
		Size = UDim2.new(1, -(textOffset + 12), 0, 19),
		Text = tostring(value),
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextColor3 = color or T.AccentSoft,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = align,
		Parent = row,
	})

	row.MouseEnter:Connect(function()
		tween(row, 0.15, { BackgroundTransparency = 0.86 })
		tween(stroke, 0.15, { Transparency = 0.65 })
		tween(rowScale, 0.15, { Scale = 1.012 })
	end)
	row.MouseLeave:Connect(function()
		tween(row, 0.15, { BackgroundTransparency = 0.94 })
		tween(stroke, 0.15, { Transparency = 0.9 })
		tween(rowScale, 0.15, { Scale = 1 })
	end)

	if options.divider then
		window:AddDivider()
	end

	window:_Resize()

	local infoObj = {}
	function infoObj:Update(newValue)
		valueLabel.Text = tostring(newValue)
	end
	function infoObj:SetColor(newColor)
		valueLabel.TextColor3 = newColor
	end
	function infoObj:Destroy()
		row:Destroy()
		window:_Resize()
	end
	return infoObj
end

function UiLibrary:AddLabel(text, align)
	local window = self
	local alignEnum = align == "center" and Enum.TextXAlignment.Center or Enum.TextXAlignment.Left

	local row = new("Frame", {
		LayoutOrder = window._order,
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Parent = window._Container,
	})
	window._order += 1

	if alignEnum == Enum.TextXAlignment.Left then
		local tick = new("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, -1),
			Size = UDim2.fromOffset(4, 16),
			BackgroundColor3 = T.Accent,
			BorderSizePixel = 0,
			Parent = row,
		})
		addCorner(tick, 2)
	end

	label({
		Position = alignEnum == Enum.TextXAlignment.Left and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0),
		Size = alignEnum == Enum.TextXAlignment.Left and UDim2.new(1, -14, 0, 16) or UDim2.new(1, 0, 0, 16),
		Text = string.upper(text),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = T.Muted,
		TextXAlignment = alignEnum,
		Parent = row,
	})

	new("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.93,
		BorderSizePixel = 0,
		Parent = row,
	})

	window:_Resize()
end

function UiLibrary:AddDivider()
	local window = self

	local holder = new("Frame", {
		LayoutOrder = window._order,
		Size = UDim2.new(1, 0, 0, 10),
		BackgroundTransparency = 1,
		Parent = window._Container,
	})
	window._order += 1

	new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.9,
		BorderSizePixel = 0,
		Parent = holder,
	})

	window:_Resize()
end

function UiLibrary:AddButton(text, textColor, callback)
	local window = self

	local btn = new("TextButton", {
		LayoutOrder = window._order,
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = T.White,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		Parent = window._Container,
	})
	window._order += 1
	addCorner(btn, 13)
	local gradient = new("UIGradient", {
		Rotation = 15,
		Color = ColorSequence.new(T.Accent, T.Accent2),
		Parent = btn,
	})
	local stroke = addStroke(btn, T.White, 1, 0.75)
	local scale = new("UIScale", { Scale = 1, Parent = btn })

	local lbl = label({
		Size = UDim2.fromScale(1, 1),
		Text = text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 14,
		TextColor3 = textColor or T.White,
		Parent = btn,
	})

	btn.MouseEnter:Connect(function()
		tween(gradient, 0.3, { Rotation = 55 })
		tween(stroke, 0.15, { Transparency = 0.4 })
		tween(scale, 0.15, { Scale = 1.015 })
	end)
	btn.MouseLeave:Connect(function()
		tween(gradient, 0.3, { Rotation = 15 })
		tween(stroke, 0.15, { Transparency = 0.75 })
		tween(scale, 0.15, { Scale = 1 })
	end)
	btn.MouseButton1Down:Connect(function()
		tween(scale, 0.1, { Scale = 0.97 })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(scale, 0.12, { Scale = 1.015 })
	end)
	btn.MouseButton1Click:Connect(function()
		if callback then
			local ok, err = pcall(callback)
			if not ok then
				warn("[InfinityX Info] Button callback error: " .. tostring(err))
			end
		end
	end)

	window:_Resize()

	local btnObj = {}
	function btnObj:SetText(newText)
		lbl.Text = newText
	end
	function btnObj:SetEnabled(state)
		btn.Active = state
		tween(btn, 0.15, { BackgroundTransparency = state and 0 or 0.5 })
		tween(lbl, 0.15, { TextTransparency = state and 0 or 0.5 })
	end
	function btnObj:Destroy()
		btn:Destroy()
		window:_Resize()
	end
	return btnObj
end

function UiLibrary:SetTitle(newTitle)
	if self._TitleLabel then
		self._TitleLabel.Text = newTitle
	end
end

function UiLibrary:SetSubtitle(newSubtitle)
	if self._SubtitleLabel then
		self._SubtitleLabel.Text = newSubtitle
	end
end

function UiLibrary:Notify(title, content, duration, kind)
	self._Notify(title, content, duration, kind)
end

function UiLibrary:SetVisible(visible)
	self._Gui.Enabled = visible
end

function UiLibrary:Destroy()
	if self._Destroyed then
		return
	end
	self._Destroyed = true

	if self._ScaleConnection then
		self._ScaleConnection:Disconnect()
	end

	if self._Background then
		tween(self._Background, 0.35, { BackgroundTransparency = 1 })
	end
	if self._CardBg then
		tween(self._CardBg, 0.3, { BackgroundTransparency = 1 })
	end
	if self._Border then
		tween(self._Border, 0.3, { Transparency = 1 })
	end

	task.delay(0.4, function()
		if self._Gui then
			self._Gui:Destroy()
		end
	end)
end

local staticNotify

function UiLibrary:StaticNotify(title, content, duration, kind)
	if not staticNotify then
		local gui = new("ScreenGui", {
			Name = "InfinityXInfoNotify",
			IgnoreGuiInset = true,
			ResetOnSpawn = false,
			DisplayOrder = 60,
			Parent = getParent(),
		})
		staticNotify = createNotifier(gui)
	end
	staticNotify(title, content, duration, kind)
end

return UiLibrary
