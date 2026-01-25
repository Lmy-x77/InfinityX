local hook = {}
hook.__index = hook

local oldNamecall
local oldNewIndex

function hook:BypassGlobalGame()
    pcall(function()
        if not hookmetamethod then return end
        oldNamecall = oldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod and getnamecallmethod()
            if self == _G and method == "__newindex" then
                local key = ...
                if tostring(key) == "game" then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end)

    pcall(function()
        if not hookmetamethod then return end
        oldNewIndex = oldNewIndex or hookmetamethod(_G, "__newindex", function(self, key, value)
            if tostring(key) == "game" then
                return
            end
            return oldNewIndex(self, key, value)
        end)
    end)
end

function hook:NeutralizeFluff()
    local noop = function() end

    pcall(function()
        if rawget(_G, "MakeFluffNonGC") then
            _G.MakeFluffNonGC = noop
        end
    end)

    pcall(function()
        if not getrawmetatable or not setreadonly or not newcclosure then return end
        local mt = getrawmetatable(game)
        if not mt then return end

        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod()
            if method == "Write" or method == "Output" then
                return
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)

    pcall(function()
        if not getgc or not hookfunction then return end
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.name and info.name:find("MakeFluffNonGC") then
                    hookfunction(v, function() return nil end)
                end
            end
        end
    end)
end

function hook:Apply()
    pcall(function()
        self:BypassGlobalGame()
        self:NeutralizeFluff()
    end)
end

return hook
