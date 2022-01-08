local vein = exports.vein -- Store it in local variable for performance reasons

local windowX, windowY
isMechanicPartMenuOpen = false
local parts = nil
local currentRank = nil
local orderedParts = nil
local currentServerTime = nil
local deliveredParts = nil

local DATA_FETCH_INTERVAL_SECONDS = 5
local CLAIM_BUTTON_TIMEOUT_SECONDS = 3

local claimButtonLastLick = 0

RegisterNetEvent("mechanic:openMechanicShopMenuCL")
AddEventHandler("mechanic:openMechanicShopMenuCL", function(loadedRank, loadedParts, loadedOrderedParts, loadedDeliveredParts, loadedCurrentServerTime)
    parts = loadedParts
    currentRank = loadedRank
    isMechanicPartMenuOpen = true
    orderedParts = loadedOrderedParts
    currentServerTime = loadedCurrentServerTime
    deliveredParts = loadedDeliveredParts
end)

RegisterNetEvent("mechanic:setOrderedParts")
AddEventHandler("mechanic:setOrderedParts", function(loadedOrders)
    orderedParts = loadedOrders
end)

RegisterNetEvent("mechanic:setDeliveredParts")
AddEventHandler("mechanic:setDeliveredParts", function(loadedDeliveries)
    deliveredParts = loadedDeliveries
end)

local function drawLabel(text, width)
	vein:setNextWidgetWidth(width)
	vein:label(text)
end

local function comma_value(amount)
	local formatted = amount
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
	return formatted
end

Citizen.CreateThread(function()
    while true do
        if isMechanicPartMenuOpen then

            vein:beginWindow(windowX, windowY) -- Mandatory

            vein:beginRow()
                drawLabel('Mechanic Shop - Welcome! (Rank: ' .. currentRank .. ')')
            vein:endRow()
            
            vein:beginRow()
                drawLabel('Select a part to order:')
            vein:endRow()

            vein:beginRow()
                if currentRank > 1 then
                    local itemsPerRow = 3
                    local numRows = math.ceil(#parts / itemsPerRow)

                    for i = 1, numRows do
                        vein:beginRow()
                            for j = 1, itemsPerRow do
                                local curPartIndex = ((i-1) * itemsPerRow) + j
                                if parts[curPartIndex] then
                                    if vein:button("($" .. comma_value(PARTS[parts[curPartIndex]].price) .. ") " .. parts[curPartIndex]) then
                                        TriggerServerEvent("mechanic:orderPart", parts[curPartIndex])
                                    end
                                end
                            end
                        vein:endRow()
                    end
                else
                    drawLabel('You must be level 2 to order parts. Repair more vehicles to level up.')
                end
            vein:endRow()

            vein:beginRow()
                drawLabel('- Ordered parts -')
            vein:endRow()

            vein:beginRow()
                for i = 1, #orderedParts do
                    vein:beginRow()
                        drawLabel(orderedParts[i].name)
                        local currentProgress = orderedParts[i].deliveryProgress
                        vein:progressBar(0.0, currentProgress, 1.0, 0.2)
                    vein:endRow()
                end
                if #orderedParts == 0 then
                    drawLabel("None")
                end
            vein:endRow()

            vein:beginRow()
                drawLabel('- Delivered parts -')
            vein:endRow()

            vein:beginRow()
                for i = 1, #deliveredParts do
                    vein:beginRow()
                        drawLabel(deliveredParts[i].name)
                    vein:endRow()
                end
                if #deliveredParts == 0 then
                    drawLabel("None")
                end
            vein:endRow()

            vein:beginRow()
                if vein:button('Close') then -- Draw button and check if it were pressed
                    isMechanicPartMenuOpen = false
                end
                if vein:button('Claim Deliveries') and GetGameTimer() > claimButtonLastLick + (CLAIM_BUTTON_TIMEOUT_SECONDS * 1000) then
                    TriggerServerEvent("mechanic:claimDeliveries")
                    claimButtonLastLick = GetGameTimer()
                end
            vein:endRow()

            windowX, windowY = vein:endWindow() -- Mandatory
        end
        Wait(0)
    end
end)

Citizen.CreateThread(function()
    local lastFetch = 0
    while true do
        if isMechanicPartMenuOpen then
            while GetGameTimer() < lastFetch + (DATA_FETCH_INTERVAL_SECONDS * 1000) do
                Wait(1)
            end
            TriggerServerEvent("mechanic:fetchDeliveryProgress")
            lastFetch = GetGameTimer()
        end
        Wait(1)
    end
end)