local hook = {}
hook.__index = hook

local oldNamecall
local oldNewIndex

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local ReplicatedFirst = cloneref(game:GetService("ReplicatedFirst"))
local UnreliableRemoteEvent = ReplicatedStorage.shared.Remotes.UnreliableRemoteEvent

local Players = cloneref(game:GetService("Players"));
local lp = Players.LocalPlayer

function hook:BypassGlobalGame()
    pcall(function()
        if not hookmetamethod then return end
        oldNamecall = oldNamecall or hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod and getnamecallmethod()
            if self == _G and method == "__newindex" then
                local key = ...
                if tostring(key) == "game" then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end)

    pcall(function()
        if not hookmetamethod then return end
        oldNewIndex = oldNewIndex or hookmetamethod(_G, "__newindex", function(self, key, value)
            if tostring(key) == "game" then
                return
            end
            return oldNewIndex(self, key, value)
        end)
    end)
end

function hook:NeutralizeActor()
  pcall(function(...)
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
  end)
end

function hook:NeutralizeFluff()
    local noop = function() end

    pcall(function()
        if rawget(_G, "MakeFluffNonGC") then
            _G.MakeFluffNonGC = noop
        end
    end)

    pcall(function()
        if not getrawmetatable or not setreadonly or not newcclosure then return end
        local mt = getrawmetatable(game)
        if not mt then return end

        local old = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = newcclosure(function(self, ...)
            local method = getnamecallmethod and getnamecallmethod()
            if method == "Write" or method == "Output" then
                return
            end
            return old(self, ...)
        end)
        setreadonly(mt, true)
    end)

    pcall(function()
        if not getgc or not hookfunction then return end
        for _, v in pairs(getgc(true)) do
            if type(v) == "function" then
                local info = debug.getinfo(v)
                if info and info.name and info.name:find("MakeFluffNonGC") then
                    hookfunction(v, function() return nil end)
                end
            end
        end
    end)
end

function hook:NeutralizeUnreliableRemoteEvent()
    pcall(function()
        local oldNamecall
        oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
            if not checkcaller() and self == UnreliableRemoteEvent then
                if getnamecallmethod() == "Fire" then
                    return
                end
            end
            return oldNamecall(self, ...)
        end)
    end)
    pcall(function()
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", function(self, key)
            if not checkcaller() and self == UnreliableRemoteEvent and key == "Fire" then
                return function() end
            end
            return oldIndex(self, key)
        end)
    end)
end

function hook:NeutralizeLocalScript()
    pcall(function()
        local name = lp.Name
        local EXCLUDE_PATH = "Players.".. name ..".PlayerGui.Main.MainClient.VisualClient.Quirks"

        local function getScriptPath(func)
            local env = getfenv(func)
            if env and typeof(env.script) == "Instance" then
                return env.script:GetFullName()
            end

            local info = debug.getinfo(func)
            return (info.source or "unknown"):gsub("@","")
        end

        for _, v in ipairs(getgc(true)) do
            if typeof(v) == "function" and not isexecutorclosure(v) then
                local info = debug.getinfo(v)
                if info.name and (
                    info.name:lower():find("kick") or
                    info.name:lower():find("ban") or
                    info.name:lower():find("anti")
                ) then
                    local path = getScriptPath(v)
                    if not path:find(EXCLUDE_PATH, 1, true) then
                        hookfunction(v, function(...)
                            return nil
                        end)
                    end
                end
            end
        end
    end)
end

hook._applied = false

function hook:Apply()
  pcall(function()
    self:BypassGlobalGame()
    self:NeutralizeFluff()
    self:NeutralizeUnreliableRemoteEvent()
    self:NeutralizeLocalScript()
    hook:NeutralizeActor()
    self._applied = true
  end)
end

return hook
