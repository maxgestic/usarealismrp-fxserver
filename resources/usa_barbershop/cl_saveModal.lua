local vein = exports.vein -- Store it in local variable for performance reasons

local windowX, windowY
local isWindowOpened = false

RegisterNetEvent("barber:openSaveConfirmationModal")
AddEventHandler("barber:openSaveConfirmationModal", function()
    isWindowOpened = true
end)

local function drawLabel(text)
	vein:setNextWidgetWidth(labelWidth)
	vein:label(text)
end

Citizen.CreateThread(function()
    while true do
        if isWindowOpened then

            vein:beginWindow(windowX, windowY) -- Mandatory

            vein:beginRow()
                drawLabel('Save changes?')
            vein:endRow()

            vein:beginRow()
                if vein:button('YES') then -- Draw button and check if it were pressed
                    local business = exports["usa-businesses"]:GetClosestStore(15)
                    TriggerServerEvent("barber:checkout", old_head, business)
                    isWindowOpened = false
                end

                if vein:button('NO') then -- Draw button and check if it were pressed
                    isWindowOpened = false
                end
            vein:endRow()

            windowX, windowY = vein:endWindow() -- Mandatory
        end
        Wait(0)
    end
end)