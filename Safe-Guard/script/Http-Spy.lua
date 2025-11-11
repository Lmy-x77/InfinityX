local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")

local suspiciousPatterns = {
    "localhost",
    "127.0.0.1",
    "192.168.",
    "10.",
    "169.254.",
    "discord.gg/",
    "pastebin.com/",
    "raw.githubusercontent.com/",
    "ngrok.io",
    "repl.co",
    "glitch.me",
    "example.com/spy",
}
local whitelist = {
    "roblox.com",
    "api.roblox.com",
}

local function normalize(s)
    if not s then return "" end
    return tostring(s):lower():gsub("^%s+",""):gsub("%s+$","")
end

local function percentDecode(s)
    return (s:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex,16)) end))
end

local function isWhitelisted(str)
    str = normalize(str)
    for _, w in ipairs(whitelist) do
        if str:find(w, 1, true) then return true end
    end
    return false
end

local function containsSuspicious(value)
    local t = typeof(value)
    if t == "string" or t == "Instance" then
        local s = normalize(tostring(value))
        s = percentDecode(s)
        if isWhitelisted(s) then return false end
        for _, pat in ipairs(suspiciousPatterns) do
            if s:find(pat, 1, true) then
                return true, pat, s
            end
        end
        if s:match("%d+%.%d+%.%d+%.%d+") then
            for _, pat in ipairs({"127.", "192.168.", "10.", "169.254."}) do
                if s:find(pat, 1, true) then
                    return true, pat, s
                end
            end
        end
        return false
    elseif t == "table" then
        for k,v in pairs(value) do
            local found, matched, full = containsSuspicious(k)
            if found then return true, matched, full end
            found, matched, full = containsSuspicious(v)
            if found then return true, matched, full end
        end
        return false
    else
        return false
    end
end

local function fakeRequestResponse()
    return {
        Success = false,
        StatusCode = 403,
        StatusMessage = "Forbidden",
        Body = "",
        Headers = {},
    }
end

local ok, mt = pcall(function() return getrawmetatable(HttpService) end)
if not ok or not mt then
    return
end

setreadonly(mt, false)
local oldNamecall = mt.__namecall
mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if self == HttpService and (method == "RequestAsync" or method == "Request" or method == "GetAsync" or method == "PostAsync") then
        local args = {...}
        local candidates = {}
        if #args >= 1 then table.insert(candidates, args[1]) end
        if type(args[1]) == "table" then
            table.insert(candidates, args[1].Url or args[1].url or args[1].Endpoint)
            table.insert(candidates, args[1].Body or args[1].body)
        end
        if #args >= 2 then table.insert(candidates, args[2]) end

        for _, cand in ipairs(candidates) do
            local found, matchedPattern, full = containsSuspicious(cand)
            if found then
                if method == "RequestAsync" or method == "Request" then
                    return fakeRequestResponse()
                else
                    return ""
                end
            end
        end
    end

    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
