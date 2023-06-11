local particles = EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")
for k, particle in pairs(particles)do
    
    if(GlobalsGetValue(entity_id.."_emit_frame", "no") ~= "no")then
        GlobalsSetValue(entity_id.."_emit_frame", GameGetFrameNum())
       -- EntitySetComponentIsEnabled(entity_id, particle, false)
       ComponentSetValue2(particle, "is_emitting", true)
    end

end

local particles = EntityGetComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")
for k, particle in pairs(particles)do
    

    if(GlobalsGetValue(entity_id.."_emit_frame", "no") ~= "no")then
        local frame_diff = GameGetFrameNum() - tonumber(GlobalsGetValue(entity_id.."_emit_frame", "no"))

        if(frame_diff > 60)then
            GlobalsSetValue(entity_id.."_emit_frame", "no")
            ComponentSetValue2(particle, "is_emitting", false)
           -- EntitySetComponentIsEnabled(entity_id, particle, false)
        end
    end
end

