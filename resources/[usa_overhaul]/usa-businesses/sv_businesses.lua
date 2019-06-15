RegisterServerEvent("business:tryOpenMenu")
AddEventHandler("business:tryOpenMenu", function(businessName)
  -- 0) get caller character ID
  -- 1) query business DB for business with owner = character id
  -- 2a) display notification if not the owner
  -- 2b) open business menu for player with loaded information if owner
end)
