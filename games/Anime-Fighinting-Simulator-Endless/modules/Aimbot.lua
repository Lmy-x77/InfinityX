local Aimbot = {}
Aimbot.__index = Aimbot

local Workspace = cloneref(game:GetService("Workspace"))
local Players = cloneref(game:GetService("Players"))
local UIS = cloneref(game:GetService("UserInputService"))
local RunService = cloneref(game:GetService("RunService"))

local Camera = Workspace.CurrentCamera
local conn
local enabled = false
local targetPart

local IsOnMobile = table.find(
	{ Enum.Platform.Android, Enum.Platform.IOS },
	UIS:GetPlatform()
)

function Aimbot:SetTarget(part)
	targetPart = part
end

function Aimbot:Enable()
	if enabled then return end
	enabled = true

	conn = RunService.RenderStepped:Connect(function()
		if not enabled or not targetPart or not targetPart.Parent then return end

		local camPos = Camera.CFrame.Position
		local targetPos = targetPart.Position
		Camera.CFrame = Camera.CFrame:Lerp(
			CFrame.new(camPos, targetPos),
			IsOnMobile and 0.35 or 0.2
		)
	end)
end

function Aimbot:Disable()
	enabled = false
	if conn then
		conn:Disconnect()
		conn = nil
	end
	UIS.MouseBehavior = Enum.MouseBehavior.Default
end

return Aimbot
