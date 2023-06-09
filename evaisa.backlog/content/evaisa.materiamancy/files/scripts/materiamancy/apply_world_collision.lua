local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")

local penetrate_coeff = ComponentGetValue2(projectile_comp, "penetrate_world_velocity_coeff")

penetrate_coeff = penetrate_coeff - 0.05

if(penetrate_coeff < 0)then
    penetrate_coeff = 0
    ComponentSetValue2(projectile_comp, "penetrate_world", false)
    ComponentSetValue2(projectile_comp, "on_collision_die", true)
else
    ComponentSetValue2(projectile_comp, "penetrate_world_velocity_coeff", penetrate_coeff)
end
