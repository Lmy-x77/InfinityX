---@diagnostic disable: undefined-global
-- detect service
local DataStoreService = game:GetService("DataStoreService")
local UserInputService = game:GetService("UserInputService")
IsOnMobile = table.find({Enum.Platform.Android, Enum.Platform.IOS}, UserInputService:GetPlatform())
if IsOnMobile then
  print("Mobile device")
  loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/main/Software/Items/button.lua",true))()
elseif not IsOnMobile then
  print("Computer device")
end


-- start
print[[                                                                     

 /$$$$$$            /$$$$$$  /$$           /$$   /$$               /$$   /$$
|_  $$_/           /$$__  $$|__/          |__/  | $$              | $$  / $$
| $$   /$$$$$$$ | $$  \__/ /$$ /$$$$$$$  /$$ /$$$$$$   /$$   /$$|  $$/ $$/
| $$  | $$__  $$| $$$$    | $$| $$__  $$| $$|_  $$_/  | $$  | $$ \  $$$$/ 
| $$  | $$  \ $$| $$_/    | $$| $$  \ $$| $$  | $$    | $$  | $$  >$$  $$ 
| $$  | $$  | $$| $$      | $$| $$  | $$| $$  | $$ /$$| $$  | $$ /$$/\  $$
/$$$$$$| $$  | $$| $$      | $$| $$  | $$| $$  |  $$$$/|  $$$$$$$| $$  \ $$
|______/|__/  |__/|__/      |__/|__/  |__/|__/   \___/   \____  $$|__/  |__/
                                                       /$$  | $$          
                                                      |  $$$$$$/          
                                                       \______/           
]]


-- variables
getgenv().FarmSettings = {
  OrbsTime = 0.1,
  HoopMethod = 'Teleport'
}
getgenv().PetSellSettings = {
  Ignore = true
}
function GetGameGui()
  local findgui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('gameGui')
  if findgui then
    return true
  else
    return false
  end
end
function GetRaceStatus(name : string)
  local findgui = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild('gameGui')
  for _, v in pairs(findgui.winnersFolder.winnersFrame:GetDescendants()) do
    if v:IsA('Frame') and v.Name == name then
      return v.playerName.Text
    end
  end
end
function FindHumanoidRootPart()
  local char = game.Players.LocalPlayer.Character or game.Players.LocalPlayer.CharacterAdded:Wait()
  local hrp = char:FindFirstChild('HumanoidRootPart')
  if hrp then
    return true
  else
    return false
  end
end
function GetCrystals()
  local crystals = {}
  for _, v in pairs(workspace.mapCrystalsFolder:GetChildren()) do
    if v:IsA('Model') then
      table.insert(crystals, v.Name)
    end
  end
  return crystals
end
local Signals = {"Activated", "MouseButton1Down", "MouseButton2Down", "MouseButton1Click", "MouseButton2Click"}


-- ui library
local isMobile = game.UserInputService.TouchEnabled
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Fluent/source.lua"))()

local Options = Fluent.Options

function GetSize()
  if isMobile then
    return UDim2.fromOffset(480, 300)
  else
    return UDim2.fromOffset(650, 480)
  end
end

local Window = Fluent:CreateWindow({
	Title = '<font color="rgb(175, 120, 255)" size="14"><b>InfinityX</b> <font color="rgb(180,180,180)" size="13"> - <b>v4.2a</b></font></font>',
  SubTitle = '<font color="rgb(160,160,160)" size="10"><i> -  by lmy77</i></font>',
	TabWidth = 160,
	Size = GetSize(),
	Acrylic = false,
	Theme = "InfinityX",
	MinimizeKey = Enum.KeyCode.K
})


-- tabs
local Tabs = {
  AutoFarm = Window:AddTab({ Title = "| Autofarm", Icon = "refresh-cw" }),
  Pet = Window:AddTab({ Title = "| Pets", Icon = "cat" }),
  Misc = Window:AddTab({ Title = "| Misc", Icon = "layers" }),
  Settings = Window:AddTab({ Title = "| Settings", Icon = "settings" })
}
Window:SelectTab(1)


-- source
Tabs.AutoFarm:AddSection("[💸] - Auto Farm Options")
local AutoOrb = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Auto collect orbs",
  Description = "Active to collect all orbs spawned in map",
  Default = false,
})
AutoOrb:OnChanged(function(Value)
  autoorb = Value
  while autoorb do task.wait(getgenv().FarmSettings.OrbsTime)
    for _, v in pairs(workspace.orbFolder:GetDescendants()) do
      if v:IsA('Model') then
        if FindHumanoidRootPart() then
          local Event = game:GetService("ReplicatedStorage").rEvents.orbEvent
          Event:FireServer(
            "collectOrb",
            v.Name,
            v.Parent.Name
          )
          if not autoorb then return end
        end
      end
    end
  end
end)
local AutoHoop = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Auto collect hoop",
  Description = "Active to collect all hoops spawned in map",
  Default = false,
})
AutoHoop:OnChanged(function(Value)
  autohoop = Value
  while autohoop do task.wait()
    if getgenv().FarmSettings.HoopMethod == 'Teleport' then
      for _, v in pairs(workspace.Hoops:GetDescendants()) do
        if v:IsA('MeshPart') then
          if FindHumanoidRootPart() then
            game.Players.LocalPlayer.Character:PivotTo(v:GetPivot())
            task.wait()
          end
        end
      end
    elseif getgenv().FarmSettings.HoopMethod == 'Touch' then
      for _, v in pairs(workspace.Hoops:GetDescendants()) do
        if v:IsA('TouchTransmitter') then
          if FindHumanoidRootPart() then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
            task.wait()
          end
        end
      end
    end
  end
end)
local AutoChest = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Auto collect reward chest",
  Description = "Active to collect all chest spawned in map",
  Default = false,
})
AutoChest:OnChanged(function(Value)
  autochest = Value
  while autochest do task.wait()
    for _, v in pairs(workspace.rewardChests:GetChildren()) do
      if v:IsA('Model') then
        local Event = game:GetService("ReplicatedStorage").rEvents.collectCourseChestRemote
        Event:InvokeServer(
          v
        )
      end
    end
  end
end)
local AutoRebirth = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Auto rebirth",
  Description = "When the player reaches the maximum level available, the system will automatically carry out the rebirth process, without the user having to perform any manual action.",
  Default = false,
})
AutoRebirth:OnChanged(function(Value)
  autorebirth = Value
  while autorebirth do task.wait()
    local Event = game:GetService("ReplicatedStorage").rEvents.rebirthEvent
    Event:FireServer(
      "rebirthRequest"
    )
  end
end)
Tabs.AutoFarm:AddButton({
  Title = "Claim all free rewards",
  Callback = function()
    for i = 1, 10 do
      local Event = game:GetService("ReplicatedStorage").rEvents.freeGiftClaimRemote
      Event:InvokeServer(
        "claimGift",
        i
      )
      wait()
    end
  end
})
Tabs.AutoFarm:AddSection("[🏃] - Race Options")
local AutoJoinRace = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Auto join race",
  Description = "Active to join automatically the race",
  Default = false,
})
AutoJoinRace:OnChanged(function(Value)
  autojoin = Value
  while autojoin do task.wait()
    if GetGameGui() then
      for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.gameGui.raceJoinLabel:GetChildren()) do
        if v:IsA("TextButton") and v.Name == 'yesButton' then
          for i,Signal in pairs(Signals) do
            firesignal(v[Signal])
          end
        end
      end
    end
  end
end)
local AutoWinRace = Tabs.AutoFarm:AddToggle("AutoMoneyToggle", {
  Title = "Auto win race",
  Description = "Active to win automatically the race",
  Default = false,
})
AutoWinRace:OnChanged(function(Value)
  autowin = Value
  while autowin do task.wait()
    for _, v in pairs(workspace.raceMaps:GetDescendants()) do
      if v:IsA('TouchTransmitter') then
        if FindHumanoidRootPart() then
          firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 0)
          firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart, v.Parent, 1)
        end
      end
    end
  end
end)
local p1 = Tabs.AutoFarm:AddParagraph({
  Title = "Race Status",
  Content = "None"
})
task.spawn(function()
	while true do
		task.wait()
    if GetGameGui() then
		  p1:SetDesc('1st: ' ..
        GetRaceStatus('firstFrame') .. '\n2st: ' ..
        GetRaceStatus('secondFrame') .. '\n3st: ' ..
        GetRaceStatus('thirdFrame')
      )
    end
	end
end)
Tabs.AutoFarm:AddSection("[⚙️] - Farm Settings")
local Input = Tabs.AutoFarm:AddInput("Input", {
  Title = "Collect orb time",
  Default = "",
  Placeholder = "0.1 (Recommended)",
  Numeric = true,
  Finished = false,
  Callback = function(Value)
    getgenv().FarmSettings.OrbsTime = tonumber(Value)
  end
})
local ToolDropdown = Tabs.AutoFarm:AddDropdown("Dropdown", {
  Title = "Selected hoop farm method",
  Values = { 'Teleport', 'Touch' },
  Multi = false,
  Default = 'Teleport',
})
ToolDropdown:OnChanged(function(Value)
  getgenv().FarmSettings.HoopMethod = Value
end)


Tabs.Pet:AddSection("[🐶] - Pets Options")
local CrystalDropdown = Tabs.Pet:AddDropdown("Dropdown", {
  Title = "Select crystal",
  Values = GetCrystals(),
  Multi = false,
  Default = selectedItem,
})
CrystalDropdown:OnChanged(function(Value)
  SelectedCrystal = Value
end)
Tabs.Pet:AddButton({
  Title = "Open selected crystal",
  Callback = function()
    if game:GetService("Players").LocalPlayer.PlayerGui.gameGui.petsMenu.Visible == false then
      for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.gameGui.sideButtons:GetChildren()) do
        if v:IsA("TextButton") and v.Name == 'petsButton' then
          for i,Signal in pairs(Signals) do
            firesignal(v[Signal])
          end
        end
      end
    end
    wait(.2)
    local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
    Event:InvokeServer(
      "openCrystal",
      SelectedCrystal
    )
  end
})
local AutoOpenCrystal = Tabs.Pet:AddToggle("AutoMoneyToggle", {
  Title = "Auto open selected crystal",
  Default = false,
})
AutoOpenCrystal:OnChanged(function(Value)
  crystal = Value
  if crystal and game:GetService("Players").LocalPlayer.PlayerGui.gameGui.petsMenu.Visible == false then
    for _,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.gameGui.sideButtons:GetChildren()) do
      if v:IsA("TextButton") and v.Name == 'petsButton' then
        for i,Signal in pairs(Signals) do
          firesignal(v[Signal])
        end
      end
    end
  end
  wait(.2)
  while crystal do task.wait()
    local Event = game:GetService("ReplicatedStorage").rEvents.openCrystalRemote
    Event:InvokeServer(
      "openCrystal",
      SelectedCrystal
    )
  end
end)
Tabs.Pet:AddButton({
  Title = "Teleport to selected crystal",
  Callback = function()
    for _, v in pairs(workspace.mapCrystalsFolder:GetChildren()) do
      if v:IsA('Model') and v.Name == SelectedCrystal then
        game.Players.LocalPlayer.Character:PivotTo(v:GetPivot() * CFrame.new(0, 10, 0))
      end
    end
  end
})
Tabs.Pet:AddSection("[🤑] - Sell Pets")
local p1 = Tabs.Pet:AddParagraph({
  Title = "How To Use",
  Content = "So that you can use auto sell, remember to put this code “Blocked Pet” in the name of the pet you want NOT to sell. By entering this code, the script will find the pet and will not sell it."
})
local AutoSell = Tabs.Pet:AddToggle("", {
  Title = "Auto sell pets",
  Default = false,
})
AutoSell:OnChanged(function(Value)
  autosell = Value
  while autosell do task.wait()
    if getgenv().PetSellSettings.Ignore == true then
      for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetDescendants()) do
        if v:IsA('StringValue') and v.Name == 'chosenName' and v.Value ~= 'Blocked Pet' then
          local Event = game:GetService("ReplicatedStorage").rEvents.sellPetEvent
          Event:FireServer(
            "sellPet",
            v.Parent
          )
        end
      end
    elseif getgenv().PetSellSettings.Ignore == false then
      for _, v in pairs(game:GetService("Players").LocalPlayer.petsFolder:GetDescendants()) do
        if v:IsA('StringValue') and v.Name == 'chosenName' then
          local Event = game:GetService("ReplicatedStorage").rEvents.sellPetEvent
          Event:FireServer(
            "sellPet",
            v.Parent
          )
        end
      end
    end 
  end
end)
local IgnorePets = Tabs.Pet:AddToggle("", {
  Title = "Ignore pet block code",
  Default = true,
})
IgnorePets:OnChanged(function(Value)
  getgenv().PetSellSettings.Ignore = Value
end)
Tabs.Pet:AddButton({
  Title = "Copy pet block code",
  Callback = function()
    setclipboard('Blocked Pet')
  end
})



Tabs.Misc:AddSection("[☄️] - Misc Options")
Tabs.Misc:AddButton({
  Title = "Reedem all codes",
  Callback = function()
    local codes = { 'swiftjungle1000', 'speedchampion000', 'racer300', 'SPRINT250', 'hyper250', 'legends500', 'sparkles300', 'Launch200' }
    for _, v in pairs(codes) do
      local Event = game:GetService("ReplicatedStorage").rEvents.codeRemote
      Event:InvokeServer(
        v
      )
    end
  end
})
Tabs.Misc:AddButton({
  Title = "Get click tp tool",
  Callback = function()
    local player = game.Players.LocalPlayer
    local function giveTool()
      local mouse = player:GetMouse()
      local tool = Instance.new("Tool")
      tool.RequiresHandle = false
      tool.Name = "Tp tool (Equip to Click TP)"
      tool.Activated:Connect(function()
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
          local pos = mouse.Hit.Position + Vector3.new(0, 2.5, 0)
          player.Character.HumanoidRootPart.CFrame = CFrame.new(pos)
        end
      end)
      tool.Parent = player.Backpack
    end
    player.CharacterAdded:Connect(function()
      task.wait(1)
      if not player.Backpack:FindFirstChild("Tp tool (Equip to Click TP)") then
        giveTool()
      end
    end)
    if player.Character then
      giveTool()
    end
  end
})
Tabs.Misc:AddButton({
  Title = "Rejoin server",
  Callback = function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game:GetService("Players").LocalPlayer)
  end
})


Tabs.Settings:AddSection("[⚙️] - Ui Settings")
local InterfaceTheme = Tabs.Settings:AddDropdown("InterfaceTheme", {
  Title = "Theme",
  Description = "Changes the interface theme.",
  Values = Fluent.Themes,
  Default = "InfinityX",
  Callback = function(Value)
    Fluent:SetTheme(Value)
  end
})
Tabs.Settings:AddToggle("AcrylicToggle", {
  Title = "Acrylic",
  Description = "The blurred background requires graphic quality 8+",
  Default = false,
  Callback = function(Value)
    Fluent:ToggleAcrylic(Value)
  end
})
Tabs.Settings:AddToggle("TransparentToggle", {
  Title = "Transparency",
  Description = "Makes the interface transparent.",
  Default = true,
  Callback = function(Value)
    Fluent:ToggleTransparency(Value)
  end
})
local MenuKeybind = Tabs.Settings:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = "K" })
Fluent.MinimizeKeybind = MenuKeybind
Tabs.Settings:AddSection("[🎉] - Credits")
local p1 = Tabs.Settings:AddParagraph({
  Title = "Script Credits",
  Content = "Made by: Lmy77"
})
Tabs.Settings:AddButton({
  Title = "Join discord server",
  Callback = function()
    setclipboard("https://discord.gg/emKJgWMHAr")
  	Fluent:Notify({
  		Title = "InfinityX",
  		Content = "Link copied to your clipboard",
  		Duration = 5
  	})
  end
})
