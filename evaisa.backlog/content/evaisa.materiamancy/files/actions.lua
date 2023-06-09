table.insert(actions, {
    id          = "MATERIAMANCY",
    name         = "Materiamancy",
    description = "The world is your weapon.",
    sprite         = "mods/evaisa.backlog/content/evaisa.materiamancy/files/action_icon.png",
    sprite_unidentified = "data/ui_gfx/gun_actions/damage_unidentified.png",
    related_projectiles    = {},
    type         = ACTION_TYPE_PROJECTILE,
    spawn_level                       = "0,1,2,4,5,6",
    spawn_probability                 = "1,1,1,1,1,1",
    price = 150,
    mana = 60,
    -- max_uses = 1,
    action         = function()
        if reflecting then
            return
        end

        local caster = GetUpdatedEntityID()
        local controls_component = EntityGetFirstComponentIncludingDisabled(caster, "ControlsComponent")
        if controls_component ~= nil then
            local shooting_start = ComponentGetValue2(controls_component, "mButtonFrameFire")
            if GameGetFrameNum() == shooting_start then
                local old_c = c
                c = {}
                reset_modifiers( c )
                for x = 1, 8 do
                    for y = 1, 8 do
                        local distance = math.sqrt((x - 4.5) ^ 2 + (y - 4.5) ^ 2)
                        if distance <= 4 then

                            -- Create trigger projectile
                            BeginProjectile("mods/evaisa.backlog/content/evaisa.materiamancy/files/entities/materiamancy/trigger_projectile.xml")

                                BeginTriggerDeath()

                                    -- Create handler with positional xml
                                    BeginProjectile("mods/evaisa.backlog/content/evaisa.materiamancy/files/entities/materiamancy/handler_projectile.xml")

                                        BeginTriggerTimer(Random(30, 120))



                                            BeginProjectile("mods/evaisa.backlog/content/evaisa.materiamancy/files/entities/materiamancy/projectile.xml")
                   
                                            EndProjectile()

                                            -- Clear c
                                            c = {}
                                            reset_modifiers( c )

                                            -- Clone modifiers
                                            for k,v in pairs(old_c) do
                                                c[k] = v
                                            end
                                            register_action( c )
                                            SetProjectileConfigs()
                                        EndTrigger()

                                    EndProjectile()


                                    -- Clear c
                                    c = {}
                                    reset_modifiers( c )

                                    -- Add crappy hardcoded position xmls
                                    c.extra_entities = table.concat{
                                        c.extra_entities,
                                        table.concat{
                                            "mods/evaisa.backlog/content/evaisa.materiamancy/files/entities/materiamancy/offsets/",
                                            tostring(x),
                                            "_",
                                            tostring(y),
                                            ".xml,",
                                        },
                                        "mods/evaisa.backlog/content/evaisa.materiamancy/files/entities/materiamancy/lua.xml,"
                                    }

                                    -- Register and add c to the handler
                                    register_action( c )
                                    SetProjectileConfigs()

                                EndTrigger()

                            EndProjectile()

                        end
                    end
                end
                c = old_c
            end
        end
    end,
})