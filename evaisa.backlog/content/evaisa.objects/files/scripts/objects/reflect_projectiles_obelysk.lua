dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 50

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

-- attract various entities

local particles = EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")
for k, particle in pairs(particles)do
    

    if(GlobalsGetValue(entity_id.."_emit_frame", "no") ~= "no")then
        local frame_diff = GameGetFrameNum() - tonumber(GlobalsGetValue(entity_id.."_emit_frame", "no"))

        if(frame_diff > 10)then
            GlobalsSetValue(entity_id.."_emit_frame", "no")
            ComponentSetValue2(particle, "is_emitting", false)
           -- EntitySetComponentIsEnabled(entity_id, particle, false)
        end
    end
end

local entities = EntityGetInRadiusWithTag(x, y, distance_full, "projectile")
if ( #entities == 0 ) then return end



--if(tonumber(GlobalsGetValue(entity_id.."_max_uses", "50")) > 0)then
for _,id in ipairs(entities) do	
    if(EntityHasTag(id, "returned_projectile_obelysk") ~= true)then
        local velocity_component = EntityGetFirstComponent(id, "VelocityComponent")
        if(velocity_component ~= nil)then
            local velocity_x, velocity_y = ComponentGetValueVector2( velocity_component, "mVelocity")


            
            -- GlobalsSetValue(entity_id.."_max_uses", tostring(tonumber(GlobalsGetValue(entity_id.."_max_uses", "50")) - 1))
        
            

            local particles = EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")
            for k, particle in pairs(particles)do
                if(GlobalsGetValue(entity_id.."_emit_frame", "no") == "no")then
                    GlobalsSetValue(entity_id.."_emit_frame", GameGetFrameNum())
                   -- GamePrint(GlobalsGetValue(entity_id.."_emit_frame", "no"))
                    ComponentSetValue2(particle, "is_emitting", true)
                end
            end

           -- GamePrint("Projectile returned to sender")
            EntityAddTag(id, "returned_projectile_obelysk")
            local force_x = -velocity_x
            local force_y = -velocity_y

            local projectile_component = EntityGetFirstComponent(id, "ProjectileComponent")

            if(projectile_component ~= nil)then
                ComponentSetValue2(projectile_component, "friendly_fire", true)
                ComponentSetValue2(projectile_component, "collide_with_shooter_frames", 1)
                EntityAddComponent(id, "HomingComponent", {
                    target_who_shot="1",
                    detect_distance="150",
                    homing_targeting_coeff="160",
                })
            end

            
            ComponentSetValue2( velocity_component, "mVelocity", force_x, force_y )

        end
    end
end

