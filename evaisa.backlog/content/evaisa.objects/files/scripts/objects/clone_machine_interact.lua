function interacting( entity_who_interacted, entity_interacted, interactable_name )
    local entity = entity_interacted

    local x, y = EntityGetTransform(entity)

    GlobalsSetValue(entity.."_who_interacted", tostring(entity_who_interacted))

    EntityAddTag(entity, "machine_active")

    EntityLoadToEntity("mods/evaisa.backlog/content/evaisa.objects/files/entities/clone_machine/effects.xml", entity)

    local interactable = EntityGetFirstComponent(entity, "InteractableComponent")

    EntityRemoveComponent(entity, interactable)
end