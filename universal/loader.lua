--[[
	getgenv().UiLibrary = {
    	['ReGui'] = true,
    	['Fluriore'] = false
	}
]]

if getgenv().UiLibrary['ReGui'] then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/universal/mudules/ReGui/source.lua'))()
elseif getgenv().UiLibrary['Fluriore'] then
    loadstring(game:HttpGetAsync('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/universal/mudules/Fluriore/source.lua'))()
end
