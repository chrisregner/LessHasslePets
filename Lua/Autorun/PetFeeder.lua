local descriptor = LuaUserData.RegisterType("BaroMod_sjx.ConditionStorage")

function debugPrint(message)
    -- print('LHP Petfeeder: ' .. message)
end

local storageCache = {}
local function getContainedQuantity(containerComponent)
    local totalCount = 0

    -- Get all physical items recursively
    local allItems = containerComponent.Inventory.FindAllItems(nil, true)
    debugPrint("Total physical items found in Inventory: " .. #allItems)

    for i, item in pairs(allItems) do
        debugPrint(string.format("Iterating item [%d]: %s", i, tostring(item.Prefab.Identifier.Value)))

        -- Standard Leaf Item Check:
        -- If it has no inventory, it's a "real" item (like a single fruit).
        if item.OwnInventory == nil then
            totalCount = totalCount + 1
            debugPrint("  + Leaf item detected. New totalCount: " .. totalCount)
        else
            debugPrint("  - Item has OwnInventory; skipping leaf increment.")
            

            -- StackBox Support:
            -- Check if this specific item has the virtual storage component.
            if storageCache[item.ID] == nil then    
                storageCache[item.ID] = false

                for _, c in pairs(item.Components) do
                    if (c.Name == 'ConditionStorage') then
                        storageCache[item.ID] = c
                        break
                    end
                end

                debugPrint("  - Cache miss for ID " .. item.ID .. ". Value: " .. (storageCache[item.ID] ~= false and storageCache[item.ID].Name or "false"))
            else
                debugPrint("  - Cache hit for ID " .. item.ID .. ". Value: " .. (storageCache[item.ID] ~= false and storageCache[item.ID].Name or "false"))
            end

            local cs = storageCache[item.ID]

            if (cs) then
                local ConditionStorage = LuaUserData.CreateStatic("BaroMod_sjx.ConditionStorage")
                local storage = ConditionStorage.GetFromInventory(item.OwnInventory)
                local currentItemCount = storage.currentItemCount
                
                -- Add the virtual count (items that were 'consumed' into the stack)
                totalCount = totalCount + currentItemCount
                debugPrint(string.format("  + ConditionStorage detected. Adding virtual count: %d. New totalCount: %d", currentItemCount, totalCount))
            else
                debugPrint("  - No ConditionStorage component found.")
            end
        end
    end

    debugPrint("Final calculated totalCount: " .. totalCount)
    return totalCount
end

Hook.Add('petfeeder', 'petfeeder', function(effect, deltaTime, petfeeder, targets, worldPosition, element)
    local container = petfeeder and petfeeder.GetComponentString('ItemContainer')

    if container == nil then
        -- debugPrint('PetFeeder: No container found')
        return
    end

    local quantity = getContainedQuantity(container)
    debugPrint('PetFeeder: Container has ' .. quantity .. ' items')

    petfeeder.SendSignal(quantity, 'quantity')
end)
