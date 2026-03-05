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
  end
})

local Players = Services.Players
local TweenService = Services.TweenService
local Lighting = Services.Lighting

local player = Players.LocalPlayer

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = Lighting

TweenService:Create(
	blur,
	TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
	{Size = 28}
):Play()

local gui = Instance.new("ScreenGui")
gui.Name = "InfinityXIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Parent = gui
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(22,18,30)
bg.BackgroundTransparency = 0.05

local bgGradient = Instance.new("UIGradient")
bgGradient.Parent = bg
bgGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40,20,60)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120,70,200)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(40,20,60))
})
bgGradient.Rotation = 0

task.spawn(function()
	while bg.Parent do
		local t = TweenService:Create(
			bgGradient,
			TweenInfo.new(6, Enum.EasingStyle.Linear),
			{Rotation = bgGradient.Rotation + 360}
		)
		t:Play()
		t.Completed:Wait()
	end
end)

local container = Instance.new("Frame")
container.Parent = bg
container.AnchorPoint = Vector2.new(0.5,0.5)
container.Position = UDim2.new(0.5,0,0.45,0)
container.Size = UDim2.new(0,540,0,120)
container.BackgroundTransparency = 1

local word = "INFINITYX"
local letters = {}

for i = 1,#word do
	local char = word:sub(i,i)

	local label = Instance.new("TextLabel")
	label.Parent = container
	label.Text = char
	label.Font = Enum.Font.GothamBold
	label.TextColor3 = Color3.new(1,1,1)
	label.TextStrokeTransparency = 0.9
	label.TextTransparency = 1
	label.TextSize = 36
	label.BackgroundTransparency = 1
	label.Size = UDim2.new(0,60,0,80)
	label.AnchorPoint = Vector2.new(0,0.5)
	label.Position = UDim2.new(0,(i-1)*60,0.5,30)

	local gradient = Instance.new("UIGradient")
	gradient.Parent = label
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,Color3.fromRGB(215,180,255)),
		ColorSequenceKeypoint.new(1,Color3.fromRGB(170,120,255))
	})
	gradient.Rotation = 90

	table.insert(letters,label)

	TweenService:Create(
		label,
		TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
		{
			TextTransparency = 0,
			TextSize = 64,
			Position = UDim2.new(0,(i-1)*60,0.5,0)
		}
	):Play()

	task.wait(0.18)
end

task.wait(0.5)

local subtitle = Instance.new("TextLabel")
subtitle.Parent = bg
subtitle.Text = "Version 4.2a"
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 22
subtitle.TextColor3 = Color3.fromRGB(210,210,210)
subtitle.BackgroundTransparency = 1
subtitle.TextTransparency = 1
subtitle.AnchorPoint = Vector2.new(0.5,0)
subtitle.Position = UDim2.new(0.5,0,0.57,0)
subtitle.Size = UDim2.new(0,260,0,30)

TweenService:Create(
	subtitle,
	TweenInfo.new(0.7, Enum.EasingStyle.Quad),
	{TextTransparency = 0}
):Play()

task.wait(2.5)

for _,label in ipairs(letters) do
	TweenService:Create(
		label,
		TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{
			TextTransparency = 1,
			TextSize = 30
		}
	):Play()
end

TweenService:Create(subtitle,TweenInfo.new(0.8),{TextTransparency = 1}):Play()
TweenService:Create(bg,TweenInfo.new(1),{BackgroundTransparency = 1}):Play()
TweenService:Create(blur,TweenInfo.new(1),{Size = 0}):Play()

task.wait(1)

gui:Destroy()
blur:Destroy()
