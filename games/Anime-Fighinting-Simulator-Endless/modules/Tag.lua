local Players = cloneref(game:GetService("Players"));
local TextChatService = cloneref(game:GetService("TextChatService"));

local lp = Players.LocalPlayer

TextChatService.OnIncomingMessage = function(message)
    local props = Instance.new("TextChatMessageProperties")

    if not message.TextSource then
        return props
    end

    local player = Players:GetPlayerByUserId(message.TextSource.UserId)
    if not player then
        return props
    end

    if player == lp then
        props.PrefixText =
            "<font color=\"#8E44FF\">[In</font>" ..
            "<font color=\"#A970FF\">fi</font>" ..
            "<font color=\"#C084FF\">ni</font>" ..
            "<font color=\"#B794F4\">ty</font>" ..
            "<font color=\"#C4A1FF\">X]</font> " ..
            "<font color=\"#B57CFF\">" .. (player.DisplayName or player.Name) .. ":</font>"
    end

    return props
end
