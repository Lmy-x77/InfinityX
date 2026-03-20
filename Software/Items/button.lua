Services = setmetatable({}, {
  __index = function(self, name)
    local ok, svc = pcall(function()
      return cloneref(game:GetService(name))
    end)
    if ok then
      rawset(self, name, svc)
      return svc
    end
  end
})

local TweenService = Services.TweenService
local RunService = Services.RunService
local CoreGui = Services.CoreGui
local VIM = Services.VirtualInputManager
local UIS = game:GetService("UserInputService")

local gui = Instance.new("ScreenGui")
gui.Name = "Button"
gui.Parent = (CoreGui or gethui())
gui.ResetOnSpawn = false

local Main = Instance.new("TextButton")
Main.Parent = gui
Main.Size = UDim2.fromOffset(45,45)
Main.Position = UDim2.new(0.05,0,0.15,0)
Main.BackgroundColor3 = Color3.fromRGB(28,22,40)
Main.BorderSizePixel = 0
Main.Text = ""

local corner = Instance.new("UICorner", Main)
corner.CornerRadius = UDim.new(1,0)

local icon = Instance.new("ImageLabel", Main)
icon.BackgroundTransparency = 1
icon.Size = UDim2.fromScale(0.7,0.7)
icon.Position = UDim2.fromScale(0.15,0.15)
icon.Image = "rbxassetid://92308401887821"
icon.ImageColor3 = Color3.fromRGB(240,230,255)

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Main
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.LineJoinMode = Enum.LineJoinMode.Round
UIStroke.Color = Color3.new(1,1,1)

local UIGradient = Instance.new("UIGradient")
UIGradient.Parent = UIStroke
UIGradient.Rotation = 0
UIGradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(170,110,255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255,140,220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(170,110,255))
}
UIGradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 0.6),
	NumberSequenceKeypoint.new(1, 0)
}

task.spawn(function()
	while true do
		UIGradient.Rotation = (UIGradient.Rotation + 2) % 360
		RunService.RenderStepped:Wait()
	end
end)

local default = Main.BackgroundColor3
local hover = Color3.fromRGB(50,40,70)

Main.MouseEnter:Connect(function()
	TweenService:Create(Main, TweenInfo.new(0.15), {BackgroundColor3 = hover}):Play()
end)

Main.MouseLeave:Connect(function()
	TweenService:Create(Main, TweenInfo.new(0.15), {BackgroundColor3 = default}):Play()
end)

local function toggle()
     if game.PlaceId == 537413528 then
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.LeftControl, false, nil)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.LeftControl, false, nil)
    elseif CoreGui:FindFirstChild("ScreenGui"):FindFirstChild("Base") then
        CoreGui.ScreenGui.Base.Visible = not CoreGui.ScreenGui.Base.Visible
    else
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.K, false, nil)
        task.wait(0.1)
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.K, false, nil)
     end
end

Main.TouchTap:Connect(toggle)

local dragging, dragStart, startPos

local function update(input)
	local delta = input.Position - dragStart
	Main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

Main.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		update(input)
	end
end)
