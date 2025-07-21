local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local gui = Instance.new("ScreenGui")
gui.Name = "NotSupportedUI"
gui.IgnoreGuiInset = true
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0
TweenService:Create(blur, TweenInfo.new(0.4), {Size = 15}):Play()

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 0, 0, 0)
frame.Position = UDim2.new(0.5, 0, 0.5, 0)
frame.BackgroundColor3 = Color3.fromRGB(28, 16, 38)
frame.BorderSizePixel = 0
frame.BackgroundTransparency = 0

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1.5
stroke.Transparency = 0.1
stroke.Color = Color3.fromRGB(150, 90, 200)

local strokeGradient = Instance.new("UIGradient", stroke)
strokeGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 180)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 80, 255))
})
strokeGradient.Rotation = 0

local gradient = Instance.new("UIGradient", frame)
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 30, 60)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 12, 34))
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
content.Text = "The game you are trying to run the script in is not compatible with InfintiyX.\nPlease refer to our RScripts profile or join our Discord for a list of supported games."
content.Font = Enum.Font.Gotham
content.TextWrapped = true
content.TextYAlignment = Enum.TextYAlignment.Center
content.TextScaled = true
content.TextColor3 = Color3.fromRGB(230, 230, 230)

local button = Instance.new("TextButton", frame)
button.Size = UDim2.new(0, 120, 0, 34)
button.Position = UDim2.new(0.5, -60, 1, -44)
button.BackgroundColor3 = Color3.fromRGB(130, 80, 255)
button.Text = "Copy Discord Link"
button.Font = Enum.Font.GothamSemibold
button.TextSize = 14
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0
Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

button.MouseEnter:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 125, 0, 36)}):Play()
end)
button.MouseLeave:Connect(function()
	TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(0, 120, 0, 34)}):Play()
end)

TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 380, 0, 200),
	Position = UDim2.new(0.5, -190, 0.5, -100)
}):Play()

local function close()
	local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Notify/source.lua", true))()
	lib.notify("Discord link copied to clipboard!")
	setclipboard("https://discord.gg/emKJgWMHAr")

	wait(1)

    for _, obj in ipairs({title, content, button}) do
    	if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA('Frame') then
    		TweenService:Create(obj, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            button:Destroy()
            title.Visible = false
            content.Visible = false
        end
    end

	TweenService:Create(frame, TweenInfo.new(0.3), {
		BackgroundTransparency = 1
	}):Play()

	TweenService:Create(frame, TweenInfo.new(0.35), {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}):Play()

	wait(0.4)
	blur:Destroy()
	gui:Destroy()
end
button.MouseButton1Click:Connect(close)

task.spawn(function()
	while gui and gui.Parent do
		strokeGradient.Rotation = (strokeGradient.Rotation + 1) % 360
		RunService.RenderStepped:Wait()
	end
end)
