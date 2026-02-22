local ServerFinder = {}
ServerFinder.__index = ServerFinder

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

function ServerFinder.new(minPlayers, maxPlayers, hopDelay)
    local self = setmetatable({}, ServerFinder)

    self.HttpService = HttpService
    self.TeleportService = TeleportService
    self.Players = Players
    self.ReplicatedStorage = ReplicatedStorage

    self.MIN_PLAYERS = minPlayers or 1
    self.MAX_PLAYERS = maxPlayers or 20
    self.HOP_DELAY = hopDelay or 5

    self.Webhooks = {}

    self.sentWebhook = false
    self.monitoring = false
    self.hopping = false

    return self
end

function ServerFinder:AddWebhook(webhookList)
    if type(webhookList) ~= "table" then return end
    if not self.Webhooks then
        self.Webhooks = {}
    end

    for _, wh in pairs(webhookList) do
        if type(wh) == "table" and wh.Url and wh.Url ~= "" then
            table.insert(self.Webhooks, {
                Url = wh.Url,
                Type = wh.Type or "All",
                Color = wh.Color or 65280,
                Image = wh.Image,
                Thumbnail = wh.Thumbnail
            })
        end
    end
end

function ServerFinder:ShouldSendToWebhook(wh, eventType)
    if not wh.Type or string.lower(wh.Type) == "all" then
        return true
    end

    return string.lower(wh.Type) == string.lower(eventType)
end

function ServerFinder:IsPrivateServer()
    local success, id = pcall(function()
        return game.PrivateServerId
    end)

    if success and id and id ~= "" and game.PrivateServerOwnerId ~= 0 then
        return true
    end

    return false
end

function ServerFinder:GetServerType()
    local isPrivate = game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0
    local isReserved = game.PrivateServerId ~= "" and game.PrivateServerOwnerId == 0

    local serverType = "Public Server"
    local color = 65280

    if isPrivate then
        serverType = "Private Server"
        color = 255
    elseif isReserved then
        serverType = "Reserved Server"
        color = 16776960
    end

    if rawget(_G, "IsBoostedServer") and _G.IsBoostedServer == true then
        serverType = "Boosted Server"
        color = 16711680
    end

    return serverType, color
end

function ServerFinder:GetServerBoost()
    local success, value = pcall(function()
        return self.ReplicatedStorage.shared.ReplicatedData.Boosts.ServerBoost.Value
    end)

    if success and tonumber(value) and value > 0 then
        return tonumber(value)
    end

    return 0
end

function ServerFinder:GetWhitehairTier()
    for _, model in ipairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model.Name:find("Whitehair") then
            local hum = model:FindFirstChildOfClass("Humanoid")
            if hum and hum.MaxHealth then
                local hp = hum.MaxHealth
                if hp == 5000 then return 1 end
                if hp == 15000 then return 2 end
                if hp == 35000 then return 3 end
            end

            local tierVal = model:FindFirstChild("Tier") or model:FindFirstChildOfClass("IntValue")
            if tierVal and tierVal.Value then
                return tierVal.Value
            end

            return 1
        end
    end

    return nil
end

function ServerFinder:GetSpawnedFruits()
    local fruits = {}

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:lower():find("fruit") then
            table.insert(fruits, obj.Name)
        end
    end

    return fruits
end

function ServerFinder:FormatTime(seconds)
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

function ServerFinder:GetWebhook(url)
    if url == "https://discord.com/api/webhooks/1471852000399331370/7iivrjq_Cvhdw-8fzGHvXArJKM3AmzJp86xyhiWlDSURIu5dfOb-nNVNGj2uuXFd1Dso"
    or url == "https://discord.com/api/webhooks/1475107963453571142/kc4cCEUrnqbw4YdQ6u-T65trpHmwBBCYRW3ICyMG-qmWoiXVpJxhMpkO-MLN6slyh_p9"
    or url == "https://discord.com/api/webhooks/1475108051362254928/QaGTRGQSkzaK_ghfElS1_kFpwviF4XPfNZS4MIW2VTAv-61E-OubJP5n_uhsQO33z1TA" then
        return "InfinityX"

    elseif url == "https://discord.com/api/webhooks/1471535113274789958/0sYh5fB9vp7qjwuYcej_DzSn3qEp32ErNivoQqHgYHo7JxniIeVPNhZT53Febo0JLxdQ"
    or url == "https://discord.com/api/webhooks/1473590493668577322/h4EmHJp4DnqN1xjj1hWazF7YAuRlIqnR4PHGN5n180d62nMp3_g5sWYZFAtqTs6_NbXJ"
    or url == "https://discord.com/api/webhooks/1474349938296094741/C5QraFurmC4GeXGHcV30LEa8ome2xG4k1ff6sXnlZLrmOG0wKHpqHyOMg3lUZ1QMpk2j" then
        return "Shadow Hub"
    end

    return "Unknown"
end

function ServerFinder:SendWebhook(boostValue, jobId, playerCount)
    local formattedTime = self:FormatTime(boostValue)
    local serverType, embedColor = self:GetServerType()

    local robloxLink = string.format(
        "https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s",
        game.PlaceId,
        jobId
    )

    for _, wh in pairs(self.WEBHOOKS) do
        if self:ShouldSendToWebhook(wh, "BoostServer") then
            pcall(function()
                request({
                    Url = wh.Url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = self.HttpService:JSONEncode({
                        username = "Boost Server Notifier",
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
                                    value = "```" .. playerCount .. "```",
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
end

function ServerFinder:SendWhitehairWebhook(tier)
    local tierLabel = tier == 3 and "TIER 3"
        or (tier == 2 and "TIER 2" or "TIER 1")

    local serverType = select(1, self:GetServerType())

    local joinLink = string.format(
        "https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s",
        game.PlaceId,
        game.JobId
    )

    local now = os.date("!*t")
    local isoTime = string.format(
        "%04d-%02d-%02dT%02d:%02d:%02dZ",
        now.year, now.month, now.day,
        now.hour, now.min, now.sec
    )

    for _, wh in pairs(self.Webhooks) do
        if self:ShouldSendToWebhook(wh, "Boss") then

            local webhookName = self:GetWebhook(wh.Url)

            local authorName =
                webhookName == "InfinityX" and "InfinityX | Whitehair Spawn Notifier"
                or webhookName == "Shadow Hub" and "Shadow Hub | Whitehair Spawn Notifier"
                or "Whitehair Spawn Notifier"

            local embed = {
                title = "WHITEHAIR WORLD BOSS  |  " .. tierLabel,
                description = "**Whitehair World Boss has spawned!**",
                color = (tier == 3 and 16711680)
                    or (tier == 2 and 16753920)
                    or 5025616,

                author = {
                    name = authorName,
                    icon_url = wh.Image
                },

                thumbnail = {
                    url = wh.Thumbnail
                },

                fields = {
                    {
                        name = "🌐 Server Type",
                        value = "```" .. serverType .. "```",
                        inline = true
                    },
                    {
                        name = "👥 Players",
                        value = "```" .. #Players:GetPlayers() .. " / 24```",
                        inline = true
                    },
                    {
                        name = "🔰 TIER",
                        value = "```" .. tierLabel .. "```",
                        inline = true
                    },
                    {
                        name = "🆔 Job ID",
                        value = "```fix\n" .. game.JobId .. "```",
                        inline = false
                    },
                    {
                        name = "🔗 Direct Join Link",
                        value = "[Click here to join the server](" .. joinLink .. ")",
                        inline = false
                    },
                    {
                        name = "💻 Join via Script",
                        value = "```lua\nlocal ts = game:GetService('TeleportService')\nts:TeleportToPlaceInstance(" 
                            .. game.PlaceId .. ", \"" .. game.JobId .. "\")```",
                        inline = false
                    }
                },

                footer = {
                    text = webhookName .. " | Whitehair Spawn Notifier | " .. os.date("%b %d, %Y  %H:%M UTC"),
                    icon_url = wh.Image
                },

                timestamp = isoTime
            }

            local payload = {
                username = webhookName,
                avatar_url = wh.Thumbnail,
                embeds = { embed }
            }

            pcall(function()
                request({
                    Url = wh.Url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end
    end
end

function ServerFinder:SendFruitWebhook(fruitName)
    local serverType = select(1, self:GetServerType())

    local joinLink = string.format(
        "https://www.roblox.com/games/start?placeId=%d&gameInstanceId=%s",
        game.PlaceId,
        game.JobId
    )

    local now = os.date("!*t")
    local isoTime = string.format(
        "%04d-%02d-%02dT%02d:%02d:%02dZ",
        now.year, now.month, now.day,
        now.hour, now.min, now.sec
    )

    for _, wh in pairs(self.Webhooks) do
        if self:ShouldSendToWebhook(wh, "Fruit") then

            local webhookName = self:GetWebhook(wh.Url)

            local authorName =
                webhookName == "InfinityX" and "InfinityX | Fruit Spawn Notifier"
                or webhookName == "Shadow Hub" and "Shadow Hub | Fruit Spawn Notifier"
                or "Fruit Spawn Notifier"

            local embed = {
                title = "FRUIT SPAWN DETECTED",
                description = "**A rare fruit has appeared in this server!**",
                color = wh.Color or 10846687,

                author = {
                    name = authorName,
                    icon_url = wh.Image
                },

                thumbnail = {
                    url = wh.Thumbnail
                },

                fields = {
                    {
                        name = "🍎 Fruit",
                        value = "```" .. tostring(fruitName) .. "```",
                        inline = true
                    },
                    {
                        name = "🌐 Server Type",
                        value = "```" .. serverType .. "```",
                        inline = true
                    },
                    {
                        name = "👥 Players",
                        value = "```" .. #Players:GetPlayers() .. " / 24```",
                        inline = true
                    },
                    {
                        name = "🆔 Job ID",
                        value = "```fix\n" .. game.JobId .. "```",
                        inline = false
                    },
                    {
                        name = "🔗 Direct Join Link",
                        value = "[Click here to join the server](" .. joinLink .. ")",
                        inline = false
                    },
                    {
                        name = "💻 Join via Script",
                        value = "```lua\nlocal ts = game:GetService('TeleportService')\nts:TeleportToPlaceInstance(" 
                            .. game.PlaceId .. ", \"" .. game.JobId .. "\")```",
                        inline = false
                    }
                },

                footer = {
                    text = webhookName .. " | Fruit Spawn Notifier | " .. os.date("%b %d, %Y  %H:%M UTC"),
                    icon_url = wh.Image
                },

                timestamp = isoTime
            }

            local payload = {
                username = webhookName,
                avatar_url = wh.Thumbnail,
                embeds = { embed }
            }

            pcall(function()
                request({
                    Url = wh.Url,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = HttpService:JSONEncode(payload)
                })
            end)
        end
    end
end

function ServerFinder:GetServers()
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

function ServerFinder:Hop()
    local servers = self:GetServers()
    if #servers == 0 then return end
    local jobId = servers[math.random(1, #servers)]
    self.TeleportService:TeleportToPlaceInstance(game.PlaceId, jobId)
end

function ServerFinder:VerifyIfServerIsBoosted()
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

function ServerFinder:StartMonitoring()
    if self.monitoring then return end
    self.monitoring = true

    local boostSent = false
    local whitehairSent = false
    local fruitSent = false

    task.spawn(function()
        while self.monitoring do
            local boostValue = self:GetServerBoost()
            if boostValue > 0 and not boostSent then
                boostSent = true
                self:SendWebhook(boostValue, game.JobId, #self.Players:GetPlayers())
            elseif boostValue <= 0 then
                boostSent = false
            end

            local tier = self:GetWhitehairTier()
            if tier and not whitehairSent then
                whitehairSent = true
                self:SendWhitehairWebhook(tier)
            elseif not tier then
                whitehairSent = false
            end

            local fruits = self:GetSpawnedFruits()
            if #fruits > 0 and not fruitSent then
                fruitSent = true
                local fruitNames = {}
                for _, fruit in pairs(fruits) do
                    if type(fruit) == "table" and fruit.Name then
                        table.insert(fruitNames, fruit.Name)
                    else
                        table.insert(fruitNames, tostring(fruit))
                    end
                end
                self:SendFruitWebhook(table.concat(fruitNames, ", "))
            
            elseif #fruits == 0 then
                fruitSent = false
            end

            task.wait(self.HOP_DELAY)
        end
    end)
end

function ServerFinder:StartHopping()
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

function ServerFinder:Stop()
    self.monitoring = false
    self.hopping = false
end

return ServerFinder
