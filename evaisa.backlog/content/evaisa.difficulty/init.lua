get_content = ModTextFileGetContent

smallfolk = dofile("mods/evaisa.backlog/content/evaisa.difficulty/lib/smallfolk.lua")

ModLuaFileAppend("data/scripts/director_helpers.lua", "mods/evaisa.backlog/content/evaisa.difficulty/files/scripts/director_patch.lua")


damage_multipliers = nil

function OnMagicNumbersAndWorldSeedInitialized()
    print("Magic numbers initialized")
    if(not GameHasFlagRun("RunStartedDiff"))then
        local damage_multipliers_string = ModSettingGet("player_damage_mult")
        if(damage_multipliers_string)then
            damage_multipliers = smallfolk.loadsies(damage_multipliers_string)
        end
    end
    SessionNumbersSetValue( "DESIGN_SCALE_ENEMIES", "1" )
    dofile("mods/evaisa.backlog/content/evaisa.difficulty/files/scripts/biome_patcher.lua")
end

function OnWorldPreUpdate()
    dofile("mods/evaisa.backlog/content/evaisa.difficulty/files/scripts/spawn_director.lua")
end

function OnPlayerSpawned(player_entity)
    GameAddFlagRun("RunStartedDiff")
    if(damage_multipliers == nil)then

        damage_multipliers = {
        }

        local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
        if( damagemodels ~= nil ) then
            for i,damagemodel in ipairs(damagemodels) do
                
                damage_multipliers.melee = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "melee" ) )
                damage_multipliers.projectile = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ) )
                damage_multipliers.explosion = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ) )
                damage_multipliers.electricity = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "electricity" ) )
                damage_multipliers.fire = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "fire" ) )
                damage_multipliers.drill = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "drill" ) )
                damage_multipliers.slice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "slice" ) )
                damage_multipliers.ice = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "ice" ) )
                damage_multipliers.healing = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "healing" ) )
                damage_multipliers.physics_hit = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "physics_hit" ) )
                damage_multipliers.radioactive = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "radioactive" ) )
                damage_multipliers.poison = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "poison" ) )


            end

            ModSettingSet("player_damage_mult", smallfolk.dumpsies(damage_multipliers))
        end

        

    end
    
end