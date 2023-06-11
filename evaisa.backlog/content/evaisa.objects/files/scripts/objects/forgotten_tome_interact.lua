function interacting( entity_who_interacted, entity_interacted, interactable_name )
    local entity = entity_interacted

    local x, y = EntityGetTransform(entity)

    GlobalsSetValue(entity.."_x", tostring(x))
    GlobalsSetValue(entity.."_y", tostring(y - 10))
    EntityAddTag(entity, "tome_active")

    EntityLoadToEntity("mods/evaisa.backlog/content/evaisa.objects/files/entities/forgotten_tome/effects.xml", entity)

    local interactable = EntityGetFirstComponent(entity, "InteractableComponent")

    EntityRemoveComponent(entity, interactable)
end