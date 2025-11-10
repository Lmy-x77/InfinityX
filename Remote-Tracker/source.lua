local hook = {}
hook.__index = hook

local OldNamecall
local OldInvokeServer

function hook:Hook(info)
    local Path = info.Path
    local Type = info.Type
    if not Path or not Type then return end

    if Type == "RemoteFunction" then
        OldNamecall = OldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "InvokeServer" and self == Path then
                return nil
            end
            return OldNamecall(self, ...)
        end)

        if not OldInvokeServer then
            OldInvokeServer = hookfunction(Path.InvokeServer, function(self, ...)
                if self == Path then
                    return nil
                end
                return OldInvokeServer(self, ...)
            end)
        end
    elseif Type == "RemoteEvent" then
        OldNamecall = OldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            if method == "FireServer" and self == Path then
                return
            end
            return OldNamecall(self, ...)
        end)
    end
end

return hook
