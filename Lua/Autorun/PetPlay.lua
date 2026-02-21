Hook.Patch("Barotrauma.PetBehavior", "Play", function(instance, ptable)
    -- 'instance' is the PetBehavior object
    -- We set the Happiness field/property to 100.0
    instance.Happiness = 100.0

    -- Optional: Logging to console to verify it worked
    -- print("Pet is now max happy!")
end, Hook.HookMethodType.After)
