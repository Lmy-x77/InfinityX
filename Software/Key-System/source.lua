-- variables
function OpenKeySystem()
  local tweenService = game:GetService("TweenService")
  local lighting = game:GetService("Lighting")
  local camera = workspace.CurrentCamera
  local soundInstances = workspace:GetDescendants()
  local function createReverb(timing)
    for _, sound in next, soundInstances do
      if sound:IsA("Sound") and not sound:FindFirstChild("EqualizerSound") then
        local reverb = Instance.new("EqualizerSoundEffect")
        reverb.Name = "EqualizerSound"
        reverb.Parent = sound
        reverb.Enabled = false
        reverb.HighGain = 0
        reverb.LowGain = 0
        reverb.MidGain = 0
        reverb.Enabled = true
        if timing then
          tweenService:Create(reverb, TweenInfo.new(timing, Enum.EasingStyle.Exponential), {HighGain = -20}):Play()
          tweenService:Create(reverb, TweenInfo.new(timing, Enum.EasingStyle.Exponential), {LowGain = 5}):Play()
          tweenService:Create(reverb, TweenInfo.new(timing, Enum.EasingStyle.Exponential), {MidGain = -20}):Play()
        end
      end
    end
  end
  local homeBlur = Instance.new("BlurEffect", lighting)
  homeBlur.Size = 0
  homeBlur.Name = "HomeBlur"
  tweenService:Create(homeBlur, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = 5}):Play()
  tweenService:Create(camera, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {FieldOfView = camera.FieldOfView + 5}):Play()
  task.wait(0.25)
  createReverb(0.8)
  tweenService:Create(camera, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {FieldOfView = camera.FieldOfView - 40}):Play()
  tweenService:Create(homeBlur, TweenInfo.new(0.8, Enum.EasingStyle.Quint), {Size = 20}):Play()
  task.wait(0.5)
end
function CLoseKeySystem()
  local tweenService = game:GetService("TweenService")
  local lighting = game:GetService("Lighting")
  local camera = workspace.CurrentCamera
  local soundInstances = workspace:GetDescendants()
  local function removeReverbs(timing)
    timing = timing or 0.65
    for _, sound in next, soundInstances do
      if sound:FindFirstChild("EqualizerSound") then
        local reverb = sound:FindFirstChild("EqualizerSound")
        tweenService:Create(reverb, TweenInfo.new(timing, Enum.EasingStyle.Exponential), {HighGain = 0}):Play()
        tweenService:Create(reverb, TweenInfo.new(timing, Enum.EasingStyle.Exponential), {LowGain = 0}):Play()
        tweenService:Create(reverb, TweenInfo.new(timing, Enum.EasingStyle.Exponential), {MidGain = 0}):Play()
        task.delay(timing + 0.03, reverb.Destroy, reverb)
      end
    end
  end
  tweenService:Create(camera, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {FieldOfView = camera.FieldOfView + 35}):Play()
  for _, obj in ipairs(lighting:GetChildren()) do
    if obj.Name == "HomeBlur" then
      tweenService:Create(obj, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Size = 0}):Play()
      task.delay(0.6, obj.Destroy, obj)
    end
  end
  removeReverbs(0.5)
  task.wait(0.52)
end


-- source
OpenKeySystem()
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")

local function create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	return inst
end

local gui = create("ScreenGui", {
	Name = "InfinityX_KeySystem",
	Parent = CoreGui,
	ResetOnSpawn = false
})

local main = create("Frame", {
	Parent = gui,
	Size = UDim2.new(0, 420, 0, 300),
	Position = UDim2.new(0.5, -210, 0.5, -300),
	BackgroundColor3 = Color3.fromRGB(28, 28, 30),
	BorderSizePixel = 0
})
local UIGradient = Instance.new("UIGradient")
local UIStroke = Instance.new("UIStroke")

UIStroke.Parent = main
UIStroke.Thickness = 0.8
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Color = Color3.new(1, 1, 1)

UIGradient.Parent = UIStroke
UIGradient.Rotation = 180
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 0, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(130, 0, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 0, 255))
}
UIGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 1),
	NumberSequenceKeypoint.new(1, 0)
}

task.spawn(function()
	while true do
		UIGradient.Rotation = (UIGradient.Rotation + 3) % 360 -- rotação rápida
		RunService.RenderStepped:Wait()
	end
end)
create("UICorner", {Parent = main, CornerRadius = UDim.new(0, 8)})


TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, -210, 0.5, -150)
}):Play()

local header = create("Frame", {
	Parent = main,
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundColor3 = Color3.fromRGB(36, 36, 38),
	BorderSizePixel = 0
})
create("Frame", {
	Parent = header,
	Size = UDim2.new(1, 0, 0, 8),
	Position = UDim2.new(0, 0, 1, -5),
	BackgroundColor3 = Color3.fromRGB(36, 36, 38),
	BorderSizePixel = 0
})
create("UICorner", {Parent = header, CornerRadius = UDim.new(0, 8)})

local title = create("TextLabel", {
	Parent = header,
	Text = "InfinityX - Key System",
	Font = Enum.Font.GothamBold,
	TextScaled = true,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 1,
	Size = UDim2.new(0.9, 0, 0.45, 0),
	Position = UDim2.new(0.05, 0, 0.25, 0),
	TextXAlignment = Enum.TextXAlignment.Center
})

local closeBtn = create("TextButton", {
	Parent = header,
	Text = "X",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundColor3 = Color3.fromRGB(200, 60, 60),
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(1, -40, 0.5, -15),
	BorderSizePixel = 0
})
create("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0, 4)})

local subtitle = create("TextLabel", {
	Parent = main,
	Position = UDim2.new(0.1, 0, 0, 60),
	Size = UDim2.new(0.8, 0, 0, 15),
	BackgroundTransparency = 1,
	Text = "Get your key to use InfinityX",
	TextColor3 = Color3.fromRGB(190, 190, 190),
	Font = Enum.Font.Gotham,
	TextScaled = true
})

local versiontitle = create("TextLabel", {
	Parent = main,
	Position = UDim2.new(0.1, 0, 0, 280),
	Size = UDim2.new(0.8, 0, 0, 15),
	BackgroundTransparency = 1,
	Text = "Version: 4.2a",
	TextColor3 = Color3.fromRGB(139, 139, 139),
	TextTransparency = 0.4,
	Font = Enum.Font.Gotham,
	TextScaled = true
})

local textbox = create("TextBox", {
	Parent = main,
	Size = UDim2.new(0.9, 0, 0, 35),
	Position = UDim2.new(0.05, 0, 0, 100),
	Text = "",
	PlaceholderText = "Enter your key here...",
	BackgroundColor3 = Color3.fromRGB(20, 20, 22),
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.Gotham,
	TextSize = 14,
	BorderSizePixel = 0,
	ClearTextOnFocus = false
})
create("UICorner", {Parent = textbox, CornerRadius = UDim.new(0, 4)})

local function makeButton(text, pos)
	local btn = create("TextButton", {
		Parent = main,
		Size = UDim2.new(0.425, 0, 0, 35),
		Position = pos,
		Text = text,
		BackgroundColor3 = Color3.fromRGB(42, 42, 44),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		BorderSizePixel = 0
	})
	create("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 4)})
	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 64)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(42, 42, 44)}):Play()
	end)
	return btn
end

local notifications = {}
local notifyYOffset = -50

local function notify(text)
	local index = #notifications + 1
	local yOffset = notifyYOffset - ((index - 1) * 45)

	local note = create("Frame", {
		Parent = gui,
		Size = UDim2.new(0, 300, 0, 40),
		Position = UDim2.new(1, 10, 1, yOffset),
		BackgroundColor3 = Color3.fromRGB(32, 32, 34),
		BorderSizePixel = 0
	})
	create("UICorner", {Parent = note, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {
		Parent = note,
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	})

	table.insert(notifications, note)

	TweenService:Create(note, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {
		Position = UDim2.new(1, -310, 1, yOffset)
	}):Play()

	task.delay(2, function()
		TweenService:Create(note, TweenInfo.new(0.3), {
			Position = UDim2.new(1, 10, 1, yOffset),
			BackgroundTransparency = 1
		}):Play()
		wait(0.3)
		note:Destroy()
		table.remove(notifications, table.find(notifications, note))
		for i, v in ipairs(notifications) do
			local targetOffset = notifyYOffset - ((i - 1) * 45)
			TweenService:Create(v, TweenInfo.new(0.2), {
				Position = UDim2.new(1, -310, 1, targetOffset)
			}):Play()
		end
	end)
end

local CheckKey = makeButton("Check Key", UDim2.new(0.05, 0, 0, 150))
CheckKey.MouseButton1Click:Connect(function()
	CheckKey.Text = "Checking..."
	writefile('InfinityX/Key-System/key.lua', textbox.Text)
	wait(1)
	if readfile('InfinityX/Key-System/key.lua') == key then
        CheckKey.Text = 'Key is valid!'
		wait(1.2)
		for _, v in ipairs(gui:GetDescendants()) do
			if v:IsA("GuiObject") and not v:IsA('Frame') and not v:IsA('ImageLabel') then
				TweenService:Create(v, TweenInfo.new(0.3), {
					BackgroundTransparency = 1,
					TextTransparency = 1
				}):Play()
			end
		end
		for _, v in ipairs(gui:GetDescendants()) do
			if v:IsA('Frame') then
				TweenService:Create(v, TweenInfo.new(0.3), {
					BackgroundTransparency = 1,
				}):Play()
			end
		end
		for _, v in ipairs(gui:GetDescendants()) do
			if v:IsA('ImageLabel') then
				TweenService:Create(v, TweenInfo.new(0.3), {
					ImageTransparency = 1,
				}):Play()
			end
		end
        UIStroke:Destroy()
		CLoseKeySystem()
		wait(0.5)
		gui:Destroy()
		correctKey = true
	else
        CheckKey.Text = 'Invalid key!'
		wait(1)
		CheckKey.Text = "Check Key"
	end
end)

local GetKey = makeButton("Get Key", UDim2.new(0.525, 0, 0, 150))
GetKey.MouseButton1Click:Connect(function()
	setclipboard(url)
    GetKey.Text = 'Key URL Copied!'
	wait(1)
	GetKey.Text = "Get Key"
end)

local logo = create("ImageLabel", {
	Parent = header,
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(0, 8, 0.5, -15),
	BackgroundTransparency = 1,
	Image = "rbxassetid://126527122577864"
})

local discordBtn = create("TextButton", {
	Parent = main,
	Size = UDim2.new(0.9, 0, 0, 35),
	Position = UDim2.new(0.05, 0, 0, 200),
	Text = "Join our Discord",
	BackgroundColor3 = Color3.fromRGB(0, 180, 100),
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	BorderSizePixel = 0
})
create("UICorner", {Parent = discordBtn, CornerRadius = UDim.new(0, 4)})

discordBtn.MouseEnter:Connect(function()
	TweenService:Create(discordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
end)
discordBtn.MouseLeave:Connect(function()
	TweenService:Create(discordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}):Play()
end)

discordBtn.MouseButton1Click:Connect(function()
	setclipboard("https://discord.gg/emKJgWMHAr")
    discordBtn.Text = 'Copied!'
	wait(1)
	discordBtn.Text = "Join our Discord"
end)

closeBtn.MouseButton1Click:Connect(function()
	for _, v in ipairs(gui:GetDescendants()) do
		if v:IsA("GuiObject") and not v:IsA('Frame') and not v:IsA('ImageLabel') then
			TweenService:Create(v, TweenInfo.new(0.3), {
				BackgroundTransparency = 1,
				TextTransparency = 1
			}):Play()
		end
	end
	for _, v in ipairs(gui:GetDescendants()) do
		if v:IsA('Frame') then
			TweenService:Create(v, TweenInfo.new(0.3), {
				BackgroundTransparency = 1,
			}):Play()
		end
	end
	for _, v in ipairs(gui:GetDescendants()) do
		if v:IsA('ImageLabel') then
			TweenService:Create(v, TweenInfo.new(0.3), {
				ImageTransparency = 1,
			}):Play()
		end
	end
    UIStroke:Destroy()
    CLoseKeySystem()
    wait(0.5)
    gui:Destroy()
end)
