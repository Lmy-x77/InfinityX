-- detect service
local TextService = game:GetService("TextService")
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
    print("Mobile device")
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
local EspSettings = {
    SharkColor = Color3.fromRGB(0, 200, 255),
    SurvivalColor = Color3.fromRGB(61, 240, 61),
    BoatColor = Color3.fromRGB(255, 62, 62),
}
local function createSurvivalESP(player)
    if not player.Character then return end
    local char = player.Character
    local primary = char:WaitForChild("HumanoidRootPart", 5)
    if not primary or char:FindFirstChild("EspSurvival") then return end

    local esp = Instance.new("Highlight", char)
    esp.Name = "EspSurvival"
    esp.FillColor = EspSettings.SurvivalColor

    local billboard = Instance.new("BillboardGui", primary)
    billboard.Name = "SurvivalName"
    billboard.Size = UDim2.new(0, 100, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true

    local label = Instance.new("TextLabel", billboard)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "👤 " .. player.Name
    label.TextColor3 = EspSettings.SurvivalColor
    label.TextStrokeTransparency = 0
    label.Font = Enum.Font.GothamBold
    label.TextScaled = true
end
local function connectPlayer(player)
    if player == game.Players.LocalPlayer then return end
    player.CharacterAdded:Connect(function()
        if espSurvival then
            createSurvivalESP(player)
        end
    end)
    if player.Character then
        createSurvivalESP(player)
    end
end
scriptVersion = '4.2a'



-- ui library
local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
function getDpiScale()
    if IsOnMobile then
        return Library:SetDPIScale(75)
    elseif not IsOnMobile then
        Library:SetDPIScale(100)
    end
end
local ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = true

local Window = Library:CreateWindow({
    Title = "InfinityX",
    Footer = "Shark Bite · ".. scriptVersion .. " · discord.gg/emKJgWMHAr",
    Icon = 126527122577864,
    NotifySide = "Right",
    ShowCustomCursor = false,
    Center = true,
    MobileButtonsSide = "Left",
    Resizable = false,
    Size = UDim2.fromOffset(650, 410),
    ToggleKeybind = Enum.KeyCode.K
})



-- tabs
local Tabs = {
  Main = Window:AddTab("Main", "layers"),
  Settings = Window:AddTab("Config.", "settings"),
}



-- source
local SurvivalGroupBox = Tabs.Main:AddLeftGroupbox("Survival", "heart-pulse")
local MiscGroupBox = Tabs.Main:AddLeftGroupbox("Misc", "wrench")
local SharkGroupBox = Tabs.Main:AddRightGroupbox("Shark", "waves")
local CharacterGroupBox = Tabs.Main:AddRightGroupbox("Character", "user")
SurvivalGroupBox:AddToggle("MyToggle", {
	Text = "Esp shark",
	Tooltip = "Active to esp the shark",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
		espShark = Value
        if espShark then
            Library:Notify({
                Title = "InfinityX",
                Description = "Esp shark enabled",
                Time = 4,
            })
            for _, v in pairs(workspace.Sharks:GetChildren()) do
                if v:IsA('Model') and not v:FindFirstChild('EspShark') then
                    local espShark = Instance.new('Highlight', v)
                    espShark.Name = "EspShark"
                    espShark.FillColor = EspSettings.SharkColor

                    local billboard = Instance.new("BillboardGui", v.PrimaryPart)
                    billboard.Name = "SharkName"
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "🦈 Shark"
                    label.TextColor3 = EspSettings.SharkColor
                    label.TextStrokeTransparency = 0
                    label.Font = Enum.Font.GothamBold
                    label.TextScaled = true
                end
            end
        else
            for _, v in pairs(workspace.Sharks:GetDescendants()) do
                if v:IsA("Highlight") and v.Name == "EspShark" then
                    v:Destroy()
                end
            end
            for _, v in pairs(workspace.Sharks:GetDescendants()) do
                if v:IsA("BillboardGui") and v.Name == "SharkName" then
                    v:Destroy()
                end
            end
        end
        workspace.Sharks.ChildAdded:Connect(function(shark)
            if espShark and shark:IsA("Model") and not shark:FindFirstChild("EspShark") then
                local espShark = Instance.new("Highlight", shark)
                espShark.Name = "EspShark"
                espShark.FillColor = EspSettings.SharkColor

                local primary = shark:WaitForChild("Body", 5)
                if not primary then return end

                local billboard = Instance.new("BillboardGui", primary)
                billboard.Name = "SharkName"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "🦈 Shark"
                label.TextColor3 = EspSettings.SharkColor
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBold
                label.TextScaled = true
            end
        end)
	end,
}):AddColorPicker("ColorPicker1", {
    Default = Color3.fromRGB(0, 200, 255),
    Title = "Esp shark color",
    Transparency = 0,

    Callback = function(Value)
        EspSettings.SharkColor = Value
    end,
})
SurvivalGroupBox:AddToggle("MyToggle", {
	Text = "Auto teleport to shark",
	Tooltip = "Active to teleport to all sharks automatically",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        autoTpShark = Value
        if autoTpShark then
            Library:Notify({
                Title = "InfinityX",
                Description = "Auto teleport shark enabled",
                Time = 4,
            })
        end
        while autoTpShark do task.wait()
            local lp = game.Players.LocalPlayer
            local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
            for _, v in pairs(workspace.Sharks:GetChildren()) do
                if v:IsA("Model") and v.PrimaryPart and v.PrimaryPart.Name == "Body" then
                    local initialPos = v.PrimaryPart.Position
                    task.wait()
                    if (v.PrimaryPart.Position - initialPos).Magnitude > 0.1 then
                        hrp.CFrame = v.PrimaryPart.CFrame * CFrame.new(20, 0, 0)
                        break
                    end
                end
            end
        end
	end,
})
SurvivalGroupBox:AddToggle("MyToggle", {
	Text = "Auto chest",
	Tooltip = "Active to automatically collect the chest",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        autoChest = Value
        if autoChest then
            Library:Notify({
                Title = "InfinityX",
                Description = "Auto chest enabled",
                Time = 4,
            })
        end
        while autoChest do task.wait()
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA('Model') and v.Name == 'ChestDrop' then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v:FindFirstChild('PrimaryPart').CFrame
                end
            end
        end
	end,
})
SurvivalGroupBox:AddButton({
	Text = "Inifnite ammo",
	Func = function()
        local success = pcall(function()
            for _, tool in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA('Tool') then
                    local ls = tool:FindFirstChild('LocalScript')
                    if ls then
                        for _, func in pairs(getgc(true)) do
                            if typeof(func) == "function" and getfenv(func).script == ls then
                                if debug.getinfo(func).name == "reload" then
                                    debug.setupvalue(func, 4, math.huge)
                                    local check = debug.getupvalue(func, 4)

                                    wait()
                                    if check == math.huge then
                                        Library:Notify({
                                            Title = "InfinityX",
                                            Description = "Infinite ammo added to "..tool.Name,
                                            Time = 2,
                                        })
                                    else
                                        Library:Notify({
                                            Title = "InfinityX",
                                            Description = "Unable to add infinite ammo function to weapon: "..tool.Name,
                                            Time = 4,
                                        })
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end)

        if not success then
            Library:Notify({
                Title = "InfinityX",
                Description = "Your exploit doesn't support this function",
                Time = 4,
            })
        end
	end,
	DoubleClick = false,

	Tooltip = "Click to get infinite ammo in your gun",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
SurvivalGroupBox:AddButton({
	Text = "Remove ragdoll",
	Func = function()
        if game:GetService("ReplicatedStorage"):FindFirstChild('Ragdoll') then
            local ragdollScript = game:GetService("ReplicatedStorage").Ragdoll
            local ragdollModule = require(ragdollScript)
            for k, v in pairs(ragdollModule) do
                if typeof(v) == "function" then
                    ragdollModule[k] = function() end
                end
            end

            Library:Notify({
                Title = "InfinityX",
                Description = "Ragdoll removed",
                Time = 4,
            })
            ragdollScript.Name = 'BypassedRagdoll'
        elseif not game:GetService("ReplicatedStorage"):FindFirstChild('Ragdoll') then
            Library:Notify({
                Title = "InfinityX",
                Description = "Ragdoll allready removed",
                Time = 4,
            })
        end
    end,
	DoubleClick = false,

	Tooltip = "Click to remove ragdoll",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
SurvivalGroupBox:AddButton({
	Text = "Teleport to lobby",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Teleporting to lobby",
            Time = 4,
        })
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-1, 286, -36)
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to lobby",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
SurvivalGroupBox:AddButton({
	Text = "Teleport to shark",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Telporting to shark",
            Time = 4,
        })
        local lp = game.Players.LocalPlayer
        local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
        for _, v in pairs(workspace.Sharks:GetChildren()) do
            if v:IsA("Model") and v.PrimaryPart and v.PrimaryPart.Name == "Body" then
                local initialPos = v.PrimaryPart.Position
                task.wait(0.2)
                if (v.PrimaryPart.Position - initialPos).Magnitude > 0.1 then
                    hrp.CFrame = v.PrimaryPart.CFrame * CFrame.new(20, 0, 0)
                    break
                end
            end
        end
	end,
	DoubleClick = false,

	Tooltip = "Click to teleport to shark",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
MiscGroupBox:AddButton({
	Text = "Get flare gun",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Getting flare gun",
            Time = 4,
        })
        for _, v in pairs(game:GetService("ReplicatedStorage").Gear:GetChildren()) do
            if v:IsA('Tool') and v.Name == 'FlareGun' then
                local cloneTool = v:Clone()
                cloneTool.Parent = game.Players.LocalPlayer.Backpack
            end
        end
	end,
	DoubleClick = false,

	Tooltip = "Click to get the flare gun",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
MiscGroupBox:AddButton({
	Text = "Remove barriers",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Barriers removed",
            Time = 4,
        })
        for _, v in pairs(workspace:GetDescendants()) do
            if (v:IsA("Part") or v:IsA('Model')) and v.Name:lower():find("barrier") then
                v:Destroy()
            end
        end
	end,
	DoubleClick = false,

	Tooltip = "Click to remove barriers",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
MiscGroupBox:AddButton({
	Text = "Get old guns",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Old guns added to your backpack",
            Time = 4,
        })

        for _, v in pairs(game:GetService("Lighting").OLDBoatStorage:GetChildren()) do
            if v:IsA('Tool') then
                local cloneTool = v:Clone()
                cloneTool.Parent = game.Players.LocalPlayer.Backpack
            end
        end
	end,
	DoubleClick = false,

	Tooltip = "Click to get old guns",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
SharkGroupBox:AddToggle("MyToggle", {
	Text = "Esp survivals",
	Tooltip = "Active to esp the survivals",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        espSurvival = Value
        if espSurvival then
            Library:Notify({
                Title = "InfinityX",
                Description = "Esp survivals enabled",
                Time = 4,
            })
            for _, v in pairs(game.Players:GetPlayers()) do
                connectPlayer(v)
            end
            game.Players.PlayerAdded:Connect(connectPlayer)
        else
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("Highlight") and v.Name == "EspSurvival" or
                   v:IsA("BillboardGui") and v.Name == "SurvivalName" then
                    v:Destroy()
                end
            end
        end
	end,
}):AddColorPicker("ColorPicker1", {
    Default = Color3.fromRGB(61, 240, 61),
    Title = "Esp player color",
    Transparency = 0,

    Callback = function(Value)
        EspSettings.SurvivalColor = Value
    end,
})
SharkGroupBox:AddToggle("MyToggle", {
	Text = "Esp boats",
	Tooltip = "Active to esp the boats",
	DisabledTooltip = "I am disabled!",

	Default = false,
	Disabled = false,
	Visible = true,
	Risky = false,

	Callback = function(Value)
        espBoats = Value
        if espBoats then
            Library:Notify({
                Title = "InfinityX",
                Description = "Esp boats enabled",
                Time = 4,
            })
            for _, v in pairs(workspace.Boats:GetChildren()) do
                if v:IsA('Model') and not v:FindFirstChild('EspBoat') then
                    local espBoat = Instance.new('Highlight', v)
                    espBoat.Name = "EspBoat"
                    espBoat.FillColor = EspSettings.BoatColor

                    local billboard = Instance.new("BillboardGui", v.PrimaryPart)
                    billboard.Name = "BoatName"
                    billboard.Size = UDim2.new(0, 100, 0, 40)
                    billboard.StudsOffset = Vector3.new(0, 3, 0)
                    billboard.AlwaysOnTop = true

                    local label = Instance.new("TextLabel", billboard)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "🚤 Boat"
                    label.TextColor3 = EspSettings.BoatColor
                    label.TextStrokeTransparency = 0
                    label.Font = Enum.Font.GothamBold
                    label.TextScaled = true
                end
            end
        else
            for _, v in pairs(workspace.Boats:GetDescendants()) do
                if v:IsA("Highlight") and v.Name == "EspBoat" then
                    v:Destroy()
                end
            end
            for _, v in pairs(workspace.Boats:GetDescendants()) do
                if v:IsA("BillboardGui") and v.Name == "BoatName" then
                    v:Destroy()
                end
            end
        end
        workspace.Boats.ChildAdded:Connect(function(boat)
            if espBoats and boat:IsA("Model") and not boat:FindFirstChild("EspBoat") then
                local espBoat = Instance.new("Highlight", boat)
                espBoat.Name = "EspBoat"
                espBoat.FillColor = EspSettings.BoatColor

                local primary = boat:WaitForChild("TP", 5)
                if not primary then return end

                local billboard = Instance.new("BillboardGui", primary)
                billboard.Name = "BoatName"
                billboard.Size = UDim2.new(0, 100, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 3, 0)
                billboard.AlwaysOnTop = true

                local label = Instance.new("TextLabel", billboard)
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.Text = "🚤 Boat"
                label.TextColor3 = EspSettings.BoatColor
                label.TextStrokeTransparency = 0
                label.Font = Enum.Font.GothamBold
                label.TextScaled = true
            end
        end)
	end,
}):AddColorPicker("ColorPicker1", {
    Default = Color3.fromRGB(255, 62, 62),
    Title = "Esp boat color",
    Transparency = 0,

    Callback = function(Value)
        EspSettings.BoatColor = Value
    end,
})
SharkGroupBox:AddButton({
	Text = "Delete boats",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Boats deleted!",
            Time = 4,
        })

        for _, v in pairs(workspace.Boats:GetChildren()) do
            if v:IsA("Model") then
                v:Destroy()
            end
        end
	end,
	DoubleClick = false,

	Tooltip = "Click to delete all boats + freeze players",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
if not IsOnMobile then
    CharacterGroupBox:AddSlider("MySlider", {
    	Text = "WalkSpeed",
    	Default = 16,
    	Min = 16,
    	Max = 500,
    	Rounding = 1,
    	Compact = false,

    	Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
    	end,

    	Tooltip = "Chence your walkspeed",
    	DisabledTooltip = "I am disabled!",

    	Disabled = false,
    	Visible = true,
    })
    CharacterGroupBox:AddSlider("MySlider", {
    	Text = "JumpPower",
    	Default = 50,
    	Min = 50,
    	Max = 500,
    	Rounding = 1,
    	Compact = false,

    	Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
    	end,

    	Tooltip = "Chence your jumppower",
    	DisabledTooltip = "I am disabled!",

    	Disabled = false,
    	Visible = true,
    })
elseif IsOnMobile then
    CharacterGroupBox:AddInput("MyTextbox", {
        Default = "",
        Numeric = true,
        Finished = false,
        ClearTextOnFocus = false,

        Text = "WalkSpeed",
        Placeholder = "16",

        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = Value
        end,
    })
    CharacterGroupBox:AddInput("MyTextbox", {
        Default = "",
        Numeric = true,
        Finished = false,
        ClearTextOnFocus = false,

        Text = "JumpPower",
        Placeholder = "50",

        Callback = function(Value)
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = Value
        end,
    })
end
CharacterGroupBox:AddDivider()
CharacterGroupBox:AddButton({
	Text = "Remove remote event",
	Func = function()
        local scriptRef = game:GetService("Players").LocalPlayer:WaitForChild("PlayerScripts"):FindFirstChild("LocalScript")
        local remote = workspace.Terrain:FindFirstChild("RemoteEvent")
        local remote2 = game:GetService("ReplicatedStorage"):FindFirstChild('HackerMessage')

        if remote then
            Library:Notify({
                Title = "InfinityX",
                Description = "Remote event removed!",
                Time = 4,
            })
        elseif not remote then
            Library:Notify({
                Title = "InfinityX",
                Description = "Remote event aleady removed!",
                Time = 4,
            })
            return
        end
        if hookfunction and hookmetamethod then
            local remoteName = "HackerMessage"
            local mt = getrawmetatable(game)

            setreadonly(mt, false)
                local oldNamecall = mt.__namecall
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if method == "FireServer" and tostring(self) == remoteName then
                        return
                    end
                    return oldNamecall(self, ...)
                end)
                hookfunction(game.Players.LocalPlayer.Kick, newcclosure(function(...)
                    return nil
                end))
                mt.__namecall = newcclosure(function(self, ...)
                    local method = getnamecallmethod()
                    if self == game.Players.LocalPlayer and method == "Kick" then
                        return nil
                    end
                    return oldNamecall(self, ...)
                end)
            setreadonly(mt, true)

            for _, func in pairs(getgc(true)) do
                if typeof(func) == "function" and getfenv(func).script == scriptRef then
                    for i = 1, debug.getinfo(func).nups do
                        debug.setupvalue(func, i, function() return nil end)
                    end
                    hookfunction(func, function() end)
                end
            end
            for _, conn in pairs(getconnections(scriptRef.AncestryChanged)) do conn:Disable() end
            for _, conn in pairs(getconnections(scriptRef.Changed)) do conn:Disable() end
            for _, conn in pairs(getconnections(scriptRef:GetPropertyChangedSignal("Parent"))) do conn:Disable() end

            warn('Remote event removed successfully!')

            scriptRef.Disabled = true
            remote:Destroy()
            remote2:Destroy()
        elseif not hookfunction then
            scriptRef.Disabled = true
            remote:Destroy()
            remote2:Destroy()
        end
	end,
	DoubleClick = false,

	Tooltip = "Remove remote event to prevent getting kicked for more security",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})
CharacterGroupBox:AddButton({
	Text = "Force day",
	Func = function()
        Library:Notify({
            Title = "InfinityX",
            Description = "Force day actived",
            Time = 4,
        })
        game.Lighting.ClockTime = 12
        game.Lighting.Brightness = 2
        game.Lighting.FogEnd = 1000000000000000
        game.Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
	end,
	DoubleClick = false,

	Tooltip = "Click to force day",
	DisabledTooltip = "I am disabled!",

	Disabled = false,
	Visible = true,
	Risky = false,
})


local UiSettingsGroubBox = Tabs.Settings:AddLeftGroupbox("Ui Settings", "brush")
local CreditsGroupBox = Tabs.Settings:AddRightGroupbox("Credits", "scroll-text")
UiSettingsGroubBox:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",

	Text = "Notification Side",

	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
if IsOnMobile then
    UiSettingsGroubBox:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "75%",

        Text = "DPI Scale",

        Callback = function(Value)
            Value = Value:gsub("%%", "")
            local DPI = tonumber(Value)

            Library:SetDPIScale(DPI)
        end,
    })
elseif not IsOnMobile then
    UiSettingsGroubBox:AddDropdown("DPIDropdown", {
        Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
        Default = "100%",

        Text = "DPI Scale",

        Callback = function(Value)
            Value = Value:gsub("%%", "")
            local DPI = tonumber(Value)

            Library:SetDPIScale(DPI)
        end,
    })
end
UiSettingsGroubBox:AddDivider()
UiSettingsGroubBox:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "K", NoUI = true, Text = "Menu keybind" })
Library.ToggleKeybind = Options.MenuKeybind
UiSettingsGroubBox:AddButton("Unload", function()
	Library:Unload()
end)
CreditsGroupBox:AddLabel("Script made by Lmy77")
CreditsGroupBox:AddButton("Discor server", function()
	setclipboard("https://discord.gg/emKJgWMHAr")
    Library:Notify({
        Title = "InfinityX",
        Description = "Discord server copied to clipboard",
        Time = 4,
    })
end)



-- extra functions
getDpiScale()
Library:Notify({
    Title = "InfinityX",
    Description = "Welcome ".. game.Players.LocalPlayer.Name .."",
    Time = 6,
})
Library:Notify({
    Title = "InfinityX",
    Description = "Script Loaded!",
    Time = 6,
})
wait(1.5)
Library:Notify({
    Title = "InfinityX",
    Description = "If there are any errors in the script, please let us know on the discord server. have fun 🥰",
    Time = 10,
})
