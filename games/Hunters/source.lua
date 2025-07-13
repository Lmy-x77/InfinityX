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
    AutoFarm  = tabGroups.TabGroup1:Tab({
        Name = "| Farm",
        Image = "rbxassetid://10709811110"
    }),
}
local sections = {
    AutoFarmSection1 = tabs.AutoFarm:Section({
        Side = "Left"
    }),
    AutoFarmSection2 = tabs.AutoFarm:Section({
        Side = "Right"
    }),
}
tabs.AutoFarm:Select()



-- source
sections.AutoFarmSection1:Header({
	Name = "[🔁] Roll"
})
sections.AutoFarmSection2:Header({
	Name = "[🏰] Doungeon"
})
sections.AutoFarmSection1:Toggle({
	Name = "Auto roll",
	Default = false,
	Callback = function(bool)
        roll = bool
        while roll do task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Roll"):InvokeServer()
        end
	end,
}, "Toggle")
sections.AutoFarmSection1:Toggle({
	Name = "Auto 100x roll",
	Default = false,
	Callback = function(bool)
        rollTwo = bool
        while rollTwo do task.wait()
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("x100Roll"):InvokeServer()
        end
	end,
}, "Toggle")
sections.AutoFarmSection1:Divider()
local stats = sections.AutoFarmSection1:Paragraph({
    Header = "Spins you've made",
    Body = 'nil'
})
local player = game:GetService("Players").LocalPlayer
local rollValue = player.leaderstats:WaitForChild("Rolls")
local changeCount = 0
rollValue:GetPropertyChangedSignal("Value"):Connect(function()
	changeCount += 1
    stats:UpdateBody(
        'Spins: '..changeCount
    )
end)


sections.AutoFarmSection2:Dropdown({
	Name = "Select doungeon",
	Search = false,
	Multi = false,
	Required = false,
	Options = {'DoubleDungeonD', 'GoblinCave', 'SpiderCavern', 'EnchantedCourtyard'},
	Default = {""},
	Callback = function(Options)
        lobby = Options
	end,
}, "Dropdown")
sections.AutoFarmSection2:Dropdown({
	Name = "Select difficulty",
	Search = false,
	Multi = false,
	Required = false,
	Options = {'Regular', 'Hard', 'Nightmare'},
	Default = {""},
	Callback = function(Options)
        difficulty = Options
	end,
}, "Dropdown")
sections.AutoFarmSection2:Button({
	Name = "Create lobby",
	Callback = function()
        if difficulty == 'Regular' then
            local args = {
                lobby
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("createLobby"):InvokeServer(unpack(args))
        else
            local args = {
                lobby
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("createLobby"):InvokeServer(unpack(args))
            wait(0.2)
            local args = {
                difficulty
            }
            game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyDifficulty"):FireServer(unpack(args))
        end
	end,
})
sections.AutoFarmSection2:Button({
	Name = "Start doungeon",
	Callback = function()
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("LobbyStart"):FireServer()
	end,
})
sections.AutoFarmSection2:Divider()
sections.AutoFarmSection2:Toggle({
	Name = "Farm mobs",
	Default = false,
	Callback = function(bool)
        farmMobs = bool
        while farmMobs do task.wait()
            for _, v in pairs(workspace.Mobs:GetChildren()) do
                if v:IsA('Model') then
                    if v:FindFirstChild('HumanoidRootPart') then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = v.HumanoidRootPart.CFrame * CFrame.new(0, 5.5, 0) * CFrame.Angles(math.rad(270), 0, 0)
                        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Combat"):FireServer()

                    end
                end
            end
        end
	end,
}, "Toggle")
sections.AutoFarmSection2:Toggle({
	Name = "Kill aura",
	Default = false,
	Callback = function(bool)
        mobs = bool
        while mobs do task.wait()
            local findMobs = workspace.Mobs
            for _, v in pairs(findMobs:GetChildren()) do
                if v:IsA('Model') then
                    if v:FindFirstChild('Head') and v:FindFirstChild('Humanoid') then
                        v.Humanoid.Health = 0
                        wait(0.5)
                        v.Head:Destroy()
                    end
                end
            end
        end
	end,
}, "Toggle")
