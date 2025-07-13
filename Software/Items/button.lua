-- (VOID) : Gui to Lua
-- Version: 1.4

-- Instances:

local Button = Instance.new("ScreenGui")
local Main = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")
local Icon = Instance.new("ImageLabel")
local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

--Properties:

Button.Name = "Button"
Button.Parent = (game:GetService("CoreGui") or gethui())
Button.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = Button
Main.BackgroundColor3 = Color3.fromRGB(31, 31, 31)
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Position = UDim2.new(0.0429799445, 0, 0.117917307, 0)
Main.Size = UDim2.new(0.0486237705, 0, 0.0842266455, 0)
Main.AutoButtonColor = false
Main.Font = Enum.Font.SourceSans
Main.Text = ""
Main.TextColor3 = Color3.fromRGB(0, 0, 0)
Main.TextSize = 14.000

UICorner.CornerRadius = UDim.new(0.100000001, 0)
UICorner.Parent = Main

Icon.Name = "Icon"
Icon.Parent = Main
Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Icon.BackgroundTransparency = 1.000
Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
Icon.BorderSizePixel = 0
Icon.Position = UDim2.new(0.0447446592, 1, 0.114989087, 0)
Icon.Size = UDim2.new(0.886666656, 0, 1.3909086, 0)
Icon.Image = "http://www.roblox.com/asset/?id=126527122577864"

UIAspectRatioConstraint.Parent = Icon
UIAspectRatioConstraint.AspectRatio = 1.154

UIAspectRatioConstraint_2.Parent = Main
UIAspectRatioConstraint_2.AspectRatio = 1.023

-- Scripts:

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
