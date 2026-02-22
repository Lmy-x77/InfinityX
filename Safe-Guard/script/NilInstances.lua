local TARGET_KEYWORDS = {
    "kitten", "prism", "eclipse", "solara", "wave", "fluxus", "nekohub",
    "delta", "codex", "venyx", "neverlose", "synapse", "krnl", "scriptware",
    "anticheat", "bypass", "detection", "ac_", "anti_", "loader", "core",
    "ugcvalidationservice", "skillvalid", "asset detection", "suspicious coregui",
    "exploit log detected", "nice try! maybe stick to playing the game",
    "impactframe", "savefunction", "rathub x", "nshub 2", "rat hub x",
    "exploitassets", "dark dex", "rayfield", "infinite yield", "linoria",
    "v_u_53", "v_u_23", "v_u_33", "humanoiddescription", "inspectplayerfromhumanoiddescription"
}

local function isDangerous(obj)
    if not obj:IsA("LocalScript") then return false end
    local name = (obj.Name or ""):lower()
    for _, kw in ipairs(TARGET_KEYWORDS) do
        if name:find(kw) then return true end
    end
    pcall(function()
        local src = decompile(obj)
        if src then
            src = src:lower()
            for _, kw in ipairs(TARGET_KEYWORDS) do
                if src:find(kw) then return true end
            end
            if src:find("savefunction") or src:find("impactframe") or 
               src:find("ugcvalidationservice") or src:find("skillvalid") or
               src:find("inspectplayerfromhumanoiddescription") or
               src:find("nice try! maybe stick to playing the game") then
                return true
            end
        end
    end)
    return false
end

for _,v in pairs(getnilinstances()) do
    if v:IsA("LocalScript") then
        if isDangerous(v) then
            pcall(function() v:Destroy() end)
        end
        local env = getsenv(v)
        if env then
            pcall(function()
                for k,val in pairs(env) do
                    if type(val) == "function" then
                        env[k] = function(...) return nil end
                    end
                end
            end)

            pcall(function()
                setmetatable(env, {
                    __index = function(self, key)
                        return function(...) return nil end
                    end,
                    __newindex = function() end
                })
            end)

            pcall(function()  
                if env.task then
                    setmetatable(env.task, {
                        __index = function() return function() return nil end end,
                        __newindex = function() end
                    })
                end
            end)
        end
    end
    if v:IsA("BindableEvent") then
        pcall(function()
            for _, c in pairs(getconnections(v.Event)) do
                c:Disable()
            end

            hookfunction(v.Fire, function()
                return nil
            end)
            hookfunction(v.FireServer or function() end, function()
                return nil
            end)
        end)
    end
end
