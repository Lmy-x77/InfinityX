local SafeGuard = {}
SafeGuard.__index = SafeGuard

function SafeGuard:Hook(info)
  local AntiKick = info.AntiKick
  local AntiBan = info.AntiBan
  local AntiHttpSpy = info.AntiHttpSpy
  local BlockRemote = info.BlockRemote or {}

  if AntiKick then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Anti-Kick.lua'))()
  end
  if AntiBan then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Anti-Ban.lua'))()
  end
  if AntiHttpSpy then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Http-Spy.lua'))()
  end
  if BlockRemote.Enabled then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/Block-Remote.lua'))()
  end
end

return SafeGuard
