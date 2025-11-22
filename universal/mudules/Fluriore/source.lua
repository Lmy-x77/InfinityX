-- universal ui librarys
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/universal/mudules/Fluriore/intro.lua",true))() wait(.8)
local SafeGuard = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/source.lua'))()
local RemoteTracker = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Remote-Tracker/source.lua'))()


-- ui library
local NebulaIcons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))()
local FlurioreLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Fluriore/source.lua"))()
local FlurioreGui = FlurioreLib:MakeGui({
  ["NameHub"] = "InfinityX - v4.2a -",
  ["Description"] = "by lmy77 ㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤㅤ",
  ["Color"] = Color3.new(0.600000, 0.000000, 1.000000),
  ["Logo Player"] = "https://www.roblox.com/headshot-thumbnail/image?userId="..game:GetService("Players").LocalPlayer.UserId .."&width=420&height=420&format=png",
  ["Name Player"] = tostring(game:GetService("Players").LocalPlayer.Name),
  ["Tab Width"] = 140
})


-- tabs
local tabs = {
  SafeGuard = FlurioreGui:CreateTab({
    ["Name"] = "Safe-Guard",
    ["Icon"] = "rbxassetid://"..NebulaIcons:GetIcon("shield-check", "Lucide")
  }),
  RemoteTracker = FlurioreGui:CreateTab({
    ["Name"] = "Remote-Tracker",
    ["Icon"] = "rbxassetid://"..NebulaIcons:GetIcon("strikethrough", "Lucide")
  }),
}


-- source
local SafeGuardSections = {
  Section1 = tabs.SafeGuard:AddSection("SafeGuard Options"),
  Section2 = tabs.SafeGuard:AddSection("Optional - Block Remotes")
}
local Toggle = SafeGuardSections.Section1:AddToggle({
  ["Title"]= "Anti-Kick",
  ["Content"] = "prevent server kicks",
  ["Default"] = false,
  ["Callback"] = function(Value) 
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
local Toggle = SafeGuardSections.Section1:AddToggle({
  ["Title"]= "Anti-Ban",
  ["Content"] = "block ban attempts via remotes",
  ["Default"] = false,
  ["Callback"] = function(Value)  
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
local Toggle = SafeGuardSections.Section1:AddToggle({
  ["Title"]= "Anti-HttpSpy",
  ["Content"] = "stop HTTP spying hooks",
  ["Default"] = false,
  ["Callback"] = function(Value) 
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
local Toggle = SafeGuardSections.Section1:AddToggle({
  ["Title"]= "Anti-Fling",
  ["Content"] = "prevent forced flings / physics abuse",
  ["Default"] = false,
  ["Callback"] = function(Value) 
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
local Toggle = SafeGuardSections.Section1:AddToggle({
  ["Title"]= "WalkSpeed-Bypass",
  ["Content"] = "make walk speed changes persist while avoiding detection",
  ["Default"] = false,
  ["Callback"] = function(Value)
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
local Toggle = SafeGuardSections.Section1:AddToggle({
  ["Title"]= "JumpPower-Bypass",
  ["Content"] = "make jump power changes persist while avoiding detection",
  ["Default"] = false,
  ["Callback"] = function(Value) 
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
local Toggle = SafeGuardSections.Section2:AddToggle({
  ["Title"]= "Enabled",
  ["Content"] = "enable block remote funtion",
  ["Default"] = false,
  ["Callback"] = function(Value) 
    BlockRemoteEnbled = Value
  end
})
local Input = SafeGuardSections.Section2:AddInput({
  Title = "Add path",
  Content = "add path of remote you want to block",
  Callback = function(Value)
    local ok, result = pcall(function()
        return loadstring("return " .. Value)()
    end)

    if ok and typeof(result) == "Instance" then
      SelectedRemote = result:GetFullName()
    else
      print("Fatal error")
    end
  end
})
local Button = SafeGuardSections.Section2:AddButton({
  ["Title"] = "Block remote",
  ["Content"] = "optionally block listed RemoteEvents / RemoteFunctions",
  ["Callback"] = function()
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

local RemoteTrackerSections = {
  Section1 = tabs.RemoteTracker:AddSection("RemoteTracker Options"),
  Section2 = tabs.RemoteTracker:AddSection("Args Options"),
}
local Input = RemoteTrackerSections.Section1:AddInput({
  Title = "Add path",
  Content = "add path of remote you want to block",
  Callback = function(Value)
    local ok, result = pcall(function()
        return loadstring("return " .. Value)()
    end)

    if ok and typeof(result) == "Instance" then
      SelectedRemote = result:GetFullName()
    else
      print("Fatal error")
    end
  end
})
local Input = RemoteTrackerSections.Section1:AddInput({
  Title = "Type",
  Content = 'can be "RemoteEvent" or "RemoteFunction"',
  Callback = function(Value)
    SelectedType = Value
  end
})
local Button = RemoteTrackerSections.Section1:AddButton({
  ["Title"] = "Block remote",
  ["Content"] = "optionally block selected remote event",
  ["Callback"] = function()
    RemoteTracker:Hook({
      Path = SelectedRemote,
      Type = tostring(SelectedType)
    })
  end
})
local Toggle = RemoteTrackerSections.Section2:AddToggle({
  ["Title"]= "Enabled",
  ["Content"] = "table containing argument filters to match specific remote calls.",
  ["Default"] = false,
  ["Callback"] = function(Value)

  end
})
local NumberDropdown = RemoteTrackerSections.Section2:AddDropdown({
  ["Title"] = "Number",
  ["Content"] = "numbers to match with numeric args",
  ["Multi"] = true,
  ["Options"] = {},
  ["Default"] = {'--'},
  ["Callback"] = function(Value)
    print(Value)
  end
})
local StringDropdown = RemoteTrackerSections.Section2:AddDropdown({
  ["Title"] = "String",
  ["Content"] = "strings to match with string args",
  ["Multi"] = true,
  ["Options"] = {},
  ["Default"] = {'--'},
  ["Callback"] = function(Value)
    print(Value)
  end
})
local InstanceDropdown = RemoteTrackerSections.Section2:AddDropdown({
  ["Title"] = "Instance",
  ["Content"] = "instances to match with instance args",
  ["Multi"] = true,
  ["Options"] = {},
  ["Default"] = {'--'},
  ["Callback"] = function(Value)
    print(Value)
  end
})
local Dropdown = RemoteTrackerSections.Section2:AddDropdown({
  ["Title"] = "Add options",
  ["Content"] = "select a dropdown you want to add option",
  ["Multi"] = false,
  ["Options"] = {'NumberDropdown', 'StringDropdown', 'InstanceDropdown'},
  ["Default"] = {'--'},
  ["Callback"] = function(Value)
    SelectedDropdown = Value
  end
})
local Input = RemoteTrackerSections.Section2:AddInput({
  ["Title"] = "Enter",
  ["Content"] = "enter the options you want to add to selected dropdown",
  ["Callback"] = function(Value)
    SelectedOption = Value
  end
})
local Button = RemoteTrackerSections.Section2:AddButton({
  ["Title"] = "Add Options",
  ["Content"] = "click to add selected options in the selected dropdown",
  ["Callback"] = function()
    if unpack(SelectedDropdown) == "NumberDropdown" then
      NumberDropdown:AddOption(tonumber(SelectedOption))
    elseif unpack(SelectedDropdown) == "StringDropdown" then
      StringDropdown:AddOption(tostring(SelectedOption))
    elseif unpack(SelectedDropdown) == "InstanceDropdown" then
      local ok, result = pcall(function()
        return loadstring("return " .. SelectedOption)()
      end)
      if ok and typeof(result) == "Instance" then
        InstanceDropdown:AddOption(result:GetFullName())
      else
        print("Fatal error")
      end
    end
  end
})
local Button = RemoteTrackerSections.Section2:AddButton({
  ["Title"] = "Clear dropdown",
  ["Content"] = "click to clear options in selected dropdown",
  ["Callback"] = function()
    if unpack(SelectedDropdown) == "NumberDropdown" then
      NumberDropdown:Clear()
    elseif unpack(SelectedDropdown) == "StringDropdown" then
      StringDropdown:Clear()
    elseif unpack(SelectedDropdown) == "InstanceDropdown" then
      InstanceDropdown:Clear()
    end
  end
})
