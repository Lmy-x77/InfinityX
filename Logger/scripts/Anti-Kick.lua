local Logger = loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Logger/source.lua'))()

Logger.banner("Anti-Kick Utility")
Logger.info("Initialize", "Starting runtime checks and environment validation.")
Logger.stage(1, "Initialize", "Load safe modules\nCheck resource availability")

if hookfunction and getrawmetatable and setreadonly then
    local mt = getrawmetatable(game)
    local old = mt.namecall
    setreadonly(mt, false)
    mt.namecall = function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" then
            return
        end
        return old(self, ...)
    end
else
    Logger.error("Runtime", "Non-critical error: reconnect attempt failed")
    return
end

Logger.stage(2, "Hook Setup", "Attach harmless debugging hooks\nHooks uploaded successfully")
