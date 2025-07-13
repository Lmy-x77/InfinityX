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
local scriptVersion = '3.2a'
local Players = game:GetService("Players")
local player = Players.LocalPlayer
function teleportMob(name, distance)
    for _, v in pairs(workspace.Monster:GetChildren()) do
        if v:IsA('Model') and v.Name == name then
            for _, x in pairs(v:GetChildren()) do
                if x:IsA('Part') and x.Name == 'Head' then
                    local modelPosition = x.Position
                    local cframe = CFrame.new(modelPosition + Vector3.new(0, distance, 0)) * CFrame.Angles(math.rad(270), 0, 0)
                    for _, hrt in pairs(game:GetService('Players').LocalPlayer.Character:GetChildren()) do
                        if hrt:IsA('Part') and hrt.Name == 'HumanoidRootPart' then
                            for _, hum in pairs(v:GetChildren()) do
                                if hum.Name == 'Humanoid' then
                                    if hum.Health ~= 0 then
                                        hrt.CFrame = cframe
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
function getQuest(name)
    for _, v in pairs(workspace.Location.QuestLocaion:GetChildren()) do
        if v:IsA('Part') and v.Name == name then
            game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = v.CFrame
        end
    end
    for _, v in pairs(workspace.NPCs.Quests_Npc:GetChildren()) do
        if v:IsA('Model') and v.Name == name then
            for _, x in pairs(v:GetDescendants()) do
                if x:IsA('ProximityPrompt') and x.Name == 'QuestPrompt' then
                    fireproximityprompt(x)
                end
            end
        end
    end
end
function teleportToQuest(name)
    for _, v in pairs(workspace.Location.QuestLocaion:GetChildren()) do
        if v:IsA('Part') and v.Name == name then
            game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = v.CFrame
        end
    end
end
function fireTool(name)
    for _, fireWeapon in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
        if fireWeapon:IsA('Tool') and fireWeapon.Name == name then
            fireWeapon:Activate()
        end
    end
end
function upgradeStats(name, amount)
    local args = {
        [1] = {
            ["Target"] = name,
            ["Action"] = "UpgradeStats",
            ["Amount"] = amount
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("OtherEvent"):WaitForChild("MainEvents"):WaitForChild("StatsFunction"):InvokeServer(unpack(args))
end
function simulateKeyPress(keyCode)
    game:GetService("VirtualInputManager"):SendKeyEvent(true, keyCode, false, nil)
    game:GetService("VirtualInputManager"):SendKeyEvent(false, keyCode, false, nil)
end
function useSkills()
    simulateKeyPress(Enum.KeyCode.Z)
    simulateKeyPress(Enum.KeyCode.X)
    simulateKeyPress(Enum.KeyCode.C)
    simulateKeyPress(Enum.KeyCode.V)
end
function getTools()
    local toolsName = {}
    for _, v in pairs(game:GetService("Players").LocalPlayer.StarterGear:GetChildren()) do
        if v:IsA('Tool') then
            table.insert(toolsName, v.Name);
        end
    end
    return toolsName
end
function teleportPlayersTo(pivotTo, model, cframe, x, y, z)
    if pivotTo then
        game.Players.LocalPlayer.Character:PivotTo(model:GetPivot())
    end
    if cframe then
        game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(x, y, z)
    end
end
function Refresh(dropdown, table)
    dropdown:ClearOptions()
    dropdown:InsertOptions(table)
end
function GetSize()
    if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
        return UDim2.fromOffset(600, 350)
    else
        return UDim2.fromOffset(830, 525)
    end
end



-- ui library
local MacLib = loadstring(game:HttpGet("https://github.com/biggaboy212/Maclib/releases/latest/download/maclib.txt"))()
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
		Default = true,
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
		Default = true,
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
	AutoFarm  = tabGroups.TabGroup1:Tab({ Name = "| Auto Farm", Image = "rbxassetid://10709811110" }),
    Stats = tabGroups.TabGroup1:Tab({ Name = "| Stats", Image = "rbxassetid://10734973130" }),
    Shop = tabGroups.TabGroup1:Tab({ Name = "| Shop", Image = "rbxassetid://10709770178" }),
    Quest = tabGroups.TabGroup1:Tab({ Name = "| Quest", Image = "rbxassetid://10734943448" }),
    RaidBoss = tabGroups.TabGroup1:Tab({ Name = "| Raid Boss", Image = "rbxassetid://10709761629" }),
    Misc = tabGroups.TabGroup1:Tab({ Name = "| Misc", Image = "rbxassetid://10723424505" }),
}
local sections = {
	AutoFarmSection1 = tabs.AutoFarm:Section({ Side = "Left" }),
    AutoFarmSection2 = tabs.AutoFarm:Section({ Side = "Right" }),
    AutoFarmSection3 = tabs.AutoFarm:Section({ Side = "Left" }),
    StatsSection1 = tabs.Stats:Section({ Side = "Left" }),
    StatsSection2 = tabs.Stats:Section({ Side = "Right" }),
    ShopSection1 = tabs.Shop:Section({ Side = "Left" }),
    ShopSection2 = tabs.Shop:Section({ Side = "Right" }),
    ShopSection3 = tabs.Shop:Section({ Side = "Left" }),
    ShopSection4 = tabs.Shop:Section({ Side = "Right" }),
    QuestSection1 = tabs.Quest:Section({ Side = "Left" }),
    RaidBossSection1 = tabs.RaidBoss:Section({ Side = "Left" }),
    RaidBossSection2 = tabs.RaidBoss:Section({ Side = "Right" }),
    RaidBossSection3 = tabs.RaidBoss:Section({ Side = "Left" }),
    RaidBossSection4 = tabs.RaidBoss:Section({ Side = "Right" }),
    MiscSection1 = tabs.Misc:Section({ Side = 'Left' }),
    MiscSection2 = tabs.Misc:Section({ Side = 'Right' })
}
tabs.AutoFarm:Select()



-- source
sections.AutoFarmSection1:Header({
	Name = "[🔝] Level Farm"
})
sections.AutoFarmSection2:Header({
	Name = "[⚙️] Farm Settings"
})
sections.AutoFarmSection3:Header({
	Name = "[📋] Stats"
})
_G.Skills = false
_G.Weapon = ''
_G.IgnoreBoss = false
sections.AutoFarmSection1:Toggle({
	Name = "Auto farm level",
	Default = false,
	Callback = function(bool)
        autoFarm = bool
        if autoFarm then
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon)
                end
            end
        else
            game:GetService("VirtualInputManager"):SendKeyEvent(true, 'Q', false, nil)
        end
        repeat task.wait()
             if autoFarm then
                for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                    if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                        for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                            if x.Name == 'Humanoid' then
                                x:EquipTool(weapon)
                            end
                        end
                    end
                end
                if player:FindFirstChild("PlayerData") and player.PlayerData:FindFirstChild("Level") then
                    local level = player.PlayerData.Level.Value

                    if level >= 1 and level <= 50 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 1')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Floppa' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Floppa', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 1')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 50 and level <= 100 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 2')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Golden Floppa' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Golden Floppa', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 2')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 100 and level <= 150 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 3')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Big Floppa' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Big Floppa', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 3')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 150 and level <= 200 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 4')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Doge' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Doge', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 4')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 200 and level <= 250 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 5')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Cheems' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Cheems', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 5')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 250 and level <= 300 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 6')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Walter Dog' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Walter Dog', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 6')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 300 and level <= 350 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 7')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Staring Fish' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Staring Fish', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 7')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 350 and level <= 400 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 8')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Hamster' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Hamster', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 8')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 400 and level <= 450 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 9')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Snow Tree' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Snow Tree', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 9')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 450 and level <= 500 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 10')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'The Rock' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('The Rock', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 10')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 500 and level <= 550 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 11')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Banana Cat' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Banana Cat', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 11')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 550 and level <= 600 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 12')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Sus Face' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Sus Face', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 12')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 600 and level <= 650 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 13')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Egg Dog' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Egg Dog', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 13')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 650 and level <= 700 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 14')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Popcat' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Popcat', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 14')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 700 and level <= 750 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 15')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Gorilla King' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Gorilla King', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 15')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 750 and level <= 800 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 16')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Smiling Cat' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Smiling Cat', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 16')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 800 and level <= 850 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 17')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Killerfish' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Killerfish', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 17')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 850 and level <= 900 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 18')
                         else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Bingus' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Bingus', 5.5)
                                        fireTool(_G.Weapon)
                                    end
                                        teleportToQuest('Floppa Quest 18')
                                    end
                                end
                            end
                        end
                    end
                    local level = player.PlayerData.Level.Value
                    if level >= 900 and level <= 950 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 19')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Obamid' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Obamid', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 19')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 950 and level <= 1000 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 20')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Floppy' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Floppy', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 20')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1000 and level <= 1050 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 21')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Creepy Head' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Creepy Head', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 21')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1050 and level <= 1150 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 22')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Scary Skull' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Scary Skull', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 22')
                                    end
                                end
                            end
                        end
                    end
                    if not _G.IgnoreBoss then
                        if level >= 1100 and level <= 1150 then
                            local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                            if currentQuest.Value == 0 then
                                for _, v in pairs(workspace.Island.PumpkinIsland:GetChildren()) do
                                    if v:IsA('Model') and v.Name == 'Summon1' then
                                        for _, x in pairs(v:GetDescendants()) do
                                            if x:IsA('ProximityPrompt') and x.Name == 'SummonPrompt' then
                                                fireproximityprompt(x);
                                            end
                                        end
                                    end
                                end
                                getQuest('Floppa Quest 23')
                            else
                                for _, v in pairs(workspace.Monster:GetChildren()) do
                                    if v:IsA('Model') and v.Name == 'Giant Pumpkin' then
                                        if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                            if _G.Skills then
                                                useSkills()
                                            end
                                            teleportMob('Giant Pumpkin', 5.5)
                                            fireTool(_G.Weapon)
                                        else
                                            teleportToQuest('Floppa Quest 23')
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1150 and level <= 1200 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 24')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Pink Absorber' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Pink Absorber', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 24')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1200 and level <= 1250 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 25')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Troll Face' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Troll Face', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 25')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1250 and level <= 1300 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 26')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Uncanny Cat' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Uncanny Cat', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 26')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1300 and level <= 1350 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 27')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                                if v:IsA('Model') and v.Name == 'Quandale Dingle' then
                                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                        if _G.Skills then
                                            useSkills()
                                        end
                                        teleportMob('Quandale Dingle', 5.5)
                                        fireTool(_G.Weapon)
                                    else
                                        teleportToQuest('Floppa Quest 27')
                                    end
                                end
                            end
                        end
                    end
                    if level >= 1350 and level <= 1450 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 28')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Moai' then
                                  if v.Humanoid and v.Humanoid.Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Moai', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 28')
                                  end
                              end
                            end
                        end
                    end
                    if not _G.IgnoreBoss then
                        if level >= 1400 and level <= 1450 then
                            local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                            if currentQuest.Value == 0 then
                                for _, v in pairs(workspace.Island.MoaiIsland:GetChildren()) do
                                    if v:IsA('Model') and v.Name == 'Summon2' then
                                        for _, x in pairs(v:GetDescendants()) do
                                            if x:IsA('ProximityPrompt') and x.Name == 'SummonPrompt' then
                                                fireproximityprompt(x);
                                            end
                                        end
                                    end
                                end
                                getQuest('Floppa Quest 29')
                            else
                                for _, v in pairs(workspace.Monster:GetChildren()) do
                                  if v:IsA('Model') and v.Name == 'Evil Noob' then
                                      if v.Humanoid and v.Humanoid.Health ~= 0 then
                                          if _G.Skills then
                                              useSkills()
                                          end
                                          teleportMob('Evil Noob', 5.5)
                                          fireTool(_G.Weapon)
                                      else
                                          teleportToQuest('Floppa Quest 29')
                                      end
                                  end
                                end
                            end
                        end
                    end
                    if level >= 1450 and level <= 1500 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 30')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Red Sus' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Red Sus', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 30')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 1500 and level <= 1700 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 31')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Sus Duck' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Sus Duck', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 31')
                                  end
                              end
                            end
                        end
                    end
                    if not _G.IgnoreBoss then
                        if level >= 1550 and level <= 1700 then
                            local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                            if currentQuest.Value == 0 then
                                getQuest('Floppa Quest 32')
                            else
                                for _, v in pairs(workspace.Monster:GetChildren()) do
                                  if v:IsA('Model') and v.Name == 'Lord Sus' then
                                      if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                          if _G.Skills then
                                              useSkills()
                                          end
                                          teleportMob('Lord Sus', 5.5)
                                          fireTool(_G.Weapon)
                                      else
                                          teleportToQuest('Floppa Quest 32')
                                      end
                                  end
                                end
                            end
                        end
                    end
                    if level >= 1700 and level <= 1750 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 33')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Sigma Man' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Sigma Man', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 33')
                                  end
                              end
                            end
    
                        end
                    end
                    if level >= 1750 and level <= 1800 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 34')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Dancing Cat' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Dancing Cat', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 34')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 1800 and level <= 1850 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 35')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Toothless Dragon' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Toothless Dragon', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 35')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 1850 and level <= 1900 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 36')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Manly Nugget' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Manly Nugget', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 36')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 1900 and level <= 1950 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 37')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Huh Cat' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Huh Cat', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 37')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 1950 and level <= 2000 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 38')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Mystical Tree' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Mystical Tree', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 38')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2000 and level <= 2050 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 39')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Old Man' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Old Man', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 39')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2050 and level <= 2100 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 40')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Nyan Cat' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Nyan Cat', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 40')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2100 and level <= 2150 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 41')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Baller' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Baller', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 41')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2150 and level <= 2200 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 42')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Slicer' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Slicer', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 42')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2200 and level <= 2250 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 43')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Rick Roller' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Rick Roller', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 43')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2250 and level <= 2300 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 44')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'Gigachad' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('Gigachad', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 44')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2300 and level <= 2350 then
                        local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                        if currentQuest.Value == 0 then
                            getQuest('Floppa Quest 45')
                        else
                            for _, v in pairs(workspace.Monster:GetChildren()) do
                              if v:IsA('Model') and v.Name == 'MrBeast' then
                                  if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                      if _G.Skills then
                                          useSkills()
                                      end
                                      teleportMob('MrBeast', 5.5)
                                      fireTool(_G.Weapon)
                                  else
                                      teleportToQuest('Floppa Quest 45')
                                  end
                              end
                            end
                        end
                    end
                    if level >= 2350 and level <= 2400 then
                     local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                     if currentQuest.Value == 0 then
                         getQuest('Floppa Quest 46')
                     else
                         for _, v in pairs(workspace.Monster:GetChildren()) do
                          if v:IsA('Model') and v.Name == 'Handsome Man' then
                              if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                                  if _G.Skills then
                                      useSkills()
                                  end
                                  teleportMob('Handsome Man', 5.5)
                                  fireTool(_G.Weapon)
                              else
                                  teleportToQuest('Floppa Quest 46')
                              end
                          end
                         end
                     end
                 end
             end
        until autoFarm == false
	end,
}, "Toggle")
sections.AutoFarmSection1:Button({
	Name = "Reset farm",
	Callback = function()
        local args = {
            [1] = "Abandon_Quest",
            [2] = {
                ["QuestSlot"] = "QuestSlot1"
            }
        }
        game:GetService("ReplicatedStorage"):WaitForChild("OtherEvent"):WaitForChild("QuestEvents"):WaitForChild("Quest"):FireServer(unpack(args))
	end,
})
local weapons = sections.AutoFarmSection2:Dropdown({
	Name = "Select weapon",
	Search = false,
	Multi = false,
	Required = false,
	Options = getTools(),
	Default = {"Combat"},
	Callback = function(Options)
        _G.Weapon = Options
	end,
}, "Dropdown")
sections.AutoFarmSection2:Toggle({
	Name = "Use skills",
	Default = false,
	Callback = function(bool)
        _G.Skills = bool
	end,
}, "Toggle")
sections.AutoFarmSection2:Toggle({
	Name = "Use instinct",
	Default = false,
	Callback = function(bool)
        instinct = bool
        while instinct do task.wait()
            local UserInputService = game:GetService("UserInputService")
            if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled then
                if game:GetService("Lighting").Instinct.TintColor == Color3.fromRGB(255, 255, 255) then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
                    wait(.5)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
                end
            elseif UserInputService.KeyboardEnabled then
                if game:GetService("Lighting").Instinct.TintColor == Color3.fromRGB(255, 255, 255) then
                    game:GetService('VirtualInputManager'):SendKeyEvent(true, 'E', false, game)
                    wait(.5)
                    game:GetService('VirtualInputManager'):SendKeyEvent(false, 'E', false, game)
                end
            end
        end
	end,
}, "Toggle")
sections.AutoFarmSection2:Toggle({
	Name = "Use aura",
	Default = false,
	Callback = function(bool)
        aura = bool
        while aura do task.wait()
            local auraFolder = game.Players.LocalPlayer.Character:WaitForChild('AuraColor_Folder')
            local auraFind = auraFolder:FindFirstChild('LeftHand_AuraColor')
            if not auraFind then
                game:GetService('VirtualInputManager'):SendKeyEvent(true, 'B', false, game)
                wait(.5)
                game:GetService('VirtualInputManager'):SendKeyEvent(false, 'B', false, game)
            end
        end
	end,
}, "Toggle")
sections.AutoFarmSection2:Toggle({
	Name = "Ignore raid bosses quest",
	Default = false,
	Callback = function(bool)
        _G.IgnoreBoss = bool
	end,
}, "Toggle")
local stats = sections.AutoFarmSection3:Paragraph({
    Header = 'Your stats',
    Body = 'nil'
})
local stats2 = sections.AutoFarmSection3:Paragraph({
    Header = '',
    Body = 'nil'
})
task.spawn(function()
    while true do task.wait()
        stats:UpdateBody(
            'Money: $'..game:GetService("Players").LocalPlayer.PlayerData.Money.Value.. "\nGem: "..game:GetService("Players").LocalPlayer.PlayerData.Gem.Value.."\nLevel: "..game:GetService("Players").LocalPlayer.PlayerData.Level.Value.."\nXp: "..game:GetService("Players").LocalPlayer.PlayerData.Exp.Value
        )
        stats2:UpdateBody(
            'Aura xp: '..game:GetService("Players").LocalPlayer.PlayerData.AuraExp.Value..'\nAura level: '..game:GetService("Players").LocalPlayer.PlayerData.AuraLevel.Value..'\nDodge xp: '..game:GetService("Players").LocalPlayer.PlayerData.DodgeExp.Value..'\nDodge level: '..game:GetService("Players").LocalPlayer.PlayerData.DodgeLevel.Value
        )
    end
end)


sections.StatsSection1:Header({
	Name = "[📈] Auto Set Points"
})
sections.StatsSection2:Header({
	Name = "[👁️] Points"
})
sections.StatsSection1:Toggle({
	Name = "Auto upgrade melee",
	Default = false,
	Callback = function(bool)
        autoMelee = bool
        while autoMelee do task.wait()
            upgradeStats('MeleeLevel', 1)
        end
	end,
}, "Toggle")
sections.StatsSection1:Toggle({
	Name = "Auto upgrade defense",
	Default = false,
	Callback = function(bool)
        autoMelee = bool
        while autoMelee do task.wait()
            upgradeStats('DefenseLevel', 1)
        end
	end,
}, "Toggle")
sections.StatsSection1:Toggle({
	Name = "Auto upgrade sword",
	Default = false,
	Callback = function(bool)
        autoMelee = bool
        while autoMelee do task.wait()
            upgradeStats('SwordLevel', 1)
        end
	end,
}, "Toggle")
sections.StatsSection1:Toggle({
	Name = "Auto upgrade power",
	Default = false,
	Callback = function(bool)
        autoMelee = bool
        while autoMelee do task.wait()
            upgradeStats('MemePowerLevel', 1)
        end
	end,
}, "Toggle")
local stats3 = sections.StatsSection2:Paragraph({
    Header = 'Your stats',
    Body = 'nil'
})
task.spawn(function()
    while true do task.wait()
        stats3:UpdateBody(
            'Melee: '..game:GetService("Players").LocalPlayer.PlayerData.MeleeLevel.Value..'\nDefense: '..game:GetService("Players").LocalPlayer.PlayerData.DefenseLevel.Value..'\nSword: '..game:GetService("Players").LocalPlayer.PlayerData.SwordLevel.Value..'\nPower: '..game:GetService("Players").LocalPlayer.PlayerData.MemePowerLevel.Value..'\nSkill points: '..game:GetService("Players").LocalPlayer.PlayerData.SkillPoint.Value
        )
    end
end)
sections.StatsSection2:Button({
	Name = "Refound stats [ 50 Gems ]",
	Callback = function()
        local args = {[1] = {["Action"] = "ResetStats"}}
        game:GetService("ReplicatedStorage"):WaitForChild("OtherEvent"):WaitForChild("MainEvents"):WaitForChild("StatsFunction"):InvokeServer(unpack(args))        
	end,
})


sections.ShopSection1:Header({
	Name = "[🏪] Gacha Shop"
})
sections.ShopSection2:Header({
	Name = "[👊] Fighting Style"
})
sections.ShopSection3:Header({
	Name = "[🏋️‍♂️] Ability Trainer"
})
sections.ShopSection4:Header({
	Name = "[⚔️] Sword"
})
sections.ShopSection1:Dropdown({
	Name = "Select pet",
	Search = false,
	Multi = false,
	Required = false,
	Options = {'Floppa Gacha', 'Doge Gacha'},
	Default = {""},
	Callback = function(Options)
        selectedPet = Options
	end,
}, "Dropdown")
sections.ShopSection1:Dropdown({
	Name = "Select amount",
	Search = false,
	Multi = false,
	Required = false,
	Options = {'Once', 'Triple', 'Decuple'},
	Default = {""},
	Callback = function(Options)
        selectedAmount = Options
	end,
}, "Dropdown")
sections.ShopSection1:Button({
	Name = "Buy",
	Callback = function()
        if selectedPet == 'Floppa Gacha' then
            local ohString1 = "Random_Power"
            local ohTable2 = {
                ["Type"] = selectedAmount,
                ["NPCName"] = "Floppa Gacha",
                ["GachaType"] = "Money"
            }
            game:GetService("ReplicatedStorage").OtherEvent.MainEvents.Modules:FireServer(ohString1, ohTable2)
        elseif selectedPet == 'Doge Gacha' then
            local ohString1 = "Random_Power"
            local ohTable2 = {
                ["Type"] = selectedAmount,
                ["NPCName"] = "Doge Gacha",
                ["GachaType"] = "Gem"
            }
            game:GetService("ReplicatedStorage").OtherEvent.MainEvents.Modules:FireServer(ohString1, ohTable2)
        end
	end,
})
sections.ShopSection2:Button({
	Name = "Buy combat",
	Callback = function()
        teleportPlayersTo(false, nil, true, 56, 3, -617)
	end,
})
sections.ShopSection2:Button({
	Name = "Buy baller",
	Callback = function()
        teleportPlayersTo(false, nil, true, 1713, -76, -4727)
	end,
})
sections.ShopSection3:Button({
	Name = "Buy obs haki",
	Callback = function()
        teleportPlayersTo(false, nil, true, 973, 44, -549)
	end,
})
sections.ShopSection3:Button({
	Name = "Buy aura",
	Callback = function()
        teleportPlayersTo(false, nil, true, 6962, 31, 4923)
	end,
})
sections.ShopSection3:Button({
	Name = "Buy flash step",
	Callback = function()
        teleportPlayersTo(false, nil, true, -3063, -79, -2065)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy pumpkin",
	Callback = function()
        teleportPlayersTo(false, nil, true, -982, -92, 1285)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy flame katana",
	Callback = function()
        teleportPlayersTo(false, nil, true, 114, -5, -1579)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy katana",
	Callback = function()
        teleportPlayersTo(false, nil, true, 383, -37, -852)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy hanger",
	Callback = function()
        teleportPlayersTo(false, nil, true, 208, 5, -1272)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy bonk",
	Callback = function()
        teleportPlayersTo(false, nil, true, 1673, -35, -5247)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy popcat",
	Callback = function()
        teleportPlayersTo(false, nil, true, 3494, 24, -1567)
	end,
})
sections.ShopSection4:Button({
	Name = "Buy banana",
	Callback = function()
        teleportPlayersTo(false, nil, true, -2893, -64, 349)
	end,
})


sections.QuestSection1:Header({
	Name = "[📜] Auto Quest"
})
sections.QuestSection1:Toggle({
	Name = "Cool Floppa Quest",
	Default = false,
	Callback = function(bool)
        autoCoolFloppa = bool
        if autoCoolFloppa then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(755, -30, -426)
        end
        repeat task.wait()
            if autoCoolFloppa then
                local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                if currentQuest.Value == 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(755, -30, -426)
                    for _, v in pairs(workspace.NPCs.Quests_Npc:GetChildren()) do
                        if v:IsA('Model') and v.Name == 'Cool Floppa Quest' then
                            for _, x in pairs(v:GetDescendants()) do
                                if x:IsA('ProximityPrompt') and x.Name == 'QuestPrompt' then
                                    fireproximityprompt(x)
                                end
                            end
                        end
                    end
                else
                    for _, v in pairs(workspace.Island.FloppaIsland:GetChildren()) do
                        if v:IsA('Model') and v.Name == 'Lava Floppa' then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.ClickPart.CFrame
                            for _, x in pairs(v:GetDescendants()) do
                                if x:IsA('ProximityPrompt') and x.Name == 'ProximityPrompt' then
                                    fireproximityprompt(x)
                                end
                            end
                        end
                    end
                end
            end
        until autoCoolFloppa == false
	end,
}, "Toggle")
sections.QuestSection1:Toggle({
	Name = "Dancing Banana Quest",
	Default = false,
	Callback = function(bool)
        dancingBanana = bool
        if dancingBanana then
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon)
                end
            end
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2623, -77, -2005)
        end
        repeat task.wait()
            if dancingBanana then
                for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                    if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                        for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                            if x.Name == 'Humanoid' then
                                x:EquipTool(weapon)
                            end
                        end
                    end
                end
                local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                if currentQuest.Value == 0 then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-2623, -77, -2005)
                    for _, v in pairs(workspace.NPCs.Quests_Npc:GetChildren()) do
                        if v:IsA('Model') and v.Name == 'Dancing Banana Quest' then
                            for _, x in pairs(v:GetDescendants()) do
                                if x:IsA('ProximityPrompt') and x.Name == 'QuestPrompt' then
                                    fireproximityprompt(x)
                                end
                            end
                        end
                    end
                else
                    if _G.Skills then
                        useSkills()
                    end
                    teleportMob('Sogga', 5.5)
                    fireTool(_G.Weapon)
                end
            end
        until dancingBanana == false
	end,
}, "Toggle")


sections.RaidBossSection1:Header({
	Name = "[🎃] Giant Pumpkin"
})
sections.RaidBossSection2:Header({
	Name = "[🦹] Evil Noob"
})
sections.RaidBossSection3:Header({
	Name = "[👨‍🚀] Lord Sus"
})
sections.RaidBossSection4:Header({
	Name = "[👺] Meme Beast"
})
sections.RaidBossSection1:Toggle({
	Name = "Auto farm",
	Default = false,
	Callback = function(bool)
        giantPumpkin = bool
        if giantPumpkin then
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon)
                end
            end
        end
        while giantPumpkin do task.wait()
            local backpack = game.Players.LocalPlayer.Backpack
            local character = game.Players.LocalPlayer.Character
            local tool = backpack:FindFirstChild(_G.Weapon)
            local ctool = character:FindFirstChild(_G.Weapon)
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') then
                    for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if x.Name == 'Humanoid' then
                            if not tool and not ctool then
                                x.Health = 0
                            else
                                x:EquipTool(tool)
                            end
                        end
                    end
                end
            end
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                    for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if x.Name == 'Humanoid' then
                            x:EquipTool(weapon)
                        end
                    end
                end
            end
            if _G.Skills then
                useSkills()
            end
            teleportMob('Giant Pumpkin', 5.5)
            fireTool(_G.Weapon)
        end
	end,
}, "Toggle")
sections.RaidBossSection1:Toggle({
	Name = "Auto spawn",
	Default = false,
	Callback = function(bool)
        giantPumpkinSpawn = bool
        repeat task.wait()
            local mob = workspace.Monster:findFirstChild('Giant Pumpkin')
            if not mob then
                local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
                if currentQuest.Value == 0 then
                    teleportPlayersTo(false, nil, true, -1181, -93, 1459)
                    for _, v in pairs(workspace.Island.PumpkinIsland:GetChildren()) do
                        if v:IsA('Model') and v.Name == 'Summon1' then
                            for _, x in pairs(v:GetDescendants()) do
                                if x:IsA('ProximityPrompt') and x.Name == 'SummonPrompt' then
                                    fireproximityprompt(x);
                                end
                            end
                        end
                    end
                    wait(.2)
                    getQuest('Floppa Quest 23')
                end
            end
        until giantPumpkinSpawn == false
	end,
}, "Toggle")
sections.RaidBossSection2:Toggle({
	Name = "Auto farm",
	Default = false,
	Callback = function(bool)
        evilNoob = bool
        if evilNoob then
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon)
                end
            end
        end
        while evilNoob do task.wait()
            local currentQuest = game:GetService("Players").LocalPlayer.PlayerData.CurrentQuest
            if currentQuest.Value == 0 then
                getQuest('Floppa Quest 29')
            else
                for _, v in pairs(workspace.Monster:GetChildren()) do
                    if v:IsA('Model') and v.Name == 'Evil Noob' then
                        if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                            local backpack = game.Players.LocalPlayer.Backpack
                            local character = game.Players.LocalPlayer.Character
                            local tool = backpack:FindFirstChild(_G.Weapon)
                            local ctool = character:FindFirstChild(_G.Weapon)
                            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                if weapon:IsA('Tool') then
                                    for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                        if x.Name == 'Humanoid' then
                                            if not tool and not ctool then
                                                x.Health = 0
                                            else
                                                x:EquipTool(tool)
                                            end
                                        end
                                    end
                                end
                            end
                            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                                    for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                        if x.Name == 'Humanoid' then
                                            x:EquipTool(weapon)
                                        end
                                    end
                                end
                            end
                            if _G.Skills then
                                useSkills()
                            end
                            teleportMob('Evil Noob', 5.5)
                            fireTool(_G.Weapon)
                        else
                            teleportToQuest('Floppa Quest 29')
                        end
                    end
                end
            end
        end
	end,
}, "Toggle")
sections.RaidBossSection2:Toggle({
	Name = "Auto spawn",
	Default = false,
	Callback = function(bool)
        evilNoobSpawn = bool
        repeat task.wait()
            local mob = workspace.Monster:findFirstChild('Evil Noob')
            if not mob then
                teleportPlayersTo(false, nil, true, -2357, -81, 3176)
                for _, v in pairs(workspace.Island.MoaiIsland:GetChildren()) do
                    if v:IsA('Model') and v.Name == 'Summon2' then
                        for _, x in pairs(v:GetDescendants()) do
                            if x:IsA('ProximityPrompt') and x.Name == 'SummonPrompt' then
                                fireproximityprompt(x);
                            end
                        end
                    end
                end
            end
        until evilNoobSpawn == false
	end,
}, "Toggle")
sections.RaidBossSection3:Toggle({
	Name = "Auto farm",
	Default = false,
	Callback = function(bool)
        lordSus = bool
        if lordSus then
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                    game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon)
                end
            end
        end
        while lordSus do task.wait()
            for _, v in pairs(workspace.Monster:GetChildren()) do
                if v:IsA('Model') and v.Name == 'Lord Sus' then
                    if v:FindFirstChild('Humanoid') and v:FindFirstChild('Humanoid').Health ~= 0 then
                        local backpack = game.Players.LocalPlayer.Backpack
                        local character = game.Players.LocalPlayer.Character
                        local tool = backpack:FindFirstChild(_G.Weapon)
                        local ctool = character:FindFirstChild(_G.Weapon)
                        for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                            if weapon:IsA('Tool') then
                                for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                    if x.Name == 'Humanoid' then
                                        if not tool and not ctool then
                                            x.Health = 0
                                        else
                                            x:EquipTool(tool)
                                        end
                                    end
                                end
                            end
                        end
                        for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                            if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                                for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                    if x.Name == 'Humanoid' then
                                        x:EquipTool(weapon)
                                    end
                                end
                            end
                        end
                        if _G.Skills then
                            useSkills()
                        end
                        teleportMob('Lord Sus', 5.5)
                        fireTool(_G.Weapon)
                    else
                        teleportToQuest('Floppa Quest 32')
                    end
                end
            end
        end
	end,
}, "Toggle")
sections.RaidBossSection3:Toggle({
	Name = "Auto spawn",
	Default = false,
	Callback = function(bool)
        lordSusSpawn = bool
        repeat task.wait()
            local mob = workspace.Monster:findFirstChild('Lord Sus')
            if not mob then
                teleportPlayersTo(false, nil, true, 6639, -95, 4812)
                for _, v in pairs(workspace.Island.ForgottenIsland:GetChildren()) do
                    if v:IsA('Model') and v.Name == 'Summon3' then
                        for _, x in pairs(v:GetDescendants()) do
                            if x:IsA('ProximityPrompt') and x.Name == 'SummonPrompt' then
                                fireproximityprompt(x);
                            end
                        end
                    end
                end
            end
        until lordSusSpawn == false
	end,
}, "Toggle")
sections.RaidBossSection4:Toggle({
	Name = "Auto farm",
	Default = false,
	Callback = function(bool)
        memeBeast = bool
        if memeBeast then
           for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
               if weapon:IsA('Tool') and weapon.Name == _G.Weapon then
                   game.Players.LocalPlayer.Character.Humanoid:EquipTool(weapon)
               end
           end
        end
        while memeBeast do task.wait()
            local backpack = game.Players.LocalPlayer.Backpack
            local character = game.Players.LocalPlayer.Character
            local tool = backpack:FindFirstChild(_G.Weapon)
            local ctool = character:FindFirstChild(_G.Weapon)
            for _, weapon in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
                if weapon:IsA('Tool') then
                    for _, x in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                        if x.Name == 'Humanoid' then
                            if not tool and not ctool then
                                x.Health = 0
                            else
                                x:EquipTool(tool)
                            end
                        end
                    end
                end
            end
            if _G.Skills then
                useSkills()
            end
            teleportMob('Meme Beast', 5.5)
            fireTool(_G.Weapon)
        end
	end,
}, "Toggle")


sections.MiscSection1:Header({
	Name = "[➕] Misc Options"
})
sections.MiscSection2:Header({
	Name = "[🏯] Raid"
})
sections.MiscSection2:Toggle({
	Name = "Auto start raid",
	Default = false,
	Callback = function(bool)
        startRaid = bool
        while startRaid do task.wait()
            local args = {
                "Start"
            }
            game:GetService("ReplicatedStorage"):WaitForChild("OtherEvent"):WaitForChild("MiscEvents"):WaitForChild("StartRaid"):FireServer(unpack(args))            
        end
	end,
}, "Toggle")
sections.MiscSection2:Toggle({
	Name = "Auto farm mobs",
	Default = false,
	Callback = function(bool)
        raidMobs = bool
        while raidMobs do task.wait()
            local closest = nil
            local shortestDistance = math.huge
            local player = game:GetService("Players").LocalPlayer
            local character = player.Character or player.CharacterAdded:Wait()
            local hrp = character:FindFirstChild("HumanoidRootPart")

            if hrp then
                for _, mob in pairs(workspace.Monster:GetChildren()) do
                    local head = mob:FindFirstChild("Head")
                    local humanoid = mob:FindFirstChild("Humanoid")

                    if head and humanoid and humanoid.Health > 0 then
                        local dist = (head.Position - hrp.Position).Magnitude
                        if dist < shortestDistance then
                            shortestDistance = dist
                            closest = mob
                        end
                    end
                end

                if closest then
                    local head = closest:FindFirstChild("Head")
                    if head then
                        local tpPos = head.Position + Vector3.new(0, 5, 0)
                        hrp.CFrame = CFrame.new(tpPos) * CFrame.Angles(math.rad(270), 0, 0)
                    end
                else
                    game.Players.LocalPlayer.Character:WaitForChild('HumanoidRootPart').CFrame = CFrame.new(-19421, 56, -22499)
                end
            end
        end
	end,
}, "Toggle")
sections.MiscSection1:Button({
	Name = "Reedem all codes",
	Callback = function()
        local codes = { "100MVisits", "100KLikes", "100KFavorites", "100KActive", "70KActive", "40KActive", "20KActive", "10KActive", "10KMembers", "Update4", "4KActive", "10KLikes", "10MVisits", "9MVisits" }
        for _, v in next, codes do  
            local args = {
                [1] = v
            }
            game:GetService("ReplicatedStorage"):WaitForChild("OtherEvent"):WaitForChild("MainEvents"):WaitForChild("Code"):InvokeServer(unpack(args))
        end
	end,
})
sections.MiscSection2:Button({
	Name = "Teleport to raid",
	Callback = function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Region.RaidArea.CFrame
	end,
})



-- auto update list
game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function()
    Refresh(weapons, getTools())
end)
game.Players.LocalPlayer.Backpack.ChildRemoved:Connect(function()
    Refresh(weapons, getTools())
end)



warn('InfinityX - [ LOADED ]')
