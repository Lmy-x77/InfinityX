local hook = {}
hook.__index = hook

local OldNamecall = nil
local OldInvoke = {}

function hook:Hook(info)
    local Path = info.Path
    local Type = info.Type
    if not Path or not Type then return end

    if Type == "RemoteEvent" then
        if not OldNamecall then
            OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
                local method = getnamecallmethod()
                if method == "FireServer" and tostring(self) == tostring(Path) then
                    return
                end
                return OldNamecall(self, ...)
            end)
        end

    elseif Type == "RemoteFunction" then
        if not OldInvoke[Path] then
            OldInvoke[Path] = hookfunction(Path.InvokeServer, function(self, ...)
                if tostring(self) == tostring(Path) then
                    return nil
                end
                return OldInvoke[Path](self, ...)
            end)
        end
    end
end

return hook
