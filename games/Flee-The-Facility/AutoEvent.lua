local PlaceId = { Lobby = 893973440, Event = 107279422643029 }
if game.PlaceId ~= PlaceId.Event then return end

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "InfinityX",
	Text = "AutoEvent Loaded, waiting for end cutscene",
	Duration = 5
})

local BeginGui = game.Players.LocalPlayer.PlayerGui.GateUIFolder.BeginGui
repeat task.wait() until BeginGui.Enabled == true

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VIM = game:GetService("VirtualInputManager")

local LP = Players.LocalPlayer
local HRP = LP.Character:WaitForChild("HumanoidRootPart")
local Gate = ReplicatedStorage.Remotes.GateUIEvent

local function ScreenClick()
	VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
	task.wait()
	VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
end

local function CloseTaskGui()
	for _, v in pairs(LP.PlayerGui.GateUIFolder:GetChildren()) do
		if v:IsA("ScreenGui") and v.Name:find("Task") then
			Gate:FireServer(v.Name)
		end
	end
end

local function FireTouch(part)
	local t = part:FindFirstChild("TouchInterest")
	if t then
		firetouchinterest(part, HRP, 0)
		firetouchinterest(part, HRP, 1)
	end
end

local function WaitForHikers(count)
	while true do
		task.wait(0.2)
		local total = 0
		for _, v in pairs(workspace:GetChildren()) do
			if v:IsA("Model") and v.Name == "HikerCharacter" then
				total += 1
			end
		end
		if total >= count then break end
	end
end

task.wait(0.8)
ScreenClick()
wait()
ScreenClick()
wait()
ScreenClick()
wait()
ScreenClick()
wait()
ScreenClick()
wait()
ScreenClick()
wait()
CloseTaskGui()

HRP.CFrame = workspace.GameplaySections.Task1.Complete.CFrame
task.wait(0.3)
FireTouch(workspace.GameplaySections.Task1.Complete)
task.wait(0.2)
ScreenClick()
task.wait(0.5)

CloseTaskGui()
WaitForHikers(3)

for _, v in pairs(workspace:GetChildren()) do
	if v:IsA("Model") and v.Name == "HikerCharacter" and v:FindFirstChild("HumanoidRootPart") then
		HRP.CFrame = v.HumanoidRootPart.CFrame
		task.wait(0.2)

		LP.Character.Hammer.HammerEvent:FireServer("HammerHit", v["Left Arm"])
		task.wait(0.3)

		for _, x in pairs(v:GetDescendants()) do
			if x:IsA("ProximityPrompt") then
				fireproximityprompt(x)
				task.wait(0.15)
			end
		end
	end
end

task.wait(0.6)
CloseTaskGui()

HRP.CFrame = workspace.GameplaySections.Task2.CompleteA.CFrame
task.wait(0.3)
FireTouch(workspace.GameplaySections.Task2.CompleteA)
task.wait(0.2)
ScreenClick()
task.wait(0.5)

CloseTaskGui()

HRP.CFrame = workspace.GameplaySections.Task2.CompleteB.CFrame
task.wait(0.3)
FireTouch(workspace.GameplaySections.Task2.CompleteB)
task.wait(0.2)
ScreenClick()
task.wait(0.5)

CloseTaskGui()

local Dress = workspace.Map:GetChildren()[117].DressClone.ClickPart
for _, v in pairs(Dress:GetDescendants()) do
	if v:IsA("ClickDetector") then
		fireclickdetector(v)
		task.wait(0.2)
	end
end

task.wait(0.5)

ScreenClick()

task.wait(1)

game:GetService("ReplicatedStorage").Remotes.MinigameEvent:FireServer(true)

task.wait(0.5)

ScreenClick()

repeat task.wait() until game:GetService("Players").LocalPlayer.PlayerGui.GateUIFolder.RewardGui.Enabled == true

task.wait(0.5)

ScreenClick()
