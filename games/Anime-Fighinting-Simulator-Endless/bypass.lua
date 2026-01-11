local GameData = game:GetService("ReplicatedStorage").Modules.GameData
local success, source = pcall(require, GameData)
if not success then return end

local rf = game:GetService("ReplicatedFirst")
local start = rf:FindFirstChild("Start")
if start then start:Destroy() end

for _, f in pairs(getgc(true)) do
    if type(f) == "function" then
        local ok, consts = pcall(debug.getconstants, f)
        if ok then
            for _, c in pairs(consts) do
                if type(c) == "string" and c:lower() == "script detected" then
                    hookfunction(f, function() return end)
                end
            end
        end
    end
end

for _, f in pairs(source) do
    if type(f) == "function" then
        for _, c in pairs(debug.getconstants(f)) do
            if type(c) == "string" and c:lower() == "kick" then
                hookfunction(f, function() return end)
                break
            end
        end
    end
end

task.spawn(function()
    local RF = game:GetService("ReplicatedFirst")
    local start, ls2

    repeat
        start = RF:FindFirstChild("Start")
        task.wait(1)
    until start

    repeat
        ls2 = start:FindFirstChild("LocalScript2")
        task.wait(1)
    until ls2

    for i = 1, 5 do task.wait(3)
        for _, v in pairs(getgc(false)) do
            if type(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.name == "reportDetectionAndCrash" then
                    hookfunction(v, function() return end)
                    return
                end
            end
        end
    end
end)

task.spawn(function()
    while true do task.wait(1)
        local gui = game.Players.LocalPlayer.PlayerGui:FindFirstChild("ImpactFrame")
        if gui then
            local ls = gui:FindFirstChildWhichIsA("LocalScript")
            if ls then
                for _, f in pairs(getsenv(ls)) do
                    if type(f) == "function" then
                        hookfunction(f, function() return end)
                        break
                    end
                end
            end
            for _, s in pairs(gui:GetDescendants()) do
                if s:IsA("Sound") then
                    s:Destroy()
                end
            end
            gui:Destroy()
        end
    end
end)

task.spawn(function()
    local RF = game:GetService("ReplicatedFirst")
    local start, ls2

    repeat
        start = RF:FindFirstChild("Start")
        task.wait(1)
    until start

    repeat
        ls2 = start:FindFirstChild("LocalScript2")
        task.wait(1)
    until ls2

    for _, f in pairs(getsenv(ls2)) do
        if type(f) == "function" then
            hookfunction(f, function() return end)
        end
    end

    local module = ls2:FindFirstChild("ModuleScript")
    if module then
        local ok, mod = pcall(require, module)
        if ok then
            for _, f in pairs(mod) do
                if type(f) == "function" then
                    hookfunction(f, function() return end)
                end
            end
        end
    end
end)
