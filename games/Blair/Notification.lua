function missing(t, f, fallback)
    if type(f) == t then return f end
    return fallback
end
queueteleport =  missing("function", queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport))


local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 340, 0, 190)
Frame.Position = UDim2.new(0.5, -170, 0.5, -95)
Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame.BackgroundTransparency = 1
Frame.BorderSizePixel = 0
Frame.ClipsDescendants = true

local UIStroke = Instance.new("UIStroke", Frame)
UIStroke.Thickness = 1.5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Color = Color3.new(1, 1, 1)

local UIGradient = Instance.new("UIGradient", UIStroke)
UIGradient.Rotation = 0
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(130, 0, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 170, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 0, 255))
}
UIGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 1),
	NumberSequenceKeypoint.new(1, 0)
}

task.spawn(function()
	while Frame.Parent do
		UIGradient.Rotation = (UIGradient.Rotation + 1) % 360
		game:GetService("RunService").RenderStepped:Wait()
	end
end)

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 10)

local Header = Instance.new("Frame", Frame)
Header.Size = UDim2.new(1, 0, 0, 40)
Header.BackgroundTransparency = 1

local Icon = Instance.new("ImageLabel", Header)
Icon.Size = UDim2.new(0, 24, 0, 24)
Icon.Position = UDim2.new(0, 10, 0.5, -12)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://72212320253117"

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 45, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "InfinityX - Warning"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left

local Text = Instance.new("TextLabel", Frame)
Text.Size = UDim2.new(1, -30, 0, 70)
Text.Position = UDim2.new(0, 15, 0, 50)
Text.BackgroundTransparency = 1
Text.TextWrapped = true
Text.Text = "For the best possible experience, please ensure that you execute this script within the map of your choice.\nWe sincerely appreciate your support and hope you enjoy using InfinityX."
Text.TextColor3 = Color3.fromRGB(200, 200, 200)
Text.Font = Enum.Font.Gotham
Text.TextSize = 18
Text.TextXAlignment = Enum.TextXAlignment.Left
Text.TextYAlignment = Enum.TextYAlignment.Top

local Button1 = Instance.new("TextButton", Frame)
Button1.Size = UDim2.new(0.45, 0, 0, 36)
Button1.Position = UDim2.new(0.05, -6, 1, -50)
Button1.Text = "Active auto execute"
Button1.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
Button1.TextColor3 = Color3.new(1, 1, 1)
Button1.Font = Enum.Font.GothamBold
Button1.TextSize = 14
Instance.new("UICorner", Button1).CornerRadius = UDim.new(0, 8)

local Button2 = Instance.new("TextButton", Frame)
Button2.Size = UDim2.new(0.45, 0, 0, 36)
Button2.Position = UDim2.new(0.5, 6, 1, -50)
Button2.Text = "Close"
Button2.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
Button2.TextColor3 = Color3.new(1, 1, 1)
Button2.Font = Enum.Font.GothamBold
Button2.TextSize = 14
Instance.new("UICorner", Button2).CornerRadius = UDim.new(0, 8)

local function HoverEffect(button, baseColor, hoverColor)
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = hoverColor
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = baseColor
	end)
end
HoverEffect(Button1, Color3.fromRGB(70, 70, 200), Color3.fromRGB(90, 90, 220))
HoverEffect(Button2, Color3.fromRGB(200, 70, 70), Color3.fromRGB(220, 90, 90))

Frame.Size = UDim2.new(0, 300, 0, 160)
Frame.BackgroundTransparency = 1
TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Size = UDim2.new(0, 340, 0, 190),
	BackgroundTransparency = 0.05
}):Play()
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 20}):Play()

Button1.MouseButton1Click:Connect(function()
    local TeleportCheck = false
    game.Players.LocalPlayer.OnTeleport:Connect(function(State)
    	if not TeleportCheck and queueteleport then
    		TeleportCheck = true
			wait(4)
    		queueteleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Blair/source.lua'))()")
    	end
    end)

	local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 1
	})
	local blurOut = TweenService:Create(blur, TweenInfo.new(0.6), {Size = 0})

    UIGradient:Destroy()
    UIStroke:Destroy()
	for _, obj in ipairs(Frame:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") then
			TweenService:Create(obj, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
			if obj:IsA("TextButton") then
				TweenService:Create(obj, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			end
		elseif obj:IsA("ImageLabel") then
			TweenService:Create(obj, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()
		end
	end

	fadeOut:Play()
	blurOut:Play()

	fadeOut.Completed:Wait()
	ScreenGui:Destroy()
	blur:Destroy()
end)

Button2.MouseButton1Click:Connect(function()
	local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
		BackgroundTransparency = 1
	})
	local blurOut = TweenService:Create(blur, TweenInfo.new(0.6), {Size = 0})

    UIGradient:Destroy()
    UIStroke:Destroy()
	for _, obj in ipairs(Frame:GetDescendants()) do
		if obj:IsA("TextLabel") or obj:IsA("TextButton") then
			TweenService:Create(obj, TweenInfo.new(0.6), {TextTransparency = 1}):Play()
			if obj:IsA("TextButton") then
				TweenService:Create(obj, TweenInfo.new(0.6), {BackgroundTransparency = 1}):Play()
			end
		elseif obj:IsA("ImageLabel") then
			TweenService:Create(obj, TweenInfo.new(0.6), {ImageTransparency = 1}):Play()
		end
	end

	fadeOut:Play()
	blurOut:Play()

	fadeOut.Completed:Wait()
	ScreenGui:Destroy()
	blur:Destroy()
end)
