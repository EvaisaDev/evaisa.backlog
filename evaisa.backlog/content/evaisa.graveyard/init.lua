function OnPlayerSpawned(player)
	EntityAddComponent2(player, "LuaComponent", {
	  script_death="mods/evaisa.backlog/content/evaisa.graveyard/files/player_death.lua",
	  execute_every_n_frame=-1
	})
end

local EZWand = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/EZWand/EZWand.lua")
local smallfolk = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/smallfolk.lua")
local vector = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/vector.lua")

local function get_player()
    local players = EntityGetWithTag("player_unit")
    if #players == 0 then return end

    return players[1]
end


local available_loadouts = {}

local ids = {}


function validateLoadouts()
	print("Validating loadouts...")
	-- get the total number of loadouts stored
	local total_loadouts_stored = ModSettingGet("graveyard_storage_count") or 0
	
	local has_invalid = false

	-- loop through all the loadouts
	for i = 1, total_loadouts_stored do
	-- get the loadout
	local loadout_string = ModSettingGet("graveyard_storage_" .. i)
	
	if(loadout_string == nil)then
		print("Loadout #"..tostring(i)..": invalid")
		has_invalid = true
	else
		print("Loadout #"..tostring(i)..": valid")
	end
	end

	if(has_invalid)then
		print("Removing invalid loadouts...")
		-- remove invalid loadouts and decrement the total loadouts stored
		for i = total_loadouts_stored, 1, -1 do
			local loadout_string = ModSettingGet("graveyard_storage_" .. i)
			if(loadout_string == nil)then
				ModSettingRemove("graveyard_storage_" .. i)
				total_loadouts_stored = total_loadouts_stored - 1
				ModSettingSet("graveyard_storage_count", total_loadouts_stored)
			end
		end

		-- revalidate
		for i = 1, total_loadouts_stored do
			-- get the loadout
			local loadout_string = ModSettingGet("graveyard_storage_" .. i)
			
			if(loadout_string == nil)then
			print("Loadout #"..tostring(i)..": invalid")
			else
			print("Loadout #"..tostring(i)..": valid")
			end
		end
	else
		print("No invalid loadouts found.")
	end
end

function OnMagicNumbersAndWorldSeedInitialized()
	validateLoadouts()

	local a, b, c, d, e, f = GameGetDateAndTimeLocal()
	local frames = GameGetFrameNum()
	local world_seed = tonumber(StatsGetValue("world_seed")) or 0

	SetRandomSeed(frames + a + b + c + d + e + f, world_seed)
		
	local max_loot_points = ModSettingGet("evaisa.backlog.graveyard.max_loot_points") or 5
	local max_storage = ModSettingGet("evaisa.backlog.graveyard.max_storage") or 20
	local total_loadouts_stored = ModSettingGet("graveyard_storage_count") or 0

	max_loot_points = max_loot_points < max_storage and max_loot_points or max_storage

	if(total_loadouts_stored < max_loot_points)then
		max_loot_points = total_loadouts_stored
	end


	for i=1, max_loot_points do
		if(Random(0, 100) >= 30)then
			table.insert(ids, i)
		end
	end

	-- shuffle ids table
	for i = #ids, 2, -1 do
		local j = Random(i)
		ids[i], ids[j] = ids[j], ids[i]
	end

	print("Total loadouts stored: "..tostring(total_loadouts_stored))

	if(total_loadouts_stored > 0)then
		for x, i in ipairs(ids) do
			print("checking loadout #"..tostring(i))
			local loadout_string = ModSettingGet("graveyard_storage_" .. i)
			if(loadout_string ~= nil)then
				local loadout = smallfolk.loadsies(loadout_string)
				loadout.id = i
				loadout.original_string = loadout_string
				table.insert(available_loadouts, loadout)
			end
		end
	end	

	for i, v in ipairs(available_loadouts) do
		available_loadouts[i].vector = vector.new(v.x, v.y)
		print("Adding available loadout #"..tostring(i).." at "..tostring(v.x)..", "..tostring(v.y))
	end


end


RenderOffScreenMarkers = function(players)
	marker_gui = marker_gui or GuiCreate()
	GuiStartFrame(marker_gui)

	GuiOptionsAdd(marker_gui, GUI_OPTION.NonInteractive)
	local id = 2041242
	local function new_id()
		id = id + 1
		return id
	end

	local screen_width, screen_height = GuiGetScreenDimensions(marker_gui)
	local screen_center_x, screen_center_y = screen_width / 2, screen_height / 2
	local camera_x, camera_y = GameGetCameraPos()
	local bounds_x, bounds_y, bounds_w, bounds_h = GameGetCameraBounds()
	-- loop through each player
	for id, player in pairs(players) do
		if (player and EntityGetIsAlive(player)) then
			local x, y = EntityGetTransform(player)
			-- direction from camera to player
			local dx, dy = x - camera_x, y - camera_y


			-- check if player is outside camera bounds
			if (x < bounds_x or y < bounds_y or x > bounds_x + bounds_w or y > bounds_y + bounds_h) then
				-- normalize that shit
				local length = math.sqrt(dx * dx + dy * dy)
				dx, dy = dx / length, dy / length

				-- draw a marker on the edge of the screen in the direction of the player
				-- march from screen center in direction until we are off screen
				local marker_x, marker_y = screen_center_x, screen_center_y
				while (marker_x > 0 and marker_x < screen_width and marker_y > 0 and marker_y < screen_height) do
					marker_x = marker_x + dx
					marker_y = marker_y + dy
				end


				-- subtract 10 so that we are away from the edge a bit
				marker_x = marker_x - 10 * dx
				marker_y = marker_y - 10 * dy


				local markers = {
					up = "mods/evaisa.mp/files/gfx/ui/marker/top.png",
					down = "mods/evaisa.mp/files/gfx/ui/marker/bottom.png",
					left = "mods/evaisa.mp/files/gfx/ui/marker/left.png",
					right = "mods/evaisa.mp/files/gfx/ui/marker/right.png",
					topleft = "mods/evaisa.mp/files/gfx/ui/marker/topleft.png",
					topright = "mods/evaisa.mp/files/gfx/ui/marker/topright.png",
					bottomleft = "mods/evaisa.mp/files/gfx/ui/marker/bottomleft.png",
					bottomright = "mods/evaisa.mp/files/gfx/ui/marker/bottomright.png",
				}

				-- figure out which marker to draw based on the direction

				local marker_image = markers.up
				if (marker_x < screen_center_x - (screen_center_x / 2) and marker_y < screen_center_y - (screen_center_y / 2)) then
					marker_image = markers.topleft
				elseif (marker_x > screen_center_x + (screen_center_x / 2) and marker_y < screen_center_y - (screen_center_y / 2)) then
					marker_image = markers.topright
				elseif (marker_x < screen_center_x - (screen_center_x / 2) and marker_y > screen_center_y + (screen_center_y / 2)) then
					marker_image = markers.bottomleft
				elseif (marker_x > screen_center_x + (screen_center_x / 2) and marker_y > screen_center_y + (screen_center_y / 2)) then
					marker_image = markers.bottomright
				elseif (marker_x < screen_center_x - (screen_center_x / 2)) then
					marker_image = markers.left
				elseif (marker_x > screen_center_x + (screen_center_x / 2)) then
					marker_image = markers.right
				elseif (marker_y < screen_center_y - (screen_center_y / 2)) then
					marker_image = markers.up
				elseif (marker_y > screen_center_y + (screen_center_y / 2)) then
					marker_image = markers.down
				end



				--marker_x, marker_y = marker_x / 2, marker_y / 2

				marker_x = marker_x - 2.5
				marker_y = marker_y - 2.5

				-- somehow convert id to a color


				local color = nil
				if (color == nil) then
					color = { r = 255, g = 255, b = 255 }
				end
				local r, g, b = color.r, color.g, color.b
				local a = 1
				GuiColorSetForNextWidget(marker_gui, r / 255, g / 255, b / 255, a)

				GuiImage(marker_gui, new_id(), marker_x, marker_y, marker_image, 1, 1, 1)
				--GuiText(gui, marker_x / 2, marker_y / 2, "o")
			end
		end
	end
end

function SpawnGrave(x, y, loadout_string, loadout_id)
	print("Spawning grave.")
	GamePrint("You feel a chill down your spine.")
	-- find free spot
	local free_x, free_y = FindFreePositionForBody( x, y, 0, 0, 25 )

	print(loadout_string)

	local entity = EntityLoad("mods/evaisa.backlog/content/evaisa.graveyard/files/grave.xml", free_x, free_y)
	-- add VariableStorageComponent
	EntityAddComponent2(entity, "VariableStorageComponent", {
		name = "loadout",
		value_string = loadout_string
	})

	EntityAddComponent2(entity, "VariableStorageComponent", {
		name = "loadout_id",
		value_int = loadout_id
	})

	return entity
end

--local graves = {}

function OnWorldPreUpdate() 
	--RenderOffScreenMarkers(graves)

	local x, y = GameGetCameraPos()
	local position = vector.new(x, y)
	for i, v in ipairs(available_loadouts)do
		if(position:distance(v.vector) < 300)then
			local grave = SpawnGrave(v.x, v.y, v.original_string, v.id)
			--table.insert(graves, grave)
			table.remove(available_loadouts, i)
			break;
		end
	end
end
