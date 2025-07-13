-- mod detector
pcall(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/Dig/Security/Admin_Detector/source.lua", true))()
end)
print('[ BYPASS ] - Mod detector 🟢')



-- Remote blocking / Remote function white list
local Targets = {}
local mtHook
for _, v in pairs(game:GetService("ReplicatedStorage").Remotes:GetChildren()) do
  if (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")) and v.Name:lower():find("admin") then
    Targets[v] = true
  end
end
mtHook = hookmetamethod(game, "__namecall", function(self, ...)
  if Targets[self] and (getnamecallmethod() == "InvokeServer" or getnamecallmethod() == "FireServer") then
    return nil
  end
  return mtHook(self, ...)
end)
local WhiteList = {
  'Voucher_RemoveGuis','Voucher_OpenOption','Admin_GetBanStatus','Admin_GetCommandLibrary','Admin_GetData',
  'Admin_GetTradeBanStatus','Admin_RunCommand','Admin_WipeData','Bindable_ItemHandler_RemoveItem',
  'Bindable_ToolHandler_RemoveItem','Boss_Spawn','CharmChisel_Use','ClientCall_PlatformType','Complete_Code',
  'Crate_OpenOption','Crate_RemoveGuis','CycleEvent_Horn_Use','Dig_GetClientGround','Dig_GetClientStatus',
  'Emote_Play','Emote_Stop','GetBossID','GetWaypointPosition','JournalPage_Complete','Level_Check',
  'Quest_DeliverPizza','Request_Copies_Data','Totem_GetStacks','Totem_Place','Trade_SendRequest',
  'TravelingMerchant_BuyItem','TravelingMerchant_GetItems','TravelingMerchant_OpenGui','Vehicle_Purchase'
}
for _, remote in pairs(game:GetService("ReplicatedStorage").Remotes:GetChildren()) do
    if remote:IsA('RemoteFunction') then
        local foundInWhitelist = false
        for _, whitelistedName in pairs(WhiteList) do
            if remote.Name == whitelistedName then
                foundInWhitelist = true
                break
            end
        end
        if not foundInWhitelist then
            remote.OnClientInvoke = function() return nil end
        end
    end
end
print('[ BYPASS ] - Remote blocking 🟢')
print('[ BYPASS ] - RemoteFunction whitelist 🟢')



-- NamecallInstanceDetector bypass
local NamecallInstanceDetector = nil
for _, tbl in ipairs(getgc(true)) do
    if typeof(tbl) == "table" and rawget(tbl, "namecallInstance") then
        for _, cont in pairs(tbl) do
            if type(cont)=="table" then
                for idx, val in ipairs(cont) do
                    if val=="kick" and type(cont[idx+1])=="function" then
                        local fn = cont[idx+1]
                        if table.find(getconstants(fn), "namecallInstance") then
                            NamecallInstanceDetector = fn
                        end
                    end
                end
            end
        end
    end
end
if NamecallInstanceDetector then
    hookfunction(NamecallInstanceDetector, function() return false end)
end
print('[ BYPASS ] - NamecallInstanceDetector bypass 🟢')



-- Stealth disable
local function stealthDisable(name)
    local target = cloneref(game:GetService("ReplicatedFirst")):FindFirstChild(name)
    if target and not target.Disabled then
        target.AncestryChanged:Connect(function()
            if not target:IsDescendantOf(game) then return end
            target.Disabled = true
        end)
        target.Disabled = true
    end
end
spawn(function()
    game:GetService('RunService').RenderStepped:Connect(function()
        stealthDisable("Debris")
    end)
end)
print('[ BYPASS ] - Stealth disable function 🟢')



-- LocalScript disable
spawn(function()
   game:GetService('RunService').RenderStepped:Connect(function()
        game:GetService("Players").LocalPlayer.PlayerScripts.CustomClientScripts.SpectateClient.Disabled = true
    end)
end)
print('[ BYPASS ] - LocalScript disable 🟢')
