dofile("mods/evaisa.backlog/content/evaisa.objects/files/scripts/objects/ring_perks.lua")

function item_pickup( entity_item, entity_pickupper, item_name )
    local entity_id = entity_item

    GlobalsSetValue(entity_id.."_current_owner", tostring(entity_pickupper))

    local storage = EntityGetComponent(entity_id, "VariableStorageComponent")

    local id = GlobalsGetValue(entity_id.."_perk_id", "")

    --GamePrint(id)
    if(id ~= "")then
        for k, v in pairs(ring_perks)do
            if(v.id == id)then
                if(v.game_effect ~= nil)then
                   -- GamePrint(v.game_effect)
                   -- GamePrint("Game Effect Added")
                    local game_effect_comp = GetGameEffectLoadTo( entity_pickupper, v.game_effect, true )

                    GlobalsSetValue(entity_id.."_game_effect_comp", tostring(game_effect_comp))

                end
                --GamePrint("Function ran")
                if(v.perk_add_func ~= nil)then
                 --   GamePrint("Function ran")
                    v.perk_add_func(entity_pickupper)
                end
            end
        end
    end
end