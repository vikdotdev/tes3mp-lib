local function is_player_authorized(pid)
  return Players[pid].data.settings.staffRank >= 2
end

local function implant_thought(pid, args)
  local target_pid = args[2]
  local message = table.concat(args, " ", 3)

  if is_player_authorized(pid) then
    tes3mp.MessageBox(target_pid, -1, tostring(message))
  else
    tes3mp.SendMessage(pid, "Permission denied.")
  end
end

customCommandHooks.registerCommand('implant', implant_thought)
