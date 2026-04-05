local Players = game:GetService("Players")
local player = Players.LocalPlayer

local MyMelee = {}
local MySword = {}

local Combat = {}
Combat.__index = Combat

Combat.Items = {
    Swords = {
        "Wooden Sword","Katana","Dark Blade","Gryphon","Excalibur",
        "Solo Hunter","Slime","Manipulator","True Manipulator","Yamato",
        "Escanor","Dragon Slayer","Soul Reaper","Shadow","Shadow Monarch",
        "Atomic","Abyssal Empress"
    },
    Melees = {
        "Combat","Limitless Sorcerer","Cursed King","Qin Shi","Cursed Vessel",
        "Vampire King","Strongest of Today","Strongest in History","Madoka",
        "King of Heros","Demon King","Conqueror Haki","Blessed Maiden",
        "Corrupted Excalibur","Strongest Shinobi","Moon Slayer"
    }
}


function Combat:GetMyMelees()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()

    local function CheckTool(tool)
        local name = tool.Name
        for _, melee in ipairs(Combat.Items.Melees) do
            if name == melee then
                table.insert(MyMelee, name)
            end
        end
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            CheckTool(tool)
        end
    end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            CheckTool(tool)
        end
    end
end

function Combat:GetMySword()
    local backpack = player:WaitForChild("Backpack")
    local character = player.Character or player.CharacterAdded:Wait()

    local function CheckTool(tool)
        local name = tool.Name
        for _, sword in ipairs(Combat.Items.Swords) do
            if name == sword then
                table.insert(MySword, name)
            end
        end
    end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            CheckTool(tool)
        end
    end

    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            CheckTool(tool)
        end
    end
end

function Combat:GetValues()
    Combat:GetMyMelees()
    Combat:GetMySword()
end

return Combat
