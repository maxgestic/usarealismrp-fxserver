Citizen.CreateThread(function()


    interiorID = GetInteriorAtCoords(5012.0, -5747.5, 15.0)
            
        
        if IsValidInterior(interiorID) then      
				---ActivateInteriorEntitySet(interiorID, "pearl_necklace_set")
				---SetInteriorEntitySetColor(interiorID, "pearl_necklace_set", 1)
				---ActivateInteriorEntitySet(interiorID, "set_panther_set")
				---SetInteriorEntitySetColor(interiorID, "set_panther_set", 1)
				ActivateInteriorEntitySet(interiorID, "pink_diamond_set")
				SetInteriorEntitySetColor(interiorID, "pink_diamond_set", 1)
				
				

                
        RefreshInterior(interiorID)
    
        end
    
    end)
	
--- YOU CAN ONLY HAVE ONE SET ACTIVE AT ONE TIME. ---