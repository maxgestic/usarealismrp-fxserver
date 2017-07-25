local playerInventory = nil
local showInventory = false
local canRefresh = true
local key = 167 -- n9 = 118, F6 = 167

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustPressed(1, key) then
            showInventory = not showInventory
            if showInventory then
                if canRefresh then
                    TriggerServerEvent("inventory:refreshInventory")
                    canRefresh = false
                    Citizen.CreateThread(function()
                        Wait(3000)
                        canRefresh = true
                    end)
                end
                while playerInventory == nil do
                    Wait(0) -- wait for playerInventory to load
                end
                -- player inventory has loaded at this point
                while showInventory do
                    Wait(0)
                    DrawRect(0.5,0.4,0.2,0.4,54,100,139,255)
                    if #playerInventory ~= 0 then
                        for i = 1, #playerInventory do
                            local item = playerInventory[i]
                            local itemName, itemQuantity = item.name, item.quantity
                            local r,g,b
                            if item.legality then
                                if item.legality == "illegal" then
                                    r,g,b = 255,0,0
                                else
                                    r,g,b = 255,255,255
                                end
                            else
                                r,g,b = 255,255,255 -- fall back if no legality property
                            end
                            drawAdvText(0.510,0.31 + ((i  - 1)*0.037),0.185,0.206, 0.40,"(x" .. itemQuantity .. ") " ..  itemName,r,g,b,255,4)
                            -- y += 0.037 for each row/item
                        end
                    else
                        drawAdvText(0.510,0.31,0.185,0.206, 0.40,"You have nothing in your inventory.",255,255,255,255,4)
                    end
                    if IsControlJustPressed(1, key) then
                        showInventory = not showInventory
                    end
                end
            end
        end
    end
end)

RegisterNetEvent("inventory:updatePlayerInventory")
AddEventHandler("inventory:updatePlayerInventory", function(data)
    playerInventory = data
end)

function drawAdvText(x,y ,width,height,scale, text, r,g,b,a, font)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end
