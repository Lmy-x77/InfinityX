local notify = {}

local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local function create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	return inst
end

local gui = CoreGui:FindFirstChild("InfinityX-Notify") or create("ScreenGui", {
	Name = "InfinityX-Notify",
	Parent = CoreGui,
	ResetOnSpawn = false
})

local notifications = {}
local baseYOffset = -50
local spacing = 45

local function updateNotificationPositions()
	for i, note in ipairs(notifications) do
		local yOffset = baseYOffset - ((i - 1) * spacing)
		TweenService:Create(note, TweenInfo.new(0.2), {
			Position = UDim2.new(1, -310, 1, yOffset)
		}):Play()
	end
end

local function notify:notify(text)
	local note = create("Frame", {
		Parent = gui,
		Size = UDim2.new(0, 300, 0, 40),
		Position = UDim2.new(1, 10, 1, baseYOffset),
		BackgroundColor3 = Color3.fromRGB(32, 32, 34),
		BorderSizePixel = 0
	})
	create("UICorner", {Parent = note, CornerRadius = UDim.new(0, 6)})

	local label = create("TextLabel", {
		Parent = note,
		Size = UDim2.new(1, -20, 1, 0),
		Position = UDim2.new(0, 10, 0, 0),
		Text = text,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.Gotham,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		BackgroundTransparency = 1
	})

	table.insert(notifications, 1, note)
	updateNotificationPositions()

	TweenService:Create(note, TweenInfo.new(0.4, Enum.EasingStyle.Sine), {
		Position = UDim2.new(1, -310, 1, baseYOffset)
	}):Play()

	task.delay(2, function()
		TweenService:Create(note, TweenInfo.new(0.3), {
			BackgroundTransparency = 1,
			Position = UDim2.new(1, 10, 1, baseYOffset)
		}):Play()
		wait(0.3)
		note:Destroy()
		table.remove(notifications, table.find(notifications, note))
		updateNotificationPositions()
	end)
end

return notify
