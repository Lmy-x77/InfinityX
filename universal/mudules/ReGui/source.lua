-- universal ui librarys
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/universal/intro.lua",true))() wait(1)
local SafeGuard = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/source.lua'))()
local RemoteTracker = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Remote-Tracker/source.lua'))()


-- ui library
local ReGui = loadstring(game:HttpGet('https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua'))()
ReGui:DefineTheme("InfinityX", {
	TitleAlign = Enum.TextXAlignment.Center,
	TextDisabled = Color3.fromRGB(120, 120, 120),
	Text = Color3.fromRGB(200, 200, 200),
	FrameBg = Color3.fromRGB(30, 30, 30),
	FrameBgTransparency = 0.4,
	FrameBgActive = Color3.fromRGB(70, 70, 70),
	FrameBgTransparencyActive = 0.4,
	WindowBg = Color3.fromRGB(40, 40, 40),
	TitleBarBg = Color3.fromRGB(60, 60, 60),
	TitleBarBgActive = Color3.fromRGB(75, 75, 75),
	Border = Color3.fromRGB(70, 70, 70),
	ResizeGrab = Color3.fromRGB(70, 70, 70),
	RegionBgTransparency = 1,
	CheckMark = Color3.fromRGB(160, 160, 160),
	SliderGrab = Color3.fromRGB(160, 160, 160),
	ButtonsBg = Color3.fromRGB(160, 160, 160),
	CollapsingHeaderBg = Color3.fromRGB(160, 160, 160),
	CollapsingHeaderText = Color3.fromRGB(220, 220, 220),
	RadioButtonHoveredBg = Color3.fromRGB(160, 160, 160),
	TabBg = Color3.fromRGB(45, 45, 45),
	TabBgActive = Color3.fromRGB(95, 95, 95),
	TabBgHovered = Color3.fromRGB(85, 85, 85),
	TabText = Color3.fromRGB(210, 210, 210),
	TabTextActive = Color3.fromRGB(240, 240, 240),
	TabBorder = Color3.fromRGB(80, 80, 80)
})
local Window = ReGui:TabsWindow({
	Title = "Safe Guard",
	Theme = "InfinityX",
	NoClose = false,
	Size = UDim2.new(0, 280, 0, 350),
  NoCollapse = true,
  NoResize = true,
}):Center()


-- tabs
local tabs = {
  Main = Window:CreateTab({Name = 'Main'}),
	Review = Window:CreateTab({Name = 'Review'}),
}


-- source
tabs.Main:Separator({Text="Safe-Guard Options"})
tabs.Main:Checkbox({
	Value = false,
	Label = "Anti-Kick",
	Callback = function(self, Value: boolean)
		if not Value then return end
    SafeGuard:Hook({
      AntiKick = Value;
      AntiBan = false;
      AntiHttpSpy = false;
      AntiFling = false;
      WalkSpeedBypass = false;
      JumpPowerBypass = false;

      BlockRemote = {
        Enabled = false;
        Name = {''}
      }
    })
	end
})
tabs.Main:Checkbox({
	Value = false,
	Label = "Anti-Ban",
	Callback = function(self, Value: boolean)
		if not Value then return end
		SafeGuard:Hook({
      AntiKick = false;
      AntiBan = Value;
      AntiHttpSpy = false;
      AntiFling = false;
      WalkSpeedBypass = false;
      JumpPowerBypass = false;

      BlockRemote = {
        Enabled = false;
        Name = {''}
      }
    })
	end
})
tabs.Main:Checkbox({
	Value = false,
	Label = "Anti-HttpSpy",
	Callback = function(self, Value: boolean)
		if not Value then return end
		SafeGuard:Hook({
      AntiKick = false;
      AntiBan = false;
      AntiHttpSpy = Value;
      AntiFling = false;
      WalkSpeedBypass = false;
      JumpPowerBypass = false;

      BlockRemote = {
        Enabled = false;
        Name = {''}
      }
    })
	end
})
tabs.Main:Checkbox({
	Value = false,
	Label = "Anti-Fling",
	Callback = function(self, Value: boolean)
		if not Value then return end
		SafeGuard:Hook({
      AntiKick = false;
      AntiBan = false;
      AntiHttpSpy = false;
      AntiFling = Value;
      WalkSpeedBypass = false;
      JumpPowerBypass = false;

      BlockRemote = {
        Enabled = false;
        Name = {''}
      }
    })
	end
})
tabs.Main:Checkbox({
	Value = false,
	Label = "WalkSpeed-Bypass",
	Callback = function(self, Value: boolean)
		if not Value then return end
		SafeGuard:Hook({
      AntiKick = false;
      AntiBan = false;
      AntiHttpSpy = false;
      AntiFling = false;
      WalkSpeedBypass = Value;
      JumpPowerBypass = false;

      BlockRemote = {
        Enabled = false;
        Name = {''}
      }
    })
	end
})
tabs.Main:Checkbox({
	Value = false,
	Label = "JumpPower-Bypass",
	Callback = function(self, Value: boolean)
		if not Value then return end
		SafeGuard:Hook({
      AntiKick = false;
      AntiBan = false;
      AntiHttpSpy = false;
      AntiFling = false;
      WalkSpeedBypass = false;
      JumpPowerBypass = Value;

      BlockRemote = {
        Enabled = false;
        Name = {''}
      }
    })
	end
})
tabs.Main:Separator({Text="Block Remote [ OPTIONAL ]"})
tabs.Main:Checkbox({
	Value = false,
	Label = "Enabled",
	Callback = function(self, Value: boolean)
		BlockRemoteEnbled = Value
	end
})
tabs.Main:InputText({
	Label = "Path",
	Value = '',
	Placeholder = 'enter a remote path',
	Callback = function(Value)
    local ok, result = pcall(function()
      return loadstring("return " .. Value)()
    end)

    if ok and typeof(result) == "Instance" then
      SelectedRemote = result:GetFullName()
    end
	end
})
tabs.Main:Button({
	Text = " Block remote ",
	Callback = function()
    SafeGuard:Hook({
      AntiKick = false;
      AntiBan = false;
      AntiHttpSpy = false;
      AntiFling = false;
      WalkSpeedBypass = false;
      JumpPowerBypass = false;

      BlockRemote = {
        Enabled = BlockRemoteEnbled;
        Name = {SelectedRemote}
      }
    })
	end
})
tabs.Review:Label({
	Text = "-		  Safe-Guard - v1.5 		-",
	Bold = true
})
tabs.Review:Label({
	Text = "",
})
tabs.Review:Label({
	Text = "🛡️ AntiKick — blocks kicks\n🚫 AntiBan — blocks bans\n🔍 AntiHttpSpy — hides HTTP\n🌀 AntiFling — prevents flings\n🏃 WS Bypass — enforces speed\n🦘 JP Bypass — enforces jump\n🔒 BlockRemote — filters remotes"
})
tabs.Review:Label({
	Text = "",
})
tabs.Review:Label({
	Text = "Just to remind you, some sections are\nsntill under development, so they may\nnotwork. Also, functions like AntiKick\nonly block client kicks not server kicks.",
	Bold = true,
})





-- window2
local Window = ReGui:TabsWindow({
	Title = "Remote Tracker",
	Theme = "InfinityX",
	NoClose = false,
	Size = UDim2.new(0, 280, 0, 350),
  NoCollapse = true,
  NoResize = true,
}):Center()


-- tabs
local tabs = {
  Main = Window:CreateTab({Name = 'Main'}),
	Review = Window:CreateTab({Name = 'Review'}),
}


-- source
tabs.Main:Separator({Text="Remote-Tracker Options"})
tabs.Main:InputText({
	Label = "Path",
	Value = '',
	Placeholder = 'enter a remote path',
	Callback = function(Value)
    local ok, result = pcall(function()
      return loadstring("return " .. Value)()
    end)

    if ok and typeof(result) == "Instance" then
      SelectedRemote = result:GetFullName()
    end
	end
})
tabs.Main:InputText({
	Label = "Type",
	Value = '',
	Placeholder = 'RemoteEvent or RemoteFunction',
	Callback = function(Value)
		SelectedType = Value
	end
})
tabs.Main:Button({
	Text = " Block remote ",
	Callback = function()
    RemoteTracker:Hook({
      Path = SelectedRemote,
      Type = tostring(SelectedType)
    })
	end
})
tabs.Main:Separator({Text="Specific Arguments"})
tabs.Main:Checkbox({
	Value = false,
	Label = "Enabled",
	Callback = function(self, Value: boolean)

	end
})
tabs.Main:Combo({
	Label = "Number",
	Selected = "",
	Items = {},
})
tabs.Main:Combo({
	Label = "String",
	Selected = "",
	Items = {},
})
tabs.Main:Combo({
	Label = "Instance",
	Selected = "",
	Items = {},
})
tabs.Main:InputText({
	Label = "Enter",
	Value = '',
	Placeholder = 'enter the options you want to add to selected dropdown',
	Callback = function(Value)

	end
})
tabs.Main:Combo({
	Label = "Add options",
	Selected = "",
	Items = {'NumberDropdown', 'StringDropdown', 'InstanceDropdown'},
})
tabs.Main:Button({
	Text = " Add option ",
	Callback = function()

	end
})
tabs.Main:Button({
	Text = " Clear dropdown ",
	Callback = function()

	end
})
