TriggerEvent('es:addCommand', 'crypto', function(src, args, char)
    if char.hasItem("Cell Phone") then
        exports.crypto:avcrypto_open(src)
    else
        TriggerClientEvent("usa:notify", src, "Must have cell phone")
    end
end, {
	help = "Open the crypto app"
})