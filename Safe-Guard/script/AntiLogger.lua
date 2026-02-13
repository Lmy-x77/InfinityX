local RanTimes = 0
local RunService = cloneref(game:GetService("RunService"));

local Connection = RunService.Heartbeat:Connect(function()
    RanTimes += 1
end)

repeat
    task.wait()
until RanTimes >= 2

Connection:Disconnect()

if not game.ServiceAdded then
    error("nerd")
    assert(nil, "nerd")
    return
end
if getfenv()[(" "):rep(15000)] then
    error("nerd")
    assert(nil, "nerd")
    return
end
if getmetatable(__call) then
    error("nerd")
    assert(nil, "nerd")
    return
end

local ticks = 0
local hb; hb = RunService.Heartbeat:Connect(function()
    ticks += 1
    if ticks >= 2 then
        hb:Disconnect()

        if not game.ServiceAdded
        or rawget(getfenv(), (" "):rep(15000))
        or getmetatable(__call) then
            error("nerd")
        end
    end
end)
