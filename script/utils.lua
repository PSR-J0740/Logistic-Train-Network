--[[ Copyright (c) 2017 Optera
 * Part of Logistics Train Network
 * Control stage utility functions
 *
 * See LICENSE.md in the project directory for license information.
--]]

--GetTrainCapacity(train)
local function getCargoWagonCapacity(entity)
  local capacity = entity.prototype.get_inventory_size(defines.inventory.cargo_wagon)
  -- log("(getCargoWagonCapacity) capacity for "..entity.name.." = "..capacity)
  storage.WagonCapacity[entity.name] = capacity
  return capacity
end

local function getFluidWagonCapacity(entity)
  local capacity = entity.prototype.fluid_capacity
  -- log("(getFluidWagonCapacity) capacity for "..entity.name.." = "..capacity)
  storage.WagonCapacity[entity.name] = capacity
  return capacity
end

-- returns inventory and fluid capacity of a given train
function GetTrainCapacity(train)
  local inventorySize = 0
  local fluidCapacity = 0
  if train and train.valid then
    for _,wagon in pairs(train.cargo_wagons) do
      local capacity = storage.WagonCapacity[wagon.name] or getCargoWagonCapacity(wagon)
      inventorySize = inventorySize + capacity
    end
    for _,wagon in pairs(train.fluid_wagons) do
      local capacity = storage.WagonCapacity[wagon.name] or getFluidWagonCapacity(wagon)
      fluidCapacity = fluidCapacity + capacity
    end
  end
  return inventorySize, fluidCapacity
end

-- returns rich text string for train stops, or nil if entity is invalid
function Make_Stop_RichText(entity)
  if entity and entity.valid then
    if message_include_gps then
      return format("[train-stop=%d] [gps=%s,%s,%s]", entity.unit_number, entity.position["x"], entity.position["y"], entity.surface.name)
    else
      return format("[train-stop=%d]", entity.unit_number)
    end
  else
    return nil
  end
end

-- returns rich text string for trains, or nil if entity is invalid
function Make_Train_RichText(train, train_name)
  local loco = Get_Main_Locomotive(train)
  if loco and loco.valid then
    return format("[train=%d] %s", loco.unit_number, train_name or loco.backer_name)
  else
    return format("[train=] %s", train_name)
  end
end

-- same as flib.get_or_insert(a_table, key, {}) but avoids the garbage collector overhead of passing an empty table that isn't used when the key exists
function Get_Or_Create(a_table, key)
  local subtable = a_table[key]
  if not subtable then
    subtable = {}
    a_table[key] = subtable
  end
  return subtable
end

-- Convert old color into the new one for migration
function OldColor(color)
  if color then
    if isValidOldColor(color.r) and isValidOldColor(color.g) and isValidOldColor(color.b) and isValidOldColor(color.a) then
      local rgb = (color.r * 16711680 + color.g * 65280 + color.b * 255) * color.a
      return rgb
    end
  end
  return 0
end
function isValidOldColor(value)
  return value == 0 or value == 1
end