local places = {
  Lobby = 17850641257,
  Dungeon = 17850769550
}


if game.PlaceId == places.Lobby then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Saga/Place-Id/Lobby.lua", true))()
elseif game.PlaceId == places.Dungeon then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Saga/Place-Id/Dungeon.lua", true))()
end
