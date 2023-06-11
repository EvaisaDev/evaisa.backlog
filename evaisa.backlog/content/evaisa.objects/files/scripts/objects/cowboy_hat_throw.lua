function throw_item( from_x, from_y, to_x, to_y )
    local entity_id = GetUpdatedEntityID()
    hat = tonumber(GlobalsGetValue(entity_id.."_hat_entity", ""))
    player = tonumber(GlobalsGetValue(entity_id.."_player_entity", ""))


    if(hat ~= nil)then
        EntityKill(hat)
        if(player ~= nil)then
            local extra_components = EntityGetComponentIncludingDisabled(player, "ShotEffectComponent")
            for k, v in pairs(extra_components)do
                local modifier = ComponentGetValue2(v, "extra_modifier")
                if(modifier == "high_noon")then
                    EntityRemoveComponent(player, v)
                    break
                end
            end
        end
    end
    GameSetPostFxParameter( "enable_western", 0.0, 0.0, 0.0, 0.0)
end