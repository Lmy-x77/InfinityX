-- notification
local args = {
    "Welcome to InfinityX!",
    Color3.fromRGB(127, 42, 212)
}
firesignal(game:GetService("ReplicatedStorage").AnnouncementEvent.OnClientEvent, unpack(args))
wait(2.5)



-- detect service
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	print("Mobile device")
elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
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



-- load preference
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/main/Software/button.lua"))()
end



-- variables
local afkFarmSettings = {
    Distance = 30,
    DistanceToBeast = 30,
}
function GetSizeOfObject(Obj)
    if Obj:IsA("BasePart") then
        return Obj.Size
    elseif Obj:IsA("Model") then
        return Obj:GetExtentsSize()
    end
end
if hookmetamethod then
    local OldNameCall = nil
    OldNameCall = hookmetamethod(game, "__namecall", function(...)
        local Args = {...}
        local Self = Args[1]
        if getnamecallmethod() == "FireServer" and tostring(Self) == "RemoteEvent" and Args[1] == "ReportPhysicsFPS" then
            return wait(math.huge)
        end
        return OldNameCall(...)
    end)
else
    local Info = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/library/Info/source.lua", true))()
    Info:Notify('Waring', 'your exploit does not support hookmetamethod. Please use a better exploit', 5)
    return
end
local function WalkSpeedBypass()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldIndex = gmt.__Index
    gmt.__Index = newcclosure(function(self, b)
        if b == 'WalkSpeed' then
            return 16
        end
        return oldIndex(self, b)
    end)
end
local function JumpPowerBypass()
    local gmt = getrawmetatable(game)
    setreadonly(gmt, false)
    local oldIndex = gmt.__Index
    gmt.__Index = newcclosure(function(self, b)
        if b == 'JumpPower' then
            return 50
        end
        return oldIndex(self, b)
    end)
end
getgenv().EspSettings = {
    Enabled = true,
    Name = true,
    Tracers = true,
    Studs = true,
    Box3D = true,
    BeastColor = Color3.fromRGB(255, 0, 0),
    InnocentColor = Color3.fromRGB(70, 243, 84)
}
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local Drawings = {}
local function createESP(player)
    local drawings = {}

    drawings.name = Drawing.new("Text")
    drawings.name.Size = 13
    drawings.name.Center = true
    drawings.name.Outline = true

    drawings.distance = Drawing.new("Text")
    drawings.distance.Size = 13
    drawings.distance.Center = true
    drawings.distance.Outline = true

    drawings.tracer = Drawing.new("Line")
    drawings.tracer.Thickness = 1
    drawings.tracer.Transparency = 1

    if getgenv().EspSettings.Box3D then
        local box = Instance.new("BoxHandleAdornment")
        box.Name = "ESP3DBox"
        box.Size = Vector3.new(4, 6, 2)
        box.Transparency = 0.5
        box.ZIndex = 5
        box.AlwaysOnTop = true
        box.Adornee = nil
        box.Parent = game.CoreGui
        drawings.box = box
    else
        drawings.box = Drawing.new("Square")
        drawings.box.Thickness = 2
        drawings.box.Transparency = 1
        drawings.box.Filled = false
    end

    Drawings[player] = drawings

    local function update()
        if not getgenv().EspSettings.Enabled then
            for _, d in pairs(drawings) do
                if typeof(d) == "Instance" then
                    d.Adornee = nil
                else
                    d.Visible = false
                end
            end
            return
        end

        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChild("Humanoid")
        if not hrp or not humanoid or humanoid.Health <= 0 then
            for _, d in pairs(drawings) do
                if typeof(d) ~= "Instance" then d.Visible = false end
            end
            return
        end

        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen then
            for _, d in pairs(drawings) do
                if typeof(d) ~= "Instance" then d.Visible = false end
            end
            return
        end

        local color = char:FindFirstChild("BeastPowers") and getgenv().EspSettings.BeastColor or getgenv().EspSettings.InnocentColor

        if getgenv().EspSettings.Box3D then
            drawings.box.Adornee = char
            drawings.box.Color3 = color
        else
            local size = Vector3.new(2, 3, 1.5)
            local topLeft = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(-size.X, size.Y, 0))
            local bottomRight = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(size.X, -size.Y, 0))
            drawings.box.Size = Vector2.new(math.abs(topLeft.X - bottomRight.X), math.abs(topLeft.Y - bottomRight.Y))
            drawings.box.Position = Vector2.new(math.min(topLeft.X, bottomRight.X), math.min(topLeft.Y, bottomRight.Y))
            drawings.box.Color = color
            drawings.box.Visible = true
        end

        if getgenv().EspSettings.Name then
            drawings.name.Position = Vector2.new(pos.X, pos.Y - 20)
            drawings.name.Text = player.Name
            drawings.name.Color = color
            drawings.name.Visible = true
        else
            drawings.name.Visible = false
        end

        if getgenv().EspSettings.Studs then
            local dist = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                and math.floor((hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude) or 0
            drawings.distance.Position = Vector2.new(pos.X, pos.Y + 20)
            drawings.distance.Text = tostring(dist) .. "m"
            drawings.distance.Color = color
            drawings.distance.Visible = true
        else
            drawings.distance.Visible = false
        end

        if getgenv().EspSettings.Tracers then
            drawings.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.tracer.To = Vector2.new(pos.X, pos.Y)
            drawings.tracer.Color = color
            drawings.tracer.Visible = true
        else
            drawings.tracer.Visible = false
        end
    end

    local conn = RunService.RenderStepped:Connect(update)

    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            for _, d in pairs(drawings) do
                if typeof(d) == "Instance" then
                    d:Destroy()
                else
                    d:Remove()
                end
            end
            conn:Disconnect()
            Drawings[player] = nil
        end
    end)
end
local function deleteESP()
    for _, drawings in pairs(Drawings) do
        for _, d in pairs(drawings) do
            if typeof(d) == "Instance" then
                d:Destroy()
            else
                d:Remove()
            end
        end
    end
    Drawings = {}
end
local function updateComputerESP()
    local map = workspace:FindFirstChild(tostring(game.ReplicatedStorage.CurrentMap.Value))
    if map then
        local computerTables = map:GetChildren()
        for _, table in pairs(computerTables) do
            if table:IsA("Model") and table.Name == "ComputerTable" then
                for _, screen in pairs(table:GetDescendants()) do
                    if (screen:IsA("Part") or screen:IsA("UnionOperation")) and screen.Name == "Screen" then
                        local billboardGui = screen:FindFirstChild("BillboardGui")
                        if billboardGui then
                            local imageLabel = billboardGui:FindFirstChild("ImageLabel")
                            if imageLabel then
                                billboardGui.Enabled = ESPComputer
                                if ESPComputer then
                                    imageLabel.ImageColor3 = screen.Color
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
local KeyPress = function(v)
    return game:GetService("VirtualInputManager"):SendKeyEvent(true, v, false, game)
end
function getAction()
    if game:GetService("Players").LocalPlayer.TempPlayerStatsModule.ActionProgress.Value == 0 then
        return 'Nothing or walking'
    else
        return 'Hacking a computer or opening a door'
    end
end
function getBeast()
    for _, v in pairs(game:GetService('Players'):GetChildren()) do
        if v.Name ~= game:GetService('Players').LocalPlayer.Name then
            if v.Character:findFirstChild('BeastPowers') then
                return v.Name
            end
        end
    end
end
local function inSpawn()
	local char = game.Players.LocalPlayer.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	local pad = workspace:FindFirstChild("LobbySpawnPad")

	return hrp and pad and (pad.Position - hrp.Position).Magnitude < (pad.Size.X / 2)
end
function GetSize()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
        return UDim2.fromOffset(600, 350)
    else
        return UDim2.fromOffset(830, 525)
    end
end
scriptVersion = '3.2a'



-- ui library
local MacLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/library/Maclib/src.lua"))()
local Window = MacLib:Window({
	Title = "InfinityX "..scriptVersion,
	Subtitle = "By lmy77 | "..game:GetService('MarketplaceService'):GetProductInfo(game.PlaceId).Name,
	Size = GetSize(),
	DragStyle = 2,
	DisabledWindowControls = {},
	ShowUserInfo = true,
	Keybind = Enum.KeyCode.K,
	AcrylicBlur = true,
})
local globalSettings = {
	FPSToggle = Window:GlobalSetting({
		Name = "Unlock FPS",
		Default = false,
		Callback = function(bool)
            local fps = bool
            local function UnlockFPS()
                local RefreshRate = 60
                if game:GetService("UserInputService").TouchEnabled then
                    RefreshRate = 120
                elseif game:GetService("UserInputService").KeyboardEnabled then
                    RefreshRate = 240
                end
                setfpscap(RefreshRate * 2)
            end
            while fps do task.wait(.2)
                UnlockFPS()
            end
        end,
	}),
    ViewGame = Window:GlobalSetting({
		Name = "Auto Update",
		Default = false,
		Callback = function(bool)
			if bool then
                warn('Auto update actived!')
			end
		end,
	}),
}



-- tabs
local tabGroups = {
	TabGroup1 = Window:TabGroup()
}
local tabs = {
	Game = tabGroups.TabGroup1:Tab({ Name = "| Game", Image = "rbxassetid://10723424505" }),
    LPayer = tabGroups.TabGroup1:Tab({ Name = "| Local Player", Image = "rbxassetid://10747373176" }),
    Esp = tabGroups.TabGroup1:Tab({ Name = "| Esp", Image = "rbxassetid://10747375132" }),
    EspSettings = tabGroups.TabGroup1:Tab({ Name = "| Esp Settings", Image = "rbxassetid://10734950309" }),
}
local sections = {
	GameSection1 = tabs.Game:Section({ Side = "Left" }),
    GameSection2 = tabs.Game:Section({ Side = "Right" }),
    GameSection3 = tabs.Game:Section({ Side = "Left" }),
    GameSection4 = tabs.Game:Section({ Side = "Right" }),
    GameSection5 = tabs.Game:Section({ Side = "Right" }),
    LPlayerSection1 = tabs.LPayer:Section({ Side = "Left" }),
    LPlayerSection2 = tabs.LPayer:Section({ Side = "Right" }),
    LPlayerSection3 = tabs.LPayer:Section({ Side = "Left" }),
    LPlayerSection4 = tabs.LPayer:Section({ Side = "Right" }),
    EspSection1 = tabs.Esp:Section({ Side = "Left" }),
    EspSection2 = tabs.Esp:Section({ Side = "Right" }),
    EspSeettingsSection1 = tabs.EspSettings:Section({ Side = "Left" }),
}
tabs.Game:Select()



-- source
sections.GameSection1:Header({
	Name = "[🌐] Game Cheats"
})
sections.GameSection2:Header({
	Name = "[📋] Stats"
})
sections.GameSection3:Header({
	Name = "[🎮] Game Stats"
})
sections.GameSection4:Header({
	Name = "[🌍] Places Teleport"
})
sections.GameSection5:Header({
	Name = "[📶] Misc"
})
sections.GameSection1:Toggle({
	Name = "Auto hack",
	Default = false,
	Callback = function(bool)
        autoHack = bool
        if autoHack then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Auto hack actived!"
            })
        end
        while autoHack do task.wait()
            game:GetService("ReplicatedStorage").RemoteEvent:FireServer("SetPlayerMinigameResult",true)
            for _, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui:GetChildren()) do
                if v:IsA('ScreenGui') and v.Name == 'ScreenGui' then
                    if v.TimingCircle.Visible == true then
                        wait(.2)
                        KeyPress('E')
                    end
                end
            end
        end
	end,
}, "Toggle")
sections.GameSection1:Button({
	Name = "Teleport to exit door",
	Callback = function()
        for _, v in pairs(workspace:GetDescendants()) do
            if (v:IsA('Model') and v.Name == 'ExitDoor') then
                for _, x in pairs(v:GetChildren()) do
                    if (x:IsA('Part') and x.Name == 'ExitDoorTrigger') then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.CFrame
                        wait(.2)
                        KeyPress('E')
                        return
                    end
                end
            end
        end
	end,
})
sections.GameSection1:Button({
	Name = "Teleport to computer",
	Callback = function()
        if cooldown then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Cooldown, wait"
            })
            return
        end
        local progress = game:GetService("Players").LocalPlayer.TempPlayerStatsModule.ActionProgress.Value
        if progress ~= 0 then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Finish computer first"
            })
            return
        end
        local map = workspace:FindFirstChild(tostring(game.ReplicatedStorage.CurrentMap.Value))
        if map then
            for _, v in pairs(map:GetChildren()) do
                if v:IsA("Model") and v.Name == "ComputerTable" then
                    for _, x in pairs(v:GetChildren()) do
                        if x:IsA("Part") and x.Name:lower():find("computertrigger") then
                            if x.ActionSign.Value == 20 and v.Screen.Color ~= Color3.fromRGB(40, 127, 71) then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = x.CFrame
                                wait(.5)
                                game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game) wait(.1) game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
                                wait(.5)
                                task.spawn(function()
                                    wait(1)
                                    repeat task.wait() until game:GetService("Players").LocalPlayer.TempPlayerStatsModule.ActionProgress.Value == 0
                                    cooldown = true
                                    task.wait(20)
                                    cooldown = false
                                end)
                                return
                            end
                        end
                    end
                end
            end
        end
	end,
})
sections.GameSection1:Button({
	Name = "Save captured players",
	Callback = function()
        local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local TeleportOldPos = '';
        TeleportOldPos = oldPos
        for _, v in pairs(game:GetService('Players'):GetChildren()) do
            if (v.Name ~= game.Players.LocalPlayer.Name) then
                if (v.TempPlayerStatsModule.Captured.Value == true) then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-2.35)
                    wait(.2)
                    KeyPress('E')
                    wait(.25)
                end
            end
        end
        wait(.2)
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportOldPos)
	end,
})
sections.GameSection1:Button({
	Name = "Check beast",
	Callback = function()
        for _, v in pairs(game:GetService('Players'):GetChildren()) do
            if v.Name ~= game:GetService('Players').LocalPlayer.Name then
                if v.Character:findFirstChild('BeastPowers') then
                    Window:Notify({
                        Title = 'InfinityX',
                        Description = "Beast is "..v.Name
                    })
                end
            end
        end
	end,
})
local stats = sections.GameSection2:Paragraph({
    Header = 'Your stats',
    Body = 'nil'
})
task.spawn(function()
    while true do task.wait()
        stats:UpdateBody(
            'Money: '..game:GetService("Players").LocalPlayer.SavedPlayerStatsModule.Credits.Value.. "\nBeast Chance: "..game:GetService("Players").LocalPlayer.PlayerGui.MenusScreenGui.MainMenuWindow.Body.BeastChanceFrame.PercentageLabel.Text.."\nLevel: "..game:GetService("Players").LocalPlayer.SavedPlayerStatsModule.Level.Value.."\nXp: "..game:GetService("Players").LocalPlayer.SavedPlayerStatsModule.Xp.Value.."\nAction: "..getAction()
        )
    end
end)
sections.GameSection2:Divider()
sections.GameSection2:Button({
	Name = "Open menu",
	Callback = function()
        if game:GetService("Players").LocalPlayer.PlayerGui.MenusScreenGui.MainMenuWindow.Visible == false then
            game:GetService("Players").LocalPlayer.PlayerGui.MenusScreenGui.MainMenuWindow.Visible = true
        elseif game:GetService("Players").LocalPlayer.PlayerGui.MenusScreenGui.MainMenuWindow.Visible == true then
            game:GetService("Players").LocalPlayer.PlayerGui.MenusScreenGui.MainMenuWindow.Visible = false
        end
	end,
})
sections.GameSection2:Button({
	Name = "Reset button [ Mobile ]",
	Callback = function()
        Window:Notify({
            Title = 'InfinityX',
            Description = "New button generated!"
        })
        for _, v in pairs(game:GetService('CoreGui'):GetChildren()) do
            if v:IsA('ScreenGui') and v.Name == 'Button' then
                v:Destroy() wait() loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/main/Software/button.lua"))()
            end
        end
	end,
})
local p1 = sections.GameSection3:Label({ Text = 'nil' }, nil)
local p2 = sections.GameSection3:Label({ Text = 'nil' }, nil)
local p3 = sections.GameSection3:Label({ Text = 'nil' }, nil)
local p4 = sections.GameSection3:Label({ Text = 'nil' }, nil)
local p5 = sections.GameSection3:Label({ Text = 'nil' }, nil)
local labels = {p1, p2, p3, p4, p5}
local assignedLabels = {}

local function updateLabels()
    local availableLabels = {unpack(labels)}
    local playersList = Players:GetPlayers()

    assignedLabels = {}

    for i, player in ipairs(playersList) do
        if availableLabels[i] then
            assignedLabels[player] = availableLabels[i]
            availableLabels[i]:UpdateName(player.Name)
        end
    end

    for i = #playersList + 1, #labels do
        labels[i]:UpdateName("Empty player")
    end
end
local function updateStats()
    for player, label in pairs(assignedLabels) do
        if label and label.Text ~= "Empty player" then
            local statsModule = player:FindFirstChild("SavedPlayerStatsModule")
            local tempStatsModule = player:FindFirstChild("TempPlayerStatsModule")

            if statsModule and tempStatsModule then
                local LevelValue = statsModule:FindFirstChild("Level") and statsModule.Level.Value or "N/A"
                local CapturedValue = tempStatsModule:FindFirstChild("Captured") and (tempStatsModule.Captured.Value and "Yes" or "No") or "N/A"
                local HealthValue = tempStatsModule:FindFirstChild("Health") and tempStatsModule.Health.Value or "N/A"
                local BeastValue = tempStatsModule:FindFirstChild("IsBeast") and (tempStatsModule.IsBeast.Value and "Yes" or "No") or "N/A"

                label:UpdateName("<b>-> " .. player.Name .. " </b>\n  • Level: " .. LevelValue .. "\n  • Captured: " .. CapturedValue .. "\n  • Health: " .. HealthValue .. "\n  • Is Beast: " .. BeastValue)
            else
                label:UpdateName(player.Name .. " | Loading stats...")
            end
        end
    end
end

Players.PlayerAdded:Connect(updateLabels)
Players.PlayerRemoving:Connect(updateLabels)
updateLabels()

task.spawn(function()
    while true do
        updateStats()
        task.wait(1)
    end
end)
sections.GameSection4:Button({
	Name = "Lobby",
	Callback = function()
        game:GetService("TeleportService"):Teleport(893973440, game:GetService("Players").LocalPlayer)
	end,
})
sections.GameSection4:Button({
	Name = "Trading Post",
	Callback = function()
        game:GetService("TeleportService"):Teleport(1738581510, game:GetService("Players").LocalPlayer)
	end,
})
sections.GameSection4:Button({
	Name = "Voice Server",
	Callback = function()
        game:GetService("TeleportService"):Teleport(125624013879756, game:GetService("Players").LocalPlayer)
	end,
})
sections.GameSection4:Button({
	Name = "Pro Server",
	Callback = function()
        game:GetService("TeleportService"):Teleport(132745842491660, game:GetService("Players").LocalPlayer)
	end,
})
sections.GameSection5:Toggle({
	Name = "Fly",
	Default = false,
	Callback = function(bool)
        function _G.Fly(char)
            local hrp = char:WaitForChild("HumanoidRootPart")
            local bv = Instance.new("BodyVelocity")
            local bg = Instance.new("BodyGyro")

            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.zero
            bv.Parent = hrp

            bg.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
            bg.P = 1e5
            bg.CFrame = hrp.CFrame
            bg.Parent = hrp

            _G._flyConn = game:GetService("RunService").RenderStepped:Connect(function()
                local cam = workspace.CurrentCamera
                local move = Vector3.zero
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then move += cam.CFrame.UpVector end
                if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) then move -= cam.CFrame.UpVector end
                bv.Velocity = move.Unit * 60
                if move.Magnitude == 0 then bv.Velocity = Vector3.zero end
                bg.CFrame = cam.CFrame
            end)
        end

        function _G.Unfly()
            if _G._flyConn then _G._flyConn:Disconnect() _G._flyConn = nil end
            local char = game.Players.LocalPlayer.Character
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                if hrp:FindFirstChildOfClass("BodyVelocity") then hrp:FindFirstChildOfClass("BodyVelocity"):Destroy() end
                if hrp:FindFirstChildOfClass("BodyGyro") then hrp:FindFirstChildOfClass("BodyGyro"):Destroy() end
            end
        end

        fly = bool
        if fly then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Fly actived!"
            })
            _G.Fly(game.Players.LocalPlayer.Character)
        else
            _G.Unfly()
        end
	end,
}, "Toggle")
sections.GameSection5:Toggle({
	Name = "Noclip",
	Default = false,
	Callback = function(bool)
        function _G.Noclip()
            _G._noclipConn = game:GetService("RunService").Stepped:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char then
                    for _, part in pairs(char:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end

        function _G.Clip()
            if _G._noclipConn then _G._noclipConn:Disconnect() _G._noclipConn = nil end
            local char = game.Players.LocalPlayer.Character
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end

        Noclip = bool
        if Noclip then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Noclip actived!"
            })
            _G.Noclip()
        else
            _G.Clip()
        end
	end,
}, "Toggle")
sections.GameSection5:Toggle({
	Name = "Infinite Jump",
	Default = false,
	Callback = function(bool)
        function _G.InfiniteJump()
            _G._jumpConn = game:GetService("UserInputService").JumpRequest:Connect(function()
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        end

        function _G.DisableInfiniteJump()
            if _G._jumpConn then _G._jumpConn:Disconnect() _G._jumpConn = nil end
        end

        infJump = bool
        if infJump then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Infinite jump actived!"
            })
            _G.InfiniteJump()
        else
            _G.DisableInfiniteJump()
        end
	end,
}, "Toggle")


sections.LPlayerSection1:Header({
    Name = "[🏃] Survival Options"
})
sections.LPlayerSection2:Header({
    Name = "[🔨] Beast Options"
})
sections.LPlayerSection3:Header({
    Name = "[🙍] Character Options"
})
sections.LPlayerSection4:Header({
    Name = "[💤] Afk"
})
sections.LPlayerSection1:Toggle({
	Name = "Anti ragdoll",
	Default = false,
	Callback = function(bool)
        antiRagdoll = bool
        if antiRagdoll then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Anti ragdoll actived!"
            })
        end
        if antiRagdoll then
            while antiRagdoll do task.wait()
                for _, v in pairs(game:GetService("Players").LocalPlayer.TempPlayerStatsModule:GetChildren()) do
                    if (v:IsA('BoolValue') and v.Name == 'Ragdoll') then
                        if v.Value == true then
                            wait(.2)
                            v.Value = false
                            game.Players.LocalPlayer.Character.Ragdoller.Enabled = false
                            game.Players.LocalPlayer.Character.Humanoid.PlatformStand = false
                        end
                    end
                end
            end
        else
            wait(.5)
            for _, v in pairs(game:GetService("Players").LocalPlayer.TempPlayerStatsModule:GetChildren()) do
                if (v:IsA('BoolValue') and v.Name == 'Ragdoll') then
                    if (v.Value == true) then
                        v.Value = false
                    end
                end
            end
        end
	end,
}, "Toggle")
sections.LPlayerSection1:Toggle({
	Name = "No slow",
	Default = false,
	Callback = function(bool)
        NoSlow = bool
        if NoSlow then
            Window:Notify({
                Title = 'InfinityX',
                Description = "No slow actived!"
            })
        end
        WalkSpeedBypass()
        while NoSlow do task.wait()
            while NoSlow do task.wait()
                if game.Players.LocalPlayer.Character.Humanoid.WalkSpeed < 16 then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
                end
            end
        end
	end,
}, "Toggle")
sections.LPlayerSection1:Toggle({
	Name = "Self-protection",
	Default = false,
	Callback = function(bool)
        autoProtection = bool
        if autoProtection then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Self-protection actived!"
            })
        end

		local Players = game:GetService("Players")
		local RunService = game:GetService("RunService")
		local LocalPlayer = Players.LocalPlayer
		local safePos = Vector3.new(400.9646301269531, 6.3987059593200684, 157.8434600830078)
		local savedPos
		local teleported = false

        local function getBeastSelf()
			for _, v in pairs(Players:GetChildren()) do
				if v.Name ~= LocalPlayer.Name then
					if v.Character and v.Character:FindFirstChild("BeastPowers") then
						return v
					end
				end
			end
		end

		RunService.Stepped:Connect(function()
			if autoProtection then
				local beast = getBeastSelf()
				if beast and beast.Character and LocalPlayer.Character then
					local beastPos = beast.Character:FindFirstChild("HumanoidRootPart")
					local myPos = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
					if beastPos and myPos then
						local dist = (beastPos.Position - myPos.Position).Magnitude
						if dist < 30 and not teleported then
							savedPos = myPos.Position
							myPos.CFrame = CFrame.new(safePos)
							teleported = true
						elseif teleported and savedPos and (beastPos.Position - savedPos).Magnitude > 30 then
							myPos.CFrame = CFrame.new(savedPos)
							teleported = false
						end
					end
				end
			end
		end)
	end,
}, "Toggle")
sections.LPlayerSection2:Toggle({
	Name = "Knock aura",
	Default = false,
	Callback = function(bool)
        knock = bool
        if (knock) then
            local beastPower = game:GetService('Players').LocalPlayer.Character:FindFirstChild('BeastPowers')
            if not beastPower then
                Window:Notify({
                    Title = 'InfinityX',
                    Description = "You dont is the beast"
                })
                return
            else
                Window:Notify({
                    Title = 'InfinityX',
                    Description = "Knock aura actived!"
                })
            end
        end
        while knock do task.wait()
            for _, v in pairs(game.Players:GetChildren()) do
                if v.Name ~= game.Players.LocalPlayer.Name then
                    for _, x in pairs(game.Players[v.Name].Character:GetChildren()) do
                        if (x:IsA('Part') and x.Name == 'Left Arm') then
                            local ohString1 = "HammerHit"
                            local ohInstance2 = x
                            game.Players.LocalPlayer.Character.Hammer.HammerEvent:FireServer(ohString1, ohInstance2)
                            wait(.1)
                        end
                    end
                end
            end
        end
	end,
}, "Toggle")
sections.LPlayerSection2:Toggle({
	Name = "Active crawling",
	Default = false,
	Callback = function(bool)
        activeCraw = bool
        if activeCraw then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Crawling actived!"
            })
        end
        while activeCraw do task.wait()
            game:GetService("Players").LocalPlayer.TempPlayerStatsModule.DisableCrawl.Value = false
        end
	end,
}, "Toggle")
sections.LPlayerSection2:Toggle({
	Name = "No hammer cooldown",
	Default = false,
	Callback = function(bool)
        nohCD = bool
        while nohCD do task.wait()
            local Character = game:GetService("Players").LocalPlayer.Character or game:GetService("Players").LocalPlayer.CharacterAdded:wait()
            local Humanoid = Character:FindFirstChildOfClass("Humanoid") or Character:FindFirstChildOfClass("AnimationController")
            if not Humanoid or not Character then continue end
            for _, v in next, Humanoid:GetPlayingAnimationTracks() do
                v:AdjustSpeed(15)
            end
        end
	end,
}, "Toggle")
sections.LPlayerSection2:Button({
	Name = "Capture a random player",
	Callback = function()
        local map = workspace:FindFirstChild(tostring(game.ReplicatedStorage.CurrentMap.Value))
        local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        local TeleportOldPos = '';
        TeleportOldPos = oldPos

        local beastPower = game:GetService('Players').LocalPlayer.Character:FindFirstChild('BeastPowers')
        if not beastPower then
            Window:Notify({
                Title = 'InfinityX',
                Description = "You dont is the beast"
            })
            return
        end
        for _, v in pairs(game:GetService('Players'):GetChildren()) do
            if (v.Name ~= game.Players.LocalPlayer.Name) then
                if (v.TempPlayerStatsModule.Captured.Value == false) then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                    wait(.2)
                    local ohString1 = "HammerHit"
                    local ohInstance2 = v.Character["Left Arm"]
                    game.Players.LocalPlayer.Character.Hammer.HammerEvent:FireServer(ohString1, ohInstance2)
                    wait(.3)
                    local ohString1 = "HammerTieUp"
                    local ohInstance2 = v.Character.Torso
                    local ohVector33 = Vector3.new(v.Character.HumanoidRootPart.Position)
                    game.Players.LocalPlayer.Character.Hammer.HammerEvent:FireServer(ohString1, ohInstance2, ohVector33)
                    wait(.5)
                    for _, x in pairs(map:GetChildren()) do
                        if x:IsA('Model') and x.Name == 'FreezePod' then
                            for _, z in pairs(x:GetDescendants()) do
                                if z:IsA('IntValue') and z.Name == 'ActionSign' then
                                    if z.Value == 30 then
                                        local pivotCFrame = x:GetPivot()
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pivotCFrame
                                        wait(.5)
                                        KeyPress('E')
                                        wait(.2)
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportOldPos)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
	end,
})
local walkspeedInput = sections.LPlayerSection3:Input({
	Name = "WalkSpeed",
	Placeholder = "value",
	AcceptedCharacters = "Numeric",
	Callback = function(input)
		WalkSpeedValue = input
	end,
}, "TargetInput")
local jumppowerInput = sections.LPlayerSection3:Input({
	Name = "JumpPower",
	Placeholder = "value",
	AcceptedCharacters = "Numeric",
	Callback = function(input)
		JumpPowerValue = input
	end,
}, "TargetInput")
sections.LPlayerSection3:Divider()
sections.LPlayerSection3:Button({
	Name = "Set values",
	Callback = function()
        WalkSpeedBypass()
        JumpPowerBypass()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = WalkSpeedValue
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = JumpPowerValue
	end,
})
sections.LPlayerSection3:Button({
	Name = "Reset values",
	Callback = function()
        WalkSpeedBypass()
        JumpPowerBypass()
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        walkspeedInput:UpdateText('value')
        jumppowerInput:UpdateText('value')
	end,
})
sections.LPlayerSection4:Toggle({
	Name = "Afk farm [BETA]",
	Default = false,
	Callback = function(bool)
        afkFarmToggle = bool
        if afkFarmToggle then
            Window:Notify({
                Title = 'InfinityX',
                Description = "Afk farm actived!"
            })

            workspace:FindFirstChild('LobbySpawnPad').Size = Vector3.new(65, 1, 65)
        end
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local VirtualInput = game:GetService("VirtualInputManager")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TweenService = game:GetService("TweenService")

        local LocalPlayer = Players.LocalPlayer
        local function HRP() return LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") end

        local safePos = Vector3.new(400.9646301269531, 4.3987059593200684, 157.8434600830078)
        local savedPos
        local teleportedToSafe = false
        local returnedFromSafe = false
        local waiting = false
        local exited = false
        local currentComputer = nil
        local progress = LocalPlayer.TempPlayerStatsModule.ActionProgress
        local computersLeft = ReplicatedStorage:WaitForChild("ComputersLeft")
        local exitTrigger, exitArea

        local function CreatePlataform()
            local safezone = workspace:FindFirstChild("safezone")
            if not safezone then
                local model = Instance.new("Model", workspace)
                model.Name = "safezone"
                local plataform = Instance.new("Part", model)
                plataform.Position = Vector3.new(400.9646301269531, 2.3987059593200684, 157.8434600830078)
                plataform.Size = Vector3.new(10, 1.2, 10)
                plataform.Name = "handle"
                plataform.Anchored = true
            end
        end

        local function KeyPressAfk(key)
            VirtualInput:SendKeyEvent(true, key, false, game)
            wait(0.1)
            VirtualInput:SendKeyEvent(false, key, false, game)
        end

        local function getBeast()
            for _, v in pairs(Players:GetChildren()) do
                if v.Name ~= LocalPlayer.Name then
                    if v.Character and v.Character:FindFirstChild("BeastPowers") then
                        return v
                    end
                end
            end
        end

        local function getComputers()
            local map = workspace:FindFirstChild(tostring(ReplicatedStorage.CurrentMap.Value))
            if not map then return {} end
            local list = {}
            for _, v in pairs(map:GetChildren()) do
                if v:IsA("Model") and v.Name == "ComputerTable" then
                    for _, x in pairs(v:GetChildren()) do
                        if x:IsA("Part") and x.Name:lower():find("computertrigger") then
                            if x.ActionSign.Value == 20 and v.Screen.Color ~= Color3.fromRGB(40, 127, 71) then
                                table.insert(list, {trigger = x, model = v})
                            end
                        end
                    end
                end
            end
            return list
        end

        local function teleportToExit()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Model") and v.Name == "ExitDoor" then
                    for _, x in pairs(v:GetChildren()) do
                        if x:IsA("Part") and x.Name == "ExitDoorTrigger" then
                            exitTrigger = x
                        elseif x:IsA("Part") and x.Name == "ExitArea" then
                            exitArea = x
                        end
                    end
                end
            end

            if HRP() and exitTrigger then
                HRP().CFrame = exitTrigger.CFrame
                wait(0.5)
                KeyPressAfk("E")
            end
        end

        CreatePlataform()

        ReplicatedStorage.CurrentMap:GetPropertyChangedSignal("Value"):Connect(function()
            exited = false
            currentComputer = nil
            waiting = false
            teleportedToSafe = false
            returnedFromSafe = false
        end)

        computersLeft:GetPropertyChangedSignal("Value"):Connect(function()
            if afkFarmToggle then
                if not LocalPlayer.TempPlayerStatsModule.IsBeast.Value and not inSpawn() then
                    if computersLeft.Value == 0 and not exited then
                        exited = true
                        currentComputer = nil
                        waiting = false
                        teleportedToSafe = false
                        returnedFromSafe = false
                        teleportToExit()
                    end
                end
            end
        end)

        RunService.Stepped:Connect(function()
            if not afkFarmToggle or inSpawn() then return end

            if LocalPlayer.TempPlayerStatsModule.IsBeast.Value == false then
                local hrp = HRP()
                local beast = getBeast()
                local beastHRP = beast and beast.Character and beast.Character:FindFirstChild("HumanoidRootPart")

                if beastHRP and hrp then
                    local dist = (beastHRP.Position - hrp.Position).Magnitude
                    if dist < afkFarmSettings.Distance and not teleportedToSafe then
                        savedPos = hrp.Position
                        hrp.CFrame = CFrame.new(safePos)
                        KeyPressAfk("E")
                        teleportedToSafe = true
                    elseif teleportedToSafe and savedPos and (beastHRP.Position - savedPos).Magnitude > afkFarmSettings.DistanceToBeast then
                        hrp.CFrame = CFrame.new(savedPos)
                        teleportedToSafe = false
                        returnedFromSafe = true
                    end
                end

                if exited and exitTrigger and exitArea and hrp then
                    if progress.Value == 1 then
                        wait(3)
                        local tween = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = exitArea.CFrame})
                        tween:Play()
                        wait(1.5)
                        if LocalPlayer.TempPlayerStatsModule.Escaped.Value then
                            hrp.CFrame = workspace.LobbySpawnPad.CFrame
                        end
                    end
                    return
                end

                if waiting or computersLeft.Value == 0 then return end

                if not currentComputer then
                    local comps = getComputers()
                    for _, comp in pairs(comps) do
                        currentComputer = comp
                        savedPos = hrp and hrp.Position
                        break
                    end
                end

                if currentComputer and hrp and not teleportedToSafe then
                    hrp.CFrame = currentComputer.trigger.CFrame * CFrame.new(0, 0.2, 0)
                    wait(.5)
                    task.delay(0.2, function()
                        VirtualInput:SendKeyEvent(true, "E", false, game)
                        wait(0.1)
                        VirtualInput:SendKeyEvent(false, "E", false, game)
                    end)
                end

                if returnedFromSafe and hrp then
                    if currentComputer then
                        hrp.CFrame = currentComputer.trigger.CFrame
                    elseif exitTrigger then
                        hrp.CFrame = exitTrigger.CFrame
                    end
                    wait(0.5)
                    VirtualInput:SendKeyEvent(true, "E", false, game)
                    wait(0.1)
                    VirtualInput:SendKeyEvent(false, "E", false, game)
                    returnedFromSafe = false
                end

                if progress.Value >= 1 then
                    currentComputer = nil
                    waiting = true
                    hrp.CFrame = CFrame.new(safePos)
                    KeyPressAfk("E")
                    task.delay(20, function()
                        waiting = false
                    end)
                end
            elseif game:GetService('Players').LocalPlayer.Character:FindFirstChild('BeastPowers') then
                local map = workspace:FindFirstChild(tostring(game.ReplicatedStorage.CurrentMap.Value))
                local oldPos = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
                local TeleportOldPos = '';
                TeleportOldPos = oldPos

                for _, v in pairs(game:GetService('Players'):GetChildren()) do
                    if (v.Name ~= game.Players.LocalPlayer.Name) then
                        if (v.TempPlayerStatsModule.Captured.Value == false) then
                            if v.TempPlayerStatsModule.Ragdoll.Value == false then
                                game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.Character.HumanoidRootPart.CFrame
                                wait(.2)
                                local ohString1 = "HammerHit"
                                local ohInstance2 = v.Character["Left Arm"]
                                game.Players.LocalPlayer.Character.Hammer.HammerEvent:FireServer(ohString1, ohInstance2)
                            elseif v.TempPlayerStatsModule.Ragdoll.Value == true then
                                local ohString1 = "HammerTieUp"
                                local ohInstance2 = v.Character.Torso
                                local ohVector33 = Vector3.new(v.Character.HumanoidRootPart.Position)
                                game.Players.LocalPlayer.Character.Hammer.HammerEvent:FireServer(ohString1, ohInstance2, ohVector33)
                                wait(.5)
                                for _, x in pairs(map:GetChildren()) do
                                    if x:IsA('Model') and x.Name == 'FreezePod' then
                                        for _, z in pairs(x:GetDescendants()) do
                                            if z:IsA('IntValue') and z.Name == 'ActionSign' then
                                                if z.Value == 30 then
                                                    local pivotCFrame = x:GetPivot()
                                                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = pivotCFrame
                                                    wait(.2)
                                                    KeyPressAfk('E')
                                                    if v.TempPlayerStatsModule.Captured.Value == false then
                                                        wait(.2)
                                                    elseif v.TempPlayerStatsModule.Captured.Value == true then
                                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(TeleportOldPos)
                                                        wait(4)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
	end,
}, "Toggle")
sections.LPlayerSection4:Divider()
local walkspeedInput = sections.LPlayerSection4:Input({
	Name = "Set distance",
	Placeholder = "30",
	AcceptedCharacters = "Numeric",
	Callback = function(input)
		afkFarmSettings.Distance = input
	end,
}, "TargetInput")
local walkspeedInput = sections.LPlayerSection4:Input({
	Name = "Set distance to beast",
	Placeholder = "30",
	AcceptedCharacters = "Numeric",
	Callback = function(input)
		afkFarmSettings.DistaneToBeast = input
	end,
}, "TargetInput")


sections.EspSection1:Header({
    Name = "[👀] Esp Players"
})
sections.EspSection2:Header({
    Name = "[💻] Esp Computers"
})
sections.EspSection1:Toggle({
	Name = "Esp players",
	Default = false,
	Callback = function(bool)
        ESPEnabled = bool
        if not ESPEnabled then
            deleteESP()
        else
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end
            Players.PlayerAdded:Connect(function(player)
                if player ~= LocalPlayer then
                    createESP(player)
                end
            end)
        end
	end,
}, "Toggle")
sections.EspSection1:Divider()
local StyleDropdown = sections.EspSection1:Dropdown({
	Name = "Box style",
	Search = false,
	Multi = false,
	Required = false,
	Options = {'3d', '2d'},
	Default = '3d',
	Callback = function(Options)
        selectedBoxStyle = Options
        if selectedBoxStyle == '3d' then
            getgenv().EspSettings.Box3D = true
        elseif selectedBoxStyle == '2d' then
            getgenv().EspSettings.Box3D = false
        end
	end,
}, "Dropdown")
sections.EspSection1:Toggle({
	Name = "Names",
	Default = true,
	Callback = function(bool)
        getgenv().EspSettings.Name = bool
	end,
}, "Toggle")
sections.EspSection1:Toggle({
	Name = "Tracers",
	Default = true,
	Callback = function(bool)
        getgenv().EspSettings.Tracers = bool
	end,
}, "Toggle")
sections.EspSection1:Toggle({
	Name = "Studs",
	Default = true,
	Callback = function(bool)
        getgenv().EspSettings.Studs = bool
	end,
}, "Toggle")
sections.EspSection2:Toggle({
	Name = "Esp computers",
	Default = false,
	Callback = function(bool)
        ESPComputer = bool
        if not ESPComputer then
            local map = workspace:FindFirstChild(tostring(game.ReplicatedStorage.CurrentMap.Value))
            if map then
                local computerTables = map:GetChildren()
                for _, table in pairs(computerTables) do
                    if table:IsA("Model") and table.Name == "ComputerTable" then
                        for _, screen in pairs(table:GetDescendants()) do
                            if (screen:IsA("Part") or screen:IsA("UnionOperation")) and screen.Name == "Screen" then
                                local billboardGui = screen:FindFirstChild("BillboardGui")
                                if billboardGui then
                                    billboardGui.Enabled = false
                                end
                            end
                        end
                    end
                end
            end
        else
            Window:Notify({
                Title = 'InfinityX',
                Description = "Esp computer actived!"
            })
            while ESPComputer do task.wait()
                updateComputerESP()
            end
        end
	end,
}, "Toggle")


sections.EspSeettingsSection1:Header({
	Name = "[🖌️] Esp Colors"
})
local playerPicker = sections.EspSeettingsSection1:Colorpicker({
	Name = "Set the player's colour",
	Default = Color3.fromRGB(70, 243, 84),
	Alpha = 0,
	Callback = function(color, alpha)
        getgenv().EspSettings.InnocentColor = color
	end,
}, "ESPColorToggle")
local beastPicker = sections.EspSeettingsSection1:Colorpicker({
	Name = "Set the beast colour",
	Default = Color3.fromRGB(255, 0, 0),
	Alpha = 0,
	Callback = function(color, alpha)
        getgenv().EspSettings.BeastColor = color
	end,
}, "ESPColorToggle")
sections.EspSeettingsSection1:Button({
	Name = "Reset colors",
	Callback = function()
        BeastColor = Color3.new(255, 0, 0)
        InoccentColor = Color3.new(255, 255, 255)
        playerPicker:SetColor(Color3.new(255, 255, 255))
        beastPicker:SetColor(Color3.new(255, 0, 0))
	end,
})



-- extra functions
workspace:FindFirstChild('LobbySpawnPad').Size = Vector3.new(65, 1, 65)
warn('InfinityX - [ LOADED ]')
