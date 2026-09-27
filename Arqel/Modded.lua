--[[
 ________   ________   ________   _______    ___        ___  ___   ___     
|\   __  \ |\   __  \ |\   __  \ |\  ___ \  |\  \      |\  \|\  \ |\  \    
\ \  \|\  \\ \  \|\  \\ \  \|\  \\ \   __/| \ \  \     \ \  \\\  \\ \  \   
 \ \   __  \\ \   _  _\\ \  \\\  \\ \  \_|/__\ \  \     \ \  \\\  \\ \  \  
  \ \  \ \  \\ \  \\  \|\ \  \\\  \\ \  \_|\ \\ \  \____ \ \  \\\  \\ \  \ 
   \ \__\ \__\\ \__\\ _\ \ \_____  \\ \_______\\ \_______\\ \_______\\ \__\
    \|__|\|__| \|__|\|__| \|___| \__\\|_______| \|_______| \|_______| \|__|
                                \|__|                                      
                                                                           

     Github - https://github.com/Cobruhehe/expert-octo-doodle
     Author: Cobru (Cobruhehe, .cobru)
     License: MIT
                                                                           
]]

repeat task.wait() until game:IsLoaded()

local cloneref = cloneref or function(obj) return obj end
local gethui = gethui or function() return cloneref(game:GetService("CoreGui")) end

--services
local TweenService = cloneref(game:GetService("TweenService"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local Workspace = cloneref(game:GetService("Workspace"))
local RunService = cloneref(game:GetService("RunService"))
local Lighting = cloneref(game:GetService("Lighting"))
local Players = cloneref(game:GetService("Players"))

local hui = gethui()

if getgenv().ArqelLoaded and hui:FindFirstChild("ArqelKeySystem") then return getgenv().Arqel end
if getgenv().ArqelLoaded and hui:FindFirstChild("ArqelKeylessSystem") then return getgenv().Arqel end
getgenv().ArqelLoaded = true
getgenv().ArqelClosed = false

local Arqel = {}

--appearance
Arqel.Appearance = {
    Title = "InfinityX",
    Subtitle = "Secure Access",
    Description = "Enter your InfinityX access key to continue.",
    Icon = "rbxassetid://92308401887821",
    IconSize = UDim2.new(0, 34, 0, 34)
}

--links
Arqel.Links = {
    GetKey = "https://jnkie.com/get-key/infinityx",
    Discord = ""
}

--storage
Arqel.Storage = {
    FileName = "Arqel_Key",
    Remember = true,
    AutoLoad = true
}

--options
Arqel.Options = {
    Keyless = nil,
    KeylessUI = false,
    Blur = true,
    Draggable = true,
    NoGetKey = false
}

--theme
Arqel.Theme = {
    Accent = Color3.fromRGB(179, 136, 255),
    AccentHover = Color3.fromRGB(168, 117, 255),
    Background = Color3.fromRGB(11, 13, 16),
    Header = Color3.fromRGB(16, 19, 24),
    Input = Color3.fromRGB(20, 24, 32),
    Surface = Color3.fromRGB(18, 22, 29),
    SurfaceHover = Color3.fromRGB(22, 27, 36),
    Text = Color3.fromRGB(245, 243, 250),
    TextDim = Color3.fromRGB(145, 145, 158),
    Success = Color3.fromRGB(88, 196, 125),
    Error = Color3.fromRGB(210, 82, 99),
    Warning = Color3.fromRGB(214, 164, 76),
    StatusIdle = Color3.fromRGB(125, 129, 140),
    Discord = Color3.fromRGB(145, 122, 235),
    DiscordHover = Color3.fromRGB(164, 140, 250),
    Divider = Color3.fromRGB(37, 42, 53),
    Pending = Color3.fromRGB(54, 59, 70)
}

--callbacks
Arqel.Callbacks = {
    OnVerify = nil,
    OnSuccess = nil,
    OnFail = nil,
    OnClose = nil
}

Arqel.Changelog = {}

--shop
Arqel.Shop = {
    Enabled = false,
    Icon = "",
    Title = "Get Premium Access",
    Subtitle = "Instant delivery • 24/7 support",
    ButtonText = "Buy",
    Link = ""
}

--internal
local Internal = {
    Junkie = nil,
    BlurEffect = nil,
    NotificationList = {},
    ValidateFunction = nil,
    IsJunkieMode = false,
    IconsLoaded = false
}

local IconBaseURL = "https://raw.githubusercontent.com/Cobruhehe/expert-octo-doodle/main/Icons/"
local IconFiles = {
    key = "lucide--key.png",
    shield = "lucide--shield-minus.png",
    check = "prime--check-square.png",
    copy = "flowbite--clipboard-outline.png",
    discord = "qlementine-icons--discord-16.png",
    alert = "mdi--alert-octagon-outline.png",
    lock = "lucide--user-lock.png",
    loading = "nonicons--loading-16.png",
    close = "material-symbols--dangerous-outline.png",
    changelog = "ant-design--sync-outlined.png",
    logo = "rrjlGmac.png",
    user = "U.png",
    clock = "Clock.png",
    cart = "Cart.png",
    nogetkey = "lucide--lock.png",
    keyround = "lucide--key-round.png",
    external = "lucide--external-link.png",
    badge = "lucide--badge.png",
    mapPin = "lucide--map-pin.png",
    server = "lucide--server.png",
    circleCheck = "lucide--circle-check.png",
    circleX = "lucide--circle-x.png",
    loader = "lucide--loader-circle.png",
    chart = "lucide--chart-no-axes-column.png",
    arrow = "lucide--arrow-right.png"
}

local FallbackIcons = {
    key = "rbxassetid://96510194465420",
    shield = "rbxassetid://89965059528921",
    check = "rbxassetid://76078495178149",
    copy = "rbxassetid://125851897718493",
    discord = "rbxassetid://83278450537116",
    alert = "rbxassetid://140438367956051",
    lock = "rbxassetid://114355063515473",
    loading = "rbxassetid://116535712789945",
    close = "rbxassetid://6022668916",
    changelog = "rbxassetid://138133190015277",
    logo = "rbxassetid://92308401887821",
    user = "rbxassetid://77400125196692",
    clock = "rbxassetid://87505349362628",
    cart = "rbxassetid://114754518183872",
    nogetkey = "rbxassetid://119765975153029",
    keyround = "rbxassetid://96510194465420",
    external = "rbxassetid://138133190015277",
    badge = "rbxassetid://89965059528921",
    mapPin = "rbxassetid://138133190015277",
    server = "rbxassetid://114355063515473",
    circleCheck = "rbxassetid://76078495178149",
    circleX = "rbxassetid://6022668916",
    loader = "rbxassetid://116535712789945",
    chart = "rbxassetid://138133190015277",
    arrow = "rbxassetid://138133190015277"
}

local CachedIcons = {}
local FolderName = "Arqel"
local IconsFolder = "Icons"
local DefaultLogoAsset = "rbxassetid://95721401302279"

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function getScale()
    local viewport = Workspace.CurrentCamera.ViewportSize
    return math.clamp(math.min(viewport.X, viewport.Y) / 900, 0.65, 1.3)
end

local function hasFileSystem()
    local ok1 = pcall(function() return type(writefile) == "function" end)
    local ok2 = pcall(function() return type(readfile) == "function" end)
    local ok3 = pcall(function() return type(isfile) == "function" end)
    local ok4 = pcall(function() return type(makefolder) == "function" end)
    local ok5 = pcall(function() return type(isfolder) == "function" end)
    return ok1 and ok2 and ok3 and ok4 and ok5
end

local fileSystemSupported = hasFileSystem()

local function getFileName()
    return FolderName .. "/" .. Arqel.Storage.FileName .. ".txt"
end

local function saveKey(key)
    if not fileSystemSupported or not Arqel.Storage.Remember then return false end
    return pcall(function() writefile(getFileName(), key) end)
end

local function loadKey()
    if not fileSystemSupported then return nil end
    local ok, content = pcall(function()
        if isfile(getFileName()) then return readfile(getFileName()) end
        return nil
    end)
    if ok and content and content ~= "" then return content end
    return nil
end

local function clearKey()
    if not fileSystemSupported then return false end
    return pcall(function() delfile(getFileName()) end)
end

local function ensureFolders()
    if not fileSystemSupported then return false end
    pcall(function()
        if not isfolder(FolderName) then makefolder(FolderName) end
        if not isfolder(FolderName .. "/" .. IconsFolder) then makefolder(FolderName .. "/" .. IconsFolder) end
    end)
    return true
end

local function getIconPath(iconName)
    return FolderName .. "/" .. IconsFolder .. "/" .. IconFiles[iconName]
end

local function isIconCached(iconName)
    if not fileSystemSupported then return false end
    local success, result = pcall(function() return isfile(getIconPath(iconName)) end)
    return success and result
end

local function downloadIcon(iconName)
    if not fileSystemSupported then
        CachedIcons[iconName] = FallbackIcons[iconName]
        return false
    end
    local path = getIconPath(iconName)
    if isIconCached(iconName) then
        local success = pcall(function() CachedIcons[iconName] = getcustomasset(path) end)
        if success then return true end
    end
    local success = pcall(function()
        local response = game:HttpGet(IconBaseURL .. IconFiles[iconName])
        if #response < 100 then error("Invalid") end
        writefile(path, response)
        CachedIcons[iconName] = getcustomasset(path)
    end)
    if not success then CachedIcons[iconName] = FallbackIcons[iconName] end
    return success
end

local function getIcon(iconName)
    return CachedIcons[iconName] or FallbackIcons[iconName]
end

local function getLogoIcon()
    if Arqel.Appearance.Icon == DefaultLogoAsset then return getIcon("logo") end
    return Arqel.Appearance.Icon
end

local function shouldDownloadLogo()
    return Arqel.Appearance.Icon == DefaultLogoAsset
end

local function getShopIcon()
    if Arqel.Shop.Icon == "" then return getLogoIcon() end
    return Arqel.Shop.Icon
end

local function isShopEnabled()
    return Arqel.Shop.Enabled
end

local function allIconsCached()
    if not fileSystemSupported then return false end
    local iconNames = {
        "key", "shield", "check", "copy", "discord", "alert", "lock", "loading",
        "close", "changelog", "user", "clock", "cart", "nogetkey",
        "keyround", "external", "badge", "mapPin", "server", "circleCheck", "circleX", "loader", "chart", "arrow"
    }
    if shouldDownloadLogo() then table.insert(iconNames, "logo") end
    for _, name in ipairs(iconNames) do
        if not isIconCached(name) then return false end
    end
    return true
end

local function loadAllIconsFromCache()
    ensureFolders()
    local iconNames = {
        "key", "shield", "check", "copy", "discord", "alert", "lock", "loading",
        "close", "changelog", "user", "clock", "cart", "nogetkey",
        "keyround", "external", "badge", "mapPin", "server", "circleCheck", "circleX", "loader", "chart", "arrow"
    }
    if shouldDownloadLogo() then table.insert(iconNames, "logo") end
    for _, name in ipairs(iconNames) do downloadIcon(name) end
    Internal.IconsLoaded = true
end

local function getExecutorName()
    local success, name = pcall(identifyexecutor)
    if success and name then return tostring(name) end
    return "Unknown"
end

local function getDeviceType()
    local touch = UserInputService.TouchEnabled
    local keyboard = UserInputService.KeyboardEnabled
    local gamepad = UserInputService.GamepadEnabled
    if gamepad and not keyboard and not touch then return "Console"
    elseif touch and not keyboard then return "Mobile"
    elseif keyboard and touch then return "PC & Touch"
    elseif keyboard then return "PC"
    else return "Unknown" end
end

local function getHWID()
    local hwid = nil
    pcall(function() if gethwid then hwid = gethwid() end end)
    if not hwid then pcall(function() if getgenv().HWID then hwid = getgenv().HWID end end) end
    if not hwid then pcall(function() if game.RobloxHWID then hwid = tostring(game.RobloxHWID) end end) end
    if not hwid then
        local player = cloneref(Players.LocalPlayer)
        hwid = HttpService:GenerateGUID(false):gsub("-", ""):sub(1, 32)
        if player then hwid = tostring(player.UserId) .. hwid:sub(1, 20) end
    end
    return hwid or "N/A"
end

local function generateHiddenDots(availableWidth, charWidth)
    charWidth = charWidth or 5
    local count = math.floor(availableWidth / charWidth)
    count = math.max(count, 8)
    return string.rep("•", count)
end

local function formatTime12()
    local hour = tonumber(os.date("%H"))
    local min = os.date("%M")
    local sec = os.date("%S")
    local period = "AM"
    if hour >= 12 then period = "PM" end
    if hour > 12 then hour = hour - 12 end
    if hour == 0 then hour = 12 end
    return string.format("%d:%s:%s %s", hour, min, sec, period)
end

local function formatDate()
    return os.date("%b %d, %Y")
end

local function enableBlur()
    if not Arqel.Options.Blur then return end
    local existing = Lighting:FindFirstChild("ArqelKeySystemBlur")
    if existing then existing:Destroy() end
    Internal.BlurEffect = Instance.new("BlurEffect")
    Internal.BlurEffect.Name = "ArqelKeySystemBlur"
    Internal.BlurEffect.Size = 0
    Internal.BlurEffect.Parent = Lighting
    TweenService:Create(Internal.BlurEffect, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = 24}):Play()
end

local function disableBlur()
    if Internal.BlurEffect and Internal.BlurEffect.Parent then
        TweenService:Create(Internal.BlurEffect, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = 0}):Play()
        task.delay(0.3, function()
            if Internal.BlurEffect and Internal.BlurEffect.Parent then
                Internal.BlurEffect:Destroy()
                Internal.BlurEffect = nil
            end
        end)
    else
        local existing = Lighting:FindFirstChild("ArqelKeySystemBlur")
        if existing then existing:Destroy() end
        Internal.BlurEffect = nil
    end
end

local function fullCleanup()
    getgenv().ArqelLoaded = false
    getgenv().ArqelClosed = true
    disableBlur()
    local gui1 = hui:FindFirstChild("ArqelKeySystem")
    local gui2 = hui:FindFirstChild("ArqelKeylessSystem")
    local gui3 = hui:FindFirstChild("ArqelLoadingScreen")
    if gui1 then gui1:Destroy() end
    if gui2 then gui2:Destroy() end
    if gui3 then gui3:Destroy() end
end

local function setupDragging(header, main)
    if not Arqel.Options.Draggable then return end
    local dragging, dragStart, startPos, dragInput
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            dragInput = input
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    if dragInput == input then dragging = false dragInput = nil end
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if not dragging or not dragInput then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        elseif input.UserInputType == Enum.UserInputType.Touch then
            if input == dragInput then
                local delta = input.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

local function validateKey(key, validateFunc)
    if not validateFunc or not key or key == "" then return false end
    local success, result = pcall(validateFunc, key)
    if not success then return false end
    if type(result) == "table" then return result.valid == true end
    if type(result) == "boolean" then return result end
    return false
end

local function CreateDoorOverlay(parentFrame, width, height)
    local overlay = Instance.new("Frame")
    overlay.Name = "DoorOverlay"
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundTransparency = 1
    overlay.ClipsDescendants = true
    overlay.ZIndex = 50
    overlay.Parent = parentFrame

    local leftDoor = Instance.new("Frame")
    leftDoor.Name = "LeftDoor"
    leftDoor.Size = UDim2.new(0.5, 0, 1, 0)
    leftDoor.Position = UDim2.new(0, 0, 0, 0)
    leftDoor.BackgroundColor3 = Arqel.Theme.Header
    leftDoor.BorderSizePixel = 0
    leftDoor.ZIndex = 51
    leftDoor.Parent = overlay

    local rightDoor = Instance.new("Frame")
    rightDoor.Name = "RightDoor"
    rightDoor.Size = UDim2.new(0.5, 0, 1, 0)
    rightDoor.Position = UDim2.new(0.5, 0, 0, 0)
    rightDoor.BackgroundColor3 = Arqel.Theme.Header
    rightDoor.BorderSizePixel = 0
    rightDoor.ZIndex = 51
    rightDoor.Parent = overlay

    local logoSize = math.min(width, height) * 0.28
    local logoImage = Instance.new("ImageLabel")
    logoImage.Name = "DoorLogo"
    logoImage.Size = UDim2.new(0, logoSize, 0, logoSize)
    logoImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    logoImage.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImage.BackgroundTransparency = 1
    logoImage.Image = getLogoIcon()
    logoImage.ImageColor3 = Arqel.Theme.Text
    logoImage.ScaleType = Enum.ScaleType.Fit
    logoImage.ZIndex = 54
    logoImage.Parent = overlay

    local halfWidth = math.ceil(width / 2)

    local function openDoors(callback)
        TweenService:Create(logoImage, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {ImageTransparency = 1}):Play()
        task.wait(0.25)
        TweenService:Create(leftDoor, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(0, -halfWidth, 0, 0)}):Play()
        TweenService:Create(rightDoor, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.45)
        overlay.Visible = false
        if callback then callback() end
    end

    local function closeDoors(callback)
        overlay.Visible = true
        leftDoor.Position = UDim2.new(0, -halfWidth, 0, 0)
        rightDoor.Position = UDim2.new(1, 0, 0, 0)
        logoImage.ImageTransparency = 1
        TweenService:Create(leftDoor, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)}):Play()
        TweenService:Create(rightDoor, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Position = UDim2.new(0.5, 0, 0, 0)}):Play()
        task.wait(0.38)
        TweenService:Create(logoImage, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {ImageTransparency = 0}):Play()
        task.wait(0.3)
        if callback then callback() end
    end

    return {overlay = overlay, open = openDoors, close = closeDoors}
end

local function ShowLoadingScreen(onComplete)
    local completed = false
    local oldGui = hui:FindFirstChild("ArqelLoadingScreen")
    if oldGui then oldGui:Destroy() end
    local oldBlur = Lighting:FindFirstChild("ArqelLoadingBlur")
    if oldBlur then oldBlur:Destroy() end

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Name = "ArqelLoadingBlur"
    blurEffect.Size = 0
    blurEffect.Parent = Lighting

    local gui = Instance.new("ScreenGui")
    gui.Name = "ArqelLoadingScreen"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = hui

    local mobile = isMobile()

    local loadingScreen = Instance.new("Frame")
    loadingScreen.Size = UDim2.new(1, 0, 1, 0)
    loadingScreen.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    loadingScreen.BackgroundTransparency = 1
    loadingScreen.BorderSizePixel = 0
    loadingScreen.Parent = gui

    local linesContainer = Instance.new("Frame")
    linesContainer.Size = UDim2.new(1, 0, 1, 0)
    linesContainer.BackgroundTransparency = 1
    linesContainer.Parent = loadingScreen

    local longLines = {}
    local linePositions = {0.15, 0.35, 0.65, 0.85}
    for i = 1, 4 do
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0.3, 0, 0, mobile and 2 or 3)
        line.Position = UDim2.new(1.3, 0, linePositions[i], 0)
        line.BackgroundColor3 = Arqel.Theme.Text
        line.BackgroundTransparency = 1
        line.BorderSizePixel = 0
        line.Parent = linesContainer
        Instance.new("UICorner", line).CornerRadius = UDim.new(1, 0)
        longLines[i] = line
    end

    local shipSize = mobile and 18 or 28
    local shipContainer = Instance.new("Frame")
    shipContainer.Size = UDim2.new(0, mobile and 100 or 150, 0, mobile and 30 or 50)
    shipContainer.Position = UDim2.new(0.5, 0, 0.35, 0)
    shipContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    shipContainer.BackgroundTransparency = 1
    shipContainer.Parent = loadingScreen

    local shipBody = Instance.new("Frame")
    shipBody.Size = UDim2.new(0, shipSize, 0, shipSize)
    shipBody.Position = UDim2.new(0.5, 10, 0.5, 0)
    shipBody.AnchorPoint = Vector2.new(0.5, 0.5)
    shipBody.BackgroundColor3 = Arqel.Theme.Text
    shipBody.BackgroundTransparency = 1
    shipBody.BorderSizePixel = 0
    shipBody.Parent = shipContainer
    Instance.new("UICorner", shipBody).CornerRadius = UDim.new(1, 0)

    local pointSize = mobile and 10 or 16
    local shipPoint = Instance.new("Frame")
    shipPoint.Size = UDim2.new(0, pointSize, 0, pointSize)
    shipPoint.Position = UDim2.new(1, 2, 0.5, 0)
    shipPoint.AnchorPoint = Vector2.new(0, 0.5)
    shipPoint.BackgroundColor3 = Arqel.Theme.Text
    shipPoint.BackgroundTransparency = 1
    shipPoint.BorderSizePixel = 0
    shipPoint.Rotation = 45
    shipPoint.Parent = shipBody
    Instance.new("UICorner", shipPoint).CornerRadius = UDim.new(0, 3)

    local trails = {}
    local trailConfigs = {
        {y = 0.20, width = mobile and 45 or 70},
        {y = 0.38, width = mobile and 60 or 95},
        {y = 0.62, width = mobile and 55 or 85},
        {y = 0.80, width = mobile and 40 or 65}
    }
    for i, config in ipairs(trailConfigs) do
        local trail = Instance.new("Frame")
        trail.Size = UDim2.new(0, config.width, 0, mobile and 2 or 3)
        trail.Position = UDim2.new(0.5, -15, config.y, 0)
        trail.AnchorPoint = Vector2.new(1, 0.5)
        trail.BackgroundColor3 = Arqel.Theme.Text
        trail.BackgroundTransparency = 1
        trail.BorderSizePixel = 0
        trail.Parent = shipContainer
        local gradient = Instance.new("UIGradient", trail)
        gradient.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(0.3, 0.5), NumberSequenceKeypoint.new(1, 0)})
        Instance.new("UICorner", trail).CornerRadius = UDim.new(1, 0)
        trails[i] = {frame = trail, config = config}
    end

    local phasesContainer = Instance.new("Frame")
    phasesContainer.Size = UDim2.new(0, mobile and 200 or 280, 0, mobile and 150 or 180)
    phasesContainer.Position = UDim2.new(0.5, 0, 0.62, 0)
    phasesContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    phasesContainer.BackgroundTransparency = 1
    phasesContainer.Parent = loadingScreen

    local phasesLayout = Instance.new("UIListLayout", phasesContainer)
    phasesLayout.Padding = UDim.new(0, mobile and 8 or 12)
    phasesLayout.SortOrder = Enum.SortOrder.LayoutOrder
    phasesLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    phasesLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local phases = {}
    local phaseNames = {"Initializing", "Creating folders", "Downloading assets", "Preparing interface", "Ready"}
    local phaseTextSize = mobile and 14 or 18

    for i, name in ipairs(phaseNames) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, mobile and 22 or 28)
        row.BackgroundTransparency = 1
        row.LayoutOrder = i
        row.Parent = phasesContainer

        local indicator = Instance.new("TextLabel")
        indicator.Size = UDim2.new(0, mobile and 22 or 28, 0, mobile and 22 or 28)
        indicator.BackgroundTransparency = 1
        indicator.Text = "○"
        indicator.TextColor3 = Arqel.Theme.Pending
        indicator.TextSize = phaseTextSize
        indicator.Font = Enum.Font.ArimoBold
        indicator.TextTransparency = 1
        indicator.Parent = row

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, mobile and -28 or -35, 1, 0)
        label.Position = UDim2.new(0, mobile and 28 or 35, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = name
        label.TextColor3 = Arqel.Theme.Pending
        label.TextSize = phaseTextSize
        label.Font = Enum.Font.ArimoBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.TextTransparency = 1
        label.Parent = row

        phases[i] = {indicator = indicator, label = label}
    end

    local animationRunning = true
    local currentPhase = 0
    local pulseThread = nil

    local function animateLongLines()
        local speeds = {0.8, 1.0, 0.7, 0.9}
        while animationRunning do
            for i, line in ipairs(longLines) do
                task.spawn(function()
                    line.Position = UDim2.new(1.3, 0, linePositions[i], 0)
                    line.BackgroundTransparency = 0.5
                    TweenService:Create(line, TweenInfo.new(speeds[i], Enum.EasingStyle.Linear), {Position = UDim2.new(-0.4, 0, linePositions[i], 0), BackgroundTransparency = 0.9}):Play()
                end)
            end
            task.wait(0.5)
        end
    end

    local function animateTrails()
        while animationRunning do
            for _, trail in ipairs(trails) do
                local newWidth = trail.config.width + math.random(-12, 12)
                TweenService:Create(trail.frame, TweenInfo.new(0.12, Enum.EasingStyle.Quad), {Size = UDim2.new(0, newWidth, 0, mobile and 2 or 3), BackgroundTransparency = 0.1 + math.random() * 0.3}):Play()
            end
            task.wait(0.1)
        end
    end

    local function animateShipShake()
        while animationRunning do
            local shakeAmount = mobile and 2 or 3
            TweenService:Create(shipContainer, TweenInfo.new(0.04, Enum.EasingStyle.Linear), {Position = UDim2.new(0.5, math.random(-shakeAmount, shakeAmount), 0.35, math.random(-1, 1))}):Play()
            task.wait(0.04)
        end
    end

    local function setPhase(num)
        if pulseThread then task.cancel(pulseThread) pulseThread = nil end
        for i = 1, 5 do
            local p = phases[i]
            if i < num then
                p.indicator.Text = "●"
                TweenService:Create(p.indicator, TweenInfo.new(0.2), {TextColor3 = Arqel.Theme.Success, TextTransparency = 0}):Play()
                TweenService:Create(p.label, TweenInfo.new(0.2), {TextColor3 = Arqel.Theme.Success}):Play()
            elseif i == num then
                p.indicator.Text = "●"
                p.indicator.TextTransparency = 0
                TweenService:Create(p.indicator, TweenInfo.new(0.2), {TextColor3 = Arqel.Theme.Accent}):Play()
                TweenService:Create(p.label, TweenInfo.new(0.2), {TextColor3 = Arqel.Theme.Text}):Play()
                currentPhase = num
                pulseThread = task.spawn(function()
                    while currentPhase == num do
                        TweenService:Create(p.indicator, TweenInfo.new(0.4), {TextTransparency = 0.5}):Play()
                        task.wait(0.4)
                        if currentPhase ~= num then break end
                        TweenService:Create(p.indicator, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
                        task.wait(0.4)
                    end
                end)
            else
                p.indicator.Text = "○"
                p.indicator.TextColor3 = Arqel.Theme.Pending
                p.label.TextColor3 = Arqel.Theme.Pending
            end
        end
    end

    task.spawn(function()
        TweenService:Create(blurEffect, TweenInfo.new(0.6), {Size = 24}):Play()
        TweenService:Create(loadingScreen, TweenInfo.new(0.5), {BackgroundTransparency = 0.25}):Play()
        task.wait(0.3)
        TweenService:Create(shipBody, TweenInfo.new(0.4, Enum.EasingStyle.Back), {BackgroundTransparency = 0}):Play()
        TweenService:Create(shipPoint, TweenInfo.new(0.4, Enum.EasingStyle.Back), {BackgroundTransparency = 0}):Play()
        task.spawn(animateLongLines)
        task.spawn(animateTrails)
        task.spawn(animateShipShake)
        task.wait(0.2)
        for i = 1, 5 do
            task.delay((i-1)*0.08, function()
                TweenService:Create(phases[i].indicator, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
                TweenService:Create(phases[i].label, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
            end)
        end
        task.wait(0.5)
        setPhase(1)
        task.wait(0.3)
        setPhase(2) ensureFolders() task.wait(0.25)
        setPhase(3)
        local iconNames = {
        "key", "shield", "check", "copy", "discord", "alert", "lock", "loading",
        "close", "changelog", "user", "clock", "cart", "nogetkey",
        "keyround", "external", "badge", "mapPin", "server", "circleCheck", "circleX", "loader", "chart", "arrow"
    }
        if shouldDownloadLogo() then table.insert(iconNames, "logo") end
        for _, name in ipairs(iconNames) do downloadIcon(name) task.wait(0.06) end
        Internal.IconsLoaded = true
        setPhase(4) task.wait(0.25)
        setPhase(5) task.wait(0.5)
        animationRunning = false
        if pulseThread then task.cancel(pulseThread) end
        TweenService:Create(loadingScreen, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        TweenService:Create(shipBody, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(shipPoint, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        for _, trail in pairs(trails) do TweenService:Create(trail.frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() end
        for _, line in pairs(longLines) do TweenService:Create(line, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play() end
        for i = 1, 5 do
            TweenService:Create(phases[i].indicator, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
            TweenService:Create(phases[i].label, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        end
        TweenService:Create(blurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
        task.wait(0.5)
        gui:Destroy()
        blurEffect:Destroy()
        if onComplete then onComplete() end
        completed = true
    end)

    while not completed do task.wait(0.05) end
end

local function EnsureIconsReady(callback)
    if allIconsCached() then
        loadAllIconsFromCache()
        if callback then callback() end
    else
        ShowLoadingScreen(callback)
    end
end

function Arqel:Notify(title, message, duration, iconType)
    duration = duration or 5
    iconType = iconType or "info"
    local scale = getScale()
    local width = math.clamp(320 * scale, 260, 380)
    local height = math.clamp(80 * scale, 75, 105)

    local notifGui = Instance.new("ScreenGui")
    notifGui.ResetOnSpawn = false
    notifGui.DisplayOrder = 999999
    notifGui.Parent = hui

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, width, 0, height)
    frame.Position = UDim2.new(1, width + 20, 1, -15)
    frame.AnchorPoint = Vector2.new(1, 1)
    frame.BackgroundColor3 = Arqel.Theme.Header
    frame.BorderSizePixel = 0
    frame.Parent = notifGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 4)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Arqel.Theme.Accent
    stroke.Thickness = 1
    stroke.Transparency = 0.7

    local progressBg = Instance.new("Frame")
    progressBg.Size = UDim2.new(1, 0, 0, 2)
    progressBg.Position = UDim2.new(0, 0, 1, -2)
    progressBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    progressBg.BorderSizePixel = 0
    progressBg.Parent = frame

    local progressBar = Instance.new("Frame")
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = Arqel.Theme.Accent
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressBg

    local iconSize = height - 35
    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, iconSize, 0, iconSize)
    icon.Position = UDim2.new(0, 14, 0.5, -2)
    icon.AnchorPoint = Vector2.new(0, 0.5)
    icon.BackgroundTransparency = 1
    icon.ScaleType = Enum.ScaleType.Fit
    icon.Parent = frame

    local iconMap = {
        success = {"check", Arqel.Theme.Success}, error = {"alert", Arqel.Theme.Error},
        warning = {"alert", Arqel.Theme.Warning}, shield = {"shield", Arqel.Theme.Accent},
        info = {"shield", Arqel.Theme.Accent}, key = {"key", Arqel.Theme.Accent},
        copy = {"copy", Arqel.Theme.Success}, discord = {"discord", Arqel.Theme.Discord},
        close = {"close", Arqel.Theme.Error}, nogetkey = {"nogetkey", Arqel.Theme.TextDim}
    }

    if iconMap[iconType] then
        icon.Image = getIcon(iconMap[iconType][1])
        icon.ImageColor3 = iconMap[iconType][2]
    else
        icon.Image = getLogoIcon()
        icon.ImageColor3 = Arqel.Theme.Text
    end

    local textX = 14 + iconSize + 14
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -(textX + 14), 0, 24)
    titleLabel.Position = UDim2.new(0, textX, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.ArimoBold
    titleLabel.TextSize = math.clamp(15 * scale, 13, 18)
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextColor3 = Arqel.Theme.Text
    titleLabel.Text = title
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.Parent = frame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Size = UDim2.new(1, -(textX + 14), 0, 22)
    messageLabel.Position = UDim2.new(0, textX, 0, 38)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.ArimoBold
    messageLabel.TextSize = math.clamp(13 * scale, 11, 15)
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextColor3 = Arqel.Theme.TextDim
    messageLabel.Text = message
    messageLabel.TextTruncate = Enum.TextTruncate.AtEnd
    messageLabel.Parent = frame

    local id = tick() .. HttpService:GenerateGUID(false)
    table.insert(Internal.NotificationList, {id = id, frame = frame, gui = notifGui, height = height})

    local function restack()
        local yOffset = 0
        for i = #Internal.NotificationList, 1, -1 do
            local n = Internal.NotificationList[i]
            if n and n.frame and n.frame.Parent then
                TweenService:Create(n.frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -15, 1, -15 - yOffset)}):Play()
                yOffset = yOffset + n.height + 12
            end
        end
    end

    TweenService:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -15, 1, -15)}):Play()
    task.wait(0.1)
    restack()

    local function dismiss()
        for i, n in ipairs(Internal.NotificationList) do
            if n.id == id then table.remove(Internal.NotificationList, i) break end
        end
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, width + 20, frame.Position.Y.Scale, frame.Position.Y.Offset)}):Play()
        task.wait(0.3)
        notifGui:Destroy()
        restack()
    end

    TweenService:Create(progressBar, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 1, 0)}):Play()
    task.delay(duration, dismiss)

    local clickBtn = Instance.new("TextButton")
    clickBtn.Size = UDim2.new(1, 0, 1, 0)
    clickBtn.BackgroundTransparency = 1
    clickBtn.Text = ""
    clickBtn.Parent = frame
    clickBtn.MouseButton1Click:Connect(dismiss)
end

local function CreateChangelogPanel(parent, windowWidth, panelHeight, panelWidth, mainFrame, gap)
    panelWidth = panelWidth or 220
    local isOpen = false

    local panel = Instance.new("Frame")
    panel.Name = "ChangelogPanel"
    panel.Size = UDim2.new(0, 0, 0, panelHeight)
    panel.Position = UDim2.new(1, gap, 0, 0)
    panel.BackgroundColor3 = Arqel.Theme.Background
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Parent = mainFrame
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 4)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Arqel.Theme.Accent
    panelStroke.Thickness = 2
    panelStroke.Transparency = 1

    local panelHeader = Instance.new("Frame")
    panelHeader.Size = UDim2.new(1, 0, 0, 50)
    panelHeader.BackgroundColor3 = Arqel.Theme.Header
    panelHeader.BorderSizePixel = 0
    panelHeader.Parent = panel
    Instance.new("UICorner", panelHeader).CornerRadius = UDim.new(0, 4)

    local panelHeaderFix = Instance.new("Frame")
    panelHeaderFix.Size = UDim2.new(1, 0, 0, 8)
    panelHeaderFix.Position = UDim2.new(0, 0, 1, -8)
    panelHeaderFix.BackgroundColor3 = Arqel.Theme.Header
    panelHeaderFix.BorderSizePixel = 0
    panelHeaderFix.Parent = panelHeader

    local panelHeaderLine = Instance.new("Frame")
    panelHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    panelHeaderLine.Position = UDim2.new(0, 0, 1, 0)
    panelHeaderLine.BackgroundColor3 = Arqel.Theme.Accent
    panelHeaderLine.BackgroundTransparency = 0.6
    panelHeaderLine.BorderSizePixel = 0
    panelHeaderLine.Parent = panelHeader

    local panelHeaderIcon = Instance.new("ImageLabel")
    panelHeaderIcon.Size = UDim2.new(0, 16, 0, 16)
    panelHeaderIcon.Position = UDim2.new(0, 12, 0.5, 0)
    panelHeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    panelHeaderIcon.BackgroundTransparency = 1
    panelHeaderIcon.Image = getIcon("changelog")
    panelHeaderIcon.ImageColor3 = Arqel.Theme.Accent
    panelHeaderIcon.ScaleType = Enum.ScaleType.Fit
    panelHeaderIcon.Parent = panelHeader

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -65, 1, 0)
    panelTitle.Position = UDim2.new(0, 34, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "Changelog"
    panelTitle.TextColor3 = Arqel.Theme.Text
    panelTitle.TextSize = 16
    panelTitle.Font = Enum.Font.ArimoBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelHeader

    local panelClose = Instance.new("ImageButton")
    panelClose.Size = UDim2.new(0, 20, 0, 20)
    panelClose.Position = UDim2.new(1, -14, 0.5, 0)
    panelClose.AnchorPoint = Vector2.new(1, 0.5)
    panelClose.BackgroundTransparency = 1
    panelClose.Image = getIcon("close")
    panelClose.ImageColor3 = Arqel.Theme.TextDim
    panelClose.ScaleType = Enum.ScaleType.Fit
    panelClose.Parent = panelHeader
    panelClose.MouseEnter:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    panelClose.MouseLeave:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, 0, 1, -55)
    scrollFrame.Position = UDim2.new(0, 0, 0, 55)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.BorderSizePixel = 0
    scrollFrame.ScrollBarThickness = 4
    scrollFrame.ScrollBarImageColor3 = Arqel.Theme.Accent
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollFrame.Parent = panel

    local scrollPadding = Instance.new("UIPadding", scrollFrame)
    scrollPadding.PaddingLeft = UDim.new(0, 10)
    scrollPadding.PaddingRight = UDim.new(0, 10)
    scrollPadding.PaddingTop = UDim.new(0, 5)
    scrollPadding.PaddingBottom = UDim.new(0, 5)

    local contentLayout = Instance.new("UIListLayout", scrollFrame)
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

    for i, update in ipairs(Arqel.Changelog) do
        local entry = Instance.new("Frame")
        entry.Size = UDim2.new(1, 0, 0, 0)
        entry.AutomaticSize = Enum.AutomaticSize.Y
        entry.BackgroundTransparency = 1
        entry.LayoutOrder = i * 2
        entry.Parent = scrollFrame

        local entryLayout = Instance.new("UIListLayout", entry)
        entryLayout.Padding = UDim.new(0, 5)

        local versionLabel = Instance.new("TextLabel")
        versionLabel.Size = UDim2.new(1, 0, 0, 22)
        versionLabel.BackgroundTransparency = 1
        versionLabel.Text = update.Version .. "  •  " .. update.Date
        versionLabel.TextColor3 = Arqel.Theme.Accent
        versionLabel.TextSize = 14
        versionLabel.Font = Enum.Font.ArimoBold
        versionLabel.TextXAlignment = Enum.TextXAlignment.Left
        versionLabel.LayoutOrder = 1
        versionLabel.Parent = entry

        for j, change in ipairs(update.Changes) do
            local changeLabel = Instance.new("TextLabel")
            changeLabel.Size = UDim2.new(1, 0, 0, 0)
            changeLabel.AutomaticSize = Enum.AutomaticSize.Y
            changeLabel.BackgroundTransparency = 1
            changeLabel.Text = "  •  " .. change
            changeLabel.TextColor3 = Arqel.Theme.TextDim
            changeLabel.TextSize = 12
            changeLabel.Font = Enum.Font.ArimoBold
            changeLabel.TextXAlignment = Enum.TextXAlignment.Left
            changeLabel.TextWrapped = true
            changeLabel.LayoutOrder = j + 1
            changeLabel.Parent = entry
        end

        if i < #Arqel.Changelog then
            local divWrapper = Instance.new("Frame")
            divWrapper.Size = UDim2.new(1, 0, 0, 2)
            divWrapper.BackgroundTransparency = 1
            divWrapper.LayoutOrder = i * 2 + 1
            divWrapper.Parent = scrollFrame

            local div = Instance.new("Frame")
            div.Size = UDim2.new(1, 0, 0, 2)
            div.BackgroundColor3 = Arqel.Theme.Divider
            div.BorderSizePixel = 0
            div.Parent = divWrapper
        end
    end

    local function toggle(changelogIcon, container, currentContainerWidth)
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, panelWidth, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, currentContainerWidth + gap + panelWidth, 0, panelHeight)}):Play()
            if changelogIcon then TweenService:Create(changelogIcon, TweenInfo.new(0.3), {Rotation = 180}):Play() end
        else
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, currentContainerWidth, 0, panelHeight)}):Play()
            if changelogIcon then TweenService:Create(changelogIcon, TweenInfo.new(0.3), {Rotation = 0}):Play() end
        end
    end

    panelClose.MouseButton1Click:Connect(function() if isOpen then toggle(nil, parent, windowWidth) end end)
    return panel, toggle, function() return isOpen end, panelWidth
end

local function CreateUserInfoPanel(parent, windowWidth, panelHeight, panelWidth, mainFrame, gap, startOpen)
    panelWidth = panelWidth or 180
    local isOpen = startOpen or false
    local isCompact = panelHeight < 300
    local avatarSize = isCompact and 42 or 55
    local fieldHeight = isCompact and 24 or 28
    local titleSize = isCompact and 8 or 9
    local valueSize = isCompact and 10 or 11
    local welcomeSize = isCompact and 11 or 12
    local spacing = isCompact and 3 or 5

    local panel = Instance.new("Frame")
    panel.Name = "UserInfoPanel"
    panel.Size = UDim2.new(0, isOpen and panelWidth or 0, 0, panelHeight)
    panel.Position = UDim2.new(0, -(gap), 0, 0)
    panel.AnchorPoint = Vector2.new(1, 0)
    panel.BackgroundColor3 = Arqel.Theme.Background
    panel.BorderSizePixel = 0
    panel.ClipsDescendants = true
    panel.Parent = mainFrame
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 4)

    local panelStroke = Instance.new("UIStroke", panel)
    panelStroke.Color = Arqel.Theme.Accent
    panelStroke.Thickness = 2
    panelStroke.Transparency = isOpen and 0.4 or 1

    local panelHeader = Instance.new("Frame")
    panelHeader.Size = UDim2.new(1, 0, 0, 50)
    panelHeader.BackgroundColor3 = Arqel.Theme.Header
    panelHeader.BorderSizePixel = 0
    panelHeader.Parent = panel
    Instance.new("UICorner", panelHeader).CornerRadius = UDim.new(0, 4)

    local panelHeaderFix = Instance.new("Frame")
    panelHeaderFix.Size = UDim2.new(1, 0, 0, 8)
    panelHeaderFix.Position = UDim2.new(0, 0, 1, -8)
    panelHeaderFix.BackgroundColor3 = Arqel.Theme.Header
    panelHeaderFix.BorderSizePixel = 0
    panelHeaderFix.Parent = panelHeader

    local panelHeaderLine = Instance.new("Frame")
    panelHeaderLine.Size = UDim2.new(1, 0, 0, 1)
    panelHeaderLine.Position = UDim2.new(0, 0, 1, 0)
    panelHeaderLine.BackgroundColor3 = Arqel.Theme.Accent
    panelHeaderLine.BackgroundTransparency = 0.6
    panelHeaderLine.BorderSizePixel = 0
    panelHeaderLine.Parent = panelHeader

    local panelHeaderIcon = Instance.new("ImageLabel")
    panelHeaderIcon.Size = UDim2.new(0, 16, 0, 16)
    panelHeaderIcon.Position = UDim2.new(0, 12, 0.5, 0)
    panelHeaderIcon.AnchorPoint = Vector2.new(0, 0.5)
    panelHeaderIcon.BackgroundTransparency = 1
    panelHeaderIcon.Image = getIcon("user")
    panelHeaderIcon.ImageColor3 = Arqel.Theme.Accent
    panelHeaderIcon.ScaleType = Enum.ScaleType.Fit
    panelHeaderIcon.Parent = panelHeader

    local panelTitle = Instance.new("TextLabel")
    panelTitle.Size = UDim2.new(1, -65, 1, 0)
    panelTitle.Position = UDim2.new(0, 34, 0, 0)
    panelTitle.BackgroundTransparency = 1
    panelTitle.Text = "User Info"
    panelTitle.TextColor3 = Arqel.Theme.Text
    panelTitle.TextSize = 16
    panelTitle.Font = Enum.Font.ArimoBold
    panelTitle.TextXAlignment = Enum.TextXAlignment.Left
    panelTitle.Parent = panelHeader

    local panelClose = Instance.new("ImageButton")
    panelClose.Size = UDim2.new(0, 20, 0, 20)
    panelClose.Position = UDim2.new(1, -14, 0.5, 0)
    panelClose.AnchorPoint = Vector2.new(1, 0.5)
    panelClose.BackgroundTransparency = 1
    panelClose.Image = getIcon("close")
    panelClose.ImageColor3 = Arqel.Theme.TextDim
    panelClose.ScaleType = Enum.ScaleType.Fit
    panelClose.Parent = panelHeader
    panelClose.MouseEnter:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    panelClose.MouseLeave:Connect(function() TweenService:Create(panelClose, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(1, 0, 1, -55)
    contentFrame.Position = UDim2.new(0, 0, 0, 55)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = panel

    local contentPadding = Instance.new("UIPadding", contentFrame)
    contentPadding.PaddingLeft = UDim.new(0, 8)
    contentPadding.PaddingRight = UDim.new(0, 8)

    local contentLayout = Instance.new("UIListLayout", contentFrame)
    contentLayout.Padding = UDim.new(0, spacing)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local player = cloneref(Players.LocalPlayer)

    local avatarWrapper = Instance.new("Frame")
    avatarWrapper.Size = UDim2.new(0, avatarSize + 6, 0, avatarSize + 6)
    avatarWrapper.BackgroundTransparency = 1
    avatarWrapper.LayoutOrder = 1
    avatarWrapper.Parent = contentFrame

    local avatarGlow = Instance.new("Frame")
    avatarGlow.Size = UDim2.new(1, 0, 1, 0)
    avatarGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarGlow.BackgroundColor3 = Arqel.Theme.Accent
    avatarGlow.BackgroundTransparency = 0.5
    avatarGlow.BorderSizePixel = 0
    avatarGlow.Parent = avatarWrapper
    Instance.new("UICorner", avatarGlow).CornerRadius = UDim.new(0, 4)

    local avatarGlowStroke = Instance.new("UIStroke", avatarGlow)
    avatarGlowStroke.Color = Arqel.Theme.Accent
    avatarGlowStroke.Thickness = 1.5
    avatarGlowStroke.Transparency = 0.3

    local avatarContainer = Instance.new("Frame")
    avatarContainer.Size = UDim2.new(0, avatarSize, 0, avatarSize)
    avatarContainer.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarContainer.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarContainer.BackgroundColor3 = Arqel.Theme.Input
    avatarContainer.BorderSizePixel = 0
    avatarContainer.ClipsDescendants = true
    avatarContainer.Parent = avatarWrapper
    Instance.new("UICorner", avatarContainer).CornerRadius = UDim.new(0, 4)

    local avatarImage = Instance.new("ImageLabel")
    avatarImage.Size = UDim2.new(1, 0, 1, 0)
    avatarImage.Position = UDim2.new(0.5, 0, 0.5, 0)
    avatarImage.AnchorPoint = Vector2.new(0.5, 0.5)
    avatarImage.BackgroundTransparency = 1
    avatarImage.ScaleType = Enum.ScaleType.Crop
    avatarImage.Parent = avatarContainer
    pcall(function()
        local content = Players:GetUserThumbnailAsync(player and player.UserId or 0, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        avatarImage.Image = content
    end)

    local welcomeLabel = Instance.new("TextLabel")
    welcomeLabel.Size = UDim2.new(1, 0, 0, isCompact and 14 or 18)
    welcomeLabel.BackgroundTransparency = 1
    welcomeLabel.Text = "Welcome, " .. (player and player.DisplayName or "User")
    welcomeLabel.TextColor3 = Arqel.Theme.Text
    welcomeLabel.TextSize = welcomeSize
    welcomeLabel.Font = Enum.Font.ArimoBold
    welcomeLabel.TextTruncate = Enum.TextTruncate.AtEnd
    welcomeLabel.LayoutOrder = 2
    welcomeLabel.Parent = contentFrame

    local divider1 = Instance.new("Frame")
    divider1.Size = UDim2.new(1, 16, 0, 2)
    divider1.Position = UDim2.new(0.5, 0, 0, 0)
    divider1.AnchorPoint = Vector2.new(0.5, 0)
    divider1.BackgroundColor3 = Arqel.Theme.Divider
    divider1.BorderSizePixel = 0
    divider1.LayoutOrder = 3
    divider1.Parent = contentFrame

    local executorContainer = Instance.new("Frame")
    executorContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    executorContainer.BackgroundTransparency = 1
    executorContainer.LayoutOrder = 4
    executorContainer.Parent = contentFrame

    local executorTitle = Instance.new("TextLabel")
    executorTitle.Size = UDim2.new(1, 0, 0, 11)
    executorTitle.BackgroundTransparency = 1
    executorTitle.Text = "Executor"
    executorTitle.TextColor3 = Arqel.Theme.TextDim
    executorTitle.TextSize = titleSize
    executorTitle.Font = Enum.Font.ArimoBold
    executorTitle.TextXAlignment = Enum.TextXAlignment.Left
    executorTitle.Parent = executorContainer

    local executorValue = Instance.new("TextLabel")
    executorValue.Size = UDim2.new(1, 0, 0, 14)
    executorValue.Position = UDim2.new(0, 0, 0, 11)
    executorValue.BackgroundTransparency = 1
    executorValue.Text = getExecutorName()
    executorValue.TextColor3 = Arqel.Theme.Accent
    executorValue.TextSize = valueSize
    executorValue.Font = Enum.Font.ArimoBold
    executorValue.TextXAlignment = Enum.TextXAlignment.Left
    executorValue.TextTruncate = Enum.TextTruncate.AtEnd
    executorValue.Parent = executorContainer

    local deviceContainer = Instance.new("Frame")
    deviceContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    deviceContainer.BackgroundTransparency = 1
    deviceContainer.LayoutOrder = 5
    deviceContainer.Parent = contentFrame

    local deviceTitle = Instance.new("TextLabel")
    deviceTitle.Size = UDim2.new(1, 0, 0, 11)
    deviceTitle.BackgroundTransparency = 1
    deviceTitle.Text = "Device"
    deviceTitle.TextColor3 = Arqel.Theme.TextDim
    deviceTitle.TextSize = titleSize
    deviceTitle.Font = Enum.Font.ArimoBold
    deviceTitle.TextXAlignment = Enum.TextXAlignment.Left
    deviceTitle.Parent = deviceContainer

    local deviceValue = Instance.new("TextLabel")
    deviceValue.Size = UDim2.new(1, 0, 0, 14)
    deviceValue.Position = UDim2.new(0, 0, 0, 11)
    deviceValue.BackgroundTransparency = 1
    deviceValue.Text = getDeviceType()
    deviceValue.TextColor3 = Arqel.Theme.Accent
    deviceValue.TextSize = valueSize
    deviceValue.Font = Enum.Font.ArimoBold
    deviceValue.TextXAlignment = Enum.TextXAlignment.Left
    deviceValue.TextTruncate = Enum.TextTruncate.AtEnd
    deviceValue.Parent = deviceContainer

    local divider2 = Instance.new("Frame")
    divider2.Size = UDim2.new(1, 16, 0, 2)
    divider2.Position = UDim2.new(0.5, 0, 0, 0)
    divider2.AnchorPoint = Vector2.new(0.5, 0)
    divider2.BackgroundColor3 = Arqel.Theme.Divider
    divider2.BorderSizePixel = 0
    divider2.LayoutOrder = 6
    divider2.Parent = contentFrame

    local hwidContainer = Instance.new("Frame")
    hwidContainer.Size = UDim2.new(1, 0, 0, fieldHeight)
    hwidContainer.BackgroundTransparency = 1
    hwidContainer.LayoutOrder = 7
    hwidContainer.Parent = contentFrame

    local hwidTitle = Instance.new("TextLabel")
    hwidTitle.Size = UDim2.new(1, 0, 0, 11)
    hwidTitle.BackgroundTransparency = 1
    hwidTitle.Text = "HWID"
    hwidTitle.TextColor3 = Arqel.Theme.TextDim
    hwidTitle.TextSize = titleSize
    hwidTitle.Font = Enum.Font.ArimoBold
    hwidTitle.TextXAlignment = Enum.TextXAlignment.Left
    hwidTitle.Parent = hwidContainer

    local fullHWID = getHWID()
    local copyBtnSize = 18
    local dotAreaWidth = panelWidth - 16 - copyBtnSize - 6
    local hiddenDots = generateHiddenDots(dotAreaWidth, 5)

    local hwidValue = Instance.new("TextLabel")
    hwidValue.Size = UDim2.new(1, -(copyBtnSize + 6), 0, 14)
    hwidValue.Position = UDim2.new(0, 0, 0, 11)
    hwidValue.BackgroundTransparency = 1
    hwidValue.Text = hiddenDots
    hwidValue.TextColor3 = Arqel.Theme.TextDim
    hwidValue.TextSize = isCompact and 9 or 10
    hwidValue.Font = Enum.Font.ArimoBold
    hwidValue.TextXAlignment = Enum.TextXAlignment.Left
    hwidValue.TextTruncate = Enum.TextTruncate.AtEnd
    hwidValue.Parent = hwidContainer

    local copyBtn = Instance.new("ImageButton")
    copyBtn.Size = UDim2.new(0, copyBtnSize, 0, copyBtnSize)
    copyBtn.Position = UDim2.new(1, 0, 0.5, 1)
    copyBtn.AnchorPoint = Vector2.new(1, 0.5)
    copyBtn.BackgroundTransparency = 1
    copyBtn.Image = getIcon("copy")
    copyBtn.ImageColor3 = Arqel.Theme.TextDim
    copyBtn.ScaleType = Enum.ScaleType.Fit
    copyBtn.Parent = hwidContainer
    copyBtn.MouseEnter:Connect(function() TweenService:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Accent}):Play() end)
    copyBtn.MouseLeave:Connect(function() TweenService:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)
    copyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(fullHWID) end)
        TweenService:Create(copyBtn, TweenInfo.new(0.1), {ImageColor3 = Arqel.Theme.Success}):Play()
        task.delay(0.3, function() TweenService:Create(copyBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)
        Arqel:Notify("Copied", "HWID copied to clipboard", 2, "copy")
    end)

    local divider3 = Instance.new("Frame")
    divider3.Size = UDim2.new(1, 16, 0, 2)
    divider3.Position = UDim2.new(0.5, 0, 0, 0)
    divider3.AnchorPoint = Vector2.new(0.5, 0)
    divider3.BackgroundColor3 = Arqel.Theme.Divider
    divider3.BorderSizePixel = 0
    divider3.LayoutOrder = 8
    divider3.Parent = contentFrame

    local clockContainer = Instance.new("Frame")
    clockContainer.Size = UDim2.new(1, 0, 0, isCompact and 30 or 38)
    clockContainer.BackgroundTransparency = 1
    clockContainer.LayoutOrder = 9
    clockContainer.Parent = contentFrame

    local clockRow = Instance.new("Frame")
    clockRow.Size = UDim2.new(1, 0, 0, isCompact and 18 or 22)
    clockRow.Position = UDim2.new(0.5, -8, 0, 0)
    clockRow.AnchorPoint = Vector2.new(0.5, 0)
    clockRow.BackgroundTransparency = 1
    clockRow.Parent = clockContainer

    local clockRowLayout = Instance.new("UIListLayout", clockRow)
    clockRowLayout.FillDirection = Enum.FillDirection.Horizontal
    clockRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    clockRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    clockRowLayout.Padding = UDim.new(0, isCompact and 4 or 6)

    local clockIcon = Instance.new("ImageLabel")
    clockIcon.Size = UDim2.new(0, isCompact and 14 or 16, 0, isCompact and 14 or 16)
    clockIcon.BackgroundTransparency = 1
    clockIcon.Image = getIcon("clock")
    clockIcon.ImageColor3 = Arqel.Theme.Accent
    clockIcon.ScaleType = Enum.ScaleType.Fit
    clockIcon.LayoutOrder = 1
    clockIcon.Parent = clockRow

    local clockTimeLabel = Instance.new("TextLabel")
    clockTimeLabel.Size = UDim2.new(0, 0, 1, 0)
    clockTimeLabel.AutomaticSize = Enum.AutomaticSize.X
    clockTimeLabel.BackgroundTransparency = 1
    clockTimeLabel.Text = formatTime12()
    clockTimeLabel.TextColor3 = Arqel.Theme.Accent
    clockTimeLabel.TextSize = isCompact and 14 or 16
    clockTimeLabel.Font = Enum.Font.ArimoBold
    clockTimeLabel.LayoutOrder = 2
    clockTimeLabel.Parent = clockRow

    local clockDateLabel = Instance.new("TextLabel")
    clockDateLabel.Size = UDim2.new(1, 0, 0, isCompact and 12 or 14)
    clockDateLabel.Position = UDim2.new(0, -8, 0, isCompact and 18 or 22)
    clockDateLabel.BackgroundTransparency = 1
    clockDateLabel.Text = formatDate()
    clockDateLabel.TextColor3 = Arqel.Theme.TextDim
    clockDateLabel.TextSize = isCompact and 9 or 11
    clockDateLabel.Font = Enum.Font.ArimoBold
    clockDateLabel.TextXAlignment = Enum.TextXAlignment.Center
    clockDateLabel.Parent = clockContainer

    local clockRunning = true
    task.spawn(function()
        while clockRunning do
            if not clockTimeLabel or not clockTimeLabel.Parent then clockRunning = false break end
            clockTimeLabel.Text = formatTime12()
            clockDateLabel.Text = formatDate()
            task.wait(1)
        end
    end)
    panel.Destroying:Connect(function() clockRunning = false end)

    local function toggle(userIcon, container, baseWidth)
        isOpen = not isOpen
        if isOpen then
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 0.4}):Play()
            TweenService:Create(panel, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, panelWidth, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(0, baseWidth + gap + panelWidth, 0, panelHeight)}):Play()
        else
            TweenService:Create(panelStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TweenService:Create(panel, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, panelHeight)}):Play()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, baseWidth, 0, panelHeight)}):Play()
        end
    end

    panelClose.MouseButton1Click:Connect(function() if isOpen then toggle(nil, parent, windowWidth) end end)
    return panel, toggle, function() return isOpen end, panelWidth
end

local function handleKeylessSkip()
    getgenv().SCRIPT_KEY = "KEYLESS"
    getgenv().ArqelLoaded = false
    Arqel:Notify("Access Granted", "Keyless access approved!", 3, "success")
    task.wait(0.3)
    if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
end

local function BuildCenteredUI(windowWidth, windowHeight, panelHeight, userPanelWidth, changelogPanelWidth, gap, buildContent)
    local gui = buildContent.gui

    local container = Instance.new("Frame")
    container.Name = "Container"
    container.Size = UDim2.new(0, windowWidth, 0, panelHeight)
    container.Position = UDim2.new(0.5, 0, 1.5, 0)
    container.AnchorPoint = Vector2.new(0.5, 0.5)
    container.BackgroundTransparency = 1
    container.Parent = gui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, windowWidth, 0, windowHeight)
    mainFrame.Position = UDim2.new(0.5, 0, 0, 0)
    mainFrame.AnchorPoint = Vector2.new(0.5, 0)
    mainFrame.BackgroundColor3 = Arqel.Theme.Background
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = container
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 4)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color = Arqel.Theme.Accent
    mainStroke.Thickness = 2
    mainStroke.Transparency = 0.4

    local userPanel, toggleUserPanel, isUserOpen, userPanelActualWidth = CreateUserInfoPanel(container, windowWidth, panelHeight, userPanelWidth, mainFrame, gap, false)
    local changelogPanel, toggleChangelog, isChangelogOpen, changelogPanelActualWidth = CreateChangelogPanel(container, windowWidth, panelHeight, changelogPanelWidth, mainFrame, gap)

    local function getContainerWidth()
        local w = windowWidth
        if isUserOpen() then w = w + gap + userPanelActualWidth end
        if isChangelogOpen() then w = w + gap + changelogPanelActualWidth end
        return w
    end

    local function toggleUser(userIcon)
        local currentW = getContainerWidth()
        if isUserOpen() then
            toggleUserPanel(userIcon, container, currentW - gap - userPanelActualWidth)
        else
            toggleUserPanel(userIcon, container, currentW)
        end
    end

    local function toggleCL(changelogIcon)
        local currentW = getContainerWidth()
        if isChangelogOpen() then
            toggleChangelog(changelogIcon, container, currentW - gap - changelogPanelActualWidth)
        else
            toggleChangelog(changelogIcon, container, currentW)
        end
    end

    local function closeAllPanels(userIcon, changelogIcon, callback)
        if isChangelogOpen() then toggleCL(changelogIcon) task.wait(0.35) end
        if isUserOpen() then toggleUser(userIcon) task.wait(0.35) end
        if callback then callback() end
    end

    return {
        container = container,
        mainFrame = mainFrame,
        mainStroke = mainStroke,
        toggleUser = toggleUser,
        toggleCL = toggleCL,
        isUserOpen = isUserOpen,
        isChangelogOpen = isChangelogOpen,
        closeAllPanels = closeAllPanels
    }
end

local function BuildKeylessUI()
    local oldGui = hui:FindFirstChild("ArqelKeylessSystem")
    if oldGui then oldGui:Destroy() end
    local oldGui2 = hui:FindFirstChild("ArqelKeySystem")
    if oldGui2 then oldGui2:Destroy() end

    enableBlur()

    local mobile = isMobile()
    local padding = 14
    local windowWidth = 300
    local windowHeight = 265
    local userPanelWidth = 165
    local changelogPanelWidth = 200
    local gap = 12

    local gui = Instance.new("ScreenGui")
    gui.Name = "ArqelKeylessSystem"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.Parent = hui

    local ui = BuildCenteredUI(windowWidth, windowHeight, windowHeight, userPanelWidth, changelogPanelWidth, gap, {gui = gui})
    local container = ui.container
    local main = ui.mainFrame
    local mainStroke = ui.mainStroke

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Arqel.Theme.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.Parent = main
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 4)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 8)
    headerFix.Position = UDim2.new(0, 0, 1, -8)
    headerFix.BackgroundColor3 = Arqel.Theme.Header
    headerFix.BorderSizePixel = 0
    headerFix.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, 0)
    headerLine.BackgroundColor3 = Arqel.Theme.Accent
    headerLine.BackgroundTransparency = 0.6
    headerLine.BorderSizePixel = 0
    headerLine.Parent = header

    local logo = Instance.new("ImageLabel")
    logo.Size = UDim2.new(0, 30, 0, 30)
    logo.Position = UDim2.new(0, padding, 0.5, 0)
    logo.AnchorPoint = Vector2.new(0, 0.5)
    logo.BackgroundTransparency = 1
    logo.Image = getLogoIcon()
    logo.ImageColor3 = Arqel.Theme.Text
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -90, 1, 0)
    title.Position = UDim2.new(0, padding + 40, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = Arqel.Appearance.Title
    title.TextColor3 = Arqel.Theme.Text
    title.TextSize = mobile and 24 or 26
    title.Font = Enum.Font.ArimoBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -padding, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = getIcon("close")
    closeBtn.ImageColor3 = Arqel.Theme.TextDim
    closeBtn.ScaleType = Enum.ScaleType.Fit
    closeBtn.Parent = header
    closeBtn.MouseEnter:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Error}):Play() end)
    closeBtn.MouseLeave:Connect(function() TweenService:Create(closeBtn, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local contentY = 60

    local successBox = Instance.new("Frame")
    successBox.Size = UDim2.new(0.94, 0, 0, 52)
    successBox.Position = UDim2.new(0.5, 0, 0, contentY)
    successBox.AnchorPoint = Vector2.new(0.5, 0)
    successBox.BackgroundColor3 = Arqel.Theme.Success
    successBox.BackgroundTransparency = 0.85
    successBox.BorderSizePixel = 0
    successBox.Parent = main
    Instance.new("UICorner", successBox).CornerRadius = UDim.new(0, 4)

    local successStroke = Instance.new("UIStroke", successBox)
    successStroke.Color = Arqel.Theme.Success
    successStroke.Thickness = 1
    successStroke.Transparency = 0.5

    local checkIcon = Instance.new("ImageLabel")
    checkIcon.Size = UDim2.new(0, 24, 0, 24)
    checkIcon.Position = UDim2.new(0, 16, 0.5, 0)
    checkIcon.AnchorPoint = Vector2.new(0, 0.5)
    checkIcon.BackgroundTransparency = 1
    checkIcon.Image = getIcon("check")
    checkIcon.ImageColor3 = Arqel.Theme.Success
    checkIcon.ScaleType = Enum.ScaleType.Fit
    checkIcon.Parent = successBox

    local successText = Instance.new("TextLabel")
    successText.Size = UDim2.new(1, -60, 1, 0)
    successText.Position = UDim2.new(0, 52, 0, 0)
    successText.BackgroundTransparency = 1
    successText.Text = "Access Granted"
    successText.TextColor3 = Arqel.Theme.Success
    successText.TextSize = mobile and 17 or 18
    successText.Font = Enum.Font.ArimoBold
    successText.TextXAlignment = Enum.TextXAlignment.Left
    successText.Parent = successBox

    local keylessText = Instance.new("TextLabel")
    keylessText.Size = UDim2.new(1, 0, 0, 20)
    keylessText.Position = UDim2.new(0.5, 0, 0, contentY + 60)
    keylessText.AnchorPoint = Vector2.new(0.5, 0)
    keylessText.BackgroundTransparency = 1
    keylessText.Text = "Keyless Script"
    keylessText.TextColor3 = Arqel.Theme.TextDim
    keylessText.TextSize = mobile and 14 or 15
    keylessText.Font = Enum.Font.ArimoBold
    keylessText.Parent = main

    local divider = Instance.new("Frame")
    divider.Size = UDim2.new(1, 0, 0, 3)
    divider.Position = UDim2.new(0, 0, 0, contentY + 88)
    divider.BackgroundColor3 = Arqel.Theme.Divider
    divider.BorderSizePixel = 0
    divider.Parent = main

    local launchBtn = Instance.new("TextButton")
    launchBtn.Size = UDim2.new(0.75, 0, 0, 42)
    launchBtn.Position = UDim2.new(0.5, 0, 0, contentY + 103)
    launchBtn.AnchorPoint = Vector2.new(0.5, 0)
    launchBtn.BackgroundColor3 = Arqel.Theme.Accent
    launchBtn.BorderSizePixel = 0
    launchBtn.Text = ""
    launchBtn.AutoButtonColor = false
    launchBtn.Parent = main
    Instance.new("UICorner", launchBtn).CornerRadius = UDim.new(0, 4)

    local launchStroke = Instance.new("UIStroke", launchBtn)
    launchStroke.Color = Arqel.Theme.AccentHover
    launchStroke.Thickness = 1
    launchStroke.Transparency = 0.5

    local launchContent = Instance.new("Frame")
    launchContent.Size = UDim2.new(1, 0, 1, 0)
    launchContent.BackgroundTransparency = 1
    launchContent.Parent = launchBtn

    local launchLayout = Instance.new("UIListLayout", launchContent)
    launchLayout.FillDirection = Enum.FillDirection.Horizontal
    launchLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    launchLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    launchLayout.Padding = UDim.new(0, 8)

    local launchIcon = Instance.new("ImageLabel")
    launchIcon.Size = UDim2.new(0, 18, 0, 18)
    launchIcon.BackgroundTransparency = 1
    launchIcon.Image = getIcon("shield")
    launchIcon.ImageColor3 = Arqel.Theme.Text
    launchIcon.ScaleType = Enum.ScaleType.Fit
    launchIcon.LayoutOrder = 1
    launchIcon.Parent = launchContent

    local launchLabel = Instance.new("TextLabel")
    launchLabel.Size = UDim2.new(0, 0, 0, 18)
    launchLabel.AutomaticSize = Enum.AutomaticSize.X
    launchLabel.BackgroundTransparency = 1
    launchLabel.Text = "Launch Script"
    launchLabel.TextColor3 = Arqel.Theme.Text
    launchLabel.TextSize = mobile and 14 or 15
    launchLabel.Font = Enum.Font.ArimoBold
    launchLabel.LayoutOrder = 2
    launchLabel.Parent = launchContent

    launchBtn.MouseEnter:Connect(function() TweenService:Create(launchBtn, TweenInfo.new(0.15), {BackgroundColor3 = Arqel.Theme.AccentHover}):Play() end)
    launchBtn.MouseLeave:Connect(function() TweenService:Create(launchBtn, TweenInfo.new(0.15), {BackgroundColor3 = Arqel.Theme.Accent}):Play() end)

    local bottomY = contentY + 153

    local userBtn = Instance.new("TextButton")
    userBtn.Size = UDim2.new(0, 36, 0, 36)
    userBtn.Position = UDim2.new(0.5, -44, 0, bottomY)
    userBtn.AnchorPoint = Vector2.new(0.5, 0)
    userBtn.BackgroundColor3 = Arqel.Theme.Background
    userBtn.BorderSizePixel = 0
    userBtn.Text = ""
    userBtn.AutoButtonColor = false
    userBtn.Parent = main
    Instance.new("UICorner", userBtn).CornerRadius = UDim.new(0, 4)

    local userIcon = Instance.new("ImageLabel")
    userIcon.Size = UDim2.new(0, 18, 0, 18)
    userIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    userIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    userIcon.BackgroundTransparency = 1
    userIcon.Image = getIcon("user")
    userIcon.ImageColor3 = Arqel.Theme.TextDim
    userIcon.ScaleType = Enum.ScaleType.Fit
    userIcon.Parent = userBtn
    userBtn.MouseEnter:Connect(function() TweenService:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Accent}):Play() end)
    userBtn.MouseLeave:Connect(function() TweenService:Create(userIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    local discordBtn = Instance.new("TextButton")
    discordBtn.Size = UDim2.new(0, 36, 0, 36)
    discordBtn.Position = UDim2.new(0.5, 0, 0, bottomY)
    discordBtn.AnchorPoint = Vector2.new(0.5, 0)
    discordBtn.BackgroundColor3 = Arqel.Theme.Background
    discordBtn.BorderSizePixel = 0
    discordBtn.Text = ""
    discordBtn.AutoButtonColor = false
    discordBtn.Parent = main
    Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 4)

    local discordIcon = Instance.new("ImageLabel")
    discordIcon.Size = UDim2.new(0, 18, 0, 18)
    discordIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    discordIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    discordIcon.BackgroundTransparency = 1
    discordIcon.Image = getIcon("discord")
    discordIcon.ImageColor3 = Arqel.Theme.Discord
    discordIcon.ScaleType = Enum.ScaleType.Fit
    discordIcon.Parent = discordBtn
    discordBtn.MouseEnter:Connect(function() TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.DiscordHover}):Play() end)
    discordBtn.MouseLeave:Connect(function() TweenService:Create(discordIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Discord}):Play() end)

    local changelogBtn = Instance.new("TextButton")
    changelogBtn.Size = UDim2.new(0, 36, 0, 36)
    changelogBtn.Position = UDim2.new(0.5, 44, 0, bottomY)
    changelogBtn.AnchorPoint = Vector2.new(0.5, 0)
    changelogBtn.BackgroundColor3 = Arqel.Theme.Background
    changelogBtn.BorderSizePixel = 0
    changelogBtn.Text = ""
    changelogBtn.AutoButtonColor = false
    changelogBtn.Parent = main
    Instance.new("UICorner", changelogBtn).CornerRadius = UDim.new(0, 4)

    local changelogIcon = Instance.new("ImageLabel")
    changelogIcon.Size = UDim2.new(0, 18, 0, 18)
    changelogIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
    changelogIcon.AnchorPoint = Vector2.new(0.5, 0.5)
    changelogIcon.BackgroundTransparency = 1
    changelogIcon.Image = getIcon("changelog")
    changelogIcon.ImageColor3 = Arqel.Theme.TextDim
    changelogIcon.ScaleType = Enum.ScaleType.Fit
    changelogIcon.Parent = changelogBtn
    changelogBtn.MouseEnter:Connect(function() TweenService:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.Text}):Play() end)
    changelogBtn.MouseLeave:Connect(function() TweenService:Create(changelogIcon, TweenInfo.new(0.15), {ImageColor3 = Arqel.Theme.TextDim}):Play() end)

    if #Arqel.Changelog == 0 then
        changelogBtn.Visible = false
        userBtn.Position = UDim2.new(0.5, -22, 0, bottomY)
        discordBtn.Position = UDim2.new(0.5, 22, 0, bottomY)
    end

    local doors = CreateDoorOverlay(main, windowWidth, windowHeight)

    userBtn.MouseButton1Click:Connect(function() ui.toggleUser(userIcon) end)
    changelogBtn.MouseButton1Click:Connect(function() ui.toggleCL(changelogIcon) end)

    local function closeDoorsThenExit(callback)
        ui.closeAllPanels(userIcon, changelogIcon, function()
            doors.close(function() task.wait(0.3) if callback then callback() end end)
        end)
    end

    closeBtn.MouseButton1Click:Connect(function()
        Arqel:Notify("Goodbye", "See you next time!", 2, "close")
        closeDoorsThenExit(function()
            fullCleanup()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            task.wait(0.4) gui:Destroy()
        end)
        if Arqel.Callbacks.OnClose then Arqel.Callbacks.OnClose() end
    end)

    launchBtn.MouseButton1Click:Connect(function()
        Arqel:Notify("Launching", "Script loaded successfully!", 2, "success")
        getgenv().SCRIPT_KEY = "KEYLESS"
        getgenv().ArqelLoaded = false
        closeDoorsThenExit(function()
            disableBlur()
            TweenService:Create(container, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            TweenService:Create(main, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(mainStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            task.wait(0.4) gui:Destroy()
            if not Internal.IsJunkieMode and Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end
        end)
    end)

    discordBtn.MouseButton1Click:Connect(function()
        if Arqel.Links.Discord ~= "" then
            Arqel:Notify("Discord", "Invite link copied!", 2, "discord")
            pcall(function() setclipboard(Arqel.Links.Discord) end)
        end
    end)

    setupDragging(header, container)
    TweenService:Create(container, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Position = UDim2.new(0.5, 0, 0.45, 0)}):Play()
    task.wait(0.6)
    doors.open(function()
        checkIcon.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(checkIcon, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 24, 0, 24)}):Play()
        task.wait(0.2)
        ui.toggleUser(userIcon)
        if #Arqel.Changelog > 0 then task.wait(0.3) ui.toggleCL(changelogIcon) end
    end)
end

local function BuildKeyUI()
    local oldGui = hui:FindFirstChild("ArqelKeySystem")
    if oldGui then oldGui:Destroy() end
    local oldGui2 = hui:FindFirstChild("ArqelKeylessSystem")
    if oldGui2 then oldGui2:Destroy() end

    enableBlur()

    local mobile = isMobile()
    local scale = getScale()
    local padding = mobile and 12 or 16
    local windowWidth = mobile and math.clamp(430 * scale, 330, 460) or 520
    local windowHeight = mobile and math.clamp(630 * scale, 585, 675) or 660
    local userPanelWidth = mobile and 190 or 225
    local changelogPanelWidth = mobile and 220 or 260
    local gap = 12

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ArqelKeySystem"
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.Parent = hui

    local ui = BuildCenteredUI(windowWidth, windowHeight, windowHeight, userPanelWidth, changelogPanelWidth, gap, {gui = screenGui})
    local container = ui.container
    local mainFrame = ui.mainFrame
    local mainStroke = ui.mainStroke

    local scaleObject = Instance.new("UIScale")
    scaleObject.Scale = 0.97
    scaleObject.Parent = mainFrame

    local doors = CreateDoorOverlay(mainFrame, windowWidth, windowHeight)

    local topGlow = Instance.new("Frame")
    topGlow.Size = UDim2.new(0.78, 0, 0, 80)
    topGlow.Position = UDim2.new(0.5, 0, 0, -28)
    topGlow.AnchorPoint = Vector2.new(0.5, 0)
    topGlow.BackgroundColor3 = Arqel.Theme.Accent
    topGlow.BackgroundTransparency = 0.92
    topGlow.BorderSizePixel = 0
    topGlow.ZIndex = 0
    topGlow.Parent = mainFrame
    Instance.new("UICorner", topGlow).CornerRadius = UDim.new(1, 0)

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, mobile and 88 or 92)
    header.BackgroundColor3 = Arqel.Theme.Header
    header.BorderSizePixel = 0
    header.Active = true
    header.ZIndex = 2
    header.Parent = mainFrame
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

    local headerFix = Instance.new("Frame")
    headerFix.Size = UDim2.new(1, 0, 0, 10)
    headerFix.Position = UDim2.new(0, 0, 1, -10)
    headerFix.BackgroundColor3 = Arqel.Theme.Header
    headerFix.BorderSizePixel = 0
    headerFix.ZIndex = 2
    headerFix.Parent = header

    local headerLine = Instance.new("Frame")
    headerLine.Size = UDim2.new(1, 0, 0, 1)
    headerLine.Position = UDim2.new(0, 0, 1, 0)
    headerLine.BackgroundColor3 = Arqel.Theme.Accent
    headerLine.BackgroundTransparency = 0.65
    headerLine.BorderSizePixel = 0
    headerLine.ZIndex = 3
    headerLine.Parent = header

    local logo = Instance.new("ImageLabel")
    logo.Size = mobile and UDim2.new(0, 38, 0, 38) or UDim2.new(0, 42, 0, 42)
    logo.Position = UDim2.new(0, padding, 0.5, -6)
    logo.AnchorPoint = Vector2.new(0, 0.5)
    logo.BackgroundTransparency = 1
    logo.Image = getLogoIcon()
    logo.ImageColor3 = Arqel.Theme.Text
    logo.ScaleType = Enum.ScaleType.Fit
    logo.ZIndex = 3
    logo.Parent = header

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -padding * 2 - 96, 0, 28)
    titleLabel.Position = UDim2.new(0, padding + logo.Size.X.Offset + 12, 0.5, -25)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = Arqel.Appearance.Title
    titleLabel.TextColor3 = Arqel.Theme.Text
    titleLabel.TextSize = mobile and 24 or 27
    titleLabel.Font = Enum.Font.ArimoBold
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    titleLabel.ZIndex = 3
    titleLabel.Parent = header

    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Size = UDim2.new(1, -padding * 2 - 96, 0, 18)
    subtitleLabel.Position = UDim2.new(0, padding + logo.Size.X.Offset + 12, 0.5, 6)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = Arqel.Appearance.Subtitle
    subtitleLabel.TextColor3 = Arqel.Theme.Accent
    subtitleLabel.TextSize = mobile and 12 or 13
    subtitleLabel.Font = Enum.Font.ArimoBold
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    subtitleLabel.TextTruncate = Enum.TextTruncate.AtEnd
    subtitleLabel.ZIndex = 3
    subtitleLabel.Parent = header

    local closeBtn = Instance.new("ImageButton")
    closeBtn.Size = UDim2.new(0, 22, 0, 22)
    closeBtn.Position = UDim2.new(1, -padding, 0.5, 0)
    closeBtn.AnchorPoint = Vector2.new(1, 0.5)
    closeBtn.BackgroundTransparency = 1
    closeBtn.Image = getIcon("close")
    closeBtn.ImageColor3 = Arqel.Theme.TextDim
    closeBtn.ScaleType = Enum.ScaleType.Fit
    closeBtn.ZIndex = 4
    closeBtn.Parent = header
    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {ImageColor3 = Arqel.Theme.Error}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {ImageColor3 = Arqel.Theme.TextDim}):Play()
    end)

    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -padding * 2, 1, -header.Size.Y.Offset - padding * 2)
    content.Position = UDim2.new(0, padding, 0, header.Size.Y.Offset + padding)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 2
    content.ScrollBarImageColor3 = Arqel.Theme.Accent
    content.ScrollBarImageTransparency = 0.35
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.AutomaticCanvasSize = Enum.AutomaticSize.Y
    content.ScrollingDirection = Enum.ScrollingDirection.Y
    content.ZIndex = 2
    content.Parent = mainFrame

    local contentPadding = Instance.new("UIPadding")
    contentPadding.PaddingTop = UDim.new(0, 2)
    contentPadding.PaddingBottom = UDim.new(0, 4)
    content.Padding = contentPadding

    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, mobile and 9 or 10)
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    contentLayout.Parent = content

    local descriptionLabel = Instance.new("TextLabel")
    descriptionLabel.Size = UDim2.new(1, 0, 0, mobile and 24 or 26)
    descriptionLabel.BackgroundTransparency = 1
    descriptionLabel.Text = Arqel.Appearance.Description or "Enter your InfinityX access key to continue."
    descriptionLabel.TextColor3 = Arqel.Theme.TextDim
    descriptionLabel.TextTransparency = 0.08
    descriptionLabel.TextSize = mobile and 11 or 12
    descriptionLabel.Font = Enum.Font.ArimoBold
    descriptionLabel.TextXAlignment = Enum.TextXAlignment.Left
    descriptionLabel.TextTruncate = Enum.TextTruncate.AtEnd
    descriptionLabel.LayoutOrder = 0
    descriptionLabel.ZIndex = 3
    descriptionLabel.Parent = content

    local function createPanel(parent, height, layoutOrder)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, 0, 0, height)
        frame.BackgroundColor3 = Arqel.Theme.Surface
        frame.BorderSizePixel = 0
        frame.LayoutOrder = layoutOrder or 1
        frame.ClipsDescendants = true
        frame.ZIndex = 2
        frame.Parent = parent
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Arqel.Theme.Divider
        stroke.Thickness = 1
        stroke.Transparency = 0.25
        stroke.Parent = frame

        return frame, stroke
    end

    local function addSectionTitle(parent, text, iconName, layoutOrder)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, 0, 0, 22)
        row.BackgroundTransparency = 1
        row.LayoutOrder = layoutOrder or 1
        row.ZIndex = 4
        row.Parent = parent

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 15, 0, 15)
        icon.Position = UDim2.new(0, 0, 0.5, 0)
        icon.AnchorPoint = Vector2.new(0, 0.5)
        icon.BackgroundTransparency = 1
        icon.Image = getIcon(iconName)
        icon.ImageColor3 = Arqel.Theme.Accent
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ZIndex = 4
        icon.Parent = row

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, -22, 1, 0)
        label.Position = UDim2.new(0, 22, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Arqel.Theme.TextDim
        label.TextSize = mobile and 10 or 11
        label.Font = Enum.Font.ArimoBold
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.ZIndex = 4
        label.Parent = row

        return row
    end

    local function setTextColor(label, color)
        if label and label.Parent then
            TweenService:Create(label, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {TextColor3 = color}):Play()
        end
    end

    -- Key status panel
    local statusPanel, statusStroke = createPanel(content, mobile and 54 or 58, 1)

    local statusIcon = Instance.new("ImageLabel")
    statusIcon.Size = UDim2.new(0, 22, 0, 22)
    statusIcon.Position = UDim2.new(0, 14, 0.5, 0)
    statusIcon.AnchorPoint = Vector2.new(0, 0.5)
    statusIcon.BackgroundTransparency = 1
    statusIcon.Image = getIcon("lock")
    statusIcon.ImageColor3 = Arqel.Theme.StatusIdle
    statusIcon.ScaleType = Enum.ScaleType.Fit
    statusIcon.ZIndex = 4
    statusIcon.Parent = statusPanel

    local statusTitle = Instance.new("TextLabel")
    statusTitle.Size = UDim2.new(1, -50, 0, 15)
    statusTitle.Position = UDim2.new(0, 48, 0, 9)
    statusTitle.BackgroundTransparency = 1
    statusTitle.Text = "KEY STATUS"
    statusTitle.TextColor3 = Arqel.Theme.TextDim
    statusTitle.TextSize = 9
    statusTitle.Font = Enum.Font.ArimoBold
    statusTitle.TextXAlignment = Enum.TextXAlignment.Left
    statusTitle.ZIndex = 4
    statusTitle.Parent = statusPanel

    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -50, 0, 20)
    statusLabel.Position = UDim2.new(0, 48, 0, 25)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "Enter a key"
    statusLabel.TextColor3 = Arqel.Theme.StatusIdle
    statusLabel.TextSize = mobile and 13 or 14
    statusLabel.Font = Enum.Font.ArimoBold
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.TextTruncate = Enum.TextTruncate.AtEnd
    statusLabel.ZIndex = 4
    statusLabel.Parent = statusPanel

    -- Main key input
    local inputPanel, inputStroke = createPanel(content, mobile and 58 or 62, 2)
    inputStroke.Color = Arqel.Theme.Accent
    inputStroke.Transparency = 0.82

    local inputGlow = Instance.new("Frame")
    inputGlow.Size = UDim2.new(1, -4, 1, -4)
    inputGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
    inputGlow.AnchorPoint = Vector2.new(0.5, 0.5)
    inputGlow.BackgroundColor3 = Arqel.Theme.Accent
    inputGlow.BackgroundTransparency = 1
    inputGlow.BorderSizePixel = 0
    inputGlow.ZIndex = 2
    inputGlow.Parent = inputPanel
    Instance.new("UICorner", inputGlow).CornerRadius = UDim.new(0, 6)

    local keyIcon = Instance.new("ImageLabel")
    keyIcon.Size = UDim2.new(0, 20, 0, 20)
    keyIcon.Position = UDim2.new(0, 14, 0.5, 0)
    keyIcon.AnchorPoint = Vector2.new(0, 0.5)
    keyIcon.BackgroundTransparency = 1
    keyIcon.Image = getIcon("keyround")
    keyIcon.ImageColor3 = Arqel.Theme.TextDim
    keyIcon.ScaleType = Enum.ScaleType.Fit
    keyIcon.ZIndex = 4
    keyIcon.Parent = inputPanel

    local textBox = Instance.new("TextBox")
    textBox.Size = UDim2.new(1, -52, 1, 0)
    textBox.Position = UDim2.new(0, 48, 0, 0)
    textBox.BackgroundTransparency = 1
    textBox.Text = ""
    textBox.PlaceholderText = "XXXX-XXXX-XXXX"
    textBox.PlaceholderColor3 = Arqel.Theme.TextDim
    textBox.TextColor3 = Arqel.Theme.Text
    textBox.TextSize = mobile and 15 or 16
    textBox.Font = Enum.Font.ArimoBold
    textBox.ClearTextOnFocus = false
    textBox.TextTruncate = Enum.TextTruncate.AtEnd
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.TextYAlignment = Enum.TextYAlignment.Center
    textBox.ZIndex = 4
    textBox.Parent = inputPanel

    local inputHint = Instance.new("TextLabel")
    inputHint.Size = UDim2.new(1, -52, 0, 14)
    inputHint.Position = UDim2.new(0, 48, 1, -17)
    inputHint.BackgroundTransparency = 1
    inputHint.Text = "Your access key stays local to this interface."
    inputHint.TextColor3 = Arqel.Theme.TextDim
    inputHint.TextTransparency = 0.35
    inputHint.TextSize = 8
    inputHint.Font = Enum.Font.Arimo
    inputHint.TextXAlignment = Enum.TextXAlignment.Left
    inputHint.ZIndex = 4
    inputHint.Parent = inputPanel

    -- Button group
    local buttonHolder = Instance.new("Frame")
    buttonHolder.Size = UDim2.new(1, 0, 0, mobile and 91 or 94)
    buttonHolder.BackgroundTransparency = 1
    buttonHolder.LayoutOrder = 3
    buttonHolder.ZIndex = 3
    buttonHolder.Parent = content

    local redeemBtn = Instance.new("TextButton")
    redeemBtn.Size = UDim2.new(1, 0, 0, mobile and 43 or 44)
    redeemBtn.Position = UDim2.new(0, 0, 0, 0)
    redeemBtn.BackgroundColor3 = Arqel.Theme.Pending
    redeemBtn.BorderSizePixel = 0
    redeemBtn.Text = ""
    redeemBtn.AutoButtonColor = false
    redeemBtn.Active = false
    redeemBtn.ZIndex = 4
    redeemBtn.Parent = buttonHolder
    Instance.new("UICorner", redeemBtn).CornerRadius = UDim.new(0, 7)

    local redeemStroke = Instance.new("UIStroke")
    redeemStroke.Color = Arqel.Theme.Divider
    redeemStroke.Thickness = 1
    redeemStroke.Transparency = 0.1
    redeemStroke.Parent = redeemBtn

    local redeemContent = Instance.new("Frame")
    redeemContent.Size = UDim2.new(1, 0, 1, 0)
    redeemContent.BackgroundTransparency = 1
    redeemContent.ZIndex = 5
    redeemContent.Parent = redeemBtn

    local redeemLayout = Instance.new("UIListLayout")
    redeemLayout.FillDirection = Enum.FillDirection.Horizontal
    redeemLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    redeemLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    redeemLayout.Padding = UDim.new(0, 7)
    redeemLayout.Parent = redeemContent

    local redeemIcon = Instance.new("ImageLabel")
    redeemIcon.Size = UDim2.new(0, 17, 0, 17)
    redeemIcon.BackgroundTransparency = 1
    redeemIcon.Image = getIcon("circleCheck")
    redeemIcon.ImageColor3 = Arqel.Theme.TextDim
    redeemIcon.ScaleType = Enum.ScaleType.Fit
    redeemIcon.ZIndex = 6
    redeemIcon.Parent = redeemContent

    local redeemLabel = Instance.new("TextLabel")
    redeemLabel.Size = UDim2.new(0, 0, 0, 20)
    redeemLabel.AutomaticSize = Enum.AutomaticSize.X
    redeemLabel.BackgroundTransparency = 1
    redeemLabel.Text = "Redeem Key"
    redeemLabel.TextColor3 = Arqel.Theme.TextDim
    redeemLabel.TextSize = mobile and 13 or 14
    redeemLabel.Font = Enum.Font.ArimoBold
    redeemLabel.ZIndex = 6
    redeemLabel.Parent = redeemContent

    local acquireBtn = Instance.new("TextButton")
    acquireBtn.Size = UDim2.new(1, 0, 0, mobile and 38 or 40)
    acquireBtn.Position = UDim2.new(0, 0, 0, mobile and 49 or 52)
    acquireBtn.BackgroundColor3 = Arqel.Theme.Input
    acquireBtn.BorderSizePixel = 0
    acquireBtn.Text = ""
    acquireBtn.AutoButtonColor = false
    acquireBtn.Active = not Arqel.Options.NoGetKey
    acquireBtn.ZIndex = 4
    acquireBtn.Parent = buttonHolder
    Instance.new("UICorner", acquireBtn).CornerRadius = UDim.new(0, 7)

    local acquireStroke = Instance.new("UIStroke")
    acquireStroke.Color = Arqel.Theme.Divider
    acquireStroke.Thickness = 1
    acquireStroke.Transparency = 0.2
    acquireStroke.Parent = acquireBtn

    local acquireContent = Instance.new("Frame")
    acquireContent.Size = UDim2.new(1, 0, 1, 0)
    acquireContent.BackgroundTransparency = 1
    acquireContent.ZIndex = 5
    acquireContent.Parent = acquireBtn

    local acquireLayout = Instance.new("UIListLayout")
    acquireLayout.FillDirection = Enum.FillDirection.Horizontal
    acquireLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    acquireLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    acquireLayout.Padding = UDim.new(0, 6)
    acquireLayout.Parent = acquireContent

    local acquireIcon = Instance.new("ImageLabel")
    acquireIcon.Size = UDim2.new(0, 16, 0, 16)
    acquireIcon.BackgroundTransparency = 1
    acquireIcon.Image = Arqel.Options.NoGetKey and getIcon("nogetkey") or getIcon("external")
    acquireIcon.ImageColor3 = Arqel.Options.NoGetKey and Arqel.Theme.TextDim or Arqel.Theme.Text
    acquireIcon.ScaleType = Enum.ScaleType.Fit
    acquireIcon.ZIndex = 6
    acquireIcon.Parent = acquireContent

    local acquireLabel = Instance.new("TextLabel")
    acquireLabel.Size = UDim2.new(0, 0, 0, 18)
    acquireLabel.AutomaticSize = Enum.AutomaticSize.X
    acquireLabel.BackgroundTransparency = 1
    acquireLabel.Text = Arqel.Options.NoGetKey and "Get Key unavailable" or "Get Key"
    acquireLabel.TextColor3 = Arqel.Options.NoGetKey and Arqel.Theme.TextDim or Arqel.Theme.Text
    acquireLabel.TextSize = mobile and 12 or 13
    acquireLabel.Font = Enum.Font.ArimoBold
    acquireLabel.ZIndex = 6
    acquireLabel.Parent = acquireContent

    -- Account card
    local profilePanel, profileStroke = createPanel(content, mobile and 102 or 108, 4)
    addSectionTitle(profilePanel, "ROBLOX PROFILE", "user", 1)

    local player = cloneref(Players.LocalPlayer)
    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.new(0, mobile and 48 or 52, 0, mobile and 48 or 52)
    avatar.Position = UDim2.new(0, 14, 0, 35)
    avatar.BackgroundColor3 = Arqel.Theme.Input
    avatar.BorderSizePixel = 0
    avatar.ScaleType = Enum.ScaleType.Crop
    avatar.ZIndex = 4
    avatar.Parent = profilePanel
    Instance.new("UICorner", avatar).CornerRadius = UDim.new(1, 0)

    local avatarStroke = Instance.new("UIStroke")
    avatarStroke.Color = Arqel.Theme.Accent
    avatarStroke.Thickness = 1.25
    avatarStroke.Transparency = 0.35
    avatarStroke.Parent = avatar

    pcall(function()
        local image = Players:GetUserThumbnailAsync(
            player and player.UserId or 0,
            Enum.ThumbnailType.HeadShot,
            Enum.ThumbnailSize.Size150x150
        )
        avatar.Image = image
    end)

    local displayLabel = Instance.new("TextLabel")
    displayLabel.Size = UDim2.new(1, -92, 0, 20)
    displayLabel.Position = UDim2.new(0, 78, 0, 34)
    displayLabel.BackgroundTransparency = 1
    displayLabel.Text = player and player.DisplayName or "User"
    displayLabel.TextColor3 = Arqel.Theme.Text
    displayLabel.TextSize = mobile and 13 or 14
    displayLabel.Font = Enum.Font.ArimoBold
    displayLabel.TextXAlignment = Enum.TextXAlignment.Left
    displayLabel.TextTruncate = Enum.TextTruncate.AtEnd
    displayLabel.ZIndex = 4
    displayLabel.Parent = profilePanel

    local usernameLabel = Instance.new("TextLabel")
    usernameLabel.Size = UDim2.new(1, -92, 0, 17)
    usernameLabel.Position = UDim2.new(0, 78, 0, 54)
    usernameLabel.BackgroundTransparency = 1
    usernameLabel.Text = player and ("@" .. player.Name) or "@User"
    usernameLabel.TextColor3 = Arqel.Theme.TextDim
    usernameLabel.TextSize = 11
    usernameLabel.Font = Enum.Font.ArimoBold
    usernameLabel.TextXAlignment = Enum.TextXAlignment.Left
    usernameLabel.TextTruncate = Enum.TextTruncate.AtEnd
    usernameLabel.ZIndex = 4
    usernameLabel.Parent = profilePanel

    local userIdLabel = Instance.new("TextLabel")
    userIdLabel.Size = UDim2.new(1, -92, 0, 14)
    userIdLabel.Position = UDim2.new(0, 78, 0, 72)
    userIdLabel.BackgroundTransparency = 1
    userIdLabel.Text = "User ID: " .. tostring(player and player.UserId or 0)
    userIdLabel.TextColor3 = Arqel.Theme.Accent
    userIdLabel.TextSize = 9
    userIdLabel.Font = Enum.Font.Code
    userIdLabel.TextXAlignment = Enum.TextXAlignment.Left
    userIdLabel.ZIndex = 4
    userIdLabel.Parent = profilePanel

    local clientLabel = Instance.new("TextLabel")
    clientLabel.Size = UDim2.new(1, -92, 0, 14)
    clientLabel.Position = UDim2.new(0, 78, 0, 87)
    clientLabel.BackgroundTransparency = 1
    clientLabel.Text = "Client: " .. getExecutorName() .. " • " .. getDeviceType()
    clientLabel.TextColor3 = Arqel.Theme.TextDim
    clientLabel.TextTransparency = 0.12
    clientLabel.TextSize = 8
    clientLabel.Font = Enum.Font.ArimoBold
    clientLabel.TextXAlignment = Enum.TextXAlignment.Left
    clientLabel.TextTruncate = Enum.TextTruncate.AtEnd
    clientLabel.ZIndex = 4
    clientLabel.Parent = profilePanel

    profilePanel.MouseEnter:Connect(function()
        TweenService:Create(profileStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Color = Arqel.Theme.Accent, Transparency = 0.05}):Play()
        TweenService:Create(avatarStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Transparency = 0}):Play()
    end)
    profilePanel.MouseLeave:Connect(function()
        TweenService:Create(profileStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Color = Arqel.Theme.Divider, Transparency = 0.25}):Play()
        TweenService:Create(avatarStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {Transparency = 0.35}):Play()
    end)

    -- Session card
    local sessionPanel = createPanel(content, mobile and 119 or 114, 5)
    addSectionTitle(sessionPanel, "SESSION", "server", 1)

    local function makeInfoRow(parent, y, title, value, iconName, copyText, isCode)
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -28, 0, 28)
        row.Position = UDim2.new(0, 14, 0, y)
        row.BackgroundTransparency = 1
        row.ZIndex = 4
        row.Parent = parent

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 14, 0, 14)
        icon.Position = UDim2.new(0, 0, 0.5, 0)
        icon.AnchorPoint = Vector2.new(0, 0.5)
        icon.BackgroundTransparency = 1
        icon.Image = getIcon(iconName)
        icon.ImageColor3 = Arqel.Theme.TextDim
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ZIndex = 5
        icon.Parent = row

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(0, 58, 1, 0)
        titleLabel.Position = UDim2.new(0, 22, 0, 0)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Arqel.Theme.TextDim
        titleLabel.TextSize = 9
        titleLabel.Font = Enum.Font.ArimoBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 5
        titleLabel.Parent = row

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, copyText and -116 or -86, 1, 0)
        valueLabel.Position = UDim2.new(0, 80, 0, 0)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = value
        valueLabel.TextColor3 = title == "Server" and Arqel.Theme.Success or Arqel.Theme.Text
        valueLabel.TextSize = isCode and 9 or 10
        valueLabel.Font = isCode and Enum.Font.Code or Enum.Font.ArimoBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
        valueLabel.ZIndex = 5
        valueLabel.Parent = row

        if copyText then
            local copyBtn = Instance.new("ImageButton")
            copyBtn.Size = UDim2.new(0, 17, 0, 17)
            copyBtn.Position = UDim2.new(1, 0, 0.5, 0)
            copyBtn.AnchorPoint = Vector2.new(1, 0.5)
            copyBtn.BackgroundTransparency = 1
            copyBtn.Image = getIcon("copy")
            copyBtn.ImageColor3 = Arqel.Theme.TextDim
            copyBtn.ScaleType = Enum.ScaleType.Fit
            copyBtn.ZIndex = 6
            copyBtn.Parent = row
            copyBtn.MouseEnter:Connect(function()
                TweenService:Create(copyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {ImageColor3 = Arqel.Theme.Accent}):Play()
            end)
            copyBtn.MouseLeave:Connect(function()
                TweenService:Create(copyBtn, TweenInfo.new(0.15, Enum.EasingStyle.Quart), {ImageColor3 = Arqel.Theme.TextDim}):Play()
            end)
            copyBtn.Activated:Connect(function()
                local ok = pcall(function()
                    setclipboard(copyText)
                end)
                if ok then
                    TweenService:Create(copyBtn, TweenInfo.new(0.12, Enum.EasingStyle.Quart), {ImageColor3 = Arqel.Theme.Success}):Play()
                    Arqel:Notify("Copied", title .. " copied to clipboard.", 2, "copy")
                    task.delay(0.45, function()
                        if copyBtn and copyBtn.Parent then
                            TweenService:Create(copyBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {ImageColor3 = Arqel.Theme.TextDim}):Play()
                        end
                    end)
                end
            end)
        end

        return valueLabel
    end

    makeInfoRow(sessionPanel, 28, "Place ID", tostring(game.PlaceId), "mapPin", tostring(game.PlaceId), true)
    makeInfoRow(sessionPanel, 55, "Job ID", tostring(game.JobId), "server", tostring(game.JobId), true)
    makeInfoRow(sessionPanel, 82, "Server", "Connected", "circleCheck", nil, false)

    -- Stats
    local statsPanel = createPanel(content, mobile and 105 or 96, 6)
    addSectionTitle(statsPanel, "STATS", "chart", 1)

    local statsHolder = Instance.new("Frame")
    statsHolder.Size = UDim2.new(1, -28, 0, mobile and 65 or 56)
    statsHolder.Position = UDim2.new(0, 14, 0, 29)
    statsHolder.BackgroundTransparency = 1
    statsHolder.ZIndex = 4
    statsHolder.Parent = statsPanel

    local statsLayout = Instance.new("UIListLayout")
    statsLayout.FillDirection = Enum.FillDirection.Horizontal
    statsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    statsLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    statsLayout.Padding = UDim.new(0, 7)
    statsLayout.Parent = statsHolder

    local statElements = {}

    local function createStat(title, value, iconName)
        local card = Instance.new("Frame")
        card.Size = UDim2.new(0.25, -6, 1, 0)
        card.BackgroundColor3 = Arqel.Theme.Input
        card.BorderSizePixel = 0
        card.ZIndex = 4
        card.Parent = statsHolder
        Instance.new("UICorner", card).CornerRadius = UDim.new(0, 6)

        local stroke = Instance.new("UIStroke")
        stroke.Color = Arqel.Theme.Divider
        stroke.Thickness = 1
        stroke.Transparency = 0.15
        stroke.Parent = card

        local icon = Instance.new("ImageLabel")
        icon.Size = UDim2.new(0, 13, 0, 13)
        icon.Position = UDim2.new(0, 9, 0, 8)
        icon.BackgroundTransparency = 1
        icon.Image = getIcon(iconName)
        icon.ImageColor3 = Arqel.Theme.TextDim
        icon.ScaleType = Enum.ScaleType.Fit
        icon.ZIndex = 5
        icon.Parent = card

        local titleLabel = Instance.new("TextLabel")
        titleLabel.Size = UDim2.new(1, -28, 0, 13)
        titleLabel.Position = UDim2.new(0, 26, 0, 7)
        titleLabel.BackgroundTransparency = 1
        titleLabel.Text = title
        titleLabel.TextColor3 = Arqel.Theme.TextDim
        titleLabel.TextSize = 8
        titleLabel.Font = Enum.Font.ArimoBold
        titleLabel.TextXAlignment = Enum.TextXAlignment.Left
        titleLabel.ZIndex = 5
        titleLabel.Parent = card

        local valueLabel = Instance.new("TextLabel")
        valueLabel.Size = UDim2.new(1, -16, 0, 21)
        valueLabel.Position = UDim2.new(0, 8, 1, -28)
        valueLabel.BackgroundTransparency = 1
        valueLabel.Text = value
        valueLabel.TextColor3 = Arqel.Theme.Text
        valueLabel.TextSize = mobile and 10 or 11
        valueLabel.Font = Enum.Font.ArimoBold
        valueLabel.TextXAlignment = Enum.TextXAlignment.Left
        valueLabel.TextTruncate = Enum.TextTruncate.AtEnd
        valueLabel.ZIndex = 5
        valueLabel.Parent = card

        return {frame = card, stroke = stroke, icon = icon, title = titleLabel, value = valueLabel}
    end

    statElements.Key = createStat("KEY", "Waiting", "keyround")
    statElements.Session = createStat("SESSION", "Active", "clock")
    statElements.Server = createStat("SERVER", "Connected", "server")
    statElements.Access = createStat("ACCESS", "Locked", "lock")

    local KeyState = {
        Status = "Empty",
        Valid = false,
        Verifying = false
    }

    local spinConnection
    local verifyingToken = 0

    local errorMessages = {
        KEY_INVALID = "Key not found in system",
        KEY_EXPIRED = "Key has expired",
        HWID_BANNED = "Hardware banned",
        KEY_INVALIDATED = "Key was revoked",
        ALREADY_USED = "One-time key already used",
        HWID_MISMATCH = "HWID limit reached",
        SERVICE_NOT_FOUND = "Service not found",
        SERVICE_MISMATCH = "Wrong service",
        PREMIUM_REQUIRED = "Premium required",
        ERROR = "Network error"
    }

    local function updateStats()
        local keyValue = "Waiting"
        local keyColor = Arqel.Theme.Text
        local accessValue = "Locked"
        local accessColor = Arqel.Theme.Text

        if KeyState.Status == "Ready" then
            keyValue = "Ready"
            keyColor = Arqel.Theme.Accent
        elseif KeyState.Status == "Verifying" then
            keyValue = "Checking"
            keyColor = Arqel.Theme.Accent
        elseif KeyState.Status == "Valid" then
            keyValue = "Valid"
            keyColor = Arqel.Theme.Success
            accessValue = "Granted"
            accessColor = Arqel.Theme.Success
        elseif KeyState.Status == "Invalid" then
            keyValue = "Invalid"
            keyColor = Arqel.Theme.Error
        elseif KeyState.Status == "Error" then
            keyValue = "Error"
            keyColor = Arqel.Theme.Warning
        end

        for _, state in pairs({
            {element = statElements.Key, value = keyValue, color = keyColor},
            {element = statElements.Access, value = accessValue, color = accessColor},
            {element = statElements.Session, value = "Active", color = Arqel.Theme.Success},
            {element = statElements.Server, value = "Connected", color = Arqel.Theme.Success}
        }) do
            if state.element and state.element.value then
                TweenService:Create(state.element.value, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                    TextColor3 = state.color
                }):Play()
                state.element.value.Text = state.value
            end
        end
    end

    local function setRedeemState(state)
        if state == "Empty" then
            redeemBtn.Active = false
            TweenService:Create(redeemBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Pending
            }):Play()
            TweenService:Create(redeemStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Divider
            }):Play()
            TweenService:Create(redeemIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.TextDim
            }):Play()
            setTextColor(redeemLabel, Arqel.Theme.TextDim)
            redeemLabel.Text = "Redeem Key"
            redeemIcon.Image = getIcon("circleCheck")
        elseif state == "Ready" then
            redeemBtn.Active = true
            TweenService:Create(redeemBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Accent
            }):Play()
            TweenService:Create(redeemStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Accent
            }):Play()
            TweenService:Create(redeemIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.Text
            }):Play()
            setTextColor(redeemLabel, Arqel.Theme.Text)
            redeemLabel.Text = "Redeem Key"
            redeemIcon.Image = getIcon("arrow")
        elseif state == "Verifying" then
            redeemBtn.Active = false
            TweenService:Create(redeemBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Accent
            }):Play()
            TweenService:Create(redeemStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.AccentHover
            }):Play()
            redeemLabel.Text = "Verifying..."
            setTextColor(redeemLabel, Arqel.Theme.Text)
            redeemIcon.Image = getIcon("loader")
            TweenService:Create(redeemIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.Text
            }):Play()
        elseif state == "Valid" then
            redeemBtn.Active = false
            TweenService:Create(redeemBtn, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Success
            }):Play()
            TweenService:Create(redeemStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Success
            }):Play()
            redeemLabel.Text = "Key Redeemed"
            setTextColor(redeemLabel, Arqel.Theme.Text)
            redeemIcon.Image = getIcon("circleCheck")
            TweenService:Create(redeemIcon, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.Text
            }):Play()
        elseif state == "Invalid" then
            redeemBtn.Active = true
            TweenService:Create(redeemBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(52, 29, 35)
            }):Play()
            TweenService:Create(redeemStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Error
            }):Play()
            redeemLabel.Text = "Try Again"
            setTextColor(redeemLabel, Arqel.Theme.Text)
            redeemIcon.Image = getIcon("circleX")
            TweenService:Create(redeemIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.Error
            }):Play()
        elseif state == "Error" then
            redeemBtn.Active = true
            TweenService:Create(redeemBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Input
            }):Play()
            TweenService:Create(redeemStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Warning
            }):Play()
            redeemLabel.Text = "Retry"
            setTextColor(redeemLabel, Arqel.Theme.Text)
            redeemIcon.Image = getIcon("alert")
            TweenService:Create(redeemIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.Warning
            }):Play()
        end
    end

    local function setStatus(state, customText)
        KeyState.Status = state
        KeyState.Valid = state == "Valid"
        KeyState.Verifying = state == "Verifying"

        if spinConnection then
            spinConnection:Disconnect()
            spinConnection = nil
            redeemIcon.Rotation = 0
            statusIcon.Rotation = 0
        end

        local color = Arqel.Theme.StatusIdle
        local icon = "lock"
        local text = customText or "Enter a key"

        if state == "Ready" then
            color = Arqel.Theme.Accent
            icon = "keyround"
            text = customText or "Ready to verify"
        elseif state == "Verifying" then
            color = Arqel.Theme.Accent
            icon = "loader"
            text = customText or "Verifying..."
            spinConnection = RunService.Heartbeat:Connect(function(dt)
                if not statusIcon.Parent or not redeemIcon.Parent then
                    if spinConnection then spinConnection:Disconnect() end
                    return
                end
                statusIcon.Rotation = (statusIcon.Rotation + dt * 360) % 360
                redeemIcon.Rotation = (redeemIcon.Rotation - dt * 360) % 360
            end)
        elseif state == "Valid" then
            color = Arqel.Theme.Success
            icon = "circleCheck"
            text = customText or "Valid key"
        elseif state == "Invalid" then
            color = Arqel.Theme.Error
            icon = "circleX"
            text = customText or "Invalid key"
        elseif state == "Error" then
            color = Arqel.Theme.Warning
            icon = "alert"
            text = customText or "Connection error"
        end

        statusIcon.Image = getIcon(icon)
        TweenService:Create(statusIcon, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {ImageColor3 = color}):Play()
        TweenService:Create(statusLabel, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {TextColor3 = color}):Play()
        TweenService:Create(statusStroke, TweenInfo.new(0.2, Enum.EasingStyle.Quart), {Color = color, Transparency = 0.55}):Play()
        statusLabel.Text = text
        setRedeemState(state)
        updateStats()

        if state == "Valid" then
            TweenService:Create(statusPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(20, 31, 25)
            }):Play()
        elseif state == "Invalid" then
            TweenService:Create(statusPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(31, 21, 25)
            }):Play()
        else
            TweenService:Create(statusPanel, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Surface
            }):Play()
        end
    end

    local function updateInputState()
        if KeyState.Verifying then return end

        local hasText = textBox.Text:gsub("%s+", "") ~= ""
        if hasText then
            setStatus("Ready")
        else
            setStatus("Empty")
        end
    end

    local function setFocusVisual(focused)
        if focused then
            textBox.PlaceholderText = ""
            TweenService:Create(inputStroke, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                Transparency = 0.18,
                Color = Arqel.Theme.Accent
            }):Play()
            TweenService:Create(keyIcon, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.Accent
            }):Play()
            TweenService:Create(inputGlow, TweenInfo.new(0.16, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 0.9
            }):Play()
        else
            textBox.PlaceholderText = textBox.Text == "" and "XXXX-XXXX-XXXX" or ""
            TweenService:Create(inputStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                Transparency = 0.82,
                Color = Arqel.Theme.Accent
            }):Play()
            TweenService:Create(keyIcon, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                ImageColor3 = Arqel.Theme.TextDim
            }):Play()
            TweenService:Create(inputGlow, TweenInfo.new(0.18, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 1
            }):Play()
        end
    end

    local function openExternal(url)
        local opened = pcall(function()
            local GuiService = cloneref(game:GetService("GuiService"))
            GuiService:OpenBrowserWindow(url)
        end)

        if opened then
            return true
        end

        return pcall(function()
            setclipboard(url)
        end)
    end

    local function closeDoorsThenExit(callback)
        ui.closeAllPanels(nil, nil, function()
            doors.close(function()
                task.wait(0.25)
                if callback then callback() end
            end)
        end)
    end

    local function finishSuccess()
        getgenv().SCRIPT_KEY = textBox.Text:gsub("%s+", "")
        getgenv().InfinityXKey = getgenv().SCRIPT_KEY
        getgenv().ArqelLoaded = false
        setStatus("Valid", "Access granted")
        Arqel:Notify("Success", "Key validated successfully.", 2, "success")
        task.wait(0.85)
        closeDoorsThenExit(function()
            disableBlur()
            TweenService:Create(container, TweenInfo.new(0.34, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, -0.5, 0)
            }):Play()
            TweenService:Create(mainFrame, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.35)
            screenGui:Destroy()
            if Arqel.Callbacks.OnSuccess then
                Arqel.Callbacks.OnSuccess()
            end
        end)
    end

    local function handleRedeem()
        if KeyState.Verifying then return end

        local key = textBox.Text:gsub("%s+", "")
        if key == "" then
            setStatus("Empty", "Enter a key")
            return
        end

        if not Internal.ValidateFunction then
            setStatus("Error", "Connection error")
            Arqel:Notify("Connection Error", "No key validation method is configured.", 4, "error")
            return
        end

        verifyingToken += 1
        local currentToken = verifyingToken
        setStatus("Verifying")

        task.spawn(function()
            local success, result, message = pcall(Internal.ValidateFunction, key)

            if currentToken ~= verifyingToken then return end

            local valid = false
            local isConnectionError = not success
            local errorMsg = "Invalid key"
            local errorCode

            if success then
                if type(result) == "table" then
                    valid = result.valid == true
                    errorCode = result.error

                    if errorCode == "ERROR" then
                        isConnectionError = true
                        errorMsg = "Connection error"
                    else
                        errorMsg = errorMessages[errorCode or ""] or result.message or errorCode or "Invalid key"
                    end

                    if errorCode == "HWID_BANNED" then
                        task.delay(2, function()
                            local localPlayer = cloneref(Players.LocalPlayer)
                            if localPlayer then
                                pcall(function()
                                    localPlayer:Kick("Hardware banned")
                                end)
                            end
                        end)
                    end
                elseif type(result) == "boolean" then
                    valid = result
                    errorMsg = message or "Invalid key"
                else
                    isConnectionError = true
                    errorMsg = "Connection error"
                end
            else
                errorMsg = "Connection error"
            end

            if valid then
                saveKey(key)
                textBox.Text = key
                finishSuccess()
            elseif isConnectionError then
                setStatus("Error", "Connection error")
                Arqel:Notify("Connection Error", "Unable to verify the key right now.", 4, "error")
            else
                setStatus("Invalid", errorMsg)
                Arqel:Notify("Invalid Key", errorMsg, 4, "error")
                if Arqel.Callbacks.OnFail then
                    Arqel.Callbacks.OnFail(errorMsg)
                end
            end
        end)
    end

    textBox.Focused:Connect(function()
        setFocusVisual(true)
    end)

    textBox.FocusLost:Connect(function()
        setFocusVisual(false)
    end)

    textBox:GetPropertyChangedSignal("Text"):Connect(function()
        updateInputState()
    end)

    redeemBtn.MouseEnter:Connect(function()
        if redeemBtn.Active and not KeyState.Verifying then
            local hoverColor = KeyState.Status == "Invalid"
                and Color3.fromRGB(65, 32, 42)
                or Arqel.Theme.AccentHover

            TweenService:Create(redeemBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                BackgroundColor3 = hoverColor
            }):Play()
        end
    end)

    redeemBtn.MouseLeave:Connect(function()
        if redeemBtn.Active and not KeyState.Verifying then
            local baseColor = KeyState.Status == "Invalid"
                and Color3.fromRGB(52, 29, 35)
                or Arqel.Theme.Accent

            TweenService:Create(redeemBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                BackgroundColor3 = baseColor
            }):Play()
        end
    end)

    redeemBtn.Activated:Connect(handleRedeem)

    acquireBtn.MouseEnter:Connect(function()
        if acquireBtn.Active then
            TweenService:Create(acquireBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.SurfaceHover
            }):Play()
            TweenService:Create(acquireStroke, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Accent,
                Transparency = 0.05
            }):Play()
        end
    end)

    acquireBtn.MouseLeave:Connect(function()
        if acquireBtn.Active then
            TweenService:Create(acquireBtn, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Arqel.Theme.Input
            }):Play()
            TweenService:Create(acquireStroke, TweenInfo.new(0.14, Enum.EasingStyle.Quart), {
                Color = Arqel.Theme.Divider,
                Transparency = 0.2
            }):Play()
        end
    end)

    acquireBtn.Activated:Connect(function()
        if Arqel.Options.NoGetKey then
            Arqel:Notify("Unavailable", "Get Key is unavailable.", 3, "nogetkey")
            return
        end

        local url = Arqel.Links.GetKey
        if url == "" and Internal.Junkie then
            pcall(function()
                url = Internal.Junkie.get_key_link()
            end)
        end

        if url and url ~= "" then
            local opened = openExternal(url)
            if opened then
                Arqel:Notify("Get Key", "Opening the official key page.", 2, "key")
            else
                Arqel:Notify("Get Key", "Key link copied to clipboard.", 2, "copy")
            end
        else
            Arqel:Notify("Get Key", "No key link is configured.", 3, "warning")
        end
    end)

    closeBtn.Activated:Connect(function()
        getgenv().ArqelClosed = true
        getgenv().ArqelLoaded = false
        verifyingToken += 1
        if spinConnection then spinConnection:Disconnect() end
        closeDoorsThenExit(function()
            fullCleanup()
            TweenService:Create(container, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0.5, 0, -0.5, 0)
            }):Play()
            TweenService:Create(mainFrame, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.3)
            if screenGui and screenGui.Parent then
                screenGui:Destroy()
            end
            if Arqel.Callbacks.OnClose then
                Arqel.Callbacks.OnClose()
            end
        end)
    end)

    -- Entry animation follows the existing door/blur system and adds staggered content reveal.
    for _, object in ipairs({
        header, statusPanel, inputPanel, buttonHolder, profilePanel, sessionPanel, statsPanel
    }) do
        if object:IsA("GuiObject") then
            object.BackgroundTransparency = object == header and 0 or object.BackgroundTransparency
        end
    end

    local animatedPanels = {
        {object = statusPanel, stroke = statusStroke, delay = 0},
        {object = inputPanel, stroke = inputStroke, delay = 0.05},
        {object = buttonHolder, stroke = nil, delay = 0.10},
        {object = profilePanel, stroke = profileStroke, delay = 0.15},
        {object = sessionPanel, stroke = sessionPanel:FindFirstChildOfClass("UIStroke"), delay = 0.20},
        {object = statsPanel, stroke = statsPanel:FindFirstChildOfClass("UIStroke"), delay = 0.25}
    }

    for _, item in ipairs(animatedPanels) do
        local panelScale = Instance.new("UIScale")
        panelScale.Scale = 0.985
        panelScale.Parent = item.object
        item.scale = panelScale

        if item.object ~= buttonHolder then
            item.object.BackgroundTransparency = 1
        end
        if item.stroke then
            item.stroke.Transparency = 1
        end
    end

    setupDragging(header, container)

    TweenService:Create(container, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()

    TweenService:Create(scaleObject, TweenInfo.new(0.42, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Scale = 1
    }):Play()

    task.wait(0.28)
    doors.open(function()
        TweenService:Create(logo, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {ImageTransparency = 0}):Play()
        TweenService:Create(statusStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quart), {Transparency = 0.55}):Play()

        for _, item in ipairs(animatedPanels) do
            task.delay(item.delay, function()
                if not item.object or not item.object.Parent then return end

                TweenService:Create(item.scale, TweenInfo.new(0.24, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()

                if item.object ~= buttonHolder then
                    TweenService:Create(item.object, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 0
                    }):Play()
                end

                if item.stroke then
                    local targetTransparency = item.object == statusPanel and 0.55 or 0.25
                    TweenService:Create(item.stroke, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                        Transparency = targetTransparency
                    }):Play()
                end
            end)
        end
    end)
end

function Arqel:Launch()
    Internal.IsJunkieMode = false
    Internal.ValidateFunction = Arqel.Callbacks.OnVerify
    local existingKey = getgenv().SCRIPT_KEY
    if existingKey and existingKey ~= "" then
        if existingKey == "KEYLESS" then
            Arqel:Notify("Executed", "Script loaded successfully!", 2, "success")
            if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end return
        elseif Internal.ValidateFunction and validateKey(existingKey, Internal.ValidateFunction) then
            Arqel:Notify("Executed", "Script loaded successfully!", 2, "success")
            if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end return
        end
        getgenv().SCRIPT_KEY = nil
    end
    getgenv().ArqelClosed = false
    EnsureIconsReady(function()
        if Arqel.Options.Keyless == true then
            if Arqel.Options.KeylessUI == false then handleKeylessSkip() return end
            BuildKeylessUI()
            while not getgenv().SCRIPT_KEY do task.wait(0.1) end
            return
        end
        if Arqel.Storage.AutoLoad and Internal.ValidateFunction then
            local savedKey = loadKey()
            if savedKey and savedKey ~= "" then
                Arqel:Notify("Checking", "Validating saved key...", 2, "shield") task.wait(0.5)
                if validateKey(savedKey, Internal.ValidateFunction) then
                    getgenv().SCRIPT_KEY = savedKey
                    Arqel:Notify("Welcome Back", "Key validated!", 2, "success")
                    if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end return
                else clearKey() Arqel:Notify("Expired", "Saved key is no longer valid", 3, "warning") task.wait(1) end
            end
        end
        BuildKeyUI()
        while not getgenv().SCRIPT_KEY do task.wait(0.1) end
    end)
end

function Arqel:LaunchJunkie(config)
    assert(config and config.Service and config.Identifier and config.Provider, "Config required: Service, Identifier, Provider")
    Internal.IsJunkieMode = true
    local existingKey = getgenv().SCRIPT_KEY
    if existingKey and existingKey ~= "" then
        Arqel:Notify("Executed", "Script loaded successfully!", 2, "success")
        if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end return
    end
    getgenv().ArqelClosed = false
    EnsureIconsReady(function()
        local success, Junkie = pcall(function() return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))() end)
        if not success or not Junkie then Arqel:Notify("Error", "Failed to load Junkie SDK", 5, "error") return end
        Junkie.service = config.Service
        Junkie.identifier = config.Identifier
        Junkie.provider = config.Provider
        Internal.Junkie = Junkie
        if Arqel.Links.GetKey == "" then pcall(function() Arqel.Links.GetKey = Junkie.get_key_link() end) end
        Internal.ValidateFunction = function(key) return Junkie.check_key(key) end
        if Arqel.Options.Keyless == nil then
            local ks, kr = pcall(function() return Junkie.check_key("KEYLESS") end)
            if ks and kr and kr.valid then
                if Arqel.Options.KeylessUI == false then handleKeylessSkip() return end
                BuildKeylessUI()
                while not getgenv().SCRIPT_KEY do task.wait(0.1) end
                return
            end
        elseif Arqel.Options.Keyless == true then
            if Arqel.Options.KeylessUI == false then handleKeylessSkip() return end
            BuildKeylessUI()
            while not getgenv().SCRIPT_KEY do task.wait(0.1) end
            return
        end
        if Arqel.Storage.AutoLoad then
            local savedKey = loadKey()
            if savedKey and savedKey ~= "" then
                Arqel:Notify("Checking", "Validating saved key...", 2, "shield") task.wait(0.5)
                local vs, vr = pcall(function() return Junkie.check_key(savedKey) end)
                if vs and vr and vr.valid then
                    getgenv().SCRIPT_KEY = savedKey
                    Arqel:Notify("Welcome Back", "Key validated!", 2, "success")
                    if Arqel.Callbacks.OnSuccess then Arqel.Callbacks.OnSuccess() end return
                else clearKey() Arqel:Notify("Expired", "Saved key is no longer valid", 3, "warning") task.wait(1) end
            end
        end
        BuildKeyUI()
        while not getgenv().SCRIPT_KEY do task.wait(0.1) end
    end)
end

function Arqel:GetSavedKey() return loadKey() end
function Arqel:ClearSavedKey() return clearKey() end

getgenv().Arqel = Arqel
getgenv().InfinityX = Arqel
return Arqel
