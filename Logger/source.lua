-- Logger.lua (module)
local Logger = {}
Logger.__index = Logger

-- Configuration (customize as needed)
local DEFAULT_PREFIX = "SYSTEM"
local TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M:%S"

local function timestamp()
    return os.date(TIMESTAMP_FORMAT)
end

local function pad_center(s, width)
    local len = #s
    if len >= width then return s end
    local total = width - len
    local left = math.floor(total/2)
    local right = total - left
    return string.rep(" ", left) .. s .. string.rep(" ", right)
end

-- Basic printer used internally (keeps output consistent)
local function raw_print(level, title, body)
    local ts = timestamp()
    local header = string.format("┌─[%s]─[%s]─[%s]", ts, level, title)
    local footer = "└" .. string.rep("─", #header - 1)
    print(header)
    for line in body:gmatch("[^\n]+") do
        print(("│ %s"):format(line))
    end
    print(footer)
end

-- Public API

-- Logger.info(title, message)
function Logger.info(title, message)
    raw_print("INFO", title or DEFAULT_PREFIX, tostring(message or ""))
end

-- Logger.warn(title, message)
function Logger.warn(title, message)
    raw_print("WARN", title or DEFAULT_PREFIX, tostring(message or ""))
end

-- Logger.error(title, message)
function Logger.error(title, message)
    raw_print("ERROR", title or DEFAULT_PREFIX, tostring(message or ""))
end

-- Logger.stage(index, name, details)
-- prints a numbered step in a stylized block
function Logger.stage(index, name, details)
    local boxedTitle = string.format("Step %d — %s", index or 0, name or "Unnamed")
    local width = math.max(40, #boxedTitle + 4)
    local top = "╔" .. string.rep("═", width) .. "╗"
    local bottom = "╚" .. string.rep("═", width) .. "╝"
    print(top)
    print("║" .. pad_center(boxedTitle, width) .. "║")
    print("╠" .. string.rep("═", width) .. "╣")
    if details and #tostring(details) > 0 then
        for line in tostring(details):gmatch("[^\n]+") do
            -- ensure line fits, wrap if needed (simple wrap)
            if #line > width - 2 then
                local i = 1
                while i <= #line do
                    local chunk = line:sub(i, i + width - 3)
                    print("║ " .. pad_center(chunk, width - 2) .. " ║")
                    i = i + width - 2
                end
            else
                print("║ " .. pad_center(line, width - 2) .. " ║")
            end
        end
    else
        print("║" .. pad_center("(no details)", width) .. "║")
    end
    print(bottom)
end

-- Convenience: print a compact banner when a module loads
function Logger.banner(title)
    local t = title or "LOGGER"
    local line = string.rep("=", #t + 8)
    print(line)
    print("==  " .. t .. "  ==")
    print(line)
end

return Logger
