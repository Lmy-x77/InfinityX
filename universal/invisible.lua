if _G.EffectUI then
    _G.EffectUI:Destroy()
end
if _G.connections then
    for _, connection in pairs(_G.connections) do
        connection:Disconnect()
    end
    _G.connections = nil
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

local isEffectActive = false
local originalParts = {}
_G.connections = {}

local function dragify(Frame)
    local dragToggle, dragInput, dragStart, startPos = false, nil, nil, nil
    local function updateInput(input)
        local Delta = input.Position - dragStart
        local Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + Delta.X, startPos.Y.Scale, startPos.Y.Offset + Delta.Y)
        TweenService:Create(Frame, TweenInfo.new(0.25), {Position = Position}):Play()
    end
    
    table.insert(_G.connections, Frame.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UserInputService:GetFocusedTextBox() == nil then
            dragToggle, dragStart, startPos = true, input.Position, Frame.Position
            local changedConn
            changedConn = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragToggle = false
                    changedConn:Disconnect()
                end
            end)
        end
    end))
    
    table.insert(_G.connections, Frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end))
    
    table.insert(_G.connections, UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragToggle then updateInput(input) end
    end))
end

local function getCharacterParts(char)
    local parts = {}
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.Transparency == 0 then
            table.insert(parts, part)
        end
    end
    return parts
end

originalParts = getCharacterParts(character)

local function setTransparency(isActive)
    local transparency = isActive and 0.5 or 0
    for _, part in pairs(originalParts) do
        if part and part.Parent then
            part.Transparency = transparency
        end
    end
end

local function resetAll()
    isEffectActive = false
    if humanoid and humanoid.Parent then
        humanoid.CameraOffset = Vector3.new(0, 0, 0)
    end
    setTransparency(false)
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "EffectUI_ScreenGui"
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
screenGui.ResetOnSpawn = false
_G.EffectUI = screenGui

local ToggleButton = Instance.new("TextButton", screenGui)
ToggleButton.Name = "ToggleButton"
ToggleButton.Text = "YG"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleButton.BackgroundTransparency = 0.3
ToggleButton.BorderSizePixel = 1
ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0.1, 0, 0.5, 0)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.TextSize = 20

local UICorner = Instance.new("UICorner", ToggleButton)
UICorner.CornerRadius = UDim.new(1, 0)

dragify(ToggleButton)

table.insert(_G.connections, RunService.Heartbeat:Connect(function()
    if isEffectActive and humanoidRootPart and humanoid and humanoid.Health > 0 then
        local originalCFrame = humanoidRootPart.CFrame
        local originalCameraOffset = humanoid.CameraOffset

        local targetCFrame = originalCFrame * CFrame.new(0, 2000000, 0)

        humanoid.CameraOffset = targetCFrame:ToObjectSpace(CFrame.new(originalCFrame.Position)).Position
        humanoidRootPart.CFrame = targetCFrame

        RunService.RenderStepped:Wait()

        humanoid.CameraOffset = originalCameraOffset
        humanoidRootPart.CFrame = originalCFrame
    end
end))

table.insert(_G.connections, ToggleButton.MouseButton1Click:Connect(function()
    isEffectActive = not isEffectActive
    setTransparency(isEffectActive)

    if isEffectActive then
        ToggleButton.TextColor3 = Color3.fromRGB(70, 255, 70)
        ToggleButton.BorderColor3 = Color3.fromRGB(70, 255, 70)
    else
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
    end
end))

local function onCharacterAdded(newCharacter)
    resetAll()

    character = newCharacter
    humanoid = newCharacter:WaitForChild("Humanoid")
    humanoidRootPart = newCharacter:WaitForChild("HumanoidRootPart")

    originalParts = getCharacterParts(newCharacter)

    local diedConnection
    diedConnection = humanoid.Died:Connect(function()
        resetAll()
        isEffectActive = false
        ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
        diedConnection:Disconnect()
    end)
end

localPlayer.CharacterAdded:Connect(onCharacterAdded)

humanoid.Died:Connect(function()
    resetAll()
    isEffectActive = false
    ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleButton.BorderColor3 = Color3.fromRGB(255, 255, 255)
end)
