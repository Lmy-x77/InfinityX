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

    print('[ BYPASS ] - Disconnected functions ✅')
    task.wait(.5)
    print('[ BYPASS ] - Hokked kick functions ✅')
    task.wait(.5)
    print('[ BYPASS ] - Disabled changed function ✅')
    task.wait(.5)
    print('[ BYPASS ] - Auto disable local scripts ✅')
  end
end)
task.wait(.25)
print('[ BYPASS ] applied successfully')
