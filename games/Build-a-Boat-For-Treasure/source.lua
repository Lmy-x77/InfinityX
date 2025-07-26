-- detect service
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
  print("Mobile device")
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Items/button.lua",true))()
elseif not IsOnMobile then
  print("Computer device")
end


-- start
print[[                                                                     

 /$$$$$$            /$$$$$$  /$$           /$$   /$$               /$$   /$$
|_  $$_/           /$$__  $$|__/          |__/  | $$              | $$  / $$
| $$   /$$$$$$$ | $$  \__/ /$$ /$$$$$$$  /$$ /$$$$$$   /$$   /$$|  $$/ $$/
| $$  | $$__  $$| $$$$    | $$| $$__  $$| $$|_  $$_/  | $$  | $$ \  $$$$/ 
| $$  | $$  \ $$| $$_/    | $$| $$  \ $$| $$  | $$    | $$  | $$  >$$  $$ 
| $$  | $$  | $$| $$      | $$| $$  | $$| $$  | $$ /$$| $$  | $$ /$$/\  $$
/$$$$$$| $$  | $$| $$      | $$| $$  | $$| $$  |  $$$$/|  $$$$$$$| $$  \ $$
|______/|__/  |__/|__/      |__/|__/  |__/|__/   \___/   \____  $$|__/  |__/
                                                       /$$  | $$          
                                                      |  $$$$$$/          
                                                       \______/           
]]


-- variables
local velocityHandlerName = 'valocityHandler'
local gyroHandlerName = 'gyroHander'
local mfly1
local mfly2
FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1
function missing(t, f, fallback)
  if type(f) == t then return f end
  return fallback
end
cloneref = missing("function", cloneref, function(...) return ... end)
local Players = game.Players
Mouse = cloneref(Players.LocalPlayer:GetMouse())
function getRoot(char)
  local rootPart = char:FindFirstChild('HumanoidRootPart') or char:FindFirstChild('Torso') or char:FindFirstChild('UpperTorso')
  return rootPart
end
local unmobilefly = function(speaker)
	pcall(function()
		FLYING = false
		local root = getRoot(speaker.Character)
		root:FindFirstChild(velocityHandlerName):Destroy()
		root:FindFirstChild(gyroHandlerName):Destroy()
		speaker.Character:FindFirstChildWhichIsA("Humanoid").PlatformStand = false
		mfly1:Disconnect()
		mfly2:Disconnect()
	end)
end
local mobilefly = function(speaker, vfly)
	unmobilefly(speaker)
	FLYING = true

	local root = getRoot(speaker.Character)
	local camera = workspace.CurrentCamera
	local v3none = Vector3.new()
	local v3zero = Vector3.new(0, 0, 0)
	local v3inf = Vector3.new(9e9, 9e9, 9e9)

	local controlModule = require(speaker.PlayerScripts:WaitForChild("PlayerModule"):WaitForChild("ControlModule"))
	local bv = Instance.new("BodyVelocity")
	bv.Name = velocityHandlerName
	bv.Parent = root
	bv.MaxForce = v3zero
	bv.Velocity = v3zero

	local bg = Instance.new("BodyGyro")
	bg.Name = gyroHandlerName
	bg.Parent = root
	bg.MaxTorque = v3inf
	bg.P = 1000
	bg.D = 50

	mfly1 = speaker.CharacterAdded:Connect(function()
		local bv = Instance.new("BodyVelocity")
		bv.Name = velocityHandlerName
		bv.Parent = root
		bv.MaxForce = v3zero
		bv.Velocity = v3zero

		local bg = Instance.new("BodyGyro")
		bg.Name = gyroHandlerName
		bg.Parent = root
		bg.MaxTorque = v3inf
		bg.P = 1000
		bg.D = 50
	end)

	mfly2 = game.RunService.RenderStepped:Connect(function()
		root = getRoot(speaker.Character)
		camera = workspace.CurrentCamera
		if speaker.Character:FindFirstChildWhichIsA("Humanoid") and root and root:FindFirstChild(velocityHandlerName) and root:FindFirstChild(gyroHandlerName) then
			local humanoid = speaker.Character:FindFirstChildWhichIsA("Humanoid")
			local VelocityHandler = root:FindFirstChild(velocityHandlerName)
			local GyroHandler = root:FindFirstChild(gyroHandlerName)

			VelocityHandler.MaxForce = v3inf
			GyroHandler.MaxTorque = v3inf
			if not vfly then humanoid.PlatformStand = true end
			GyroHandler.CFrame = camera.CoordinateFrame
			VelocityHandler.Velocity = v3none

			local direction = controlModule:GetMoveVector()
			if direction.X > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.X < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity + camera.CFrame.RightVector * (direction.X * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z > 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
			if direction.Z < 0 then
				VelocityHandler.Velocity = VelocityHandler.Velocity - camera.CFrame.LookVector * (direction.Z * ((vfly and vehicleflyspeed or iyflyspeed) * 50))
			end
		end
	end)
end
function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until Mouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = Mouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = Mouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end
function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end
local lastValue = game:GetService("Players").LocalPlayer.Data.Gold.Value
local totalGained = 0
local MoneyFarm = {
	Enabled = false,
	method = 'Teleport',
  Teleport = {
    Time = 2
  },
  Tween = {
    Size = 0.3
  }
}
local WebHookSettings = {
  WebHookUrl = '',
  TimeToReport = 300,
  Items = {
    FarmingTime = '',
    ObtaindedGold = '',
    CurrentGold = ''
  }
}
local farmTime = 0
local function formatTime(seconds)
	local hrs = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = seconds % 60
	return string.format("%02d:%02d:%02d", hrs, mins, secs)
end
local blocklist = {"Character", "+", "Gold", "Chest", 'Firework'}
function GetItemsName()
	local items = {}
	for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.ShopFrame.ScrollingFrameChests:GetDescendants()) do
		if v:IsA("ImageButton") and v.Parent ~= game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.ShopFrame.ScrollingFrameChests.FrameEvent then
			local blocked = false
			for _, word in ipairs(blocklist) do
				if v.Name:lower():find(word:lower()) then
					blocked = true
					break
				end
			end
			if not blocked then
				table.insert(items, v.Name)
			end
		end
	end
	return items
end
function GetTeams()
  local teams = {}
  for _, v in pairs(game:GetService('Teams'):GetChildren()) do
    table.insert(teams, v.Name)
  end
  return teams
end
function GetPlayersName()
  local players = {}
  for _, v in pairs(game:GetService('Players'):GetPlayers()) do
    if v.Name ~= game.Players.LocalPlayer.Name then
      table.insert(players, v.Name)
    end
  end
  return players
end
function GetPlayerZone()
	local player = game.Players.LocalPlayer
	local teamName = tostring(player.Team):lower()

	for _, v in pairs(workspace:GetChildren()) do
		local TeamZone = v.Name:lower():find(teamName .. "zone")
		if TeamZone then
			return v
		end
	end

	if teamName == "yellow" then
		return workspace["New YellerZone"]
	elseif teamName == "green" then
		return workspace["CamoZone"]
	end
end
function GetPlayerBlocks()
  for _, v in pairs(workspace.Blocks:GetChildren()) do
    if v:IsA('Folder') and v.Name == game.Players.LocalPlayer.Name then
      for _, x in pairs(v:GetChildren()) do
        if x:IsA('Model') then
          return x
        end
      end
    end
  end
end
function TpFarm()
	if not MoneyFarm.Enabled then return end
	task.wait(1.4)

  local Event = GetPlayerZone().VoteLaunchRE
  Event:FireServer()

	local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local stages = {}
	for _, v in pairs(workspace.BoatStages.NormalStages:GetChildren()) do
		if v:IsA("Model") and v.Name:lower():match("cavestage%d+") then
			table.insert(stages, v)
		end
	end

	table.sort(stages, function(a, b)
		return tonumber(a.Name:match("%d+")) < tonumber(b.Name:match("%d+"))
	end)

	for i, stage in ipairs(stages) do
		local part = stage:FindFirstChild("DarknessPart", true)
		if part and part:IsA("Part") then
			local center = Instance.new("Part")
			center.Size = Vector3.new(5, 1, 5)
			center.Anchored = true
			center.CanCollide = true
			center.Transparency = 1
			center.CFrame = part.CFrame
			center.Parent = part

			hrp.CFrame = center.CFrame * CFrame.new(0, 3, 0)
      wait(MoneyFarm.Teleport.Time)
		end
	end

	task.wait(MoneyFarm.Teleport.Time)
	hrp.CFrame = CFrame.new(-51, -360, 9329)
	task.wait(MoneyFarm.Teleport.Time)
	hrp.CFrame = workspace.BoatStages.NormalStages.TheEnd.GoldenChest:FindFirstChild("Trigger").CFrame
end
function TweenFarm()
	if not MoneyFarm.Enabled then return end
	task.wait(1.4)

  local Event = GetPlayerZone().VoteLaunchRE
  Event:FireServer()

	local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
	local hrp = character:WaitForChild("HumanoidRootPart")

	local BV = Instance.new("BodyVelocity", hrp)
	BV.Velocity = Vector3.new(0, -0.1, 0)

	hrp.CFrame = CFrame.new(-135.900, 72, 623.750)
	while hrp.CFrame.Z < 8600.750 do
		for _ = 1, 50 do
			hrp.CFrame = hrp.CFrame + Vector3.new(0, 0, MoneyFarm.Tween.Size)
		end
		wait()
	end

	BV:Destroy()
	hrp.CFrame = CFrame.new(-150.900, 72, 2000.750)
	wait(0.2)
	hrp.CFrame = CFrame.new(-150.900, 72, 2500.750)
	wait(0.5)
	hrp.CFrame = CFrame.new(-55.8801956, -361.116333, 9488.1377)
	wait(0.5)
	hrp.CFrame = CFrame.new(-55.8801956, -361.116333, 9495.1377)
	wait(1)
	hrp.CFrame = CFrame.new(-205.900, 20, 1700.750)
	wait(2.3)
	hrp.CFrame = CFrame.new(-55.8801956, -361.116333, 9488.1377)
	wait(0.6)
	hrp.CFrame = CFrame.new(-55.8801956, -361.116333, 9495.1377)
	wait(1.4)
	hrp.CFrame = CFrame.new(-55.8801956, -361.116333, 9488.1377)
end
local function RestartFarm()
	if MoneyFarm.method == "Teleport" then
		TpFarm()
		game.Players.LocalPlayer.CharacterAdded:Connect(function()
			if MoneyFarm.Enabled then TpFarm() end
		end)
	elseif MoneyFarm.method == "Tween" then
		TweenFarm()
		game.Players.LocalPlayer.CharacterAdded:Connect(function()
			if MoneyFarm.Enabled then TweenFarm() end
		end)
	end
end


-- ui library
local isMobile = game.UserInputService.TouchEnabled
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Fluent/source.lua"))()

local Options = Fluent.Options

function GetSize()
  if isMobile then
    return UDim2.fromOffset(480, 300)
  else
    return UDim2.fromOffset(650, 480)
  end
end

local Window = Fluent:CreateWindow({
	Title = '<font color="rgb(175, 120, 255)" size="14"><b>InfinityX</b> <font color="rgb(180,180,180)" size="13"> - <b>v4.2a</b></font></font>',
  SubTitle = '<font color="rgb(160,160,160)" size="10"><i> -  by lmy77</i></font>',
	TabWidth = 160,
	Size = GetSize(),
	Acrylic = false,
	Theme = "InfinityX",
	MinimizeKey = Enum.KeyCode.LeftControl
})


-- tabs
local Tabs = {
  AutoFarm = Window:AddTab({ Title = "Autofarm", Icon = "refresh-cw" }),
  Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
  Quest = Window:AddTab({ Title = "Quest", Icon = "scroll" }),
  Character = Window:AddTab({ Title = "Character", Icon = "user" }),
  Teleport = Window:AddTab({ Title = "Teleport", Icon = "locate" }),
  Changelog = Window:AddTab({ Title = "Changelog", Icon = "list" }),
  Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}
Window:SelectTab(1)


-- source
Tabs.AutoFarm:AddSection("[💸] - Money Farm")
local AutoMoney = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Start",
  Description = "Active to start a auto money farm",
  Default = false,
})
AutoMoney:OnChanged(function(Value)
  MoneyFarm.Enabled = Value
  if MoneyFarm.Enabled then
  	Fluent:Notify({
  		Title = "InfinityX",
  		Content = "The script is loading the data, please wait a few seconds",
  		Duration = 5
  	})
  	RestartFarm()
  end
end)
local MethodDropdown = Tabs.AutoFarm:AddDropdown("Dropdown", {
  Title = "Select method",
  Values = {'Teleport', 'Tween'},
  Multi = false,
  Default = 'Teleport',
})
MethodDropdown:OnChanged(function(Value)
  MoneyFarm.method = Value
end)
Tabs.AutoFarm:AddSection("[⚙️] - Farm Settings")
local AntiAfk = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Anti afk",
  Description = "Active for dont have kiked at 20 minutes idled",
  Default = true,
})
AntiAfk:OnChanged(function(Value)
  afk = Value
  if afk then
    local VirtualUser = game:GetService("VirtualUser")
    game:GetService("Players").LocalPlayer.Idled:Connect(function()
      VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
      task.wait(1)
      VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
  end
end)
local DeleteMap = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Delete map",
  Description = "The function deletes all the terrain around it. This helps to increase your fps when farming",
  Default = false,
})
DeleteMap:OnChanged(function(Value)
  Del = Value
  if Del then
    local find = workspace:FindFirstChild('MainTerrain')
    if find then
      find:Destroy()
    else
      return
    end
  end
end)
local Input = Tabs.AutoFarm:AddInput("Input", {
  Title = "Teleport speed",
  Default = "",
  Placeholder = "2",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    MoneyFarm.Teleport.Time = tonumber(Value)
  end
})
local Input = Tabs.AutoFarm:AddInput("Input", {
  Title = "Tween speed",
  Default = "",
  Placeholder = "0.3",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    MoneyFarm.Tween.Size = tonumber(Value)
  end
})
Tabs.AutoFarm:AddSection("[📈] - Farm Stats")
local p1 = Tabs.AutoFarm:AddParagraph({
  Title = "Total Farming Time",
  Content = "None"
})
local p2 = Tabs.AutoFarm:AddParagraph({
  Title = "Obtainded Gold",
  Content = "None"
})
local p3 = Tabs.AutoFarm:AddParagraph({
  Title = "Current Gold",
  Content = "None"
})
task.spawn(function()
	while true do
		task.wait(1)
		if MoneyFarm.Enabled then
			farmTime += 1
			p1:SetDesc(formatTime(farmTime))
      WebHookSettings.Items.FarmingTime = formatTime(farmTime)
		end
	end
end)
task.spawn(function()
  while true do task.wait()
    local player = game:GetService("Players").LocalPlayer
    local gold = player:WaitForChild("Data"):WaitForChild("Gold")

    p3:SetDesc(gold.Value)
    WebHookSettings.Items.CurrentGold = tostring(gold.Value)

    local currentValue = tonumber(gold.Value)
    if MoneyFarm.Enabled and currentValue > lastValue then
      local diff = currentValue - lastValue
      totalGained += diff
      WebHookSettings.Items.ObtaindedGold = tostring(totalGained)
      p2:SetDesc(tostring(totalGained))
      lastValue = currentValue
    end
  end
end)
Tabs.AutoFarm:AddSection("[🤖] - Webhook")
local WebHookReport = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Enable webhook report",
  Default = false,
})
WebHookReport:OnChanged(function(Value)
  WebHook = Value
  if WebHook and WebHookSettings.WebHookUrl == '' or WebHookSettings.TimeToReport == '' then
    Fluent:Notify({
      Title = "InfinityX",
      Content = 'Please, select a webhook or time to report first',
      Duration = 5
    })
    return
  end
  while WebHook do task.wait()
    local http = request or syn.request
    local webhookUrl = WebHookSettings.WebHookUrl
    http({
      Url = webhookUrl,
      Method = "POST",
      Headers = {
          ["Content-Type"] = "application/json"
      },
      Body = game:GetService("HttpService"):JSONEncode({
          content = "||@here||",
          username = "InfinityX • Autofarm Stats",
          avatar_url = 'https://cdn.discordapp.com/attachments/1390305524234453013/1397666019941552189/latest.png?ex=68828d6a&is=68813bea&hm=0caf96fd589c3c820a4fe08822048cd3be081db2d9c079bef31605b0ee31c0d5&',
          embeds = {{
            title = "📢 Autofarm statistics update!",
            description = "",
            color = 0x5865F2,
            thumbnail = {
              url = 'https://img.icons8.com/?size=100&id=6oFZ7BIVGUGH&format=png&color=000000'
          },
          fields = {
            {
              name = "[⏳] - Farming time",
              value = WebHookSettings.Items.FarmingTime
            },
            {
              name = "[🏦] - Obtainded gold",
              value = WebHookSettings.Items.ObtaindedGold
            },
            {
              name = "[🪙] - Current gold",
              value = WebHookSettings.Items.CurrentGold
            },
            },
              footer = {
              text = "🚀  •  INFX Team  •  Deployment Active",
            },
          }}
      })
    })
    wait(WebHookSettings.TimeToReport)
  end
end)
local Input = Tabs.AutoFarm:AddInput("Input", {
  Title = "Webhook URL",
  Default = "",
  Placeholder = "Enter discord webhook",
  Numeric = false,
  Finished = false,
  Callback = function(Value)
    WebHookSettings.WebHookUrl = Value
  end
})
local Input = Tabs.AutoFarm:AddInput("Input", {
  Title = "Report interval",
  Default = "",
  Placeholder = "300",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    WebHookSettings.TimeToReport = tonumber(Value)
  end
})


Tabs.Shop:AddSection("[📦] - Buy Chest")
local ChestDropdown = Tabs.Shop:AddDropdown("Dropdown", {
  Title = "Select chest",
  Values = {'Common Chest', 'Uncommon Chest', 'Rare Chest', 'Epic Chest', 'Legendary Chest'},
  Multi = false,
  Default = 'Common Chest',
})
ChestDropdown:OnChanged(function(Value)
  SelectedChest = Value
end)
local Input = Tabs.Shop:AddInput("Input", {
  Title = "Select amount",
  Default = "",
  Placeholder = "1",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    SelectedAmount = tonumber(Value)
  end
})
Tabs.Shop:AddButton({
  Title = "Open selected chest",
  Callback = function()
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      SelectedChest,
      SelectedAmount
    )
  end
})
local AutoChest = Tabs.Shop:AddToggle("AutoMoneyToggle", {
  Title = "Auto open selected chest",
  Default = false,
})
AutoChest:OnChanged(function(Value)
  Chest = Value
  while Chest do task.wait(.25)
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      SelectedChest,
      SelectedAmount
    )
  end
end)
Tabs.Shop:AddSection("[🧱] - Buy Blocks")
local selectedItem = nil
local items = GetItemsName()
if #items > 0 then
	selectedItem = items[math.random(1, #items)]
end
local BlocksDropdown = Tabs.Shop:AddDropdown("Dropdown", {
  Title = "Select block",
  Values = GetItemsName(),
  Multi = false,
  Default = selectedItem,
})
BlocksDropdown:OnChanged(function(Value)
  SelectedBlock = Value
end)
local Input = Tabs.Shop:AddInput("Input", {
  Title = "Select amount",
  Default = "",
  Placeholder = "1",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    SelectedAmountBlock = tonumber(Value)
  end
})
Tabs.Shop:AddButton({
  Title = "Buy selected block",
  Callback = function()
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      SelectedBlock,
      SelectedAmountBlock
    )
  end
})
local AutoChest = Tabs.Shop:AddToggle("AutoMoneyToggle", {
  Title = "Auto buy selected block",
  Default = false,
})
AutoChest:OnChanged(function(Value)
  Block = Value
  while Block do task.wait(.5)
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      SelectedBlock,
      SelectedAmountBlock
    )
  end
end)
Tabs.Shop:AddSection("[🔨] - Buy Tool")
local ToolDropdown = Tabs.Shop:AddDropdown("Dropdown", {
  Title = "Select tool",
  Values = {'Painting Tool', 'Binding Tool', 'Property Tool', 'Scaling Tool', 'Trowel Tool'},
  Multi = false,
  Default = 'Painting Tool',
})
ToolDropdown:OnChanged(function(Value)
  SelectedTool = Value
end)
Tabs.Shop:AddButton({
  Title = "Buy selected tool",
  Callback = function()
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      SelectedTool,
      1
    )
  end
})
Tabs.Shop:AddButton({
  Title = "Buy all tools",
  Callback = function()
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      "Painting Tool",
      1
    )
    wait(.25)
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      "Binding Tool",
      1
    )
    wait(.25)
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      "Property Tool",
      1
    )
    wait(.25)
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      "Scaling Tool",
      1
    )
    wait(.25)
    local Event = workspace.ItemBoughtFromShop
    Event:InvokeServer(
      "Trowel Tool",
      1
    )
    wait(.25)
  end
})
Tabs.Shop:AddSection("[⚙️] - Settings")
local IsolationMode = Tabs.Shop:AddToggle("AutoMoneyToggle", {
  Title = "Isolation mode",
  Description = 'Turning this setting on will prevent players on different teams from coming onto your building area. Only the team leader may turn this setting on or off',
  Default = false,
})
IsolationMode:OnChanged(function(Value)
  Isolation = Value
  local Event = workspace.RefreshLocks
  Event:FireServer(
    Isolation
  )
end)
local JoinRequest = Tabs.Shop:AddToggle("AutoMoneyToggle", {
  Title = "Block join request",
  Description = 'Turning this setting on will prevent players from sending requests to join your team. This will not prevent requests sent from teammates to share your blocks',
  Default = false,
})
JoinRequest:OnChanged(function(Value)
  Request = Value
  local Event = workspace.SettingFunction
  Event:InvokeServer(
    "BlockRequests",
    Request
  )
end)
local PvpMode = Tabs.Shop:AddToggle("AutoMoneyToggle", {
  Title = "Pvp mode",
  Description = 'Turning this setting on will allow other players using pvp mode to damage you and your blocks using weapons. This includes blocks that are in your building area',
  Default = false,
})
PvpMode:OnChanged(function(Value)
  Pvp = Value
  local Event = workspace.PVPRemote
  Event:FireServer(
    Pvp
  )
end)
Tabs.Shop:AddButton({
  Title = "Reedem all codes",
  Callback = function()
    local codes = {'hi', 'Squid Army', '=D', '=P'}
    for _, v in pairs(codes) do
      local Event = workspace.CheckCodeFunction
      Event:InvokeServer(
        v
      )
    end
  end
})



Tabs.Quest:AddSection("[📜] - Quest Options")
local CloudQuest = Tabs.Quest:AddToggle("AutoMoneyToggle", {
  Title = "Auto complete cloud quest",
  Default = false,
})
CloudQuest:OnChanged(function(Value)
  Cloud = Value
  if Cloud then
    if game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.QuestFrame.ScrollingFrame.Quest1.Checkmark.Visible == true then
      Fluent:Notify({
        Title = "InfinityX",
        Content = 'Your already completed this quest',
        Duration = 5
      })
      return
    end
    local Event = workspace.QuestMakerEvent
    Event:FireServer(
      1
    )
    wait(.2)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetPlayerZone().Quest.Cloud.PrimaryPart.CFrame
  end
end)
local TargetQuest = Tabs.Quest:AddToggle("AutoMoneyToggle", {
  Title = "Auto complete target quest",
  Default = false,
})
TargetQuest:OnChanged(function(Value)
  Target = Value
  if Target then
    if game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.QuestFrame.ScrollingFrame.Quest2.Checkmark.Visible == true then
      Fluent:Notify({
        Title = "InfinityX",
        Content = 'Your already completed this quest',
        Duration = 5
      })
      return
    end
    local Event = workspace.QuestMakerEvent
    Event:FireServer(
      2
    )
    wait(.5)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = GetPlayerZone().Quest.Target:GetChildren()[5].CFrame
  end
end)
local SoccerToggle = Tabs.Quest:AddToggle("AutoMoneyToggle", {
  Title = "Help complete soccer quest",
  Default = false,
})
SoccerToggle:OnChanged(function(Value)
  Soccer = Value
  if Soccer then
    if game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.QuestFrame.ScrollingFrame.Quest8.Checkmark.Visible == true then
      Fluent:Notify({
        Title = "InfinityX",
        Content = 'Your already completed this quest',
        Duration = 5
      })
      return
    end
    local Event = workspace.QuestMakerEvent
    Event:FireServer(
      8
    )
    wait(.5)
    GetPlayerZone().Quest.Soccer1.SoccerBall.Transparency = 0.5
    GetPlayerZone().Quest.Soccer1.SoccerBall.CanCollide = false
  end
end)
local RampToggle = Tabs.Quest:AddToggle("AutoMoneyToggle", {
  Title = "Auto complete ramp quest",
  Default = false,
})
RampToggle:OnChanged(function(Value)
  Ramp = Value
  if Ramp then
    if game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.QuestFrame.ScrollingFrame.Quest3.Checkmark.Visible == true then
      Fluent:Notify({
        Title = "InfinityX",
        Content = 'Your already completed this quest',
        Duration = 5
      })
      return
    end
    local Event = workspace.QuestMakerEvent
    Event:FireServer(
      3
    )
    wait(.5)
    for _, v in pairs(GetPlayerZone().Quest.Ramp:GetDescendants()) do
      if v:IsA('TouchTransmitter') then
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
        firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
      end
    end
    wait(.5)
    game.Players.LocalPlayer.Character:BreakJoints()
  end
end)
local FindToggle = Tabs.Quest:AddToggle("AutoMoneyToggle", {
  Title = "Auto complete find me quest",
  Default = false,
})
FindToggle:OnChanged(function(Value)
  Find = Value
  if Find then
    if game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.QuestFrame.ScrollingFrame.Quest4.Checkmark.Visible == true then
      Fluent:Notify({
        Title = "InfinityX",
        Content = 'Your already completed this quest',
        Duration = 5
      })
      return
    end
    local Event = workspace.QuestMakerEvent
    Event:FireServer(
      4
    )
    wait(.5)
    while Find do task.wait()
      for _, v in pairs(GetPlayerZone():WaitForChild('Quest'):waitForChild('Butter'):GetDescendants()) do
        if v:IsA('ClickDetector') then
          fireclickdetector(v)
        end
      end
    end
  end
end)
local ThinToggle = Tabs.Quest:AddToggle("AutoMoneyToggle", {
  Title = "Auto complete thin ice quest",
  Default = false,
})
ThinToggle:OnChanged(function(Value)
  Thin = Value
  if Thin then
    if game:GetService("Players").LocalPlayer.PlayerGui.ShopGui.MainFrame.TabFrame.QuestFrame.ScrollingFrame.Quest9.Checkmark.Visible == true then
      Fluent:Notify({
        Title = "InfinityX",
        Content = 'Your already completed this quest',
        Duration = 5
      })
      return
    end
    local Event = workspace.QuestMakerEvent
    Event:FireServer(
      9
    )
    wait(.5)
    local Event = GetPlayerZone().VoteLaunchRE
    Event:FireServer()
    wait(.2)
    local oldPos = ''
    oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
    local character = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
    local hrp = character:WaitForChild("HumanoidRootPart")

    local BV = Instance.new("BodyVelocity", hrp)
    BV.Velocity = Vector3.new(0, -0.1, 0)

    hrp.CFrame = CFrame.new(-135.900, 72, 623.750)
    while hrp.CFrame.Z < 8600.750 do
      for _ = 1, 50 do
        hrp.CFrame = hrp.CFrame + Vector3.new(0, 0, 1)
      end
      wait()
    end

    BV:Destroy()
    hrp.CFrame = CFrame.new(-51, -360, 9329)
    wait(2)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(oldPos)
  end
end)


Tabs.Character:AddSection("[🙍] - Character Options")
Tabs.Character:AddInput("Input", {
  Title = "WalkSpeed",
  Default = "",
  Placeholder = "16",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
  end
})
Tabs.Character:AddInput("Input", {
  Title = "JumpPower",
  Default = "",
  Placeholder = "50",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    if Value == nil or Value == '' then return end
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
  end
})
Tabs.Character:AddButton({
  Title = "Reset values",
  Callback = function()
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
  end
})
local WalkOnWater = Tabs.Character:AddToggle("AutoMoneyToggle", {
  Title = "Walk on water",
  Default = false,
})
WalkOnWater:OnChanged(function(Value)
  water = Value
  if water then
    local waterPart = workspace:FindFirstChild("Water")
    for i = 0, 7 do
      local walkPart = Instance.new("Part", waterPart)
      walkPart.Name = "Walk Part " .. i
      walkPart.Anchored = true
      walkPart.Transparency = 1
      walkPart.Size = Vector3.new(2048, 1, 9e9)
      walkPart.CFrame = waterPart.CFrame * CFrame.new(0, 16, i * waterPart.Size.Z)
    end
  else
    for _, v in pairs(workspace:FindFirstChild("Water"):GetChildren()) do
      if v:IsA('Part') and v.Name:lower():find('walk') then
        v:Destroy()
      end
    end
  end
end)
local NoclipToggle = Tabs.Character:AddToggle("AutoMoneyToggle", {
  Title = "Noclip",
  Default = false,
})
NoclipToggle:OnChanged(function(Value)
  Noclip = Value
  if Noclip then
		for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == true then
				v.CanCollide = false
			end
		end
  else
		for _, v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
			if v:IsA("BasePart") and v.CanCollide == false then
				v.CanCollide = true
			end
		end
  end
end)
local FlyToggle = Tabs.Character:AddToggle("AutoMoneyToggle", {
  Title = "Fly",
  Default = false,
})
FlyToggle:OnChanged(function(Value)
  Fly = Value
  if Fly then
    if not IsOnMobile then
      NOFLY()
      wait()
      sFLY()
    else
      mobilefly(game.Players.LocalPlayer)
    end
  else
    if not IsOnMobile then NOFLY() else unmobilefly(game.Players.LocalPlayer) end
  end
end)
Tabs.Character:AddSection("[🚩] - Team Options")
local teams = GetTeams()
if #teams > 0 then
	selectedTeamRandom = teams[math.random(1, #teams)]
end
local TeamsDropdown = Tabs.Character:AddDropdown("Dropdown", {
  Title = "Select team",
  Values = GetTeams(),
  Multi = false,
  Default = selectedTeamRandom,
})
TeamsDropdown:OnChanged(function(Value)
  SelectedTeam = Value
end)
Tabs.Character:AddButton({
  Title = "Change selected team",
  Callback = function()
    local Event = workspace.ChangeTeam
    Event:FireServer(
      game:GetService("Teams")[SelectedTeam]
    )
  end
})
Tabs.Character:AddButton({
  Title = "Teleport to team",
  Callback = function()
    if SelectedTeam == 'black' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-589, -11, -70)
    elseif SelectedTeam == 'blue' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(482, -10, 300)
    elseif SelectedTeam == 'green' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-587, -10, 293)
    elseif SelectedTeam == 'magenta' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(482, -10, 647)
    elseif SelectedTeam == 'red' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(482, -10, -65)
    elseif SelectedTeam == 'white' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-50, -10, -606)
    elseif SelectedTeam == 'yellow' then
      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-589, -10, 640)
    end
  end
})
Tabs.Character:AddButton({
  Title = "View the free teams",
  Callback = function()
    local FreeTeams = {}
    for _, v in pairs(game:GetService("Teams"):GetDescendants()) do
      if v:IsA("StringValue") and v.Value == "" then
        table.insert(FreeTeams, v.Parent.Name)
      end
    end
    wait(0.1)
    Fluent:Notify({
      Title = "InfinityX",
      Content = 'All free teams is: ' .. table.concat(FreeTeams, ", "),
      Duration = 5
    })
  end
})
local AutoTeam = Tabs.Character:AddToggle("AutoMoneyToggle", {
  Title = "Auto selected team",
  Default = false,
})
AutoTeam:OnChanged(function(Value)
  Team = Value
  while Team do task.wait()
    local Event = workspace.ChangeTeam
    Event:FireServer(
      game:GetService("Teams")[SelectedTeam]
    )
  end
end)
Tabs.Character:AddSection("[🙅] - Players Options")
local players = GetPlayersName()
if #players > 0 then
	SelectedPlayerRandom = players[math.random(1, #players)]
end
local PlayersDropdown = Tabs.Character:AddDropdown("Dropdown", {
  Title = "Select player",
  Values = GetPlayersName(),
  Multi = false,
  Default = SelectedPlayerRandom,
})
PlayersDropdown:OnChanged(function(Value)
  SelectedPlayer = Value
end)
Tabs.Character:AddButton({
  Title = "Teleport to player",
  Callback = function()
    if SelectedPlayer == 'None' then
      Fluent:Notify({
        Title = "InfinityX",
        Content = "Select a player first to use this function",
        Duration = 5
      })
      return
    end
    game.Players.LocalPlayer.Character:PivotTo(game.Players[SelectedPlayer].Character:GetPivot())
  end
})
local SpectatePlayer = Tabs.Character:AddToggle("AutoMoneyToggle", {
  Title = "Spactate selected player",
  Default = false,
})
SpectatePlayer:OnChanged(function(Value)
  Spactate = Value
  if SelectedPlayer == 'None' and Spactate then
  	Fluent:Notify({
  		Title = "InfinityX",
  		Content = "Select a player first to use this function",
  		Duration = 5
  	})
    return
  end
  if Spactate then
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera

    local playerToSpec = SelectedPlayer
    local target = Players:FindFirstChild(playerToSpec)

    if target and target.Character and target.Character:FindFirstChild("Humanoid") then
      Camera.CameraSubject = target.Character:FindFirstChild("Humanoid")
    end
  else
    local Players = game:GetService("Players")
    local Camera = workspace.CurrentCamera

    local localPlayer = Players.LocalPlayer

    if localPlayer.Character and localPlayer.Character:FindFirstChild("Humanoid") then
      Camera.CameraSubject = localPlayer.Character:FindFirstChild("Humanoid")
    end
  end
end)
local DeleteIsolation = Tabs.Character:AddToggle("", {
  Title = "Delete isolation mode",
  Description = "Automatically identifies and removes all invisible or non-collidable barriers present within any base that has Isolation Mode currently enabled, ensuring unrestricted access or visibility as required.",
  Default = false,
})
DeleteIsolation:OnChanged(function(Value)
  delete = Value
  local deletelist = {'IsolationBeams', 'Lock'}
  while delete do task.wait()
    for _, v in pairs(workspace:GetChildren()) do
      if v:IsA('Part') and v.Name:lower():find('zone') then
        for _, x in pairs(v:GetDescendants()) do
          if table.find(deletelist, x.Name) then
            x:Destroy()
          end
        end
      end
    end
  end
end)
Tabs.Character:AddButton({
  Title = "Rejoin smallest server",
  Callback = function()
    local HttpService = game:GetService("HttpService")
    local TeleportService = game:GetService("TeleportService")
    local Players = game:GetService("Players")

    local PlaceId = game.PlaceId
    local JobId = game.JobId

    local function GetServer()
      local servers = {}
      local req = request({
        Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100", PlaceId)
      })
      local data = HttpService:JSONDecode(req.Body)

      for _, v in pairs(data.data) do
        if v.playing < v.maxPlayers and v.id ~= JobId then
          table.insert(servers, v.id)
        end
      end

      if #servers > 0 then
        return servers[math.random(1, #servers)]
      end
    end

    local serverId = GetServer()
    if serverId then
      TeleportService:TeleportToPlaceInstance(PlaceId, serverId, Players.LocalPlayer)
    end
  end
})


Tabs.Teleport:AddSection("[🌍] - Places Teleport")
Tabs.Teleport:AddButton({
  Title = "Teleport to Inner Cloud",
  Callback = function()
    game:GetService("TeleportService"):Teleport(1930863474, game:GetService("Players").LocalPlayer)
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to Winter Place",
  Callback = function()
    game:GetService("TeleportService"):Teleport(1930866268, game:GetService("Players").LocalPlayer)
  end
})
Tabs.Teleport:AddButton({
  Title = "Teleport to The Secret Place",
  Callback = function()
    game:GetService("TeleportService"):Teleport(1930665568, game:GetService("Players").LocalPlayer)
  end
})


Tabs.Changelog:AddSection("[🥳] - Changelog List")
Tabs.Changelog:AddParagraph({
  Title = "InfinityX Update - Changelog [v4.2a] - New",
  Content = '\n' .. [[
> Added
  • New UI design for the script hub
  • New mobile button
  • Force delete all isolation mode
  • Rejoin smallest servers
  • New method to auto thin ice quest
  • New tab changelog

> Fixed
  • Auto thin ice quest
  • Auto tween speed
  • Auto teleport part
  ]]
})
Tabs.Changelog:AddParagraph({
  Title = "InfinityX Update - Changelog [v4.2a] - Old",
  Content = '\n' .. [[
> Fixed
  • Improved auto quest
  • Improved thin ice quest
  ]]
})
Tabs.Changelog:AddParagraph({
  Title = "InfinityX Update - Changelog [v4.2a] - Old",
  Content = '\n' .. [[
> Fixed
  • Obtained gold
  • Obtained gold webhook
  • Improved auto farm
  ]]
})
Tabs.Changelog:AddParagraph({
  Title = "InfinityX Update - Changelog [v4.2a] - Old",
  Content = '\n' .. [[
> Fixed
  • Auto farm in yellow or green zone
  • Get players zone
  ]]
})


Tabs.Settings:AddSection("[⚙️] - Ui Settings")
local InterfaceTheme = Tabs.Settings:AddDropdown("InterfaceTheme", {
  Title = "Theme",
  Description = "Changes the interface theme.",
  Values = Fluent.Themes,
  Default = "InfinityX",
  Callback = function(Value)
    Fluent:SetTheme(Value)
  end
})
Tabs.Settings:AddToggle("AcrylicToggle", {
  Title = "Acrylic",
  Description = "The blurred background requires graphic quality 8+",
  Default = false,
  Callback = function(Value)
    Fluent:ToggleAcrylic(Value)
  end
})
Tabs.Settings:AddToggle("TransparentToggle", {
  Title = "Transparency",
  Description = "Makes the interface transparent.",
  Default = true,
  Callback = function(Value)
    Fluent:ToggleTransparency(Value)
  end
})
local MenuKeybind = Tabs.Settings:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = "LeftControl" })
Fluent.MinimizeKeybind = MenuKeybind
Tabs.Settings:AddSection("[🎉] - Credits")
local p1 = Tabs.Settings:AddParagraph({
  Title = "Script Credits",
  Content = "Made by: Lmy77"
})
Tabs.Settings:AddButton({
  Title = "Join discord server",
  Callback = function()
    setclipboard("https://discord.gg/emKJgWMHAr")
  	Fluent:Notify({
  		Title = "InfinityX",
  		Content = "Link copied to your clipboard",
  		Duration = 5
  	})
  end
})


-- extra functions
game.Players.PlayerAdded:Connect(function()
  PlayersDropdown:SetValues(GetPlayersName())
end)
game.Players.PlayerRemoving:Connect(function()
  PlayersDropdown:SetValues(GetPlayersName())
end)
