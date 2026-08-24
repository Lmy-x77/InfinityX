local Fly = {
  Enabled = false,
  Speed = 1,

  PCInputBegan = nil,
  PCInputEnded = nil,

  MobileConnection = nil,
  CharacterConnection = nil,

  BodyVelocity = nil,
  BodyGyro = nil,

  Control = {
    F = 0,
    B = 0,
    L = 0,
    R = 0,
    U = 0,
    D = 0
  }
}

function Fly:GetCharacter()
  return game.Players.LocalPlayer.Character
end

function Fly:GetRoot()
  local character = self:GetCharacter()

  if not character then
    return nil
  end

  local humanoid = character:FindFirstChildOfClass("Humanoid")

  return humanoid and humanoid.RootPart
end

function Fly:IsMobile()
  return UserInputService.TouchEnabled
    and not UserInputService.KeyboardEnabled
end

function Fly:CreatePhysics()
  local root = self:GetRoot()

  if not root then
    return false
  end

  if root:FindFirstChild("InfinityXFlyVelocity") then
    root.InfinityXFlyVelocity:Destroy()
  end

  if root:FindFirstChild("InfinityXFlyGyro") then
    root.InfinityXFlyGyro:Destroy()
  end

  self.BodyVelocity = Instance.new("BodyVelocity")
  self.BodyVelocity.Name = "InfinityXFlyVelocity"
  self.BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
  self.BodyVelocity.Velocity = Vector3.zero
  self.BodyVelocity.Parent = root

  self.BodyGyro = Instance.new("BodyGyro")
  self.BodyGyro.Name = "InfinityXFlyGyro"
  self.BodyGyro.P = 9e4
  self.BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
  self.BodyGyro.CFrame = root.CFrame
  self.BodyGyro.Parent = root

  return true
end

function Fly:DestroyPhysics()
  local character = self:GetCharacter()

  if character then
    for _, object in ipairs(character:GetDescendants()) do
      if object.Name == "InfinityXFlyVelocity"
        or object.Name == "InfinityXFlyGyro"
      then
        object:Destroy()
      end
    end
  end

  self.BodyVelocity = nil
  self.BodyGyro = nil
end

function Fly:StartPC()
  self.PCInputBegan = UserInputService.InputBegan:Connect(function(input, processed)
    if processed then
      return
    end

    if input.KeyCode == Enum.KeyCode.W then
      self.Control.F = 1

    elseif input.KeyCode == Enum.KeyCode.S then
      self.Control.B = -1

    elseif input.KeyCode == Enum.KeyCode.A then
      self.Control.L = -1

    elseif input.KeyCode == Enum.KeyCode.D then
      self.Control.R = 1

    elseif input.KeyCode == Enum.KeyCode.E
      or input.KeyCode == Enum.KeyCode.Space
    then
      self.Control.U = 1

    elseif input.KeyCode == Enum.KeyCode.Q
      or input.KeyCode == Enum.KeyCode.LeftControl
    then
      self.Control.D = -1
    end
  end)

  self.PCInputEnded = UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.W then
      self.Control.F = 0

    elseif input.KeyCode == Enum.KeyCode.S then
      self.Control.B = 0

    elseif input.KeyCode == Enum.KeyCode.A then
      self.Control.L = 0

    elseif input.KeyCode == Enum.KeyCode.D then
      self.Control.R = 0

    elseif input.KeyCode == Enum.KeyCode.E
      or input.KeyCode == Enum.KeyCode.Space
    then
      self.Control.U = 0

    elseif input.KeyCode == Enum.KeyCode.Q
      or input.KeyCode == Enum.KeyCode.LeftControl
    then
      self.Control.D = 0
    end
  end)

  RunService.RenderStepped:Connect(function()
    if not self.Enabled or self:IsMobile() then
      return
    end

    local root = self:GetRoot()
    local camera = Workspace.CurrentCamera

    if not root
      or not camera
      or not self.BodyVelocity
      or not self.BodyGyro
    then
      return
    end

    local direction =
      camera.CFrame.LookVector * (self.Control.F + self.Control.B)
      + camera.CFrame.RightVector * (self.Control.L + self.Control.R)
      + Vector3.new(0, self.Control.U + self.Control.D, 0)

    if direction.Magnitude > 0 then
      direction = direction.Unit
    end

    self.BodyVelocity.Velocity =
      direction * (self.Speed * 50)

    self.BodyGyro.CFrame = camera.CFrame
  end)
end

function Fly:StartMobile()
  local controlModule = require(
    Players.LocalPlayer.PlayerScripts
      :WaitForChild("PlayerModule")
      :WaitForChild("ControlModule")
  )

  self.MobileConnection = RunService.RenderStepped:Connect(function()
    if not self.Enabled or not self:IsMobile() then
      return
    end

    local root = self:GetRoot()
    local camera = Workspace.CurrentCamera

    if not root
      or not camera
      or not self.BodyVelocity
      or not self.BodyGyro
    then
      return
    end

    local direction = controlModule:GetMoveVector()

    local velocity =
      camera.CFrame.RightVector * direction.X
      - camera.CFrame.LookVector * direction.Z

    if velocity.Magnitude > 0 then
      velocity = velocity.Unit
    end

    self.BodyVelocity.Velocity =
      velocity * (self.Speed * 50)

    self.BodyGyro.CFrame = camera.CFrame
  end)
end

function Fly:Start()
  if self.Enabled then
    return
  end

  self.Enabled = true

  if not self:CreatePhysics() then
    self.Enabled = false
    return
  end

  if self:IsMobile() then
    self:StartMobile()
  else
    self:StartPC()
  end
end

function Fly:Stop()
  self.Enabled = false

  self.Control = {
    F = 0,
    B = 0,
    L = 0,
    R = 0,
    U = 0,
    D = 0
  }

  if self.PCInputBegan then
    self.PCInputBegan:Disconnect()
    self.PCInputBegan = nil
  end

  if self.PCInputEnded then
    self.PCInputEnded:Disconnect()
    self.PCInputEnded = nil
  end

  if self.MobileConnection then
    self.MobileConnection:Disconnect()
    self.MobileConnection = nil
  end

  self:DestroyPhysics()
end

return Fly
