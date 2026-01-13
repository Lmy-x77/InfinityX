if not run_on_actor then
  pcall(game.Players.LocalPlayer.Kick, game.Players.LocalPlayer, "Your exploit: " .. identifyexecutor() .. ' dont support actor funtions')
end

local getactors = getactors or function()
    local t = {}
    for _, v in ipairs(game:QueryDescendants("Actor")) do
        t[#t+1] = v
    end
    return t
end

pcall(function()
  local actor = getactors()[1]

  run_on_actor(actor, function()
    for _, v in pairs(getgc(true)) do
      if type(v) == "function" then
        local info = debug.getinfo(v)
        if info and info.source and info.source:find("ReplicatedFirst") then
          pcall(hookfunction, v, function()
            return nil
          end)
        end
      end
    end
  end)
end)
