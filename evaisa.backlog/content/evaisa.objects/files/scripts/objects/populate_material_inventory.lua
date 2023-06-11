dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/utilities.lua")

function init( entity_id )

    local variable_storage_components = EntityGetComponent(entity_id, "VariableStorageComponent")

    material_count = 1
    if(variable_storage_components ~= nil)then
        for k, variable_storage in pairs(variable_storage_components)do
            local name = ComponentGetValue2(variable_storage, "name")
            if(name == "material_count")then
                local value = ComponentGetValue2(variable_storage, "value_int")
                material_count = value
            end
        end
    end

	local x,y = EntityGetTransform( entity_id )
    SetRandomSeed( x..StatsGetValue("world_seed"),  y..StatsGetValue("world_seed") )
	--local materials = nil

    --[[materials = CellFactory_GetAllLiquids( false )
    
    table.remove_value(materials, "air")
    table.remove_value(materials, "creepy_liquid")
    table.remove_value(materials, "time_leak")]]

    local DamageModel = EntityGetFirstComponent(entity_id, "DamageModelComponent")

    local material_split = 1000 / material_count

    for i=1, material_count do
        local potion_material = random_from_array( materials )

        ComponentSetValue2(DamageModel, "blood_material", potion_material)
        AddMaterialInventoryMaterial( entity_id, potion_material, material_split )
    end
end