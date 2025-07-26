local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Notify/source.lua", true))()
if not Drawing then
    lib.notify('Your exploit dont support this function')
    wait(.4)
    lib.notify('Use a better exploit')
    return
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local activeDrawings = {}

local function createESP(player)
    local drawings = {}

    if getgenv().EspSettings.BoxType == "2d" then
        drawings.box = Drawing.new("Square")
        drawings.box.Thickness = 2
        drawings.box.Transparency = 1
        drawings.box.Filled = false
    elseif getgenv().EspSettings.BoxType == "3d" then
        local box = Instance.new("BoxHandleAdornment")
        box.Size = Vector3.new(4, 6, 2)
        box.Transparency = getgenv().EspSettings.BoxTransparency
        box.AlwaysOnTop = true
        box.ZIndex = 10
        box.Adornee = nil
        box.Color3 = Color3.new(1, 1, 1)
        box.Parent = game.CoreGui
        drawings.box3d = box
    end

    drawings.name = Drawing.new("Text")
    drawings.name.Size = 13
    drawings.name.Center = true
    drawings.name.Outline = true

    drawings.distance = Drawing.new("Text")
    drawings.distance.Size = 13
    drawings.distance.Center = true
    drawings.distance.Outline = true

    drawings.tracer = Drawing.new("Line")
    drawings.tracer.Thickness = 1
    drawings.tracer.Transparency = 1

    activeDrawings[player] = drawings

    local function update()
        if not getgenv().EspSettings.Enabled then
            for _, d in pairs(drawings) do
                if typeof(d) == "Instance" then
                    if d:IsA("BoxHandleAdornment") then d.Adornee = nil end
                else
                    d.Visible = false
                end
            end
            return
        end

        local char = player.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") or not char:FindFirstChild("Humanoid") then
            for _, d in pairs(drawings) do
                if typeof(d) ~= "Instance" then d.Visible = false end
            end
            return
        end

        local hrp = char.HumanoidRootPart
        local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        if not onScreen or char.Humanoid.Health <= 0 then
            for _, d in pairs(drawings) do
                if typeof(d) ~= "Instance" then d.Visible = false end
            end
            return
        end

        local teamColor = getgenv().EspSettings.TeamColor and player.TeamColor.Color or Color3.new(1, 1, 1)

        if getgenv().EspSettings.BoxType == "2d" then
            local size = Vector3.new(2, 3, 1.5)
            local topLeft = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(-size.X, size.Y, 0))
            local bottomRight = Camera:WorldToViewportPoint(hrp.Position + Vector3.new(size.X, -size.Y, 0))
            drawings.box.Size = Vector2.new(math.abs(topLeft.X - bottomRight.X), math.abs(topLeft.Y - bottomRight.Y))
            drawings.box.Position = Vector2.new(math.min(topLeft.X, bottomRight.X), math.min(topLeft.Y, bottomRight.Y))
            drawings.box.Color = teamColor
            drawings.box.Visible = true
        elseif getgenv().EspSettings.BoxType == "3d" then
            drawings.box3d.Adornee = char
            drawings.box3d.Color3 = teamColor
        end

        if getgenv().EspSettings.Name then
            drawings.name.Position = Vector2.new(pos.X, pos.Y - 30)
            drawings.name.Text = player.Name
            drawings.name.Color = teamColor
            drawings.name.Visible = true
        else
            drawings.name.Visible = false
        end

        if getgenv().EspSettings.Studs then
            local dist = math.floor((LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")) and (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude or 0)
            drawings.distance.Position = Vector2.new(pos.X, pos.Y + 30)
            drawings.distance.Text = tostring(dist) .. "m"
            drawings.distance.Color = teamColor
            drawings.distance.Visible = true
        else
            drawings.distance.Visible = false
        end

        if getgenv().EspSettings.Tracers then
            drawings.tracer.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
            drawings.tracer.To = Vector2.new(pos.X, pos.Y)
            drawings.tracer.Color = teamColor
            drawings.tracer.Visible = true
        else
            drawings.tracer.Visible = false
        end
    end

    local conn = RunService.RenderStepped:Connect(update)

    player.AncestryChanged:Connect(function(_, parent)
        if not parent then
            for _, d in pairs(drawings) do
                if typeof(d) == "Instance" then
                    d:Destroy()
                else
                    d:Remove()
                end
            end
            conn:Disconnect()
            activeDrawings[player] = nil
        end
    end)
end

function deleteESP()
    for _, drawings in pairs(activeDrawings) do
        for _, d in pairs(drawings) do
            if typeof(d) == "Instance" then
                d:Destroy()
            else
                d:Remove()
            end
        end
    end
    activeDrawings = {}
end

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LocalPlayer then
        createESP(plr)
    end
end

Players.PlayerAdded:Connect(function(plr)
    if plr ~= LocalPlayer then
        createESP(plr)
    end
end)

RunService.RenderStepped:Connect(function()
    if not getgenv().EspSettings.Enabled then
        deleteESP()
    end
end)
