local Icon = require(ReplicatedStorage.shared.Modules.client.NewIcon)

local gradientText =
	"<font color='#6A5ACD'><b>I</b></font>" ..
	"<font color='#6F5FD6'><b>n</b></font>" ..
	"<font color='#7464DF'><b>f</b></font>" ..
	"<font color='#7969E8'><b>i</b></font>" ..
	"<font color='#7E6EF1'><b>n</b></font>" ..
	"<font color='#8373FA'><b>i</b></font>" ..
	"<font color='#8878FF'><b>t</b></font>" ..
	"<font color='#8D7DFF'><b>y</b></font>" ..
	"<font color='#9272E6'><b>X</b></font>" ..
	"<font color='#7A6FE0'><b> | v4.2a</b></font>"

local main = Icon.new():setLabel(gradientText):setImage(90772127577731)

local by = Icon.new():setLabel("<font color='#7B68EE'><b>👑 by</b></font> " .."<font color='#A78BFA'><b>lmy77</b></font>")
by.selected:Connect(function()
	print("InfinityX by lmy77")
end)

local discord = Icon.new():setLabel("<font color='#3B82F6'><b> 💬 Discord</b></font> " .."<font color='#1D4ED8'><b>Server </b></font>")
discord.selected:Connect(function()
	setclipboard("discord.gg/emKJgWMHAr")
end)

main:setDropdown({ by, discord })
