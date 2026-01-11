local TweenService = game:GetService("TweenService")
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)

local blur = Instance.new("BlurEffect", game.Lighting)
blur.Size = 0

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 420, 0, 240)
Frame.Position = UDim2.new(0.5, -210, 0.5, -120)
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

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 12)

local Header = Instance.new("Frame", Frame)
Header.Size = UDim2.new(1, 0, 0, 46)
Header.BackgroundTransparency = 1

local Icon = Instance.new("ImageLabel", Header)
Icon.Size = UDim2.new(0, 26, 0, 26)
Icon.Position = UDim2.new(0, 14, 0.5, -13)
Icon.BackgroundTransparency = 1
Icon.Image = "rbxassetid://72212320253117"

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -60, 1, 0)
Title.Position = UDim2.new(0, 52, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "InfinityX - Error Log"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left

local Text = Instance.new("TextLabel", Frame)
Text.Size = UDim2.new(1, -40, 0, 130)
Text.Position = UDim2.new(0, 20, 0, 45)
Text.BackgroundTransparency = 1
Text.TextWrapped = true
Text.RichText = true

local executor = "Unknown Executor"
if identifyexecutor then
	executor = identifyexecutor()
elseif getexecutorname then
	executor = getexecutorname()
end

Text.Text = "<font size='14' color='#E0E0E0'>We have detected that the exploit you are currently using,</font><font size='15' color='#00FFCC'><b> \"" .. executor .. "\"</b></font><font size='14' color='#E0E0E0'> does not fully support some of the functions required to run this script properly.</font><font size='13' color='#FFD166'> You may continue anyway by pressing the button below and executing the script normally.</font>\n<font size='13' color='#FF6B6B'><b>WARNING:</b> If you choose to proceed, do not complain about potential issues or unexpected behavior.</font>"
Text.Font = Enum.Font.Gotham
Text.TextSize = 18
Text.TextXAlignment = Enum.TextXAlignment.Left
Text.TextYAlignment = Enum.TextYAlignment.Top
Text.TextScaled = true

local ButtonContainer = Instance.new("Frame", Frame)
ButtonContainer.Size = UDim2.new(1, -40, 0, 44)
ButtonContainer.Position = UDim2.new(0, 20, 1, -60)
ButtonContainer.BackgroundTransparency = 1

local UIList = Instance.new("UIListLayout", ButtonContainer)
UIList.FillDirection = Enum.FillDirection.Horizontal
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 14)

local Button1 = Instance.new("TextButton", ButtonContainer)
Button1.Size = UDim2.new(0.5, -7, 1, 0)
Button1.Text = "Run Script"
Button1.BackgroundColor3 = Color3.fromRGB(70, 70, 200)
Button1.TextColor3 = Color3.new(1, 1, 1)
Button1.Font = Enum.Font.GothamBold
Button1.TextSize = 16
Instance.new("UICorner", Button1).CornerRadius = UDim.new(0, 10)

local Button2 = Instance.new("TextButton", ButtonContainer)
Button2.Size = UDim2.new(0.5, -7, 1, 0)
Button2.Text = "Close"
Button2.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
Button2.TextColor3 = Color3.new(1, 1, 1)
Button2.Font = Enum.Font.GothamBold
Button2.TextSize = 16
Instance.new("UICorner", Button2).CornerRadius = UDim.new(0, 10)

local function HoverEffect(button, baseColor, hoverColor)
	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = hoverColor
	end)
	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = baseColor
	end)
end

HoverEffect(Button1, Color3.fromRGB(70, 70, 200), Color3.fromRGB(95, 95, 230))
HoverEffect(Button2, Color3.fromRGB(200, 70, 70), Color3.fromRGB(230, 95, 95))

TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	BackgroundTransparency = 0.05
}):Play()
TweenService:Create(blur, TweenInfo.new(0.5), {Size = 22}):Play()

local function CloseUI()
	local fadeOut = TweenService:Create(Frame, TweenInfo.new(0.6), {BackgroundTransparency = 1})
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
end

Button1.MouseButton1Click:Connect(function()
	read = true
	CloseUI()
end)

Button2.MouseButton1Click:Connect(function()
	CloseUI()
end)
