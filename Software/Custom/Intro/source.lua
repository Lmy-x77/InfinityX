local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer

local blur = Instance.new("BlurEffect", Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(0.6), {Size = 30}):Play()

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "InfinityXIntro"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local bg = Instance.new("Frame", gui)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(26, 14, 29)
bg.BackgroundTransparency = 1
TweenService:Create(bg, TweenInfo.new(0.6), {BackgroundTransparency = 0.15}):Play()

local container = Instance.new("Frame", bg)
container.AnchorPoint = Vector2.new(0.5, 0.5)
container.Position = UDim2.new(0.5, 0, 0.45, 0)
container.Size = UDim2.new(0, 500, 0, 100)
container.BackgroundTransparency = 1

local word = "INFINITYX"
local letters = {}

for i = 1, #word do
	local char = word:sub(i, i)
	local label = Instance.new("TextLabel", container)
	label.Text = char
	label.Font = Enum.Font.GothamBlack
	label.TextColor3 = Color3.new(1, 1, 1)
	label.TextStrokeTransparency = 0.8
	label.TextTransparency = 1
	label.TextSize = 50
	label.Size = UDim2.new(0, 50, 0, 60)
	label.AnchorPoint = Vector2.new(0, 0.5)
	label.Position = UDim2.new(0, (i - 1) * 55, 0.5, 0)
	label.BackgroundTransparency = 1

	local gradient = Instance.new("UIGradient", label)
	gradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(185, 100, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(147, 50, 160))
	})
	gradient.Rotation = 90

	table.insert(letters, label)
	TweenService:Create(label, TweenInfo.new(0.35), {TextTransparency = 0, TextSize = 60}):Play()
	wait(0.15)
end

wait(0.25)

local subtitle = Instance.new("TextLabel", bg)
subtitle.Text = "Version: 4.2a"
subtitle.Font = Enum.Font.GothamMedium
subtitle.TextSize = 20
subtitle.TextColor3 = Color3.fromRGB(197, 197, 197)
subtitle.TextTransparency = 1
subtitle.BackgroundTransparency = 1
subtitle.AnchorPoint = Vector2.new(0.5, 0)
subtitle.Position = UDim2.new(0.5, 0, 0.545, 0)
subtitle.Size = UDim2.new(0, 200, 0, 30)

TweenService:Create(subtitle, TweenInfo.new(0.5), {TextTransparency = 0}):Play()

wait(2)

for _, label in ipairs(letters) do
	TweenService:Create(label, TweenInfo.new(0.4), {TextTransparency = 1, TextSize = 30}):Play()
end
TweenService:Create(subtitle, TweenInfo.new(0.4), {TextTransparency = 1}):Play()
TweenService:Create(bg, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 0}):Play()

wait(0.6)

gui:Destroy()
blur:Destroy()
