Game.AddCommand('debuglesshasslepets', 'Debug LessHasslePets', function()
    for _, char in pairs(Character.CharacterList) do
        if char.IsInPlayerSub and char.IsPet then
            print(char.ID .. " " .. char.Name)
            print(char.Health)
            print(char.AIController.PetBehavior.playForce)
        end
    end
end, nil, true)

Game.AddCommand('setpethunger', 'Set pet hunger', function(args)
    local hunger = tonumber(args[1])
    if not hunger then
        print("Invalid hunger value")
        return
    end

    for _, char in pairs(Character.CharacterList) do
        if char.IsInPlayerSub and char.IsPet then
            char.AIController.PetBehavior.hunger = hunger
        end
    end
end, nil, true)

Game.AddCommand('preptestlesshasslepets', 'Spawn all pet types', function()
    Game.ExecuteCommand('spawncharacter balloon cursor')
    Game.ExecuteCommand('spawncharacter orangeboy cursor')
    Game.ExecuteCommand('spawncharacter peanut cursor')
    Game.ExecuteCommand('spawncharacter psilotoad cursor')
    Game.ExecuteCommand('spawnitem screwdriver inventory')
    Game.ExecuteCommand('spawnitem Pomegrenade inventory 32')
end, nil, true)
