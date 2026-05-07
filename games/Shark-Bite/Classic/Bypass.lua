local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local Workspace = cloneref(game:GetService("Workspace"))

local LocalPlayer = Players.LocalPlayer
local PlayerScripts = LocalPlayer:WaitForChild("PlayerScripts")

local DetectionScript = PlayerScripts:FindFirstChild("LocalScript")
local DetectionRemote = Workspace.Terrain:FindFirstChild("RemoteEvent")
local HackerRemote = ReplicatedStorage:FindFirstChild("HackerMessage")
local Ragdoll = ReplicatedStorage:FindFirstChild("Ragdoll")

local function DisableConnections_(Signal)
    for _, Connection in ipairs(getconnections(Signal)) do
        pcall(Connection.Disable, Connection)
    end
end

local function BypassRagdoll_()
    if not Ragdoll then
        return
    end

    local Module = require(Ragdoll)

    for Index, Value in pairs(Module) do
        if typeof(Value) == "function" then
            Module[Index] = function() end
        end
    end

    Ragdoll.Name = "BypassedRagdoll"
end

local function HookProtection_()
    if not (hookfunction and hookmetamethod) then
        return
    end

    local MetaTable = getrawmetatable(game)
    local OldNamecall = MetaTable.__namecall

    setreadonly(MetaTable, false)

    MetaTable.__namecall = newcclosure(function(Self, ...)
        local Method = getnamecallmethod()

        if Method == "Kick" and Self == LocalPlayer then
            return nil
        end

        if Method == "FireServer" and Self == HackerRemote then
            return nil
        end

        return OldNamecall(Self, ...)
    end)

    hookfunction(LocalPlayer.Kick, newcclosure(function()
        return nil
    end))

    setreadonly(MetaTable, true)
end

local function NeutralizeDetection_()
    if not DetectionScript then
        return
    end

    for _, Function in ipairs(getgc(true)) do
        if typeof(Function) == "function" and getfenv(Function).script == DetectionScript then
            for Index = 1, debug.getinfo(Function).nups do
                debug.setupvalue(Function, Index, function()
                    return nil
                end)
            end

            hookfunction(Function, function() end)
        end
    end

    DisableConnections_(DetectionScript.AncestryChanged)
    DisableConnections_(DetectionScript.Changed)
    DisableConnections_(DetectionScript:GetPropertyChangedSignal("Parent"))

    DetectionScript.Disabled = true
end

local function DestroyRemotes_()
    pcall(function()
        if DetectionRemote then
            DetectionRemote:Destroy()
        end

        if HackerRemote then
            HackerRemote:Destroy()
        end
    end)
end

BypassRagdoll_()
HookProtection_()
NeutralizeDetection_()
DestroyRemotes_()
