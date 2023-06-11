dofile("mods/evaisa.backlog/content/evaisa.objects/files/scripts/objects/ring_perks.lua")
function throw_item( from_x, from_y, to_x, to_y )
    local entity_id = GetUpdatedEntityID()
    GamePrint("thrown")

    local owner_id = GlobalsGetValue(entity_id.."_current_owner", "")
    local game_effect_comp = GlobalsGetValue(entity_id.."_game_effect_comp", "")
    local id = GlobalsGetValue(entity_id.."_perk_id", "")

    if(owner_id ~= "")then
       -- GamePrint("Owner Exists")
        if(game_effect_comp ~= "")then
            GlobalsSetValue(entity_id.."_current_owner", "")
            GlobalsSetValue(entity_id.."_game_effect_comp", "")
            EntityRemoveComponent(tonumber(owner_id), tonumber(game_effect_comp))
        end
        for k, v in pairs(ring_perks)do
            if(v.id == id)then
                if(v.perk_remove_func ~= nil)then
                 --   GamePrint("Remove Function Ran")
                    v.perk_remove_func(owner_id)
                end
            end
        end
    end
end