local Players = cloneref(game:GetService("Players"));
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"));

local lp = Players.LocalPlayer
local TitlesData = require(ReplicatedStorage.shared.Modules.data.TitlesData)

local IndexToReplace = 15

local GradientTitle =
    "<font color=\"#8E44FF\">[In</font>" ..
    "<font color=\"#A970FF\">fi</font>" ..
    "<font color=\"#C084FF\">ni</font>" ..
    "<font color=\"#B794F4\">ty</font>" ..
    "<font color=\"#C4A1FF\">X]</font>"

TitlesData.GroupTitles[IndexToReplace] = {
	CharTitle = GradientTitle,
	HeadTitle = "InfinityX User",
	Color = Color3.fromRGB(170,85,255),
	Description = "mambo"
}

local otherData = lp:FindFirstChild("OtherData") or Instance.new("Folder", lp)
otherData.Name = "OtherData"

local equipped = otherData:FindFirstChild("EquippedTitle") or Instance.new("IntValue", otherData)
equipped.Name = "EquippedTitle"
equipped.Value = IndexToReplace
