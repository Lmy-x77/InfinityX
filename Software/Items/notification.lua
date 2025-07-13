local TweenService = game:GetService("TweenService")

local gui = Instance.new("ScreenGui")
gui.Name = "NotSupportedUI"
gui.Parent = game.CoreGui
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false

local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(0.4), {Size = 15}):Play()

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 360, 0, 200)
frame.Position = UDim2.new(0.5, -180, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(26, 14, 29)
frame.BackgroundTransparency = 0.05
frame.BorderSizePixel = 0

local corner = Instance.new("UICorner", frame)
corner.CornerRadius = UDim.new(0, 3)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
stroke.Transparency = 0.1
stroke.Color = Color3.fromRGB(140, 80, 180)

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 20, 50)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 10, 30))
}
gradient.Rotation = 90

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Position = UDim2.new(0, 0, 0, 15)
title.BackgroundTransparency = 1
title.Text = "Game Not Supported"
title.Font = Enum.Font.GothamBlack
title.TextSize = 26
title.TextColor3 = Color3.fromRGB(255, 255, 255)

local content = Instance.new("TextLabel", frame)
content.Size = UDim2.new(1, -40, 0, 80)
content.Position = UDim2.new(0, 20, 0, 60)
content.BackgroundTransparency = 1
content.Text = "The game you're trying to run InfinityX on is not supported.\nVisit our RScripts profile to see supported games or join discord server."
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextYAlignment = Enum.TextYAlignment.Top
content.TextScaled = true
content.TextColor3 = Color3.fromRGB(230, 230, 230)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 120, 0, 34)
button.Position = UDim2.new(0.5, -60, 1, -44)
button.BackgroundColor3 = Color3.fromRGB(120, 70, 255)
button.Text = "Copy discord link"
button.Font = Enum.Font.GothamSemibold
button.TextSize = 15
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0

local buttonCorner = Instance.new("UICorner", button)
buttonCorner.CornerRadius = UDim.new(0, 4)

button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 125, 0, 36)}):Play()
end)

button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 34)}):Play()
end)

local function close()
    local info = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/library/Info/source.lua", true))()
    info:Notify('InfinityX', 'Link copied to your clipboard!')
    setclipboard('https://discord.gg/emKJgWMHAr')
    wait(1)
	TweenService:Create(frame, TweenInfo.new(0.35), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()
	wait(0.1)
    title:Destroy()
	blur:Destroy()
    content:Destroy()
    wait(.20)
    button.Visible = false
	gui:Destroy()
end

button.MouseButton1Click:Connect(function()
	close()
end)
