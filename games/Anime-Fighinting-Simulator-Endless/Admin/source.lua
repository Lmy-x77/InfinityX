-- variables
local loopTeleportStates = {}
local looprespawnStates = {}
local loopkillStates = {}
local RS = game:GetService("ReplicatedStorage")
local Cmdr = RS:WaitForChild("CmdrClient")
local CmdrFunction = Cmdr:WaitForChild("CmdrFunction")
local CmdrEvent = Cmdr:WaitForChild("CmdrEvent")
local function ExecuteCmd(command)
  pcall(function()
    CmdrFunction:InvokeServer(command)
  end)
  pcall(function()
    CmdrEvent:FireServer(command)
  end)
end


-- ui library
local vanta = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Command/VantaUi.lua"))()
local commands = vanta.Initialize({
  Shortcut = { Enum.KeyCode.Home },
  Theme = vanta.Themes.Monochrome
})


-- create blur
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local blur = Instance.new("BlurEffect")
local gui = CoreGui:WaitForChild("RobloxGui"):WaitForChild("Vanta")
blur.Size = 24
blur.Enabled = gui.Enabled
blur.Parent = Lighting
gui:GetPropertyChangedSignal("Enabled"):Connect(function()
	blur.Enabled = gui.Enabled
end)


-- source
commands.Register({
  Icon = nil,
  Name = "kick",
  Description = "Expels the designated player from the active session.",
  Arguments = {
    { Name = "Player", Type = "string", Optional = false },
    { Name = "All", Type = "string", Optional = true },
    { Name = "Others", Type = "string", Optional = true },
  },
  Callback = function(self, player: string)
    local arg = player
    if arg == "All" or arg == "all" then
      for _, v in pairs(game.Players:GetChildren()) do
        ExecuteCmd("kick " .. v.Name)
      end
    elseif arg == "Others" or arg == "others" then
      for _, v in pairs(game.Players:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
          ExecuteCmd("kick " .. v.Name)
        end
      end
    else
      local findPlr = arg:lower()
      for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Name:lower():find(findPlr) then
          ExecuteCmd("kick " .. plr.Name)
        end
      end
    end
  end
})
commands.Register({
  Icon = nil,
  Name = "kill",
  Description = "Automatically kills the selected player.",
  Arguments = {
    { Name = "Player", Type = "string", Optional = false },
    { Name = "All", Type = "string", Optional = true },
    { Name = "Others", Type = "string", Optional = true },
  },
  Callback = function(self, player: string)
    local arg = player
    if arg == "All" or arg == "all" then
      for _, v in pairs(game.Players:GetChildren()) do
        ExecuteCmd("kill " .. v.Name)
      end
    elseif arg == "Others" or arg == "others" then
      for _, v in pairs(game.Players:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
          ExecuteCmd("kill " .. v.Name)
        end
      end
    else
      local findPlr = arg:lower()
      for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Name:lower():find(findPlr) then
          ExecuteCmd("kill " .. plr.Name)
        end
      end
    end
  end
})
commands.Register({
  Icon = nil,
  Name = "respawn",
  Description = "Respawns the selected player automatically",
  Aliares = { "resp", "reset", "re", "r" },
  Arguments = {
    { Name = "Player", Type = "string", Optional = false },
    { Name = "All", Type = "string", Optional = true },
    { Name = "Others", Type = "string", Optional = true },
  },
  Callback = function(self, player: string)
    local arg = player
    if arg == "All" or arg == "all" then
      for _, v in pairs(game.Players:GetChildren()) do
        ExecuteCmd("respawn " .. v.Name)
      end
    elseif arg == "Others" or arg == "others" then
      for _, v in pairs(game.Players:GetChildren()) do
        if v.Name ~= game.Players.LocalPlayer.Name then
          ExecuteCmd("respawn " .. v.Name)
        end
      end
    else
      local findPlr = arg:lower()
      for _, plr in pairs(game.Players:GetPlayers()) do
        if plr.Name:lower():find(findPlr) then
          ExecuteCmd("respawn " .. plr.Name)
        end
      end
    end
  end
})
commands.Register({
	Icon = nil,
	Name = "teleport",
	Description = "Execute the teleport command as you wish",
	Aliares = { "tp", "cframe", "goto" },
	Arguments = {
		{ Name = "From", Type = "string", Optional = false },
		{ Name = "To", Type = "string", Optional = false },
    { Name = "Others", Type = "string", Optional = false },
    { Name = "All", Type = "string", Optional = false },
	},
	Callback = function(self, fromArg: string, toArg: string)
		local argFrom = fromArg:lower()
		local argTo = toArg

		if argFrom == "all" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				ExecuteCmd("teleport " .. plr.Name .. " " .. argTo)
			end
		elseif argFrom == "others" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer then
					ExecuteCmd("teleport " .. plr.Name .. " " .. argTo)
				end
			end
		else
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr.Name:lower():find(argFrom) then
					ExecuteCmd("teleport " .. plr.Name .. " " .. argTo)
				end
			end
		end
	end
})
commands.Register({
	Icon = nil,
	Name = "announce",
	Description = "Show the other players what you want to announce",
	Aliares = { "an", "a" },
	Arguments = {
		{ Name = "Message", Type = "string", Optional = false },
	},
	Callback = function(self, Message: string)
		CmdrEvent:FireServer("announce " .. Message)
	end
})
commands.Register({
  Icon = nil,
  Name = "spectate",
  Description = "Spectate a player in real time.",
  Aliases = { "spec", "view" },
  Arguments = {
    { Name = "Player", Type = "string" },
    { Name = "State", Type = "boolean" },
  },
  Callback = function(self, playerName: string, state: boolean)
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Camera = workspace.CurrentCamera
    local function findPlayer(name)
      name = name:lower()
      for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Name:lower():find(name, 1, true) then
          return plr
        end
      end
    end
    local function setCamera(character)
      if not character then return end
      local hum = character:FindFirstChildOfClass("Humanoid")
      if hum then
        Camera.CameraType = Enum.CameraType.Custom
        Camera.CameraSubject = hum
      end
    end

    if state then
      local target = findPlayer(playerName)
      if not target then return end

      if target.Character then
        setCamera(target.Character)
      end

      target.CharacterAdded:Connect(function(char)
        task.wait()
        setCamera(char)
      end)
    else
      if LocalPlayer.Character then
        setCamera(LocalPlayer.Character)
      end
    end
  end
})
commands.Register({
	Icon = nil,
	Name = "loopkill",
	Description = "Kill any player you want without stopping",
	Aliares = { "lk", "loopk" },
	Arguments = {
		{ Name = "Player", Type = "string", Optional = false },
		{ Name = "State", Type = "boolean", Optional = false },
    { Name = "All", Type = "string", Optional = true },
    { Name = "Others", Type = "string", Optional = true },
	},
	Callback = function(self, player: string, state: boolean)
		local arg = player:lower()
		local function start(plr)
			if loopkillStates[plr] then return end
			loopkillStates[plr] = true
			task.spawn(function()
				while loopkillStates[plr] do
					ExecuteCmd("kill " .. plr.Name)
					task.wait(0.3)
				end
			end)
		end
		local function stop(plr)
			loopkillStates[plr] = false
		end

		if arg == "all" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if state then start(plr) else stop(plr) end
			end
		elseif arg == "others" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer then
					if state then start(plr) else stop(plr) end
				end
			end
		else
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr.Name:lower():find(arg) then
					if state then start(plr) else stop(plr) end
				end
			end
		end
	end
})
commands.Register({
	Icon = nil,
	Name = "looprespawn",
	Description = "Respawn any player you want without stopping",
	Aliares = { "lr", "loopr" },
	Arguments = {
		{ Name = "Player", Type = "string", Optional = false },
		{ Name = "State", Type = "boolean", Optional = false },
		{ Name = "Others", Type = "string", Optional = true },
		{ Name = "All", Type = "string", Optional = true },
	},
	Callback = function(self, player: string, state: boolean)
		local arg = player:lower()
		local function start(plr)
			if looprespawnStates[plr] then return end
			looprespawnStates[plr] = true
			task.spawn(function()
				while looprespawnStates[plr] do
					ExecuteCmd("respawn " .. plr.Name)
					task.wait(0.5)
				end
			end)
		end
		local function stop(plr)
			looprespawnStates[plr] = false
		end

		if arg == "all" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if state then start(plr) else stop(plr) end
			end
		elseif arg == "others" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer then
					if state then start(plr) else stop(plr) end
				end
			end
		else
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr.Name:lower():find(arg) then
					if state then start(plr) else stop(plr) end
				end
			end
		end
	end
})
commands.Register({
	Icon = nil,
	Name = "loopteleport",
	Description = "Teleport players repeatedly",
	Aliares = { "ltp", "looptp", "loopgoto", "lg" },
	Arguments = {
		{ Name = "From", Type = "string", Optional = false },
		{ Name = "To", Type = "string", Optional = false },
		{ Name = "State", Type = "boolean", Optional = false },
		{ Name = "Others", Type = "string", Optional = true },
		{ Name = "All", Type = "string", Optional = true },
	},
	Callback = function(self, fromArg: string, toArg: string, state: boolean)
		local argFrom = fromArg:lower()
		local function start(plr)
			if loopTeleportStates[plr] then return end
			loopTeleportStates[plr] = true
			task.spawn(function()
				while loopTeleportStates[plr] do
					ExecuteCmd("teleport " .. plr.Name .. " " .. toArg)
					task.wait()
				end
			end)
		end
		local function stop(plr)
			loopTeleportStates[plr] = false
		end

		if argFrom == "all" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if state then start(plr) else stop(plr) end
			end
		elseif argFrom == "others" then
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr ~= game.Players.LocalPlayer then
					if state then start(plr) else stop(plr) end
				end
			end
		else
			for _, plr in pairs(game.Players:GetPlayers()) do
				if plr.Name:lower():find(argFrom) then
					if state then start(plr) else stop(plr) end
				end
			end
		end
	end
})
commands.Register({
	Icon = nil,
	Name = "destroy",
	Description = "Close the admin UI.",
	Callback = function()
    for _, v in pairs(game:GetService("CoreGui").RobloxGui:GetChildren()) do
      if v:IsA('ScreenGui') and v.Name == "Vanta" then
        v:Destroy()
      end
    end
	end
})
