local Logger = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Logger/source.lua'))()

Logger.banner("Anti-Kick Utility")
Logger.info("Initialize", "Starting runtime checks and environment validation.")
Logger.stage(1, "Initialize", "Load safe modules\nCheck resource availability")

if hookfunction and getrawmetatable and setreadonly then
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local mt = getrawmetatable(game)
	local oldNamecall = mt.__namecall
	local oldIndex = mt.__index
	setreadonly(mt, false)
	mt.__namecall = newcclosure(function(self, ...)
		local method = getnamecallmethod()
		if self == LocalPlayer and (method == "Kick" or method == "kick") then
			warn("Kick function blocked.")
			return
		end
		return oldNamecall(self, ...)
	end)
	mt.__index = newcclosure(function(self, key)
		if self == LocalPlayer and (key == "Kick" or key == "kick") then
			return function()
				warn("Kick function call blocked.")
			end
		end
		return oldIndex(self, key)
	end)
	setreadonly(mt, true)
else
  Logger.error("Runtime", "Non-critical error: reconnect attempt failed")
  return
end

Logger.stage(2, "Hook Setup", "Attach harmless debugging hooks\nHooks uploaded successfully")
print('Anti-Kick loaded successfully!')
print('made by lmy77')
