Services = setmetatable({}, {
    __index = function(self, name)
        local success, cache = pcall(function()
            return cloneref(game:GetService(name))
        end)
        if success then
            rawset(self, name, cache)
            return cache
        else
            error("Invalid Service: " .. tostring(name))
        end
    end
})

local Players = Services.Players
local RunService = Services.RunService
local TweenService = Services.TweenService
local Stats = Services.Stats
local UIS = Services.UserInputService

local plr = Players.LocalPlayer

if plr:WaitForChild("PlayerGui"):FindFirstChild("InfinityX_UI") then
    plr:WaitForChild("PlayerGui"):FindFirstChild("InfinityX_UI"):Destroy()
    task.wait(1)
end

local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "InfinityX_UI"
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 285, 0, 170)
main.Position = UDim2.new(0.5, -142, 0.5, -85)
main.BackgroundColor3 = Color3.fromRGB(22,22,26)
main.BorderSizePixel = 0
main.Active = true

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0,6)

local stroke = Instance.new("UIStroke", main)
stroke.Thickness = 0.8
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
stroke.Color = Color3.new(1, 1, 1)

local gradient = Instance.new("UIGradient", stroke)
gradient.Rotation = 180
gradient.Color = ColorSequence.new{
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 120, 255)),
	ColorSequenceKeypoint.new(0.33, Color3.fromRGB(150, 80, 255)),
	ColorSequenceKeypoint.new(0.66, Color3.fromRGB(120, 40, 220)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 150, 255))
}
gradient.Transparency = NumberSequence.new{
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.5, 1),
	NumberSequenceKeypoint.new(1, 0)
}

task.spawn(function()
	while true do
		gradient.Rotation = (gradient.Rotation + 3) % 360
		RunService.RenderStepped:Wait()
	end
end)

local top = Instance.new("Frame", main)
top.Size = UDim2.new(1,0,0,36)
top.BackgroundColor3 = Color3.fromRGB(30,30,35)
top.BorderSizePixel = 0

local topCorner = Instance.new("UICorner", top)
topCorner.CornerRadius = UDim.new(0,6)

local hider = Instance.new("Frame", top)
hider.Size = UDim2.new(1,0,0,6)
hider.Position = UDim2.new(0,0,1,-6)
hider.BackgroundColor3 = top.BackgroundColor3
hider.BorderSizePixel = 0

local divider = Instance.new("Frame", main)
divider.Size = UDim2.new(1,-20,0,1)
divider.Position = UDim2.new(0,10,0,36)
divider.BackgroundColor3 = Color3.fromRGB(60,60,70)
divider.BorderSizePixel = 0

local logo = Instance.new("ImageLabel", top)
logo.Size = UDim2.new(0,22,0,22)
logo.Position = UDim2.new(0,8,0.5,-11)
logo.BackgroundTransparency = 1
logo.Image = "rbxassetid://92308401887821"

local title = Instance.new("TextLabel", top)
title.Size = UDim2.new(1,-60,1,0)
title.Position = UDim2.new(0,36,0,0)
title.BackgroundTransparency = 1
title.Text = "InfinityX - Afk Protection"
title.TextColor3 = Color3.fromRGB(255,255,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local close = Instance.new("TextButton", top)
close.Size = UDim2.new(0,24,0,24)
close.Position = UDim2.new(1,-28,0.5,-12)
close.Text = "X"
close.Font = Enum.Font.GothamBold
close.TextSize = 15
close.TextColor3 = Color3.fromRGB(255,255,255)
close.BackgroundTransparency = 1
close.BorderSizePixel = 0

local infoFrame = Instance.new("Frame", main)
infoFrame.Size = UDim2.new(1,-20,1,-55)
infoFrame.Position = UDim2.new(0,10,0,45)
infoFrame.BackgroundTransparency = 1

local function createRow(text,y)
	local row = Instance.new("Frame", infoFrame)
	row.Size = UDim2.new(1,0,0,26)
	row.Position = UDim2.new(0,0,0,y)
	row.BackgroundTransparency = 1
	
	local left = Instance.new("TextLabel", row)
	left.Size = UDim2.new(0.5,0,1,0)
	left.BackgroundTransparency = 1
	left.Text = text
	left.TextColor3 = Color3.fromRGB(255,255,255)
	left.Font = Enum.Font.GothamBold
	left.TextSize = 13
	left.TextXAlignment = Enum.TextXAlignment.Left
	
	local right = Instance.new("TextLabel", row)
	right.Size = UDim2.new(0.5,0,1,0)
	right.Position = UDim2.new(0.5,0,0,0)
	right.BackgroundTransparency = 1
	right.Text = "0"
	right.TextColor3 = Color3.fromRGB(255,255,255)
	right.Font = Enum.Font.GothamBold
	right.TextSize = 13
	right.TextXAlignment = Enum.TextXAlignment.Right
	
	return right
end

local sessionValue = createRow("Session Time:",0)
local pingValue = createRow("Ping:",28)
local fpsValue = createRow("FPS:",56)
local versionValue = createRow("Version:",84)
versionValue.Text = "4.2a"

local fpstikcs

if fpstikcs then
    fpstikcs:Disconnect()
    fpstikcs = nil
end

local startTime = tick()
local fps = 0
local frames = 0
local last = tick()

local function formatTime(sec)
	local h = math.floor(sec/3600)
	local m = math.floor((sec%3600)/60)
	local s = math.floor(sec%60)
	return string.format("%02d:%02d:%02d",h,m,s)
end

fpstikcs = RunService.RenderStepped:Connect(function()
	frames += 1
	if tick()-last >= 1 then
		fps = frames
		frames = 0
		last = tick()
	end
	
	sessionValue.Text = formatTime(tick()-startTime)
	fpsValue.Text = tostring(fps)
	
	local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	pingValue.Text = ping.." ms"
end)

local dragging,dragInput,dragStart,startPos

local function update(input)
	local delta = input.Position - dragStart
	main.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,
		startPos.Y.Scale,startPos.Y.Offset+delta.Y)
end

top.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

top.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		update(input)
	end
end)

local hover = TweenService:Create(close,TweenInfo.new(0.2),{TextColor3 = Color3.fromRGB(255,60,60)})
local leave = TweenService:Create(close,TweenInfo.new(0.2),{TextColor3 = Color3.fromRGB(255,255,255)})

close.MouseEnter:Connect(function() hover:Play() end)
close.MouseLeave:Connect(function() leave:Play() end)

close.MouseButton1Click:Connect(function()
	gui:Destroy()
end)
