safeloadstring = setmetatable({}, {
  __call = function(self, url)
  	assert(type(url) == "string", "Invalid URL")

  	local ok, response = pcall(function()
  	  return request({
  	    Url = url,
  	    Method = "GET"
  	  })
  	end)

  	if not ok or not response or response.StatusCode ~= 200 then
  	  return warn("Failed to fetch:", url)
  	end

  	local func, err = loadstring(response.Body)
  	if not func then
  	  return warn("Loadstring Error:", err)
  	end

  	setfenv(func, getgenv())

  	local success, result = pcall(func)
  	if not success then
  	  warn("Runtime Error:", result)
  	end

    return result
  end
})


safeloadstring("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Fighting-Simulator/modules/memory.lua");
safeloadstring("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/scripts/games/Anime-Fighting-Simulator/modules/safemode.lua");
safeloadstring("https://raw.githubusercontent.com/Lmy-x77/InfinityX/refs/heads/library/Safe-Guard/script/NilInstances.lua");
