local ChampionsModule = {}

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteF = ReplicatedStorage.shared.Remotes.RemoteFunction

local LastSummon = 0
local SUMMON_CD = 1.2
local LastStat, LastEquipped

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
	LastEquipped, LastStat = nil, nil
end

function ChampionsModule.EquipBest(statId, ChampionsData)
	if not getgenv().StatsFarm.EquipBestChampion then return end

	local plr = Players.LocalPlayer
	if not plr or not plr.Champions then return end

	if LastStat and LastStat ~= statId then
		ChampionsModule.Refresh()
	end

	local bestName, bestVal = nil, 0

	for _, champInst in pairs(plr.Champions:GetChildren()) do
		for _, data in pairs(ChampionsData) do
			if data.Name == champInst.Name then
				local at = data.Abilities and data.Abilities.AutoTrainer
				local v = at and at[tostring(statId)]
				if v and v > bestVal then
					bestVal = v
					bestName = champInst.Name
				end
				break
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

	local new = plr.Champions:FindFirstChild(bestName)
	if new then Summon(new) end

	LastEquipped = bestName
	LastStat = statId
end

return ChampionsModule
