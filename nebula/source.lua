--[[
	NebulaUI
	A modern, dark, premium UI Library for Roblox.

	--------------------------------------------------------------------------
	OVERVIEW
	--------------------------------------------------------------------------
	NebulaUI is organized into clearly separated internal systems, all living
	inside this single ModuleScript so it can be distributed and required as
	one file:

		Theme            - color / spacing / radius / typography tokens
		Icons            - swappable icon-name -> asset-id registry
		Utilities        - instance creation, tweening, dragging, helpers
		ScaleManager     - responsive scaling (manual Scale + viewport based)
		Animator         - centralized TweenService wrapper + speed presets
		Tooltip          - hover tooltips for icon-only elements (PC only)
		Notifications    - toast notification system
		Search           - global fuzzy-ish search across tabs/components
		Components       - Button, Toggle, Dropdown, Slider, ColorPicker,
		                   Paragraph, Title, Section, Divider
		Tab              - a single tab's content + right-nav entry
		Window           - the main application window (top bar, right nav,
		                   Welcome tab, About tab)
		NebulaUI (root)  - public entry point: CreateWindow, SetTheme, etc.

	--------------------------------------------------------------------------
	QUICK START
	--------------------------------------------------------------------------
		local NebulaUI = require(path.to.NebulaUI)

		local Window = NebulaUI:CreateWindow({
			Title = "My UI",
			Subtitle = "Modern Roblox Interface",
			Logo = "rbxassetid://0",
			Scale = 1,
		})

		local Welcome = Window:CreateWelcomeTab()

		local Combat = Window:CreateTab({ Title = "Combat", Icon = "sword" })
		Combat:CreateToggle({ Title = "Enable Feature", Callback = function(v) end })

	See NebulaUI-Example.lua for a complete, realistic usage example.

	--------------------------------------------------------------------------
	NOTES / HONEST LIMITATIONS (read before shipping)
	--------------------------------------------------------------------------
	- Icon asset ids in Icons.Defaults below are placeholders ("rbxassetid://0").
	  Roblox doesn't have a universal built-in icon font, so real icon packs
	  (e.g. Lucide-for-Roblox) ship their own numeric asset ids. Wire your pack
	  in with Library:RegisterIcon(name, id) or Library:RegisterIcons(table)
	  rather than trusting hard-coded ids that may not resolve for you.
	- "Maximize / Restore" is emulated by tweening the window's own Size —
	  Roblox has no real OS-level window manager, so this is the standard
	  approach every Roblox UI library uses.
	- "Friends currently playing" uses Player:GetFriendsOnline() where
	  available and fails soft (shows "—") if the API is unavailable in your
	  execution context, since Roblox has tightened this API over time.
	- Opening Discord/external links uses GuiService:OpenBrowserWindowAsync
	  where available and falls back to copying the link to the user via a
	  notification, since not every Roblox context allows direct navigation.
--]]

local NebulaUI = {}
NebulaUI.__index = NebulaUI
NebulaUI._VERSION = "1.0.0"

--============================================================================
-- SERVICES
--============================================================================
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local TextService = game:GetService("TextService")
local GuiService = game:GetService("GuiService")

local LocalPlayer = Players.LocalPlayer

--============================================================================
-- DESIGN TOKENS
--============================================================================
local Theme = {
	Background = Color3.fromRGB(15, 15, 18),
	Surface = Color3.fromRGB(21, 21, 26),
	SurfaceLight = Color3.fromRGB(27, 27, 33),
	Elevated = Color3.fromRGB(32, 32, 39),
	Border = Color3.fromRGB(52, 52, 60),
	Accent = Color3.fromRGB(150, 100, 255),
	AccentDark = Color3.fromRGB(120, 78, 210),
	Text = Color3.fromRGB(245, 245, 247),
	TextSecondary = Color3.fromRGB(158, 158, 168),
	TextDisabled = Color3.fromRGB(92, 92, 100),
	Success = Color3.fromRGB(84, 200, 128),
	Warning = Color3.fromRGB(238, 179, 68),
	Error = Color3.fromRGB(235, 92, 92),
	Hover = Color3.fromRGB(36, 36, 43),
	Pressed = Color3.fromRGB(18, 18, 22),
}

local Spacing = { xs = 4, sm = 8, md = 12, lg = 16, xl = 24 }

local Radius = { sm = 6, md = 8, lg = 12, xl = 16, full = 999 }

local Typography = {
	Title = 20,
	Subtitle = 13,
	Body = 14,
	Small = 12,
	Tiny = 11,
	Font = Enum.Font.GothamMedium,
	FontBold = Enum.Font.GothamBold,
	FontRegular = Enum.Font.Gotham,
}

local ComponentHeight = 36

local Breakpoints = {
	Mobile = 700,
	Tablet = 1000,
}

local Config = {
	AnimationSpeed = "Normal",
	TabMode = "IconAndText", -- "Icon" | "IconAndText"
	NotificationCorner = "TopRight",
}

--============================================================================
-- ICONS (swappable icon provider)
--============================================================================
local Icons = {}
Icons.Fallback = "rbxassetid://0"
Icons.Defaults = {
	home = "rbxassetid://0",
	sword = "rbxassetid://0",
	eye = "rbxassetid://0",
	user = "rbxassetid://0",
	settings = "rbxassetid://0",
	info = "rbxassetid://0",
	search = "rbxassetid://0",
	palette = "rbxassetid://0",
	close = "rbxassetid://0",
	minimize = "rbxassetid://0",
	maximize = "rbxassetid://0",
	restore = "rbxassetid://0",
	chevronDown = "rbxassetid://0",
	check = "rbxassetid://0",
	discord = "rbxassetid://0",
	book = "rbxassetid://0",
	github = "rbxassetid://0",
	x = "rbxassetid://0",
	warning = "rbxassetid://0",
	error = "rbxassetid://0",
	success = "rbxassetid://0",
}
Icons.Registry = setmetatable({}, { __index = Icons.Defaults })

function Icons.Register(name, assetId)
	Icons.Registry[name] = assetId
end

function Icons.RegisterMany(map)
	for name, id in pairs(map) do
		Icons.Registry[name] = id
	end
end

function Icons.Get(nameOrId)
	if not nameOrId then
		return Icons.Fallback
	end
	if type(nameOrId) == "string" and nameOrId:sub(1, 13) == "rbxassetid://" then
		return nameOrId
	end
	return Icons.Registry[nameOrId] or Icons.Fallback
end

--============================================================================
-- UTILITIES
--============================================================================
local Utilities = {}

function Utilities.Create(className, props, children)
	local inst = Instance.new(className)
	if props then
		for key, value in pairs(props) do
			inst[key] = value
		end
	end
	if children then
		for _, child in ipairs(children) do
			child.Parent = inst
		end
	end
	return inst
end

function Utilities.Corner(instance, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius or Radius.md)
	corner.Parent = instance
	return corner
end

function Utilities.Stroke(instance, color, thickness, transparency)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Theme.Border
	stroke.Thickness = thickness or 1
	stroke.Transparency = transparency or 0
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Parent = instance
	return stroke
end

function Utilities.Padding(instance, all, top, bottom, left, right)
	local pad = Instance.new("UIPadding")
	pad.PaddingTop = UDim.new(0, top or all or 0)
	pad.PaddingBottom = UDim.new(0, bottom or all or 0)
	pad.PaddingLeft = UDim.new(0, left or all or 0)
	pad.PaddingRight = UDim.new(0, right or all or 0)
	pad.Parent = instance
	return pad
end

function Utilities.ListLayout(instance, direction, gap, alignH, alignV)
	local layout = Instance.new("UIListLayout")
	layout.FillDirection = direction or Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, gap or Spacing.sm)
	layout.HorizontalAlignment = alignH or Enum.HorizontalAlignment.Left
	layout.VerticalAlignment = alignV or Enum.VerticalAlignment.Top
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = instance
	return layout
end

function Utilities.Round(number, decimals)
	local mult = 10 ^ (decimals or 0)
	return math.floor(number * mult + 0.5) / mult
end

function Utilities.Clamp(value, min, max)
	return math.max(min, math.min(max, value))
end

function Utilities.IsMobile()
	local touch = UserInputService.TouchEnabled
	local mouse = UserInputService.MouseEnabled
	local keyboard = UserInputService.KeyboardEnabled
	if touch and not mouse and not keyboard then
		return true
	end
	if touch and not mouse then
		return true
	end
	return false
end

function Utilities.MakeDraggable(dragHandle, target, onDragStart, onDragEnd)
	local dragging = false
	local dragStart
	local startPos

	local function update(input)
		local delta = input.Position - dragStart
		target.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end

	dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			if onDragStart then
				onDragStart()
			end

			local changedConn
			changedConn = input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
					if onDragEnd then
						onDragEnd()
					end
					if changedConn then
						changedConn:Disconnect()
					end
				end
			end)
		end
	end)

	dragHandle.InputChanged:Connect(function(input)
		if dragging
			and (input.UserInputType == Enum.UserInputType.MouseMovement
				or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
end

function Utilities.HexToColor3(hex)
	hex = hex:gsub("#", "")
	if #hex ~= 6 then
		return nil
	end
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	if not (r and g and b) then
		return nil
	end
	return Color3.fromRGB(r, g, b)
end

function Utilities.Color3ToHex(color)
	local r = math.floor(color.R * 255 + 0.5)
	local g = math.floor(color.G * 255 + 0.5)
	local b = math.floor(color.B * 255 + 0.5)
	return string.format("%02X%02X%02X", r, g, b)
end

function Utilities.SafeCallback(fn, ...)
	if not fn then
		return
	end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[NebulaUI] Callback error: " .. tostring(err))
	end
end

-- Scrolls the nearest ancestor ScrollingFrame so guiObject is centered in
-- view. Used by the search system to jump to a selected component.
function Utilities.ScrollIntoView(guiObject)
	local scroller = guiObject:FindFirstAncestorWhichIsA("ScrollingFrame")
	if not scroller then
		return
	end
	local relativeY = (guiObject.AbsolutePosition.Y - scroller.AbsolutePosition.Y) + scroller.CanvasPosition.Y
	local targetY = math.max(0, relativeY - (scroller.AbsoluteSize.Y / 2) + (guiObject.AbsoluteSize.Y / 2))
	Animator.Tween(scroller, { CanvasPosition = Vector2.new(scroller.CanvasPosition.X, targetY) }, 0.25)
end

--============================================================================
-- ANIMATOR (centralized TweenService wrapper + speed presets)
--============================================================================
local Animator = {}
Animator.Presets = { Fast = 0.12, Normal = 0.18, Slow = 0.32 }

function Animator.Duration()
	return Animator.Presets[Config.AnimationSpeed] or Animator.Presets.Normal
end

function Animator.Tween(instance, props, duration, style, direction)
	local info = TweenInfo.new(
		duration or Animator.Duration(),
		style or Enum.EasingStyle.Quint,
		direction or Enum.EasingDirection.Out
	)
	local tween = TweenService:Create(instance, info, props)
	tween:Play()
	return tween
end

function Animator.Spring(instance, props)
	return Animator.Tween(instance, props, Animator.Duration(), Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

--============================================================================
-- SCALE MANAGER (responsive scaling: manual Scale + viewport adaptation)
--============================================================================
local ScaleManager = {}
ScaleManager.ManualScale = 1
ScaleManager.MinFactor = 0.62
ScaleManager.MaxFactor = 1.15
ScaleManager.UIScaleInstance = nil
ScaleManager._connection = nil

function ScaleManager.ComputeFactor(viewportSize)
	local w, h = viewportSize.X, viewportSize.Y
	local reference = 1280
	local factor = math.min(w, reference) / reference

	if w <= Breakpoints.Mobile then
		factor = math.max(factor, 0.72)
	elseif w <= Breakpoints.Tablet then
		factor = math.max(factor, 0.85)
	end

	if h < 500 then
		factor = factor * 0.9
	end

	factor = factor * ScaleManager.ManualScale
	return Utilities.Clamp(factor, ScaleManager.MinFactor, ScaleManager.MaxFactor)
end

function ScaleManager.Init(uiScaleInstance, camera)
	ScaleManager.UIScaleInstance = uiScaleInstance
	camera = camera or workspace.CurrentCamera

	local function refresh()
		if not camera then
			return
		end
		local factor = ScaleManager.ComputeFactor(camera.ViewportSize)
		uiScaleInstance.Scale = factor
	end

	refresh()

	if ScaleManager._connection then
		ScaleManager._connection:Disconnect()
	end
	if camera then
		ScaleManager._connection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(refresh)
	end

	return refresh
end

function ScaleManager.SetManualScale(value)
	ScaleManager.ManualScale = Utilities.Clamp(value, 0.5, 1.5)
	if ScaleManager.UIScaleInstance and workspace.CurrentCamera then
		ScaleManager.UIScaleInstance.Scale = ScaleManager.ComputeFactor(workspace.CurrentCamera.ViewportSize)
	end
end

function ScaleManager.Destroy()
	if ScaleManager._connection then
		ScaleManager._connection:Disconnect()
		ScaleManager._connection = nil
	end
end

--============================================================================
-- TOOLTIP SYSTEM (PC only — never blocks touch interaction on mobile)
--============================================================================
local Tooltip = {}
Tooltip.Host = nil
Tooltip.Label = nil
Tooltip.Desc = nil

function Tooltip.Init(screenGui)
	local host = Utilities.Create("Frame", {
		Name = "TooltipHost",
		BackgroundColor3 = Theme.Elevated,
		BorderSizePixel = 0,
		Visible = false,
		ZIndex = 1000,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.new(0, 0, 0, 0),
	}, {
		Utilities.Create("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 2),
		}),
	})
	Utilities.Corner(host, Radius.sm)
	Utilities.Stroke(host, Theme.Border, 1, 0.4)
	Utilities.Padding(host, Spacing.sm)

	local title = Utilities.Create("TextLabel", {
		Name = "Title",
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Small,
		TextColor3 = Theme.Text,
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 1,
	})
	local desc = Utilities.Create("TextLabel", {
		Name = "Description",
		BackgroundTransparency = 1,
		Font = Typography.FontRegular,
		TextSize = Typography.Tiny,
		TextColor3 = Theme.TextSecondary,
		Text = "",
		AutomaticSize = Enum.AutomaticSize.XY,
		LayoutOrder = 2,
		Visible = false,
	})
	title.Parent = host
	desc.Parent = host
	host.Parent = screenGui

	Tooltip.Host = host
	Tooltip.Label = title
	Tooltip.Desc = desc
end

function Tooltip.Show(text, description, guiObject)
	if not Tooltip.Host or Utilities.IsMobile() then
		return
	end
	Tooltip.Label.Text = text or ""
	if description and description ~= "" then
		Tooltip.Desc.Text = description
		Tooltip.Desc.Visible = true
	else
		Tooltip.Desc.Visible = false
	end

	local mouse = UserInputService:GetMouseLocation()
	Tooltip.Host.Position = UDim2.new(0, mouse.X + 16, 0, mouse.Y + 16)
	Tooltip.Host.Visible = true
	Tooltip.Host.BackgroundTransparency = 1
	Animator.Tween(Tooltip.Host, { BackgroundTransparency = 0 }, 0.1)
end

function Tooltip.Hide()
	if Tooltip.Host then
		Tooltip.Host.Visible = false
	end
end

function Tooltip.Attach(guiObject, text, description)
	if Utilities.IsMobile() then
		return
	end
	guiObject.MouseEnter:Connect(function()
		Tooltip.Show(text, description, guiObject)
	end)
	guiObject.MouseMoved:Connect(function(x, y)
		if Tooltip.Host and Tooltip.Host.Visible then
			Tooltip.Host.Position = UDim2.new(0, x + 16, 0, y + 16)
		end
	end)
	guiObject.MouseLeave:Connect(function()
		Tooltip.Hide()
	end)
end

--============================================================================
-- NOTIFICATION SYSTEM
--============================================================================
local Notifications = {}
Notifications.Container = nil

local NotifyColors = {
	Success = Theme.Success,
	Warning = Theme.Warning,
	Error = Theme.Error,
	Information = Theme.Accent,
}
local NotifyIcons = {
	Success = "success",
	Warning = "warning",
	Error = "error",
	Information = "info",
}

function Notifications.Init(screenGui, corner)
	local anchorRight = corner == nil or corner == "TopRight" or corner == "BottomRight"
	local anchorTop = corner == nil or corner == "TopRight" or corner == "TopLeft"

	local container = Utilities.Create("Frame", {
		Name = "NotificationContainer",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 320, 1, -32),
		Position = UDim2.new(anchorRight and 1 or 0, anchorRight and -336 or 16, anchorTop and 0 or 0, 16),
		ZIndex = 500,
	})
	Utilities.ListLayout(
		container,
		Enum.FillDirection.Vertical,
		Spacing.sm,
		Enum.HorizontalAlignment.Center,
		anchorTop and Enum.VerticalAlignment.Top or Enum.VerticalAlignment.Bottom
	)
	container.Parent = screenGui
	Notifications.Container = container
end

function Notifications.Notify(config)
	config = config or {}
	if not Notifications.Container then
		return
	end

	local kind = config.Type or "Information"
	local color = NotifyColors[kind] or Theme.Accent
	local duration = config.Duration or 4

	local card = Utilities.Create("Frame", {
		Name = "Notification",
		BackgroundColor3 = Theme.Elevated,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		ZIndex = 501,
	})
	Utilities.Corner(card, Radius.md)
	Utilities.Stroke(card, Theme.Border, 1, 0.3)
	Utilities.Padding(card, Spacing.md)

	local accentBar = Utilities.Create("Frame", {
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
		ZIndex = 502,
	})
	Utilities.Corner(accentBar, Radius.full)
	accentBar.Parent = card

	local row = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 502,
	})
	Utilities.ListLayout(row, Enum.FillDirection.Horizontal, Spacing.sm, Enum.HorizontalAlignment.Left)
	row.Parent = card

	local iconHolder = Utilities.Create("Frame", {
		BackgroundColor3 = color,
		BackgroundTransparency = 0.85,
		Size = UDim2.new(0, 26, 0, 26),
		ZIndex = 503,
	})
	Utilities.Corner(iconHolder, Radius.sm)
	local iconImg = Utilities.Create("ImageLabel", {
		BackgroundTransparency = 1,
		Image = Icons.Get(NotifyIcons[kind]),
		ImageColor3 = color,
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(0.5, -7, 0.5, -7),
		ZIndex = 504,
	})
	iconImg.Parent = iconHolder
	iconHolder.Parent = row

	local textCol = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -50, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 502,
	})
	Utilities.ListLayout(textCol, Enum.FillDirection.Vertical, 2)
	local titleLbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Body,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Title or "Notification",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		ZIndex = 502,
	})
	local contentLbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontRegular,
		TextSize = Typography.Small,
		TextColor3 = Theme.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Content or "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
		ZIndex = 502,
	})
	titleLbl.Parent = textCol
	contentLbl.Parent = textCol
	textCol.Parent = row

	local closeBtn = Utilities.Create("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(0, 18, 0, 18),
		ZIndex = 503,
	})
	local closeIcon = Utilities.Create("ImageLabel", {
		BackgroundTransparency = 1,
		Image = Icons.Get("close"),
		ImageColor3 = Theme.TextSecondary,
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 504,
	})
	closeIcon.Parent = closeBtn
	closeBtn.Parent = row

	local progress = Utilities.Create("Frame", {
		BackgroundColor3 = color,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 2),
		Position = UDim2.new(0, 0, 1, -2),
		AnchorPoint = Vector2.new(0, 0),
		ZIndex = 503,
	})
	progress.Parent = card

	card.Parent = Notifications.Container

	Animator.Tween(card, { BackgroundTransparency = 0 }, Animator.Duration())

	local removed = false
	local function remove()
		if removed then
			return
		end
		removed = true
		local tween = Animator.Tween(card, { BackgroundTransparency = 1 }, Animator.Duration())
		tween.Completed:Connect(function()
			card:Destroy()
		end)
	end

	closeBtn.MouseButton1Click:Connect(remove)

	if duration and duration > 0 then
		Animator.Tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear)
		task.delay(duration, remove)
	end

	return { Destroy = remove }
end

--============================================================================
-- SEARCH SYSTEM
--============================================================================
local Search = {}
Search.Registry = {}
Search.PopoverFrame = nil
Search.ResultsHolder = nil
Search.Input = nil
Search.OnNavigate = nil -- set by Window; function(entry)

function Search.Register(entry)
	-- entry: { Name, Description, TabName, Icon, GuiObject, OnSelect }
	table.insert(Search.Registry, entry)
end

function Search.Unregister(guiObject)
	for i = #Search.Registry, 1, -1 do
		if Search.Registry[i].GuiObject == guiObject then
			table.remove(Search.Registry, i)
		end
	end
end

function Search.Query(text)
	text = (text or ""):lower()
	if text == "" then
		return {}
	end
	local results = {}
	for _, entry in ipairs(Search.Registry) do
		local haystack = ((entry.Name or "") .. " " .. (entry.Description or "") .. " " .. (entry.TabName or "")):lower()
		if haystack:find(text, 1, true) then
			table.insert(results, entry)
		end
	end
	return results
end

function Search.Init(screenGui, anchorButton)
	local popover = Utilities.Create("Frame", {
		Name = "SearchPopover",
		BackgroundColor3 = Theme.Elevated,
		Visible = false,
		Size = UDim2.new(0, 320, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 900,
		ClipsDescendants = true,
	})
	Utilities.Corner(popover, Radius.lg)
	Utilities.Stroke(popover, Theme.Border, 1, 0.2)

	local inputHolder = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 44),
	})
	Utilities.Padding(inputHolder, Spacing.sm)
	local input = Utilities.Create("TextBox", {
		BackgroundColor3 = Theme.SurfaceLight,
		Font = Typography.FontRegular,
		TextSize = Typography.Body,
		TextColor3 = Theme.Text,
		PlaceholderText = "Search tabs and components...",
		PlaceholderColor3 = Theme.TextDisabled,
		Text = "",
		ClearTextOnFocus = false,
		Size = UDim2.new(1, 0, 1, 0),
	})
	Utilities.Corner(input, Radius.sm)
	Utilities.Padding(input, 0, 0, 0, Spacing.sm, Spacing.sm)
	input.Parent = inputHolder
	inputHolder.Parent = popover

	local resultsHolder = Utilities.Create("ScrollingFrame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = Theme.Border,
	})
	local maxHeight = 260
	resultsHolder.Size = UDim2.new(1, 0, 0, 0)
	Utilities.ListLayout(resultsHolder, Enum.FillDirection.Vertical, 2)
	Utilities.Padding(resultsHolder, Spacing.xs, 0, Spacing.sm, Spacing.sm, Spacing.sm)
	resultsHolder.Parent = popover

	popover.Parent = screenGui
	Search.PopoverFrame = popover
	Search.ResultsHolder = resultsHolder
	Search.Input = input

	local function clearResults()
		for _, child in ipairs(resultsHolder:GetChildren()) do
			if child:IsA("GuiObject") then
				child:Destroy()
			end
		end
	end

	local function renderResults(results)
		clearResults()
		if #results == 0 then
			local empty = Utilities.Create("TextLabel", {
				BackgroundTransparency = 1,
				Font = Typography.FontRegular,
				TextSize = Typography.Small,
				TextColor3 = Theme.TextDisabled,
				Text = input.Text == "" and "Start typing to search..." or "No results found.",
				Size = UDim2.new(1, 0, 0, 32),
			})
			empty.Parent = resultsHolder
			resultsHolder.Size = UDim2.new(1, 0, 0, 32)
			return
		end
		local count = math.min(#results, 6)
		resultsHolder.Size = UDim2.new(1, 0, 0, math.min(count * 40, maxHeight))
		for _, entry in ipairs(results) do
			local row = Utilities.Create("TextButton", {
				BackgroundColor3 = Theme.Hover,
				BackgroundTransparency = 1,
				Text = "",
				Size = UDim2.new(1, 0, 0, 36),
				AutoButtonColor = false,
			})
			Utilities.Corner(row, Radius.sm)
			local icon = Utilities.Create("ImageLabel", {
				BackgroundTransparency = 1,
				Image = Icons.Get(entry.Icon),
				ImageColor3 = Theme.TextSecondary,
				Size = UDim2.new(0, 16, 0, 16),
				Position = UDim2.new(0, 10, 0.5, -8),
			})
			icon.Parent = row
			local nameLbl = Utilities.Create("TextLabel", {
				BackgroundTransparency = 1,
				Font = Typography.Font,
				TextSize = Typography.Small,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = entry.Name or "",
				Position = UDim2.new(0, 34, 0, 0),
				Size = UDim2.new(1, -100, 1, 0),
			})
			nameLbl.Parent = row
			local tabLbl = Utilities.Create("TextLabel", {
				BackgroundTransparency = 1,
				Font = Typography.FontRegular,
				TextSize = Typography.Tiny,
				TextColor3 = Theme.TextDisabled,
				TextXAlignment = Enum.TextXAlignment.Right,
				Text = entry.TabName or "",
				Position = UDim2.new(1, -70, 0, 0),
				Size = UDim2.new(0, 60, 1, 0),
			})
			tabLbl.Parent = row

			row.MouseEnter:Connect(function()
				Animator.Tween(row, { BackgroundTransparency = 0 }, 0.1)
			end)
			row.MouseLeave:Connect(function()
				Animator.Tween(row, { BackgroundTransparency = 1 }, 0.1)
			end)
			row.MouseButton1Click:Connect(function()
				if entry.OnSelect then
					entry.OnSelect()
				end
				Search.Close()
			end)
			row.Parent = resultsHolder
		end
	end

	input:GetPropertyChangedSignal("Text"):Connect(function()
		renderResults(Search.Query(input.Text))
	end)

	renderResults({})

	UserInputService.InputBegan:Connect(function(inputObj, processed)
		if not Search.PopoverFrame.Visible then
			return
		end
		if inputObj.UserInputType == Enum.UserInputType.MouseButton1 or inputObj.UserInputType == Enum.UserInputType.Touch then
			local mousePos = UserInputService:GetMouseLocation()
			local absPos, absSize = popover.AbsolutePosition, popover.AbsoluteSize
			local btnPos, btnSize = anchorButton.AbsolutePosition, anchorButton.AbsoluteSize
			local insidePopover = mousePos.X >= absPos.X and mousePos.X <= absPos.X + absSize.X
				and mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + absSize.Y
			local insideButton = mousePos.X >= btnPos.X and mousePos.X <= btnPos.X + btnSize.X
				and mousePos.Y >= btnPos.Y and mousePos.Y <= btnPos.Y + btnSize.Y
			if not insidePopover and not insideButton then
				Search.Close()
			end
		end
	end)
end

function Search.Open()
	if not Search.PopoverFrame then
		return
	end
	Search.PopoverFrame.Visible = true
	Search.Input.Text = ""
	Search.Input:CaptureFocus()
end

function Search.Close()
	if Search.PopoverFrame then
		Search.PopoverFrame.Visible = false
	end
end

function Search.Toggle()
	if Search.PopoverFrame and Search.PopoverFrame.Visible then
		Search.Close()
	else
		Search.Open()
	end
end

function Search.Highlight(guiObject)
	local stroke = guiObject:FindFirstChildOfClass("UIStroke")
	local created = false
	if not stroke then
		stroke = Utilities.Stroke(guiObject, Theme.Accent, 2, 0)
		created = true
	end
	local originalColor = stroke.Color
	local originalThickness = stroke.Thickness
	stroke.Color = Theme.Accent
	stroke.Thickness = 2
	stroke.Transparency = 0
	task.delay(1.2, function()
		if stroke and stroke.Parent then
			Animator.Tween(stroke, { Transparency = created and 1 or 0.7 }, 0.4)
			if not created then
				stroke.Color = originalColor
				stroke.Thickness = originalThickness
			end
		end
	end)
end

--============================================================================
-- COMPONENTS
--============================================================================
local Components = {}

-- Shared: a component "row" wrapper with Title + optional Description on the
-- left, used by Button / Toggle / Dropdown / ColorPicker / Slider.
local function baseRow(parent, config, controlWidth)
	local row = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(1, 0, 0, ComponentHeight + (config.Description and 16 or 0)),
		LayoutOrder = config.Order or 0,
	})
	Utilities.Corner(row, Radius.md)
	Utilities.Stroke(row, Theme.Border, 1, 0.5)
	Utilities.Padding(row, 0, Spacing.sm, Spacing.sm, Spacing.md, Spacing.md)

	local textCol = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -(controlWidth + Spacing.md), 1, 0),
		Position = UDim2.new(0, 0, 0, 0),
	})
	Utilities.ListLayout(textCol, Enum.FillDirection.Vertical, 2, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)

	local title = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.Font,
		TextSize = Typography.Body,
		TextColor3 = config.Disabled and Theme.TextDisabled or Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Title or "",
		Size = UDim2.new(1, 0, 0, 18),
		AutomaticSize = Enum.AutomaticSize.None,
	})
	title.Parent = textCol

	local desc
	if config.Description then
		desc = Utilities.Create("TextLabel", {
			BackgroundTransparency = 1,
			Font = Typography.FontRegular,
			TextSize = Typography.Small,
			TextColor3 = Theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Description,
			Size = UDim2.new(1, 0, 0, 14),
			TextWrapped = true,
		})
		desc.Parent = textCol
	end

	textCol.Parent = row
	row.Parent = parent

	return row, title, desc
end

--------------------------------------------------------------------
-- BUTTON
--------------------------------------------------------------------
function Components.CreateButton(parent, config)
	config = config or {}
	local controlWidth = 90
	local row, titleLbl = baseRow(parent, config, controlWidth)

	local btn = Utilities.Create("TextButton", {
		BackgroundColor3 = Theme.Accent,
		Text = "Run",
		Font = Typography.FontBold,
		TextSize = Typography.Small,
		TextColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, controlWidth, 0, 28),
		Position = UDim2.new(1, -controlWidth, 0.5, -14),
		AutoButtonColor = false,
	})
	Utilities.Corner(btn, Radius.sm)
	if config.Icon then
		local icon = Utilities.Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Icons.Get(config.Icon),
			ImageColor3 = Color3.new(1, 1, 1),
			Size = UDim2.new(0, 14, 0, 14),
			Position = UDim2.new(0, 8, 0.5, -7),
		})
		icon.Parent = btn
	end
	btn.Parent = row

	local disabled = config.Disabled or false

	local function refreshState()
		btn.BackgroundColor3 = disabled and Theme.SurfaceLight or Theme.Accent
		btn.AutoButtonColor = not disabled
		titleLbl.TextColor3 = disabled and Theme.TextDisabled or Theme.Text
	end
	refreshState()

	btn.MouseEnter:Connect(function()
		if not disabled then
			Animator.Tween(btn, { BackgroundColor3 = Theme.AccentDark }, 0.1)
		end
	end)
	btn.MouseLeave:Connect(function()
		if not disabled then
			Animator.Tween(btn, { BackgroundColor3 = Theme.Accent }, 0.1)
		end
	end)
	btn.MouseButton1Down:Connect(function()
		if not disabled then
			Animator.Tween(btn, { Size = UDim2.new(0, controlWidth - 3, 0, 26) }, 0.06)
		end
	end)
	btn.MouseButton1Up:Connect(function()
		if not disabled then
			Animator.Tween(btn, { Size = UDim2.new(0, controlWidth, 0, 28) }, 0.08)
		end
	end)
	btn.MouseButton1Click:Connect(function()
		if not disabled then
			Utilities.SafeCallback(config.Callback)
		end
	end)

	local api = {}
	function api:SetDisabled(value)
		disabled = value
		refreshState()
	end
	function api:SetTitle(text)
		titleLbl.Text = text
	end
	function api:Destroy()
		row:Destroy()
	end

	Search.Register({
		Name = config.Title,
		Description = config.Description,
		TabName = config.TabName,
		Icon = config.Icon or "check",
		GuiObject = row,
		OnSelect = config.OnNavigate,
	})

	return api
end

--------------------------------------------------------------------
-- DIVIDER
--------------------------------------------------------------------
function Components.CreateDivider(parent, config)
	config = config or {}
	local line = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.6,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		LayoutOrder = config.Order or 0,
	})
	line.Parent = parent
	return { Destroy = function() line:Destroy() end }
end

--------------------------------------------------------------------
-- TITLE
--------------------------------------------------------------------
function Components.CreateTitle(parent, text, config)
	config = config or {}
	local lbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Title,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = text or "",
		Size = UDim2.new(1, 0, 0, 28),
		LayoutOrder = config.Order or 0,
	})
	lbl.Parent = parent
	return {
		Destroy = function() lbl:Destroy() end,
		SetText = function(_, t) lbl.Text = t end,
	}
end

--------------------------------------------------------------------
-- SECTION
--------------------------------------------------------------------
function Components.CreateSection(parent, text, config)
	config = config or {}
	local holder = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 22),
		LayoutOrder = config.Order or 0,
	})
	local bar = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Accent,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 3, 0, 12),
		Position = UDim2.new(0, 0, 0.5, -6),
	})
	Utilities.Corner(bar, Radius.full)
	bar.Parent = holder
	local lbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Small,
		TextColor3 = Theme.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = string.upper(text or ""),
		Position = UDim2.new(0, 12, 0, 0),
		Size = UDim2.new(1, -12, 1, 0),
	})
	lbl.Parent = holder
	holder.Parent = parent
	return { Destroy = function() holder:Destroy() end }
end

--------------------------------------------------------------------
-- PARAGRAPH
--------------------------------------------------------------------
function Components.CreateParagraph(parent, config)
	config = config or {}
	local card = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		LayoutOrder = config.Order or 0,
	})
	Utilities.Corner(card, Radius.md)
	Utilities.Stroke(card, Theme.Border, 1, 0.5)
	Utilities.Padding(card, Spacing.md)
	Utilities.ListLayout(card, Enum.FillDirection.Vertical, 4)

	if config.Title then
		local title = Utilities.Create("TextLabel", {
			BackgroundTransparency = 1,
			Font = Typography.FontBold,
			TextSize = Typography.Body,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Title,
			Size = UDim2.new(1, 0, 0, 18),
		})
		title.Parent = card
	end

	local content = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontRegular,
		TextSize = Typography.Small,
		TextColor3 = Theme.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		Text = config.Content or "",
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		TextWrapped = true,
	})
	content.Parent = card
	card.Parent = parent

	return {
		Destroy = function() card:Destroy() end,
		SetContent = function(_, t) content.Text = t end,
	}
end

--------------------------------------------------------------------
-- TOGGLE  (supports optional `Settings` sub-dialog, per Lucas' Obsidian
-- build: Settings = function(dialog) ... end shows a gear icon that opens
-- a populable dialog with its own toggles/sliders/dropdowns.)
--------------------------------------------------------------------
function Components.CreateToggle(parent, config)
	config = config or {}
	local hasSettings = type(config.Settings) == "function"
	local controlWidth = hasSettings and 66 or 40
	local row, titleLbl = baseRow(parent, config, controlWidth)

	local value = config.Default or false
	local disabled = config.Disabled or false

	local track = Utilities.Create("Frame", {
		BackgroundColor3 = value and Theme.Accent or Theme.SurfaceLight,
		Size = UDim2.new(0, 40, 0, 22),
		Position = UDim2.new(1, -40, 0.5, -11),
	})
	Utilities.Corner(track, Radius.full)
	Utilities.Stroke(track, Theme.Border, 1, 0.5)

	local knob = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 16, 0, 16),
		Position = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
	})
	Utilities.Corner(knob, Radius.full)
	knob.Parent = track

	local clickArea = Utilities.Create("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
	})
	clickArea.Parent = track
	track.Parent = row

	local gearBtn
	if hasSettings then
		gearBtn = Utilities.Create("TextButton", {
			BackgroundColor3 = Theme.SurfaceLight,
			Text = "",
			Size = UDim2.new(0, 22, 0, 22),
			Position = UDim2.new(1, -66, 0.5, -11),
			AutoButtonColor = false,
		})
		Utilities.Corner(gearBtn, Radius.sm)
		local gearIcon = Utilities.Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Icons.Get("settings"),
			ImageColor3 = Theme.TextSecondary,
			Size = UDim2.new(0, 13, 0, 13),
			Position = UDim2.new(0.5, -6.5, 0.5, -6.5),
		})
		gearIcon.Parent = gearBtn
		gearBtn.Parent = row
	end

	local function refresh(animate)
		local trackColor = disabled and Theme.SurfaceLight or (value and Theme.Accent or Theme.SurfaceLight)
		local knobPos = value and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
		if animate then
			Animator.Tween(track, { BackgroundColor3 = trackColor }, Animator.Duration())
			Animator.Spring(knob, { Position = knobPos })
		else
			track.BackgroundColor3 = trackColor
			knob.Position = knobPos
		end
		titleLbl.TextColor3 = disabled and Theme.TextDisabled or Theme.Text
	end

	local function setValue(newValue, fireCallback, animate)
		value = newValue
		refresh(animate ~= false)
		if fireCallback ~= false then
			Utilities.SafeCallback(config.Callback, value)
		end
	end

	clickArea.MouseButton1Click:Connect(function()
		if not disabled then
			setValue(not value, true, true)
		end
	end)

	-- Settings dialog: a floating popover anchored under the gear icon,
	-- populated by the developer-supplied `Settings(dialog)` function using
	-- the same component API (dialog:CreateToggle, dialog:CreateSlider, ...).
	local settingsDialog
	if hasSettings then
		gearBtn.MouseButton1Click:Connect(function()
			if settingsDialog then
				settingsDialog.Toggle()
				return
			end
			settingsDialog = Components.CreateDialog(row, {
				Title = (config.Title or "Settings") .. " Settings",
			})
			config.Settings(settingsDialog.API)
			settingsDialog.Toggle()
		end)
	end

	local api = {}
	function api:GetValue() return value end
	function api:SetValue(newValue) setValue(newValue, false, true) end
	function api:SetDisabled(v) disabled = v; refresh(false) end
	function api:Destroy() row:Destroy() end

	Search.Register({
		Name = config.Title, Description = config.Description, TabName = config.TabName,
		Icon = config.Icon or "check", GuiObject = row, OnSelect = config.OnNavigate,
	})

	return api
end

--------------------------------------------------------------------
-- DIALOG (popover used by Toggle Settings gear, and reusable generally)
--------------------------------------------------------------------
function Components.CreateDialog(anchor, config)
	config = config or {}
	local screenGui = anchor:FindFirstAncestorOfClass("ScreenGui")

	local overlay = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 1, 0),
		Visible = false,
		ZIndex = 800,
	})
	local dismiss = Utilities.Create("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.new(1, 0, 1, 0),
		ZIndex = 800,
	})
	dismiss.Parent = overlay

	local panel = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Elevated,
		Size = UDim2.new(0, 300, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0.5, -150, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ZIndex = 801,
	})
	Utilities.Corner(panel, Radius.lg)
	Utilities.Stroke(panel, Theme.Border, 1, 0.2)
	Utilities.Padding(panel, Spacing.md)

	local header = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Body,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Title or "Settings",
		Size = UDim2.new(1, 0, 0, 24),
		ZIndex = 801,
	})
	header.Parent = panel

	local body = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, 30),
		ZIndex = 801,
	})
	Utilities.ListLayout(body, Enum.FillDirection.Vertical, Spacing.sm)
	body.Parent = panel

	-- Overall panel height auto-grows via body's AutomaticSize; nudge panel too.
	panel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function() end)

	panel.Parent = overlay
	overlay.Parent = screenGui

	local visible = false
	local function setVisible(v)
		visible = v
		overlay.Visible = v
		if v then
			overlay.BackgroundTransparency = 1
			panel.Size = UDim2.new(0, 300, 0, 0)
			Animator.Tween(overlay, { BackgroundTransparency = 0.5 }, Animator.Duration())
			Animator.Spring(panel, { Position = UDim2.new(0.5, -150, 0.5, 0) })
		end
	end
	dismiss.MouseButton1Click:Connect(function() setVisible(false) end)

	local dialogAPI = {}
	function dialogAPI:CreateToggle(cfg) return Components.CreateToggle(body, cfg) end
	function dialogAPI:CreateSlider(cfg) return Components.CreateSlider(body, cfg) end
	function dialogAPI:CreateDropdown(cfg) return Components.CreateDropdown(body, cfg, screenGui) end
	function dialogAPI:CreateButton(cfg) return Components.CreateButton(body, cfg) end
	function dialogAPI:CreateParagraph(cfg) return Components.CreateParagraph(body, cfg) end
	function dialogAPI:CreateDivider(cfg) return Components.CreateDivider(body, cfg) end

	return {
		API = dialogAPI,
		Toggle = function() setVisible(not visible) end,
		Show = function() setVisible(true) end,
		Hide = function() setVisible(false) end,
		Destroy = function() overlay:Destroy() end,
	}
end

--------------------------------------------------------------------
-- SLIDER
--------------------------------------------------------------------
function Components.CreateSlider(parent, config)
	config = config or {}
	local min = config.Min or 0
	local max = config.Max or 100
	local increment = config.Increment or 1
	local value = Utilities.Clamp(config.Default or min, min, max)
	local disabled = config.Disabled or false

	local row = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(1, 0, 0, config.Description and 62 or 50),
		LayoutOrder = config.Order or 0,
	})
	Utilities.Corner(row, Radius.md)
	Utilities.Stroke(row, Theme.Border, 1, 0.5)
	Utilities.Padding(row, 0, Spacing.sm, Spacing.sm, Spacing.md, Spacing.md)

	local titleLbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.Font,
		TextSize = Typography.Body,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Title or "",
		Size = UDim2.new(1, -60, 0, 18),
	})
	titleLbl.Parent = row

	local valueLbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Small,
		TextColor3 = Theme.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Right,
		Text = tostring(value),
		Position = UDim2.new(1, -60, 0, 0),
		Size = UDim2.new(0, 60, 0, 18),
	})
	valueLbl.Parent = row

	local barY = config.Description and 40 or 28
	local barBg = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.SurfaceLight,
		Size = UDim2.new(1, 0, 0, 6),
		Position = UDim2.new(0, 0, 0, barY),
	})
	Utilities.Corner(barBg, Radius.full)

	local function fillWidth()
		return (value - min) / math.max(max - min, 0.0001)
	end

	local fill = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Accent,
		Size = UDim2.new(fillWidth(), 0, 1, 0),
	})
	Utilities.Corner(fill, Radius.full)
	fill.Parent = barBg

	local knob = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 14, 0, 14),
		Position = UDim2.new(fillWidth(), -7, 0.5, -7),
	})
	Utilities.Corner(knob, Radius.full)
	knob.Parent = barBg
	barBg.Parent = row

	if config.Description then
		local desc = Utilities.Create("TextLabel", {
			BackgroundTransparency = 1,
			Font = Typography.FontRegular,
			TextSize = Typography.Small,
			TextColor3 = Theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = config.Description,
			Position = UDim2.new(0, 0, 0, 20),
			Size = UDim2.new(1, 0, 0, 14),
		})
		desc.Parent = row
	end

	local dragging = false

	local function setFromAlpha(alpha)
		alpha = Utilities.Clamp(alpha, 0, 1)
		local raw = min + (max - min) * alpha
		raw = math.floor(raw / increment + 0.5) * increment
		raw = Utilities.Clamp(raw, min, max)
		if raw ~= value then
			value = raw
			valueLbl.Text = tostring(value)
			Utilities.SafeCallback(config.Callback, value)
		end
		fill.Size = UDim2.new(fillWidth(), 0, 1, 0)
		knob.Position = UDim2.new(fillWidth(), -7, 0.5, -7)
	end

	local function beginDrag(input)
		if disabled then return end
		dragging = true
		local rel = (input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X
		setFromAlpha(rel)
	end

	barBg.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local rel = (input.Position.X - barBg.AbsolutePosition.X) / barBg.AbsoluteSize.X
			setFromAlpha(rel)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	row.Parent = parent

	local api = {}
	function api:GetValue() return value end
	function api:SetValue(v)
		value = Utilities.Clamp(v, min, max)
		valueLbl.Text = tostring(value)
		fill.Size = UDim2.new(fillWidth(), 0, 1, 0)
		knob.Position = UDim2.new(fillWidth(), -7, 0.5, -7)
	end
	function api:SetDisabled(v) disabled = v end
	function api:Destroy() row:Destroy() end

	Search.Register({
		Name = config.Title, Description = config.Description, TabName = config.TabName,
		Icon = config.Icon, GuiObject = row, OnSelect = config.OnNavigate,
	})

	return api
end

--------------------------------------------------------------------
-- DROPDOWN  (single or multi select, optional in-list search)
--------------------------------------------------------------------
function Components.CreateDropdown(parent, config, screenGui)
	config = config or {}
	local isMulti = config.Multi or false
	local options = config.Options or {}
	local disabled = config.Disabled or false
	screenGui = screenGui or parent:FindFirstAncestorOfClass("ScreenGui")

	local selected = {}
	if isMulti then
		for _, v in ipairs(config.Default or {}) do
			selected[v] = true
		end
	else
		selected.value = config.Default or options[1]
	end

	local controlWidth = 160
	local row, titleLbl = baseRow(parent, config, controlWidth)

	local function displayText()
		if isMulti then
			local count = 0
			for _ in pairs(selected) do count = count + 1 end
			if count == 0 then return "None" end
			if count == 1 then
				for k in pairs(selected) do return k end
			end
			return count .. " selected"
		end
		return tostring(selected.value or "Select...")
	end

	local box = Utilities.Create("TextButton", {
		BackgroundColor3 = Theme.SurfaceLight,
		Text = "",
		Size = UDim2.new(0, controlWidth, 0, 28),
		Position = UDim2.new(1, -controlWidth, 0.5, -14),
		AutoButtonColor = false,
	})
	Utilities.Corner(box, Radius.sm)
	Utilities.Stroke(box, Theme.Border, 1, 0.4)
	Utilities.Padding(box, 0, 0, 0, Spacing.sm, Spacing.sm)

	local boxLabel = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontRegular,
		TextSize = Typography.Small,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextTruncate = Enum.TextTruncate.AtEnd,
		Text = displayText(),
		Size = UDim2.new(1, -18, 1, 0),
	})
	boxLabel.Parent = box

	local chevron = Utilities.Create("ImageLabel", {
		BackgroundTransparency = 1,
		Image = Icons.Get("chevronDown"),
		ImageColor3 = Theme.TextSecondary,
		Size = UDim2.new(0, 12, 0, 12),
		Position = UDim2.new(1, -14, 0.5, -6),
	})
	chevron.Parent = box
	box.Parent = row

	-- Floating list, parented to the ScreenGui so it renders above everything.
	local list = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Elevated,
		Visible = false,
		Size = UDim2.new(0, controlWidth, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		ZIndex = 700,
		ClipsDescendants = true,
	})
	Utilities.Corner(list, Radius.sm)
	Utilities.Stroke(list, Theme.Border, 1, 0.2)

	local searchBox
	if config.Searchable then
		searchBox = Utilities.Create("TextBox", {
			BackgroundColor3 = Theme.SurfaceLight,
			Font = Typography.FontRegular,
			TextSize = Typography.Small,
			TextColor3 = Theme.Text,
			PlaceholderText = "Search...",
			PlaceholderColor3 = Theme.TextDisabled,
			Text = "",
			ClearTextOnFocus = false,
			Size = UDim2.new(1, -8, 0, 26),
			Position = UDim2.new(0, 4, 0, 4),
		})
		Utilities.Corner(searchBox, Radius.sm)
		Utilities.Padding(searchBox, 0, 0, 0, 6, 6)
		searchBox.Parent = list
	end

	local optionsHolder = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		Position = UDim2.new(0, 0, 0, searchBox and 34 or 4),
	})
	Utilities.ListLayout(optionsHolder, Enum.FillDirection.Vertical, 1)
	Utilities.Padding(optionsHolder, 0, 0, 4, 4, 4)
	optionsHolder.Parent = list

	list.Parent = screenGui

	local optionRows = {}

	local function refreshOptionVisuals()
		for _, entry in ipairs(optionRows) do
			local isSelected = isMulti and selected[entry.value] or (selected.value == entry.value)
			entry.check.Visible = isSelected
			entry.frame.BackgroundTransparency = isSelected and 0.85 or 1
		end
		boxLabel.Text = displayText()
	end

	local function selectOption(value)
		if isMulti then
			selected[value] = not selected[value] or nil
		else
			selected.value = value
		end
		refreshOptionVisuals()
		if isMulti then
			local out = {}
			for k in pairs(selected) do table.insert(out, k) end
			Utilities.SafeCallback(config.Callback, out)
		else
			Utilities.SafeCallback(config.Callback, selected.value)
		end
	end

	local function buildOptions(filter)
		filter = filter and filter:lower() or nil
		for _, entry in ipairs(optionRows) do
			entry.frame:Destroy()
		end
		optionRows = {}
		for _, value in ipairs(options) do
			if not filter or tostring(value):lower():find(filter, 1, true) then
				local optRow = Utilities.Create("TextButton", {
					BackgroundColor3 = Theme.Accent,
					BackgroundTransparency = 1,
					Text = "",
					Size = UDim2.new(1, 0, 0, 30),
					AutoButtonColor = false,
				})
				Utilities.Corner(optRow, Radius.sm)
				local lbl = Utilities.Create("TextLabel", {
					BackgroundTransparency = 1,
					Font = Typography.FontRegular,
					TextSize = Typography.Small,
					TextColor3 = Theme.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					Text = tostring(value),
					Position = UDim2.new(0, 8, 0, 0),
					Size = UDim2.new(1, -26, 1, 0),
				})
				lbl.Parent = optRow
				local check = Utilities.Create("ImageLabel", {
					BackgroundTransparency = 1,
					Image = Icons.Get("check"),
					ImageColor3 = Theme.Accent,
					Visible = false,
					Size = UDim2.new(0, 12, 0, 12),
					Position = UDim2.new(1, -20, 0.5, -6),
				})
				check.Parent = optRow

				optRow.MouseEnter:Connect(function()
					Animator.Tween(optRow, { BackgroundTransparency = 0.85 }, 0.1)
				end)
				optRow.MouseLeave:Connect(function()
					local isSelected = isMulti and selected[value] or (selected.value == value)
					Animator.Tween(optRow, { BackgroundTransparency = isSelected and 0.85 or 1 }, 0.1)
				end)
				optRow.MouseButton1Click:Connect(function()
					selectOption(value)
					if not isMulti then
						list.Visible = false
					end
				end)

				optRow.Parent = optionsHolder
				table.insert(optionRows, { frame = optRow, check = check, value = value })
			end
		end
		refreshOptionVisuals()
	end

	buildOptions(nil)
	if searchBox then
		searchBox:GetPropertyChangedSignal("Text"):Connect(function()
			buildOptions(searchBox.Text ~= "" and searchBox.Text or nil)
		end)
	end

	local function positionList()
		local absPos = box.AbsolutePosition
		local absSize = box.AbsoluteSize
		list.Position = UDim2.new(0, absPos.X, 0, absPos.Y + absSize.Y + 4)
	end

	box.MouseButton1Click:Connect(function()
		if disabled then return end
		list.Visible = not list.Visible
		if list.Visible then
			positionList()
			chevron.Rotation = 180
		else
			chevron.Rotation = 0
		end
	end)

	UserInputService.InputBegan:Connect(function(input)
		if not list.Visible then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local mousePos = UserInputService:GetMouseLocation()
			local function inside(frame)
				local p, s = frame.AbsolutePosition, frame.AbsoluteSize
				return mousePos.X >= p.X and mousePos.X <= p.X + s.X and mousePos.Y >= p.Y and mousePos.Y <= p.Y + s.Y
			end
			if not inside(list) and not inside(box) then
				list.Visible = false
				chevron.Rotation = 0
			end
		end
	end)

	local api = {}
	function api:GetValue()
		if isMulti then
			local out = {}
			for k in pairs(selected) do table.insert(out, k) end
			return out
		end
		return selected.value
	end
	function api:SetValue(v)
		if isMulti then
			selected = {}
			for _, val in ipairs(v) do selected[val] = true end
		else
			selected.value = v
		end
		refreshOptionVisuals()
	end
	function api:SetOptions(newOptions)
		options = newOptions
		buildOptions(nil)
	end
	function api:SetDisabled(v) disabled = v end
	function api:Destroy()
		row:Destroy()
		list:Destroy()
	end

	Search.Register({
		Name = config.Title, Description = config.Description, TabName = config.TabName,
		Icon = config.Icon, GuiObject = row, OnSelect = config.OnNavigate,
	})

	return api
end

--------------------------------------------------------------------
-- COLOR PICKER  (hue slider + saturation/value canvas + RGB/hex + alpha)
--------------------------------------------------------------------
function Components.CreateColorPicker(parent, config, screenGui)
	config = config or {}
	screenGui = screenGui or parent:FindFirstAncestorOfClass("ScreenGui")

	local color = config.Default or Color3.fromRGB(150, 100, 255)
	local transparency = config.Transparency or 0
	local disabled = config.Disabled or false

	local h, s, v = Color3.toHSV(color)

	local controlWidth = 60
	local row = baseRow(parent, config, controlWidth)

	local swatchBtn = Utilities.Create("TextButton", {
		BackgroundColor3 = color,
		Text = "",
		Size = UDim2.new(0, 44, 0, 26),
		Position = UDim2.new(1, -44, 0.5, -13),
		AutoButtonColor = false,
	})
	Utilities.Corner(swatchBtn, Radius.sm)
	Utilities.Stroke(swatchBtn, Theme.Border, 1, 0.3)
	swatchBtn.Parent = row

	-- Floating popover
	local popover = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Elevated,
		Visible = false,
		Size = UDim2.new(0, 240, 0, 320),
		ZIndex = 700,
	})
	Utilities.Corner(popover, Radius.lg)
	Utilities.Stroke(popover, Theme.Border, 1, 0.2)
	Utilities.Padding(popover, Spacing.md)

	-- Saturation/Value canvas
	local svCanvas = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.fromHSV(h, 1, 1),
		Size = UDim2.new(1, 0, 0, 140),
		Position = UDim2.new(0, 0, 0, 0),
		ClipsDescendants = true,
	})
	Utilities.Corner(svCanvas, Radius.sm)

	local whiteGradient = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
	})
	local whiteGrad = Instance.new("UIGradient")
	whiteGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	whiteGrad.Parent = whiteGradient
	whiteGradient.Parent = svCanvas

	local blackGradient = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(0, 0, 0),
		Size = UDim2.new(1, 0, 1, 0),
		BorderSizePixel = 0,
	})
	local blackGrad = Instance.new("UIGradient")
	blackGrad.Rotation = 90
	blackGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0),
	})
	blackGrad.Parent = blackGradient
	blackGradient.Parent = svCanvas

	local svCursor = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 10, 0, 10),
		Position = UDim2.new(s, -5, 1 - v, -5),
		BorderSizePixel = 0,
	})
	Utilities.Corner(svCursor, Radius.full)
	Utilities.Stroke(svCursor, Color3.new(0, 0, 0), 1.5, 0)
	svCursor.Parent = svCanvas
	svCanvas.Parent = popover

	-- Hue bar
	local hueBar = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 0, 150),
	})
	Utilities.Corner(hueBar, Radius.full)
	local hueGrad = Instance.new("UIGradient")
	hueGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.000, Color3.fromHSV(0.00, 1, 1)),
		ColorSequenceKeypoint.new(0.166, Color3.fromHSV(0.166, 1, 1)),
		ColorSequenceKeypoint.new(0.333, Color3.fromHSV(0.333, 1, 1)),
		ColorSequenceKeypoint.new(0.500, Color3.fromHSV(0.500, 1, 1)),
		ColorSequenceKeypoint.new(0.666, Color3.fromHSV(0.666, 1, 1)),
		ColorSequenceKeypoint.new(0.833, Color3.fromHSV(0.833, 1, 1)),
		ColorSequenceKeypoint.new(1.000, Color3.fromHSV(1.00, 1, 1)),
	})
	hueGrad.Parent = hueBar
	local hueCursor = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 6, 0, 20),
		Position = UDim2.new(h, -3, 0.5, -10),
	})
	Utilities.Corner(hueCursor, Radius.sm)
	Utilities.Stroke(hueCursor, Color3.new(0, 0, 0), 1.5, 0)
	hueCursor.Parent = hueBar
	hueBar.Parent = popover

	-- Alpha (transparency) bar
	local alphaBar = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(1, 0, 0, 14),
		Position = UDim2.new(0, 0, 0, 174),
	})
	Utilities.Corner(alphaBar, Radius.full)
	local alphaGrad = Instance.new("UIGradient")
	alphaGrad.Color = ColorSequence.new(color)
	alphaGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	alphaGrad.Parent = alphaBar
	local alphaCursor = Utilities.Create("Frame", {
		BackgroundColor3 = Color3.new(1, 1, 1),
		Size = UDim2.new(0, 6, 0, 20),
		Position = UDim2.new(1 - transparency, -3, 0.5, -10),
	})
	Utilities.Corner(alphaCursor, Radius.sm)
	Utilities.Stroke(alphaCursor, Color3.new(0, 0, 0), 1.5, 0)
	alphaCursor.Parent = alphaBar
	alphaBar.Parent = popover

	-- Hex + RGB inputs
	local inputsRow = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 30),
		Position = UDim2.new(0, 0, 0, 198),
	})
	Utilities.ListLayout(inputsRow, Enum.FillDirection.Horizontal, Spacing.xs)

	local hexBox = Utilities.Create("TextBox", {
		BackgroundColor3 = Theme.SurfaceLight,
		Font = Typography.FontRegular,
		TextSize = Typography.Small,
		TextColor3 = Theme.Text,
		Text = "#" .. Utilities.Color3ToHex(color),
		Size = UDim2.new(0, 90, 1, 0),
		ClearTextOnFocus = false,
	})
	Utilities.Corner(hexBox, Radius.sm)
	Utilities.Padding(hexBox, 0, 0, 0, 6, 6)
	hexBox.Parent = inputsRow

	local copyBtn = Utilities.Create("TextButton", {
		BackgroundColor3 = Theme.SurfaceLight,
		Text = "Copy",
		Font = Typography.Font,
		TextSize = Typography.Tiny,
		TextColor3 = Theme.TextSecondary,
		Size = UDim2.new(0, 50, 1, 0),
		AutoButtonColor = false,
	})
	Utilities.Corner(copyBtn, Radius.sm)
	copyBtn.Parent = inputsRow

	local resetBtn = Utilities.Create("TextButton", {
		BackgroundColor3 = Theme.SurfaceLight,
		Text = "Reset",
		Font = Typography.Font,
		TextSize = Typography.Tiny,
		TextColor3 = Theme.TextSecondary,
		Size = UDim2.new(0, 54, 1, 0),
		AutoButtonColor = false,
	})
	Utilities.Corner(resetBtn, Radius.sm)
	resetBtn.Parent = inputsRow
	inputsRow.Parent = popover

	-- Preview swatch strip
	local preview = Utilities.Create("Frame", {
		BackgroundColor3 = color,
		BackgroundTransparency = transparency,
		Size = UDim2.new(1, 0, 0, 24),
		Position = UDim2.new(0, 0, 0, 236),
	})
	Utilities.Corner(preview, Radius.sm)
	Utilities.Stroke(preview, Theme.Border, 1, 0.3)
	preview.Parent = popover

	popover.Parent = screenGui

	local originalColor, originalTransparency = color, transparency

	local function pushUpdate()
		color = Color3.fromHSV(h, s, v)
		swatchBtn.BackgroundColor3 = color
		svCanvas.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
		alphaGrad.Color = ColorSequence.new(color)
		preview.BackgroundColor3 = color
		preview.BackgroundTransparency = transparency
		hexBox.Text = "#" .. Utilities.Color3ToHex(color)
		Utilities.SafeCallback(config.Callback, color, transparency)
	end

	local draggingSV, draggingHue, draggingAlpha = false, false, false

	svCanvas.InputBegan:Connect(function(input)
		if disabled then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSV = true
		end
	end)
	hueBar.InputBegan:Connect(function(input)
		if disabled then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingHue = true
		end
	end)
	alphaBar.InputBegan:Connect(function(input)
		if disabled then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingAlpha = true
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			draggingSV, draggingHue, draggingAlpha = false, false, false
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
			return
		end
		if draggingSV then
			local pos = svCanvas.AbsolutePosition
			local size = svCanvas.AbsoluteSize
			s = Utilities.Clamp((input.Position.X - pos.X) / size.X, 0, 1)
			v = 1 - Utilities.Clamp((input.Position.Y - pos.Y) / size.Y, 0, 1)
			svCursor.Position = UDim2.new(s, -5, 1 - v, -5)
			pushUpdate()
		elseif draggingHue then
			local pos = hueBar.AbsolutePosition
			local size = hueBar.AbsoluteSize
			h = Utilities.Clamp((input.Position.X - pos.X) / size.X, 0, 1)
			hueCursor.Position = UDim2.new(h, -3, 0.5, -10)
			pushUpdate()
		elseif draggingAlpha then
			local pos = alphaBar.AbsolutePosition
			local size = alphaBar.AbsoluteSize
			local alpha = Utilities.Clamp((input.Position.X - pos.X) / size.X, 0, 1)
			transparency = 1 - alpha
			alphaCursor.Position = UDim2.new(alpha, -3, 0.5, -10)
			pushUpdate()
		end
	end)

	hexBox.FocusLost:Connect(function()
		local parsed = Utilities.HexToColor3(hexBox.Text)
		if parsed then
			h, s, v = Color3.toHSV(parsed)
			svCursor.Position = UDim2.new(s, -5, 1 - v, -5)
			hueCursor.Position = UDim2.new(h, -3, 0.5, -10)
			pushUpdate()
		else
			hexBox.Text = "#" .. Utilities.Color3ToHex(color)
		end
	end)

	copyBtn.MouseButton1Click:Connect(function()
		hexBox:CaptureFocus()
		hexBox.SelectionStart = 1
		hexBox.CursorPosition = #hexBox.Text + 1
	end)

	resetBtn.MouseButton1Click:Connect(function()
		h, s, v = Color3.toHSV(originalColor)
		transparency = originalTransparency
		svCursor.Position = UDim2.new(s, -5, 1 - v, -5)
		hueCursor.Position = UDim2.new(h, -3, 0.5, -10)
		alphaCursor.Position = UDim2.new(1 - transparency, -3, 0.5, -10)
		pushUpdate()
	end)

	local function positionPopover()
		local absPos = swatchBtn.AbsolutePosition
		local absSize = swatchBtn.AbsoluteSize
		popover.Position = UDim2.new(0, absPos.X + absSize.X - 240, 0, absPos.Y + absSize.Y + 4)
	end

	swatchBtn.MouseButton1Click:Connect(function()
		if disabled then return end
		popover.Visible = not popover.Visible
		if popover.Visible then
			positionPopover()
		end
	end)

	UserInputService.InputBegan:Connect(function(input)
		if not popover.Visible then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			local mousePos = UserInputService:GetMouseLocation()
			local function inside(frame)
				local p, sz = frame.AbsolutePosition, frame.AbsoluteSize
				return mousePos.X >= p.X and mousePos.X <= p.X + sz.X and mousePos.Y >= p.Y and mousePos.Y <= p.Y + sz.Y
			end
			if not inside(popover) and not inside(swatchBtn) and not draggingSV and not draggingHue and not draggingAlpha then
				popover.Visible = false
			end
		end
	end)

	local api = {}
	function api:GetColor() return color, transparency end
	function api:SetColor(newColor, newTransparency)
		h, s, v = Color3.toHSV(newColor)
		transparency = newTransparency or transparency
		svCursor.Position = UDim2.new(s, -5, 1 - v, -5)
		hueCursor.Position = UDim2.new(h, -3, 0.5, -10)
		alphaCursor.Position = UDim2.new(1 - transparency, -3, 0.5, -10)
		pushUpdate()
	end
	function api:SetDisabled(v) disabled = v end
	function api:Destroy()
		row:Destroy()
		popover:Destroy()
	end

	Search.Register({
		Name = config.Title, Description = config.Description, TabName = config.TabName,
		Icon = config.Icon or "palette", GuiObject = row, OnSelect = config.OnNavigate,
	})

	return api
end

--============================================================================
-- WINDOW
--============================================================================
function NebulaUI:CreateWindow(config)
	config = config or {}
	Config.AnimationSpeed = config.AnimationSpeed or Config.AnimationSpeed
	Config.TabMode = config.TabMode or Config.TabMode
	ScaleManager.ManualScale = config.Scale or 1

	local screenGui = Utilities.Create("ScreenGui", {
		Name = "NebulaUI",
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		IgnoreGuiInset = true,
		DisplayOrder = 100,
	})
	local ok = pcall(function()
		screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
	end)
	if not ok then
		screenGui.Parent = game:GetService("CoreGui")
	end

	local uiScale = Instance.new("UIScale")

	local mainFrame = Utilities.Create("Frame", {
		Name = "MainWindow",
		BackgroundColor3 = Theme.Background,
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 640, 0, 460),
		Position = UDim2.new(0.5, 0, 0.5, 0),
		AnchorPoint = Vector2.new(0.5, 0.5),
		ClipsDescendants = true,
	})
	Utilities.Corner(mainFrame, Radius.xl)
	local mainStroke = Utilities.Stroke(mainFrame, Theme.Border, 1, 1)
	uiScale.Parent = mainFrame
	mainFrame.Parent = screenGui

	Tooltip.Init(screenGui)

	-- Entrance animation: fade + scale-up + slight rise. Simple by design —
	-- ask if you want the multi-phase cinematic version.
	mainFrame.Position = UDim2.new(0.5, 0, 0.52, 10)
	task.defer(function()
		mainFrame.BackgroundTransparency = 1
		Animator.Tween(mainFrame, { BackgroundTransparency = 0 }, 0.28, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
		Animator.Tween(mainStroke, { Transparency = 0.3 }, 0.28)
		Animator.Spring(mainFrame, { Position = UDim2.new(0.5, 0, 0.5, 0) })
		uiScale.Scale = 0.94
		Animator.Spring(uiScale, { Scale = 1 })
	end)

	--------------------------------------------------------------------
	-- TOP BAR
	--------------------------------------------------------------------
	local topBar = Utilities.Create("Frame", {
		Name = "TopBar",
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(1, 0, 0, 54),
	})
	Utilities.Padding(topBar, 0, 0, 0, Spacing.md, Spacing.md)
	topBar.Parent = mainFrame

	local topBarBorder = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 1),
		Position = UDim2.new(0, 0, 1, -1),
	})
	topBarBorder.Parent = topBar

	local logoHolder = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.SurfaceLight,
		Size = UDim2.new(0, 34, 0, 34),
		Position = UDim2.new(0, 0, 0.5, -17),
	})
	Utilities.Corner(logoHolder, Radius.md)
	if config.Logo then
		local logoImg = Utilities.Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = config.Logo,
			Size = UDim2.new(1, -8, 1, -8),
			Position = UDim2.new(0, 4, 0, 4),
		})
		Utilities.Corner(logoImg, Radius.sm)
		logoImg.Parent = logoHolder
	end
	logoHolder.Parent = topBar

	local titleHolder = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Position = UDim2.new(0, 44, 0, 0),
		Size = UDim2.new(0, 260, 1, 0),
	})
	Utilities.ListLayout(titleHolder, Enum.FillDirection.Vertical, 0, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
	local titleLbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontBold,
		TextSize = Typography.Body,
		TextColor3 = Theme.Text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Title or "NebulaUI",
		Size = UDim2.new(1, 0, 0, 18),
	})
	local subtitleLbl = Utilities.Create("TextLabel", {
		BackgroundTransparency = 1,
		Font = Typography.FontRegular,
		TextSize = Typography.Small,
		TextColor3 = Theme.TextSecondary,
		TextXAlignment = Enum.TextXAlignment.Left,
		Text = config.Subtitle or "",
		Size = UDim2.new(1, 0, 0, 14),
	})
	titleLbl.Parent = titleHolder
	subtitleLbl.Parent = titleHolder
	titleHolder.Parent = topBar

	-- Window controls (right side of top bar): close, maximize, minimize, search
	local controlsHolder = Utilities.Create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 140, 0, 28),
		Position = UDim2.new(1, -140, 0.5, -14),
	})
	Utilities.ListLayout(controlsHolder, Enum.FillDirection.Horizontal, Spacing.xs, Enum.HorizontalAlignment.Right)
	controlsHolder.Parent = topBar

	local function windowButton(iconName, hoverColor)
		local b = Utilities.Create("TextButton", {
			BackgroundColor3 = Theme.SurfaceLight,
			Text = "",
			Size = UDim2.new(0, 28, 0, 28),
			AutoButtonColor = false,
		})
		Utilities.Corner(b, Radius.sm)
		local icon = Utilities.Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Icons.Get(iconName),
			ImageColor3 = Theme.TextSecondary,
			Size = UDim2.new(0, 13, 0, 13),
			Position = UDim2.new(0.5, -6.5, 0.5, -6.5),
		})
		icon.Parent = b
		b.MouseEnter:Connect(function()
			Animator.Tween(b, { BackgroundColor3 = hoverColor or Theme.Hover }, 0.1)
			if hoverColor then
				Animator.Tween(icon, { ImageColor3 = Color3.new(1, 1, 1) }, 0.1)
			end
		end)
		b.MouseLeave:Connect(function()
			Animator.Tween(b, { BackgroundColor3 = Theme.SurfaceLight }, 0.1)
			Animator.Tween(icon, { ImageColor3 = Theme.TextSecondary }, 0.1)
		end)
		return b
	end

	local searchBtn = windowButton("search")
	local minimizeBtn = windowButton("minimize")
	local maximizeBtn = windowButton("maximize")
	local closeBtn = windowButton("close", Theme.Error)
	searchBtn.Parent = controlsHolder
	minimizeBtn.Parent = controlsHolder
	maximizeBtn.Parent = controlsHolder
	closeBtn.Parent = controlsHolder
	Tooltip.Attach(searchBtn, "Search", "Find tabs and components")
	Tooltip.Attach(minimizeBtn, "Minimize", nil)
	Tooltip.Attach(maximizeBtn, "Maximize", nil)
	Tooltip.Attach(closeBtn, "Close", nil)

	-- Dragging: whole top bar minus the controls area
	if not Utilities.IsMobile() then
		Utilities.MakeDraggable(topBar, mainFrame)
	else
		Utilities.MakeDraggable(topBar, mainFrame)
	end

	--------------------------------------------------------------------
	-- RIGHT-SIDE TAB NAVIGATION + CONTENT AREA
	--------------------------------------------------------------------
	local navWidth = (Config.TabMode == "Icon") and 56 or 168
	local rightNav = Utilities.Create("Frame", {
		Name = "RightNav",
		BackgroundColor3 = Theme.Surface,
		Size = UDim2.new(0, navWidth, 1, -54),
		Position = UDim2.new(1, -navWidth, 0, 54),
	})
	local navBorder = Utilities.Create("Frame", {
		BackgroundColor3 = Theme.Border,
		BackgroundTransparency = 0.5,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 1, 1, 0),
	})
	navBorder.Parent = rightNav
	Utilities.Padding(rightNav, Spacing.sm)
	local navList = Utilities.ListLayout(rightNav, Enum.FillDirection.Vertical, Spacing.xs)
	rightNav.Parent = mainFrame

	local contentArea = Utilities.Create("Frame", {
		Name = "ContentArea",
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -navWidth, 1, -54),
		Position = UDim2.new(0, 0, 0, 54),
	})
	Utilities.Padding(contentArea, Spacing.lg)
	contentArea.Parent = mainFrame

	--------------------------------------------------------------------
	-- WINDOW OBJECT
	--------------------------------------------------------------------
	local Window = {}
	Window.ScreenGui = screenGui
	Window.MainFrame = mainFrame
	Window._tabs = {}
	Window._activeTab = nil
	Window._closed = false
	Window._maximized = false
	Window._preMaximizeSize = mainFrame.Size
	Window._preMaximizePos = mainFrame.Position

	Notifications.Init(screenGui, config.NotificationCorner)
	Search.Init(screenGui, searchBtn)

	function Window:Notify(notifyConfig)
		return Notifications.Notify(notifyConfig)
	end

	function Window:SetTheme(newTheme)
		for k, v in pairs(newTheme) do
			Theme[k] = v
		end
		-- Re-tint the pieces that were built before this call.
		mainFrame.BackgroundColor3 = Theme.Background
		topBar.BackgroundColor3 = Theme.Surface
		rightNav.BackgroundColor3 = Theme.Surface
		titleLbl.TextColor3 = Theme.Text
		subtitleLbl.TextColor3 = Theme.TextSecondary
		-- NOTE: components created *after* SetTheme pick up new Theme values
		-- automatically since they all read from the shared Theme table.
		-- Components created before SetTheme keep their original colors
		-- unless you rebuild the tab; this keeps SetTheme cheap and safe to
		-- call repeatedly (e.g. from a live theme-editor dropdown).
	end

	function Window:SetScale(value)
		ScaleManager.SetManualScale(value)
	end

	searchBtn.MouseButton1Click:Connect(function()
		Search.Toggle()
	end)

	minimizeBtn.MouseButton1Click:Connect(function()
		if rightNav.Visible then
			rightNav.Visible = false
			contentArea.Visible = false
			Animator.Tween(mainFrame, { Size = UDim2.new(0, mainFrame.Size.X.Offset, 0, 54) }, Animator.Duration())
		else
			rightNav.Visible = true
			contentArea.Visible = true
			Animator.Tween(mainFrame, { Size = Window._preMaximizeSize }, Animator.Duration())
		end
	end)

	maximizeBtn.MouseButton1Click:Connect(function()
		if not Window._maximized then
			Window._preMaximizeSize = mainFrame.Size
			Window._preMaximizePos = mainFrame.Position
			Window._maximized = true
			Animator.Tween(mainFrame, {
				Size = UDim2.new(1, -80, 1, -80),
				Position = UDim2.new(0.5, 0, 0.5, 0),
			}, Animator.Duration())
			local icon = maximizeBtn:FindFirstChildOfClass("ImageLabel")
			if icon then icon.Image = Icons.Get("restore") end
		else
			Window._maximized = false
			Animator.Tween(mainFrame, {
				Size = Window._preMaximizeSize,
				Position = Window._preMaximizePos,
			}, Animator.Duration())
			local icon = maximizeBtn:FindFirstChildOfClass("ImageLabel")
			if icon then icon.Image = Icons.Get("maximize") end
		end
	end)

	closeBtn.MouseButton1Click:Connect(function()
		Window._closed = true
		local tween = Animator.Tween(mainFrame, { BackgroundTransparency = 1 }, 0.18)
		Animator.Tween(mainStroke, { Transparency = 1 }, 0.18)
		tween.Completed:Connect(function()
			screenGui.Enabled = false
			mainFrame.BackgroundTransparency = 0
			mainStroke.Transparency = 0.3
		end)
	end)

	function Window:Show()
		Window._closed = false
		screenGui.Enabled = true
	end
	function Window:Toggle()
		if Window._closed or not screenGui.Enabled then
			Window:Show()
		else
			Window._closed = true
			screenGui.Enabled = false
		end
	end

	if config.ToggleKeybind then
		UserInputService.InputBegan:Connect(function(input, processed)
			if processed then return end
			if input.KeyCode == config.ToggleKeybind then
				Window:Toggle()
			end
		end)
	end

	function Window:Destroy()
		ScaleManager.Destroy()
		screenGui:Destroy()
	end

	-- Responsive scaling
	local scaleRefresh = ScaleManager.Init(uiScale, workspace.CurrentCamera)

	-- Adapt right nav width / tab mode automatically on small screens
	local function adaptForViewport()
		if workspace.CurrentCamera then
			local w = workspace.CurrentCamera.ViewportSize.X
			if w <= Breakpoints.Mobile and Config.TabMode == "IconAndText" then
				rightNav.Size = UDim2.new(0, 56, 1, -54)
				contentArea.Size = UDim2.new(1, -56, 1, -54)
			else
				rightNav.Size = UDim2.new(0, navWidth, 1, -54)
				contentArea.Size = UDim2.new(1, -navWidth, 1, -54)
			end
		end
	end
	adaptForViewport()
	if workspace.CurrentCamera then
		workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(adaptForViewport)
	end

	--------------------------------------------------------------------
	-- TAB SWITCHING
	--------------------------------------------------------------------
	local function switchTab(tab)
		if Window._activeTab == tab then
			return
		end
		local previous = Window._activeTab
		Window._activeTab = tab

		for _, t in ipairs(Window._tabs) do
			local isActive = (t == tab)
			Animator.Tween(t.NavButton, { BackgroundColor3 = isActive and Theme.Hover or Theme.Surface }, 0.12)
			if t.NavIcon then
				Animator.Tween(t.NavIcon, { ImageColor3 = isActive and Theme.Accent or Theme.TextSecondary }, 0.12)
			end
			if t.NavLabel then
				Animator.Tween(t.NavLabel, { TextColor3 = isActive and Theme.Text or Theme.TextSecondary }, 0.12)
			end
			if t.Indicator then
				Animator.Tween(t.Indicator, { BackgroundTransparency = isActive and 0 or 1 }, 0.12)
			end
		end

		if previous then
			previous.Content.Visible = false
		end

		tab.Content.Visible = true
		tab.Content.GroupTransparency = 1
		tab.Content.Position = UDim2.new(0, 8, 0, 0)
		Animator.Tween(tab.Content, { GroupTransparency = 0, Position = UDim2.new(0, 0, 0, 0) }, Animator.Duration())
	end

	--------------------------------------------------------------------
	-- CREATE TAB
	--------------------------------------------------------------------
	function Window:CreateTab(tabConfig)
		tabConfig = tabConfig or {}

		local navBtn = Utilities.Create("TextButton", {
			BackgroundColor3 = Theme.Surface,
			Text = "",
			AutoButtonColor = false,
			Size = UDim2.new(1, 0, 0, 40),
			LayoutOrder = tabConfig.Order or (#Window._tabs + 1),
		})
		Utilities.Corner(navBtn, Radius.sm)

		local indicator = Utilities.Create("Frame", {
			BackgroundColor3 = Theme.Accent,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Size = UDim2.new(0, 3, 0, 18),
			Position = UDim2.new(0, 0, 0.5, -9),
		})
		Utilities.Corner(indicator, Radius.full)
		indicator.Parent = navBtn

		local iconImg = Utilities.Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = Icons.Get(tabConfig.Icon),
			ImageColor3 = Theme.TextSecondary,
			Size = UDim2.new(0, 16, 0, 16),
			Position = (Config.TabMode == "Icon") and UDim2.new(0.5, -8, 0.5, -8) or UDim2.new(0, 14, 0.5, -8),
		})
		iconImg.Parent = navBtn

		local navLabel
		if Config.TabMode ~= "Icon" then
			navLabel = Utilities.Create("TextLabel", {
				BackgroundTransparency = 1,
				Font = Typography.Font,
				TextSize = Typography.Small,
				TextColor3 = Theme.TextSecondary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = tabConfig.Title or "Tab",
				Position = UDim2.new(0, 38, 0, 0),
				Size = UDim2.new(1, -44, 1, 0),
			})
			navLabel.Parent = navBtn
		end

		navBtn.Parent = rightNav
		if tabConfig.Tooltip or Config.TabMode == "Icon" then
			Tooltip.Attach(navBtn, tabConfig.Title or "", tabConfig.Tooltip)
		end

		local content = Utilities.Create("CanvasGroup", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
		})
		local scroller = Utilities.Create("ScrollingFrame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 1, 0),
			CanvasSize = UDim2.new(0, 0, 0, 0),
			AutomaticCanvasSize = Enum.AutomaticSize.Y,
			ScrollBarThickness = 3,
			ScrollBarImageColor3 = Theme.Border,
			BorderSizePixel = 0,
		})
		Utilities.ListLayout(scroller, Enum.FillDirection.Vertical, Spacing.sm)
		scroller.Parent = content
		content.Parent = contentArea

		local tab = {
			Title = tabConfig.Title,
			NavButton = navBtn,
			NavIcon = iconImg,
			NavLabel = navLabel,
			Indicator = indicator,
			Content = content,
			Scroller = scroller,
		}
		table.insert(Window._tabs, tab)

		navBtn.MouseEnter:Connect(function()
			if Window._activeTab ~= tab then
				Animator.Tween(navBtn, { BackgroundColor3 = Theme.Hover }, 0.1)
			end
		end)
		navBtn.MouseLeave:Connect(function()
			if Window._activeTab ~= tab then
				Animator.Tween(navBtn, { BackgroundColor3 = Theme.Surface }, 0.1)
			end
		end)
		navBtn.MouseButton1Click:Connect(function()
			switchTab(tab)
		end)

		if not Window._activeTab then
			switchTab(tab)
		end

		local function navigateHere()
			switchTab(tab)
		end

		local tabAPI = {}

		function tabAPI:CreateButton(cfg)
			cfg = cfg or {}
			cfg.TabName = tab.Title
			cfg.OnNavigate = navigateHere
			return Components.CreateButton(scroller, cfg)
		end
		function tabAPI:CreateToggle(cfg)
			cfg = cfg or {}
			cfg.TabName = tab.Title
			cfg.OnNavigate = navigateHere
			return Components.CreateToggle(scroller, cfg)
		end
		function tabAPI:CreateDropdown(cfg)
			cfg = cfg or {}
			cfg.TabName = tab.Title
			cfg.OnNavigate = navigateHere
			return Components.CreateDropdown(scroller, cfg, screenGui)
		end
		function tabAPI:CreateSlider(cfg)
			cfg = cfg or {}
			cfg.TabName = tab.Title
			cfg.OnNavigate = navigateHere
			return Components.CreateSlider(scroller, cfg)
		end
		function tabAPI:CreateColorPicker(cfg)
			cfg = cfg or {}
			cfg.TabName = tab.Title
			cfg.OnNavigate = navigateHere
			return Components.CreateColorPicker(scroller, cfg, screenGui)
		end
		function tabAPI:CreateParagraph(cfg)
			return Components.CreateParagraph(scroller, cfg)
		end
		function tabAPI:CreateTitle(text, cfg)
			return Components.CreateTitle(scroller, text, cfg)
		end
		function tabAPI:CreateSection(text, cfg)
			return Components.CreateSection(scroller, text, cfg)
		end
		function tabAPI:CreateDivider(cfg)
			return Components.CreateDivider(scroller, cfg)
		end
		function tabAPI:GetContentFrame()
			return scroller
		end
		function tabAPI:SetVisible(v)
			navBtn.Visible = v
		end
		function tabAPI:Show()
			switchTab(tab)
		end
		function tabAPI:Destroy()
			navBtn:Destroy()
			content:Destroy()
			for i, t in ipairs(Window._tabs) do
				if t == tab then
					table.remove(Window._tabs, i)
					break
				end
			end
		end

		return tabAPI
	end

	--------------------------------------------------------------------
	-- WELCOME TAB (built-in dashboard)
	--------------------------------------------------------------------
	function Window:CreateWelcomeTab()
		local tab = Window:CreateTab({ Title = "Welcome", Icon = "home", Order = -1000 })
		local content = tab:GetContentFrame()

		local function greetingText()
			local hour = os.date("*t").hour
			if hour < 12 then
				return "Good morning"
			elseif hour < 18 then
				return "Good afternoon"
			else
				return "Good evening"
			end
		end

		local displayName = (LocalPlayer.DisplayName ~= "" and LocalPlayer.DisplayName) or LocalPlayer.Name
		local username = LocalPlayer.Name

		local header = Utilities.Create("Frame", {
			BackgroundColor3 = Theme.Surface,
			Size = UDim2.new(1, 0, 0, 96),
			LayoutOrder = 1,
		})
		Utilities.Corner(header, Radius.lg)
		Utilities.Stroke(header, Theme.Border, 1, 0.5)
		Utilities.Padding(header, Spacing.md)
		header.Parent = content

		local avatarFrame = Utilities.Create("Frame", {
			BackgroundColor3 = Theme.SurfaceLight,
			Size = UDim2.new(0, 64, 0, 64),
			Position = UDim2.new(0, 0, 0.5, -32),
		})
		Utilities.Corner(avatarFrame, Radius.full)
		Utilities.Stroke(avatarFrame, Theme.Border, 1, 0.4)
		local avatarImg = Utilities.Create("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(LocalPlayer.UserId) .. "&w=180&h=180",
			Size = UDim2.new(1, -4, 1, -4),
			Position = UDim2.new(0, 2, 0, 2),
		})
		Utilities.Corner(avatarImg, Radius.full)
		avatarImg.Parent = avatarFrame
		local avatarHover = Utilities.Create("TextButton", { BackgroundTransparency = 1, Text = "", Size = UDim2.new(1, 0, 1, 0) })
		avatarHover.MouseEnter:Connect(function()
			Animator.Spring(avatarFrame, { Size = UDim2.new(0, 68, 0, 68), Position = UDim2.new(0, -2, 0.5, -34) })
		end)
		avatarHover.MouseLeave:Connect(function()
			Animator.Spring(avatarFrame, { Size = UDim2.new(0, 64, 0, 64), Position = UDim2.new(0, 0, 0.5, -32) })
		end)
		avatarHover.Parent = avatarFrame
		avatarFrame.Parent = header

		local textHolder = Utilities.Create("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, 80, 0, 0),
			Size = UDim2.new(1, -80, 1, 0),
		})
		Utilities.ListLayout(textHolder, Enum.FillDirection.Vertical, 2, Enum.HorizontalAlignment.Left, Enum.VerticalAlignment.Center)
		local greetLbl = Utilities.Create("TextLabel", {
			BackgroundTransparency = 1,
			Font = Typography.FontBold,
			TextSize = Typography.Title,
			TextColor3 = Theme.Text,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "Hello, " .. displayName,
			Size = UDim2.new(1, 0, 0, 24),
		})
		local subGreetLbl = Utilities.Create("TextLabel", {
			BackgroundTransparency = 1,
			Font = Typography.FontRegular,
			TextSize = Typography.Body,
			TextColor3 = Theme.TextSecondary,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = greetingText() .. ".",
			Size = UDim2.new(1, 0, 0, 18),
		})
		local userTagLbl = Utilities.Create("TextLabel", {
			BackgroundTransparency = 1,
			Font = Typography.FontRegular,
			TextSize = Typography.Small,
			TextColor3 = Theme.TextDisabled,
			TextXAlignment = Enum.TextXAlignment.Left,
			Text = "@" .. username,
			Size = UDim2.new(1, 0, 0, 14),
		})
		greetLbl.Parent = textHolder
		subGreetLbl.Parent = textHolder
		userTagLbl.Parent = textHolder
		textHolder.Parent = header

		task.spawn(function()
			while header.Parent do
				subGreetLbl.Text = greetingText() .. "."
				task.wait(60)
			end
		end)

		local statsRow = Utilities.Create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 74),
			LayoutOrder = 2,
		})
		Utilities.ListLayout(statsRow, Enum.FillDirection.Horizontal, Spacing.sm)
		statsRow.Parent = content

		local function statCard(title)
			local card = Utilities.Create("Frame", {
				BackgroundColor3 = Theme.Surface,
				Size = UDim2.new(0, 150, 1, 0),
			})
			Utilities.Corner(card, Radius.md)
			Utilities.Stroke(card, Theme.Border, 1, 0.5)
			Utilities.Padding(card, Spacing.md)
			local titleLbl = Utilities.Create("TextLabel", {
				BackgroundTransparency = 1,
				Font = Typography.FontRegular,
				TextSize = Typography.Small,
				TextColor3 = Theme.TextSecondary,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = title,
				Size = UDim2.new(1, 0, 0, 16),
			})
			local valueLbl = Utilities.Create("TextLabel", {
				BackgroundTransparency = 1,
				Font = Typography.FontBold,
				TextSize = 18,
				TextColor3 = Theme.Text,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = "—",
				Position = UDim2.new(0, 0, 0, 20),
				Size = UDim2.new(1, 0, 0, 24),
			})
			titleLbl.Parent = card
			valueLbl.Parent = card
			card.Parent = statsRow
			return valueLbl
		end

		local playersValue = statCard("Players")
		local friendsValue = statCard("Friends Online")
		local sessionValue = statCard("Session Time")

		local function refreshPlayers()
			local ok, maxP = pcall(function() return Players.MaxPlayers end)
			playersValue.Text = string.format("%d / %s", #Players:GetPlayers(), ok and tostring(maxP) or "?")
		end
		refreshPlayers()
		Players.PlayerAdded:Connect(refreshPlayers)
		Players.PlayerRemoving:Connect(function()
			task.wait()
			refreshPlayers()
		end)

		task.spawn(function()
			local ok, friends = pcall(function()
				return LocalPlayer:GetFriendsOnline(200)
			end)
			if ok and friends then
				friendsValue.Text = tostring(#friends)
			else
				friendsValue.Text = "—"
			end
		end)

		local sessionStart = os.time()
		task.spawn(function()
			while sessionValue.Parent do
				local elapsed = os.time() - sessionStart
				local hh = math.floor(elapsed / 3600)
				local mm = math.floor((elapsed % 3600) / 60)
				local ss = elapsed % 60
				sessionValue.Text = string.format("%02d:%02d:%02d", hh, mm, ss)
				task.wait(1)
			end
		end)

		tab:CreateSection("Getting Around")
		tab:CreateParagraph({
			Title = "Tip",
			Content = "Use the search icon in the top bar to jump straight to any tab or setting.",
		})

		return tab
	end

	--------------------------------------------------------------------
	-- ABOUT / LIBRARY TAB (built-in)
	--------------------------------------------------------------------
	function Window:CreateAboutTab(aboutConfig)
		aboutConfig = aboutConfig or {}
		local tab = Window:CreateTab({ Title = aboutConfig.TabTitle or "About", Icon = "info", Order = 1000 })

		tab:CreateTitle(aboutConfig.Name or "NebulaUI")
		tab:CreateParagraph({ Content = aboutConfig.Description or "A modern Roblox interface framework." })

		tab:CreateSection("Details")
		tab:CreateParagraph({ Title = "Version", Content = aboutConfig.Version or NebulaUI._VERSION })
		if aboutConfig.Author then
			tab:CreateParagraph({ Title = "Created by", Content = aboutConfig.Author })
		end
		if aboutConfig.Changelog then
			tab:CreateSection("Changelog")
			tab:CreateParagraph({ Content = aboutConfig.Changelog })
		end

		local function linkButton(label, icon, url)
			tab:CreateButton({
				Title = label,
				Icon = icon,
				Callback = function()
					local ok = pcall(function()
						GuiService:OpenBrowserWindowAsync(url)
					end)
					if not ok then
						Window:Notify({ Title = label, Content = url, Type = "Information", Duration = 6 })
					end
				end,
			})
		end

		if aboutConfig.Discord or aboutConfig.Documentation or aboutConfig.GitHub then
			tab:CreateSection("Links")
			if aboutConfig.Discord then
				linkButton("Discord", "discord", aboutConfig.Discord)
			end
			if aboutConfig.Documentation then
				linkButton("Documentation", "book", aboutConfig.Documentation)
			end
			if aboutConfig.GitHub then
				linkButton("GitHub", "github", aboutConfig.GitHub)
			end
		end

		return tab
	end

	return Window
end

--============================================================================
-- PUBLIC LIBRARY-LEVEL API
--============================================================================
function NebulaUI:RegisterIcon(name, assetId)
	Icons.Register(name, assetId)
end

function NebulaUI:RegisterIcons(map)
	Icons.RegisterMany(map)
end

-- Sets the *default* theme new windows are built with. To re-theme an
-- already-created window, use Window:SetTheme(...) instead.
function NebulaUI:SetTheme(newTheme)
	for k, v in pairs(newTheme) do
		Theme[k] = v
	end
end

function NebulaUI:SetAnimationSpeed(speed)
	if Animator.Presets[speed] then
		Config.AnimationSpeed = speed
	end
end

return NebulaUI
