local BoostedServerFinder = {}
BoostedServerFinder.__index = BoostedServerFinder

function BoostedServerFinder.new(minPlayers, maxPlayers, hopDelay)
    local self = setmetatable({}, BoostedServerFinder)

    self.HttpService = cloneref(game:GetService("HttpService"))
    self.TeleportService = cloneref(game:GetService("TeleportService"))
    self.Players = cloneref(game:GetService("Players"))
    self.ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))

    self.MIN_PLAYERS = minPlayers or 1
    self.MAX_PLAYERS = maxPlayers or 20
    self.HOP_DELAY = hopDelay or 5

    self.WEBHOOKS = {}

    self.sentWebhook = false
    self.monitoring = false
    self.hopping = false

    return self
end

function BoostedServerFinder:AddWebhook(webhookList)
    for _, wh in pairs(webhookList) do
        if type(wh) == "table" and wh.Url and wh.Url ~= "" then
            table.insert(self.WEBHOOKS, {
                Url = wh.Url,
                Color = wh.Color or 65280,
                Image = wh.Image
            })
        end
    end
end

function BoostedServerFinder:IsPrivateServer()
    local success, id = pcall(function()
        return game.PrivateServerId
    end)

    if success and id and id ~= "" and game.PrivateServerOwnerId ~= 0 then
        return true
    end

    return false
end

function BoostedServerFinder:GetServerType()
    if self:IsPrivateServer() then
        return "Private Server", 16776960
    else
        return "Public Server", 65280
    end
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
    local days = math.floor(totalSeconds / 86400)
    local hours = math.floor((totalSeconds % 86400) / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local secs = math.floor(totalSeconds % 60)

    local parts = {}
    if days > 0 then table.insert(parts, days .. "d") end
    if hours > 0 or days > 0 then table.insert(parts, hours .. "h") end
    if minutes > 0 or hours > 0 or days > 0 then table.insert(parts, minutes .. "m") end
    table.insert(parts, secs .. "s")

    return table.concat(parts, " ")
end

function BoostedServerFinder:GetWebhook(url)
    if url == "https://discord.com/api/webhooks/1471852000399331370/7iivrjq_Cvhdw-8fzGHvXArJKM3AmzJp86xyhiWlDSURIu5dfOb-nNVNGj2uuXFd1Dso" then
        return "InfinityX"
    elseif url == "https://discord.com/api/webhooks/1471535113274789958/0sYh5fB9vp7qjwuYcej_DzSn3qEp32ErNivoQqHgYHo7JxniIeVPNhZT53Febo0JLxdQ" then
        return "Shadow Hub"
    end

    return "Unknown"
end

function BoostedServerFinder:SendWebhook(boostValue, jobId, playerCount)
    local formattedTime = self:FormatTime(boostValue)
    local serverType, embedColor = self:GetServerType()

    local robloxLink = string.format(
        "https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s",
        game.PlaceId,
        jobId
    )

    local currentTime = os.date("*t")
    local timestamp = string.format(
        "%04d-%02d-%02dT%02d:%02d:%02dZ",
        currentTime.year,
        currentTime.month,
        currentTime.day,
        currentTime.hour,
        currentTime.min,
        currentTime.sec
    )

    for _, wh in pairs(self.WEBHOOKS) do
        pcall(function()

            local webhookName = self:GetWebhook(wh.Url)

            request({
                Url = wh.Url,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = self.HttpService:JSONEncode({

                    username = webhookName,
                    avatar_url = wh.Thumbnail or wh.Image,

                    embeds = {{
                        title = "🚀 Boosted Server Found!",
                        description = "Active boosted server detected.",
                        color = wh.Color or embedColor,
                        thumbnail = wh.Image and { url = wh.Image } or nil,
                        fields = {
                            {
                                name = "⏰ Boost Time Remaining",
                                value = "```" .. formattedTime .. "```",
                                inline = true
                            },
                            {
                                name = "👥 Players",
                                value = "```" .. playerCount .. "/" .. self.MAX_PLAYERS .. "```",
                                inline = true
                            },
                            {
                                name = "🌐 Server Type",
                                value = "```" .. serverType .. "```",
                                inline = true
                            },
                            {
                                name = "🆔 Job ID",
                                value = "```" .. jobId .. "```",
                                inline = false
                            },
                            {
                                name = "🔗 Direct Join",
                                value = "[Click here to join](" .. robloxLink .. ")",
                                inline = false
                            },
                            {
                                name = "💻 Join via Script",
                                value = "```lua\ngame:GetService('TeleportService'):TeleportToPlaceInstance(" 
                                    .. game.PlaceId .. ", '" .. jobId .. "')```",
                                inline = false
                            }
                        },
                        footer = {
                            text = webhookName .. " • Boost Finder"
                        },
                        timestamp = timestamp
                    }}
                })
            })
        end)
    end
end

function BoostedServerFinder:GetServers()
    local servers = {}
    local cursor = nil

    repeat
        local url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=100"
        if cursor then
            url = url .. "&cursor=" .. cursor
        end

        local success, response = pcall(function()
            return request({
                Url = url,
                Method = "GET"
            }).Body
        end)

        if not success or not response then break end

        local data = self.HttpService:JSONDecode(response)

        for _, server in pairs(data.data or {}) do
            if server.playing >= self.MIN_PLAYERS
            and server.playing < server.maxPlayers
            and server.id ~= game.JobId then
                table.insert(servers, server.id)
            end
        end

        cursor = data.nextPageCursor
    until not cursor

    return servers
end

function BoostedServerFinder:Hop()
    local servers = self:GetServers()
    if #servers == 0 then return end
    local jobId = servers[math.random(1, #servers)]
    self.TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
end

function BoostedServerFinder:VerifyIfServerIsBoosted()
    local boostValue = self:GetServerBoost()

    if boostValue > 0 then
        if not self.sentWebhook then
            self.sentWebhook = true
            self:SendWebhook(boostValue, game.JobId, #self.Players:GetPlayers())
        end
        return true
    else
        self.sentWebhook = false
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
    self.monitoring = false
    self.hopping = false
end

return BoostedServerFinder
