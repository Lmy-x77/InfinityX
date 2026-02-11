local Champions = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Fighinting-Simulator-Endless/modules/Champions.lua"))()

local ChampionsModule = {}

local Players = cloneref(game:GetService("Players"))
local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local RemoteF = ReplicatedStorage.shared.Remotes.RemoteFunction

local LastSummon = 0
local SUMMON_CD = 1.2
local LastStat, LastEquipped

local ChampionsByName = {}
for _, data in pairs(Champions) do
	if data.Name then
		ChampionsByName[data.Name] = data
	end
end

local function CanSummon()
	return os.clock() - LastSummon >= SUMMON_CD
end

local function Summon(champ)
	if not champ or not CanSummon() then return end
	LastSummon = os.clock()
	RemoteF:InvokeServer("SummonChamp", champ)
end

function ChampionsModule.Refresh()
	local plr = Players.LocalPlayer
	if not plr then return end

	local equipped = plr:FindFirstChild("ChampionEquipped")
	if equipped and equipped.Value ~= "" then
		local champ = plr.Champions:FindFirstChild(equipped.Value)
		if champ then Summon(champ) end
	end

	LastEquipped = nil
	LastStat = nil
end

function ChampionsModule.EquipBest(statId)
	if not getgenv().StatsFarm.EquipBestChampion then return end

	local plr = Players.LocalPlayer
	if not plr or not plr.Champions then return end

	if LastStat and LastStat ~= statId then
		ChampionsModule.Refresh()
	end

	local bestName
	local bestValue = 0

	for _, champInst in pairs(plr.Champions:GetChildren()) do
		local data = ChampionsByName[champInst.Name]
		if data and data.Abilities and data.Abilities.AutoTrainer then
			local value = data.Abilities.AutoTrainer[tostring(statId)]
			if value and value > bestValue then
				bestValue = value
				bestName = champInst.Name
			end
		end
	end

	if not bestName then return end

	local equipped = plr:FindFirstChild("ChampionEquipped")
	if equipped and equipped.Value == bestName and LastStat == statId then return end

	if equipped and equipped.Value ~= "" then
		local old = plr.Champions:FindFirstChild(equipped.Value)
		if old then Summon(old) end
	end

	local newChamp = plr.Champions:FindFirstChild(bestName)
	if newChamp then Summon(newChamp) end

	LastEquipped = bestName
	LastStat = statId
end

return ChampionsModule
