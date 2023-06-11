local function register_item(listname, weight, entity, offset) -- use this to register an item in spawn table
    if ( type( listname ) == "string" ) then
        local newmin = spawnlists[listname].rnd_max + 1
        local newmax = newmin + weight
        local tbl = {
            value_min = newmin,
            value_max = newmax,
            offset_y = offset,
            load_entity = entity
        }
        table.insert(spawnlists[listname].spawns, tbl)
        spawnlists[listname].rnd_max = newmax
    elseif ( type( listname ) == "table" ) then
        local newmin = listname.rnd_max + 1
        local newmax = newmin + weight
        local tbl = {
            value_min = newmin,
            value_max = newmax,
            offset_y = offset,
            load_entity = entity
        }
        table.insert(listname.spawns, tbl)
        listname.rnd_max = newmax
    end
end


local items = {
    {
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/bouncy_ball/bouncy_ball_object.xml",
        offset = -5
    },
    {
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/conversion_stone/conversion_stone.xml",
        offset = -3
    },
    {
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/cowboy_hat/cowboy_hat.xml",
        offset = -3
    },
    {
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/mirror/mirror.xml",
        offset = -3
    },
    {
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/perk_ring/perk_ring.xml",
        offset = -3
    },
    {
        weight = 2,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/sands_of_time/time_sands_object.xml",
        offset = -3
    },
    {
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/tentacle_orb/tentacle_orb.xml",
        offset = -3
    },
    {
        weight = 2,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/forgotten_tome/forgotten_tome.xml",
        offset = -3
    }
    --[[{
        weight = 3,
        entity = "mods/evaisa.backlog/content/evaisa.objects/files/entities/white_hole/moon.xml",
        offset = -3
    },]]
}

for i, v in ipairs(items) do
    register_item("potion_spawnlist", v.weight, v.entity, v.offset)
end
