local hook = {}
hook.__index = hook

local oldNamecall
local oldNewIndex

function hook:BypassGlobalGame()
    oldNamecall = oldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        if self == _G and method == "__newindex" then
            local key, value = ...
            if tostring(key) == "game" then
                return
            end
        end
        return oldNamecall(self, ...)
    end)

    oldNewIndex = oldNewIndex or hookmetamethod(_G, "__newindex", function(self, key, value)
        if tostring(key) == "game" then
            return
        end
        return oldNewIndex(self, key, value)
    end)
end

function hook:NeutralizeFluff()
    local function noop() end

    if rawget(_G, "MakeFluffNonGC") then
        _G.MakeFluffNonGC = noop
    end

    local success, mt = pcall(getrawmetatable, game)
    if success and mt then
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod()
            if method == "Write" or method == "Output" then
                return
            end
            return oldNamecall(self, ...)
        end)
        setreadonly(mt, true)
    end

    for _, v in pairs(getgc(true)) do
        if type(v) == "function" then
            local info = debug.getinfo(v)
            if info and info.name and info.name:find("MakeFluffNonGC") then
                hookfunction(v, function() return nil end)
            end
        end
    end
end

function hook:Apply()
    self:BypassGlobalGame()
    self:NeutralizeFluff()
    print("[Bypass] Anti-hook e neutralização de lag ativados.")
end

return hook
