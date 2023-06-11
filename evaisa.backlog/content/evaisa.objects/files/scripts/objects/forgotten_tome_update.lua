local entity = GetUpdatedEntityID()

if(EntityHasTag(entity, "tome_active"))then
    local x, y = EntityGetTransform(entity)

    local speed = 0.6

    local target_x = tonumber(GlobalsGetValue(entity.."_x"))
    local target_y = tonumber(GlobalsGetValue(entity.."_y"))

    local direction_x = target_x - x

    local direction_y = target_y - y


    local velocity_component = EntityGetFirstComponent(entity, "VelocityComponent")

    if(velocity_component ~= nil)then
        local velocity_x, velocity_y = ComponentGetValueVector2( velocity_component, "mVelocity")

		local len = math.sqrt((direction_x*direction_x) + (direction_y*direction_y))

		local dir_x = direction_x / len
		local dir_y = direction_y / len

		local force_x = (velocity_x * 0.96) + (dir_x * speed)
		local force_y = (velocity_y * 0.96) + (dir_y * speed)
		
		ComponentSetValue2( velocity_component, "mVelocity", force_x, force_y )
    end

    if(GlobalsGetValue("tome_"..entity.."_first_frame", "no") == "no")then
        GlobalsSetValue("tome_"..entity.."_first_frame", GameGetFrameNum())
    else
        local frame_diff = GameGetFrameNum() - tonumber(GlobalsGetValue("tome_"..entity.."_first_frame", "no"))
        if(EntityHasTag(entity, "play_animation") == false)then
            
            if(frame_diff > 70)then
                EntityAddTag(entity, "play_animation")
                --GlobalsSetValue("tome_"..entity.."_speed", "1")
                           

                local sprite_component = EntityGetFirstComponent(entity, "SpriteComponent")

                EntityRemoveComponent(entity, velocity_component)
                --EntityRemoveComponent(entity, sprite_component)

                --EntitySetTransform(entity, x, y - 1, 0)

                local sprite_component = EntityGetFirstComponent(entity, "SpriteComponent")

                ComponentSetValue2(sprite_component, "offset_y", 5.5)

                local item_component = EntityAddComponent2(entity, "ItemComponent", {
                    is_pickable=false,
                    play_hover_animation=true,
                })

            end
        else
            EntitySetTransform(entity, x, y, 0)
            if(frame_diff > 120)then
                EntityAddTag(entity, "spawn_spells")
            end

            if(EntityHasTag(entity, "spawn_spells"))then
                if(frame_diff > 40)then
                    GlobalsSetValue("tome_"..entity.."_first_frame", GameGetFrameNum())
                    local spells_spawned = tonumber(GlobalsGetValue(entity.."_spells_spawned", "0"))
                    if(spells_spawned < 5)then
                        GlobalsSetValue(entity.."_spells_spawned", spells_spawned + 1)

                        SetRandomSeed( x..StatsGetValue("world_seed"),  y..StatsGetValue("world_seed") )

                        local chosen_action = GetRandomAction( x, y, Random( 0, 6 ), 0 );
                        local action = CreateItemActionEntity( chosen_action, x, y );
                        EntitySetComponentsWithTagEnabled( action,  "enabled_in_world", true );
                        EntitySetComponentsWithTagEnabled( action,  "item_unidentified", false );
                        local velocity = EntityGetFirstComponent( action, "VelocityComponent" );
                        if velocity ~= nil then
                            ComponentSetValueVector2( velocity, "mVelocity", math.random(-140, 140), -math.random(75, 100) );
                        end
                    else
                        local projectile_component = EntityGetFirstComponent(entity, "ProjectileComponent")
                        ComponentSetValue2(projectile_component,"lifetime", 1)
                        EntityKill(entity)
                    end
                end
            end
        end

    end 
end