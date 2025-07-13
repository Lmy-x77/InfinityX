-- source
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")

local function create(class, props)
	local inst = Instance.new(class)
	for k, v in pairs(props) do
		inst[k] = v
	end
	return inst
end

local blur = create("BlurEffect", {
	Parent = game:GetService("Lighting"),
	Size = 12
})

local gui = create("ScreenGui", {
	Name = "InfinityX - Key System",
	Parent = CoreGui,
	ResetOnSpawn = false
})

local main = create("Frame", {
	Parent = gui,
	Size = UDim2.new(0, 420, 0, 300),
	Position = UDim2.new(0.5, -210, 0.5, -150),
	BackgroundColor3 = Color3.fromRGB(24, 24, 24),
	BorderSizePixel = 0
})
create("UICorner", {Parent = main, CornerRadius = UDim.new(0, 6)})

local header = create("Frame", {
	Parent = main,
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundColor3 = Color3.fromRGB(32, 32, 32),
	BorderSizePixel = 0
})
create("UICorner", {Parent = header, CornerRadius = UDim.new(0, 6)})

local title = create("TextLabel", {
	Parent = header,
	Text = "InfinityX - Key System",
	Font = Enum.Font.GothamBold,
	TextScaled = true,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundTransparency = 1,
	Size = UDim2.new(0.9, 0, 0.45, 0),
	Position = UDim2.new(0.05, 0, 0.25, 0),
	TextXAlignment = Enum.TextXAlignment.Center
})

local closeBtn = create("TextButton", {
	Parent = header,
	Text = "X",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = Color3.fromRGB(255, 255, 255),
	BackgroundColor3 = Color3.fromRGB(200, 50, 50),
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(1, -40, 0.5, -15),
	BorderSizePixel = 0
})
create("UICorner", {Parent = closeBtn, CornerRadius = UDim.new(0, 4)})

local subtitle = create("TextLabel", {
	Parent = main,
	Position = UDim2.new(0.1, 0, 0, 60),
	Size = UDim2.new(0.8, 0, 0, 15),
	BackgroundTransparency = 1,
	Text = "Get Key For InfinityX",
	TextColor3 = Color3.fromRGB(200, 200, 200),
	Font = Enum.Font.GothamBold,
	TextScaled = true
})

local versiontitle = create("TextLabel", {
	Parent = main,
	Position = UDim2.new(0.1, 0, 0, 280),
	Size = UDim2.new(0.8, 0, 0, 15),
	BackgroundTransparency = 1,
	Text = "Version: 4.2a",
	TextColor3 = Color3.fromRGB(139, 139, 139),
	TextTransparency = 0.5,
	Font = Enum.Font.GothamBold,
	TextScaled = true
})

local textbox = create("TextBox", {
	Parent = main,
	Size = UDim2.new(0.9, 0, 0, 35),
	Position = UDim2.new(0.05, 0, 0, 100),
	Text = "",
	PlaceholderText = "Enter Key",
	BackgroundColor3 = Color3.fromRGB(18, 18, 18),
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.Gotham,
	TextSize = 14,
	BorderSizePixel = 0,
	ClearTextOnFocus = false
})
create("UICorner", {Parent = textbox, CornerRadius = UDim.new(0, 4)})

local function makeButton(text, pos)
	local btn = create("TextButton", {
		Parent = main,
		Size = UDim2.new(0.425, 0, 0, 35),
		Position = pos,
		Text = text,
		BackgroundColor3 = Color3.fromRGB(40, 40, 40),
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Font = Enum.Font.GothamBold,
		TextSize = 14,
		BorderSizePixel = 0
	})
	create("UICorner", {Parent = btn, CornerRadius = UDim.new(0, 4)})

	btn.MouseEnter:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
	end)
	btn.MouseLeave:Connect(function()
		TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}):Play()
	end)

	return btn
end

local CheckKey = makeButton("Check Key", UDim2.new(0.05, 0, 0, 150))
CheckKey.MouseButton1Click:Connect(function()
  CheckKey.Text = "Checking key..."
  writefile('InfinityX/Key-System/key.lua', textbox.Text)
  wait(.2)
  warn('Key-System: '..readfile('InfinityX/Key-System/key.lua'))
  wait(2)
  if readfile('InfinityX/Key-System/key.lua') == key then
    CheckKey.Text = "Corrent key!"
    wait(1.2)
    correctKey = true
    gui:Destroy()
    blur:Destroy()
  else
    CheckKey.Text = "Wrong key!"
    wait(1)
    CheckKey.Text = "Check Key"
  end
end)

local GetKey = makeButton("Get Key", UDim2.new(0.525, 0, 0, 150))
GetKey.MouseButton1Click:Connect(function()
	setclipboard(url)
  GetKey.Text = "Copied!"
  wait(1)
  GetKey.Text = "Get Key"
end)

local logo = create("ImageLabel", {
	Parent = header,
	Size = UDim2.new(0, 30, 0, 30),
	Position = UDim2.new(0, 8, 0.5, -15),
	BackgroundTransparency = 1,
	Image = "rbxassetid://126527122577864"
})

local discordBtn = create("TextButton", {
	Parent = main,
	Size = UDim2.new(0.9, 0, 0, 35),
	Position = UDim2.new(0.05, 0, 0, 200),
	Text = "Join the Discord Server",
	BackgroundColor3 = Color3.fromRGB(0, 180, 100),
	TextColor3 = Color3.fromRGB(255, 255, 255),
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	BorderSizePixel = 0
})
discordBtn.MouseButton1Click:Connect(function()
  setclipboard("https://discord.gg/emKJgWMHAr")
  discordBtn.Text = "Copied!"
  wait(1)
  discordBtn.Text = "Join the Discord Server"
end)
create("UICorner", {Parent = discordBtn, CornerRadius = UDim.new(0, 4)})

discordBtn.MouseEnter:Connect(function()
	TweenService:Create(discordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 120)}):Play()
end)
discordBtn.MouseLeave:Connect(function()
	TweenService:Create(discordBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 180, 100)}):Play()
end)
closeBtn.MouseButton1Click:Connect(function()
  TweenService:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
    Size = UDim2.new(0, 0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0)
  }):Play()
  wait(.2)
  discordBtn:Destroy()
  GetKey:Destroy()
  CheckKey:Destroy()
  textbox:Destroy()
  closeBtn:Destroy()
  blur:Destroy()
  versiontitle:Destroy()
  logo:Destroy()
  wait(.4)
  gui:Destroy()
end)
