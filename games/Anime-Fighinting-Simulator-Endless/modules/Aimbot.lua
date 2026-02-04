local Aimbot = {}
Aimbot.__index = Aimbot

local Workspace = cloneref(game:GetService("Workspace"))
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
		Camera.CFrame = Camera.CFrame:Lerp(
			CFrame.new(Camera.CFrame.Position, targetPart.Position),
			IsOnMobile and 0.6 or 0.25
		)
	end)
end

function Aimbot:Disable()
	enabled = false
	if conn then
		conn:Disconnect()
		conn = nil
	end
end

return Aimbot
