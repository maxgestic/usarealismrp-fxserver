RegisterNetEvent("screenshots:takeForDiscord")
AddEventHandler("screenshots:takeForDiscord", function(caption)
    exports['screenshot-basic']:requestScreenshotUpload('http://147.135.104.174:3555/upload', 'files[]', function(data)
        local resp = json.decode(data)
        local screenshotUrl = resp.files[1].url
        TriggerServerEvent("screenshots:sendToDiscord", screenshotUrl, caption)
    end)
end)