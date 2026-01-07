loadstring(game:HttpGet("https://raw.githubusercontent.com/Pixeluted/adoniscries/main/Source.lua",true))()

for _, v in pairs(game.CoreGui:GetDescendants()) do
    if v.Name == 'NotificationFrame' or v.Name == 'NotificationGui' then
        v:Destroy()
    end
end
game.CoreGui.DescendantAdded:Connect(function(v)
    if v.Name == 'NotificationFrame' or v.Name == 'NotificationGui' then
        v:Destroy()
    end
end)

local placeid = { [1] = 103754275310547, [2] = 86076978383613}
local currentPlace = game.PlaceId
if currentPlace == placeid[1] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Hunty-Zombie/Places/lobby.lua",true))()
elseif currentPlace == placeid[2] then
	loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Hunty-Zombie/Places/arena.lua",true))()
end
