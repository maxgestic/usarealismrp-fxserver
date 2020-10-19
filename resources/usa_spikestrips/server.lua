local SPIKE_STRIP_ITEM = {
   name = "Spike Strips",
   objectModel = "P_ld_stinger_s",
   weight = "20.0",
   legality = "legal",
   quantity = 1,
   type = "misc",
   price = 300
}

RegisterServerEvent("spikestrips:equip")
AddEventHandler("spikestrips:equip", function(payRequired, src)
   local usource = source
   if src then usource = src end
   local char = exports["usa-characters"]:GetCharacter(usource)
   if char.canHoldItem(SPIKE_STRIP_ITEM) then
      if payRequired then
         local charMoney = char.get("money")
         if charMoney >= SPIKE_STRIP_ITEM.price then
            char.removeMoney(SPIKE_STRIP_ITEM.price)
            char.giveItem(SPIKE_STRIP_ITEM)
         else
            TriggerClientEvent("usa:notify", usource, "Need: $" .. SPIKE_STRIP_ITEM.price)
         end
      else 
         char.giveItem(SPIKE_STRIP_ITEM)
      end
   else
      TriggerClientEvent("usa:notify", usource, "Inventory full!")
   end
end)