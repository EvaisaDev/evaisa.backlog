function throw_item( from_x, from_y, to_x, to_y )
    local entity_id = GetUpdatedEntityID()
    --GamePrint("thrown")
    GlobalsSetValue("tentacle_"..entity_id.."_armedframe","no")
    GlobalsSetValue("tentacle_"..entity_id.."_feralframe",GameGetFrameNum())
end