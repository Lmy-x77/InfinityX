local cloneref = cloneref or clonereference or function(i) return i end
local RunService = cloneref(game:GetService("RunService"))
local HttpService = cloneref(game:GetService("HttpService"))

local Window
local ConfigManager = {
	Folder = nil,
	Path = nil,
	Configs = {},
	Parser = {
		Toggle = {
			Save = function(o) return { __type = o.__type, value = o.Value } end,
			Load = function(e,d) if e and e.Set then e:Set(d.value) end end
		},
		Slider = {
			Save = function(o) return { __type = o.__type, value = o.Value.Default } end,
			Load = function(e,d) if e and e.Set then e:Set(tonumber(d.value)) end end
		},
		Dropdown = {
			Save = function(o) return { __type = o.__type, value = o.Value } end,
			Load = function(e,d) if e and e.Select then e:Select(d.value) end end
		},
		Input = {
			Save = function(o) return { __type = o.__type, value = o.Value } end,
			Load = function(e,d) if e and e.Set then e:Set(d.value) end end
		},
		Keybind = {
			Save = function(o) return { __type = o.__type, value = o.Value } end,
			Load = function(e,d) if e and e.Set then e:Set(d.value) end end
		},
		Colorpicker = {
			Save = function(o)
				return {
					__type = o.__type,
					value = o.Default:ToHex(),
					transparency = o.Transparency
				}
			end,
			Load = function(e,d)
				if e and e.Update then
					e:Update(Color3.fromHex(d.value), d.transparency)
				end
			end
		}
	}
}

-- INIT
function ConfigManager:Init(WindowTable)
	if RunService:IsStudio() or not writefile then return false end
	if not WindowTable.Folder then return false end

	Window = WindowTable
	self.Folder = Window.Folder
	self.Path = "WindUI/" .. tostring(self.Folder) .. "/config/"

	if not isfolder(self.Path) then
		makefolder(self.Path)
	end

	for _, name in pairs(self:GetAutoLoadConfigs()) do
		self:CreateConfig(name, true)
	end

	return self
end

-- LIST FILES
function ConfigManager:AllConfigs()
	if not listfiles then return {} end
	local t = {}
	for _, f in pairs(listfiles(self.Path)) do
		local n = f:match("([^\\/]+)%.json$")
		if n then table.insert(t, n) end
	end
	return t
end

-- GET CONFIG (auto create if exists)
function ConfigManager:GetConfig(name)
	if self.Configs[name] then
		return self.Configs[name]
	end
	if isfile(self.Path .. name .. ".json") then
		return self:CreateConfig(name)
	end
	return nil
end

-- SET AUTOLOAD (persistente)
function ConfigManager:SetAutoLoad(name, value)
	local path = self.Path .. name .. ".json"
	if not isfile(path) then return end

	local data = HttpService:JSONDecode(readfile(path))
	data.__autoload = value
	writefile(path, HttpService:JSONEncode(data))

	if self.Configs[name] then
		self.Configs[name].AutoLoad = value
	end
end

-- GET AUTOLOAD CONFIGS (do disco)
function ConfigManager:GetAutoLoadConfigs()
	local t = {}
	if not listfiles then return t end

	for _, f in pairs(listfiles(self.Path)) do
		local data = HttpService:JSONDecode(readfile(f))
		if data.__autoload then
			local n = f:match("([^\\/]+)%.json$")
			if n then table.insert(t, n) end
		end
	end
	return t
end

-- CREATE CONFIG
function ConfigManager:CreateConfig(name, autoload)
	if not name then return end

	local Config = {
		Path = self.Path .. name .. ".json",
		Elements = {},
		CustomData = {},
		AutoLoad = autoload or false,
		Version = 1.2
	}

	function Config:Register(flag, element)
		self.Elements[flag] = element
	end

	function Config:SetAutoLoad(v)
		self.AutoLoad = v
		ConfigManager:SetAutoLoad(name, v)
	end

	function Config:Save()
		if Window.PendingFlags then
			for f,e in pairs(Window.PendingFlags) do
				self:Register(f,e)
			end
		end

		local data = {
			__version = self.Version,
			__autoload = self.AutoLoad,
			__custom = self.CustomData,
			__elements = {}
		}

		for n,e in pairs(self.Elements) do
			local p = ConfigManager.Parser[e.__type]
			if p then
				data.__elements[n] = p.Save(e)
			end
		end

		writefile(self.Path, HttpService:JSONEncode(data))
		return true
	end

	function Config:Load()
		if not isfile(self.Path) then return false end
		local data = HttpService:JSONDecode(readfile(self.Path))

		if Window.PendingFlags then
			for f,e in pairs(Window.PendingFlags) do
				self:Register(f,e)
			end
		end

		for n,d in pairs(data.__elements or {}) do
			local e = self.Elements[n]
			local p = ConfigManager.Parser[d.__type]
			if e and p then
				task.spawn(p.Load, e, d)
			end
		end

		self.CustomData = data.__custom or {}
		self.AutoLoad = data.__autoload or false
		return true
	end

	-- auto load imediato
	if isfile(Config.Path) then
		local data = HttpService:JSONDecode(readfile(Config.Path))
		if data.__autoload then
			task.spawn(function()
				task.wait()
				Config:Load()
			end)
		end
	end

	self.Configs[name] = Config
	Window.CurrentConfig = Config
	return Config
end

function ConfigManager:Config(name, autoload)
	return self:CreateConfig(name, autoload)
end

return ConfigManager
