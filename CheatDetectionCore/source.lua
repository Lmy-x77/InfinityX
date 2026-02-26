function missing(expectedType, func, fallback)
	if type(func) == expectedType then
		return func
	end
	return fallback
end

hookfunction = missing("function", hookfunction)
hookmetamethod = missing("function", hookmetamethod)
getnamecallmethod = missing("function", getnamecallmethod or get_namecall_method)
checkcaller = missing("function", checkcaller, function() return false end)
newcclosure = missing("function", newcclosure)
getgc = missing("function", getgc or get_gc_objects)
setthreadidentity = missing("function", setthreadidentity or (syn and syn.set_thread_identity) or syn_context_set or setthreadcontext)
replicatesignal = missing("function", replicatesignal)
getconnections = missing("function", getconnections or get_signal_cons)

Services = setmetatable({}, {
  __index = function(self, name)
    local success, cache = pcall(function()
      return cloneref(game:GetService(name))
    end)
    if success then
      rawset(self, name, cache)
      return cache
    else
      error("Invalid Service: " .. tostring(name))
    end
  end
})

local Workspace = Services.Workspace
local Players = Services.Players
local ReplicatedStorage = Services.ReplicatedStorage
local ReplicatedFirst = Services.ReplicatedFirst

local hooked = setmetatable({}, { __mode = "k" })

local function safeHook(fn, replacement)
    if hooked[fn] then return end
    hooked[fn] = true
    hookfunction(fn, replacement or function(...) return nil end)
end

local CheatDetectionCore = {}
CheatDetectionCore.__index = CheatDetectionCore

function CheatDetectionCore:RemoteTracker(options)
    local BlackList = options.BlackList
    local Type = options.Type
    local SuspectsCharacters = options.SuspectsCharacters

    for _,v in pairs(game:GetDescendants()) do
        if (Type == "All" and (v:IsA("RemoteEvent") or v:IsA("RemoteFunction")))
        or (Type == "RemoteEvent" and v:IsA("RemoteEvent"))
        or (Type == "RemoteFunction" and v:IsA("RemoteFunction")) then

            local name = v.Name:lower()

            for _,word in pairs(BlackList) do
                if name:find(word, 1, true) then
                    print("BlackList found:", v.Name)
                end
            end

            for _,char in pairs(SuspectsCharacters) do
                if name:find(char, 1, true) then
                    print("Suspect character found:", v.Name)
                end
            end
        end
    end
end

function CheatDetectionCore:HookRemote(options)
    local Remote = options.Path
    local RemoteType = options.Type
    local CustomArgs = options.Args

    local old; old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()

        if self == Remote then
            if (RemoteType == "RemoteFunction" and method == "InvokeServer")
            or (RemoteType == "RemoteEvent" and method == "FireServer") then
                
                if CustomArgs then
                    if CustomArgs.enabled == false then
                        return nil
                    end

                    if CustomArgs.enabled == true and CustomArgs.List then
                        return nil
                    end
                end
            end
        end

        return old(self, ...)
    end)
end

function CheatDetectionCore:ScriptTracker(options)
    local BlackList = options.BlackList
    local Type = options.Type
    local SuspectsCharacters = options.SuspectsCharacters

    for _,v in pairs(game:GetDescendants()) do
        if (Type == "All" and (v:IsA("LocalScript") or v:IsA("ModuleScript")))
        or (Type == "LocalScript" and v:IsA("LocalScript"))
        or (Type == "ModuleScript" and v:IsA("ModuleScript")) then

            local name = v.Name:lower()

            if BlackList then
                for _,word in pairs(BlackList) do
                    if name:find(word, 1, true) then
                        print("BlackList found in script:", v:GetFullName())
                    end
                end
            end

            if SuspectsCharacters then
                for _,char in pairs(SuspectsCharacters) do
                    if name:find(char, 1, true) then
                        print("Suspect character in script:", v:GetFullName())
                    end
                end
            end
        end
    end
end

function CheatDetectionCore:InterceptFunction(options)
    local ScriptPath = options.Path
    local Type = options.Type
    local FunctionName = options.Name
    local Replacement = options.Replacement

    local env

    if Type == "LocalScript" then
        env = getsenv(ScriptPath)
    elseif Type == "ModuleScript" then
        env = require(ScriptPath)
    else
        return
    end

    if not env then return end

    local target = env[FunctionName]
    if typeof(target) == "function" then
        safeHook(target, Replacement)
    end
end

return CheatDetectionCore
