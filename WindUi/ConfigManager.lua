local cloneref = cloneref or function(i) return i end
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))

local ConfigManager = {}
ConfigManager.__index = ConfigManager

ConfigManager.Parser = {
	Toggle = {
		Save = function(o) return { __type = o.__type, value = o.Value } end,
		Load = function(e, d) if e and e.Set then e:Set(d.value) end end
	},
	Slider = {
		Save = function(o) return { __type = o.__type, value = o.Value.Default } end,
		Load = function(e, d) if e and e.Set then e:Set(d.value) end end
	},
	Input = {
		Save = function(o) return { __type = o.__type, value = o.Value } end,
		Load = function(e, d) if e and e.Set then e:Set(d.value) end end
	},
	Dropdown = {
		Save = function(o) return { __type = o.__type, value = o.Value } end,
		Load = function(e, d) if e and e.Select then e:Select(d.value) end end
	},
	Keybind = {
		Save = function(o) return { __type = o.__type, value = o.Value } end,
		Load = function(e, d) if e and e.Set then e:Set(d.value) end end
	},
	Colorpicker = {
		Save = function(o)
			return { __type = o.__type, value = o.Default:ToHex(), transparency = o.Transparency }
		end,
		Load = function(e, d)
			if e and e.Update then
				e:Update(Color3.fromHex(d.value), d.transparency)
			end
		end
	}
}

function ConfigManager.new(Window)
	assert(not RunService:IsStudio(), "ConfigManager não funciona no Studio")
	assert(Window and Window.Folder, "Window.Folder ausente")

	local self = setmetatable({}, ConfigManager)
	self.Window = Window
	self.Path = "WindUI/" .. Window.Folder .. "/config/"
	self.Configs = {}

	if not isfolder(self.Path) then
		makefolder(self.Path)
	end

	for _, name in ipairs(self:AllConfigs()) do
		self:Create(name)
	end

	return self
end

function ConfigManager:AllConfigs()
	local t = {}
	if not listfiles then return t end
	for _, f in ipairs(listfiles(self.Path)) do
		local n = f:match("([^\\/]+)%.json$")
		if n then table.insert(t, n) end
	end
	return t
end

function ConfigManager:Get(name)
	return self.Configs[name] or self:Create(name)
end

function ConfigManager:Create(name)
	if self.Configs[name] then
		return self.Configs[name]
	end

	local cfg = {
		Name = name,
		Path = self.Path .. name .. ".json",
		Elements = {},
		Custom = {},
		AutoLoad = false,
		Version = 1.0
	}

	function cfg:Register(k, e)
		cfg.Elements[k] = e
	end

	function cfg:SetAutoLoad(v)
		cfg.AutoLoad = v
	end

	function cfg:Save()
		if self.Window.PendingFlags then
			for k, e in pairs(self.Window.PendingFlags) do
				cfg:Register(k, e)
			end
		end

		local data = {
			__version = cfg.Version,
			__autoload = cfg.AutoLoad,
			__custom = cfg.Custom,
			__elements = {}
		}

		for k, e in pairs(cfg.Elements) do
			local p = ConfigManager.Parser[e.__type]
			if p then
				data.__elements[k] = p.Save(e)
			end
		end

		writefile(cfg.Path, HttpService:JSONEncode(data))
	end

	function cfg:Load()
		if not isfile(cfg.Path) then return end
		local data = HttpService:JSONDecode(readfile(cfg.Path))

		cfg.AutoLoad = data.__autoload == true
		cfg.Custom = data.__custom or {}

		if self.Window.PendingFlags then
			for k, e in pairs(self.Window.PendingFlags) do
				cfg:Register(k, e)
			end
		end

		for k, v in pairs(data.__elements or {}) do
			local e = cfg.Elements[k]
			local p = ConfigManager.Parser[v.__type]
			if e and p then
				task.spawn(p.Load, e, v)
			end
		end
	end

	if isfile(cfg.Path) then
		local data = HttpService:JSONDecode(readfile(cfg.Path))
		if data.__autoload then
			cfg:Load()
		end
	end

	self.Configs[name] = cfg
	self.Window:SetCurrentConfig(cfg)
	return cfg
end

function ConfigManager:GetAutoLoads()
	local t = {}
	for n, c in pairs(self.Configs) do
		if c.AutoLoad then
			table.insert(t, n)
		end
	end
	return t
end

return ConfigManager
