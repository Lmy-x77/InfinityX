local BoostedServerFinder = {}
BoostedServerFinder.__index = BoostedServerFinder

function BoostedServerFinder.new(minPlayers, maxPlayers, hopDelay)
    local self = setmetatable({}, BoostedServerFinder)

    self.HttpService = game:GetService("HttpService")
    self.TeleportService = game:GetService("TeleportService")
    self.Players = game:GetService("Players")
    self.ReplicatedStorage = game:GetService("ReplicatedStorage")

    self.MIN_PLAYERS = minPlayers or 1
    self.MAX_PLAYERS = maxPlayers or 20
    self.HOP_DELAY = hopDelay or 5

    self.WEBHOOKS = {}

    self.sentWebhook = false
    self.hopping = false
    self.monitoring = false

    return self
end

function BoostedServerFinder:AddWebhook(webhookList)
    for _, wh in pairs(webhookList) do
        if type(wh) == "table" and wh.Url and wh.Url ~= "" then
            local exists = false
            for _, existing in pairs(self.WEBHOOKS) do
                if existing.Url == wh.Url then
                    exists = true
                    break
                end
            end
            if not exists then
                table.insert(self.WEBHOOKS, {
                    Url = wh.Url,
                    Color = wh.Color or 65280,
                    Image = wh.Image or nil
                })
            end
        end
    end
end

function BoostedServerFinder:EditWebhook(url, props)
    for _, wh in pairs(self.WEBHOOKS) do
        if wh.Url == url then
            if props.Color then wh.Color = props.Color end
            if props.Image then wh.Image = props.Image end
            return true
        end
    end
    return false
end

function BoostedServerFinder:SetWebhooks(webhookList)
    self.WEBHOOKS = {}
    self:AddWebhook(webhookList)
end

function BoostedServerFinder:GetServerBoost()
    local success, value = pcall(function()
        return self.ReplicatedStorage.shared.ReplicatedData.Boosts.ServerBoost.Value
    end)

    if success and tonumber(value) and value > 0 then
        return tonumber(value)
    end

    return 0
end

function BoostedServerFinder:FormatTime(seconds)
    local totalSeconds = tonumber(seconds) or 0
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local secs = math.floor(totalSeconds % 60)
    return string.format("%02dh %02dm %02ds", hours, minutes, secs)
end

function BoostedServerFinder:SendWebhook(boostValue, jobId, playerCount)
    local formattedTime = self:FormatTime(boostValue)

    for _, wh in pairs(self.WEBHOOKS) do
        if wh.Url and wh.Url ~= "" then
            local embed = {
                ["title"] = "Boosted Server Found!",
                ["color"] = wh.Color or 65280,
                ["thumbnail"] = wh.Thumbnail and {["url"] = wh.Thumbnail} or nil,
                ["fields"] = {
                    {["name"] = "Boost Time", ["value"] = formattedTime, ["inline"] = true},
                    {["name"] = "Players", ["value"] = playerCount .. "/" .. self.MAX_PLAYERS, ["inline"] = true}
                },
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%S")
            }

            local contentMessage = "**Tap to copy:**\n`game:GetService('TeleportService'):TeleportToPlaceInstance("
                .. game.PlaceId .. ", '" .. jobId .. "')`"

            pcall(function()
                http_request({
                    Url = wh.Url,
                    Method = "POST",
                    Headers = {["Content-Type"] = "application/json"},
                    Body = self.HttpService:JSONEncode({
                        content = contentMessage,
                        username = "Boosted Server Finder",
                        avatar_url = wh.Image,
                        embeds = {embed}
                    })
                })
            end)
        end
    end
end

function BoostedServerFinder:GetServers()
    local servers = {}
    local cursor = ""
    
    repeat
        local success, response = pcall(function()
            local url = string.format(
                "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100&cursor=%s",
                game.PlaceId,
                cursor
            )
            return http_request({Url = url, Method = "GET"}).Body
        end)

        if not success or not response then break end

        local data = self.HttpService:JSONDecode(response)

        for _, server in pairs(data.data or {}) do
            if server.playing >= self.MIN_PLAYERS
            and server.playing <= self.MAX_PLAYERS
            and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end

        cursor = data.nextPageCursor or ""
    until cursor == ""

    return servers
end

function BoostedServerFinder:Hop()
    local servers = self:GetServers()
    if #servers == 0 then
        warn("No valid servers found.")
        return
    end
    local jobId = servers[math.random(1, #servers)]
    self.TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
end

function BoostedServerFinder:VerifyIfServerIsBoosted()
    local boostValue = self:GetServerBoost()

    if boostValue > 0 then
        if not self.sentWebhook then
            self.sentWebhook = true
            local playerCount = #self.Players:GetPlayers()
            self:SendWebhook(boostValue, game.JobId, playerCount)
        end
        return true
    else
        if self.sentWebhook then
            self.sentWebhook = false
        end
    end

    return false
end

function BoostedServerFinder:StartMonitoring()
    if self.monitoring then return end
    self.monitoring = true
    task.spawn(function()
        while self.monitoring do
            self:VerifyIfServerIsBoosted()
            task.wait(self.HOP_DELAY)
        end
    end)
end

function BoostedServerFinder:StartHopping()
    if self.hopping then return end
    self.hopping = true
    task.spawn(function()
        while self.hopping do
            if not self:VerifyIfServerIsBoosted() then
                self:Hop()
            end
            task.wait(self.HOP_DELAY)
        end
    end)
end

function BoostedServerFinder:Stop()
    self.hopping = false
    self.monitoring = false
end

return BoostedServerFinder
