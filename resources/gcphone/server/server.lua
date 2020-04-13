--====================================================================================
-- #Author: Jonathan D @Gannon
-- #Version 2.0
--====================================================================================

math.randomseed(os.time())

db = nil

TriggerEvent("es:exposeDBFunctions", function(api)
    db = api
end)

-- make sure DBs exist --
exports["globals"]:PerformDBCheck("gcphone", "phone-users", nil)
exports["globals"]:PerformDBCheck("gcphone", "phone-calls", nil)
exports["globals"]:PerformDBCheck("gcphone", "phone-messages", nil)
exports["globals"]:PerformDBCheck("gcphone", "phone-contacts", nil)

--- Pour les numero du style XXX-XXXX
function getPhoneRandomNumber()
    local num = string.format("%d%d%d-%d%d%d%d", math.random(0, 9), math.random(0, 9), math.random(0, 9), math.random(0, 9), math.random(0, 9), math.random(0, 9), math.random(0, 9))
	return num
end

--- Exemple pour les numero du style 06XXXXXXXX
-- function getPhoneRandomNumber()
--     return '0' .. math.random(600000000,699999999)
-- end

RegisterServerEvent("gcPhone:getPhone")
AddEventHandler("gcPhone:getPhone", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local phone = char.getItem("Cell Phone")
	if phone then
		TriggerClientEvent("gcPhone:togglePhone", source)
	else
		TriggerClientEvent("usa:notify", source, "You have no cell phone!")
	end
end)

--====================================================================================
--  Utils
--====================================================================================
function getSourceFromIdentifier(identifier, cb)
    exports["usa-characters"]:GetCharacters(function(characters)
        for id, char in pairs(characters) do
            if char.get("_id") == identifier then
                cb(id)
                return
            end
        end
        cb(nil)
    end)
end

function getNumberPhone(identifier, cb)
    db.getDocumentById("phone-users", identifier, function(doc)
        if doc then
            cb(doc.number)
        else 
            cb(nil)
        end
    end)
end

function getIdentifierByPhoneNumber(phone_number, cb) 
    local query = {
        ["number"] = phone_number
    }
    local fields = {
        "_id"
    }
    db.getSpecificFieldFromDocumentByRows("phone-users", query, fields, function(doc)
        if doc then
            cb(doc._id)
        else
            cb(nil)
        end
    end)
end

function getPlayerID(source) -- character's ID
    return exports["usa-characters"]:GetCharacterField(source, "_id")
end


function getOrGeneratePhoneNumber (src, identifier, cb)
    getNumberPhone(identifier, function(myPhoneNumber)
        if myPhoneNumber == nil then
            local char = exports["usa-characters"]:GetCharacter(src)
            local newNum = getPhoneRandomNumber()
            db.createDocumentWithId("phone-users", { ["number"] = newNum }, char.get("_id"), function(ok)
                if ok then
                    cb(newNum)
                else
                    print("PHONE: Error trying to create doc with num:" .. newNum)
                end
            end)
        else
            cb(myPhoneNumber)
        end
    end)
end
--====================================================================================
--  Contacts
--====================================================================================
function arrayifyDBDocsResponse(queryResponse)
    local arr = {}
    for k, v in ipairs(queryResponse) do
        table.insert(arr, v.value)
    end
    return arr
end

function getContacts(identifier, cb)
    local endpoint = "/phone-contacts/_design/contactFilters/_view/getContactsByIdentifier"
    local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
    PerformHttpRequest(url, function(err, responseText, headers)
        if responseText then
            local data = json.decode(responseText)
            if data.rows then
                local contacts = arrayifyDBDocsResponse(data.rows)
                table.sort(contacts, function(a, b) return a.display < b.display end)
                cb(contacts)
            else
                cb(nil)
            end
        end
    end, "POST", json.encode({
        keys = { identifier }
    }), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
end
function addContact(src, identifier, number, display)
    local char = exports["usa-characters"]:GetCharacter(src)
    db.createDocument("phone-contacts", { number = number, display = display, ownerIdentifier = char.get("_id")}, function()
        notifyContactChange(src, identifier)
    end)
end
function updateContact(src, identifier, id, number, display)
    db.updateDocument("phone-contacts", id, { number = number, display = display }, function(doc, err, rText)
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function deleteContact(source, identifier, id)
    db.deleteDocument("phone-contacts", id, function(ok)
        notifyContactChange(sourcePlayer, identifier)
    end)
end
function deleteAllContact(identifier)
    getContacts(identifier, function(contacts)
        for i = 1, #contacts do 
            db.deleteDocument("phone-contacts", contacts[i].id, function(ok) end)
        end
    end)
end
function notifyContactChange(src, identifier)
    if src then 
        getContacts(identifier, function(contacts)
            TriggerClientEvent("gcPhone:contactList", src, contacts)
        end)
    end
end

RegisterServerEvent('gcPhone:addContact')
AddEventHandler('gcPhone:addContact', function(display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addContact(sourcePlayer, identifier, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:updateContact')
AddEventHandler('gcPhone:updateContact', function(id, display, phoneNumber)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    updateContact(sourcePlayer, identifier, id, phoneNumber, display)
end)

RegisterServerEvent('gcPhone:deleteContact')
AddEventHandler('gcPhone:deleteContact', function(id)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteContact(sourcePlayer, identifier, id)
end)

--====================================================================================
--  Messages
--====================================================================================
function getMessages(identifier, cb)
    --[[
    getNumberPhone(identifer, function(num)
        db.getDocumentsByRows("phone-messages", { receiver = num }, function(docs)
            cb(messages)
        end)
    end)
    --]]
    getNumberPhone(identifier, function(number)
        local endpoint = "/phone-messages/_design/messageFilters/_view/getReceivedMessagesByNum"
        local url = "http://" .. exports["essentialmode"]:getIP() .. ":" .. exports["essentialmode"]:getPort() .. endpoint
        PerformHttpRequest(url, function(err, responseText, headers)
            if responseText then
                local data = json.decode(responseText)
                local messages = {}
                if data.rows then
                    local msgs = arrayifyDBDocsResponse(data.rows)
                    table.sort(msgs, function(a, b) return a.timeMs < b.timeMs end)
                    cb(msgs)
                else
                    cb(messages)
                end
            end
        end, "POST", json.encode({
            keys = { number }
        }), { ["Content-Type"] = 'application/json', Authorization = "Basic " .. exports["essentialmode"]:getAuth() })
    end)
end

--[[
RegisterServerEvent('gcPhone:_internalAddMessage')
AddEventHandler('gcPhone:_internalAddMessage', function(transmitter, receiver, message, owner, cb)
    cb(_internalAddMessage(transmitter, receiver, message, owner))
end)
--]]

function _internalAddMessage(transmitter, receiver, message, owner, cb)
    local newMessage = { 
        transmitter = transmitter,
        receiver = receiver,
        message = message,
        isRead = owner,
        owner = owner,
        time = exports.globals:getJavaScriptDateString(exports.globals:currentTimestamp()),
        timeMs = os.time()
     }
    db.createDocument("phone-messages", newMessage, function(docId)
        cb(newMessage)
    end)
    --[[
    local Query = "INSERT INTO phone_messages (`transmitter`, `receiver`,`message`, `isRead`,`owner`) VALUES(@transmitter, @receiver, @message, @isRead, @owner);"
    local Query2 = 'SELECT * from phone_messages WHERE `id` = @id;'
	local Parameters = {
        ['@transmitter'] = transmitter,
        ['@receiver'] = receiver,
        ['@message'] = message,
        ['@isRead'] = owner,
        ['@owner'] = owner
    }
    local id = MySQL.Sync.insert(Query, Parameters)
    return MySQL.Sync.fetchAll(Query2, {
        ['@id'] = id
    })[1]
    --]]
end

function addMessage(src, identifier, phone_number, message)
    getIdentifierByPhoneNumber(phone_number, function(otherIdentifier)
        getNumberPhone(identifier, function(myPhone)
            if otherIdentifier then
                _internalAddMessage(myPhone, phone_number, message, 0, function(msg)
                    getSourceFromIdentifier(otherIdentifier, function (otherSrc)
                        if otherSrc then
                            TriggerClientEvent("gcPhone:receiveMessage", otherSrc, msg, false)
                        end
                    end)
                end)
            end
            _internalAddMessage(phone_number, myPhone, message, 1, function(msg)
                TriggerClientEvent("gcPhone:receiveMessage", src, msg, true)
            end)
        end)
    end)
    --[[
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier then -- if valid receiver phone number
        _internalAddMessage(myPhone, phone_number, message, function(message) -- create message in db
            TriggerClientEvent("gcPhone:receiveMessage", src, message, true) -- send to transmitter client
            getSourceFromIdentifier(otherIdentifier, function (otherSrc)
                if otherSrc then 
                    TriggerClientEvent("gcPhone:receiveMessage", otherSrc, message, false) -- send to receiver client
                end
            end) 
        end)
    else 
        TriggerClientEvent("usa:notify", src, "Invalid phone number!")
    end
    --]]

    --[[
    local sourcePlayer = tonumber(source)
    local otherIdentifier = getIdentifierByPhoneNumber(phone_number)
    local myPhone = getNumberPhone(identifier)
    if otherIdentifier ~= nil then 
        local tomess = _internalAddMessage(myPhone, phone_number, message, 0)
        getSourceFromIdentifier(otherIdentifier, function (osou)
            if tonumber(osou) ~= nil then 
                -- TriggerClientEvent("gcPhone:allMessage", osou, getMessages(otherIdentifier))
                TriggerClientEvent("gcPhone:receiveMessage", tonumber(osou), tomess)
            end
        end) 
    end
    local memess = _internalAddMessage(phone_number, myPhone, message, 1)
    TriggerClientEvent("gcPhone:receiveMessage", sourcePlayer, memess)
    --]]
end

function setReadMessageNumber(identifier, num)
    getNumberPhone(identifier, function(mePhoneNumber)
        local query = {
            ["receiver"] = mePhoneNumber,
            ["transmitter"] = num
        }
        db.getDocumentsByRows("phone-messages", query, function(docs)
            if docs then
                for i = 1, #docs do
                    db.updateDocument("phone-messages", docs[i]._id, { isRead = 1 }, function(doc, err, rText)
                        --print("message with id " .. docs[i]._id .. " set to read!")
                    end)
                end
            end
        end)
    end)
    --[[
    local mePhoneNumber = getNumberPhone(identifier)
    MySQL.Sync.execute("UPDATE phone_messages SET phone_messages.isRead = 1 WHERE phone_messages.receiver = @receiver AND phone_messages.transmitter = @transmitter", { 
        ['@receiver'] = mePhoneNumber,
        ['@transmitter'] = num
    })
    --]]
end

function deleteMessage(msgId)
    db.deleteDocument("phone-messages", msgId, function(ok) end)
    --[[
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `id` = @id", {
        ['@id'] = msgId
    })
    --]]
end

function deleteAllMessageFromPhoneNumber(src, identifier, phone_number)
    getNumberPhone(identifier, function(mePhoneNumber)
        local query = {
            ["receiver"] = mePhoneNumber,
            ["transmitter"] = phone_number
        }
        db.getDocumentsByRows("phone-messages", query, function(docs)
            for i = 1, #docs do
                db.deleteDocument("phone-messages", docs[i]._id,  function(ok) end)
            end
        end)
    end)
    --[[
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber and `transmitter` = @phone_number", {['@mePhoneNumber'] = mePhoneNumber,['@phone_number'] = phone_number})
    --]]
end

function deleteAllMessage(identifier)
    getNumberPhone(identifier, function(mePhoneNumber)
        local query = {
            ["receiver"] = mePhoneNumber
        }
        db.getDocumentsByRows("phone-messages", query, function(docs)
            if docs then
                for i = 1, #docs do
                    db.deleteDocument("phone-messages", docs[i]._id,  function(ok) end)
                end
            end
        end)
    end)
    --[[
    MySQL.Sync.execute("DELETE FROM phone_messages WHERE `receiver` = @mePhoneNumber", {
        ['@mePhoneNumber'] = mePhoneNumber
    })
    --]]
end

RegisterServerEvent('gcPhone:sendMessage')
AddEventHandler('gcPhone:sendMessage', function(phoneNumber, message)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    addMessage(sourcePlayer, identifier, phoneNumber, message)
end)

RegisterServerEvent('gcPhone:deleteMessage')
AddEventHandler('gcPhone:deleteMessage', function(msgId)
    deleteMessage(msgId)
end)

RegisterServerEvent('gcPhone:deleteMessageNumber')
AddEventHandler('gcPhone:deleteMessageNumber', function(number)
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessageFromPhoneNumber(sourcePlayer,identifier, number)
    -- TriggerClientEvent("gcphone:allMessage", sourcePlayer, getMessages(identifier))
end)

RegisterServerEvent('gcPhone:deleteAllMessage')
AddEventHandler('gcPhone:deleteAllMessage', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
end)

RegisterServerEvent('gcPhone:setReadMessageNumber')
AddEventHandler('gcPhone:setReadMessageNumber', function(num)
    local identifier = getPlayerID(source)
    setReadMessageNumber(identifier, num)
end)

RegisterServerEvent('gcPhone:deleteALL')
AddEventHandler('gcPhone:deleteALL', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    deleteAllMessage(identifier)
    deleteAllContact(identifier)
    appelsDeleteAllHistorique(identifier)
    TriggerClientEvent("gcPhone:contactList", sourcePlayer, {})
    TriggerClientEvent("gcPhone:allMessage", sourcePlayer, {})
    TriggerClientEvent("appelsDeleteAllHistorique", sourcePlayer, {})
end)

--====================================================================================
--  Gestion des appels
--====================================================================================
local AppelsEnCours = {}
local PhoneFixeInfo = {}
local lastIndexCall = 10

function getHistoriqueCall (num, cb)
    local query = {
        ["owner"] = num
    }
    db.getDocumentsByRowsLimit("phone-calls", query, 100, function(docs)
        table.sort(docs, function(a, b) return a.timeMs > b.timeMs end)
        cb(docs)
    end)
    --[[
    local result = MySQL.Sync.fetchAll("SELECT * FROM phone_calls WHERE phone_calls.owner = @num ORDER BY time DESC LIMIT 120", {
        ['@num'] = num
    })
    return result
    --]]
end

function sendHistoriqueCall (src, num) 
    getHistoriqueCall(num, function(histo)
        TriggerClientEvent('gcPhone:historiqueCall', src, histo)
    end)
end

function saveAppels (appelInfo)
    local callDoc = {
        ["owner"] = appelInfo.transmitter_num,
        ["num"] = appelInfo.receiver_num,
        ["incoming"] = 1,
        ["accepts"] = appelInfo.is_accepts,
        ["time"] = exports.globals:getJavaScriptDateString(exports.globals:currentTimestamp()),
        ["timeMs"] = os.time()
    }
    if appelInfo.extraData == nil or appelInfo.extraData.useNumber == nil then
        db.createDocument("phone-calls", callDoc, function(docId)
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
        --[[
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.transmitter_num,
            ['@num'] = appelInfo.receiver_num,
            ['@incoming'] = 1,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            notifyNewAppelsHisto(appelInfo.transmitter_src, appelInfo.transmitter_num)
        end)
        --]]
    end
    if appelInfo.is_valid == true then
        local num = appelInfo.transmitter_num
        if appelInfo.hidden == true then
            num = "###-####"
        end
        callDoc["owner"] = appelInfo.receiver_num
        callDoc["num"] = num
        callDoc["incoming"] = 0
        callDoc["accepts"] = appelInfo.is_accepts
        db.createDocument("phone-calls", callDoc, function(docId)
            notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
        end)
        --[[
        MySQL.Async.insert("INSERT INTO phone_calls (`owner`, `num`,`incoming`, `accepts`) VALUES(@owner, @num, @incoming, @accepts)", {
            ['@owner'] = appelInfo.receiver_num,
            ['@num'] = num,
            ['@incoming'] = 0,
            ['@accepts'] = appelInfo.is_accepts
        }, function()
            if appelInfo.receiver_src ~= nil then
                notifyNewAppelsHisto(appelInfo.receiver_src, appelInfo.receiver_num)
            end
        end)
        --]]
    end
end

function notifyNewAppelsHisto (src, num) 
    sendHistoriqueCall(src, num)
end

RegisterServerEvent('gcPhone:getHistoriqueCall')
AddEventHandler('gcPhone:getHistoriqueCall', function()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    getNumberPhone(srcIdentifier, function(num)
        sendHistoriqueCall(sourcePlayer, num)
    end)
end)


RegisterServerEvent('gcPhone:internal_startCall')
AddEventHandler('gcPhone:internal_startCall', function(source, phone_number, rtcOffer, extraData)
    if FixePhone[phone_number] ~= nil then
        onCallFixePhone(source, phone_number, rtcOffer, extraData)
        return
    end
    
    local rtcOffer = rtcOffer
    if phone_number == nil or phone_number == '' then 
        print('BAD CALL NUMBER IS NIL')
        return
    end

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end

    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        getNumberPhone(srcIdentifier, function(num)
            srcPhone = num
        end)
    end

    while srcPhone == '' do -- wait for callback to finish if needed
        Wait(1)
    end

    getIdentifierByPhoneNumber(phone_number, function(destPlayer)
        local is_valid = destPlayer ~= nil and destPlayer ~= srcIdentifier
        AppelsEnCours[indexCall] = {
            id = indexCall,
            transmitter_src = sourcePlayer,
            transmitter_num = srcPhone,
            receiver_src = nil,
            receiver_num = phone_number,
            is_valid = destPlayer ~= nil,
            is_accepts = false,
            hidden = hidden,
            rtcOffer = rtcOffer,
            extraData = extraData
        }
        
    
        if is_valid == true then
            getSourceFromIdentifier(destPlayer, function (srcTo)
                if srcTo ~= nil then
                    AppelsEnCours[indexCall].receiver_src = srcTo
                    TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                    TriggerClientEvent('gcPhone:waitingCall', srcTo, AppelsEnCours[indexCall], false)
                else
                    TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
                    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
                end
            end)
        else
            TriggerEvent('gcPhone:addCall', AppelsEnCours[indexCall])
            TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
        end
    end)

end)

RegisterServerEvent('gcPhone:startCall')
AddEventHandler('gcPhone:startCall', function(phone_number, rtcOffer, extraData)
    TriggerEvent('gcPhone:internal_startCall',source, phone_number, rtcOffer, extraData)
end)

RegisterServerEvent('gcPhone:candidates')
AddEventHandler('gcPhone:candidates', function (callId, candidates)
    -- print('send cadidate', callId, candidates)
    if AppelsEnCours[callId] ~= nil then
        local source = source
        local to = AppelsEnCours[callId].transmitter_src
        if source == to then 
            to = AppelsEnCours[callId].receiver_src
        end
        -- print('TO', to)
        TriggerClientEvent('gcPhone:candidates', to, candidates)
    end
end)


RegisterServerEvent('gcPhone:acceptCall')
AddEventHandler('gcPhone:acceptCall', function(infoCall, rtcAnswer)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onAcceptFixePhone(source, infoCall, rtcAnswer)
            return
        end
        AppelsEnCours[id].receiver_src = infoCall.receiver_src or AppelsEnCours[id].receiver_src
        if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
            AppelsEnCours[id].is_accepts = true
            AppelsEnCours[id].rtcAnswer = rtcAnswer
            TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
            SetTimeout(1000, function() -- change to +1000, if necessary.
                TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
            end)
            saveAppels(AppelsEnCours[id])
        end
    end
end)

RegisterServerEvent('gcPhone:rejectCall')
AddEventHandler('gcPhone:rejectCall', function (infoCall)
    local id = infoCall.id
    if AppelsEnCours[id] ~= nil then
        if PhoneFixeInfo[id] ~= nil then
            onRejectFixePhone(source, infoCall)
            return
        end
        if AppelsEnCours[id].transmitter_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src, infoCall)
        end
        if AppelsEnCours[id].receiver_src ~= nil then
            TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].receiver_src, infoCall)
        end

        if AppelsEnCours[id].is_accepts == false then 
            saveAppels(AppelsEnCours[id])
        end
        TriggerEvent('gcPhone:removeCall', AppelsEnCours)
        AppelsEnCours[id] = nil
    end
end)

RegisterServerEvent('gcPhone:appelsDeleteHistorique')
AddEventHandler('gcPhone:appelsDeleteHistorique', function (numero)
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    getNumberPhone(srcIdentifier, function(srcPhone)
        db.getDocumentsByRows("phone-calls", {owner = srcPhone, num = numero}, function(docs)
            for i = 1, #docs do
                db.deleteDocument("phone-calls", docs[i]._id, function() end)
            end
        end)
    end)
    --[[
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner AND `num` = @num", {
        ['@owner'] = srcPhone,
        ['@num'] = numero
    })
    --]]
end)

function appelsDeleteAllHistorique(srcIdentifier)
    getNumberPhone(srcIdentifier, function(srcPhone)
        db.getDocumentsByRows("phone-calls", {owner = srcPhone}, function(docs)
            for i = 1, #docs do
                db.deleteDocument("phone-calls", docs[i]._id, function() end)
            end
        end)
    end)
    --[[
    MySQL.Sync.execute("DELETE FROM phone_calls WHERE `owner` = @owner", {
        ['@owner'] = srcPhone
    })
    --]]
end

RegisterServerEvent('gcPhone:appelsDeleteAllHistorique')
AddEventHandler('gcPhone:appelsDeleteAllHistorique', function ()
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)
    appelsDeleteAllHistorique(srcIdentifier)
end)

--====================================================================================
--  OnLoad
--====================================================================================
AddEventHandler('character:loaded',function(char)
    local sourcePlayer = char.get("source")
    local identifier = char.get("_id")
    getOrGeneratePhoneNumber(sourcePlayer, identifier, function (myPhoneNumber)
        TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, myPhoneNumber)
        getContacts(identifier, function(contacts)
            TriggerClientEvent("gcPhone:contactList", sourcePlayer, contacts)
            getMessages(identifier, function(messages)
                TriggerClientEvent("gcPhone:allMessage", sourcePlayer, messages)
                sendHistoriqueCall(sourcePlayer, myPhoneNumber)
            end)
        end)
    end)
end)

--====================================================================================
--  Miscellaneous
--====================================================================================
RegisterServerEvent("phone:sendTaxiMessage")
AddEventHandler("phone:sendTaxiMessage", function(data)
	local taxi_online = false
    local message = data.message
    local src = source
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			if char.get("job") == "taxi" then
				TriggerClientEvent('chatMessage', id, "Taxi Requested! (Caller: #" .. src .. ")", {251, 229, 5}, message .. " (" .. data.location .. ")")
				TriggerClientEvent("phone:notify", id, "~y~TAXI REQUEST (Caller: # ".. src .. "):\n~w~"..message)
				taxi_online = true
				-- set temp blip
				TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z)
			end
		end
		if taxi_online then
			TriggerClientEvent('chatMessage', src, "", {255, 255, 255}, "A ^3taxi^0 has been notified!")
			TriggerClientEvent("usa:notify", src, "A ~y~taxi ~w~has been notified!")
		else
			TriggerClientEvent('chatMessage', src, "", {255, 255, 255}, "Sorry, there is no one on duty as taxi!")
			TriggerClientEvent("usa:notify", src, "~y~Sorry, there is no one on duty as taxi!")
		end
	end)
end)

RegisterServerEvent("phone:sendMechanicMessage")
AddEventHandler("phone:sendMechanicMessage", function(data)
	local mechanic_online = false
    local message = data.message
    local src = source
	exports["usa-characters"]:GetCharacters(function(characters)
		for id, char in pairs(characters) do
			if char.get("job") == "mechanic" then
				TriggerClientEvent('chatMessage', id, "Mechanic Requested! (Caller: #" .. src .. ")", {118, 120, 251}, message .. " (" .. data.location .. ")")
				TriggerClientEvent("phone:notify", id, "~y~MECHANIC REQUEST (Caller: # ".. src .. "):\n~w~"..message)
				tow_online = true
				TriggerClientEvent('drug-sell:createBlip', id, data.pos.x, data.pos.y, data.pos.z) -- hacky blip
			end
		end
		if tow_online then
			TriggerClientEvent("usa:notify", src, "A ~y~mechanic~w~ has been notified!", "^0A ^3mechanic^0 has been notified!")
		else
			TriggerClientEvent("usa:notify", src, "~y~No one is on duty as mechanic!", "^0No one is on duty as mechanic!")
		end
	end)
end)

-- Just For reload
RegisterServerEvent('gcPhone:allUpdate')
AddEventHandler('gcPhone:allUpdate', function()
    local sourcePlayer = tonumber(source)
    local identifier = getPlayerID(source)
    getNumberPhone(identifier, function(num)
        TriggerClientEvent("gcPhone:myPhoneNumber", sourcePlayer, num)
        getContacts(identifier, function(contacts)
            TriggerClientEvent("gcPhone:contactList", sourcePlayer, contacts)
            getMessages(identifier, function(messages)
                TriggerClientEvent("gcPhone:allMessage", sourcePlayer, messages)
                sendHistoriqueCall(sourcePlayer, num)
            end)
        end)
    end)
end)


--[[
AddEventHandler('onMySQLReady', function ()
    -- MySQL.Async.fetchAll("DELETE FROM phone_messages WHERE (DATEDIFF(CURRENT_DATE,time) > 10)")
end)
--]]

--====================================================================================
--  App bourse
--====================================================================================
--[[
function getBourse()
    --  Format
    --  Array 
    --    Object
    --      -- libelle type String    | Nom
    --      -- price type number      | Prix actuelle
    --      -- difference type number | Evolution 
    -- 
    -- local result = MySQL.Sync.fetchAll("SELECT * FROM `recolt` LEFT JOIN `items` ON items.`id` = recolt.`treated_id` WHERE fluctuation = 1 ORDER BY price DESC",{})
    local result = {
        {
            libelle = 'Google',
            price = 125.2,
            difference =  -12.1
        },
        {
            libelle = 'Microsoft',
            price = 132.2,
            difference = 3.1
        },
        {
            libelle = 'Amazon',
            price = 120,
            difference = 0
        }
    }
    return result
end
--]]

--====================================================================================
--  App ... WIP
--====================================================================================


-- SendNUIMessage('ongcPhoneRTC_receive_offer')
-- SendNUIMessage('ongcPhoneRTC_receive_answer')

-- RegisterNUICallback('gcPhoneRTC_send_offer', function (data)


-- end)


-- RegisterNUICallback('gcPhoneRTC_send_answer', function (data)


-- end)



function onCallFixePhone (source, phone_number, rtcOffer, extraData)
    local indexCall = lastIndexCall
    lastIndexCall = lastIndexCall + 1

    local hidden = string.sub(phone_number, 1, 1) == '#'
    if hidden == true then
        phone_number = string.sub(phone_number, 2)
    end
    local sourcePlayer = tonumber(source)
    local srcIdentifier = getPlayerID(source)

    local srcPhone = ''
    if extraData ~= nil and extraData.useNumber ~= nil then
        srcPhone = extraData.useNumber
    else
        getNumberPhone(srcIdentifier, function(num)
            srcPhone = num
        end)
    end

    while srcPhone == '' do -- wait for callback if needed
        Wait(1)
    end

    AppelsEnCours[indexCall] = {
        id = indexCall,
        transmitter_src = sourcePlayer,
        transmitter_num = srcPhone,
        receiver_src = nil,
        receiver_num = phone_number,
        is_valid = false,
        is_accepts = false,
        hidden = hidden,
        rtcOffer = rtcOffer,
        extraData = extraData,
        coords = FixePhone[phone_number].coords
    }
    
    PhoneFixeInfo[indexCall] = AppelsEnCours[indexCall]

    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:waitingCall', sourcePlayer, AppelsEnCours[indexCall], true)
end



function onAcceptFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    
    AppelsEnCours[id].receiver_src = source
    if AppelsEnCours[id].transmitter_src ~= nil and AppelsEnCours[id].receiver_src~= nil then
        AppelsEnCours[id].is_accepts = true
        AppelsEnCours[id].forceSaveAfter = true
        AppelsEnCours[id].rtcAnswer = rtcAnswer
        PhoneFixeInfo[id] = nil
        TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
        TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].transmitter_src, AppelsEnCours[id], true)
        SetTimeout(1000, function() -- change to +1000, if necessary.
                TriggerClientEvent('gcPhone:acceptCall', AppelsEnCours[id].receiver_src, AppelsEnCours[id], false)
        end)
        saveAppels(AppelsEnCours[id])
    end
end

function onRejectFixePhone(source, infoCall, rtcAnswer)
    local id = infoCall.id
    PhoneFixeInfo[id] = nil
    TriggerClientEvent('gcPhone:notifyFixePhoneChange', -1, PhoneFixeInfo)
    TriggerClientEvent('gcPhone:rejectCall', AppelsEnCours[id].transmitter_src)
    if AppelsEnCours[id].is_accepts == false then
        saveAppels(AppelsEnCours[id])
    end
    AppelsEnCours[id] = nil
    
end
