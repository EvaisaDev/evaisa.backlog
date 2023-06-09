local pretty = dofile_once("mods/evaisa.backlog/content/evaisa.properinheritance/files/pretty_print.lua")

for k, v in ipairs(actions)do
	if((v.type == ACTION_TYPE_MODIFIER or v.type == ACTION_TYPE_PASSIVE or v.type == ACTION_TYPE_DRAW_MANY or v.type == ACTION_TYPE_OTHER) and v.id ~= "ADD_TRIGGER" and v.id ~= "ADD_TIMER" and v.id ~= "ADD_DEATH_TRIGGER")then
		local old_action = v.action
		v.action = function(recursion, iteration)
			register_gunshoteffects = function( effects ) 
				ConfigGunShotEffects_PassToGame( effects )
			end
			if reflecting or recursion ~= nil or playing_permanent_card then 
				old_action(recursion, iteration)
				return
			end
			local sandbox_cast_delay = 0
			local old_c = c;
			local old_shot_effects = shot_effects;
			
			shot_effects = {}
			c = {};
			BeginProjectile( "mods/evaisa.backlog/content/evaisa.properinheritance/files/trigger_projectile.xml" );
				BeginTriggerDeath();
					--reset_modifiers( c );
					--ConfigGunShotEffects_Init( shot_effects )
					for k,v in pairs(old_c) do
						c[k] = v;
					end
					for k,v in pairs(old_shot_effects) do
						shot_effects[k] = v;
					end

					local default_firerate = c.fire_rate_wait
					
					old_action(recursion, iteration)
					sandbox_cast_delay = (c.fire_rate_wait - default_firerate)
					
					register_action( c );
					register_gunshoteffects( shot_effects )
					SetProjectileConfigs();
				EndTrigger();
			EndProjectile();
			c = old_c;
			shot_effects = old_shot_effects;
			c.fire_rate_wait = c.fire_rate_wait + sandbox_cast_delay
			register_gunshoteffects = function( effects ) end
		end
	else
		local old_action = v.action
		v.action = function(recursion, iteration)
			register_gunshoteffects = function( effects ) 
				ConfigGunShotEffects_PassToGame( effects )
			end
			if(playing_permanent_card)then
				
				if ( hand ~= nil ) then
					for i,data in ipairs( hand ) do
						local rec = check_recursion( data, recursion_level )
						if ( data ~= nil ) and ( data.type == 2 ) and ( rec > -1 ) then
							dont_draw_actions = true
							data.action( rec )
							dont_draw_actions = false
						end
					end
				end
				
			end
			old_action(recursion, iteration)
		end
	end
end