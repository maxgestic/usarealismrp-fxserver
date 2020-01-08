MechanicHelper = {}

MechanicHelper.LEVEL_2_RANK_THRESH = 40

TriggerEvent("es:exposeDBFunctions", function(db)
    MechanicHelper.db = db
end)

MechanicHelper.incrementStat = function(ident, stat, cb)
    MechanicHelper.db.getDocumentByRow("mechanicjob", "owner_identifier", ident, function(doc)
        if doc then
            MechanicHelper.db.updateDocument("mechanicjob", doc._id, {[stat] = doc[stat] + 1}, function(doc)
                cb(doc[stat])
            end)
        else
            MechanicHelper.createMechanicDoc(ident)
            cb(0)
        end
    end)
end

MechanicHelper.createMechanicDoc = function(ident)
    local newMechanic = {}
    newMechanic.owner_identifier = ident
    newMechanic.repairCount = 0
    MechanicHelper.db.createDocument("mechanicjob", newMechanic, function(docId) end)
end

MechanicHelper.upgradeInstalled = function(plate, upgrade, cb)
    MechanicHelper.db.getDocumentById("vehicles", plate, function(doc)
        if doc then 
            if not doc.upgrades then
                doc.upgrades = {}
            end
            table.insert(doc.upgrades, upgrade.id)
            MechanicHelper.db.updateDocument("vehicles", plate, { ["upgrades"] = doc.upgrades }, function(doc, err, rText)
                cb()
            end)
        end
    end)
end

MechanicHelper.getMechanicRank = function(ident, cb)
    MechanicHelper.db.getDocumentByRow("mechanicjob", "owner_identifier", ident, function(doc)
        if doc then 
            if doc.repairCount >= MechanicHelper.LEVEL_2_RANK_THRESH then
                cb(2)
            else 
                cb(1)
            end
        else    
            cb(0)
        end
    end)
end