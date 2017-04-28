log_level = settings.global["ltn-interface-log-level"].value
log_output = settings.global["ltn-interface-log-output"].value
message_filter_age = settings.global["ltn-interface-message-filter-age"].value
min_delivery_size = settings.global["ltn-dispatcher-min-delivery-size"].value
stop_timeout = settings.global["ltn-dispatcher-stop-timeout"].value
delivery_timeout = settings.global["ltn-dispatcher-delivery-timeout"].value
finish_loading = settings.global["ltn-dispatcher-finish-loading"].value
use_Best_Effort = settings.global["ltn-dispatcher-use-best-effort"].value

script.on_event(defines.events.on_runtime_mod_setting_changed, function(event)
  if not event then return end
  --for playerID, player in pairs(game.players) do
  log("(on_runtime_mod_setting_changed) setting = "..tostring(event.setting))
  if event.setting == "ltn-interface-log-level" then log_level = settings.global["ltn-interface-log-level"].value end
  if event.setting == "ltn-interface-log-output" then log_output = settings.global["ltn-interface-log-output"].value end
  if event.setting == "ltn-interface-message-filter-age" then message_filter_age = settings.global["ltn-interface-message-filter-age"].value end
  if event.setting == "ltn-dispatcher-min-delivery-size" then min_delivery_size = settings.global["ltn-dispatcher-min-delivery-size"].value end
  if event.setting == "ltn-dispatcher-stop-timeout" then  stop_timeout = settings.global["ltn-dispatcher-stop-timeout"].value end
  if event.setting == "ltn-dispatcher-delivery-timeout" then delivery_timeout = settings.global["ltn-dispatcher-delivery-timeout"].value end
  if event.setting == "ltn-dispatcher-finish-loading" then finish_loading = settings.global["ltn-dispatcher-finish-loading"].value end
  if event.setting == "ltn-dispatcher-use-best-effort" then use_Best_Effort = settings.global["ltn-dispatcher-use-best-effort"].value end
  --end
end)

function printmsg(msg, useFilter)
  local msgKey = ""
  if type(msg) == "table" then
    for k, v in pairs(msg) do
      if type(v) == "table" then
        msgKey = msgKey..v[1]..", "
      elseif type(v) == "string" then
        msgKey = msgKey..v..", "
      end
    end
  else
    msgKey = msg
  end

  local tick = game.tick

  -- print message
  if global.messageBuffer[msgKey] == nil or not useFilter then
    if log_output == "console" or log_output == "both" then
      game.print(msg)
    end
    if log_output == "log" or log_output == "both" then
      log("[LTN] " .. msgKey)
    end
  end

  -- store message in buffer
  global.messageBuffer[msgKey] = global.messageBuffer[msgKey] or {tick=tick}
end

return printmsg