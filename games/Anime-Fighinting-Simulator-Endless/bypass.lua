
local Players = game:GetService("Players")
local ReplicatedFirst = game:GetService("ReplicatedFirst")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local hooked = setmetatable({}, { __mode = "k" }) -- weak keys to avoid leaks

local function safeHook(fn, replacement)
    if hooked[fn] then return end
    hooked[fn] = true
    hookfunction(fn, replacement or function(...) return nil end)
end

local function scanGC(callback, includeTables)
    for _, v in ipairs(getgc(includeTables)) do
        if type(v) == "function" then
            callback(v)
        end
    end
end

local function hookByConstant(target)
    scanGC(function(fn)
        local ok, consts = pcall(debug.getconstants, fn)
        if not ok or not consts then return end

        for _, c in ipairs(consts) do
            if c == target then
                safeHook(fn)
                break
            end
        end
    end)
end

do
    local GameData = ReplicatedStorage:FindFirstChild("Modules")
        and ReplicatedStorage.Modules:FindFirstChild("GameData")

    if GameData then
        pcall(require, GameData)
    end
end

do
    local start = ReplicatedFirst:FindFirstChild("Start")
    if start then
        start:Destroy()
    end
end

hookByConstant("script detected")
hookByConstant("🤡 do not exploit anymore rip bozo 🤡")

do
    local GameData = ReplicatedStorage:FindFirstChild("Modules")
        and ReplicatedStorage.Modules:FindFirstChild("GameData")

    if GameData then
        local ok, source = pcall(require, GameData)
        if ok and type(source) == "table" then
            for _, fn in pairs(source) do
                if type(fn) == "function" then
                    local ok2, consts = pcall(debug.getconstants, fn)
                    if ok2 then
                        for _, c in ipairs(consts) do
                            if c == "kick" then
                                safeHook(fn)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end

local function waitForLS2()
    local start = ReplicatedFirst:WaitForChild("Start", math.huge)
    return start:WaitForChild("LocalScript2", math.huge)
end

task.spawn(function()
    for _ = 1, 5 do
        task.wait(3)
        scanGC(function(fn)
            local info = debug.getinfo(fn)
            if info and info.name == "reportDetectionAndCrash" then
                safeHook(fn)
            end
        end)
    end
end)

do
    local pg = LocalPlayer:WaitForChild("PlayerGui")

    local function handleImpact(gui)
        local ls = gui:FindFirstChildWhichIsA("LocalScript")
        if ls then
            for _, fn in pairs(getsenv(ls)) do
                if type(fn) == "function" then
                    safeHook(fn)
                end
            end
        end

        for _, d in ipairs(gui:GetDescendants()) do
            if d:IsA("Sound") then
                d:Destroy()
            end
        end

        gui:Destroy()
    end

    pg.ChildAdded:Connect(function(child)
        if child.Name == "ImpactFrame" then
            handleImpact(child)
        end
    end)
end

task.spawn(function()
    local ls2 = waitForLS2()

    for _, fn in pairs(getsenv(ls2)) do
        if type(fn) == "function" then
            safeHook(fn)
        end
    end

    local module = ls2:FindFirstChildOfClass("ModuleScript")
    if module then
        local ok, mod = pcall(require, module)
        if ok and type(mod) == "table" then
            for _, fn in pairs(mod) do
                if type(fn) == "function" then
                    safeHook(fn)
                end
            end
        end
    end
end)
