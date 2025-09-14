local ByteNet = game:GetService("ReplicatedStorage").ByteNet
local Packets = require(game:GetService("ReplicatedStorage").ByteNet.packets.packet)

local packetIDs = require(ByteNet.namespaces.packetIDs)
local bufferWriter = require(ByteNet.process.bufferWriter)

local ref = packetIDs.ref()
local old = bufferWriter.export

function getPacketName(packet)
    for i,v in pairs(Packets) do
        if v == packet then
            return i
        end
    end
end

function stringify(v, spaces, usesemicolon, depth)
    if type(v) ~= 'table' then
        if typeof(v) == "string" then
            return `"{tostring(v)}"`
        end
        if typeof(v) == "CFrame" or typeof(v) == "Vector2" or typeof(v) == "Vector3" then
            return `{typeof(v)}.new({tostring(v)})`
        end
        return tostring(v)
    elseif not next(v) then
        return '{}'
    end
    spaces = spaces or 4
    depth = depth or 1
    local space = (" "):rep(depth * spaces)
    local sep = usesemicolon and ";" or ","
    local concatenationBuilder = {"{"}
    for k, x in next, v do
        table.insert(concatenationBuilder, ("\n%s[%s] = %s%s"):format(space,type(k)=='number'and tostring(k)or('"%s"'):format(tostring(k)), stringify(x, spaces, usesemicolon, depth+1), sep))
    end
    local s = table.concat(concatenationBuilder)
    return ("%s\n%s}"):format(s:sub(1,-2), space:sub(1, -spaces-1))
end

bufferWriter.export = function()
    local Results = old()
    local len = buffer.len(Results.buff)
    local Count = 0
    while Count < len do
        local packet = ref[buffer.readu8(Results.buff, Count)]
        Count = Count + 1
        if (packet and packet.reader ~= nil) then
            local data,length = packet.reader(Results.buff, Count)
            if data then
                Count = Count + length
                print(`Packet Name: {getPacketName(packet)}`)
                print(`Packet Data: \n{string.rep(" ",12)}{stringify(data,4,false,4)}`)
            end
        end
    end
    return Results
end
