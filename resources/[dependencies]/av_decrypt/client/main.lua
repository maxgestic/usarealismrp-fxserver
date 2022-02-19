local successCb
local failCb
local resultReceived = false
local anim = false
--[[
RegisterCommand('decrypt', function()
    exports["av_decrypt"]:decrypt(
    function() -- success
        print("success")
    end,
    function() -- failure
        print("failure")
    end)
end)
]]--
RegisterNUICallback('resultado', function(data, cb)
    SetNuiFocus(false, false)
    resultReceived = true
    if data.state then
		successCb()
    else
        failCb()
    end
    cb('ok')
end)

exports('decrypt', function(success, fail)
    resultReceived = false
	successCb = success
    failCb = fail
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "Start"
    })
end)