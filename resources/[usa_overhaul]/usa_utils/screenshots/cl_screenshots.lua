RegisterNetEvent("screenshots:takeForDiscord")
AddEventHandler("screenshots:takeForDiscord", function(caption)
    exports['screenshot-basic']:requestScreenshotUpload('https://wew.wtf/upload.php', 'files[]', function(data)
        local resp = json.decode(data)
        local screenshotUrl = resp.files[1].url
        TriggerServerEvent("screenshots:sendToDiscord", screenshotUrl, caption)
    end)
end)