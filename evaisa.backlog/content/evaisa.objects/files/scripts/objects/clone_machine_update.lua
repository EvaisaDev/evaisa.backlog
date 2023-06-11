local entity = GetUpdatedEntityID()

if(EntityHasTag(entity, "machine_active"))then
    local x, y = EntityGetTransform(entity)

    local player = tonumber(GlobalsGetValue(entity.."_who_interacted", "0"))

    if(GlobalsGetValue(entity.."_first_frame", "no") == "no")then
        GlobalsSetValue(entity.."_first_frame", GameGetFrameNum())

        if(player ~= 0)then
            if(EntityGetIsAlive(player))then
                local sprite_components = EntityGetComponentIncludingDisabled(player, "SpriteComponent")
                local controls_components = EntityGetComponentIncludingDisabled(player, "ControlsComponent")
                for k, v in pairs(sprite_components)do
                    EntitySetComponentIsEnabled( player, v, false )
                end
                for k, v in pairs(controls_components)do
                    EntitySetComponentIsEnabled( player, v, false )
                end
            end
        end

    else
        local frame_diff = GameGetFrameNum() - tonumber(GlobalsGetValue(entity.."_first_frame", "no"))

        if(frame_diff > 90)then

            if(player ~= 0)then
                if(EntityGetIsAlive(player))then
                    local sprite_components = EntityGetComponentIncludingDisabled(player, "SpriteComponent")
                    local controls_components = EntityGetComponentIncludingDisabled(player, "ControlsComponent")
                    for k, v in pairs(sprite_components)do
                        EntitySetComponentIsEnabled( player, v, true )
                    end
                    for k, v in pairs(controls_components)do
                        EntitySetComponentIsEnabled( player, v, true )
                    end
                end
            end

        end
    end 
end