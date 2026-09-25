local UiLibrary = {}
UiLibrary.__index = UiLibrary

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

local CONFIG = {
	Width = 320,
	MaxContentHeight = 340,
	ReferenceWidth = 1024,
	ReferenceHeight = 600,
	MinScale = 0.8,
	MaxScale = 1.05,
	Logo = "rbxassetid://92308401887821",
}

local T = {
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
			Size = UDim2.fromOffset(11, 2),
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
		Size = UDim2.fromOffset(6, 2),
		Rotation = 45,
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Parent = holder,
	})
	local right = new("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0.5, -1, 0.5, -2),
		Size = UDim2.fromOffset(6, 2),
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
		Size = UDim2.fromOffset(22, 22),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		Parent = parent,
	})
	addCorner(btn, 7)

	btn.MouseEnter:Connect(function()
		tween(btn, 0.15, { BackgroundTransparency = 0.9 })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, 0.15, { BackgroundTransparency = 1 })
	end)

	return btn
end

local function makeDraggable(main, handle)
	local dragging, dragStart, startPos = false, nil, nil

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = main.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if
			dragging
			and (
				input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch
			)
			and main.Parent
		then
			local delta = input.Position - dragStart
			main.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)
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

	local main = new("Frame", {
		Name = "Main",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = options.Position or UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(options.Width or CONFIG.Width, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = gui,
	})
	self._Main = main

	local card = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Parent = main,
	})
	addCorner(card, 14)
	addCardBackground(card)
	local border = addStroke(card, T.White, 1, 1)
	local borderGradient = new("UIGradient", {
		Rotation = 105,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, T.Accent),
			ColorSequenceKeypoint.new(0.55, Color3.fromRGB(60, 45, 95)),
			ColorSequenceKeypoint.new(1, T.Accent2),
		}),
		Parent = border,
	})
	tween(border, 0.3, { Transparency = 0.35 })

	local scaleUI = new("UIScale", { Scale = computeScale(), Parent = main })
	self._ScaleConnection = workspace.CurrentCamera
		and workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			scaleUI.Scale = computeScale()
		end)

	local content = new("Frame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Parent = card,
	})
	new("UIPadding", {
		PaddingTop = UDim.new(0, 14),
		PaddingBottom = UDim.new(0, 14),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
		Parent = content,
	})
	new("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 10),
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
		Padding = UDim.new(0, 10),
		Parent = header,
	})

	if options.ShowLogo ~= false then
		local logo = new("Frame", {
			LayoutOrder = 1,
			Size = UDim2.fromOffset(30, 30),
			BackgroundColor3 = T.White,
			BorderSizePixel = 0,
			Parent = header,
		})
		addCorner(logo, 9)
		new("UIGradient", {
			Rotation = 135,
			Color = ColorSequence.new(Color3.fromRGB(56, 34, 104), Color3.fromRGB(20, 13, 38)),
			Parent = logo,
		})
		addStroke(logo, T.Accent, 1, 0.5)
		new("ImageLabel", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(18, 18),
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
	new("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder, Parent = textColumn })

	local titleLabel = label({
		LayoutOrder = 1,
		Size = UDim2.new(1, 0, 0, 16),
		Text = titleText,
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextColor3 = T.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Parent = textColumn,
	})
	self._TitleLabel = titleLabel

	if options.Subtitle then
		self._SubtitleLabel = label({
			LayoutOrder = 2,
			Size = UDim2.new(1, 0, 0, 12),
			Text = options.Subtitle,
			Font = Enum.Font.GothamMedium,
			TextSize = 10,
			TextColor3 = T.Muted,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextTruncate = Enum.TextTruncate.AtEnd,
			Parent = textColumn,
		})
	end

	local minimizeBtn = makeIconButton(header, 3)
	local chevronHolder = new("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(16, 16),
		BackgroundTransparency = 1,
		Parent = minimizeBtn,
	})
	drawChevronIcon(chevronHolder, T.Muted)

	local closeBtn
	if options.Closable ~= false then
		closeBtn = makeIconButton(header, 4)
		local closeIconHolder = new("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromOffset(16, 16),
			BackgroundTransparency = 1,
			Parent = closeBtn,
		})
		drawCloseIcon(closeIconHolder, T.Muted)
	end

	local divider = new("Frame", {
		LayoutOrder = 2,
		Size = UDim2.new(1, 0, 0, 1),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.9,
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
		Padding = UDim.new(0, 8),
		Parent = scrollFrame,
	})

	self._ScrollFrame = scrollFrame
	self._Layout = listLayout
	self._Container = scrollFrame
	self._Divider = divider

	local collapsed = false
	minimizeBtn.MouseButton1Click:Connect(function()
		collapsed = not collapsed
		divider.Visible = not collapsed
		scrollFrame.Visible = not collapsed
		tween(chevronHolder, 0.25, { Rotation = collapsed and 180 or 0 })
	end)

	if closeBtn then
		closeBtn.MouseButton1Click:Connect(function()
			self:Destroy()
		end)
	end

	makeDraggable(main, header)

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
		Size = UDim2.new(1, 0, 0, 44),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.94,
		BorderSizePixel = 0,
		Parent = window._Container,
	})
	window._order += 1
	addCorner(row, 10)
	local stroke = addStroke(row, T.White, 1, 0.92)

	label({
		Position = UDim2.fromOffset(12, 7),
		Size = UDim2.new(1, -24, 0, 13),
		Text = string.upper(title),
		Font = Enum.Font.GothamMedium,
		TextSize = 10,
		TextColor3 = T.Muted,
		TextXAlignment = align,
		Parent = row,
	})
	local valueLabel = label({
		Position = UDim2.fromOffset(12, 21),
		Size = UDim2.new(1, -24, 0, 17),
		Text = tostring(value),
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = color or T.AccentSoft,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = align,
		Parent = row,
	})

	row.MouseEnter:Connect(function()
		tween(row, 0.15, { BackgroundTransparency = 0.88 })
		tween(stroke, 0.15, { Transparency = 0.8 })
	end)
	row.MouseLeave:Connect(function()
		tween(row, 0.15, { BackgroundTransparency = 0.94 })
		tween(stroke, 0.15, { Transparency = 0.92 })
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
		Size = UDim2.new(1, 0, 0, 20),
		BackgroundTransparency = 1,
		Parent = window._Container,
	})
	window._order += 1

	if alignEnum == Enum.TextXAlignment.Left then
		local tick = new("Frame", {
			AnchorPoint = Vector2.new(0, 0.5),
			Position = UDim2.new(0, 0, 0.5, 0),
			Size = UDim2.fromOffset(3, 12),
			BackgroundColor3 = T.Accent,
			BorderSizePixel = 0,
			Parent = row,
		})
		addCorner(tick, 2)
	end

	label({
		Position = alignEnum == Enum.TextXAlignment.Left and UDim2.fromOffset(11, 0) or UDim2.fromOffset(0, 0),
		Size = alignEnum == Enum.TextXAlignment.Left and UDim2.new(1, -11, 1, 0) or UDim2.new(1, 0, 1, 0),
		Text = string.upper(text),
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = T.Muted,
		TextXAlignment = alignEnum,
		Parent = row,
	})

	window:_Resize()
end

function UiLibrary:AddDivider()
	local window = self

	local holder = new("Frame", {
		LayoutOrder = window._order,
		Size = UDim2.new(1, 0, 0, 9),
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
		Size = UDim2.new(1, 0, 0, 34),
		BackgroundColor3 = T.Accent,
		BackgroundTransparency = 0.85,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		Parent = window._Container,
	})
	window._order += 1
	addCorner(btn, 9)
	local stroke = addStroke(btn, T.Accent, 1, 0.55)
	local scale = new("UIScale", { Scale = 1, Parent = btn })

	local lbl = label({
		Size = UDim2.fromScale(1, 1),
		Text = text,
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
		TextColor3 = textColor or T.Text,
		Parent = btn,
	})

	btn.MouseEnter:Connect(function()
		tween(btn, 0.15, { BackgroundTransparency = 0.7 })
		tween(stroke, 0.15, { Transparency = 0.25 })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, 0.15, { BackgroundTransparency = 0.85 })
		tween(stroke, 0.15, { Transparency = 0.55 })
	end)
	btn.MouseButton1Down:Connect(function()
		tween(scale, 0.1, { Scale = 0.97 })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(scale, 0.12, { Scale = 1 })
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
		tween(btn, 0.15, { BackgroundTransparency = state and 0.85 or 0.94 })
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
	if self._ScaleConnection then
		self._ScaleConnection:Disconnect()
	end
	if self._Gui then
		self._Gui:Destroy()
	end
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
