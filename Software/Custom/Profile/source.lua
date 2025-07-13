local enabled = false
if enabled then
    function gradient(text, startColor, endColor)
      local result = ""
      local length = #text

      for i = 1, length do
          local t = (i - 1) / math.max(length - 1, 1)
          local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
          local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
          local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

          local char = text:sub(i, i)
          result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
      end

      return result
    end
    local playerList = game:GetService("CoreGui"):FindFirstChild('PlayerList')
    if PlayerList then
        local getPlayersList = playerList.Children.OffsetFrame.PlayerScrollList.SizeOffsetFrame.ScrollingFrameContainer.ScrollingFrameClippingFrame.ScollingFrame.OffsetUndoFrame
        for _, v in pairs(getPlayersList:GetChildren()) do
            if v:IsA('Frame') and v.Name == tostring('p_' .. game.Players.LocalPlayer.UserId) then
                for _, x in pairs(v:GetDescendants()) do
                    if x:IsA('ImageLabel') and x.Name == 'PlayerIcon' then
                        x.Image = 'rbxassetid://126527122577864'
                        x.Parent.PlayerName.PlayerName.RichText = true
                        x.Parent.PlayerName.PlayerName.Text = gradient(game.Players.LocalPlayer.Name, Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204))
                    end
                end
            end
        end
    elseif not playerList then
        warn('PlayerList dont found')
    end
else
    warn('Custom player list disabled')
end
