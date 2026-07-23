local StatsFinder = {}

local Cache = {}
local Loaded = false

function StatsFinder:Load()
	if Loaded then
		return true
	end

	for _,v in pairs(getgc(true)) do
		if type(v) == "table" then
			local stats = rawget(v, "Stats")
			if type(stats) == "table" then
				for statName, data in pairs(stats) do
					if type(data) == "table" and data.Stat ~= nil then
						Cache[statName] = data
					end
				end
			end
		end
	end

	Loaded = true
	return true
end

function StatsFinder:Get(statName)
	if not Loaded then
		self:Load()
	end

	local stat = Cache[statName]

	if stat then
		return stat.Stat
	end

	return nil
end

function StatsFinder:GetAll()
	if not Loaded then
		self:Load()
	end

	local result = {}

	for name,data in pairs(Cache) do
		result[name] = data.Stat
	end

	return result
end

function StatsFinder:Refresh()
	Loaded = false
	Cache = {}

	self:Load()
end

return StatsFinder
