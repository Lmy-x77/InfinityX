local CheatDetectionCore = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/CheatDetectionCore/source.lua"))()
CheatDetectionCore:RemoteTracker({
    BlackList = {"kick","ban","anti","logger","bypass","exploit"},
    Type = "All",
    SuspectsCharacters = {"@","_","!","?","#","(",")","*","-"}
})
CheatDetectionCore:HookRemote({
    Path = game:GetService("ReplicatedFirst").KickPlayer,
    Type = "RemoteFunction",
    Args = {enabled = true, List = {
        [1] = "Kick by remote",
        [2] = game.Players.LocalPlayer,
        [3] = "lol"
    }}
})
CheatDetectionCore:ScriptTracker({
    BlackList = {"anti","kick","ban","detect","logger"},
    Type = "All",
    SuspectsCharacters = {"@","_","!","?","#","(",")","*","-"}
})
CheatDetectionCore:InterceptFunction({
    Path = game.Players.LocalPlayer.PlayerScripts.AntiCheat,
    Type = "LocalScript",
    Name = "KickPlayer",
    Replacement = function(...)
        return nil
    end
})
