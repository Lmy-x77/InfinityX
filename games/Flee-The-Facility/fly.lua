Services = setmetatable({}, {
  __index = function(self, name)
    local success, cache = pcall(function()
      return cloneref(game:GetService(name))
    end)
    if success then
      rawset(self, name, cache)
      return cache
    else
      error("Invalid Service: " .. tostring(name))
    end
  end
})

local Workspace = Services.Workspace
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local ReplicatedFirst = Services.ReplicatedFirst
local TweenService = Services.TweenService
local RunService = Services.RunService
local TeleportService = Services.TeleportService
local HttpService = Services.HttpService
local VirtualUser = Services.VirtualUser
local UserInputService = Services.UserInputService
local MarketplaceService = Services.MarketplaceService
local VirtualInputManager = Services.VirtualInputManager
local CoreGui = Services.CoreGui
local GuiService = Services.GuiService
local Lighting = Services.Lighting

local Fly = {
  Enabled = false,
  Speed = 50,
  Connection = nil,
  InputConnection = nil,
  InputEndedConnection = nil,
  Direction = Vector3.zero
}

function Fly:GetCharacter()
  return Players.LocalPlayer.Character
end

function Fly:GetRoot()
  local character = self:GetCharacter()

  if not character then
    return nil
  end

  return character:FindFirstChild("HumanoidRootPart")
    or character:FindFirstChild("Torso")
end

function Fly:DestroyObjects()
  local character = self:GetCharacter()

  if not character then
    return
  end

  for _, object in ipairs(character:GetDescendants()) do
    if object.Name == "InfinityXFlyVelocity"
      or object.Name == "InfinityXFlyOrientation"
      or object.Name == "InfinityXFlyAttachment"
    then
      object:Destroy()
    end
  end
end

function Fly:Start()
  if self.Enabled then
    return
  end

  local character = self:GetCharacter()

  if not character then
    return
  end

  local humanoid = character:FindFirstChildOfClass("Humanoid")
  local root = self:GetRoot()

  if not humanoid or not root then
    return
  end

  self:DestroyObjects()

  self.Enabled = true
  self.Direction = Vector3.zero

  local attachment = Instance.new("Attachment")
  attachment.Name = "InfinityXFlyAttachment"
  attachment.Parent = root

  local velocity = Instance.new("LinearVelocity")
  velocity.Name = "InfinityXFlyVelocity"
  velocity.Attachment0 = attachment
  velocity.RelativeTo = Enum.ActuatorRelativeTo.World
  velocity.MaxForce = math.huge
  velocity.VectorVelocity = Vector3.zero
  velocity.Parent = root

  local orientation = Instance.new("AlignOrientation")
  orientation.Name = "InfinityXFlyOrientation"
  orientation.Attachment0 = attachment
  orientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
  orientation.MaxTorque = math.huge
  orientation.Responsiveness = 200
  orientation.Parent = root

  self.InputConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
      return
    end

    if input.KeyCode == Enum.KeyCode.W then
      self.Direction += Vector3.new(0, 0, -1)

    elseif input.KeyCode == Enum.KeyCode.S then
      self.Direction += Vector3.new(0, 0, 1)

    elseif input.KeyCode == Enum.KeyCode.A then
      self.Direction += Vector3.new(-1, 0, 0)

    elseif input.KeyCode == Enum.KeyCode.D then
      self.Direction += Vector3.new(1, 0, 0)

    elseif input.KeyCode == Enum.KeyCode.Space then
      self.Direction += Vector3.new(0, 1, 0)

    elseif input.KeyCode == Enum.KeyCode.LeftControl then
      self.Direction += Vector3.new(0, -1, 0)
    end
  end)

  self.InputEndedConnection = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
      self.Direction -= Vector3.new(0, 0, -1)

    elseif input.KeyCode == Enum.KeyCode.S then
      self.Direction -= Vector3.new(0, 0, 1)

    elseif input.KeyCode == Enum.KeyCode.A then
      self.Direction -= Vector3.new(-1, 0, 0)

    elseif input.KeyCode == Enum.KeyCode.D then
      self.Direction -= Vector3.new(1, 0, 0)

    elseif input.KeyCode == Enum.KeyCode.Space then
      self.Direction -= Vector3.new(0, 1, 0)

    elseif input.KeyCode == Enum.KeyCode.LeftControl then
      self.Direction -= Vector3.new(0, -1, 0)
    end
  end)

  self.Connection = RunService.RenderStepped:Connect(function()
    if not self.Enabled then
      return
    end

    if not root.Parent or not character.Parent then
      self:Stop()
      return
    end

    local camera = Workspace.CurrentCamera

    if not camera then
      return
    end

    local direction = Vector3.zero

    direction += camera.CFrame.RightVector * self.Direction.X
    direction += camera.CFrame.LookVector * -self.Direction.Z
    direction += Vector3.yAxis * self.Direction.Y

    if direction.Magnitude > 0 then
      direction = direction.Unit
    end

    velocity.VectorVelocity = direction * self.Speed
    orientation.CFrame = camera.CFrame
  end)
end

function Fly:Stop()
  if not self.Enabled then
    return
  end

  self.Enabled = false
  self.Direction = Vector3.zero

  if self.Connection then
    self.Connection:Disconnect()
    self.Connection = nil
  end

  if self.InputConnection then
    self.InputConnection:Disconnect()
    self.InputConnection = nil
  end

  if self.InputEndedConnection then
    self.InputEndedConnection:Disconnect()
    self.InputEndedConnection = nil
  end

  self:DestroyObjects()
end

return Fly
