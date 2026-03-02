local Players = cloneref(game:GetService("Players"))
local CoreGui = cloneref(game:GetService("CoreGui"))
local RunService = cloneref(game:GetService("RunService"))

local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local findUser = tostring(UserId)

local startColor = Color3.fromHex("#C4B5FD")
local endColor = Color3.fromHex("#6D28D9")

function gradient(text, startColor, endColor)
    local result = ""
    local length = #text
    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)
        local char = text:sub(i, i)
        result = result .. string.format('<font color="rgb(%d,%d,%d)">%s</font>', r, g, b, char)
    end
    return result
end

local function applyToFrame(frame)
    for _, icon in pairs(frame:GetDescendants()) do
        if icon:IsA("ImageLabel") and icon.Name == "PlayerIcon" then
            icon.Image = "rbxassetid://92308401887821"
            icon.Size = UDim2.new(0, 28, 0, 28)
            icon.BackgroundTransparency = 1
        end
    end

    for _, name in pairs(frame:GetDescendants()) do
        if name:IsA("TextLabel") and name.Name == "PlayerName" then
            name.RichText = true
            if not name:GetAttribute("GradientConnected") then
                name:SetAttribute("GradientConnected", true)
                RunService.Heartbeat:Connect(function()
                    name.Text = gradient(LocalPlayer.DisplayName or LocalPlayer.Name, startColor, endColor)
                end)
            end
        end
    end
end

for _, frame in pairs(CoreGui.PlayerList:GetDescendants()) do
    if frame:IsA("Frame") and frame.Name:find(findUser) then
        applyToFrame(frame)
    end
end

CoreGui.PlayerList.DescendantAdded:Connect(function(desc)
    if desc:IsA("Frame") and desc.Name:find(findUser) then
        task.wait()
        applyToFrame(desc)
    end
end)
