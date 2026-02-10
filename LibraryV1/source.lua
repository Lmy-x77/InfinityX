--// UI LIBRARY by you 😈

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Library = {}
Library.__index = Library

--// CREATE GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "CustomUILibrary"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

--// MAIN FRAME
local Main = Instance.new("Frame")
Main.Size = UDim2.fromScale(0.45, 0.55)
Main.Position = UDim2.fromScale(0.5, 0.5)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(25,25,25)
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 12)

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.fromScale(0.28, 1)
Sidebar.BackgroundColor3 = Color3.fromRGB(18,18,18)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 12)

--// CONTENT
local Content = Instance.new("Frame")
Content.Position = UDim2.fromScale(0.3, 0)
Content.Size = UDim2.fromScale(0.7, 1)
Content.BackgroundTransparency = 1
Content.Parent = Main

--// LAYOUTS
local TabList = Instance.new("UIListLayout", Sidebar)
TabList.Padding = UDim.new(0,6)
TabList.HorizontalAlignment = Enum.HorizontalAlignment.Center

Library.Tabs = {}

--// NEW LIB
function Library.new()
	return setmetatable({}, Library)
end

--// CREATE TAB
function Library:AddTab(name)
	local TabButton = Instance.new("TextButton")
	TabButton.Size = UDim2.fromScale(0.9, 0.08)
	TabButton.Text = name
	TabButton.Font = Enum.Font.GothamBold
	TabButton.TextSize = 14
	TabButton.TextColor3 = Color3.fromRGB(220,220,220)
	TabButton.BackgroundColor3 = Color3.fromRGB(35,35,35)
	TabButton.BorderSizePixel = 0
	TabButton.Parent = Sidebar
	Instance.new("UICorner", TabButton).CornerRadius = UDim.new(0,8)

	local Page = Instance.new("ScrollingFrame")
	Page.Size = UDim2.fromScale(1,1)
	Page.CanvasSize = UDim2.new(0,0,0,0)
	Page.ScrollBarImageTransparency = 1
	Page.Visible = false
	Page.Parent = Content

	local Layout = Instance.new("UIListLayout", Page)
	Layout.Padding = UDim.new(0,8)

	TabButton.MouseButton1Click:Connect(function()
		for _,v in pairs(Content:GetChildren()) do
			if v:IsA("ScrollingFrame") then
				v.Visible = false
			end
		end
		Page.Visible = true
	end)

	local Tab = {}

	--// BUTTON
	function Tab:AddButton(text, callback)
		local Button = Instance.new("TextButton")
		Button.Size = UDim2.fromScale(0.95, 0.09)
		Button.Text = text
		Button.Font = Enum.Font.Gotham
		Button.TextSize = 13
		Button.TextColor3 = Color3.fromRGB(230,230,230)
		Button.BackgroundColor3 = Color3.fromRGB(40,40,40)
		Button.BorderSizePixel = 0
		Button.Parent = Page
		Instance.new("UICorner", Button).CornerRadius = UDim.new(0,6)

		Button.MouseButton1Click:Connect(function()
			if callback then
				callback()
			end
		end)
	end

	--// TOGGLE
	function Tab:AddToggle(text, callback)
		local Toggle = Instance.new("TextButton")
		Toggle.Size = UDim2.fromScale(0.95, 0.09)
		Toggle.Text = "[ OFF ]  "..text
		Toggle.Font = Enum.Font.Gotham
		Toggle.TextSize = 13
		Toggle.TextColor3 = Color3.fromRGB(230,230,230)
		Toggle.BackgroundColor3 = Color3.fromRGB(40,40,40)
		Toggle.BorderSizePixel = 0
		Toggle.Parent = Page
		Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,6)

		local State = false

		Toggle.MouseButton1Click:Connect(function()
			State = not State
			Toggle.Text = State and "[ ON ]  "..text or "[ OFF ]  "..text
			if callback then
				callback(State)
			end
		end)
	end

	return Tab
end

return Library
