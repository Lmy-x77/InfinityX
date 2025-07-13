-- detect service
local UserInputService = game:GetService("UserInputService")
if UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and not UserInputService.MouseEnabled then
	print("Mobile device")
elseif not UserInputService.TouchEnabled and UserInputService.KeyboardEnabled and UserInputService.MouseEnabled then
	print("Computer device")
end



-- start
print[[                                                                     
 /$$$$$$            /$$$$$$  /$$           /$$   /$$               /$$   /$$
|_  $$_/           /$$__  $$|__/          |__/  | $$              | $$  / $$
  | $$   /$$$$$$$ | $$  \__/ /$$ /$$$$$$$  /$$ /$$$$$$   /$$   /$$|  $$/ $$/
  | $$  | $$__  $$| $$$$    | $$| $$__  $$| $$|_  $$_/  | $$  | $$ \  $$$$/ 
  | $$  | $$  \ $$| $$_/    | $$| $$  \ $$| $$  | $$    | $$  | $$  >$$  $$ 
  | $$  | $$  | $$| $$      | $$| $$  | $$| $$  | $$ /$$| $$  | $$ /$$/\  $$
 /$$$$$$| $$  | $$| $$      | $$| $$  | $$| $$  |  $$$$/|  $$$$$$$| $$  \ $$
|______/|__/  |__/|__/      |__/|__/  |__/|__/   \___/   \____  $$|__/  |__/
                                                         /$$  | $$          
                                                        |  $$$$$$/          
                                                         \______/           
]]



-- source
local lscript = game:GetService("Players").LocalPlayer.Backpack:WaitForChild("ClientMain")
lscript.Disabled = true
wait(.5)

local WindUIStart  = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

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

local placeIds = {
    Main = 6284881984,
    Arena = 6314042276
}

if game.PlaceId == placeIds.Main then
  WindUIStart:Popup({
    Title = gradient("InfinityX", Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204)),
    Icon = "info",
    Content = "The place detected is looby.\nPlease run this script in the Arena",
    Buttons = {
        {
            Title = "Close",
            Callback = function() end,
            Variant = "Tertiary",
        },
    }
  })
elseif game.PlaceId == placeIds.Arena then
  if not hookmetamethod and hookfunction and getsenv and newcclosure and getnamecallmethod and getrawmetatable then
    WindUIStart:Popup({
      Title = gradient("InfinityX", Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204)),
      Icon = "info",
      Content = "Your exploit is not supported",
      Buttons = {
          {
              Title = "Cancel",
              Callback = function() end,
              Variant = "Tertiary",
          },
          {
              Title = "View supported exploits",
              Icon = "arrow-right",
              Callback = function()
                WindUIStart:Popup({
                  Title = gradient("InfinityX", Color3.fromRGB(129, 63, 214), Color3.fromRGB(63, 61, 204)),
                  Icon = "info",
                  Content = "Supported Exploits\n - Pc: Swift, Velocity, Visual, Wave, Awp.gg\n - Mobile: Krnl, Codex, ArceusX, Fluxus\n\nThis Exploit i tested and working.\nIf you have any question please\njoin our discord server",
                  Buttons = {
                      {
                          Title = "Close",
                          Callback = function() end,
                          Variant = "Tertiary",
                      },
                      {
                        Title = "Copy discord link",
                        Callback = function()
                          setclipboard("https://discord.gg/emKJgWMHAr")
                        end,
                        Variant = "Secondary",
                    },
                  }
                })
              end,
              Variant = "Primary",
          }
      }
    })
  else
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Lmy-77/InfinityX/refs/heads/scripts/games/AnimeMania/Main/source.lua", true))()
  end
end



warn('[InfinityX] - Loaded!')
wait(2)
lscript.Disabled = false
