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

saferequire = setmetatable({}, {
    __call = function(self, module)
        assert(typeof(module) == "Instance" and module:IsA("ModuleScript"), "Invalid ModuleScript")
        local ok, result = pcall(require, module)
        if not ok then
            warn("Require Error:", result)
            return
        end
        return result
    end
})

local ClientEvents = saferequire( Services.ReplicatedStorage.Generated._ClientEvents );
local function noop() end

for name, api in pairs(ClientEvents) do
	if typeof(api) == "table" and typeof(api.setCallback) == "function" then
		api.setCallback(noop)
	end
end

return ClientEvents
