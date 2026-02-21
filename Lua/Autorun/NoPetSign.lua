local SteeringManagerDescriptor = LuaUserData.RegisterType("Barotrauma.SteeringManager")
LuaUserData.MakeFieldAccessible(SteeringManagerDescriptor, "host")
local IndoorsSteeringManagerDescriptor = LuaUserData.RegisterType("Barotrauma.IndoorsSteeringManager")
LuaUserData.MakeFieldAccessible(IndoorsSteeringManagerDescriptor, "host")
LuaUserData.RegisterType("Barotrauma.BackgroundCreature")


local noPetSigns = {}

Hook.Add('item.created', 'trackNewNoPetSign', function(item)
    if item.Prefab.Identifier == 'nopetsign' then
        noPetSigns[item.ID] = item
    end
end)

Hook.Add('item.removed', 'removeNoPetSign', function(item)
    if item.Prefab.Identifier == 'nopetsign' then
        noPetSigns[item.ID] = nil
    end
end)

Game.AddCommand('lhp_reloadnopetsigns', '', function()
    local count = 0

    for _, item in pairs(Item.ItemList) do
        if item.Prefab.Identifier == 'nopetsign' then
            noPetSigns[item.ID] = item
            count = count + 1
        end
    end

    -- print('loaded ' .. count .. ' no pet signs')
end)

-- Prevent pets from "drifting" into the zone while idling/wandering
Hook.Patch(
    "NoPetSignUltimateStop", "Barotrauma.SteeringManager", "Update", {"System.Single"},
    function(instance, ptable)
        if (LuaUserData.TypeOf(instance.host) ~= "Barotrauma.EnemyAIController") then return end

        local character = instance.host.Character
        -- print('NoPetSignUltimateStop ' .. character.Name)

        if character == nil or not character.IsPet then return end

        local avoidDistance = 120

        for _, item in pairs(noPetSigns) do
            if item.GetComponentString('Holdable').IsAttached then
                local distSq = Vector2.DistanceSquared(item.WorldPosition, character.WorldPosition)
                local avoidSq = avoidDistance * avoidDistance

                -- print(character.Name .. ' Update distSq:', distSq)

                if distSq < avoidSq then
                    -- print(character.Name .. ' Update prevented')

                    local awayDir = Vector2.Normalize(character.WorldPosition - item.WorldPosition)
                    instance.SteeringManual(ptable["speed"], awayDir * 5)
                    return
                end
            end
        end
    end, Hook.HookMethodType.Before)
