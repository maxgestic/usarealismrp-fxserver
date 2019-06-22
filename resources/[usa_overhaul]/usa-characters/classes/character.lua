function CreateCharacter(data)
  -- private:
  local self = data

  self.hasRoomForAnotherItem = function()
    for i = 0, self.inventory.MAX_CAPACITY - 1 do
      if self.inventory.items[tostring(i)] == nil then
        return true
      end
    end
    return false
  end

  self.hasItem = function(item)
    local targetItemName = (item.name or item)
    local inv = self.inventory
    for i = 0, inv.MAX_CAPACITY - 1 do
      local invItem = inv.items[tostring(i)]
      if invItem then
        if invItem.name:find(targetItemName) or invItem.name == targetItemName then
          return true
        end
      end
    end
    return false
  end

  self.addInventoryWeight = function(weight)
    self.inventory.currentWeight = self.inventory.currentWeight + weight
  end

  self.removeInventoryWeight = function(weight)
    self.inventory.currentWeight = self.inventory.currentWeight - weight
  end

  self.adjustChatSuggestions = function(data)
    TriggerClientEvent('chat:removeSuggestionAll', self.source)
    for k,v in pairs(exports['essentialmode']:getCommands()) do
      if v.job == "everyone" then
        local group = exports["essentialmode"]:getPlayerFromId(self.source).getGroup()
        if exports['essentialmode']:CanGroupTarget(group, v.group) then
          TriggerClientEvent('chat:addSuggestion', self.source, '/' .. k, v.help, v.params)
        end
      else
        local allowed = 0;
        for k,vc in pairs(v.job) do
          if data == vc then
            allowed = 1
          end
        end
        if allowed == 1 then
          TriggerClientEvent('chat:addSuggestion', self.source, '/' .. k, v.help, v.params)
        end
      end
    end
  end

  -- public:
  local rTable = {}

  rTable.getSelf = function()
    return self
  end

  rTable.get = function(field)
    return self[field]
  end

  rTable.set = function(field, data)
    self[field] = data
    if field == "money" then
      TriggerClientEvent("es:setMoneyDisplay", self.source, 1, data)
    elseif field == "job" then
      self.adjustChatSuggestions(data)
    end
  end

  rTable.giveMoney = function(amount)
    self.money = self.money + tonumber(amount)
    TriggerClientEvent("es:setMoneyDisplay", self.source, 1, self.money)
  end

  rTable.removeMoney = function(amount)
    self.money = self.money - tonumber(amount)
    TriggerClientEvent("es:setMoneyDisplay", self.source, 1, self.money)
  end

  rTable.giveBank = function(amount)
    self.bank = self.bank + tonumber(amount)
  end

  rTable.removeBank = function(amount)
    self.bank = self.bank - tonumber(amount)
  end

  rTable.getName = function()
    return self.name.first .. " " .. self.name.last
  end

  rTable.getFullName = function()
    return self.name.first .. " " .. self.name.middle .. " " .. self.name.last
  end

  rTable.getWeapons = function()
    local weps = {}
    local inv = self.inventory
    for i = 0, self.inventory.MAX_CAPACITY - 1 do
      local item = self.inventory.items[tostring(i)]
      if item then
        if item.type == "weapon" then
          table.insert(weps, item)
        end
      end
    end
    return weps
  end

  rTable.removeWeapons = function()
    local inv = self.inventory
    for i = 0, inv.MAX_CAPACITY - 1 do
      local item = inv.items[tostring(i)]
      if item then
        if item.type == "weapon" then
          self.inventory.items[tostring(i)] = nil
          self.removeInventoryWeight((item.weight or 1.0) * (item.quantity or 1))
        end
      end
    end
  end

  rTable.getLicenses = function()
    local licenses = {}
    local inv = self.inventory
    for i = 0, inv.MAX_CAPACITY - 1 do
      local item = inv.items[tostring(i)]
      if item then
        if item.type == "license" then
          table.insert(licenses, item)
        end
      end
    end
    return licenses
  end

  rTable.hasItem = function(item)
    return self.hasItem(item)
  end

  rTable.canHoldItem = function(item, quantity)
    if quantity then
      item.quantity = quantity
    end
    local newWeight = self.inventory.currentWeight + ((item.weight or 1.0) * (item.quantity or 1))
    -- first check weight --
    if newWeight > self.inventory.MAX_WEIGHT then
      return false
    end
    -- then check inventory space --
    if not item.notStackable then
      if self.hasItem(item) then
        return true
      else
        return self.hasRoomForAnotherItem()
      end
    else
      return self.hasRoomForAnotherItem()
    end
  end

  rTable.getItem = function(itemName)
    local inv = self.inventory
    for i = 0, inv.MAX_CAPACITY - 1 do
      local item = inv.items[tostring(i)]
      if item then
        if item.name:find(itemName) then
          return item
        end
      end
    end
    return nil
  end

  rTable.getItemByIndex = function(index)
    if self.inventory.items[tostring(index)] then
      return self.inventory.items[tostring(index)]
    else
      return nil
    end
  end

  rTable.getItemWithField = function(field, val)
    local inv = self.inventory
    for i = 0, inv.MAX_CAPACITY - 1 do
      local item = inv.items[tostring(i)]
      if item then
        if item[field] == val then
          return item
        end
      end
    end
    return nil
  end

  rTable.giveItem = function(item, quantity)
    if quantity then
      item.quantity = quantity
    end
    local firstFreeSlot = nil
     for i = 0, self.inventory.MAX_CAPACITY - 1 do
       if self.inventory.items[tostring(i)] == nil and not firstFreeSlot then
         firstFreeSlot = tostring(i)
       elseif self.inventory.items[tostring(i)] and self.inventory.items[tostring(i)].name == item.name and not item.notStackable then
         self.inventory.items[tostring(i)].quantity = self.inventory.items[tostring(i)].quantity + item.quantity
         self.addInventoryWeight((item.weight or 1.0) * item.quantity)
         return
       end
     end
     if firstFreeSlot then
       self.inventory.items[firstFreeSlot] = item
       self.addInventoryWeight((item.weight or 1.0) * (item.quantity or 1))
     end
  end

  rTable.putItemInSlot = function(item, slot, quantity, cb)
    if quantity then
      item.quantity = quantity
    end
    slot = tostring(slot)
    if not self.inventory.items[slot] then -- move to empty slot
      self.inventory.items[slot] = item
      cb(true)
      self.addInventoryWeight((item.weight or 1.0) * (item.quantity or 1))
    elseif self.inventory.items[slot] and self.inventory.items[slot].name == item.name and not item.notStackable then -- not empty, but stackable
      self.inventory.items[slot].quantity = self.inventory.items[slot].quantity + item.quantity
      self.addInventoryWeight((item.weight or 1.0) * (item.quantity or 1))
      cb(true)
    else
      cb(false)
    end
  end

-- can pass -1 as quantity to remove item completely
  rTable.removeItem = function(item, quantity)
    item = (item.name or item)
    for i = 0, self.inventory.MAX_CAPACITY - 1 do
      if self.inventory.items[tostring(i)] then
        if self.inventory.items[tostring(i)].name:find(item) or self.inventory.items[tostring(i)].name == item then
          local newQuantity = self.inventory.items[tostring(i)].quantity - (quantity or 1)
          if ((quantity or 1) == -1) then
            newQuantity = 0
          end
          if newQuantity <= 0 then
            self.removeInventoryWeight((self.inventory.items[tostring(i)].weight or 1.0) * self.inventory.items[tostring(i)].quantity)
            self.inventory.items[tostring(i)] = nil
          else
            self.removeInventoryWeight((self.inventory.items[tostring(i)].weight or 1.0) * (quantity or 1))
            self.inventory.items[tostring(i)].quantity = newQuantity
          end
          return
        end
      end
    end
  end

  rTable.removeItemWithField = function(field, val)
    for i = 0, self.inventory.MAX_CAPACITY - 1 do
      if self.inventory.items[tostring(i)] then
        local item = self.inventory.items[tostring(i)]
        if item[field] then
          if item[field] == val then
            self.inventory.items[tostring(i)] = nil
            return
          end
        end
      end
    end
  end

  rTable.removeAllItems = function()
    for i = 0, self.inventory.MAX_CAPACITY - 1 do
      if self.inventory.items[tostring(i)] then
        self.removeInventoryWeight((self.inventory.items[tostring(i)].weight or 1.0) * self.inventory.items[tostring(i)].quantity)
        self.inventory.items[tostring(i)] = nil
      end
    end
  end

  rTable.removeItemByIndex = function(index, quantity)
    if self.inventory.items[tostring(index)] then
      local newQuantity = self.inventory.items[tostring(index)].quantity - quantity
      if (quantity == -1) then
        newQuantity = 0
      end
      if newQuantity <= 0 then
        self.removeInventoryWeight((self.inventory.items[tostring(index)].weight or 1.0) * self.inventory.items[tostring(index)].quantity)
        self.inventory.items[tostring(index)] = nil
      else
        self.removeInventoryWeight((self.inventory.items[tostring(index)].weight or 1.0) * quantity)
        self.inventory.items[tostring(index)].quantity = newQuantity
      end
    end
  end

  rTable.removeIllegalItems = function()
    local seized = {}
    local inv = self.inventory
    for i = 0, inv.MAX_CAPACITY - 1 do
      local item = inv.items[tostring(i)]
      if item then
        if item.legality == "illegal" then
          table.insert(seized, item)
          self.inventory.items[tostring(i)] = nil
          self.removeInventoryWeight((item.weight or 1.0) * (item.quantity or 1))
        end
      end
    end
    return seized
  end

  rTable.modifyItem = function(itemName, field, newVal)
    local n = (itemName.name or itemName)
    for i = 0, self.inventory.MAX_CAPACITY - 1 do
      if self.inventory.items[tostring(i)] then
        if self.inventory.items[tostring(i)].name:find(n) then
          self.inventory.items[tostring(i)][field] = newVal
          return
        end
      end
    end
  end

  rTable.moveItemSlots = function(from, to)
    from = tostring(from)
    to = tostring(to)
    local inv = self.inventory
    if inv.items[from] then
      if inv.items[to] then
        if not inv.items[to].notStackable and inv.items[to].name == inv.items[from].name then
          self.inventory.items[to].quantity = inv.items[to].quantity + inv.items[from].quantity
          self.inventory.items[from] = nil
        end
      else
        self.inventory.items[to] = inv.items[from]
        self.inventory.items[from] = nil
      end
    end
  end

  return rTable
end
