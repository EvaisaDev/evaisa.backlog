local EZWand = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/EZWand/EZWand.lua")
local smallfolk = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/smallfolk.lua")

local function entity_is_wand(entity_id)
	local comp = EntityGetComponentIncludingDisabled(entity_id, "ManaReloaderComponent")
	return comp ~= nil
end

local function get_player_spells()
    local items = {}
    local inventory_items = EntityGetAllChildren(EntityGetWithName("inventory_full"))
    if(inventory_items ~= nil) then
        for i,item in ipairs(inventory_items) do
			local item_action_component = EntityGetFirstComponentIncludingDisabled(item, "ItemActionComponent")
			if item_action_component then
			  local val = ComponentGetValue2(item_action_component, "action_id")
			  local action_id = val
			  table.insert(items, action_id)
			end
        end
    end
    return items
end

local function get_player_wands()
	local inventory = EntityGetWithName("inventory_quick")
	local wands = {}
	for i, entity_id in ipairs(EntityGetAllChildren(inventory) or {}) do
		if entity_is_wand(entity_id) then
			table.insert(wands, EZWand(entity_id))
		end
	end
	return wands
end

local function get_player()
    local players = EntityGetWithTag("player_unit")
    if #players == 0 then return end

    return players[1]
end

local function store_loadout(x, y)
	local max_storage = ModSettingGet("evaisa.backlog.graveyard.max_storage") or 20
	local item_decay = ModSettingGet("evaisa.backlog.graveyard.item_decay") or 30
	local item_disarray = ModSettingGet("evaisa.backlog.graveyard.item_disarray")
	if(item_disarray == nil)then
		item_disarray = true
	end
	local wands = get_player_wands()
	local spells = get_player_spells()
	local loadout = {
		x = x,
		y = y,
		wands = {},
		spells = {},
	}
	for i, wand in ipairs(wands) do
		local wand_string, spells = wand:Serialize(item_disarray, item_decay)
		print(wand_string)
		table.insert(loadout.wands, wand_string)
		for i, spell in ipairs(spells) do
			table.insert(loadout.spells, spell)
		end
	end
	for i, spell in ipairs(spells) do
		SetRandomSeed(x + GameGetFrameNum, y * ((i + 1) * 100))
		if(Random(0, 100) > item_decay)then
			table.insert(loadout.spells, spell)
		end
	end
	local loadout_string = smallfolk.dumpsies(loadout)
	local total_loadouts_stored = ModSettingGet("graveyard_storage_count") or 0
	local storage_cursor = ModSettingGet("graveyard_storage_cursor") or 1

	if(storage_cursor + 1 > max_storage)then
		storage_cursor = 1
	end

	if(storage_cursor > total_loadouts_stored)then
		storage_cursor = math.max(total_loadouts_stored, 1)
	end

	if(total_loadouts_stored < max_storage)then
		ModSettingSet("graveyard_storage_count", total_loadouts_stored + 1)
	end

	ModSettingSet("graveyard_storage_cursor", storage_cursor + 1)
	ModSettingSet("graveyard_storage_" .. storage_cursor, loadout_string)

	print("Stored string: "..loadout_string)
	print("ID: "..storage_cursor)
	print("Storage count: "..ModSettingGet("graveyard_storage_count"))

	print("Loadout stored.")
end

function death(damage_type_bit_field, damage_message,entity_thats_responsible, drop_items)
	local x, y = GameGetCameraPos()
	store_loadout(x, y)
end