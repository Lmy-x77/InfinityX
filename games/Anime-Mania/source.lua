-- detect service
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
  print("Mobile device")
elseif not IsOnMobile then
  print("Computer device")
end



-- start
print[[                                                                     
 /$$$$$$            /$$$$$$  /$$           /$$   /$$               /$$   /$$
|_  $$_/           /$$__  $$|__/          |__/  | $$              | $$  / $$
  | $$   /$$$$$$$ | $$  \__/ /$$ /$$$$$$$  /$$ /$$$$$$   /$$   /$$|  $$/ $$/
  | $$  | $$__  $$| $$$$    | $$| $$__  $$| $$|_  $$_/  | $$  | $$ \  $$$$/ 
  | $$  | $$  \ $$| $$_/    | $$| $$  \ $$| $$  | $$    | $$  | $$  >$$  $$ 
  | $$  | $$  | $$| $$      | $$| $$  | $$| $$  | $$ /$$| $$  | $$ /$$/\  $$
 /$$$$$$| $$  | $$| $$      | $$| $$  | $$| $$  |  $$$$/|  $$$$$$$| $$  \ $$
|______/|__/  |__/|__/      |__/|__/  |__/|__/   \___/   \____  $$|__/  |__/
                                                         /$$  | $$          
                                                        |  $$$$$$/          
                                                         \______/           
]]



-- source
pcall(function()
  loadstring(game:HttpGet('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Mania/Bypass.lua'))()
end)
wait(.5)

local placeIds = {
    Main = 6284881984,
    Arena = 6314042276
}

if game.PlaceId == placeIds.Main then
  loadstring(game:HttpGet('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Mania/Main/Lobby.lua'))()
elseif game.PlaceId == placeIds.Arena then
  loadstring(game:HttpGet('https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Mania/Main/source.lua'))()
end



warn('[InfinityX] - Loaded!')
