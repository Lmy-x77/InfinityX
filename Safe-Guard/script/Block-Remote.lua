local OldNamecall
for _, v in pairs(BlockRemote.Name) do
  OldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
      local method = getnamecallmethod()
      if not checkcaller() and self == v and (method == "FireServer" or method == "InvokeServer") then
          return nil
      end
      return OldNamecall(self, ...)
  end)
end
