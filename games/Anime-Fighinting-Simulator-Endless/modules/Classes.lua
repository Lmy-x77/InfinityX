local Workspace = cloneref(game:GetService("Workspace"));
local Players = cloneref(game:GetService("Players"));

local MyStrength = Players.LocalPlayer.Stats["1"].Value
local MyDurability = Players.LocalPlayer.Stats["2"].Value
local MyChakra = Players.LocalPlayer.Stats["3"].Value

local Classes = {}
Classes.__index = Classes

function Classes:GetClasses()
    return {
        Classes = {
            {
                Name = "Shinobi",
                Requirements = {1000, 1000, 1000},
                Cost = 100,
                YenPerMin = 10,
                YenIncrease = 1.06,
                Icon = "rbxassetid://4255679655",
                Color = Color3.fromRGB(75, 151, 75),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1000, 1000}, Awards = {Yen = 3000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {2, 5}, Awards = {Yen = 2000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Pirate",
                Requirements = {1e4, 1e4, 1e4},
                Cost = 500,
                YenPerMin = 25,
                YenIncrease = 1.09,
                Icon = "rbxassetid://4255680247",
                Color = Color3.fromRGB(111, 94, 81),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {10000, 10000}, Awards = {Yen = 7500, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {2, 5}, Awards = {Yen = 5000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Ghoul",
                Requirements = {100000, 100000, 100000},
                Cost = 1500,
                YenPerMin = 50,
                YenIncrease = 1.13,
                Icon = "rbxassetid://4255681175",
                Color = Color3.fromRGB(196, 40, 28),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {100000, 100000}, Awards = {Yen = 15000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {2, 5}, Awards = {Yen = 10000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Hero",
                Requirements = {1000000, 1000000, 1000000},
                Cost = 5000,
                YenPerMin = 100,
                YenIncrease = 1.18,
                Icon = "rbxassetid://4255752224",
                Color = Color3.fromRGB(13, 105, 172),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1000000, 1000000}, Awards = {Yen = 30000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {3, 8}, Awards = {Yen = 20000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Reaper",
                Requirements = {1e7,1e7,1e7},
                Cost = 25000,
                YenPerMin = 500,
                YenIncrease = 1.24,
                Icon = "rbxassetid://4255684576",
                Color = Color3.fromRGB(107, 50, 124),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {10000000, 10000000}, Awards = {Yen = 150000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {3, 8}, Awards = {Yen = 100000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Saiyan",
                Requirements = {1000000000, 1000000000, 1000000000},
                Cost = 100000,
                YenPerMin = 1000,
                YenIncrease = 7.5,
                Icon = "rbxassetid://4255711550",
                Color = Color3.fromRGB(255, 176, 0),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {2500000000, 2500000000}, Awards = {Yen = 300000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {3, 8}, Awards = {Yen = 200000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Sin",
                Requirements = {100000000000, 100000000000, 100000000000},
                Cost = 250000,
                YenPerMin = 2500,
                YenIncrease = 18.75,
                Icon = "rbxassetid://4341141195",
                Color = Color3.fromRGB(26, 0, 49),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e11, 1e11}, Awards = {Yen = 750000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 10}, Awards = {Yen = 500000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Magi",
                Requirements = {1000000000000, 1000000000000, 1000000000000},
                Cost = 1000000,
                YenPerMin = 10000,
                YenIncrease = 75,
                Icon = "rbxassetid://4341113762",
                Color = Color3.fromRGB(55, 88, 130),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {2.5e12, 2.5e12}, Awards = {Yen = 3000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {10, 15}, Awards = {Yen = 2000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Akuma",
                Requirements = {100000000000000, 100000000000000, 100000000000000},
                Cost = 5000000,
                YenPerMin = 45000,
                YenIncrease = 324,
                Icon = "rbxassetid://4341124667",
                Color = Color3.fromRGB(196, 40, 28),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e14, 1e14}, Awards = {Yen = 13500000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {10, 15}, Awards = {Yen = 9000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Yonko",
                Requirements = {1000000000000000, 1000000000000000, 1000000000000000},
                Cost = 24750000,
                YenPerMin = 100000,
                YenIncrease = 1080,
                Icon = "rbxassetid://4469165966",
                Color = Color3.fromRGB(27, 42, 53),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {2.5e15, 2.5e15}, Awards = {Yen = 30000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {10, 15}, Awards = {Yen = 20000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Gorosei",
                Requirements = {1e17, 1e17, 1e17},
                Cost = 62000000,
                YenPerMin = 250000,
                YenIncrease = 2700,
                Icon = "rbxassetid://4517596949",
                Color = Color3.fromRGB(0, 32, 96),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e17, 1e17}, Awards = {Yen = 76500000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {10, 15}, Awards = {Yen = 51000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Overlord",
                Requirements = {1e18, 1e18, 1e18},
                Cost = 165000000,
                YenPerMin = 750000,
                YenIncrease = 8100,
                Icon = "rbxassetid://4597990475",
                Color = Color3.fromRGB(61, 21, 133),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {2.5e18, 2.5e18}, Awards = {Yen = 225000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {15, 20}, Awards = {Yen = 150000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Hokage",
                Requirements = {1e20, 1e20, 1e20},
                Cost = 540000000,
                YenPerMin = 4500000,
                YenIncrease = 16200,
                Icon = "rbxassetid://4598003694",
                Color = Color3.fromRGB(196, 40, 28),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Chakra"}, Goal = {1e20, 1e20}, Awards = {Yen = 1350000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {15, 20}, Awards = {Yen = 900000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Kaioshin",
                Requirements = {1e21, 1e21, 1e21},
                Cost = 3487500000,
                YenPerMin = 25000000,
                YenIncrease = 54000,
                Icon = "rbxassetid://4769402725",
                Color = Color3.fromRGB(226, 155, 64),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Chakra"}, Goal = {2.5e21, 2.5e21}, Awards = {Yen = 7500000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {2, 5}, Awards = {Yen = 5000000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Sage",
                Requirements = {1e23, 1e23, 1e23},
                Cost = 12000000000,
                YenPerMin = 150000000,
                YenIncrease = 324000,
                Icon = "rbxassetid://4902154485",
                Color = Color3.fromRGB(213, 115, 61),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Chakra"}, Goal = {1e23, 1e23}, Awards = {Yen = 45000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {15, 20}, Awards = {Yen = 30000000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Espada",
                Requirements = {1e24, 1e24, 1e24},
                Cost = 82500000000,
                YenPerMin = 500000000,
                YenIncrease = 2316600,
                Icon = "rbxassetid://5088003270",
                Color = Color3.fromRGB(141, 141, 141),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Chakra"}, Goal = {2.5e23, 2.5e23}, Awards = {Yen = 150000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 100000000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Shinigami",
                Requirements = {1e26, 1e26, 1e26},
                Cost = 1000000000000,
                YenPerMin = 2500000000,
                YenIncrease = 11750000,
                Icon = "rbxassetid://5088002280",
                Color = Color3.fromRGB(68, 0, 0),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Chakra"}, Goal = {1e25, 1e25}, Awards = {Yen = 765000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 510000000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Hashira",
                Requirements = {1e27, 1e27, 1e27},
                Cost = 6000000000000,
                YenPerMin = 7500000000,
                YenIncrease = 35261832,
                Icon = "rbxassetid://5182708152",
                Color = Color3.fromRGB(255, 148, 148),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Chakra"}, Goal = {2.5e26, 2.5e26}, Awards = {Yen = 2295000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 1530000000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Hakaishin",
                Requirements = {1e29, 1e29, 1e29},
                Cost = 21000000000000,
                YenPerMin = 45000000000,
                YenIncrease = 211570992,
                Icon = "rbxassetid://5430846798",
                Color = Color3.fromRGB(255, 0, 0),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e28, 1e28}, Awards = {Yen = 13800000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 9200000000000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Otsutsuki",
                Requirements = {1e30, 1e30, 1e30},
                Cost = 1440000000000000,
                YenPerMin = 450000000000,
                YenIncrease = 634712976,
                Icon = "rbxassetid://5430845031",
                Color = Color3.fromRGB(4, 175, 236),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e30, 1e30}, Awards = {Yen = 5000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 3333333333333, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Pirate King",
                Requirements = {1e32, 1e32, 1e32},
                Cost = 2592000000000000,
                YenPerMin = 1350000000000,
                YenIncrease = 810100000000,
                Icon = "rbxassetid://5786392426",
                Color = Color3.fromRGB(117, 0, 0),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e31, 1e31}, Awards = {Yen = 50000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 33333333333333, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Kishin",
                Requirements = {1e33, 1e33, 1e33},
                Cost = 6480000000000000,
                YenPerMin = 4050000000000,
                YenIncrease = 6480800000000,
                Icon = "rbxassetid://6217910519",
                Color = Color3.fromRGB(117, 0, 0),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e32, 1e32}, Awards = {Yen = 500000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 333333333333333, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Angel",
                Requirements = {1e35, 1e35, 1e35},
                Cost = 19440000000000000,
                YenPerMin = 12150000000000,
                YenIncrease = 19442400000000,
                Icon = "rbxassetid://6479575744",
                Color = Color3.fromRGB(0, 136, 255),
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e33, 1e33}, Awards = {Yen = 5000000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 3333333333333333, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Demon King",
                Requirements = {1e36, 1e36, 1e36},
                Cost = 77760000000000000,
                YenPerMin = 60750000000000,
                YenIncrease = 116523360000000,
                Icon = "rbxassetid://7213217459",
                TitleAnimation = {Color3.fromRGB(255, 0, 25), Color3.fromRGB(246, 154, 25)},
                Color = Color3.fromRGB(196, 40, 28),  -- mantive a cor original
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e34, 1e34}, Awards = {Yen = 5000000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 3333333333333333, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Ultra Instinct",
                Requirements = {1e38, 1e38, 1e38},
                Cost = 311040000000000000,
                YenPerMin = 303750000000000,
                YenIncrease = 815663520000000,
                Icon = "rbxassetid://8318878477",
                TitleAnimation = {Color3.fromRGB(0, 200, 255), Color3.fromRGB(64, 0, 255)},
                Color = Color3.fromRGB(0, 200, 255),  -- cor temática
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e36, 1e36}, Awards = {Yen = 500000000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 333333333333333300, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            },
            {
                Name = "Upper Moon",
                Requirements = {1e41, 1e41, 1e41},
                Cost = 1244160000000000000,
                YenPerMin = 1518750000000000,
                YenIncrease = 5709644640000000,
                Icon = "rbxassetid://9376889257",
                TitleAnimation = {Color3.fromRGB(255, 128, 0), Color3.fromRGB(255, 183, 0)},
                Color = Color3.fromRGB(255, 128, 0),  -- cor temática
                DailyQuests = {
                    { Type = "Stat", Title = "Training Arc", Desc = "Auto", Stats = {"Strength","Durability","Sword","Chakra"}, Goal = {1e37, 1e37}, Awards = {Yen = 5000000000000000000, XP = 10}, MaxStats = 2 },
                    { Type = "Boss", Title = "Boss Battle", Desc = "Auto", Stats = {"Any"}, Goal = {5, 8}, Awards = {Yen = 3333333333333333000, XP = 8}, MaxStats = 2, Boss = "Any" }
                }
            }
        }
    }
end

function Classes:GetProgressionStatus()
    local classes = self:GetClasses().Classes

    for i, class in ipairs(classes) do
        if Players.LocalPlayer.Stats["1"].Value < class.Requirements[1]
        or Players.LocalPlayer.Stats["2"].Value < class.Requirements[2]
        or Players.LocalPlayer.Stats["3"].Value < class.Requirements[3] then

            return
                classes[i - 1] and classes[i - 1].Name or nil,
                class.Name,
                math.max(0, class.Requirements[1] - Players.LocalPlayer.Stats["1"].Value),
                math.max(0, class.Requirements[2] - Players.LocalPlayer.Stats["2"].Value),
                math.max(0, class.Requirements[3] - Players.LocalPlayer.Stats["3"].Value)
        end
    end
end

return Classes
