local places = {
  Lobby = 17850641257,
  Dungeon = 17850769550
}


if game.PlaceId == places.Lobby then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/AnimeSaga/Places/lobby.lua", true))()
elseif game.PlaceId == places.Dungeon then
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/AnimeSaga/Places/dungeon.lua", true))()
end
