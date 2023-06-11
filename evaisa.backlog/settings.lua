---@diagnostic disable: lowercase-global, undefined-global
dofile("data/scripts/lib/mod_settings.lua")



local mod_id = "evaisa.backlog" -- This should match the name of your mod's folder.
mod_settings_version = 1 -- This is a magic global that can be used to migrate settings to new mod versions. call mod_settings_get_version() before mod_settings_update() to get the old value. 
mod_settings =
{
	{
		category_id = "enabled_mods",
		ui_name = "Enabled Mods",
		ui_description = "Which backlog mods do you wish to enabled?",
		settings = {
			{
				id = "evaisa.materiamancy",
				ui_name = "Materiamancy",
				ui_description = "Adds a spell which lets you use the environment as your weapon.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
            {
				id = "evaisa.graveyard",
				ui_name = "graveyard",
				ui_description = "Adds a kind of meta progression, where you can find loot from previous runs.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
            {
				id = "evaisa.tmtrainer",
				ui_name = "TMTRAINER",
				ui_description = "Adds the TMTRAINER item from BOI as a perk to Noita.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
            {
				id = "evaisa.difficulty",
				ui_name = "Monsoon",
				ui_description = "Adds a risk of rain style time scaled difficulty meter to Noita.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
            {
				id = "evaisa.properinheritance",
				ui_name = "Proper Inheritance",
				ui_description = "Makes spells inherit modifiers in a more logical way.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
            {
				id = "evaisa.lidar",
				ui_name = "Lidar",
				ui_description = "There is no light, your only guide is your lidar gun.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
            {
				id = "evaisa.objects",
				ui_name = "Curios",
				ui_description = "Adds a variety of new items to play around with.",
				value_default = false,
				scope = MOD_SETTING_SCOPE_NEW_GAME,
			},
		},
	},
    {
		category_id = "mod_settings",
		ui_name = "Mod Settings",
		ui_description = "Settings for the backlog mods.",
		settings = {
			{
				category_id = "graveyard_settings",
				ui_name = "Graveyard Settings",
				ui_description = "The settings for the graveyard mod.",
				foldable = true,
				_folded = true,
				settings = {
                    {
                        id = "graveyard.max_storage",
                        ui_name = "Max Loadout Storage",
                        ui_description = "How many death loadouts can be stored and potentially found.",
                        value_default = 20,
                        value_min = 1,
                        value_max = 100,
                        value_display_multiplier = 1,
                        value_display_formatting = " $0",
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
                    {
                        id = "graveyard.item_disarray",
                        ui_name = "Item Disarray",
                        ui_description = "Dead people do not keep their stuff organized well.",
                        value_default = true,
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
                    {
                        id = "graveyard.item_decay",
                        ui_name = "Item Decay Chance",
                        ui_description = "Chance an item is lost after death.",
                        value_default = 30,
                        value_min = 1,
                        value_max = 100,
                        value_display_multiplier = 1,
                        value_display_formatting = " $0%",
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
                    {
                        id = "graveyard.max_loot_points",
                        ui_name = "Max Loot Points",
                        ui_description = "Maximum amount of graves that can spawn in a run.",
                        value_default = 5,
                        value_min = 1,
                        value_max = 100,
                        value_display_multiplier = 1,
                        value_display_formatting = " $0",
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
                    {
                        id = "graveyard.remove_after_loot",
                        ui_name = "Remove grave after looting",
                        ui_description = "After looting a grave it will not appear in future runs.",
                        value_default = false,
                        scope = MOD_SETTING_SCOPE_NEW_GAME,
                    },
				},
			},
            {
                category_id = "difficulty_settings",
                ui_name = "Monsoon Settings",
                ui_description = "The settings for the Monsoon mod.",
                foldable = true,
                _folded = true,
                settings = {
                    {
                        id = "difficulty.difficulty",
                        ui_name = "Difficulty",
                        ui_description = "The difficulty of the game.",
                        value_default = "normal",
                        values = { {"noob","Noob"}, {"normal","Normal"}, {"hard","Hard"}, {"nightmare","Nightmare"}, {"death","You will die"}, {"dev","Development"} },
                        scope = MOD_SETTING_SCOPE_RUNTIME,
                        change_fn = mod_setting_change_callback,
                    },
                    {
                        id = "difficulty.x_offset",
                        ui_name = "X Offset",
                        ui_description = "Difficulty bar offset.",
                        value_default = "0",
                        text_max_length = 5,
                        allowed_characters = "-0123456789",
                        scope = MOD_SETTING_SCOPE_RUNTIME,
                    },
                    {
                        id = "difficulty.y_offset",
                        ui_name = "Y Offset",
                        ui_description = "Difficulty bar offset.",
                        value_default = "0",
                        text_max_length = 5,
                        allowed_characters = "-0123456789",
                        scope = MOD_SETTING_SCOPE_RUNTIME,
                    },
                    {
                        id = "difficulty.show_difficulty_coeff",
                        ui_name = "Show Difficulty Value",
                        ui_description = "Display the difficulty coefficient in the difficulty bar.",
                        value_default = true,
                        scope = MOD_SETTING_SCOPE_RUNTIME,
                    },
                    {
                        id = "difficulty.pause_in_mountain",
                        ui_name = "Pause in Mountain",
                        ui_description = "Pause the difficulty timer in the holy mountain",
                        value_default = true,
                        scope = MOD_SETTING_SCOPE_RUNTIME,
                    },
                    {
                        id = "difficulty.paused",
                        ui_name = "Pause",
                        ui_description = "Pause the difficulty timer",
                        value_default = false,
                        scope = MOD_SETTING_SCOPE_RUNTIME,
                    },
                },
            },
		},
	},
}

function ModSettingsUpdate( init_scope )
	local old_version = mod_settings_get_version( mod_id )
	mod_settings_update( mod_id, mod_settings, init_scope )
end

function ModSettingsGuiCount()
	return mod_settings_gui_count( mod_id, mod_settings )
end

function ModSettingsGui( gui, in_main_menu )
	mod_settings_gui( mod_id, mod_settings, gui, in_main_menu )
end
