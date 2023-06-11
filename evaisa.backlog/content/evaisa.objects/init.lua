--------------------- ALL THIS CODE IS EXTREMELY OLD AND BAD ---------------------

dofile("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/store_materials_barrel.lua")
dofile("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/store_materials_conversion_stone.lua")


function load_forgotten_tome(x, y)
    EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/forgotten_tome/forgotten_tome.xml", x, y - 13)
    LoadPixelScene( "mods/evaisa.backlog/content/evaisa.objects/files/entities/forgotten_tome/tome_altar.png", "mods/evaisa.backlog/content/evaisa.objects/files/entities/forgotten_tome/tome_altar_visual.png", x - 10, y-20, "", true )
end


dofile("mods/evaisa.backlog/content/evaisa.objects/lib/shader_utilities.lua")

postfx.append([[
	uniform vec4 enable_western;
]],
"uniform sampler2D tex_fog;"
)

ModLuaFileAppend("data/scripts/item_spawnlists.lua", "mods/evaisa.backlog/content/evaisa.objects/files/scripts/append/item_list.lua")

postfx.append(
	[[	
		float hash(float n) {
			return fract(cos(n*89.42)*343.42);
		}

		vec2 hash2(vec2 n) {
			return vec2(hash(n.x*23.62-300.0+n.y*34.35),hash(n.x*45.13+256.0+n.y*38.89)); 
		}

		float worley(vec2 c, float time) {
			float dis = 1.0;
			for(int x = -1; x <= 1; x++)
				for(int y = -1; y <= 1; y++){
					vec2 p = floor(c)+vec2(x,y);
					vec2 a = hash2(p) * time;
					vec2 rnd = 0.5+sin(a)*0.5;
					float d = length(rnd+vec2(x,y)-fract(c));
					dis = min(dis, d);
				}
			return dis;
		}
		float worley5(vec2 c, float time) {
			float w = 0.0;
			float a = 0.5;
			int i = 0;
			for (int i = 0; i<5; i++) {
				w += worley(c, time)*a;
				c*=2.0;
				time*=2.0;
				a*=0.5;
			}
			return w;
		}
	]],
	"// utilities"
)


postfx.append(
	[[
		if (enable_western[0] == 1.0){
			float sepiaStrength = 1.0;

			gl_FragColor.rgb = gl_FragColor.rgb * mat3( .393, .769, .189, .349, .686, .168, .272, .534, .131);

			vec2 uv = gl_FragCoord.xy / window_size;

			float strength = 10.0;
			float x = (uv.x + 4.0 ) * (uv.y + 4.0 ) * (time * 10.0);
			vec4 grain = vec4(mod((mod(x, 13.0) + 1.0) * (mod(x, 123.0) + 1.0), 0.01)-0.005) * strength;

			vec2 uv_cloned = uv;

			uv_cloned *=  1.0 - uv_cloned.yx;   
			float vig = uv_cloned.x*uv_cloned.y * 15.0;
			float t = sin(time * 23.) * cos(time * 8. + .5);
			vig = pow(vig, 0.4 + t * .05);


			uv.x *= 100.0 + time*.10;
			uv.y *= 100.;
			float dis = worley5(uv/64.0, + time*50.0);
			vec3 c = mix(vec3(-1.0), vec3(10.), dis);
			vec4 spots = vec4(clamp(c,0.0,1.0), 1.0);
			
			gl_FragColor = gl_FragColor *(1.0-grain) * spots * vig;
		}
	]],
	"	gl_FragColor.a = 1.0;"
)

local patch_barrels = function()
	local barrels = {
		"data/entities/props/physics_barrel_oil.xml",
		"data/entities/props/physics_barrel_radioactive.xml"
	}

	for _,barrel in ipairs(barrels) do
		local content = ModTextFileGetContent(barrel)
		local new_content = [[
<Entity>
		<LuaComponent
			script_source_file="mods/evaisa.backlog/content/evaisa.objects/files/scripts/objects/replace_barrels.lua"
			execute_on_added="1"
			execute_times="1"
		></LuaComponent>
</Entity>
		]]

		ModTextFileSetContent(barrel, new_content)
		ModTextFileSetContent("mods/evaisa.backlog/content/evaisa.objects/replaced/"..barrel, content)
	end

	
end

function OnMagicNumbersAndWorldSeedInitialized()
	patch_barrels()
end

function OnPlayerSpawned(player_entity)

  local x, y = EntityGetTransform(player_entity)

  --[[
  local inventory = nil 

	local player_child_entities = EntityGetAllChildren( player_entity )
	if ( player_child_entities ~= nil ) then
		for i,child_entity in ipairs( player_child_entities ) do
			local child_entity_name = EntityGetName( child_entity )
			
			if ( child_entity_name == "inventory_quick" ) then
				inventory = child_entity
			end

		end
	end

  if ( inventory ~= nil ) then
    --local item_entity = EntityLoad( "mods/evaisa.backlog/content/evaisa.objects/files/entities/tentacle_orb/tentacle_orb.xml" )
    --EntityAddChild( inventory, item_entity )

  end]]


  --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/mirror/mirror.xml", x + 40 , y - 30)
  
    --EntitySave(player, "player.xml")
    
    --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/necro_shrine/necro_shrine_object.xml", x + 40 , y - 40)
	--EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/bouncy_ball/bouncy_ball_object.xml", x + 30 , y - 40)
	--EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel/barrel_random_object.xml", x + 20 , y - 40)
	--EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/sands_of_time/time_sands_object.xml", x + 10 , y - 40)
	--EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel_multiple/barrel_random_object.xml", x + 0 , y - 40)
	--EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/conversion_stone/conversion_stone.xml", x + -80 , y - 40)
--	EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/forgotten_tome/forgotten_tome.xml", x + 80 , y - 40)
  --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/tentacle_orb/tentacle_orb.xml", x + 90 , y - 40)
  --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/perk_ring/perk_ring.xml", x + 90 , y - 40)
  --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/obelysk/obelysk.xml", x + 90 , y - 40)
  --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/obelysk/obelysk.xml", x + 400 , y - 30)
--  EntityLoad("data/entities/animals/shotgunner.xml", x + 430 , y - 30)
    --EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/clone_machine/clone_machine.xml", x + 400 , y - 30)
    --load_forgotten_tome(x + 10, y)
	--EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/white_hole/moon.xml", x + 10 , y - 40)
end



ModMaterialsFileAdd( "mods/evaisa.backlog/content/evaisa.objects/files/scripts/append/append_materials.xml" )
ModLuaFileAppend( "data/scripts/gun/gun_extra_modifiers.lua", "mods/evaisa.backlog/content/evaisa.objects/files/scripts/append/extra_modifiers.lua" )