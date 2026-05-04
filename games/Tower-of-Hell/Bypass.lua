-- // services
local players = game:GetService("Players")
local replicated = game:GetService("ReplicatedStorage")

-- // locals
local lp = players.LocalPlayer
local scripts = lp:WaitForChild("PlayerScripts")

-- // utils
local function _disconnect(signal)
    for _,c in ipairs(getconnections(signal)) do
        c:Disconnect()
    end
end

local function _disable(signal)
    for _,c in ipairs(getconnections(signal)) do
        c:Disable()
    end
end

local function _hookKick(env)
    if env and env.kick then
        hookfunction(env.kick,function() return nil end)
    end
end

local function _hookRemotes()
    local folder = replicated:FindFirstChild("Remotes") and replicated.Remotes:FindFirstChild("Moderation")
    if not folder then return end

    for _,r in ipairs(folder:GetChildren()) do
        local old
        old = hookmetamethod(game,"__namecall",function(self,...)
            local method = getnamecallmethod()
            if self == r and (method == "FireServer" or method == "InvokeServer") then
                return
            end
            return old(self,...)
        end)
    end
end

local function _autoDisable(a,b)
    task.spawn(function()
        while task.wait() do
            if a then a.Disabled = true end
            if b then b.Disabled = true end
        end
    end)
end

-- // main
print("[_BYPASS_]_loading...")

task.wait(1.5)

pcall(function()
    if not (hookfunction and getconnections and getsenv) then
        return print("[_BYPASS_]_failed ❌")
    end

    local ls1 = scripts:FindFirstChild("LocalScript")
    local ls2 = scripts:FindFirstChild("LocalScript2")

    if ls1 then
        _hookKick(getsenv(ls1))
        _disable(ls1.Changed)
    end

    if ls2 then
        _disconnect(ls2.Changed)
    end

    _hookRemotes()
    _autoDisable(ls1,ls2)

    print("[_BYPASS_]_functions_disconnected ✅")
    task.wait(.3)
    print("[_BYPASS_]_kick_hooked ✅")
    task.wait(.3)
    print("[_BYPASS_]_signals_disabled ✅")
    task.wait(.3)
    print("[_BYPASS_]_remotes_hooked ✅")
    task.wait(.3)
    print("[_BYPASS_]_auto_disable_active ✅")
end)

task.wait(.25)
print("[_BYPASS_]_applied_successfully")
