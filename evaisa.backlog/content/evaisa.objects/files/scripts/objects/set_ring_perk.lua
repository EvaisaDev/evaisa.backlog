dofile("mods/evaisa.backlog/content/evaisa.objects/files/scripts/objects/ring_perks.lua")
dofile_once("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/utilities.lua")

local entity_id = GetUpdatedEntityID()

local x, y = EntityGetTransform(entity_id)

local random_perk = random_perk(x, y)

EntityAddComponent(entity_id, "VariableStorageComponent", {
    name="perk_id",
    value_string=random_perk.id
})

GlobalsSetValue(entity_id.."_perk_id", tostring(random_perk.id))

EntityAddComponent(entity_id, "ItemComponent", {
    _tags="enabled_in_world",
    item_name="Anomalous Ring",
    ui_description=random_perk.ui_description,
    ui_sprite="mods/evaisa.backlog/content/evaisa.objects/files/entities/perk_ring/perk_ring_ui.png",
    max_child_items="0",
    is_pickable="1",
    is_equipable_forced="1",
    preferred_inventory="QUICK",
})
