local hook = {}
hook.__index = hook

local OldNamecall
local OldInvoke

function hook:Hook(info)
    local Path = info.Path
    local Type = info.Type

    if Type == "RemoteEvent" then
        OldNamecall = OldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if self == Path and method == "FireServer" then
                print("[Intercepted RemoteEvent]:", self.Name, ...)
                return
            end
            return OldNamecall(self, ...)
        end)
    elseif Type == "RemoteFunction" then
        if not Path or not Path.InvokeServer then return end
        OldInvoke = OldInvoke or hookfunction(Path.InvokeServer, function(self, ...)
            if self == Path then
                print("[Intercepted RemoteFunction]:", self.Name, ...)
                return OldInvoke(self, ...)
            end
            return OldInvoke(self, ...)
        end)
    end
end

return hook
