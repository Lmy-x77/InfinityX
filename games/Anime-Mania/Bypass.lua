print('[ BYPASS ] loading...')
wait(2)

pcall(function()
    if hookmetamethod then
        local mt = getrawmetatable(game)
        local old = mt.__namecall
        setreadonly(mt, false)
          mt.__namecall = newcclosure(function(name, ...)
            if tostring(getnamecallmethod()):lower() == "kick" then
              return
            elseif getnamecallmethod() == "FireServer" and tostring(name) == "Ban" then
              return
            end
          return old(name, ...)
        end)
        print('[ BYPASS ] - Block ban remote 🟢')
        wait(.5)
        print('[ BYPASS ] - Remove kick functions 🟢')
        wait(.5)
        print('[ BYPASS ] - Anti kick security 🟢') wait(1)
    elseif not hookmetamethod then
        print('[ BYPASS ] failed ❌')
    end
end)

print('[ BYPASS ] applied successfully')
