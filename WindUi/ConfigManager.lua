local HttpService = cloneref(game:GetService("HttpService"))

local ConfigManager = {}
ConfigManager.__index = ConfigManager

function ConfigManager.new(Window)
	assert(Window and Window.Folder, "Window.Folder missing")

	local self = setmetatable({}, ConfigManager)
	self.Window = Window
	self.Path = "WindUI/" .. Window.Folder .. "/config/"
	self.Configs = {}

	if not isfolder(self.Path) then
		makefolder(self.Path)
	end

	-- AUTOLOAD REAL
	for _, name in ipairs(self:All()) do
		self:Get(name)
	end

	return self
end

function ConfigManager:All()
	local t = {}
	for _, f in ipairs(listfiles(self.Path)) do
		local n = f:match("([^\\/]+)%.json$")
		if n then table.insert(t, n) end
	end
	return t
end

function ConfigManager:Get(name)
	if self.Configs[name] then
		return self.Configs[name]
	end

	local cfg = {
		Name = name,
		Path = self.Path .. name .. ".json",
		Elements = {},
		AutoLoad = false
	}

	function cfg:Register(k, e)
		cfg.Elements[k] = e
	end

	function cfg:SetAutoLoad(v)
		cfg.AutoLoad = v
	end

	function cfg:Save()
		local data = {
			__autoload = cfg.AutoLoad,
			__elements = {}
		}

		if self.Window.PendingFlags then
			for k, e in pairs(self.Window.PendingFlags) do
				cfg:Register(k, e)
			end
		end

		for k, e in pairs(cfg.Elements) do
			data.__elements[k] = {
				__type = e.__type,
				value = e.Value
			}
		end

		writefile(cfg.Path, HttpService:JSONEncode(data))
	end

	function cfg:Load()
		if not isfile(cfg.Path) then return end
		local data = HttpService:JSONDecode(readfile(cfg.Path))
		cfg.AutoLoad = data.__autoload == true

		for k, v in pairs(data.__elements or {}) do
			local e = cfg.Elements[k]
			if e and e.Set then
				e:Set(v.value)
			end
		end
	end

	-- AUTOLOAD
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
