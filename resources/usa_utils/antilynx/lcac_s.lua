RegisterServerEvent('LCAC:ViolationDetected')
AddEventHandler('LCAC:ViolationDetected', function(reason, ban, ban2)
    local _source = source
    DropPlayer(_source, reason)
end)