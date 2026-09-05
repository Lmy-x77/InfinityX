getgenv().AfkFarmSettings = {
  TeleportDelay = 0.3,
  RemoteDelay = 0.15,
  HackCooldown = 15,
  LoopDelay = 3,
  MinigameSpamInterval = 0.1,
  BeastHuntDelay = 1,
  Priority = "Player1",
  SavePlayer = true,
  HackExtraComputer = true
}

local AFK_Settings = getgenv().AfkFarmSettings

local AFK_FarmStats = {
  Role = "Unknown",
  Status = "Idle",
  ComputersRemaining = 0,
  ComputersHacked = 0,
  CurrentTarget = "None",
  HackProgress = 0,
  SurvivorsRemaining = 0,
  SurvivorsCaptured = 0,
  IsActive = false,
  SavePlayer = false,
  SavedPlayer = "None",
  Player2BeastDone = false
}

local AFK_StatsLabel = AfkFarmBox:AddLabel("Loading stats...", true)

local AFK_SavePlayerDetected = false
local AFK_SavePlayerConnections = {}
local AFK_SavePlayerDoneMap = nil
local AFK_SavePlayerTeleported = false

local AFK_EscapeDetected = false
local AFK_EscapeConnections = {}
local AFK_MyEscapeDetected = false
local AFK_MyEscapeConnection = nil

local AFK_Player2BeastDoneMap = nil

local function AFK_GetMap()
  local currentMap = ReplicatedStorage:FindFirstChild("CurrentMap")
  return currentMap and workspace:FindFirstChild(tostring(currentMap.Value))
end

local function AFK_IsInMatch()
  local spawnPad = workspace:FindFirstChild("LobbyInteractiveObjects")
  spawnPad = spawnPad and spawnPad:FindFirstChild("LobbySpawnPad")

  if not spawnPad then
    return true
  end

  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")

  if not hrp then
    return false
  end

  local p = hrp.Position
  local pad = spawnPad.Position
  local size = spawnPad.Size

  return not (
    math.abs(p.X - pad.X) <= size.X / 2 + 2 and
    math.abs(p.Z - pad.Z) <= size.Z / 2 + 2
  )
end

local function AFK_IsBeast()
  local stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
  local value = stats and stats:FindFirstChild("IsBeast")

  return value and value.Value or false
end

local function AFK_IsPlayerInLobby(player)
  local spawnPad = workspace:FindFirstChild("LobbyInteractiveObjects")
  spawnPad = spawnPad and spawnPad:FindFirstChild("LobbySpawnPad")

  if not spawnPad then
    return false
  end

  local char = player.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")

  if not hrp then
    return true
  end

  local p = hrp.Position
  local pad = spawnPad.Position
  local size = spawnPad.Size

  return math.abs(p.X - pad.X) <= size.X / 2 + 2 and
    math.abs(p.Z - pad.Z) <= size.Z / 2 + 2
end

local function AFK_TeleportTo(cframe)
  local char = LocalPlayer.Character
  local hrp = char and char:FindFirstChild("HumanoidRootPart")

  if not hrp then
    return false
  end

  hrp.CFrame = cframe

  task.wait(AFK_Settings.TeleportDelay)

  return true
end

local function AFK_FireAction()
  ReplicatedStorage:WaitForChild("RemoteEvent"):FireServer(
    "Input",
    "Action",
    true
  )
end

local function AFK_UpdateStatsLabel()
  local text =
    "<font color='#B388FF'>◆</font> <b>AFK Farm</b>\n" ..
    "<font color='#B388FF'>├</font> <b>Status:</b> <font color='#8FAF9A'>" ..
    tostring(AFK_FarmStats.Status) ..
    "</font>\n" ..
    "<font color='#B388FF'>├</font> <b>Role:</b> <font color='#DDD6F5'>" ..
    tostring(AFK_FarmStats.Role) ..
    "</font>\n"

  if AFK_FarmStats.Role == "Survivor" then
    text = text ..
      "<font color='#B388FF'>├</font> <b>Computers:</b> <font color='#D19CFF'>" ..
      tostring(AFK_FarmStats.ComputersRemaining) ..
      " remaining</font>\n" ..

      "<font color='#B388FF'>├</font> <b>Hacked:</b> <font color='#8FAF9A'>" ..
      tostring(AFK_FarmStats.ComputersHacked) ..
      "</font>\n"

    if AFK_Settings.Priority == "Player1" and AFK_Settings.SavePlayer then
      local saveState = AFK_FarmStats.SavePlayer and
        "<font color='#8FAF9A'>Saved</font>" or
        "<font color='#D19CFF'>Waiting</font>"

      text = text ..
        "<font color='#B388FF'>├</font> <b>Save Player:</b> " ..
        saveState ..
        "\n" ..

        "<font color='#B388FF'>├</font> <b>Saved:</b> <font color='#DDD6F5'>" ..
        tostring(AFK_FarmStats.SavedPlayer) ..
        "</font>\n"
    end

    if AFK_FarmStats.HackProgress > 0 then
      text = text ..
        "<font color='#B388FF'>├</font> <b>Hack Progress:</b> <font color='#D19CFF'>" ..
        math.floor(AFK_FarmStats.HackProgress * 100) ..
        "%</font>\n"
    end

    text = text ..
      "<font color='#B388FF'>└</font> <b>Target:</b> <font color='#DDD6F5'>" ..
      tostring(AFK_FarmStats.CurrentTarget) ..
      "</font>"

  elseif AFK_FarmStats.Role == "Beast" then
    text = text ..
      "<font color='#B388FF'>├</font> <b>Survivors:</b> <font color='#D19CFF'>" ..
      tostring(AFK_FarmStats.SurvivorsRemaining) ..
      " remaining</font>\n" ..

      "<font color='#B388FF'>├</font> <b>Captured:</b> <font color='#8FAF9A'>" ..
      tostring(AFK_FarmStats.SurvivorsCaptured) ..
      "</font>\n"

    if AFK_Settings.Priority == "Player2" then
      text = text ..
        "<font color='#B388FF'>├</font> <b>Mode:</b> <font color='#D19CFF'>One Capture</font>\n"
    end

    text = text ..
      "<font color='#B388FF'>└</font> <b>Target:</b> <font color='#DDD6F5'>" ..
      tostring(AFK_FarmStats.CurrentTarget) ..
      "</font>"

  else
    text = text ..
      "<font color='#B388FF'>└</font> <b>Target:</b> <font color='#DDD6F5'>" ..
      tostring(AFK_FarmStats.CurrentTarget) ..
      "</font>"
  end

  AFK_StatsLabel:SetText(text)
end

local function AFK_ResetStatsLabel()
  AFK_StatsLabel:SetText(
    "<font color='#B388FF'>◆</font> <b>AFK Farm</b>\n" ..
    "<font color='#B388FF'>└</font> <b>Status:</b> <font color='#8FAF9A'>Idle</font>\n" ..
    "<font color='#B388FF'>└</font> <b>Role:</b> <font color='#DDD6F5'>Unknown</font>\n" ..
    "<font color='#B388FF'>└</font> <b>Target:</b> <font color='#DDD6F5'>None</font>"
  )
end

local function AFK_WaitForActionComplete(progress, timeout)
  if not progress then
    return false
  end

  if progress.Value >= 1 then
    return true
  end

  local completed = false

  local connection = progress:GetPropertyChangedSignal("Value"):Connect(function()
    if progress.Value >= 1 then
      completed = true
    end
  end)

  local start = tick()

  while AFK_FarmStats.IsActive and not completed do
    if progress.Value >= 1 then
      completed = true
      break
    end

    if timeout and tick() - start >= timeout then
      break
    end

    task.wait(0.03)
  end

  connection:Disconnect()

  return completed
end

local function AFK_GetStats(player)
  return player and player:FindFirstChild("TempPlayerStatsModule")
end

local function AFK_GetCaptured(player)
  local stats = AFK_GetStats(player)
  return stats and stats:FindFirstChild("Captured")
end

local function AFK_GetEscaped(player)
  local stats = AFK_GetStats(player)
  return stats and stats:FindFirstChild("Escaped")
end

local function AFK_GetActionProgress(player)
  local stats = AFK_GetStats(player)
  return stats and stats:FindFirstChild("ActionProgress")
end

local function AFK_ClearSavePlayerConnections()
  for _, connection in ipairs(AFK_SavePlayerConnections) do
    if connection then
      connection:Disconnect()
    end
  end

  table.clear(AFK_SavePlayerConnections)
end

local function AFK_SetupSavePlayerDetection()
  AFK_ClearSavePlayerConnections()
  AFK_SavePlayerDetected = false

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and not AFK_IsPlayerInLobby(player) then
      local captured = AFK_GetCaptured(player)

      if captured then
        if captured.Value then
          AFK_SavePlayerDetected = true
        end

        table.insert(
          AFK_SavePlayerConnections,
          captured:GetPropertyChangedSignal("Value"):Connect(function()
            if not AFK_FarmStats.IsActive then
              return
            end

            if not AFK_IsInMatch() then
              return
            end

            if AFK_IsPlayerInLobby(player) then
              return
            end

            if captured.Value then
              AFK_SavePlayerDetected = true
            end
          end)
        )
      end
    end
  end
end

local function AFK_GetBeastPlayer()
  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
      local stats = AFK_GetStats(player)
      local isBeast = stats and stats:FindFirstChild("IsBeast")
      if isBeast and isBeast.Value then
        return player
      end
    end
  end
  return nil
end

local function AFK_GetBeastHammer(beastPlayer)
  local character = beastPlayer and beastPlayer.Character
  if not character then
    return nil
  end
  return character:FindFirstChild("Hammer", true)
end

local function AFK_SaveOnePlayer()
  if not AFK_FarmStats.IsActive then
    return false
  end

  if not AFK_Settings.SavePlayer then
    return true
  end

  if AFK_Settings.Priority ~= "Player1" then
    return true
  end

  if AFK_IsBeast() then
    return true
  end

  if not AFK_IsInMatch() then
    return false
  end

  local map = AFK_GetMap()

  if not map then
    AFK_FarmStats.Status = "Waiting for map..."
    AFK_FarmStats.CurrentTarget = "Map"
    AFK_UpdateStatsLabel()
    return false
  end

  if AFK_SavePlayerDoneMap == map then
    AFK_FarmStats.SavePlayer = true
    return true
  end

  AFK_FarmStats.SavePlayer = false
  AFK_FarmStats.SavedPlayer = "None"
  AFK_SavePlayerTeleported = false

  AFK_FarmStats.Status = "Waiting to save survivor..."
  AFK_FarmStats.CurrentTarget = "Waiting for captured player"
  AFK_UpdateStatsLabel()

  AFK_SetupSavePlayerDetection()

  while AFK_FarmStats.IsActive and
    AFK_Settings.SavePlayer and
    AFK_Settings.Priority == "Player1" do

    if not AFK_IsInMatch() or AFK_IsBeast() then
      AFK_ClearSavePlayerConnections()
      return false
    end

    if AFK_GetMap() ~= map then
      AFK_ClearSavePlayerConnections()
      return false
    end

    if AFK_SavePlayerDetected then
      break
    end

    local beastPlayer = AFK_GetBeastPlayer()
    if beastPlayer then
    local beastCharacter = beastPlayer.Character
    local beastHrp = beastCharacter and beastCharacter:FindFirstChild("HumanoidRootPart")
    local beastHammer = AFK_GetBeastHammer(beastPlayer)

    if not beastHammer then
        AFK_FarmStats.Status = "Waiting for beast hammer..."
        AFK_FarmStats.CurrentTarget = "@" .. beastPlayer.Name
    elseif not beastHrp then
        AFK_FarmStats.Status = "Waiting for beast..."
        AFK_FarmStats.CurrentTarget = "@" .. beastPlayer.Name
    elseif not AFK_SavePlayerTeleported then
        AFK_FarmStats.Status = "Hammer loaded!"
        AFK_FarmStats.CurrentTarget = "Waiting 1 second..."
        AFK_UpdateStatsLabel()

        task.wait(1)

        if not AFK_FarmStats.IsActive then
        return false
        end

        if AFK_GetMap() ~= map then
        return false
        end

        if AFK_IsBeast() then
        return false
        end

        beastCharacter = beastPlayer.Character
        beastHrp = beastCharacter and beastCharacter:FindFirstChild("HumanoidRootPart")
        beastHammer = AFK_GetBeastHammer(beastPlayer)

        if not beastHrp or not beastHammer then
        return false
        end

        local offset = Vector3.new(0, 0, -6)
        local position = beastHrp.Position + beastHrp.CFrame:VectorToWorldSpace(offset)

        AFK_TeleportTo(CFrame.lookAt(position, beastHrp.Position))
        AFK_SavePlayerTeleported = true

        AFK_FarmStats.Status = "Waiting for capture..."
        AFK_FarmStats.CurrentTarget = "Near @" .. beastPlayer.Name
    else
        AFK_FarmStats.Status = "Waiting for capture..."
        AFK_FarmStats.CurrentTarget = "Near @" .. beastPlayer.Name
    end
    else
    AFK_FarmStats.Status = "Waiting for beast..."
    AFK_FarmStats.CurrentTarget = "Player2"
    end

    AFK_UpdateStatsLabel()

    task.wait(0.5)
  end

  AFK_ClearSavePlayerConnections()

  if not AFK_FarmStats.IsActive then
    return false
  end

  if not AFK_Settings.SavePlayer then
    return true
  end

  if AFK_GetMap() ~= map then
    return false
  end

  if not AFK_SavePlayerDetected then
    return false
  end

  local targetPlayer

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and not AFK_IsPlayerInLobby(player) then
      local captured = AFK_GetCaptured(player)

      if captured and captured.Value then
        targetPlayer = player
        break
      end
    end
  end

  if not targetPlayer then
    AFK_FarmStats.Status = "Searching saved survivor..."
    AFK_FarmStats.CurrentTarget = "Captured survivor"
    AFK_UpdateStatsLabel()
    task.wait(0.2)
    return false
  end

  local targetChar = targetPlayer.Character
  local targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

  if not targetHrp then
    AFK_FarmStats.Status = "Waiting for survivor..."
    AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name
    AFK_UpdateStatsLabel()
    task.wait(0.2)
    return false
  end

  local capturedValue = AFK_GetCaptured(targetPlayer)

  if not capturedValue or not capturedValue.Value then
    return false
  end

  AFK_FarmStats.Status = "Saving survivor..."
  AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name
  AFK_FarmStats.SavedPlayer = "@" .. targetPlayer.Name
  AFK_UpdateStatsLabel()

  AFK_TeleportTo(targetHrp.CFrame + targetHrp.CFrame.LookVector * 3)

  if not AFK_FarmStats.IsActive then
    return false
  end

  task.wait(AFK_Settings.RemoteDelay)

  if not AFK_FarmStats.IsActive then
    return false
  end

  AFK_FireAction()

  local saveStart = tick()

  while AFK_FarmStats.IsActive and AFK_Settings.SavePlayer do
    capturedValue = AFK_GetCaptured(targetPlayer)

    if capturedValue and not capturedValue.Value then
      break
    end

    if AFK_GetMap() ~= map then
      return false
    end

    if tick() - saveStart >= 5 then
      AFK_FarmStats.Status = "Retrying save..."
      AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name
      AFK_UpdateStatsLabel()

      targetChar = targetPlayer.Character
      targetHrp = targetChar and targetChar:FindFirstChild("HumanoidRootPart")

      if targetHrp then
        AFK_TeleportTo(targetHrp.CFrame)

        if not AFK_FarmStats.IsActive then
          return false
        end

        task.wait(AFK_Settings.RemoteDelay)

        if not AFK_FarmStats.IsActive then
          return false
        end

        AFK_FireAction()
      end

      saveStart = tick()
    end

    AFK_FarmStats.Status = "Saving survivor..."
    AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name
    AFK_UpdateStatsLabel()

    task.wait(0.1)
  end

  if not AFK_FarmStats.IsActive then
    return false
  end

  if not AFK_Settings.SavePlayer then
    return true
  end

  if AFK_GetMap() ~= map then
    return false
  end

  AFK_SavePlayerDoneMap = map
  AFK_FarmStats.SavePlayer = true
  AFK_FarmStats.Status = "Survivor saved!"
  AFK_FarmStats.CurrentTarget = "Starting computer farm"
  AFK_UpdateStatsLabel()

  task.wait(0.5)

  return true
end

local function AFK_GetExtraComputer(map)
  if not map then
    return nil
  end

  for _, computerTable in ipairs(map:GetChildren()) do
    if computerTable:IsA("Model") and computerTable.Name == "ComputerTable" then
      local screen = computerTable:FindFirstChild("Screen")

      if screen and
        screen:IsA("BasePart") and
        screen.Color ~= Color3.fromRGB(40, 127, 71) then
        for _, trigger in ipairs(computerTable:GetChildren()) do
          if trigger:IsA("BasePart") and
            trigger.Name:lower():find("computertrigger") then
            local actionSign = trigger:FindFirstChild("ActionSign")
            if actionSign and actionSign.Value == 20 then
              return trigger
            end
          end
        end
      end
    end
  end

  return nil
end

local function AFK_HackExtraComputer(targetTrigger)
  if not AFK_FarmStats.IsActive then
    return false
  end

  if AFK_Settings.Priority ~= "Player1" then
    return false
  end

  if AFK_IsBeast() or not AFK_IsInMatch() then
    return false
  end

  AFK_FarmStats.Status = "Hacking extra computer..."
  AFK_FarmStats.CurrentTarget = "Extra Computer"
  AFK_FarmStats.HackProgress = 0
  AFK_UpdateStatsLabel()

  AFK_TeleportTo(targetTrigger.CFrame)

  if not AFK_FarmStats.IsActive or AFK_IsBeast() or not AFK_IsInMatch() then
    return false
  end

  task.wait(1.6)

  if not AFK_FarmStats.IsActive or AFK_IsBeast() or not AFK_IsInMatch() then
    return false
  end

  local stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
  local progress = stats and stats:FindFirstChild("ActionProgress")

  while not progress and AFK_FarmStats.IsActive do
    task.wait(0.1)

    stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
    progress = stats and stats:FindFirstChild("ActionProgress")
  end

  if not AFK_FarmStats.IsActive or not progress then
    return false
  end

  local completed = false

  local progressConnection = progress:GetPropertyChangedSignal("Value"):Connect(function()
    if progress.Value >= 1 then
      completed = true
    end
  end)

  if progress.Value >= 1 then
    completed = true
  end

  AFK_FireAction()

  while AFK_FarmStats.IsActive and not completed do
    if progress.Value >= 1 then
      completed = true
      break
    end

    AFK_FarmStats.HackProgress = math.clamp(progress.Value, 0, 1)
    AFK_FarmStats.CurrentTarget = "Extra Computer"
    AFK_UpdateStatsLabel()

    ReplicatedStorage.RemoteEvent:FireServer(
      "SetPlayerMinigameResult",
      true
    )

    task.wait(AFK_Settings.MinigameSpamInterval)
  end

  progressConnection:Disconnect()

  if not AFK_FarmStats.IsActive then
    return false
  end

  if not completed then
    return false
  end

  AFK_FarmStats.HackProgress = 1
  AFK_FarmStats.ComputersHacked = AFK_FarmStats.ComputersHacked + 1
  AFK_FarmStats.Status = "Extra computer hacked!"
  AFK_FarmStats.CurrentTarget = "Exit Door"
  AFK_UpdateStatsLabel()

  task.wait(0.5)

  return true
end

local function AFK_HackComputers()
  local computersLeft = ReplicatedStorage:FindFirstChild("ComputersLeft")

  if not computersLeft then
    return
  end

  AFK_FarmStats.ComputersHacked = 0

  while AFK_FarmStats.IsActive do
    if AFK_Settings.Priority == "Player1" and AFK_Settings.SavePlayer then
      if not AFK_SaveOnePlayer() then
        if not AFK_FarmStats.IsActive then
          return
        end

        if not AFK_IsInMatch() then
          return
        end

        if AFK_IsBeast() then
          return
        end

        task.wait(0.2)
        continue
      end
    end

    local currentComputers = computersLeft.Value

    AFK_FarmStats.ComputersRemaining = currentComputers

    if currentComputers <= 0 then
      if AFK_Settings.Priority == "Player1" and AFK_Settings.HackExtraComputer and AFK_IsInMatch() and not AFK_IsBeast() then
        local extraComputer = AFK_GetExtraComputer(AFK_GetMap())
        if extraComputer then
          AFK_FarmStats.Status = "Extra computer found!"
          AFK_FarmStats.CurrentTarget = "Extra Computer"
          AFK_UpdateStatsLabel()
          local extraCompleted = AFK_HackExtraComputer(extraComputer)
          if not extraCompleted then
            return
          end
        end
      end
      break
    end

    AFK_FarmStats.Status = "Searching for computer..."
    AFK_FarmStats.HackProgress = 0
    AFK_FarmStats.CurrentTarget = "Searching..."
    AFK_UpdateStatsLabel()

    local map = AFK_GetMap()

    if not map then
      task.wait(1)
      continue
    end

    local targetTrigger
    local targetTable

    for _, computerTable in ipairs(map:GetChildren()) do
      if not AFK_FarmStats.IsActive then
        return
      end

      if computerTable:IsA("Model") and computerTable.Name == "ComputerTable" then
        local screen = computerTable:FindFirstChild("Screen")

        if screen and
          screen:IsA("BasePart") and
          screen.Color ~= Color3.fromRGB(40, 127, 71) then

          for _, trigger in ipairs(computerTable:GetChildren()) do
            if trigger:IsA("BasePart") and
              trigger.Name:lower():find("computertrigger") then

              local actionSign = trigger:FindFirstChild("ActionSign")

              if actionSign and actionSign.Value == 20 then
                targetTrigger = trigger
                targetTable = computerTable
                break
              end
            end
          end
        end
      end

      if targetTrigger then
        break
      end
    end

    if not targetTrigger then
      AFK_FarmStats.Status = "No computer available..."
      AFK_FarmStats.CurrentTarget = "None"
      AFK_UpdateStatsLabel()
      task.wait(1)
      continue
    end

    AFK_FarmStats.Status = "Hacking computer..."
    AFK_FarmStats.CurrentTarget = "Computer"
    AFK_FarmStats.HackProgress = 0
    AFK_UpdateStatsLabel()

    AFK_TeleportTo(targetTrigger.CFrame)

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(1.6)

    if not AFK_FarmStats.IsActive then
      return
    end

    local stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
    local progress = stats and stats:FindFirstChild("ActionProgress")

    while not progress and AFK_FarmStats.IsActive do
      task.wait(0.1)

      stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
      progress = stats and stats:FindFirstChild("ActionProgress")
    end

    if not AFK_FarmStats.IsActive or not progress then
      return
    end

    local completed = false

    local progressConnection =
      progress:GetPropertyChangedSignal("Value"):Connect(function()
        if progress.Value >= 1 then
          completed = true
        end
      end)

    if progress.Value >= 1 then
      completed = true
    end

    AFK_FireAction()

    while AFK_FarmStats.IsActive and not completed do
      if progress.Value >= 1 then
        completed = true
        break
      end

      AFK_FarmStats.HackProgress = math.clamp(progress.Value, 0, 1)
      AFK_FarmStats.ComputersRemaining = computersLeft.Value

      AFK_UpdateStatsLabel()

      ReplicatedStorage.RemoteEvent:FireServer(
        "SetPlayerMinigameResult",
        true
      )

      task.wait(AFK_Settings.MinigameSpamInterval)
    end

    progressConnection:Disconnect()

    if not AFK_FarmStats.IsActive then
      return
    end

    if not completed then
      return
    end

    AFK_FarmStats.HackProgress = 1
    AFK_FarmStats.ComputersHacked =
      AFK_FarmStats.ComputersHacked + 1

    AFK_UpdateStatsLabel()

    local latestComputers = computersLeft.Value

    for _ = 1, 10 do
      if latestComputers <= 0 then
        break
      end

      task.wait(0.1)
      latestComputers = computersLeft.Value
    end

    AFK_FarmStats.ComputersRemaining = latestComputers

    if latestComputers <= 0 then if AFK_Settings.Priority == "Player1" and AFK_Settings.HackExtraComputer and AFK_IsInMatch() and not AFK_IsBeast() then
        local extraComputer = AFK_GetExtraComputer(AFK_GetMap())
        if extraComputer then
          AFK_FarmStats.Status = "Extra computer found! Waiting Cooldown..."
          AFK_FarmStats.CurrentTarget = "Extra Computer"
          AFK_UpdateStatsLabel()

          task.wait(AFK_Settings.HackCooldown)

          if not AFK_FarmStats.IsActive or AFK_IsBeast() or not AFK_IsInMatch() then
            return
          end

          extraComputer = AFK_GetExtraComputer(AFK_GetMap())
          if extraComputer then
            local extraCompleted = AFK_HackExtraComputer(extraComputer)
            if not extraCompleted then
              return
            end
          end
        end
      end

      AFK_FarmStats.Status = "All computers hacked!"
      AFK_FarmStats.CurrentTarget = "Exit Door"
      AFK_UpdateStatsLabel()
      break
    end

    AFK_FarmStats.Status = "Cooldown..."
    AFK_FarmStats.CurrentTarget = "Next computer"
    AFK_UpdateStatsLabel()

    local cooldownStart = tick()

    while AFK_FarmStats.IsActive and
      tick() - cooldownStart < AFK_Settings.HackCooldown do

      local remaining = math.ceil(
        AFK_Settings.HackCooldown -
        (tick() - cooldownStart)
      )

      AFK_FarmStats.Status =
        "Computer cooldown: " .. remaining .. "s"

      AFK_FarmStats.CurrentTarget = "Next computer"
      AFK_FarmStats.ComputersRemaining = computersLeft.Value

      AFK_UpdateStatsLabel()

      task.wait(0.2)
    end

    if not AFK_FarmStats.IsActive then
      return
    end

    AFK_FarmStats.HackProgress = 0
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  AFK_FarmStats.Status = "Opening exit door..."
  AFK_FarmStats.CurrentTarget = "Exit Door"
  AFK_FarmStats.HackProgress = 0
  AFK_UpdateStatsLabel()

  local map = AFK_GetMap()

  if not map then
    return
  end

  local exitDoor = map:FindFirstChild("ExitDoor", true)

  if not exitDoor then
    AFK_FarmStats.Status = "Exit door not found"
    AFK_FarmStats.CurrentTarget = "Exit Door"
    AFK_UpdateStatsLabel()
    return
  end

  local exitTrigger = exitDoor:FindFirstChild("ExitDoorTrigger")

  if not exitTrigger or not exitTrigger:IsA("BasePart") then
    AFK_FarmStats.Status = "Exit trigger not found"
    AFK_FarmStats.CurrentTarget = "Exit Door"
    AFK_UpdateStatsLabel()
    return
  end

  AFK_FarmStats.Status = "At exit door..."
  AFK_FarmStats.CurrentTarget = "Exit Door"
  AFK_UpdateStatsLabel()

  AFK_TeleportTo(exitTrigger.CFrame)

  if not AFK_FarmStats.IsActive then
    return
  end

  task.wait(1)

  if not AFK_FarmStats.IsActive then
    return
  end

  local stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
  local progress = stats and stats:FindFirstChild("ActionProgress")

  while not progress and AFK_FarmStats.IsActive do
    task.wait(0.1)

    stats = LocalPlayer:FindFirstChild("TempPlayerStatsModule")
    progress = stats and stats:FindFirstChild("ActionProgress")
  end

  if not AFK_FarmStats.IsActive or not progress then
    return
  end

  local completed = false

  local progressConnection =
    progress:GetPropertyChangedSignal("Value"):Connect(function()
      if progress.Value >= 1 then
        completed = true
      end
    end)

  if progress.Value >= 1 then
    completed = true
  end

  AFK_FireAction()

  local startTime = tick()

  while AFK_FarmStats.IsActive and
    not completed and
    tick() - startTime < 60 do

    if progress.Value >= 1 then
      completed = true
      break
    end

    AFK_FarmStats.HackProgress =
      math.clamp(progress.Value, 0, 1)

    AFK_FarmStats.Status = "Opening exit door..."
    AFK_FarmStats.CurrentTarget = "Exit Door"

    AFK_UpdateStatsLabel()

    task.wait(0.03)
  end

  progressConnection:Disconnect()

  if not AFK_FarmStats.IsActive then
    return
  end

  if not completed then
    AFK_FarmStats.Status = "Exit door failed"
    AFK_FarmStats.CurrentTarget = "Retrying..."
    AFK_UpdateStatsLabel()
    return
  end

  AFK_FarmStats.HackProgress = 1
  AFK_FarmStats.Status = "Exit opened!"
  AFK_FarmStats.CurrentTarget = "Exit Area"
  AFK_UpdateStatsLabel()

  task.wait(4)

  if not AFK_FarmStats.IsActive then
    return
  end

  local exitArea = map:FindFirstChild("ExitArea", true)

  if not exitArea then
    AFK_FarmStats.Status = "Exit area not found"
    AFK_FarmStats.CurrentTarget = "Exit Area"
    AFK_UpdateStatsLabel()
    return
  end

  if not exitArea:IsA("BasePart") then
    AFK_FarmStats.Status = "Invalid exit area"
    AFK_FarmStats.CurrentTarget = "Exit Area"
    AFK_UpdateStatsLabel()
    return
  end

  AFK_FarmStats.Status = "Escaping..."
  AFK_FarmStats.CurrentTarget = "Exit Area"
  AFK_UpdateStatsLabel()

  AFK_TeleportTo(exitArea.CFrame)

  AFK_FarmStats.Status = "Escaped!"
  AFK_FarmStats.CurrentTarget = "Complete"
  AFK_FarmStats.HackProgress = 0
  AFK_UpdateStatsLabel()
end

local function AFK_GetFirstOutsidePlayer()
  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and not AFK_IsPlayerInLobby(player) then
      local stats = AFK_GetStats(player)
      local captured = stats and stats:FindFirstChild("Captured")

      if captured and not captured.Value then
        return player, stats, captured
      end
    end
  end

  return nil
end

local function AFK_GetNearbyPlayer()
  local beastCharacter = LocalPlayer.Character
  local beastHrp = beastCharacter and beastCharacter:FindFirstChild("HumanoidRootPart")

  if not beastHrp then
    return nil
  end

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and not AFK_IsPlayerInLobby(player) then
      local captured = AFK_GetCaptured(player)
      local ragdoll = player.Character and player.Character:FindFirstChild("Ragdoll")

      local isCaptured = captured and captured.Value
      local isRagdoll = ragdoll and ragdoll.Value

      if not isCaptured and not isRagdoll then
        local character = player.Character
        local hrp = character and character:FindFirstChild("HumanoidRootPart")

        if hrp then
          local distance = (hrp.Position - beastHrp.Position).Magnitude

          if distance <= 15 then
            return player
          end
        end
      end
    end
  end

  return nil
end

local function AFK_GetFarthestSurvivor(excludedPlayer)
  local beastCharacter = LocalPlayer.Character
  local beastHrp = beastCharacter and beastCharacter:FindFirstChild("HumanoidRootPart")

  if not beastHrp then
    return nil
  end

  local farthestPlayer = nil
  local farthestDistance = -1

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer
      and player ~= excludedPlayer
      and not AFK_IsPlayerInLobby(player) then

      local stats = AFK_GetStats(player)
      local captured = stats and stats:FindFirstChild("Captured")
      local ragdoll = stats and stats:FindFirstChild("Ragdoll")

      local character = player.Character
      local hrp = character and character:FindFirstChild("HumanoidRootPart")

      if captured
        and not captured.Value
        and ragdoll
        and not ragdoll.Value
        and hrp then

        local distance = (hrp.Position - beastHrp.Position).Magnitude

        if distance > farthestDistance then
          farthestDistance = distance
          farthestPlayer = player
        end
      end
    end
  end

  return farthestPlayer
end

local function AFK_GetFreeFreezePod(map)
  for _, model in ipairs(map:GetDescendants()) do
    if model:IsA("Model") and model.Name == "FreezePod" then
      for _, desc in ipairs(model:GetDescendants()) do
        if desc:IsA("IntValue") and
          desc.Name == "ActionSign" and
          desc.Value == 30 then

          return model
        end
      end
    end
  end

  return nil
end

local function AFK_GetHammerEvent()
  local character = LocalPlayer.Character

  if not character then
    return nil
  end

  local hammer = character:FindFirstChild("Hammer")

  if not hammer then
    return nil
  end

  local hammerEvent = hammer:FindFirstChild("HammerEvent", true)

  if hammerEvent then
    return hammerEvent
  end

  return nil
end

local function AFK_HuntSurvivors()
  while AFK_FarmStats.IsActive do
    local outsidePlayers = {}

    for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer and not AFK_IsPlayerInLobby(player) then
        local stats = AFK_GetStats(player)
        local captured = stats and stats:FindFirstChild("Captured")

        if captured and not captured.Value then
          table.insert(outsidePlayers, player)
        end
      end
    end

    AFK_FarmStats.SurvivorsRemaining = #outsidePlayers
    AFK_FarmStats.SurvivorsCaptured = 0

    for _, player in ipairs(Players:GetPlayers()) do
      if player ~= LocalPlayer then
        local stats = AFK_GetStats(player)
        local captured = stats and stats:FindFirstChild("Captured")

        if captured and captured.Value then
          AFK_FarmStats.SurvivorsCaptured =
            AFK_FarmStats.SurvivorsCaptured + 1
        end
      end
    end

    AFK_UpdateStatsLabel()

    if #outsidePlayers == 0 then
      AFK_FarmStats.Status = "All survivors captured!"
      AFK_FarmStats.CurrentTarget = "Complete"
      AFK_UpdateStatsLabel()
      task.wait(2)
      break
    end

    local targetPlayer = outsidePlayers[1]
    local targetStats = AFK_GetStats(targetPlayer)
    local capturedValue =
      targetStats and targetStats:FindFirstChild("Captured")

    if not targetStats or not capturedValue then
      task.wait(0.2)
      continue
    end

    if capturedValue.Value then
      task.wait(0.1)
      continue
    end

    local hammerEvent = AFK_GetHammerEvent()
    if not hammerEvent then
      AFK_FarmStats.Status = "Waiting for hammer..."
      AFK_FarmStats.CurrentTarget = "Hammer"
      AFK_UpdateStatsLabel()
    
      task.wait(0.25)
      continue
    end

    local targetChar = targetPlayer.Character
    local targetHrp =
      targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not targetHrp then
      task.wait(0.2)
      continue
    end

    local ragdollValue =
      targetStats:FindFirstChild("Ragdoll")

    if not ragdollValue then
      AFK_FarmStats.Status = "Ragdoll unavailable..."
      AFK_FarmStats.CurrentTarget =
        "@" .. targetPlayer.Name
      AFK_UpdateStatsLabel()
      task.wait(0.5)
      continue
    end

    AFK_FarmStats.CurrentTarget =
      "@" .. targetPlayer.Name

    AFK_FarmStats.Status = "Attacking survivor..."
    AFK_UpdateStatsLabel()

    while AFK_FarmStats.IsActive and
      not ragdollValue.Value and
      not capturedValue.Value do

      targetChar = targetPlayer.Character
      targetHrp =
        targetChar and targetChar:FindFirstChild("HumanoidRootPart")

      if not targetChar or not targetHrp then
        task.wait(0.1)
        continue
      end

      AFK_FarmStats.Status = "Attacking survivor..."
      AFK_FarmStats.CurrentTarget =
        "@" .. targetPlayer.Name

      AFK_UpdateStatsLabel()

      AFK_TeleportTo(targetHrp.CFrame)

      if not AFK_FarmStats.IsActive then
        return
      end

      task.wait(AFK_Settings.RemoteDelay)

      if not AFK_FarmStats.IsActive then
        return
      end

      targetChar = targetPlayer.Character
      targetHrp =
        targetChar and targetChar:FindFirstChild("HumanoidRootPart")

      if not targetChar or not targetHrp then
        task.wait(0.1)
        continue
      end

      local leftArm = targetChar:FindFirstChild("Left Arm")

      if leftArm then
        hammerEvent:FireServer("HammerHit", leftArm)
      end

      task.wait(0.1)
    end

    if not AFK_FarmStats.IsActive then
      return
    end

    if capturedValue.Value then
      continue
    end

    if not ragdollValue.Value then
      continue
    end

    AFK_FarmStats.Status = "Tying survivor..."
    AFK_FarmStats.CurrentTarget =
      "@" .. targetPlayer.Name

    AFK_UpdateStatsLabel()

    targetChar = targetPlayer.Character
    targetHrp =
      targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    if not targetChar or not targetHrp then
      task.wait(0.2)
      continue
    end

    AFK_TeleportTo(targetHrp.CFrame)

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(AFK_Settings.RemoteDelay)

    if not AFK_FarmStats.IsActive then
      return
    end

    targetChar = targetPlayer.Character
    targetHrp =
      targetChar and targetChar:FindFirstChild("HumanoidRootPart")

    local torso =
      targetChar and targetChar:FindFirstChild("Torso")

    if not targetChar or not targetHrp or not torso then
      task.wait(0.2)
      continue
    end

    hammerEvent:FireServer(
      "HammerTieUp",
      torso,
      targetHrp.Position
    )

    task.wait(AFK_Settings.RemoteDelay)

    if not AFK_FarmStats.IsActive then
      return
    end

    local map = AFK_GetMap()

    if not map then
      task.wait(0.5)
      continue
    end

    local pod = AFK_GetFreeFreezePod(map)

    if not pod then
      AFK_FarmStats.Status = "Searching freeze pod..."
      AFK_FarmStats.CurrentTarget = "Freeze Pod"
      AFK_UpdateStatsLabel()
      task.wait(0.5)
      continue
    end

    AFK_FarmStats.Status = "Going to freeze pod..."
    AFK_FarmStats.CurrentTarget = "Freeze Pod"
    AFK_UpdateStatsLabel()

    AFK_TeleportTo(pod:GetPivot())

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(1)

    if not AFK_FarmStats.IsActive then
      return
    end

    AFK_FireAction()

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(AFK_Settings.RemoteDelay)

    while AFK_FarmStats.IsActive do
      targetStats = AFK_GetStats(targetPlayer)
      capturedValue =
        targetStats and targetStats:FindFirstChild("Captured")

      if capturedValue and capturedValue.Value then
        break
      end

      if not pod or not pod.Parent then
        break
      end

      AFK_FarmStats.Status = "Capturing survivor..."
      AFK_FarmStats.CurrentTarget =
        "@" .. targetPlayer.Name

      AFK_UpdateStatsLabel()

      AFK_TeleportTo(pod:GetPivot())

      if not AFK_FarmStats.IsActive then
        return
      end

      task.wait(0.3)

      if not AFK_FarmStats.IsActive then
        return
      end

      targetStats = AFK_GetStats(targetPlayer)
      capturedValue =
        targetStats and targetStats:FindFirstChild("Captured")

      if capturedValue and capturedValue.Value then
        break
      end

      AFK_FireAction()

      task.wait(AFK_Settings.RemoteDelay)
    end

    if not AFK_FarmStats.IsActive then
      return
    end

    if capturedValue and capturedValue.Value then
      AFK_FarmStats.Status = "Survivor captured!"
      AFK_FarmStats.CurrentTarget = "Next survivor"
      AFK_UpdateStatsLabel()

      task.wait(AFK_Settings.BeastHuntDelay)
    end
  end
end

local function AFK_ClearEscapeConnections()
  for _, connection in ipairs(AFK_EscapeConnections) do
    if connection then
      connection:Disconnect()
    end
  end

  table.clear(AFK_EscapeConnections)
end

local function AFK_SetupEscapeDetection()
  AFK_ClearEscapeConnections()
  AFK_EscapeDetected = false

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
      local stats = AFK_GetStats(player)
      local escaped = stats and stats:FindFirstChild("Escaped")

      if escaped then
        if escaped.Value and not AFK_IsPlayerInLobby(player) then
          AFK_EscapeDetected = true
        end

        table.insert(
          AFK_EscapeConnections,
          escaped:GetPropertyChangedSignal("Value"):Connect(function()
            if escaped.Value and not AFK_IsPlayerInLobby(player) then
              AFK_EscapeDetected = true
            end
          end)
        )
      end
    end
  end
end

local function AFK_SetupMyEscapeDetection()
  if AFK_MyEscapeConnection then
    AFK_MyEscapeConnection:Disconnect()
    AFK_MyEscapeConnection = nil
  end

  AFK_MyEscapeDetected = false

  local stats = AFK_GetStats(LocalPlayer)
  local escaped = stats and stats:FindFirstChild("Escaped")

  if not escaped then
    return
  end

  if escaped.Value then
    AFK_MyEscapeDetected = true
  end

  AFK_MyEscapeConnection =
    escaped:GetPropertyChangedSignal("Value"):Connect(function()
      if escaped.Value then
        AFK_MyEscapeDetected = true
      end
    end)
end

local function AFK_GetExitAreas(map)
  local exitAreas = {}

  for _, object in ipairs(map:GetDescendants()) do
    if object:IsA("BasePart") and object.Name == "ExitArea" then
      table.insert(exitAreas, object)
    end
  end

  return exitAreas
end

local function AFK_WaitForPlayerEscape()
  AFK_SetupEscapeDetection()

  while AFK_FarmStats.IsActive and not AFK_EscapeDetected do
    AFK_FarmStats.Status = "Waiting for survivor escape..."
    AFK_FarmStats.CurrentTarget = "Waiting for survivor"
    AFK_UpdateStatsLabel()

    task.wait(0.1)
  end

  AFK_ClearEscapeConnections()

  return AFK_EscapeDetected
end

local function AFK_EscapeAsPlayer2()
  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsInMatch() then
    AFK_FarmStats.Status = "Waiting for match..."
    AFK_FarmStats.CurrentTarget = "Lobby"
    AFK_UpdateStatsLabel()
    return
  end

  if AFK_IsBeast() then
    AFK_FarmStats.Status = "Player2 Beast mode"
    AFK_FarmStats.CurrentTarget = "One capture only"
    AFK_UpdateStatsLabel()
    return
  end

  local computersLeft =
    ReplicatedStorage:FindFirstChild("ComputersLeft")

  if not computersLeft then
    AFK_FarmStats.Status = "ComputersLeft unavailable"
    AFK_FarmStats.CurrentTarget = "None"
    AFK_UpdateStatsLabel()
    return
  end

  AFK_FarmStats.Role = "Survivor"
  AFK_FarmStats.ComputersRemaining = computersLeft.Value
  AFK_FarmStats.CurrentTarget = "Waiting..."
  AFK_FarmStats.Status = "Waiting for all computers..."
  AFK_UpdateStatsLabel()

  while AFK_FarmStats.IsActive and
    AFK_IsInMatch() and
    not AFK_IsBeast() and
    computersLeft.Value > 0 do

    AFK_FarmStats.ComputersRemaining = computersLeft.Value
    AFK_FarmStats.Status = "Waiting for all computers..."
    AFK_FarmStats.CurrentTarget = "Computer farm: Player1"
    AFK_UpdateStatsLabel()

    task.wait(0.2)
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsInMatch() then
    return
  end

  if AFK_IsBeast() then
    return
  end

  AFK_FarmStats.ComputersRemaining = 0
  AFK_FarmStats.Status = "Computers complete!"
  AFK_FarmStats.CurrentTarget = "Waiting for survivor escape"
  AFK_UpdateStatsLabel()

  if not AFK_WaitForPlayerEscape() then
    return
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsInMatch() then
    return
  end

  if AFK_IsBeast() then
    return
  end

  AFK_FarmStats.Status = "Survivor escaped!"
  AFK_FarmStats.CurrentTarget = "Waiting 2 seconds"
  AFK_UpdateStatsLabel()

  task.wait(2)

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsInMatch() then
    return
  end

  if AFK_IsBeast() then
    return
  end

  AFK_SetupMyEscapeDetection()

  local map = AFK_GetMap()

  if not map then
    AFK_FarmStats.Status = "Map not found"
    AFK_FarmStats.CurrentTarget = "None"
    AFK_UpdateStatsLabel()
    return
  end

  local exitAreas = AFK_GetExitAreas(map)

  if #exitAreas == 0 then
    AFK_FarmStats.Status = "No exit area found"
    AFK_FarmStats.CurrentTarget = "None"
    AFK_UpdateStatsLabel()
    return
  end

  AFK_FarmStats.Status = "Searching exit..."
  AFK_FarmStats.CurrentTarget = "Exit Area"
  AFK_UpdateStatsLabel()

  for _, exitArea in ipairs(exitAreas) do
    if not AFK_FarmStats.IsActive then
      return
    end

    if AFK_MyEscapeDetected then
      break
    end

    if not AFK_IsInMatch() then
      break
    end

    if AFK_IsBeast() then
      break
    end

    AFK_FarmStats.Status = "Escaping..."
    AFK_FarmStats.CurrentTarget = "Exit Area"
    AFK_UpdateStatsLabel()

    AFK_TeleportTo(exitArea.CFrame)

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(1)

    if not AFK_FarmStats.IsActive then
      return
    end

    AFK_FireAction()

    if not AFK_FarmStats.IsActive then
      return
    end

    local startTime = tick()

    while AFK_FarmStats.IsActive and
      not AFK_MyEscapeDetected and
      tick() - startTime < 3 do

      task.wait(0.05)
    end

    if AFK_MyEscapeDetected then
      break
    end
  end

  if AFK_MyEscapeConnection then
    AFK_MyEscapeConnection:Disconnect()
    AFK_MyEscapeConnection = nil
  end

  if AFK_MyEscapeDetected then
    AFK_FarmStats.Status = "Escaped!"
    AFK_FarmStats.CurrentTarget = "Complete"
    AFK_FarmStats.HackProgress = 0
    AFK_UpdateStatsLabel()
  else
    AFK_FarmStats.Status = "Exit failed"
    AFK_FarmStats.CurrentTarget = "Retrying..."
    AFK_UpdateStatsLabel()
  end
end

local function AFK_GetRandomPlayerForPlayer2Beast()
  local candidates = {}

  local beastCharacter = LocalPlayer.Character
  local beastHrp =
    beastCharacter and
    beastCharacter:FindFirstChild("HumanoidRootPart")

  if not beastHrp then
    return nil
  end

  for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and not AFK_IsPlayerInLobby(player) then
      local stats = AFK_GetStats(player)

      local captured =
        stats and stats:FindFirstChild("Captured")

      local ragdoll =
        stats and stats:FindFirstChild("Ragdoll")

      local character = player.Character
      local hrp =
        character and
        character:FindFirstChild("HumanoidRootPart")

      if captured and
        not captured.Value and
        ragdoll and
        not ragdoll.Value and
        hrp then

        local distance =
          (hrp.Position - beastHrp.Position).Magnitude

        if distance >= 30 then
          table.insert(candidates, player)
        end
      end
    end
  end

  if #candidates == 0 then
    return nil
  end

  return candidates[math.random(1, #candidates)]
end

local function AFK_Player2BeastCapture()
  local map = AFK_GetMap()

  if not map then
    return
  end

  if AFK_Player2BeastDoneMap == map then
    AFK_FarmStats.Status = "Complete"
    AFK_FarmStats.CurrentTarget = "One capture completed"
    AFK_UpdateStatsLabel()
    return
  end

  local hammerEvent

  AFK_FarmStats.Status = "Waiting for hammer..."
  AFK_FarmStats.CurrentTarget = "Hammer"
  AFK_UpdateStatsLabel()

  while AFK_FarmStats.IsActive and
    AFK_Settings.Priority == "Player2" and
    AFK_IsBeast() do

    map = AFK_GetMap()

    if not map then
      return
    end

    if AFK_Player2BeastDoneMap == map then
      return
    end

    hammerEvent = AFK_GetHammerEvent()

    if hammerEvent then
      break
    end

    task.wait(0.25)
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsBeast() then
    return
  end

  if not hammerEvent then
    return
  end

  AFK_FarmStats.Status = "Waiting for player..."
  AFK_FarmStats.CurrentTarget = "Waiting nearby"
  AFK_UpdateStatsLabel()

  local triggerPlayer

  while AFK_FarmStats.IsActive and
    AFK_Settings.Priority == "Player2" and
    AFK_IsBeast() do

    map = AFK_GetMap()

    if not map then
      return
    end

    if AFK_Player2BeastDoneMap == map then
      return
    end

    triggerPlayer = AFK_GetNearbyPlayer()

    if triggerPlayer then
      break
    end

    task.wait(0.1)
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsBeast() then
    return
  end

  if not triggerPlayer then
    return
  end

  AFK_FarmStats.Status = "Player detected"
  AFK_FarmStats.CurrentTarget = "@" .. triggerPlayer.Name
  AFK_UpdateStatsLabel()

  task.wait(0.15)

  AFK_FarmStats.Status = "Searching farthest..."
  AFK_FarmStats.CurrentTarget = "Finding survivor"
  AFK_UpdateStatsLabel()

  local targetPlayer

  while AFK_FarmStats.IsActive and
    AFK_Settings.Priority == "Player2" and
    AFK_IsBeast() do

    map = AFK_GetMap()

    if not map then
      return
    end

    if AFK_Player2BeastDoneMap == map then
      return
    end

    targetPlayer = AFK_GetFarthestSurvivor(triggerPlayer)

    if targetPlayer then
      break
    end

    task.wait(0.15)
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsBeast() then
    return
  end

  if not targetPlayer then
    return
  end

  AFK_FarmStats.Status = "Capturing..."
  AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name
  AFK_UpdateStatsLabel()

  local targetStats = AFK_GetStats(targetPlayer)
  local capturedValue =
    targetStats and targetStats:FindFirstChild("Captured")

  local ragdollValue =
    targetStats and targetStats:FindFirstChild("Ragdoll")

  if not targetStats or not capturedValue or not ragdollValue then
    return
  end

  while AFK_FarmStats.IsActive and
    AFK_Settings.Priority == "Player2" and
    AFK_IsBeast() and
    not capturedValue.Value do

    if ragdollValue.Value then
      break
    end

    local targetCharacter = targetPlayer.Character
    local targetHrp =
      targetCharacter and
      targetCharacter:FindFirstChild("HumanoidRootPart")

    if not targetHrp then
      task.wait(0.1)
      continue
    end

    AFK_FarmStats.Status = "Attacking..."
    AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name
    AFK_UpdateStatsLabel()

    AFK_TeleportTo(targetHrp.CFrame)

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(AFK_Settings.RemoteDelay)

    targetCharacter = targetPlayer.Character

    if not targetCharacter then
      task.wait(0.1)
      continue
    end

    local leftArm =
      targetCharacter:FindFirstChild("Left Arm")

    if leftArm then
      hammerEvent:FireServer(
        "HammerHit",
        leftArm
      )
    end

    task.wait(0.15)

    targetStats = AFK_GetStats(targetPlayer)
    capturedValue =
      targetStats and targetStats:FindFirstChild("Captured")

    ragdollValue =
      targetStats and targetStats:FindFirstChild("Ragdoll")

    if not targetStats or not capturedValue or not ragdollValue then
      return
    end
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if not AFK_IsBeast() then
    return
  end

  if capturedValue.Value then
    AFK_Player2BeastDoneMap = map

    AFK_FarmStats.Status = "Captured!"
    AFK_FarmStats.CurrentTarget =
      "@" .. targetPlayer.Name

    AFK_FarmStats.SurvivorsCaptured =
      AFK_FarmStats.SurvivorsCaptured + 1

    AFK_UpdateStatsLabel()

    return
  end

  if not ragdollValue.Value then
    return
  end

  AFK_FarmStats.Status = "Tying survivor..."
  AFK_FarmStats.CurrentTarget =
    "@" .. targetPlayer.Name

  AFK_UpdateStatsLabel()

  local targetCharacter = targetPlayer.Character
  local targetHrp =
    targetCharacter and
    targetCharacter:FindFirstChild("HumanoidRootPart")

  local torso =
    targetCharacter and
    targetCharacter:FindFirstChild("Torso")

  if not targetCharacter or
    not targetHrp or
    not torso then

    return
  end

  AFK_TeleportTo(targetHrp.CFrame)

  if not AFK_FarmStats.IsActive then
    return
  end

  task.wait(AFK_Settings.RemoteDelay)

  hammerEvent:FireServer(
    "HammerTieUp",
    torso,
    targetHrp.Position
  )

  task.wait(0.3)

  local freezePod

  while AFK_FarmStats.IsActive and
    AFK_Settings.Priority == "Player2" and
    AFK_IsBeast() do

    map = AFK_GetMap()

    if not map then
      return
    end

    freezePod = AFK_GetFreeFreezePod(map)

    if freezePod then
      break
    end

    AFK_FarmStats.Status = "Finding freeze pod..."
    AFK_FarmStats.CurrentTarget =
      "@" .. targetPlayer.Name

    AFK_UpdateStatsLabel()

    task.wait(0.2)
  end

  if not freezePod then
    return
  end

  AFK_FarmStats.Status = "Going to freeze pod..."
  AFK_FarmStats.CurrentTarget =
    "@" .. targetPlayer.Name

  AFK_UpdateStatsLabel()

  AFK_TeleportTo(freezePod:GetPivot())

  if not AFK_FarmStats.IsActive then
    return
  end

  task.wait(1)

  if not AFK_FarmStats.IsActive then
    return
  end

  AFK_FireAction()

  task.wait(0.3)

  while AFK_FarmStats.IsActive and
    AFK_Settings.Priority == "Player2" and
    AFK_IsBeast() do

    targetStats = AFK_GetStats(targetPlayer)

    capturedValue =
      targetStats and
      targetStats:FindFirstChild("Captured")

    if capturedValue and capturedValue.Value then
      break
    end

    if not freezePod.Parent then
      return
    end

    AFK_FarmStats.Status = "Capturing survivor..."
    AFK_FarmStats.CurrentTarget =
      "@" .. targetPlayer.Name

    AFK_UpdateStatsLabel()

    AFK_TeleportTo(freezePod:GetPivot())

    if not AFK_FarmStats.IsActive then
      return
    end

    task.wait(0.3)

    AFK_FireAction()

    task.wait(AFK_Settings.RemoteDelay)
  end

  if not AFK_FarmStats.IsActive then
    return
  end

  if capturedValue and capturedValue.Value then
    AFK_Player2BeastDoneMap = map

    AFK_FarmStats.Status = "Captured!"
    AFK_FarmStats.CurrentTarget = "@" .. targetPlayer.Name

    AFK_FarmStats.SurvivorsCaptured = AFK_FarmStats.SurvivorsCaptured + 1
    AFK_UpdateStatsLabel()
  end
end
