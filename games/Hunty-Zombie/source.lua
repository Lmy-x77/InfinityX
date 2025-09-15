local placeid = { [1] = 103754275310547, [2] = 86076978383613}
local currentPlace = game.PlaceId
if currentPlace == placeid[1] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Hunty-Zombie/Places/Place1.lua",true))()

elseif currentPlace == placeid[2] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Hunty-Zombie/Places/Place2.lua",true))()
end
