local hook = {}
hook.__index = hook

local OldNamecall
local OldInvokeServer

function hook:Hook(info)
    local Path = info.Path
    local Type = info.Type
    local Args = info.Args or {}
    if not Path or not Type then return end

    local function matchArgs(args)
        if not Args.Enabled then return false end

        local numbers = Args.Number or {}
        local strings = Args.String or {}
        local instances = Args.Instance or {}

        for i, v in ipairs(numbers) do
            if args[i] ~= v then
                return false
            end
        end

        for i, v in ipairs(strings) do
            if args[i] ~= v then
                return false
            end
        end

        for i, v in ipairs(instances) do
            if args[i] ~= v then
                return false
            end
        end

        return true
    end

    if Type == "RemoteFunction" then
        OldNamecall = OldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if method == "InvokeServer" and self == Path then
                if matchArgs(args) then
                    return nil
                end
            end
            return OldNamecall(self, ...)
        end)

        if not OldInvokeServer then
            OldInvokeServer = hookfunction(Path.InvokeServer, function(self, ...)
                local args = {...}
                if self == Path and matchArgs(args) then
                    return nil
                end
                return OldInvokeServer(self, ...)
            end)
        end

    elseif Type == "RemoteEvent" then
        OldNamecall = OldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            if method == "FireServer" and self == Path then
                if matchArgs(args) then
                    return
                end
            end
            return OldNamecall(self, ...)
        end)
    end
end

return hook
