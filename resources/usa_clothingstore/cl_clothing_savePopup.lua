local vein = exports.vein -- Store it in local variable for performance reasons

local windowX, windowY
local isWindowOpened = false

RegisterNetEvent("clothing:openSavePopup")
AddEventHandler("clothing:openSavePopup", function()
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
                    local character = {
                        ["hash"] = "",
                        ["components"] = {},
                        ["componentstexture"] = {},
                        ["props"] = {},
                        ["propstexture"] = {}
                    }
                    local ply = GetPlayerPed(-1)
                    character.hash = GetEntityModel(ply)
                    for i=0,7 do
                        character.props[i] = GetPedPropIndex(ply, i)
                        character.propstexture[i] = GetPedPropTextureIndex(ply, i)
                    end
                    for i=0,11 do
                        character.components[i] = GetPedDrawableVariation(ply, i)
                        character.componentstexture[i] = GetPedTextureVariation(ply, i)
                    end
                    TriggerServerEvent("mini:save", character)
                    TriggerServerEvent("mini:giveMeMyWeaponsPlease")
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