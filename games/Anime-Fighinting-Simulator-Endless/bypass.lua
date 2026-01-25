if (not run_on_actor or not getrawmetatable or not setreadonly or not rawset) or identifyexecutor() == "Bunni" or identifyexecutor() == "Velocity" then
  pcall(game.Players.LocalPlayer.Kick, game.Players.LocalPlayer,
    "Your exploit: " .. identifyexecutor() .. " dont support actor functions"
  )
else
  local Source = [=[
    task.spawn(function()
      while true do
        pcall(function()
          for i, v in getgc(true) do
            if type(v) == "function" then
              local info = debug.getinfo(v)
              if info and info.source and info.source:find("ReplicatedFirst") then
                local env = getfenv(v)
                if env then
                  pcall(function()
                    if env.game then
                      local mt = getrawmetatable(env.game)
                      setreadonly(mt, false)
                      rawset(mt, "__index", function() return function() end end)
                      rawset(mt, "__namecall", function() return nil end)
                      
                      setreadonly(mt, true)
                    end
                  end)
                  pcall(function()
                    local mt = getrawmetatable(Instance)
                    setreadonly(mt, false)
                    local old_new = mt.__index.new
                    rawset(mt.__index, "new", function(className, ...)
                      if className == "HumanoidDescription" then
                        return setmetatable({}, {
                          __index = function() return "" end,
                          __newindex = function() end
                        })
                      end
                      return old_new(className, ...)
                    end)  
                    setreadonly(mt, true)
                  end)
                  env.error = function() end
                  env.warn = function() end
                  env.pcall = function() return false end
                  rawset(env, "task", setmetatable({}, {
                    __index = function() return function() end end,
                    __newindex = function() end,
                    __metatable = "Locked"
                  }))
                  rawset(env, "string", setmetatable({}, {
                    __index = function(self, key)
                      if key == "find" or key == "match" then
                        return function() return nil end
                      elseif key == "lower" or key == "sub" then
                        return function(s) return s end
                      else
                        return function() return "" end
                      end
                    end
                  }))
                  rawset(env, "Instance", setmetatable({}, {
                    __index = function() 
                      return function() return {} end 
                    end
                  }))
                end
              end
            end
          end
        end)
        task.wait(0.03)
      end
    end)
  ]=]
  pcall(run_on_actor, getactors()[1], Source)
end
