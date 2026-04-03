---@diagnostic disable: undefined-global
---@diagnostic disable: undefined-doc-module


-- services
function missing(t, f, fallback)
	if type(f) == t then return f end
	return fallback
end

cloneref = missing("function", cloneref, function(...) return ... end)
hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)
getconnections = missing("function", getconnections or get_signal_cons)

Services = setmetatable({}, {
  __index = function(self, name)
    local success, cache = pcall(function()
      return cloneref(game:GetService(name))
    end)
    if success then
      rawset(self, name, cache)
      return cache
    else
      error("Invalid Service: " .. tostring(name))
    end
  end
})

safeloadstring = setmetatable({}, {
  __call = function(self, url)
  	assert(type(url) == "string", "Invalid URL")

  	local ok, response = pcall(function()
  	  return request({
  	    Url = url,
  	    Method = "GET"
  	  })
  	end)

  	if not ok or not response or response.StatusCode ~= 200 then
  	  return warn("Failed to fetch:", url)
  	end

  	local func, err = loadstring(response.Body)
  	if not func then
  	  return warn("Loadstring Error:", err)
  	end

  	setfenv(func, getgenv())

  	local success, result = pcall(func)
  	if not success then
  	  warn("Runtime Error:", result)
  	end

    return result
  end
})

local Workspace = Services.Workspace
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local ReplicatedFirst = Services.ReplicatedFirst
local TweenService = Services.TweenService
local RunService = Services.RunService
local TeleportService = Services.TeleportService
local HttpService = Services.HttpService
local VirtualUser = Services.VirtualUser
local UserInputService = Services.UserInputService
local MarketplaceService = Services.MarketplaceService
local VirtualInputManager = Services.VirtualInputManager
local CoreGui = Services.CoreGui


-- detect device
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
print("No Variables in the moment")


-- ui library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/kaisenlmao/loader/refs/heads/main/LibraryV3.lua"))()
local ThemeManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/ThemeManager.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/Nanana291/Kong/main/SaveManager.lua"))()
local Options = Library.Options
local Toggles = Library.Toggles

Library.ForceCheckbox = true

local Window = Library:CreateWindow({
  Title = '',
  Footer = '<font color="rgb(120,80,200)">Sailor Piece</font>',
  Icon = 92308401887821,
  Size = UDim2.fromOffset(580, 500),
  Position = UDim2.fromOffset(100, 100),
  Center = true,
  AutoShow = true,
  Resizable = true,
  ShowCustomCursor = false,
  ToggleKeybind = Enum.KeyCode.RightControl,
  NotifySide = "Right",
})
Window:SetSidebarWidth(54)


-- tabs
local AutoFarmTab = Window:AddTab({
  Name = "Auto Farm",
  Icon = "swords",
  Description = "Automated systems for fast and efficient farming.",
})


-- source
