local vein = exports.vein -- Store it in local variable for performance reasons

local commaValue = exports.globals.comma_value

local windowX, windowY

displayAircraftShopMenu = false

currentAircraftShopMenuPage = "home"

aircraftShopItems = {}
ownedAircraft = {}

local currentSelectedItem = nil
local currentSelectedAircraftToSell = nil

local function drawLabel(text)
	vein:setNextWidgetWidth(labelWidth)
	vein:label(text)
end

local function drawHomePage()
    vein:beginRow()
        if vein:button('Purchase Parachute') then
            TriggerServerEvent("aircraft:purchaseParachute")
        end
    vein:endRow()

    vein:beginRow()
        if vein:button('Helicopters') then
            currentAircraftShopMenuPage = "heliMenu"
        end
    vein:endRow()

    vein:beginRow()
        if vein:button('Airplanes') then
            currentAircraftShopMenuPage = "planeMenu"
        end
    vein:endRow()

    vein:beginRow()
        if vein:button('Sell an aircraft') then
            currentAircraftShopMenuPage = "sell"
        end
    vein:endRow()

    vein:beginRow()
        if vein:button('Retrieve an aircraft') then
            currentAircraftShopMenuPage = "retrieve"
        end
    vein:endRow()

    vein:beginRow()
        if vein:button('Make a claim') then
            currentAircraftShopMenuPage = "claims"
        end
    vein:endRow()

    if vein:button('Close') then -- Draw button and check if it were pressed
        displayAircraftShopMenu = false
    end
end

local function drawHeliMenu()
    for _, info in pairs(aircraftShopItems.helicopters) do
        if vein:button(info.name) then
            currentSelectedItem = info
            currentAircraftShopMenuPage = "buyRentSubmenu"
        end
    end
    if vein:button("Back") then 
        currentAircraftShopMenuPage = "home"
    end
end

local function drawPlaneMenu()
    for _, info in pairs(aircraftShopItems.planes) do
        if vein:button(info.name) then
            currentSelectedItem = info
            currentAircraftShopMenuPage = "buyRentSubmenu"
        end
    end
    if vein:button("Back") then 
        currentAircraftShopMenuPage = "home"
    end
end

local function drawBuyRentSubmenu()
    drawLabel("Selected: " .. currentSelectedItem.name)
    if vein:button('Back') then
        currentAircraftShopMenuPage = "home" -- todo: update to actually go to last visited page, not home
    end
    if vein:button('Buy ($' .. currentSelectedItem.price .. ")") then
        local business = exports["usa-businesses"]:GetClosestStore(15)
        TriggerServerEvent('aircraft:requestPurchase', currentSelectedItem.name, business)
    end
    if vein:button('Rent ($' .. currentSelectedItem.price * RENTAL_PERCENTAGE .. ")") then
        local business = exports["usa-businesses"]:GetClosestStore(15)
        TriggerServerEvent('aircraft:requestRent', currentSelectedItem.name, business)
    end
end

local function drawSellMenu()
    drawLabel("Select aircraft to sell:")
    for i = 1, #ownedAircraft do
        if vein:button(ownedAircraft[i].name .. " [" .. (ownedAircraft[i].plate or ownedAircraft[i].id) .. "]") then
            currentSelectedAircraftToSell = ownedAircraft[i]
            currentAircraftShopMenuPage = "sellConfirm"
        end
    end
    if vein:button("Back") then
        currentAircraftShopMenuPage = "home"
    end
end

local function drawConfirmSellMenu()
    drawLabel("Are you sure you want to sell your: " .. currentSelectedAircraftToSell.name .. " [" .. (currentSelectedAircraftToSell.plate or currentSelectedAircraftToSell.id) .. "]?")
    if vein:button("Yes") then
        TriggerServerEvent('aircraft:requestSell', currentSelectedAircraftToSell.id)
        currentAircraftShopMenuPage = "home"
        displayAircraftShopMenu = false
    end
    if vein:button("Cancel") then
        currentAircraftShopMenuPage = "sell"
    end
end

local function drawClaimsMenu()
    local hadAircraftToClaim = false
	for i = 1, #ownedAircraft do
        local aircraft = ownedAircraft[i]
        if not aircraft.stored then
            hadAircraftToClaim = true
            local claimPrice = math.floor(CLAIM_PERCENTAGE*aircraft.price)
            if vein:button(aircraft.name .. " (Fee: $" .. claimPrice .. ")") then
                TriggerServerEvent("aircraft:claim", aircraft.id)
                displayAircraftShopMenu = false
            end
        end
    end
    if not hadAircraftToClaim then
        drawLabel("Nothing to claim!")
    end
    if vein:button("Back") then
        currentAircraftShopMenuPage = "home"
    end
end

local function drawRetrievalMenu()
    for i = 1, #ownedAircraft do
        local aircraft = ownedAircraft[i]
        local store_status = ''
        if aircraft.stored then
            store_status = '(~g~Stored~s~)'
        else
            store_status = '(~r~Not Stored~s~)'
        end
        if vein:button("Retrieve " .. aircraft.name .. " " .. store_status) then
            TriggerServerEvent("aircraft:requestRetrieval", aircraft.id)
            displayAircraftShopMenu = false
            currentAircraftShopMenuPage = "home"
        end
    end
    if #ownedAircraft <= 0 then
        drawLabel("Nothing to retrieve!", "You don't own any aircraft to retrieve!")
    end
    if vein:button("Back") then
        currentAircraftShopMenuPage = "home"
    end
end

Citizen.CreateThread(function()
    while true do
        if displayAircraftShopMenu then

            vein:beginWindow(windowX, windowY) -- Mandatory

            if currentAircraftShopMenuPage == "home" then
                drawHomePage()
            elseif currentAircraftShopMenuPage == "heliMenu" then
                drawHeliMenu()
            elseif currentAircraftShopMenuPage == "planeMenu" then
                drawPlaneMenu()
            elseif currentAircraftShopMenuPage == "buyRentSubmenu" then
                drawBuyRentSubmenu()
            elseif currentAircraftShopMenuPage == "sell" then
                drawSellMenu()
            elseif currentAircraftShopMenuPage == "sellConfirm" then
                drawConfirmSellMenu()
            elseif currentAircraftShopMenuPage == "retrieve" then
                drawRetrievalMenu()
            elseif currentAircraftShopMenuPage == "claims" then
                drawClaimsMenu()
            end

            windowX, windowY = vein:endWindow() -- Mandatory
        end
        Wait(0)
    end
end)