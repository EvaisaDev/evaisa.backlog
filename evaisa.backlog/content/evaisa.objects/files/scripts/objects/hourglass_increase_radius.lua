local entity_id = GetUpdatedEntityID()

local x, y, rad = EntityGetTransform(entity_id)

local physics_body = EntityGetFirstComponent(entity_id, "PhysicsBodyComponent")

if(physics_body ~= nil)then

    local children = EntityGetAllChildren( entity_id )

    if(children ~= nil)then
        for k,v in pairs(children)do
            if(EntityHasTag(v, "hourglass_effect"))then
                local components = EntityGetComponent(v, "MagicConvertMaterialComponent")
                for k, component in pairs(components)do
                    local old_radius = ComponentGetValue2(component, "radius")
                    if(old_radius < 126)then
                        ComponentSetValue2(component, "radius", old_radius + 1)
                    else
                        local effect = EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/sands_of_time/convert_hourglass.xml", x, y)
                        EntityAddChild( entity_id, effect )
                        EntityKill(v)
                    end
                end
            end
        end
    end

end