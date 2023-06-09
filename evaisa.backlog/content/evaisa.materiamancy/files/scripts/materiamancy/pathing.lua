dofile_once( "data/scripts/lib/utilities.lua" )

local entity_id = GetUpdatedEntityID()

initial_direction = initial_direction or nil

local projectile_comp = EntityGetFirstComponentIncludingDisabled(entity_id, "ProjectileComponent")
if projectile_comp ~= nil then
    local who_shot = ComponentGetValue2(projectile_comp, "mWhoShot")
    if who_shot ~= nil then

        local controls_component = EntityGetFirstComponentIncludingDisabled(who_shot, "ControlsComponent")
        if controls_component ~= nil then
            local x, y = ComponentGetValue2(controls_component, "mMousePosition")
            

            local pos_x, pos_y = EntityGetTransform( entity_id )

            local dir = initial_direction or get_direction(  x,y,pos_x, pos_y )

            SetRandomSeed( GameGetFrameNum(), pos_x + pos_y + x + y + entity_id )

            local max_dir_ratio_change = 1

            edit_component( entity_id, "VelocityComponent", function(comp,vars)
                if(initial_direction == nil)then
                    initial_direction = dir

                    local new_dir = dir + ((Random(0,2) - 1) * math.pi / 3)

                    local speed = 10
                    local new_vel_x = math.cos( new_dir ) * speed
                    local new_vel_y = 0 - math.sin( new_dir ) * speed

                    ComponentSetValueVector2( comp, "mVelocity", new_vel_x, new_vel_y)
                end

                local vel_x,vel_y = ComponentGetValueVector2( comp, "mVelocity")
                local vel = get_magnitude(vel_x,vel_y)
                if vel <= 900 then
                    if vel <= 30 then
                        vel = 30
                    end
                    vel = vel * 1.3
                end
                local ratio = max_dir_ratio_change * (math.min(vel,600)/600)

                --[[
                if get_distance(x, y, pos_x, pos_y) <= 10 then
                    ComponentSetValue2( projectile_comp, "lifetime", 1)
                    return
                end
                ]]

                local dir2 = 0 - math.atan2( vel_y, vel_x )
                local delta = math.atan2( math.sin( dir - dir2 ), math.cos( dir - dir2 ) )
                if math.abs(delta) >= math.pi/2 then
                    delta = (math.pi/2) * (delta/math.abs(delta))
                end
                local newdir = dir2 + delta * ratio
                local addx = math.cos( newdir ) * vel
                local addy = 0 - math.sin( newdir ) * vel
                vel_x = addx
                vel_y = addy
                ComponentSetValueVector2( comp, "mVelocity", vel_x, vel_y)


            end)
        end
    end
end