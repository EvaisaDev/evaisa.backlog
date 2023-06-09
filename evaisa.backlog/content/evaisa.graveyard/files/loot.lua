local EZWand = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/EZWand/EZWand.lua")
local smallfolk = dofile_once("mods/evaisa.backlog/content/evaisa.graveyard/lib/smallfolk.lua")

-- function to remove a loadout by its id

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


function interacting( entity_who_interacted, entity_interacted, interactable_name )
    local total_loadouts_stored = ModSettingGet("graveyard_storage_count") or 0

    local grave = entity_interacted

    local loadout_string = nil
    local loadout_id = nil
    local variableStorageComponents = EntityGetComponentIncludingDisabled(grave, "VariableStorageComponent")
    if(variableStorageComponents ~= nil)then
        for i, v in ipairs(variableStorageComponents) do
            local name = ComponentGetValue2(v, "name")
            if(name == "loadout")then
                loadout_string = ComponentGetValue2(v, "value_string")
            elseif(name == "loadout_id")then
                loadout_id = ComponentGetValue2(v, "value_int")
            end
        end
    end

    print(tostring(loadout_string))
    
    local x, y = EntityGetTransform(grave)


    local interactable = EntityGetFirstComponent(grave, "InteractableComponent")
    if(loadout_string == nil or loadout_id == nil)then
        EntityLoad("data/entities/particles/image_emitters/chest_effect_bad.xml", x, y)
        EntityKill( entity_interacted )
        return
    end

    local loadout = smallfolk.loadsies(loadout_string)

    for k, v in ipairs(loadout.wands) do
        local wand = EZWand(v)
        --wand:PlaceAt(x, y)
        local wand_entity = wand.entity_id
        
        EntityApplyTransform(wand_entity, x, y)

        local item_component = EntityGetFirstComponentIncludingDisabled(wand_entity, "ItemComponent")
        if(item_component ~= nil)then
            ComponentSetValue2(item_component, "play_hover_animation", false)
            ComponentSetValue2(item_component, "play_spinning_animation", true)
        end
        local simple_physics_component = EntityGetFirstComponentIncludingDisabled(wand_entity, "SimplePhysicsComponent")
        if(simple_physics_component ~= nil)then
            EntitySetComponentIsEnabled(wand_entity, simple_physics_component, true)
        end
        local sprite_particle_emitter_component = EntityGetComponentIncludingDisabled(wand_entity, "SpriteParticleEmitterComponent") or {}
        for i, component in ipairs(sprite_particle_emitter_component) do
            EntitySetComponentIsEnabled(wand_entity, component, false)
        end
        local velocity_component = EntityGetFirstComponentIncludingDisabled(wand_entity, "VelocityComponent")
        if(velocity_component ~= nil)then
            
            SetRandomSeed(x + entity_interacted + (wand_entity * 100), y + entity_interacted + GameGetFrameNum() * wand_entity)
            EntitySetComponentIsEnabled(wand_entity, velocity_component, true)
            local rand = Random(-50, 50)
            local vel_x, vel_y = rand, -100
            ComponentSetValue2(velocity_component, "mVelocity", vel_x, vel_y)
        end

        print("Wand: " .. tostring(wand_entity))
    end

    if(type(loadout.spells) == "table")then
        for k, v in ipairs(loadout.spells)do
            local action = CreateItemActionEntity( v, x, y )

            local velocity_component = EntityGetFirstComponentIncludingDisabled(action, "VelocityComponent")
            if(velocity_component ~= nil)then
                
                SetRandomSeed(x + entity_interacted + (action * 100), y + entity_interacted + GameGetFrameNum() * action)
                EntitySetComponentIsEnabled(action, velocity_component, true)
                local rand = Random(-50, 50)
                local vel_x, vel_y = rand, -100
                ComponentSetValue2(velocity_component, "mVelocity", vel_x, vel_y)
            end
        end
    end
    ModSettingRemove("graveyard_storage_" .. loadout_id)
    validateLoadouts()
    
    EntityLoad("data/entities/particles/image_emitters/chest_effect.xml", x, y)

    EntityKill( entity_interacted )
end