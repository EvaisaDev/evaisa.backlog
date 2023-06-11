dofile_once("data/scripts/lib/utilities.lua")

local distance_full = 120
local float_range = 50
local float_force = 3
local float_sensor_sector = math.pi * 0.3

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

-- attract various entities

local dir_x = 0
local dir_y = float_range
dir_x, dir_y = vec_rotate(dir_x, dir_y, ProceduralRandomf(x, y + GameGetFrameNum(), -float_sensor_sector, float_sensor_sector))

local did_hit,hit_x,hit_y = RaytracePlatforms( x, y, x + dir_x, y + dir_y )
if did_hit then
	local dist = get_distance(x, y, hit_x, hit_y)
	dist = math.max(6, dist) -- tame a bit on close encounters
	dir_x = -dir_x / dist * float_force
	dir_y = -dir_y / dist * float_force

	local velocity_component = EntityGetFirstComponent(entity_id, "VelocityComponent")

	if(velocity_component ~= nil)then
		local velocity_x, velocity_y = ComponentGetValueVector2( velocity_component, "mVelocity")

		ComponentSetValue2( velocity_component, "mVelocity", velocity_x + dir_x, velocity_y + dir_y )

	end

	--PhysicsApplyForce(entity_id, dir_x, dir_y)
end


local entities = EntityGetInRadius(x, y, distance_full)
if ( #entities == 0 ) then return end

for _,id in ipairs(entities) do	
	if(id ~= entity_id)then

	local physics_body = EntityGetFirstComponent(id, "PhysicsBodyComponent")
	local physics_body2 = EntityGetFirstComponent(id, "PhysicsBody2Component")
	if EntityHasTag(id, "projectile") or
		EntityHasTag(id, "prop") or
		EntityHasTag(id, "gold_nugget") or
		EntityHasTag(id, "mortal") or
		EntityHasTag(id, "hittable") or
		EntityHasTag(id, "teleportable_NOT") or
		EntityHasTag(id, "item_physics") or
		physics_body ~= nil or
		physics_body2 ~= nil then


		--if(EntityHasTag(id, "player_unit") == false)then

			local px, py = EntityGetTransform( id )
			
			local gravity_coeff = 50
			
			local direction_x = px - x

			local direction_y = py - y

			local len = math.sqrt((direction_x*direction_x) + (direction_y*direction_y))

			local dir_x = direction_x / len
			local dir_y = direction_y / len

			local gravity_percent = ( distance_full - len ) / distance_full
			
			local force_main = ( gravity_coeff * gravity_percent )

			--local velocity_component = EntityGetFirstComponent(id, "VelocityComponent")


			local char_data = EntityGetFirstComponent(id, "CharacterDataComponent")
			if(char_data ~= nil)then
				local velocity_x, velocity_y = ComponentGetValueVector2( char_data, "mVelocity")

				local force_x = velocity_x + (dir_x * force_main * 10)
				local force_y = velocity_y + (dir_y * force_main * 10)

				if(EntityHasTag(id, "player_unit"))then
					force_x = velocity_x + (dir_x * force_main / 5)
					force_y = velocity_y + (dir_y * force_main / 5)				
				end
				ComponentSetValue2( char_data, "mVelocity", force_x, force_y )			
			end


	
			if(velocity_component ~= nil)then
				local velocity_x, velocity_y = ComponentGetValueVector2( velocity_component, "mVelocity")



				local force_x = velocity_x + (dir_x * force_main)
				local force_y = velocity_y + (dir_y * force_main)
				
				ComponentSetValue2( velocity_component, "mVelocity", force_x, force_y )

			end

			if(physics_body ~= nil or physics_body2 ~= nil)then
				PhysicsApplyForce(id, (dir_x * force_main), (dir_y * force_main))
			end
		end
		--end


--[[


		local velocitycomp = EntityGetFirstComponent( id, "VelocityComponent" )
		
		local gravity_percent = ( distance_full - distance ) / distance_full
		local gravity_coeff = 196
		
		local offset_x = math.cos( direction ) * ( gravity_coeff * gravity_percent )
		local offset_y = 0 - math.sin( direction ) * ( gravity_coeff * gravity_percent )

		if ( velocitycomp ~= nil ) then
			edit_component( id, "VelocityComponent", function(comp,vars)
				--local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
				local vel_x,vel_y = ComponentGetValue2( comp, "mVelocity")
				
				vel_x = vel_x + offset_x
				vel_y = vel_y + offset_y

				--ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)
				ComponentSetValue2( comp, "mVelocity", vel_x, vel_y)
			end)
		else
			-- add force instead
			PhysicsApplyForce(id, offset_x * -5, offset_y * -5)
		end]]


	end
end


