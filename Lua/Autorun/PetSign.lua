function movePetsToPetSign()
    local spawnpoint
    for _, item in pairs(Item.ItemList) do
        local holdable = item.GetComponentString('Holdable')

        if (
                item.Prefab.Identifier == 'petsign'
                and holdable ~= nil
                and holdable.IsAttached
            ) then
            spawnpoint = item.WorldPosition
        end
    end

    if (spawnpoint ~= nil) then
        for _, char in pairs(Character.CharacterList) do
            -- if (char.IsInPlayerSub) then
            --     print("Found character in player sub: " .. char.Name)
            -- end

            -- if (char.IsPet) then
            --     print("Found pet: " .. char.Name)
            -- end

            if char.IsInPlayerSub and char.IsPet then
                char.TeleportTo(spawnpoint)
                -- print("Moved pet" .. char.Name .. " to pet station")
            end
        end
    end
end

Hook.Add('roundStart', 'MovePetsToPetSign', function()
    movePetsToPetSign()
end)

Game.AddCommand('movepetstopetsign', 'Move all pets to the pet station', function()
    movePetsToPetSign()
end, nil, true)
