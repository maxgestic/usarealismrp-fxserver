RegisterServerCallback {
    eventName = "HRSGears:isManual",
    eventCallback = function(source, plate)
        local isManual = exports["usa_mechanicjob"]:doesVehicleHaveUpgrades(plate, {"manual-conversion-kit"})
        return isManual
    end
}