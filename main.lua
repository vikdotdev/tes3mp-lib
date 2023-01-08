local function set_difficulty_setting(difficulty)
  WorldInstance.data.customVariables.dynamic_difficulty = tonumber(difficulty)
end

local function get_difficulty_setting()
  if WorldInstance.data.customVariables.dynamic_difficulty == nil then return end

  return tonumber(WorldInstance.data.customVariables.dynamic_difficulty)
end

local function set_difficulty(_, pid)
  tes3mp.SendMessage(pid, "Dynamic difficulty initialized.\n")

  local difficulty = get_difficulty_setting()
  if difficulty ~= nil then
    tes3mp.SendMessage(pid, "Setting difficulty to " .. difficulty .. "\n")
    tes3mp.SetDifficulty(pid, get_difficulty_setting())
  end
end

local function set_difficulty_cmd(invoker_pid, args)
  local difficulty = tonumber(args[2])

  if Players[invoker_pid].data.settings.staffRank >= 2 then
    set_difficulty_setting(difficulty)

    for pid, _ in pairs(Players) do
      if Players[pid]:IsLoggedIn() then
        tes3mp.SetDifficulty(pid, difficulty)
        tes3mp.SendSettings(pid)
        tes3mp.SendMessage(invoker_pid, "Setting difficulty to " .. difficulty .. " for player " .. pid .. "\n")
      end
    end
  else
    tes3mp.SendMessage(invoker_pid, "Permission denied.")
  end
end

customCommandHooks.registerCommand('setdifficulty', set_difficulty_cmd)
customEventHooks.registerHandler('OnPlayerEndCharGen', set_difficulty)
customEventHooks.registerHandler('OnPlayerConnect', set_difficulty)
