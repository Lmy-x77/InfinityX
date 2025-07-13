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
local ls1 = game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript
local ls2 = game:GetService("Players").LocalPlayer.PlayerScripts.LocalScript2
local tower = workspace:FindFirstChild('tower')
local tweenPart = tower.sections.finish.start
local senv = getsenv(ls1)
local func = senv.kick
local function disconnectAll(signal)
	for _, conn in ipairs(getconnections(signal)) do
		conn:Disconnect()
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
	AutoFarm  = tabGroups.TabGroup1:Tab({ Name = "| Game", Image = "rbxassetid://10723424505" }),
}
local sections = {
	GameSection1 = tabs.AutoFarm:Section({ Side = "Left" }),
    GameSection2 = tabs.AutoFarm:Section({ Side = "Right" }),
}
tabs.AutoFarm:Select()



-- source
sections.GameSection1:Header({
	Name = "[🗼] Tower"
})
sections.GameSection2:Header({
	Name = "[🏃] Player"
})
sections.GameSection1:Button({
	Name = "Finish tower",
	Callback = function()
        if game.PlaceId == 1962086868 then
            game:GetService("TweenService"):Create(
                game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
                TweenInfo.new(25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
            ):Play() wait(25.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
        elseif game.PlaceId == 3582763398 then
            game:GetService("TweenService"):Create(
                game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
                TweenInfo.new(35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
            ):Play() wait(35.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
        end
	end,
})
sections.GameSection1:Button({
	Name = "Finish tower + rejoin",
	Callback = function()
        if game.PlaceId == 1962086868 then
            game:GetService("TweenService"):Create(
                game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
                TweenInfo.new(25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
            ):Play() wait(25.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
            wait(1.5)
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer
            )
        elseif game.PlaceId == 3582763398 then
            game:GetService("TweenService"):Create(
                game.Players.LocalPlayer.Character:WaitForChild("HumanoidRootPart"),
                TweenInfo.new(35, Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
                {Position = tweenPart.Position + Vector3.new(0, 10, 0)}
            ):Play() wait(35.2) game.Players.LocalPlayer.Character.Humanoid.Health = 0
            wait(1.5)
            game:GetService("TeleportService"):TeleportToPlaceInstance(
                game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer
            )
        end
	end,
})
sections.GameSection1:Divider()
sections.GameSection1:Paragraph({
    Header = "WARING",
    Body = "The finish tower is working, but be careful, after several tests even taking time to get kicked or banned the code is still not 100% secure, so use with moderation.\n\n(I recommend using it on a private server, but still be careful when using it)"
}, "Paragraph")
sections.GameSection2:Toggle({
	Name = "God mode",
	Default = false,
	Callback = function(bool)
        gm = bool
        while gm do task.wait()
            game:GetService("ReplicatedStorage").GameValues.killbricksDisabled.Value = gm
        end
	end,
}, "Toggle")
sections.GameSection2:Button({
	Name = "Get all tools",
	Callback = function()
        for _, v in pairs(game:GetService("ReplicatedStorage").Assets.Gear:GetChildren()) do
            if v:IsA('Tool') then
                local tclone = v:Clone()
                tclone.Parent = game.Players.LocalPlayer.Backpack
            end
        end
	end,
})
sections.GameSection2:Button({
	Name = "Rejoin",
	Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(
            game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer
        )
	end,
})
sections.GameSection2:Input({
	Name = "Walkspeed",
	Placeholder = "16",
	AcceptedCharacters = "Numeric",
	Callback = function(input)
		game:GetService("ReplicatedStorage").globalSpeed.Value = input
	end,
}, "TargetInput")
sections.GameSection2:Input({
	Name = "Extra jumps",
	Placeholder = "1",
	AcceptedCharacters = "Numeric",
	Callback = function(input)
		game:GetService("ReplicatedStorage").globalJumps.Value = input
	end,
}, "TargetInput")



-- execute bypass
if not hookfunction and getconnections and getsenv  then
    Window:Dialog({
        Title = "WARING",
        Description = "We have detected that the executor you are using is not able to support all the functions needed to bypass AntiCheater. You can use the script normally, but some functions such as “Get All Tools” are kicked.",
        Buttons = {
            {
                Name = "Confirm",
                Callback = function()
                    print("Confirmed!")
                end,
            },
            {
                Name = "Cancel"
            }
        }
    })
else
    disconnectAll(ls2.Changed)
    hookfunction(func, function(...)
        return nil
    end)
    for _, conn in pairs(getconnections(ls1.Changed)) do
        conn:Disable()
    end


    task.spawn(function() while true do task.wait() ls1.Disabled = true ls2.Disabled = true end end)

    warn('[ InfinityX ] - Loaded!')
    warn('[ InfinityX ] - Scripts and kick functions has been canceled, enjoy!')
end
