if(not GameHasFlagRun("TMTRAINER_RUN_STARTED"))then
    a, b, c, d ,e ,f = GameGetDateAndTimeLocal()
    ModSettingSet("TMTRAINER_SEED", a + b + c + d + e + f)
end

function OnMagicNumbersAndWorldSeedInitialized()
    if(not GameHasFlagRun("TMTRAINER_RUN_STARTED"))then
        RemoveFlagPersistent("TMTRAINER")
    end
end

local alt_event_utils = ModTextFileGetContent("data/scripts/streaming_integration/event_utilities.lua")
ModTextFileSetContent("data/scripts/streaming_integration/alt_event_utils.lua", alt_event_utils)

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/evaisa.backlog/content/evaisa.tmtrainer/files/scripts/append/gun_actions.lua")
ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/evaisa.backlog/content/evaisa.tmtrainer/files/scripts/append/perk_list.lua")
ModLuaFileAppend("data/scripts/perks/perk.lua", "mods/evaisa.backlog/content/evaisa.tmtrainer/files/scripts/append/perk.lua")

local bypasscontent = ModTextFileGetContent("data/scripts/gun/gun_actions.lua")
bypasscontent = 'dofile_once( "data/scripts/gun/gun_enums.lua")\n\n'..bypasscontent
ModTextFileSetContent("data/scripts/gun/gun_actions.lua", bypasscontent)

function findCenteredImagePosition(gui, image_file, scale)
    local width, height = GuiGetScreenDimensions( gui )
    local image_width, image_height = GuiGetImageDimensions( gui, image_file, scale )
    local x = (width - image_width) / 2
    local y = (height - image_height) / 2
    return x, y
end

function OnPlayerSpawned(player)
    EntityAddComponent( player, "LuaComponent", {
		execute_every_n_frame="1",
		execute_on_added="1",
		script_source_file="mods/evaisa.backlog/content/evaisa.tmtrainer/files/scripts/player_update.lua",
	});
end