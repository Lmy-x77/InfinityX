local OldNamecall
OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        for _, v in pairs(BlockRemote.Name) do
            if self == v then
                return nil
            end
        end
    end
    return OldNamecall(self, ...)
end)
