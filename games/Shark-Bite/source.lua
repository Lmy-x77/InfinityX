local placeId = {
  Game1 = 734159876,
  Game2 = 8908228901
}


if game.PlaceId == placeId.Game1 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/SharkBite/Game1/source.lua", true))()
elseif game.PlaceId == placeId.Game2 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/SharkBite/Game2/source.lua", true))()
end
