-- intro
loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/main/Software/Custom/Intro/source.lua",true))()
wait(.8)


-- variables
local currentPlaceId = game.PlaceId
local supportedGames = {
    [{893973440}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/FleeTheFacility/src.lua',
    [{10260193230}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/MemeSea/src.lua',
    [{1962086868, 3582763398, 2127551566}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/TowerOfHell/source.lua',
    [{6284881984, 6314042276}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/AnimeMania/source.lua',
    [{72992062125248}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/Hunters/source.lua',
    [{126884695634066}] = "https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/GrowAGarden/source.lua",
    [{17850641257, 17850769550}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/AnimeSaga/source.lua',
    [{75852144330025}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/HuzzRng/source.lua',
    [{734159876, 8908228901}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/SharkBite/Loader.lua',
    [{5610197459}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/GangUpOnPeopleSimulator/source.lua',
    [{126244816328678}] = 'https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/Dig/source.lua'
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
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/main/Software/notification.lua"))()
end
warn("[ InfinityX ] - Thanks for using my script ❤️")
