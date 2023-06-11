dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/utilities.lua")

local entity_id = GetUpdatedEntityID()

--local x,y = EntityGetTransform( entity_id )
--SetRandomSeed( x..StatsGetValue("world_seed"),  y..StatsGetValue("world_seed") )
--local materials = nil

--materials = CellFactory_GetAllLiquids( false )



--[[
    table.remove_value(materials, "air")
    table.remove_value(materials, "creepy_liquid")
    table.remove_value(materials, "time_leak")
    table.remove_value(materials, "killer_goo")
    table.remove_value(materials, "poly_goo")
    table.remove_value(materials, "hot_goo")
    table.remove_value(materials, "alt_killer_goo")
    table.remove_value(materials, "alt_corruption")
    table.remove_value(materials, "corruption")
    table.remove_value(materials, "killer_goo_solid")
    table.remove_value(materials, "AA_MAT_BLOOM_ROOF_DEAD")
    table.remove_value(materials, "AA_MAT_BLOOM_ROOF_PLANT")
    table.remove_value(materials, "AA_MAT_BLOOM_LIQUID")
    table.remove_value(materials, "AA_MAT_BLOOM_GAS")
    table.remove_value(materials, "AA_MAT_BLOOM_MAGIC")
    table.remove_value(materials, "AA_MAT_BLOOM_ROOF")
    table.remove_value(materials, "AA_MAT_BLOOM")
    table.remove_value(materials, "fire")
    table.remove_value(materials, "plasma_fading")
    table.remove_value(materials, "silver_molten")
    table.remove_value(materials, "copper_molten")
    table.remove_value(materials, "brass_molten")
    table.remove_value(materials, "glass_molten")
    table.remove_value(materials, "glass_broken_molten")
    table.remove_value(materials, "steel_molten")
    table.remove_value(materials, "wax_molten")
    table.remove_value(materials, "slush")
    table.remove_value(materials, "vomit")
    table.remove_value(materials, "moss")
    table.remove_value(materials, "cement")
    table.remove_value(materials, "water_swamp")
    table.remove_value(materials, "swamp")
    table.remove_value(materials, "concrete_sand")
    table.remove_value(materials, "sodium_unstable")
    table.remove_value(materials, "gunpowder_unstable")
]]

local convert_material = random_from_array( materials )

local components = EntityGetComponent( entity_id, "MagicConvertMaterialComponent")
for k, component in pairs(components)do
    ComponentSetValue2(component, "to_material", CellFactory_GetType( convert_material ) )
end