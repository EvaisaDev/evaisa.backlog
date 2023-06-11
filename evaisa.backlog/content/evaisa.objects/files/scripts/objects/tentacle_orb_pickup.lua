function item_pickup( entity_item, entity_pickupper, item_name )
    local entity_id = GetUpdatedEntityID()
    GamePrint("picked up")
    GlobalsSetValue("tentacle_"..entity_id.."_armedframe","no")
    GlobalsSetValue("tentacle_"..entity_id.."_feralframe","no")
end