local t = GameGetRealWorldTimeSinceStarted();
local now = GameGetFrameNum();

local player_entity = GetUpdatedEntityID();
local x, y = EntityGetTransform( player_entity );

local function swapCardEntity(card, spell_id)
    local card_x, card_y = EntityGetTransform(card)
    local action_comp = EntityGetFirstComponentIncludingDisabled(card, "ItemActionComponent")
    local item_comp = EntityGetFirstComponentIncludingDisabled(card, "ItemComponent")
    if(action_comp ~= nil and item_comp ~= nil)then
        local permanent = ComponentGetValue2(item_comp, "permanently_attached")
        local cost = EntityGetFirstComponent(v, "ItemCostComponent")
        local price = nil
        local stealable = nil
        if(cost ~= nil)then
            price = ComponentGetValue2(cost, "cost")
            stealable = ComponentGetValue2(cost, "stealable")
        end

        local action_entity = CreateItemActionEntity( spell_id, card_x, card_y )

        EntityAddTag(action_entity, "NOT_TMTRAINER")

        EntityAddComponent2(action_entity, "ItemCostComponent", {
            cost = price,
            stealable = stealable,
        })

        if(permanent)then
            local new_item_comp = EntityGetFirstComponentIncludingDisabled(action_entity, "ItemComponent")
            ComponentSetValue2(new_item_comp, "permanently_attached", true)
        end

        local sprite_comp = EntityGetFirstComponentIncludingDisabled(action_entity, "SpriteComponent")

        local has_parent = (EntityGetRootEntity(card) ~= card)

        if(has_parent)then
            local parent = EntityGetParent(card)
            EntitySetComponentsWithTagEnabled(action_entity, "enabled_in_world", false)
            EntitySetComponentsWithTagEnabled(action_entity, "enabled_in_inventory", true)
            EntityAddChild(parent, action_entity)
            local parent_has_parent = (EntityGetRootEntity(parent) ~= parent)
            if(parent_has_parent)then
                local parent_parent = EntityGetParent(parent)
                if(EntityGetName(parent_parent) == "inventory_quick")then
                    local player = EntityGetParent(parent_parent)
                    local inventoryComp = EntityGetFirstComponentIncludingDisabled(player, "Inventory2Component")
                    if(inventoryComp ~= nil)then
                        local activeItem = ComponentGetValue2(inventoryComp, "mActiveItem")
                        if(activeItem == parent)then
                            EntitySetComponentsWithTagEnabled(action_entity, "enabled_in_hand", true)
                        end
                    end
                end
            end
        else
            EntitySetComponentsWithTagEnabled(action_entity, "enabled_in_world", true)
            EntitySetComponentsWithTagEnabled(action_entity, "enabled_in_inventory", false)
        end

        EntityKill(card)

    end
end


if now % 30 == 0 then

    dofile_once( "data/scripts/gun/gun_enums.lua")
    dofile_once("data/scripts/gun/gun_actions.lua")
    

    typeMap = typeMap or nil
    TMTRAINER_MAP = TMTRAINER_MAP or nil
    
    if(TMTRAINER_MAP == nil)then
        TMTRAINER_MAP = {}
        for i, action in ipairs(actions)do
            if(action.tm_trainer)then
                if(TMTRAINER_MAP[action.type] == nil)then
                    TMTRAINER_MAP[action.type] = {}
                end
                table.insert(TMTRAINER_MAP[action.type], action.id)
            end
        end
    end
    
    if(typeMap == nil)then
        typeMap = {}
        for i, action in ipairs(actions)do
            typeMap[action.id] = action.type
        end
    end
    
    local function getTMTrainerSpellOfType(type)
        local spells = TMTRAINER_MAP[type]
        if(spells ~= nil)then
            return spells[Random(1, #spells)]
        end
    end

	SetRandomSeed(x + GameGetFrameNum() + StatsGetValue("world_seed"), y + GameGetFrameNum() + StatsGetValue("world_seed"))

	local card_entities = EntityGetWithTag( "card_action" )
	for k, v in ipairs(card_entities)do
        if(GameHasFlagRun("TMTRAINER") and not EntityHasTag(v, "NOT_TMTRAINER"))then
            EntityAddTag(v, "NOT_TMTRAINER")
            local action_comp = EntityGetFirstComponentIncludingDisabled(v, "ItemActionComponent")
            if(action_comp ~= nil)then
                local id = ComponentGetValue2(action_comp, "action_id")
                local type = typeMap[id]
                local new_spell = getTMTrainerSpellOfType(type)
                if(new_spell ~= nil)then
                    swapCardEntity(v, new_spell)
                end
                
            end
        else
            if(not EntityHasTag(v, "NOT_TMTRAINER"))then
                EntityAddTag(v, "NOT_TMTRAINER")
            end
        end
	end
end
