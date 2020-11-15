local JOB_NAME = "realtor"

RegisterServerEvent("realty:duty")
AddEventHandler("realty:duty", function()
    local char = exports["usa-characters"]:GetCharacter(source)
    local job = char.get('job')
    local realty_rank = char.get("realtorRank")
    if not realty_rank or realty_rank <= 0 then
        TriggerClientEvent("usa:notify", source, "You are not whitelisted for Real Estate Agent!")
        return
    end
    if job ~= JOB_NAME  then
        char.set("job", JOB_NAME)
        TriggerClientEvent("usa:notify", source, "You are now in service as a Realtor.")
        TriggerEvent("eblips:remove", source)
        TriggerEvent('job:sendNewLog', source, JOB_NAME, true)
    else
        char.set("job", "civ")
        TriggerClientEvent("usa:notify", source, "You are now out of service as a Realtor.")
        TriggerEvent('job:sendNewLog', source, JOB_NAME, false)
    end
end)