local Titles = {}
Titles.__index = Titles

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GetTitlesData = Remotes:WaitForChild("GetTitlesData")

Titles.AutoEquip = {
    LuckyTitles = {
        ["Lucky Novice"] = 10,
        ["Fortune Seeker"] = 12.5,
        ["Lucky Star"] = 15,
        ["Blessed One"] = 20,
        ["The Chosen One"] = 25,
        ["Blessed Sovereign"] = 32.5,
        ["Destiny Marked"] = 40,
        ["Celestial Favor"] = 50 
    },
    DamageTitles = {
        ["Blade Master"] = 15,
        ["Living Weapon"] = 16.5,
        ["Domain Master"] = 17.5,
        ["Curse King"] = 20,
        ["Shadow Monarch"] = 25,
        ["King of Beginning"] = 27.5,
        ["Vampire King"] = 32.5,
        ["Manipulator"] = 37.5,
        ["Eminence In Shadow"] = 40,
        ["Strongest Sorcerer"] = 45,
        ["Disgraced One"] = 50,
        ["Demon Lord"] = 55,
        ["Golden King"] = 57.5,
        ["Demon King"] = 60,
        ["King of Shadows"] = 62.5,
        ["Blade Sovereign"] = 65,
        ["The One"] = 65,
        ["Astral Empress"] = 70,
        ["Transcendent Being"] = 72.5,
        ["Corrupt Tyrant"] = 75,
        ["Void Empress"] = 77.5,
        ["Battlefield Warlord"] = 80,
        ["Eminence Incarnet"] = 82.5,
        ["Six Eyed Demon"] = 85,

        -- event
        ["Santa Helper"] = 15,
        ["Cupids Chosen"] = 25,
        ["Dragon Slayer"] = 30,
        ["Star Maiden"] = 50
    }
}

function Titles:GetUnlockedTitles()
    local data = GetTitlesData:InvokeServer()
    return data and data.unlocked or {}
end

function Titles:GetBestFromList(list)
    local unlocked = self:GetUnlockedTitles()

    local bestTitle = nil
    local bestValue = 0

    for _, title in ipairs(unlocked) do
        local value = list[title]

        if value and value > bestValue then
            bestValue = value
            bestTitle = title
        end
    end

    return bestTitle, bestValue
end

function Titles:GetBestLuckyTitle()
    return self:GetBestFromList(self.AutoEquip.LuckyTitles)
end

function Titles:GetBestDamageTitle()
    return self:GetBestFromList(self.AutoEquip.DamageTitles)
end

return Titles
