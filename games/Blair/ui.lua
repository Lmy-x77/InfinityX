local GameStatus = Instance.new("ScreenGui")
local Main = Instance.new("Frame")
local T1 = Instance.new("TextLabel")
local T2 = Instance.new("TextLabel")
local T3 = Instance.new("TextLabel")
local T4 = Instance.new("TextLabel")
local T5 = Instance.new("TextLabel")

--Properties:

GameStatus.Name = "GameStatus"
GameStatus.Parent = game:GetService('CoreGui')
GameStatus.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

Main.Name = "Main"
Main.Parent = GameStatus
Main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Main.BackgroundTransparency = 1.000
Main.BorderColor3 = Color3.fromRGB(0, 0, 0)
Main.BorderSizePixel = 0
Main.Size = UDim2.new(0, 311, 0, 210)

T1.Name = "T1"
T1.Parent = Main
T1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
T1.BackgroundTransparency = 1.000
T1.BorderColor3 = Color3.fromRGB(0, 0, 0)
T1.BorderSizePixel = 0
T1.Size = UDim2.new(0, 200, 0, 32)
T1.Font = Enum.Font.RobotoMono
T1.TextColor3 = Color3.fromRGB(255, 255, 255)
T1.TextSize = 18.000
T1.TextXAlignment = Enum.TextXAlignment.Left

T2.Name = "T2"
T2.Parent = Main
T2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
T2.BackgroundTransparency = 1.000
T2.BorderColor3 = Color3.fromRGB(0, 0, 0)
T2.BorderSizePixel = 0
T2.Position = UDim2.new(0, 0, 0.617142916, 0)
T2.Size = UDim2.new(0, 200, 0, 32)
T2.Font = Enum.Font.RobotoMono
T2.TextColor3 = Color3.fromRGB(255, 255, 255)
T2.TextSize = 18.000
T2.TextXAlignment = Enum.TextXAlignment.Left

T3.Name = "T3"
T3.Parent = Main
T3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
T3.BackgroundTransparency = 1.000
T3.BorderColor3 = Color3.fromRGB(0, 0, 0)
T3.BorderSizePixel = 0
T3.Position = UDim2.new(0, 0, 0.462857127, 0)
T3.Size = UDim2.new(0, 200, 0, 32)
T3.Font = Enum.Font.RobotoMono
T3.TextColor3 = Color3.fromRGB(255, 255, 255)
T3.TextSize = 18.000
T3.TextXAlignment = Enum.TextXAlignment.Left

T4.Name = "T4"
T4.Parent = Main
T4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
T4.BackgroundTransparency = 1.000
T4.BorderColor3 = Color3.fromRGB(0, 0, 0)
T4.BorderSizePixel = 0
T4.Position = UDim2.new(0, 0, 0.308571458, 0)
T4.Size = UDim2.new(0, 200, 0, 32)
T4.Font = Enum.Font.RobotoMono
T4.TextColor3 = Color3.fromRGB(255, 255, 255)
T4.TextSize = 18.000
T4.TextXAlignment = Enum.TextXAlignment.Left

T5.Name = "T5"
T5.Parent = Main
T5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
T5.BackgroundTransparency = 1.000
T5.BorderColor3 = Color3.fromRGB(0, 0, 0)
T5.BorderSizePixel = 0
T5.Position = UDim2.new(0, 0, 0.154285684, 0)
T5.Size = UDim2.new(0, 200, 0, 32)
T5.Font = Enum.Font.RobotoMono
T5.TextColor3 = Color3.fromRGB(255, 255, 255)
T5.TextSize = 18.000
T5.TextXAlignment = Enum.TextXAlignment.Left

-- Scripts:

local function RIMAAA_fake_script() -- Main.LocalScript 
	local script = Instance.new('LocalScript', Main)

	local FreezeTemperatureText = script.Parent.T1
	local OrbsText = script.Parent.T2
	local WrintingBookText = script.Parent.T3
	local PrintsText = script.Parent.T4
	local SpiritBoxText = script.Parent.T5
	
	
	function GetWritingBook()
		local itemsFolder = workspace.Map:FindFirstChild("Items")
		if not itemsFolder then
			return "no"
		end
	
		for _, v in pairs(itemsFolder:GetChildren()) do
			if v:IsA("Tool") and v.Name == "Ghost Writing Book" then
				local writtenValue = v:FindFirstChild("Written")
				if writtenValue and writtenValue.Value == true then
					return "yes"
				end
			end
		end
	
		return "no"
	end
	local GetFreezeTemperatureStatus = 'no'
	local CurrentGhostRoom = 'none'
	local FreezeTemperatureConnection = nil
	function GetFreezeTemperature()
		local lowestValue = math.huge
		local lowestParent = nil
	
		for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
			if v:IsA("NumberValue") and v.Name:lower():find("temperature") and v.Parent.Parent.Name ~= "Outside" then
				if v.Value < lowestValue then
					lowestValue = v.Value
					lowestParent = v.Parent
				end
			end
		end
	
		if FreezeTemperatureConnection then
			FreezeTemperatureConnection:Disconnect()
		end
	
		FreezeTemperatureConnection = game:GetService("RunService").Stepped:Connect(function()
			if lowestParent then
				for _, val in pairs(lowestParent:GetChildren()) do
					if val:IsA("NumberValue") and val.Name:lower():find("temperature") then
						if val.Value < 0 then
							GetFreezeTemperatureStatus = "yes"
							if FreezeTemperatureConnection then
								FreezeTemperatureConnection:Disconnect()
							end
							break
						end
					end
				end
			end
		end)
	
		GetFreezeTemperatureStatus = "no"
	end
	GetFreezeTemperature()
	function GetGhostRoomTemperature()
		local lowestValue = math.huge
		local lowestParent = nil
		for _, v in pairs(workspace.Map.Zones:GetDescendants()) do
			if v:IsA("NumberValue") and v.Name:find('LocalBaseTemp') and v.Parent.Parent.Name ~= 'Outside' then
				if v.Value < lowestValue then
					lowestValue = v.Value
					lowestParent = v.Parent.Parent
					CurrentGhostRoom = v.Parent.Parent.Name
				end
			end
		end
	
		if lowestParent and lowestParent:FindFirstChildWhichIsA('NumberValue') then
			local temp = lowestParent:FindFirstChildWhichIsA('NumberValue').Value
			temp = math.floor(temp * 1000 + 0.5) / 1000
			return tostring(temp)
		end
	end
	function GetOrbs()
		local findpart = workspace.Map.Orbs:FindFirstChild('OrbPart')
		if findpart then
			return 'yes'
		else
			return 'no'
		end
	end
	function GetPrints()
		if #workspace.Map.Prints:GetChildren() > 0 then
			return 'yes'
		else
			return 'no'
		end
	end
	local GetSpiritBoxStatus = 'no'
	local spiritBoxConnection = nil
	function GetSpritBox()
		local player = game:GetService("Players").LocalPlayer
		local playerGui = player:WaitForChild("PlayerGui")
		local radioFrame = playerGui:WaitForChild("Radio"):WaitForChild("Frame")
		spiritBoxConnection = radioFrame.ChildAdded:Connect(function(Message)
			if Message:IsA('Frame') and Message.Name == 'Message' then
				GetSpiritBoxStatus = 'yes'
				if spiritBoxConnection then
					spiritBoxConnection:Disconnect()
				end
			end
		end)
	end
	GetSpritBox()
	
	
	spawn(function()
		while true do task.wait()
			FreezeTemperatureText.Text = '• Freeze Temperature: ' .. GetFreezeTemperatureStatus
			OrbsText.Text = '• Orbs | Particle: ' .. GetOrbs()
			WrintingBookText.Text = '• Writing Book: ' .. GetWritingBook()
			PrintsText.Text = '• Prints | UV: ' .. GetPrints()
			SpiritBoxText.Text = '• Spirit Box: ' .. GetSpiritBoxStatus
		end
	end)
	
	
end
coroutine.wrap(RIMAAA_fake_script)()
