RegisterNetEvent("pm:sendMessage")
AddEventHandler("pm:sendMessage", function(from, msg)

	TriggerEvent("chatMessage", "TEXT (" .. from .. ")", { 255, 162, 0 }, msg)

end)

RegisterNetEvent("pm:help")
AddEventHandler("pm:help", function()

	TriggerEvent("chatMessage", "TEXT", { 255, 162, 0 }, "^0Usage: /text <id> <msg>")

end)