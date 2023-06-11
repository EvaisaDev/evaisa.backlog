function item_pickup( entity_item, entity_pickupper, item_name )
    local player = entity_pickupper
    local x,  y = EntityGetTransform(player)
    local hat = EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/cowboy_hat/hat_entity.xml", x, y)

    EntityAddComponent( player, "ShotEffectComponent", 
    { 
        extra_modifier = "high_noon",
    } )
    

    EntityAddChild(player, hat)
    GlobalsSetValue(entity_item.."_hat_entity", tostring(hat))
    GlobalsSetValue(entity_item.."_player_entity", tostring(player))
    GameSetPostFxParameter( "enable_western", 1.0, 1.0, 1.0, 1.0)
end