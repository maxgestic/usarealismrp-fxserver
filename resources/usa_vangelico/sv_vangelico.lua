-- Buy ear and wrist jewelry like earrings, watches, and bracelets
-- by: minipunch

local Wrist = {
    Left = 6,
    Right = 7
}

local ITEMS = {
    male = {
        watches = {
            ["Smart"] = {
                price = 150,
                propVal = 1,
                wrist = Wrist.Left
            },
            ["Plastic"] = {
                price = 25,
                propVal = 3,
                wrist = Wrist.Left
            },
            ["Le Argo Luxe"] = {
                price = 450,
                propVal = 4,
                wrist = Wrist.Left
            },
            ["Plastic Strap Smart Watch"] = {
                price = 100,
                propVal = 5,
                wrist = Wrist.Left
            },
            ["Stephanie's Custom"] = {
                price = 525,
                propVal = 6,
                wrist = Wrist.Left
            },
            ["Skinny Flat"] = {
                price = 75,
                propVal = 7,
                wrist = Wrist.Left
            },
            ["Jones' Classic"] = {
                price = 1000,
                propVal = 8,
                wrist = Wrist.Left
            },
            ["Double Circle"] = {
                price = 720,
                propVal = 9,
                wrist = Wrist.Left
            },
            ["Classic Standard"] = {
                price = 165,
                propVal = 10,
                wrist = Wrist.Left
            },
            ["The Kovacic Collection"] = {
                price = 765,
                propVal = 11,
                wrist = Wrist.Left
            },
            ["Standard Geometric"] = {
                price = 115,
                propVal = 12,
                wrist = Wrist.Left
            },
            ["Advanced Smart Watch"] = {
                price = 120,
                propVal = 13,
                wrist = Wrist.Left
            },
            ["Classic Silver"] = {
                price = 120,
                propVal = 14,
                wrist = Wrist.Left
            },
            ["Round Edge"] = {
                price = 580,
                propVal = 15,
                wrist = Wrist.Left
            },
            ["The Weitman Original"] = {
                price = 1750,
                propVal = 16,
                wrist = Wrist.Left
            },
            ["Rudy's Signature"] = {
                price = 1500,
                propVal = 17,
                wrist = Wrist.Left
            },
            ["Plastic and Metal"] = {
                price = 75,
                propVal = 18,
                wrist = Wrist.Left
            },
            ["Mickey's Drip"] = {
                price = 1250,
                propVal = 19,
                wrist = Wrist.Left
            },
            ["Plastic with Glass"] = {
                price = 75,
                propVal = 20,
                wrist = Wrist.Left
            },
            ["Geometric Modern"] = {
                price = 95,
                propVal = 21,
                wrist = Wrist.Left
            }
        },
        bracelets = {
            ["Small Linking"] = {
                price = 30,
                propVal = 22,
                wrist = Wrist.Left
            },
            ["Large Linking"] = {
                price = 50,
                propVal = 23,
                wrist = Wrist.Left
            },
            ["Rectangular"] = {
                price = 65,
                propVal = 24,
                wrist = Wrist.Left
            },
            ["Skull"] = {
                price = 55,
                propVal = 25,
                wrist = Wrist.Left
            },
            ["Large Shard"] = {
                price = 40,
                propVal = 26,
                wrist = Wrist.Left
            },
            ["Standard"] = {
                price = 40,
                propVal = 27,
                wrist = Wrist.Left
            },
            ["Spike"] = {
                price = 70,
                propVal = 28,
                wrist = Wrist.Left
            },
            ["Leather"] = {
                price = 30,
                propVal = 29,
                wrist = Wrist.Left
            },
            ["Small Linking"] = {
                price = 30,
                propVal = 1,
                wrist = Wrist.Right
            },
            ["Rectangular"] = {
                price = 65,
                propVal = 2,
                wrist = Wrist.Right
            },
            ["Skull"] = {
                price = 55,
                propVal = 3,
                wrist = Wrist.Right
            },
            ["Large Shard"] = {
                price = 55,
                propVal = 4,
                wrist = Wrist.Right
            },
            ["Standard"] = {
                price = 45,
                propVal = 5,
                wrist = Wrist.Right
            },
            ["Spike"] = {
                price = 45,
                propVal = 5,
                wrist = Wrist.Right
            },
            ["Leather"] = {
                price = 25,
                propVal = 5,
                wrist = Wrist.Right
            }
            -- // todo: finish rest of items...
        }
    },
    female = {
        watches = {
            ["London's Own"] = {
                price = 230,
                propVal = 2,
                wrist = Wrist.Left
            },
            ["Paris' Custom"] = {
                price = 235,
                propVal = 3,
                wrist = Wrist.Left
            },
            ["Seoul's Ice"] = {
                price = 265,
                propVal = 4,
                wrist = Wrist.Left
            },
            ["Large Geometric"] = {
                price = 145,
                propVal = 5,
                wrist = Wrist.Left
            },
            ["Jam"] = {
                price = 320,
                propVal = 6,
                wrist = Wrist.Left
            },
            ["Small Skinny"] = {
                price = 115,
                propVal = 7,
                wrist = Wrist.Left
            },
            ["Cubic Modern"] = {
                price = 95,
                propVal = 8,
                wrist = Wrist.Left
            },
            ["Flat Skinny"] = {
                price = 80,
                propVal = 9,
                wrist = Wrist.Left
            },
            ["Hexigon Modern"] = {
                price = 115,
                propVal = 10,
                wrist = Wrist.Left
            }
        },
        bracelets = {
            ["Small Linking"] = {
                price = 30,
                propVal = 11,
                wrist = Wrist.Left
            },
            ["Large Linking"] = {
                price = 40,
                propVal = 12,
                wrist = Wrist.Left
            },
            ["Rectangular"] = {
                price = 30,
                propVal = 13,
                wrist = Wrist.Left
            },
            ["Skull"] = {
                price = 20,
                propVal = 14,
                wrist = Wrist.Left
            },
            ["Large Shard"] = {
                price = 55,
                propVal = 15,
                wrist = Wrist.Left
            },
            ["Standard"] = {
                price = 25,
                propVal = 16,
                wrist = Wrist.Left
            },
            ["Spike"] = {
                price = 30,
                propVal = 17,
                wrist = Wrist.Left
            },
            ["Leather"] = {
                price = 45,
                propVal = 18,
                wrist = Wrist.Left
            },
            ["Gold & Diamond Band"] = {
                price = 215,
                propVal = 1,
                wrist = Wrist.Right
            },
            ["Solid Gold Band"] = {
                price = 215,
                propVal = 2,
                wrist = Wrist.Right
            },
            ["CHIEN Cutout Band"] = {
                price = 255,
                propVal = 3,
                wrist = Wrist.Right
            },
            ["Gold Engraved Band"] = {
                price = 150,
                propVal = 4,
                wrist = Wrist.Right
            },
            ["Engraved Gold Plated Band"] = {
                price = 100,
                propVal = 5,
                wrist = Wrist.Right
            },
            ["Square Plated Band"] = {
                price = 80,
                propVal = 6,
                wrist = Wrist.Right
            },
            ["Small Linking"] = {
                price = 60,
                propVal = 7,
                wrist = Wrist.Right
            },
            ["Large Linking"] = {
                price = 50,
                propVal = 8,
                wrist = Wrist.Right
            },
            ["Rectangular"] = {
                price = 50,
                propVal = 9,
                wrist = Wrist.Right
            },
            ["Rectangular"] = {
                price = 50,
                propVal = 9,
                wrist = Wrist.Right
            },
            ["Skull"] = {
                price = 80,
                propVal = 10,
                wrist = Wrist.Right
            },
            ["Large Shard"] = {
                price = 80,
                propVal = 11,
                wrist = Wrist.Right
            },
            ["Standard"] = {
                price = 70,
                propVal = 12,
                wrist = Wrist.Right
            },
            ["Spike"] = {
                price = 65,
                propVal = 13,
                wrist = Wrist.Right
            },
            ["Leather"] = {
                price = 50,
                propVal = 14,
                wrist = Wrist.Right
            }
        }
    }
}

RegisterServerEvent("vangelico:loadItems")
AddEventHandler("vangelico:loadItems", function()
  TriggerClientEvent("vangelico:loadItems", source, ITEMS)
end)

RegisterServerEvent("vangelico:purchase")
AddEventHandler("vangelico:purchase", function(items, business)
    local left = items["left"]
    local right = items["right"]
    local char = exports["usa-characters"]:GetCharacter(source)
    if left then
        left.price = math.floor(math.abs(left.price))
        if char.get("money") >= left.price then
            TakeMoney(char, left.price, business)
            SaveSelection(char, left)
            TriggerClientEvent("usa:notify", source, "Purchased " .. left.name .. " for $" .. exports["globals"]:comma_value(left.price))
        else
            TriggerClientEvent("usa:notify", source, "Not enough money for the " .. left.name)
        end
    end
    if right then
        right.price = math.floor(math.abs(right.price))
        if char.get("money") >= right.price then
            TakeMoney(char, right.price, business)
            SaveSelection(char, right)
            TriggerClientEvent("usa:notify", source, "Purchased " .. right.name .. " for $" .. exports["globals"]:comma_value(right.price))
        else
            TriggerClientEvent("usa:notify", source, "Not enough money for the " .. right.name)
        end
    end
end)

RegisterServerEvent("vangelico:clear")
AddEventHandler("vangelico:clear", function(index)
    local char = exports["usa-characters"]:GetCharacter(source)
    local appearance = char.get("appearance")
    appearance["props"][index] = nil
    appearance["propstexture"][index] = nil
    char.set("appearance", appearance)
end)

function TakeMoney(char, price, business)
    char.removeMoney(price)
    if business then
      exports["usa-businesses"]:GiveBusinessCashPercent(business, price)
    end
end

function SaveSelection(char, item, price)
    local appearance = char.get("appearance")
    appearance["props"][tostring(item.wrist)] = item.propVal
    appearance["propstexture"][tostring(item.wrist)] = item.textureVal
    char.set("appearance", appearance)
end
