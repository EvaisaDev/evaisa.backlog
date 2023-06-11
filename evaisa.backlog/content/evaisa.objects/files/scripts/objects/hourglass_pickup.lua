function item_pickup( entity_item, entity_pickupper, item_name )
    print("picked up!")
    local item = entity_item
    local lua_comps = EntityGetComponentIncludingDisabled( item, "LuaComponent", "sands_active" )
    if( lua_comps ~= nil ) then
        for i,lua_comp in ipairs(lua_comps) do
            ComponentAddTag( lua_comp, "enabled_in_world" )
            ComponentRemoveTag( lua_comp, "sands_active" )
            --EntitySetComponentIsEnabled( item, lua_comp, true )
            --print("enabled component")
        end
    end
end