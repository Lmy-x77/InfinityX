local Players = game:GetService("Players")
local GroupService = game:GetService("GroupService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer
local PlaceId, JobId, CreatorId = game.PlaceId, game.JobId, game.CreatorId
local Request = (syn and syn.request) or (http and http.request) or http_request or request

local function ServerHop()
    local Servers = {}
    local Success, Response = pcall(function()
        return Request({Url = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", PlaceId)})
    end)
    if Success and Response then
        local Data = HttpService:JSONDecode(Response.Body)
        for _, s in pairs(Data.data) do
            if s.id ~= JobId and s.playing < s.maxPlayers then
                table.insert(Servers, s.id)
            end
        end
        if #Servers > 0 then
            TeleportService:TeleportToPlaceInstance(PlaceId, Servers[math.random(1, #Servers)], LocalPlayer)
        end
    end
end

local function GetWorstRank(group)
    local min = math.huge
    for _, role in pairs(group.Roles) do
        if role.Rank < min then min = role.Rank end
    end
    return min
end

local function IsAdmin(plr)
    if plr.UserId == CreatorId then return true end
    local success, group = pcall(function()
        return GroupService:GetGroupInfoAsync(CreatorId)
    end)
    if success and group then
        local inGroup = plr:IsInGroup(CreatorId)
        local rank = plr:GetRankInGroup(group.Id)
        return inGroup and rank > GetWorstRank(group)
    end
    return false
end

local function DetectAdmins()
    for _, p in pairs(Players:GetPlayers()) do
        if IsAdmin(p) then
            ServerHop()
            return
        end
    end
end

DetectAdmins()
Players.PlayerAdded:Connect(function(p)
    if IsAdmin(p) then
        ServerHop()
    end
end)
