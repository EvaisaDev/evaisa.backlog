local entity_id = GetUpdatedEntityID()

--GamePrint("yee")

function GetOffset()
    local x = 0
    local y = 0
    local offset = EntityGetComponentIncludingDisabled(entity_id, "VariableStorageComponent")
    if offset ~= nil then
        for i, v in ipairs(offset) do
            local name = ComponentGetValue(v, "name")
            if name == "mm_x_offset" then
                x = ComponentGetValue(v, "value_int")
            elseif name == "mm_y_offset" then
                y = ComponentGetValue(v, "value_int")
            end
        end
    end
    return x, y
end

local offset_x, offset_y = GetOffset()

local projectile_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")
if projectile_comp ~= nil then
    local who_shot = ComponentGetValue2(projectile_comp, "mWhoShot")
    if who_shot ~= nil then
        local controls_comp = EntityGetFirstComponentIncludingDisabled(who_shot, "ControlsComponent")
        if controls_comp ~= nil then
            local mouse_x, mouse_y = ComponentGetValue2(controls_comp, "mMousePosition")
            EntitySetTransform(entity_id, mouse_x - 4 + offset_x, mouse_y - 4 + offset_y)
            EntityApplyTransform(entity_id, mouse_x - 4 + offset_x, mouse_y - 4 + offset_y)
        end
    end
end

