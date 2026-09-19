--[[
	╔══════════════════════════════════════════════╗
	║         InfinityX • Mobile Buttons           ║
	╚══════════════════════════════════════════════╝

	Usage:
		local lib = loadstring(game:HttpGet("..."))()

		local farm = lib.CreateButton("Auto Farm", {
			Position = "Left",              -- "Left" | "Right" | "Up" | "Below"
			Callback = function()
				print("clicked")
			end,
		})

		lib.CreateButton("Speed", {
			Position = "Left",
			Toggle = true,                  -- keeps an on/off state
			Default = false,
			Callback = function(state)
				print("speed:", state)
			end,
		})

		lib.CreateButton("Hidden one", { Position = "Left", Visible = false })

	Button methods:
		button:SetVisible(bool) / :Show() / :Hide()   -- hidden buttons leave NO empty gap
		button:SetState(bool)  / :GetState()          -- toggle buttons
		button:SetText(text)
		button:SetPosition("Left" | "Right" | "Up" | "Below")
		button:Destroy()

	Library:
		lib.SetVisible(name, bool)      lib.GetButton(name)
		lib.SetAllVisible(bool)         lib.SetMargin(n)     lib.SetSpacing(n)
		lib.Destroy()
]]

local lib = {}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

--// ───────────── CONFIG ─────────────
lib.Config = {
	Margin = 16, -- distance from the screen edges
	Spacing = 8, -- gap between buttons
	ButtonSize = Vector2.new(116, 42), -- touch friendly
	CornerRadius = 10,
	MobileOnly = false, -- true = only shows on touch devices
	DisplayOrder = 500,
}

local T = {
	Accent = Color3.fromRGB(140, 80, 255),
	Accent2 = Color3.fromRGB(236, 72, 153),
	Text = Color3.fromRGB(248, 245, 255),
	Muted = Color3.fromRGB(150, 140, 175),
	White = Color3.new(1, 1, 1),
}

lib.Buttons = {}

--// ───────────── HELPERS ─────────────
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

local function tween(obj, duration, props, style, direction)
	local t = TweenService:Create(
		obj,
		TweenInfo.new(duration, style or Enum.EasingStyle.Quart, direction or Enum.EasingDirection.Out),
		props
	)
	t:Play()
	return t
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

--// ───────────── SIDES ─────────────
local SIDES = {
	Left = {
		Anchor = Vector2.new(0, 0.5),
		Horizontal = false,
		HAlign = Enum.HorizontalAlignment.Left,
		VAlign = Enum.VerticalAlignment.Top,
	},
	Right = {
		Anchor = Vector2.new(1, 0.5),
		Horizontal = false,
		HAlign = Enum.HorizontalAlignment.Right,
		VAlign = Enum.VerticalAlignment.Top,
	},
	Up = {
		Anchor = Vector2.new(0.5, 0),
		Horizontal = true,
		HAlign = Enum.HorizontalAlignment.Left,
		VAlign = Enum.VerticalAlignment.Top,
	},
	Below = {
		Anchor = Vector2.new(0.5, 1),
		Horizontal = true,
		HAlign = Enum.HorizontalAlignment.Left,
		VAlign = Enum.VerticalAlignment.Bottom,
	},
}

local ALIASES = {
	left = "Left",
	right = "Right",
	up = "Up",
	top = "Up",
	above = "Up",
	below = "Below",
	bottom = "Below",
	down = "Below",
}

local function normalizeSide(value)
	if type(value) == "string" then
		local side = ALIASES[value:lower()]
		if side then
			return side
		end
		warn(("[ InfinityX ] - Invalid Position '%s', using 'Left'"):format(value))
	end
	return "Left"
end

local function sidePosition(side)
	local m = lib.Config.Margin
	if side == "Left" then
		return UDim2.new(0, m, 0.5, 0)
	elseif side == "Right" then
		return UDim2.new(1, -m, 0.5, 0)
	elseif side == "Up" then
		return UDim2.new(0.5, 0, 0, m)
	else
		return UDim2.new(0.5, 0, 1, -m)
	end
end

--// ───────────── GUI + CONTAINERS ─────────────
local parentGui = getParent()

do
	local old = parentGui:FindFirstChild("InfinityX-MobileButtons")
	if old then
		old:Destroy()
	end
end

local gui = new("ScreenGui", {
	Name = "InfinityX-MobileButtons",
	ResetOnSpawn = false,
	DisplayOrder = lib.Config.DisplayOrder,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	Enabled = (not lib.Config.MobileOnly) or UserInputService.TouchEnabled,
	Parent = parentGui,
})
pcall(function()
	gui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
end)

local containers = {}

for side, info in pairs(SIDES) do
	local container = new("Frame", {
		Name = side,
		AnchorPoint = info.Anchor,
		Position = sidePosition(side),
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
		BackgroundTransparency = 1,
		Parent = gui,
	})
	local layout = new("UIListLayout", {
		FillDirection = info.Horizontal and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical,
		HorizontalAlignment = info.HAlign,
		VerticalAlignment = info.VAlign,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, lib.Config.Spacing),
		Parent = container,
	})
	containers[side] = { Frame = container, Layout = layout }
end

--// ───────────── BUTTON CLASS ─────────────
local Button = {}
Button.__index = Button

local nextOrder = 0

function Button:_render()
	if not self.IsToggle then
		return
	end
	local on = self.State
	tween(self.Fill, 0.2, { BackgroundTransparency = on and 0 or 1 })
	tween(self.Stroke, 0.2, { Transparency = on and 0.25 or 0.6 })
	tween(self.Dot, 0.2, { BackgroundColor3 = on and T.White or T.Muted })
	tween(self.Label, 0.2, { TextColor3 = on and T.White or T.Text })
end

function Button:_fire()
	if not self.Callback then
		return
	end
	local ok, err
	if self.IsToggle then
		ok, err = pcall(self.Callback, self.State)
	else
		ok, err = pcall(self.Callback)
	end
	if not ok then
		warn(("[ InfinityX ] - Callback error in button '%s': %s"):format(self.Name, tostring(err)))
	end
end

function Button:SetVisible(state)
	if self.Destroyed then
		return
	end
	state = state and true or false
	if self.Visible == state then
		return
	end
	self.Visible = state

	if state then
		self.Instance.Visible = true
		self.Scale.Scale = 0.85
		tween(self.Scale, 0.3, { Scale = 1 }, Enum.EasingStyle.Back)
	else
		tween(self.Scale, 0.12, { Scale = 0.85 }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
		task.delay(0.12, function()
			if not self.Destroyed and not self.Visible then
				self.Instance.Visible = false -- hidden = removed from the layout (no gap)
			end
		end)
	end
end

function Button:Show()
	self:SetVisible(true)
end

function Button:Hide()
	self:SetVisible(false)
end

function Button:SetState(state)
	if not self.IsToggle or self.Destroyed then
		return
	end
	self.State = state and true or false
	self:_render()
end

function Button:GetState()
	return self.State
end

function Button:SetText(text)
	self.Label.Text = tostring(text)
end

function Button:SetPosition(position)
	if self.Destroyed then
		return
	end
	self.Position = normalizeSide(position)
	self.Instance.Parent = containers[self.Position].Frame
end

function Button:Destroy()
	if self.Destroyed then
		return
	end
	self.Destroyed = true
	if lib.Buttons[self.Name] == self then
		lib.Buttons[self.Name] = nil
	end
	self.Instance:Destroy()
end

--// ───────────── API ─────────────
function lib.CreateButton(name, options)
	assert(type(name) == "string", "CreateButton: name must be a string")
	options = options or {}

	local cfg = lib.Config
	local side = normalizeSide(options.Position or options.Postion or "Left")
	local size = options.Size or cfg.ButtonSize
	local isToggle = options.Toggle == true
	local visible = options.Visible ~= false

	nextOrder = nextOrder + 1

	local btn = new("TextButton", {
		Name = name,
		LayoutOrder = nextOrder,
		Size = UDim2.fromOffset(size.X, size.Y),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 0.08,
		AutoButtonColor = false,
		Text = "",
		BorderSizePixel = 0,
		Visible = visible,
		Parent = containers[side].Frame,
	})
	new("UICorner", { CornerRadius = UDim.new(0, cfg.CornerRadius), Parent = btn })
	new("UIGradient", {
		Rotation = 125,
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(32, 22, 52)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 10, 24)),
		}),
		Parent = btn,
	})
	local scale = new("UIScale", { Scale = 1, Parent = btn })
	local stroke = new("UIStroke", {
		Color = T.Accent,
		Thickness = 1,
		Transparency = 0.6,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = btn,
	})

	-- fill that lights up (toggle on / click feedback)
	local fill = new("Frame", {
		Name = "Fill",
		Size = UDim2.fromScale(1, 1),
		BackgroundColor3 = T.White,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ZIndex = 2,
		Parent = btn,
	})
	new("UICorner", { CornerRadius = UDim.new(0, cfg.CornerRadius), Parent = fill })
	new("UIGradient", {
		Rotation = 20,
		Color = ColorSequence.new(T.Accent, T.Accent2),
		Parent = fill,
	})

	local label = new("TextLabel", {
		Name = "Label",
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		Text = name,
		Font = Enum.Font.GothamSemibold,
		TextSize = 13,
		TextColor3 = T.Text,
		TextTruncate = Enum.TextTruncate.AtEnd,
		ZIndex = 3,
		Parent = btn,
	})
	new("UIPadding", {
		PaddingLeft = UDim.new(0, isToggle and 24 or 10),
		PaddingRight = UDim.new(0, 10),
		Parent = label,
	})

	local dot = new("Frame", {
		Name = "Dot",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 12, 0.5, 0),
		Size = UDim2.fromOffset(6, 6),
		BackgroundColor3 = T.Muted,
		BorderSizePixel = 0,
		Visible = isToggle,
		ZIndex = 3,
		Parent = btn,
	})
	new("UICorner", { CornerRadius = UDim.new(0, 3), Parent = dot })

	local self = setmetatable({
		Name = name,
		Position = side,
		Callback = options.Callback,
		IsToggle = isToggle,
		State = isToggle and options.Default == true or false,
		Visible = visible,
		Destroyed = false,
		Instance = btn,
		Scale = scale,
		Stroke = stroke,
		Fill = fill,
		Label = label,
		Dot = dot,
	}, Button)

	if lib.Buttons[name] then
		warn(("[ InfinityX ] - A button named '%s' already exists, replacing reference"):format(name))
	end
	lib.Buttons[name] = self

	-- press feedback
	btn.MouseButton1Down:Connect(function()
		tween(scale, 0.1, { Scale = 0.94 })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(scale, 0.15, { Scale = 1 })
	end)
	btn.MouseLeave:Connect(function()
		tween(scale, 0.15, { Scale = 1 })
	end)

	btn.Activated:Connect(function()
		if isToggle then
			self.State = not self.State
			self:_render()
		else
			fill.BackgroundTransparency = 0.55
			tween(fill, 0.35, { BackgroundTransparency = 1 })
		end
		self:_fire()
	end)

	-- initial visuals
	if isToggle then
		fill.BackgroundTransparency = self.State and 0 or 1
		stroke.Transparency = self.State and 0.25 or 0.6
		dot.BackgroundColor3 = self.State and T.White or T.Muted
		label.TextColor3 = self.State and T.White or T.Text
	end

	if visible then
		scale.Scale = 0.85
		tween(scale, 0.35, { Scale = 1 }, Enum.EasingStyle.Back)
	end

	return self
end

function lib.GetButton(name)
	return lib.Buttons[name]
end

function lib.SetVisible(name, state)
	local button = lib.Buttons[name]
	if button then
		button:SetVisible(state)
	end
end

function lib.SetAllVisible(state)
	for _, button in pairs(lib.Buttons) do
		button:SetVisible(state)
	end
end

function lib.SetMargin(value)
	lib.Config.Margin = value
	for side, info in pairs(containers) do
		info.Frame.Position = sidePosition(side)
	end
end

function lib.SetSpacing(value)
	lib.Config.Spacing = value
	for _, info in pairs(containers) do
		info.Layout.Padding = UDim.new(0, value)
	end
end

function lib.Destroy()
	gui:Destroy()
	table.clear(lib.Buttons)
end

return lib
