RegisterNetEvent("rockstar-editor:record")
AddEventHandler("rockstar-editor:record", function(status)
    if status == "start" then
        StartRecording(1)
        exports.globals:notify("Recording started!")
    elseif status == "stop" then
        StopRecordingAndSaveClip()
        exports.globals:notify("Recording saved!")
    elseif status == "cancel" then
        StopRecordingAndDiscardClip()
        exports.globals:notify("Recording cancelled!")
    end
end)

RegisterNetEvent("rockstar-editor:open")
AddEventHandler("rockstar-editor:open", function()
    print("Disconnecting From Server")
    NetworkSessionLeaveSinglePlayer()
    Wait(5000)
    print("Opening Rockstar Editor")
    ActivateRockstarEditor()
end)