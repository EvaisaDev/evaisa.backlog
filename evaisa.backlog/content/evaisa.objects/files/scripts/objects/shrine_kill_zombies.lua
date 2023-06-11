
function death( damage_type_bit_field, damage_message, entity_thats_responsible, drop_items )
    local entity_id = GetUpdatedEntityID()

    local x, y = EntityGetTransform(entity_id)

    local zombies = EntityGetInRadiusWithTag(x, y, 300, "die_on_shrine_death")

    GamePrint("Shrine died")

    for k, zombie in pairs(zombies)do
        EntityInflictDamage(zombie, 99999,"DAMAGE_PHYSICS_BODY_DAMAGED", "killed", "BLOOD_EXPLOSION", 0, 0, entity_id, x, y, 0)
    end
end