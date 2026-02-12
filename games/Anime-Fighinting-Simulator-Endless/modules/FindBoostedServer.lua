pcall(function() assert(cloneref or game.Players.LocalPlayer:Kick("Your exploit doesn't support cloneref")) end)
local Workspace                = cloneref(game:GetService("Workspace"));
local Players                  = cloneref(game:GetService("Players"));
local ReplicatedStorage        = cloneref(game:GetService("ReplicatedStorage"));
local ReplicatedFirst          = cloneref(game:GetService("ReplicatedFirst"));
local TweenService             = cloneref(game:GetService("TweenService"));
local RunService               = cloneref(game:GetService("RunService"));
local TeleportService          = cloneref(game:GetService("TeleportService"));
local HttpService              = cloneref(game:GetService("HttpService"));
local VirtualUser              = cloneref(game:GetService("VirtualUser"));
local UserInputService         = cloneref(game:GetService("UserInputService"));
local VirtualInputManager      = cloneref(game:GetService("VirtualInputManager"));

local WEBHOOK_URLS = {
    "https://discord.com/api/webhooks/1471527334837223719/JR4hIesMKaLMTEtrl5zvmTjJo85XpISl406dd9iGON8mi5XvWCqbOHLfNR3Q3jmeRMT5",
    ""
}

local http_request = (syn and syn.request) or (http and http.request) or (request and request) or http_request

local HOP_DELAY = 5
local MIN_PLAYERS = 20
local MAX_PLAYERS = 24

local boostHopping = true
local sentWebhook = false

local function getServerBoost()
    local success, value = pcall(function()
        return ReplicatedStorage.shared.ReplicatedData.Boosts.ServerBoost.Value
    end)
    if success and tonumber(value) and value > 0 then
        return tonumber(value)
    end
    return 0
end

local function formatTime(seconds)
    local totalSeconds = tonumber(seconds) or 0
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local secs = math.floor(totalSeconds % 60)

    return string.format("%02dh %02dm %02ds", hours, minutes, secs)
end

local function sendWebhook(boostValue, jobId, playerCount)
    local formattedTime = formatTime(boostValue)

    for _, WEBHOOK_URL in pairs(WEBHOOK_URLS) do
        if type(WEBHOOK_URL) == "string" and WEBHOOK_URL ~= "" then
            local embed = {
                ["embeds"] = {{
                    ["title"] = "Boosted Server Found!",
                    ["description"] = "A server with active boost has been discovered",
                    ["color"] = 65280,
                    ["fields"] = {
                        {
                            ["name"] = "Boost Time",
                            ["value"] = formattedTime,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Players",
                            ["value"] = playerCount .. "/" .. MAX_PLAYERS,
                            ["inline"] = true
                        },
                        {
                            ["name"] = "Job ID",
                            ["value"] = "```" .. jobId .. "```",
                            ["inline"] = false
                        },
                        {
                            ["name"] = "Join Command",
                            ["value"] = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(" .. game.PlaceId .. ", '" .. jobId .. "')```",
                            ["inline"] = false
                        }
                    },
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
                }}
            }

            pcall(function()
                http_request({
                    Url = WEBHOOK_URL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(embed)
                })
            end)
        end
    end
end

local function getServers()
    local servers = {}
    local success, response = pcall(function()
        local url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
            game.PlaceId
        )
        return http_request({Url = url, Method = "GET"}).Body
    end)

    if success and response then
        local data = HttpService:JSONDecode(response)
        for _, server in pairs(data.data or {}) do
            if server.playing >= MIN_PLAYERS
                and server.playing <= MAX_PLAYERS
                and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end
    end

    return servers
end

local function hop()
    local servers = getServers()
    if #servers == 0 then
        TeleportService:Teleport(game.PlaceId)
        return
    end
    local jobId = servers[math.random(1, #servers)]
    TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
end

local function checkServer()
    local boostValue = getServerBoost()
    if boostValue > 0 then
        if not sentWebhook then
            sentWebhook = true
            boostHopping = false
            local playerCount = #Players:GetPlayers()
            sendWebhook(boostValue, game.JobId, playerCount)
        end
    else
        hop()
    end
end

RunService.Heartbeat:Connect(function()
    if boostHopping then
        checkServer()
        task.wait(HOP_DELAY)
    end
end)
