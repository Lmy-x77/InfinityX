local FpsBooster = {}
FpsBooster.__index = FpsBooster

function FpsBooster:Apply()
    for i, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Texture") then
            v:Destroy()
        end
    end
end

return FpsBooster
