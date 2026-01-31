local RanTimes = 0
local Connection = game:GetService("RunService").Heartbeat:Connect(function()
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
