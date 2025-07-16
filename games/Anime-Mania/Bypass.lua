print('[ BYPASS ] loading...')
wait(2)

pcall(function()
    if hookmetamethod then
        local v_u_1 = game.Players.LocalPlayer
        local v_u_2 = v_u_1.Character or v_u_1.CharacterAdded:wait()
        local bypass;
        bypass = hookmetamethod(game, "__namecall", function(method, ...)
            if getnamecallmethod() == "FireServer" and method == v_u_2:FindFirstChild('Ban') then
                return
            end
            return bypass(method, ...)
        end)
        print('[ BYPASS ] - Block ban remote 🟢')
        wait(.5)

        local lscript = game:GetService("Players").LocalPlayer.Backpack:WaitForChild("ClientMain")
        local senv = getsenv(lscript)
        for k, v in pairs(senv) do
            if typeof(v) == "function" then
                local info = debug.getconstants(v)
                for _, const in ipairs(info) do
                    if tostring(const):lower():find("kick") then
                        senv[k] = function() end
                        break
                    end
                end
            end
        end
        print('[ BYPASS ] - Remove kick functions 🟢')
        wait(.5)

        local lp = game:GetService("Players").LocalPlayer
        local oldKick
        oldKick = hookmetamethod(game, "__namecall", function(self, ...)
            if self == lp and getnamecallmethod() == "Kick" then
                return
            end
            return oldKick(self, ...)
        end)
        print('[ BYPASS ] - Anti kick security 🟢') wait(1)
    elseif not hookmetamethod then
        print('[ BYPASS ] failed ❌')
    end
end)

print('[ BYPASS ] applied successfully')
