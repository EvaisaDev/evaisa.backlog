local entity_id = GetUpdatedEntityID()

local material_inventory_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "MaterialInventoryComponent")

local count_per_material_type = ComponentGetValue2( material_inventory_comp, "count_per_material_type");
local material = nil
for k,v in pairs(count_per_material_type) do
	if v ~= 0 then 
		local material_name = CellFactory_GetName(k-1)
		material = material_name
	end
end

if material == nil then
    EntityKill(entity_id)
end