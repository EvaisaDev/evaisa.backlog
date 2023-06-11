dofile_once("data/scripts/lib/utilities.lua")
dofile_once("mods/evaisa.backlog/content/evaisa.objects/files/scripts/utils/utilities.lua")

local distance_full = 20

local entity_id = GetUpdatedEntityID()
local x, y, rot = EntityGetTransform( entity_id )

local player = get_players()[1]

-- attract various entities
local entities = EntityGetInRadiusWithTag(x, y, distance_full, "projectile")
if ( #entities == 0 ) then return end

if(tonumber(GlobalsGetValue(entity_id.."_max_uses", "8")) == 5)then
    GamePrint("The mirror is starting to crack..")
end

if(tonumber(GlobalsGetValue(entity_id.."_max_uses", "8")) == 1)then
    GamePrint("The mirror is about to break..")
end

if(tonumber(GlobalsGetValue(entity_id.."_max_uses", "8")) == 0)then

    --GamePlaySound( "data/audio/Desktop/materials.snd", "collision/glass_potion", x, y )

    EntityRemoveFromParent( entity_id )
    if(player ~= nil)then
        local inventory2_comp = EntityGetFirstComponent(player, "Inventory2Component")
        if inventory2_comp then
            item = ComponentGetValue(inventory2_comp, "mActiveItem")
            ComponentSetValue(inventory2_comp, "mActiveItem", "0")
        end
    end

    local components = table.merge({EntityGetComponentIncludingDisabled(entity_id, "AudioComponent"),EntityGetComponentIncludingDisabled(entity_id, "DamageModelComponent"),EntityGetComponentIncludingDisabled(entity_id, "ExplodeOnDamageComponent"),EntityGetComponentIncludingDisabled(entity_id, "PhysicsBodyComponent"),EntityGetComponentIncludingDisabled(entity_id, "VelocityComponent")})

    for k, v in pairs(components)do
        EntitySetComponentIsEnabled(entity_id, v, true)
    end

    --zzEntitySave(entity_id, "mirror.xml")
    --GameDropPlayerInventoryItems( entity_id )
   -- EntityKill(entity_id)

    EntityInflictDamage(entity_id, 20,"DAMAGE_PHYSICS_BODY_DAMAGED", "killed", "NONE", 0, 0, entity_id, x, y, 0)

    GamePrint("The mirror shattered!")
end

if(tonumber(GlobalsGetValue(entity_id.."_max_uses", "8")) > 0)then
    for _,id in ipairs(entities) do	
        if(EntityHasTag(id, "returned_projectile") ~= true)then
            local velocity_component = EntityGetFirstComponent(id, "VelocityComponent")
            if(velocity_component ~= nil)then
                local velocity_x, velocity_y = ComponentGetValueVector2( velocity_component, "mVelocity")


                
                GlobalsSetValue(entity_id.."_max_uses", tostring(tonumber(GlobalsGetValue(entity_id.."_max_uses", "8")) - 1))
            


              --  GamePrint("Projectile returned to sender")
                EntityAddTag(id, "returned_projectile")
                local force_x = -velocity_x
                local force_y = -velocity_y

                local projectile_component = EntityGetFirstComponent(id, "ProjectileComponent")
                
                if(projectile_component ~= nil)then
                    ComponentSetValue2(projectile_component, "friendly_fire", true)
                    ComponentSetValue2(projectile_component, "collide_with_shooter_frames", 1)
                end

                ComponentSetValue2( velocity_component, "mVelocity", force_x, force_y )



                

            end
        end
    end

end