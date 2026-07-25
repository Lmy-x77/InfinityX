saferequire = setmetatable({}, {
    __call = function(self, module)
        assert(typeof(module) == "Instance" and module:IsA("ModuleScript"), "Invalid ModuleScript")

        local ok, result = pcall(require, module)

        if not ok then
            warn("Require Error:", result)
            return
        end

        return result
    end
})

return saferequire(
	game:GetService("ReplicatedStorage").Generated._ClientEvents
)
