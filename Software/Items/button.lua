local Button = Instance.new("ScreenGui")
local Main = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local Icon = Instance.new("ImageLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")
local UIStroke = Instance.new("UIStroke")
local UIGradient = Instance.new("UIGradient")

local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")


Button.Name = "Button"
Button.Parent = (game:GetService("CoreGui") or gethui())
Button.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Button.ResetOnSpawn = false

Main.Name = "Main"
Main.Parent = Button
Main.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.043, 0, 0.12, 0)
Main.Size = UDim2.new(0.05, 0, 0.085, 0)
Main.AutoButtonColor = false
Main.Font = Enum.Font.GothamBold
Main.Text = ""
Main.TextColor3 = Color3.fromRGB(255, 255, 255)
Main.TextSize = 14

UICorner.CornerRadius = UDim.new(0.25, 0)
UICorner.Parent = Main

Icon.Name = "Icon"
Icon.Parent = Main
Icon.BackgroundTransparency = 1
Icon.Size = UDim2.new(0.85, 0, 0.85, 0)
Icon.Position = UDim2.new(0.075, 0, 0.075, 0)
Icon.Image = "http://www.roblox.com/asset/?id=126527122577864"
Icon.ImageColor3 = Color3.fromRGB(220, 220, 220)

UIAspectRatioConstraint.Parent = Icon
UIAspectRatioConstraint.AspectRatio = 1.1

UIAspectRatioConstraint_2.Parent = Main
UIAspectRatioConstraint_2.AspectRatio = 1.02

UIStroke.Parent = Main
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Color = Color3.new(1, 1, 1)

UIGradient.Parent = UIStroke
UIGradient.Rotation = 0
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 255)), -- rosa
	ColorSequenceKeypoint.new(1, Color3.fromRGB(130, 0, 255))  -- roxo
}


task.spawn(function()
	while true do
		UIGradient.Rotation = (UIGradient.Rotation + 1) % 360
		RunService.RenderStepped:Wait()
	end
end)


local defaultColor = Main.BackgroundColor3
local hoverColor = Color3.fromRGB(55, 55, 60)

Main.MouseEnter:Connect(function()
	TweenService:Create(Main, TweenInfo.new(0.2), {BackgroundColor3 = hoverColor}):Play()
end)

Main.MouseLeave:Connect(function()
	TweenService:Create(Main, TweenInfo.new(0.2), {BackgroundColor3 = defaultColor}):Play()
end)




local function MHFYJL_fake_script() -- Main.hideUi 
	local script = Instance.new('LocalScript', Main)

        local button = script.Parent
        local function toggleVisibility()
			local VirtualInputManager = game:GetService("VirtualInputManager")
			VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.K, false, nil)
			task.wait(0.1)
			VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.K, false, nil)
        end

        button.TouchTap:Connect(toggleVisibility)
end
coroutine.wrap(MHFYJL_fake_script)()
local function QFEYM_fake_script() -- Main.dragable 
	local script = Instance.new('LocalScript', Main)

	local frame = script.Parent
	local userInputService = game:GetService("UserInputService")
	
	local dragging = false
	local dragStart, startPos
	
	local function update(input)
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
	
	frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = frame.Position
	
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)
	
	frame.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
	
	userInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			update(input)
		end
	end)
	
end
coroutine.wrap(QFEYM_fake_script)()
