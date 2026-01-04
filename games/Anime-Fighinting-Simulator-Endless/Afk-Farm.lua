-- variables



local Time = ""
function startTimer()
    local start = os.clock()
    game:GetService("RunService").RenderStepped:Connect(function()
      Time = tostring(math.floor(os.clock() - start)) .. " seconds"
    end)
end
local lastChikara = nil
local totalObtained = 0
local FarmStats
function GetObtainedChikaras()
    local player = game:GetService("Players").LocalPlayer
    local current = player.OtherData.Chikara.Value
    if not lastChikara then
        lastChikara = current
        return "0"
    end
    local gained = current - lastChikara
    if gained > 0 then
        totalObtained += gained
    end
    lastChikara = current
    return tostring(totalObtained)
end
function StartAfkFarm()
    local find = workspace:FindFirstChild('InfinityX')
    function Teleport(path : Instance, method : number, x,y,z)
        for _, v in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
            if v:IsA('Part') and v.Name == 'HumanoidRootPart' then
                if method == 1 then
                    v:PivotTo(path:GetPivot())
                elseif method == 2 then
                    v.CFrame = CFrame.new(x,y,z)
                end
            end
        end
    end
    if not find then
        local partFolder = Instance.new("Folder", workspace)
        partFolder.Name = 'InfinityX'

        local part1 = Instance.new('Part', partFolder)
        part1.Name = 'Part1'
        part1.Anchored = true
        part1.Position = Vector3.new(-12, 182, 4)
        part1.Size = Vector3.new(10, 1, 10)
        part1.Transparency = 1
        Teleport(nil, 2, -12, 184, 4)
        FarmStats:Update('Collecting all chikaras in lobby')
        wait(120)

        local part2 = Instance.new('Part', partFolder)
        part2.Name = 'Part2'
        part2.Anchored = true
        part2.Position = Vector3.new(1451, 362, -212)
        part2.Size = Vector3.new(10, 1, 10)
        part2.Transparency = 1
        Teleport(nil, 2, 1451, 364, -212)
        FarmStats:Update('Collecting all chikaras in city')
        wait(120)

        local part3 = Instance.new('Part', partFolder)
        part3.Name = 'Part3'
        part3.Anchored = true
        part3.Position = Vector3.new(-909, 229, -1266)
        part3.Size = Vector3.new(10, 1, 10)
        part3.Transparency = 1
        Teleport(nil, 2, -909, 231, -1266)
        FarmStats:Update('Collecting all chikaras in volcano')
        wait(120)

        local part4 = Instance.new('Part', partFolder)
        part4.Name = 'Part4'
        part4.Anchored = true
        part4.Position = Vector3.new(-1056, 238, 453)
        part4.Size = Vector3.new(10, 1, 10)
        part4.Transparency = 1
        Teleport(nil, 2, -1056, 240, 453)
        FarmStats:Update('Collecting all chikaras in snow island')
        wait(120)

        local part5 = Instance.new('Part', partFolder)
        part5.Name = 'Part5'
        part5.Anchored = true
        part5.Position = Vector3.new(35, 210, 1919)
        part5.Size = Vector3.new(10, 1, 10)
        part5.Transparency = 1
        Teleport(nil, 2, 35, 212, 1919)
        FarmStats:Update('Collecting all chikaras in snow island 2')
        wait(120)

        local part6 = Instance.new('Part', partFolder)
        part6.Name = 'Part6'
        part6.Anchored = true
        part6.Position = Vector3.new(35, 210, 1919)
        part6.Size = Vector3.new(10, 1, 10)
        part6.Transparency = 1
        Teleport(nil, 2, 35, 212, 1919)
        FarmStats:Update('Collecting all chikaras in snow island 3')
        wait(160)
    end
end


-- ui library
local Info = loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Info/source.lua", true))()
local UI = Info:CreateWindow("InfinityX - Afk Farm")


-- source
UI:AddLabel("Server Stats", "center")
UI:AddInfo("JobId", game.JobId, Color3.fromRGB(0, 255, 170))
local timeInfo = UI:AddInfo("Time", '0 seconds', Color3.fromRGB(0, 255, 170), { align = "left", divider = true })
UI:AddLabel("Chikara Stats", "center")
local CurrentChikara = UI:AddInfo("Your Chikaras: ", game:GetService("Players").LocalPlayer.OtherData.Chikara.Value)
local ObtainedChikara = UI:AddInfo("Obtained Chikaras: ", 'nil')
FarmStats = UI:AddInfo("Stats", 'Collecting chikaras...')
UI:AddButton("Close Ui", Color3.fromRGB(0, 255, 170), function()
    UI:Destroy()
end)



startTimer()
task.spawn(function()
    while true do task.wait()
        for _, v in pairs(workspace.Scriptable.ChikaraBoxes:GetDescendants()) do
            if v:IsA('ClickDetector') then
                fireclickdetector(v)
                wait(2)
            end
        end
    end
end)
task.spawn(function()
  while true do task.wait(1)
    timeInfo:Update(Time)
    CurrentChikara:Update(game:GetService("Players").LocalPlayer.OtherData.Chikara.Value)
    ObtainedChikara:Update(GetObtainedChikaras())
  end
end)
task.spawn(function()
    while true do task.wait() StartAfkFarm() end
end)
