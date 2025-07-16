local placeId = {
  Game1 = 734159876,
  Game2 = 8908228901
}


if game.PlaceId == placeId.Game1 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Shark-Bite/Place-Id/Game1.lua", true))()
elseif game.PlaceId == placeId.Game2 then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Shark-Bite/Place-Id/Game2.lua", true))()
end
