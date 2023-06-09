local entity_id = GetUpdatedEntityID()

local projectile_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")

local shooter = ComponentGetValue2(projectile_comp, "mEntityThatShot")

if shooter == nil or not EntityGetIsAlive(shooter) then return end

local color = GameGetPotionColorUint( shooter )
if color ~= 0 then
    --[[local b = bit.rshift(bit.band(color, 0xFF0000), 16) / 0xFF
    local g = bit.rshift(bit.band(color, 0xFF00), 8) / 0xFF
    local r = bit.band(color, 0xFF) / 0xFF
]]
    local particle_emitter = EntityGetFirstComponentIncludingDisabled(entity_id, "ParticleEmitterComponent")

    ComponentSetValue2(particle_emitter, "color", color)
end

--[[
local material_inventory_comp = EntityGetFirstComponentIncludingDisabled(shooter, "MaterialInventoryComponent")

local count_per_material_type = ComponentGetValue2( material_inventory_comp, "count_per_material_type");

for k,v in pairs(count_per_material_type) do
	if v ~= 0 then 
		local material_name = CellFactory_GetName(k-1)
		
	end
end
]]

