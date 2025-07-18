-- variables
local ls1 = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild('LocalScript')
local ls2 = game:GetService("Players").LocalPlayer.PlayerScripts:FindFirstChild('LocalScript2')
local senv = getsenv(ls1)
local func = senv.kick
local function disconnectAll(signal)
	for _, conn in ipairs(getconnections(signal)) do
		conn:Disconnect()
	end
end


-- source
print('[ BYPASS ] - Loading...')
task.wait(1.5)
pcall(function()
  if not hookfunction and getconnections and getsenv then
    print('[ BYPASS ] - Failed ❌')
  else
    disconnectAll(ls2.Changed)
    hookfunction(func, function(...)
        return nil
    end)
    for _, conn in pairs(getconnections(ls1.Changed)) do
        conn:Disable()
    end
    task.spawn(function() while true do task.wait() ls1.Disabled = true ls2.Disabled = true end end)
    for _, v in pairs(game:GetService("ReplicatedStorage").Remotes.Moderation:GetChildren()) do
      if v:IsA('RemoteFunction') then
        local remoteF = v
        local bypass;
        bypass = hookmetamethod(game, "__namecall", function(method, ...)
          if getnamecallmethod() == "InvokeServer" and method == remoteF then
            return
          end
          return bypass(method, ...)
        end)
      end
      if v:IsA('RemoteEvent') then
        local remoteE = v
        local bypass;
        bypass = hookmetamethod(game, "__namecall", function(method, ...)
          if getnamecallmethod() == "FireServer" and method == remoteE then
            return
          end
          return bypass(method, ...)
        end)
      end
    end

    print('[ BYPASS ] - Disconnected functions ✅')
    task.wait(.5)
    print('[ BYPASS ] - Hokked kick functions ✅')
    task.wait(.5)
    print('[ BYPASS ] - Disabled changed function ✅')
    task.wait(.5)
    print('[ BYPASS ] - Hokked admin remotes ✅')
    task.wait(.5)
    print('[ BYPASS ] - Auto disable local scripts ✅')
  end
end)
task.wait(.25)
print('[ BYPASS ] applied successfully')
