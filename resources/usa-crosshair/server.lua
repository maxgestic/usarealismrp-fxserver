RegisterServerCallback {
    eventName = "inferno-weapons:fetchCrosshairSetting",
    eventCallback = function(source)
        local waiting = true
        local enabled = false
        TriggerEvent('es:exposeDBFunctions', function(db)
            db.getDocumentById("crosshair-settings", GetPlayerIdentifiers(source)[1], function(doc)
                if doc then
                    enabled = doc.enabled
                end
                waiting = false
            end)
        end)
        while waiting do
            Wait(1)
        end
        return enabled
    end
}

TriggerEvent('es:addCommand', 'crosshair', function(src, args, char)
    local id = GetPlayerIdentifiers(src)[1]
    TriggerEvent('es:exposeDBFunctions', function(db)
        db.getDocumentById("crosshair-settings", id, function(doc)
            if doc then
                doc.enabled = not doc.enabled
                db.updateDocument("crosshair-settings", id, {enabled = doc.enabled}, function() end)
                TriggerClientEvent("inferno-weapons:toggleCrosshair", src, doc.enabled)
            else
                db.createDocumentWithId("crosshair-settings", {enabled = true}, id, function() end)
                TriggerClientEvent("inferno-weapons:toggleCrosshair", src, true)
            end
        end)
    end)
end, {
	help = "Enable or disable crosshair"
})

exports["globals"]:PerformDBCheck("inferno-weapons", "crosshair-settings", nil)