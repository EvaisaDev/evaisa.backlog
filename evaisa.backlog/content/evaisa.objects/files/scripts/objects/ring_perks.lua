ring_perks = {
    {
		id = "CRITICAL_HIT",
		ui_name = "$perk_critical_hit",
		ui_description = "$perkdesc_critical_hit",
		game_effect = "CRITICAL_HIT_BOOST",
	},
	{
		id = "BREATH_UNDERWATER",
		ui_name = "$perk_breath_underwater",
		ui_description = "$perkdesc_breath_underwater",
		game_effect = "BREATH_UNDERWATER",
	},
	{
		id = "EXTRA_MONEY",
		ui_name = "$perk_extra_money",
		ui_description = "$perkdesc_extra_money",
		game_effect = "EXTRA_MONEY",
	},
	{
		id = "EXTRA_MONEY_TRICK_KILL",
		ui_name = "$perk_extra_money_trick_kill",
		ui_description = "$perkdesc_extra_money_trick_kill",
		game_effect = "EXTRA_MONEY_TRICK_KILL",
	},
	{
		id = "HOVER_BOOST",
		ui_name = "$perk_hover_boost",
		ui_description = "$perkdesc_hover_boost",
		game_effect = "HOVER_BOOST",
	},
	{
		id = "MOVEMENT_FASTER",
		ui_name = "$perk_movement_faster",
		ui_description = "$perkdesc_movement_faster",
		game_effect = "MOVEMENT_FASTER",
    },
    {
		id = "LOW_GRAVITY",
		ui_name = "$perk_low_gravity",
		ui_description = "$perkdesc_low_gravity",
		perk_add_func = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = tonumber( ComponentGetValue( model, "pixel_gravity" ) ) * 0.4
					ComponentSetValue( model, "pixel_gravity", gravity )
				end
			end
        end,
        perk_remove_func = function( entity_who_picked )
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local gravity = tonumber( ComponentGetValue( model, "pixel_gravity" ) ) * -0.4
					ComponentSetValue( model, "pixel_gravity", gravity )
				end 
			end
		end,
    },
    {
		id = "SPEED_DIVER",
		ui_name = "$perk_speed_diver",
		ui_description = "$perkdesc_speed_diver",
		perk_add_func = function( entity_who_picked )
		
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local swim_idle = tonumber( ComponentGetValue( model, "swim_idle_buoyancy_coeff" ) ) * 0.6
					local swim_up = tonumber( ComponentGetValue( model, "swim_up_buoyancy_coeff" ) ) * 0.2
					local swim_down = tonumber( ComponentGetValue( model, "swim_down_buoyancy_coeff" ) ) * 0.2
					
					local swim_drag = tonumber( ComponentGetValue( model, "swim_drag" ) ) * 1.2
					local swim_drag_extra = tonumber( ComponentGetValue( model, "swim_extra_horizontal_drag" ) ) * 1.2
					
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", swim_idle )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", swim_up )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", swim_down )
					
					ComponentSetValue( model, "swim_drag", swim_drag )
					ComponentSetValue( model, "swim_extra_horizontal_drag", swim_drag_extra )
				end
			end
        end,
        perk_remove_func = function( entity_who_picked )
		
			local models = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local swim_idle = tonumber( ComponentGetValue( model, "swim_idle_buoyancy_coeff" ) ) * -0.6
					local swim_up = tonumber( ComponentGetValue( model, "swim_up_buoyancy_coeff" ) ) * -0.2
					local swim_down = tonumber( ComponentGetValue( model, "swim_down_buoyancy_coeff" ) ) * -0.2
					
					local swim_drag = tonumber( ComponentGetValue( model, "swim_drag" ) ) * -1.2
					local swim_drag_extra = tonumber( ComponentGetValue( model, "swim_extra_horizontal_drag" ) ) * -1.2
					
					ComponentSetValue( model, "swim_idle_buoyancy_coeff", swim_idle )
					ComponentSetValue( model, "swim_up_buoyancy_coeff", swim_up )
					ComponentSetValue( model, "swim_down_buoyancy_coeff", swim_down )
					
					ComponentSetValue( model, "swim_drag", swim_drag )
					ComponentSetValue( model, "swim_extra_horizontal_drag", swim_drag_extra )
				end
			end
		end,
    },
	{
		id = "STRONG_KICK",
		ui_name = "$perk_strong_kick",
		ui_description = "$perkdesc_strong_kick",
		perk_add_func = function( entity_who_picked )
		
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local kick_force = tonumber( ComponentGetMetaCustom( model, "max_force" ) ) * 1.7
					local player_kick_force = tonumber( ComponentGetMetaCustom( model, "player_kickforce" ) ) * 1.7
					local kick_damage = tonumber( ComponentGetMetaCustom( model, "kick_damage" ) ) + 0.12
					local kick_knockback = tonumber( ComponentGetMetaCustom( model, "kick_knockback" ) ) + 250
					
					ComponentSetMetaCustom( model, "max_force", kick_force )
					ComponentSetMetaCustom( model, "player_kickforce", player_kick_force )
					ComponentSetMetaCustom( model, "kick_damage", kick_damage )
					ComponentSetMetaCustom( model, "kick_knockback", kick_knockback )
				end
			end
        end,
		perk_remove_func = function( entity_who_picked )
		
			local models = EntityGetComponent( entity_who_picked, "KickComponent" )
			if( models ~= nil ) then
				for i,model in ipairs(models) do
					local kick_force = tonumber( ComponentGetMetaCustom( model, "max_force" ) ) * -1.7
					local player_kick_force = tonumber( ComponentGetMetaCustom( model, "player_kickforce" ) ) * -1.7
					local kick_damage = tonumber( ComponentGetMetaCustom( model, "kick_damage" ) ) - 0.12
					local kick_knockback = tonumber( ComponentGetMetaCustom( model, "kick_knockback" ) ) - 250
					
					ComponentSetMetaCustom( model, "max_force", kick_force )
					ComponentSetMetaCustom( model, "player_kickforce", player_kick_force )
					ComponentSetMetaCustom( model, "kick_damage", kick_damage )
					ComponentSetMetaCustom( model, "kick_knockback", kick_knockback )
				end
			end
		end,        
    },
    {
		id = "REPELLING_CAPE",
		ui_name = "$perk_repelling_cape",
		ui_description = "$perkdesc_repelling_cape",
		game_effect = "STAINS_DROP_FASTER",
	},
	{
		id = "EXPLODING_CORPSES",
		ui_name = "$perk_exploding_corpses",
		ui_description = "$perkdesc_exploding_corpses",
		game_effect = "EXPLODING_CORPSE_SHOTS",
	},
	{
		id = "SAVING_GRACE",
		ui_name = "$perk_saving_grace",
		ui_description = "$perkdesc_saving_grace",
		game_effect = "SAVING_GRACE",
	},
	{
		id = "INVISIBILITY",
		ui_name = "$perk_invisibility",
		ui_description = "$perkdesc_invisibility",
		game_effect = "INVISIBILITY",
	},
	{
		id = "GLOBAL_GORE",
		ui_name = "$perk_global_gore",
		ui_description = "$perkdesc_global_gore",
		game_effect = "GLOBAL_GORE",
	},
	{
		id = "REMOVE_FOG_OF_WAR",
		ui_name = "$perk_remove_fog_of_war",
		ui_description = "$perkdesc_remove_fog_of_war",
		game_effect = "REMOVE_FOG_OF_WAR",
    },  
	{
		id = "LEVITATION_TRAIL",
		ui_name = "$perk_levitation_trail",
		ui_description = "$perkdesc_levitation_trail",
		perk_add_func = function( entity_who_picked )
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{
				script_source_file="data/scripts/perks/levitation_trail.lua",
				execute_every_n_frame="3"
			} )
        end,
        perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/levitation_trail.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
    }, 
    {
		id = "VAMPIRISM",
		ui_name = "$perk_vampirism",
		ui_description = "$perkdesc_vampirism",
		game_effect = "HEALING_BLOOD",
		perk_add_func = function( entity_who_picked )

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) ) / 3 * 2

					max_hp = math.ceil( max_hp * 25 ) / 25
					
					ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
					ComponentSetValue( damagemodel, "max_hp", max_hp )
				end
			end

        end,
		perk_remove_func = function( entity_who_picked )

			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local hp = tonumber( ComponentGetValue( damagemodel, "hp" ) )
					local max_hp = tonumber( ComponentGetValue( damagemodel, "max_hp" ) ) * 3 / 2

					max_hp = math.ceil( max_hp * 25 ) / 25
					
					ComponentSetValue( damagemodel, "hp", math.min( hp, max_hp ) )
					ComponentSetValue( damagemodel, "max_hp", max_hp )
				end
			end

		end,
    },
	{
		id = "HEARTS_MORE_EXTRA_HP",
		ui_name = "$perk_hearts_more_extra_hp",
		ui_description = "$perkdesc_hearts_more_extra_hp",
		ui_icon = "data/ui_gfx/perk_icons/hearts_more_extra_hp.png",
		perk_icon = "data/items_gfx/perks/hearts_more_extra_hp.png",
		perk_add_func = function( entity_who_picked )
			-- TODO heart containers give 2x more health
			EntityAddComponent( entity_who_picked, "VariableStorageComponent", 
			{ 
				name = "hearts_more_extra_hp",
				value_int = 2,
			} )
        end,
		perk_remove_func = function( entity_who_picked )
            local storage_components = EntityGetComponent( entity_who_picked,"VariableStorageComponent")
            local is_first = true
            for k,v in pairs(storage_components)do
                if(is_first)then
                    local name = ComponentGetValue2(v, "name")
                    if(name == "hearts_more_extra_hp")then
                        EntityRemoveComponent(entity_who_picked, v)
                        is_first = false
                    end
                end
            end
		end,
    },
	{
		id = "WORM_ATTRACTOR",
		ui_name = "$perk_worm_attractor",
		ui_description = "$perkdesc_worm_attractor",
		game_effect = "WORM_ATTRACTOR",
	},

	{
		id = "WORM_DETRACTOR",
		ui_name = "$perk_worm_detractor",
		ui_description = "$perkdesc_worm_detractor",
		game_effect = "WORM_DETRACTOR",
    },
	{
		id = "RADAR_ENEMY",
		ui_name = "$perk_radar_enemy",
		ui_description = "$perkdesc_radar_enemy",
		ui_icon = "data/ui_gfx/perk_icons/radar_enemy.png",
		perk_icon = "data/items_gfx/perks/radar_enemy.png",
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/radar.lua",
				execute_every_n_frame = "1",
			} )
        end,
        perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/radar.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
	},
	{
		id = "WAND_RADAR",
		ui_name = "$perk_radar_wand",
		ui_description = "$perkdesc_radar_wand",
		ui_icon = "data/ui_gfx/perk_icons/radar_wand.png",
		perk_icon = "data/items_gfx/perks/radar_wand.png",
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/radar_wand.lua",
				execute_every_n_frame = "1",
			} )
        end,
        perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/radar_wand.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
    },
    {
		id = "PROTECTION_FIRE",
		ui_name = "$perk_protection_fire",
		ui_description = "$perkdesc_protection_fire",
		game_effect = "PROTECTION_FIRE",
	},
	{
		id = "PROTECTION_RADIOACTIVITY",
		ui_name = "$perk_protection_radioactivity",
		ui_description = "$perkdesc_protection_radioactivity",
		game_effect = "PROTECTION_RADIOACTIVITY",
	},
	{
		id = "PROTECTION_EXPLOSION",
		ui_name = "$perk_protection_explosion",
		ui_description = "$perkdesc_protection_explosion",
		game_effect = "PROTECTION_EXPLOSION",
	},
	{
		id = "PROTECTION_MELEE",
		ui_name = "$perk_protection_melee",
		ui_description = "$perkdesc_protection_melee",
		game_effect = "PROTECTION_MELEE",
	},
	{
		id = "PROTECTION_ELECTRICITY",
		ui_name = "$perk_protection_electricity",
		ui_description = "$perkdesc_protection_electricity",
		game_effect = "PROTECTION_ELECTRICITY",
    },
	{
		id = "TELEPORTITIS",
		ui_name = "$perk_teleportitis",
		ui_description = "$perkdesc_teleportitis",
		game_effect = "TELEPORTITIS",
	},
	{
		id = "STAINLESS_ARMOUR",
		ui_name = "$perk_stainless_armour",
		ui_description = "$perkdesc_stainless_armour",
		game_effect = "STAINLESS_ARMOUR",
    },
    {
		id = "EDIT_WANDS_EVERYWHERE",
		ui_name = "$perk_edit_wands_everywhere",
		ui_description = "$perkdesc_edit_wands_everywhere",
		game_effect = "EDIT_WANDS_EVERYWHERE",
    },
    {
		id = "PROJECTILE_HOMING",
		ui_name = "$perk_projectile_homing",
		ui_description = "$perkdesc_projectile_homing",
		game_effect = "PROJECTILE_HOMING",
	},
	{
		id = "PROJECTILE_HOMING_SHOOTER",
		ui_name = "$perk_projectile_homing_shooter",
		ui_description = "$perkdesc_projectile_homing_shooter",
		perk_add_func = function( entity_who_picked )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{ 
				extra_modifier = "projectile_homing_shooter",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					
					explosion_resistance = explosion_resistance * 0.7
					projectile_resistance = projectile_resistance * 0.7
					
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
				end
			end
		end,
		perk_remove_func = function( entity_who_picked )

			local shot_effects = EntityGetComponent( entity_who_picked,"ShotEffectComponent")
			local is_first = true
			for k,v in pairs(shot_effects)do
				if(is_first)then
					local name = ComponentGetValue2(v, "extra_modifier")
					if(name == "projectile_homing_shooter")then
						EntityRemoveComponent(entity_who_picked, v)
						is_first = false
					end
				end
			end
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					local explosion_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "explosion" ))
					
					explosion_resistance = explosion_resistance * -0.7
					projectile_resistance = projectile_resistance * -0.7
					
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion_resistance) )
				end
			end
		end,
	},
	{
		id = "FREEZE_FIELD",
		ui_name = "$perk_freeze_field",
		ui_description = "$perkdesc_freeze_field",
		game_effect = "PROTECTION_FIRE",
		perk_add_func = function( entity_who_picked )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/freeze_field.xml", x, y )
			EntityAddTag(child_id, "freeze_field_ring")
			EntityAddChild( entity_who_picked, child_id )
				
		end,
		perk_remove_func = function( entity_who_picked )
		
			local children = EntityGetAllChildren( entity_who_picked )

			for k, v in pairs(children)do
				if(EntityHasTag(v, "freeze_field_ring"))then
					EntityKill(v)
				end
			end
		end,
	},	
	{
		id = "DISSOLVE_POWDERS",
		ui_name = "$perk_dissolve_powders",
		ui_description = "$perkdesc_dissolve_powders",
		perk_add_func = function( entity_who_picked )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/dissolve_powders.xml", x, y )
			EntityAddTag(child_id, "dissolve_powders_ring")
			EntityAddChild( entity_who_picked, child_id )
				
		end,
		perk_remove_func = function( entity_who_picked )
		
			local children = EntityGetAllChildren( entity_who_picked )

			for k, v in pairs(children)do
				if(EntityHasTag(v, "dissolve_powders_ring"))then
					EntityKill(v)
				end
			end
		end,
	},	
	{
		id = "SHIELD",
		ui_name = "$perk_shield",
		ui_description = "$perkdesc_shield",
		perk_add_func = function( entity_who_picked )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/shield.xml", x, y )
			EntityAddTag(child_id, "shield_ring")
			EntityAddChild( entity_who_picked, child_id )
				
		end,
		perk_remove_func = function( entity_who_picked )
		
			local children = EntityGetAllChildren( entity_who_picked )

			for k, v in pairs(children)do
				if(EntityHasTag(v, "shield_ring"))then
					EntityKill(v)
				end
			end
		end,
	},
	{
		id = "REVENGE_EXPLOSION",
		ui_name = "$perk_revenge_explosion",
		ui_description = "$perkdesc_revenge_explosion",
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "data/scripts/perks/revenge_explosion.lua",
				execute_every_n_frame = "-1",
			} )				
		end,
        perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/revenge_explosion.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
	},
	{
		id = "REVENGE_TENTACLE",
		ui_name = "$perk_revenge_tentacle",
		ui_description = "$perkdesc_revenge_tentacle",
		ui_icon = "data/ui_gfx/perk_icons/revenge_tentacle.png",
		perk_icon = "data/items_gfx/perks/revenge_tentacle.png",
		usable_by_enemies = true,
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_damage_received = "data/scripts/perks/revenge_tentacle.lua",
				execute_every_n_frame = "-1",
			} )
			
		end,
        perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/revenge_tentacle.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
	},	
	{
		id = "ATTACK_FOOT",
		ui_name = "$perk_attack_foot",
		ui_description = "$perkdesc_attack_foot",
		perk_add_func = function( entity_who_picked )
		
			local x,y = EntityGetTransform( entity_who_picked )
			
			for i=1,4 do
				local child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_walker.xml", x, y )
				EntityAddTag(child_id, "attack_foot_ring")
				EntityAddChild( entity_who_picked, child_id )
			end
			
			child_id = EntityLoad( "data/entities/misc/perks/attack_foot/limb_attacker.xml", x, y )
			EntityAddTag(child_id, "attack_foot_ring")
			EntityAddChild( entity_who_picked, child_id )
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * 1.25
					local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * 1.25
					
					local vel_x_min = 0 - vel_x
					local vel_x_max = vel_x
					
					ComponentSetMetaCustom( component, "run_velocity", run_speed )
					ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
					ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
				end
			end
		end,
		perk_remove_func = function( entity_who_picked )
		
			local x,y = EntityGetTransform( entity_who_picked )
			
			for k, v in pairs(children)do
				if(EntityHasTag(v, "attack_foot_ring"))then
					EntityKill(v)
				end
			end
			
			local platformingcomponents = EntityGetComponent( entity_who_picked, "CharacterPlatformingComponent" )
			if( platformingcomponents ~= nil ) then
				for i,component in ipairs(platformingcomponents) do
					local run_speed = tonumber( ComponentGetMetaCustom( component, "run_velocity" ) ) * -1.25
					local vel_x = math.abs( tonumber( ComponentGetMetaCustom( component, "velocity_max_x" ) ) ) * -1.25
					
					local vel_x_min = 0 - vel_x
					local vel_x_max = vel_x
					
					ComponentSetMetaCustom( component, "run_velocity", run_speed )
					ComponentSetMetaCustom( component, "velocity_min_x", vel_x_min )
					ComponentSetMetaCustom( component, "velocity_max_x", vel_x_max )
				end
			end
		end,
	},
	{
		id = "PLAGUE_RATS",
		ui_name = "$perk_plague_rats",
		ui_description = "$perkdesc_plague_rats",
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/plague_rats.lua",
				execute_every_n_frame = "20",
			} )
			
			GenomeSetHerdId( entity_who_picked, "rat" )
		end,
		perk_remove_func = function( entity_who_picked )
			GenomeSetHerdId( entity_who_picked, "player" )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/plague_rats.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
	},
	{
		id = "PROJECTILE_REPULSION",
		ui_name = "$perk_projectile_repulsion",
		ui_description = "$perkdesc_projectile_repulsion",
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/projectile_repulsion.lua",
				execute_every_n_frame = "2",
			} )
			
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * 1.26
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
		perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/projectile_repulsion.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
			end
			local damagemodels = EntityGetComponent( entity_who_picked, "DamageModelComponent" )
			if( damagemodels ~= nil ) then
				for i,damagemodel in ipairs(damagemodels) do
					local projectile_resistance = tonumber(ComponentObjectGetValue( damagemodel, "damage_multipliers", "projectile" ))
					projectile_resistance = projectile_resistance * -1.26
					ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile_resistance) )
				end
			end
		end,
	},
	{
		id = "ELECTRICITY",
		ui_name = "$perk_electricity",
		ui_description = "$perkdesc_electricity",
		game_effect = "PROTECTION_ELECTRICITY",
		perk_add_func = function( entity_who_picked )
		
			local x,y = EntityGetTransform( entity_who_picked )
			local child_id = EntityLoad( "data/entities/misc/perks/electricity.xml", x, y )
			EntityAddTag(child_id, "electricity_ring")
			EntityAddChild( entity_who_picked, child_id )
			
		end,
		perk_remove_func = function( entity_who_picked )
		
			local children = EntityGetAllChildren( entity_who_picked )

			for k, v in pairs(children)do
				if(EntityHasTag(v, "electricity_ring"))then
					EntityKill(v)
				end
			end
		end,
	},
	{
		id = "ATTRACT_ITEMS",
		ui_name = "$perk_attract_items",
		ui_description = "$perkdesc_attract_items",
		perk_add_func = function( entity_who_picked )
		
			EntityAddComponent( entity_who_picked, "LuaComponent", 
			{ 
				script_source_file = "data/scripts/perks/attract_items.lua",
				execute_every_n_frame = "2",
			} )
			
		end,
		perk_remove_func = function( entity_who_picked )
            local lua_components = EntityGetComponent( entity_who_picked,"LuaComponent")
            for k,v in pairs(lua_components)do
                local source_file = ComponentGetValue2(v, "script_source_file")
                if(source_file == "data/scripts/perks/attract_items.lua")then
                    EntityRemoveComponent(entity_who_picked, v)
                end
            end
		end,
	},
	{
		id = "EXTRA_KNOCKBACK",
		ui_name = "$perk_extra_knockback",
		ui_description = "$perkdesc_extra_knockback",
		perk_add_func = function( entity_who_picked )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{ 
				extra_modifier = "extra_knockback",
			} )
		end,
		perk_remove_func = function( entity_who_picked )

			local shot_effects = EntityGetComponent( entity_who_picked,"ShotEffectComponent")
			local is_first = true
			for k,v in pairs(shot_effects)do
				if(is_first)then
					local name = ComponentGetValue2(v, "extra_modifier")
					if(name == "extra_knockback")then
						EntityRemoveComponent(entity_who_picked, v)
						is_first = false
					end
				end
			end
		end
	},	
	{
		id = "LOWER_SPREAD",
		ui_name = "$perk_lower_spread",
		ui_description = "$perkdesc_lower_spread",
		perk_add_func = function( entity_who_picked )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{ 
				extra_modifier = "lower_spread",
			} )
		end,
		perk_remove_func = function( entity_who_picked )
			local shot_effects = EntityGetComponent( entity_who_picked,"ShotEffectComponent")
			local is_first = true
			for k,v in pairs(shot_effects)do
				if(is_first)then
					local name = ComponentGetValue2(v, "extra_modifier")
					if(name == "lower_spread")then
						EntityRemoveComponent(entity_who_picked, v)
						is_first = false
					end
				end
			end
		end
	},
	{
		id = "BOUNCE",
		ui_name = "$perk_bounce",
		ui_description = "$perkdesc_bounce",
		perk_add_func = function( entity_who_picked )
			EntityAddComponent( entity_who_picked, "ShotEffectComponent", 
			{ 
				extra_modifier = "bounce",
			} )
		end,
		perk_remove_func = function( entity_who_picked )
			local shot_effects = EntityGetComponent( entity_who_picked,"ShotEffectComponent")
			local is_first = true
			for k,v in pairs(shot_effects)do
				if(is_first)then
					local name = ComponentGetValue2(v, "extra_modifier")
					if(name == "bounce")then
						EntityRemoveComponent(entity_who_picked, v)
						is_first = false
					end
				end
			end
		end	
	},
}

function random_perk(x, y)
	dofile_once("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/utilities.lua")
	
	local perk_count = table.length(ring_perks)
	
	SetRandomSeed( x..StatsGetValue("world_seed"),  y..StatsGetValue("world_seed") )
	
	local random_perk = ring_perks[Random(1, perk_count)]
	
	return random_perk
end