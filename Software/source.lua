-- intro
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Custom/Intro/source.lua",true))()
wait(.8)


-- variables
local currentPlaceId = game.PlaceId
local supportedGames = {
    [{893973440}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Flee-The-Facility/source.lua',
    [{10260193230}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Meme-Sea/source.lua',
    [{1962086868, 3582763398, 2127551566, 94971861814985}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Tower-of-Hell/source.lua',
    [{6284881984, 6314042276}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Mania/source.lua',
    [{72992062125248}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Hunters/source.lua',
    [{126884695634066}] = "https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Grow-a-Garden/source.lua",
    [{17850641257, 17850769550}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Saga/source.lua',
    [{75852144330025}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Huzz-Rng/source.lua',
    [{734159876, 8908228901}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Shark-Bite/source.lua',
    [{5610197459}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Gang-Up-On-People-Simulator/source.lua',
    [{126244816328678}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Dig/source.lua',
    [{537413528}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Build-a-Boat-For-Treasure/source.lua',
    [{79546208627805, 126509999114328}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/99-Nights-in-the-Forest/source.lua',
    [{3101667897, 3232996272, 3276265788}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Legend-of-Speed/source.lua',
    [{6137321701, 6348640020}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Blair/source.lua',
    [{103754275310547, 86076978383613}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Hunty-Zombie/source.lua',
    [{130247632398296}] = 'https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Fighinting-Simulator-Endless/source.lua'
}
local function findScript()
    for key, scriptUrl in pairs(supportedGames) do
        if typeof(key) == "table" then
            for _, id in ipairs(key) do
                if id == currentPlaceId then
                    return scriptUrl
                end
            end
        elseif key == currentPlaceId then
            return scriptUrl
        end
    end
    return nil
end


-- detect game
local scriptUrl = findScript()
if scriptUrl then
    print("[ InfinityX ] - Game supported 🟢")
    loadstring(game:HttpGet(scriptUrl))()
else
    print("[ InfinityX ] - Game not supported 🔴")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Items/notification.lua"))()
end
warn("[ InfinityX ] - Thanks for using my script ❤️")
