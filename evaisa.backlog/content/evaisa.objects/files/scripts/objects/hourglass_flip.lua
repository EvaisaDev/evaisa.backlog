local entity_id = GetUpdatedEntityID()

local x, y, rad = EntityGetTransform(entity_id)

local physics_body = EntityGetFirstComponent(entity_id, "PhysicsBodyComponent")

if(physics_body ~= nil)then
    local ang_vel = PhysicsGetComponentAngularVelocity( entity_id, physics_body )

    local children = EntityGetAllChildren( entity_id )

    local is_active = false

    if(children ~= nil)then
        for k,v in pairs(children)do
            if(EntityHasTag(v, "hourglass_effect"))then

                is_active = true
            end
        end
    end


    if(is_active == false)then
        if(ang_vel > 0.2 or ang_vel < -0.2)then
            if(GlobalsGetValue("hourglass_"..entity_id.."_armedframe", "no") == "no")then
                GlobalsSetValue("hourglass_"..entity_id.."_armedframe", GameGetFrameNum())
            else
                local frame_diff = GameGetFrameNum() - tonumber(GlobalsGetValue("hourglass_"..entity_id.."_armedframe", "no"))
                if(frame_diff > 30)then
                    EntityAddTag(entity_id, "hourglass_armed")
                end
            end 
        else
            if(EntityHasTag(entity_id, "hourglass_armed") ~= true)then
                GlobalsSetValue("hourglass_"..entity_id.."_armedframe", "no")
            else
                if(GlobalsGetValue("hourglass_"..entity_id.."_armedframe", "no") ~= "no")then
                    local effect = EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/sands_of_time/hourglass_effect.xml", x, y)
                    EntityAddChild( entity_id, effect )
                    EntityRemoveTag(entity_id, "hourglass_armed")
                end                
            end
        end
    end
end