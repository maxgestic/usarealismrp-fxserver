local LOG_ENTITY_CREATION = false
local LOG_EXPLOSIONS = true

-- log explosions for now --
AddEventHandler('explosionEvent', function(sender, ev)
    if LOG_EXPLOSIONS then
        print("explosion detected!")
        print(exports.globals:dump(ev))
        --CancelEvent()
    end
end)

-- log entity creations on toggle for now --
AddEventHandler('entityCreating', function(entity)
    if LOG_ENTITY_CREATION then
        local src = NetworkGetEntityOwner(entity)
        print("[anticheese] entity " .. entity .. " was created by src: " .. src)
    end
end)


AddEventHandler('rconCommand', function(cmd, args)
    if cmd == 'logentities' then
        LOG_ENTITY_CREATION = not LOG_ENTITY_CREATION
        print("Logging Entities: " .. tostring(LOG_ENTITY_CREATION))
    elseif cmd == 'logexplosions' then 
        LOG_EXPLOSIONS = not LOG_EXPLOSIONS
        print("Logging Entities: " .. tostring(LOG_EXPLOSIONS))
    end
end)