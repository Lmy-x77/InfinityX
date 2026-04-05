local Titles = {}
Titles.__index = Titles

local player = game:GetService("Players").LocalPlayer
local holder = player.PlayerGui.TitlesUI.MainFrame.Frame.Content.Holder

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
        ["Honored One"] = 17.5,
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

        ["Santa Helper"] = 15,
        ["Cupids Chosen"] = 25,
        ["Dragon Slayer"] = 30,
        ["Star Maiden"] = 50
    }
}

function Titles:GetBestLuckyTitle()
    local bestTitle = nil
    local bestValue = 0

    for titleName, value in pairs(self.AutoEquip.LuckyTitles) do
        local searchName = titleName:gsub("%s+", "")

        for _, v in pairs(holder:GetChildren()) do
            if v.Name:gsub("%s+", ""):find(searchName) then
                local txt = v:FindFirstChild("BuffButtonsHolder")
                    and v.BuffButtonsHolder:FindFirstChild("Txt")

                if txt and txt:IsA("TextLabel") and not txt.Text:find("Locked") then
                    if value > bestValue then
                        bestValue = value
                        bestTitle = titleName
                    end
                end
            end
        end
    end

    return bestTitle
end

return Titles
