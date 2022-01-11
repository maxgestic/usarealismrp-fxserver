local vein = exports.vein -- Store it in local variable for performance reasons

local windowX, windowY

local CLAIM_BUTTON_TIMEOUT_SECONDS = 3

local claimButtonLastLick = 0

function drawDeliveriesMenu(deliveredParts)
    vein:beginWindow(windowX, windowY) -- Mandatory

    vein:beginRow()
        drawLabel('- Delivered parts -')
    vein:endRow()

    vein:beginRow()
        local itemsPerRow = 3
        local numRows = math.ceil(#deliveredParts / itemsPerRow)

        for i = 1, numRows do
            vein:beginRow()
                for j = 1, itemsPerRow do
                    local curPartIndex = ((i-1) * itemsPerRow) + j
                    if deliveredParts[curPartIndex] then
                        drawLabel(deliveredParts[curPartIndex].name)
                    end
                end
            vein:endRow()
        end
        if #deliveredParts == 0 then
            drawLabel("None")
        end
    vein:endRow()

    vein:spacing(1)

    vein:beginRow()
        if vein:button('Back') then
            table.remove(navigationHistory)
            currentPage = (table.remove(navigationHistory) or "purchase")
        end
        if vein:button('Orders') then
            currentPage = "orders"
            table.insert(navigationHistory, currentPage)
        end
        if vein:button('Claim Deliveries') and GetGameTimer() > claimButtonLastLick + (CLAIM_BUTTON_TIMEOUT_SECONDS * 1000) then
            TriggerServerEvent("mechanic:claimDeliveries")
            claimButtonLastLick = GetGameTimer()
        end
        if vein:button('Close') then -- Draw button and check if it were pressed
            isMechanicPartMenuOpen = false
        end
    vein:endRow()

    windowX, windowY = vein:endWindow() -- Mandatory
end