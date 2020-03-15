BurgerHelper = {}

TriggerEvent("es:exposeDBFunctions", function(db)
    BurgerHelper.db = db
end)

BurgerHelper.addStrike = function(ident, stat, cb)
    BurgerHelper.db.getDocumentByRow("burgershot", "owner_identifier", ident, function(doc)
        if doc then
            BurgerHelper.db.updateDocument("burgershot", doc._id, {[stat] = doc[stat] + 1}, function(doc)
                cb(doc[stat])
            end)
        else
            BurgerHelper.createBurgerDoc(ident, 1)
            cb(1)
        end
    end)
end

BurgerHelper.createBurgerDoc = function(ident, strike)
    local newBurger = {}
    newBurger.owner_identifier = ident
    newBurger.strikes = (strike or 0)
    BurgerHelper.db.createDocument("burgershot", newBurger, function(docId) end)
end

BurgerHelper.getStrikes = function(ident, cb)
    BurgerHelper.db.getDocumentByRow("burgershot", "owner_identifier", ident, function(doc)
        if doc then
            cb(doc.strikes)
        else
            cb(0)
        end
    end)
end

BurgerHelper.clearStrikes = function(ident, stat, cb)
    BurgerHelper.db.getDocumentByRow("burgershot", "owner_identifier", ident, function(doc)
        if doc then
            BurgerHelper.db.updateDocument("burgershot", doc._id, {[stat] = 0}, function(doc)
                cb(doc[stat])
            end)
        else
            cb(0)
        end
    end)
end