local function safeHook(fn, replacement)
  if hooked[fn] then return end
  hooked[fn] = true
  hookfunction(fn, replacement or function(...) return nil end)
end

local function scanGC(callback, includeTables)
  for _, v in ipairs(getgc(includeTables)) do
    if type(v) == "function" then
      callback(v)
    end
  end
end

local function hookByConstant(target)
  target = target:lower()
  scanGC(function(fn)
    local ok, consts = pcall(debug.getconstants, fn)
    if not ok or not consts then return end

    for _, c in ipairs(consts) do
      if type(c) == "string" and c:lower():find(target) then
        safeHook(fn)
        break
      end
    end
  end)
end

hookByConstant("you have been kicked")
