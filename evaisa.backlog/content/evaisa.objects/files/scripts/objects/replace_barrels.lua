local entity = GetUpdatedEntityID()

local x, y = EntityGetTransform(entity)

local barrels = {
    "mods/evaisa.backlog/content/evaisa.objects/replaced/data/entities/props/physics_barrel_oil.xml",
    "mods/evaisa.backlog/content/evaisa.objects/replaced/data/entities/props/physics_barrel_radioactive.xml",
}

if( Random( 1, 100 ) < 80 ) then
    local barrel = barrels[Random(1, #barrels)]
    EntityLoad(barrel, x, y)
    --print("loaded: " .. barrel)
else
    --[[local weighted_list = {
        {
            "mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel/barrel_random_object.xml",
            weight = 70
        },
        {
            "mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel_multiple/barrel_random_object.xml",
            weight = 30
        },
        {
            "mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel_multiple/barrel_random_object.xml",
        },
    }]]


    if(Random( 1, 100 ) < 50 )then
        EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel/barrel_random_object.xml", x, y)
        --print("loaded: " .. "mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel/barrel_random_object.xml")
    else
        EntityLoad("mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel_multiple/barrel_random_object.xml", x, y)
        --print("loaded: " .. "mods/evaisa.backlog/content/evaisa.objects/files/entities/random_barrel_multiple/barrel_random_object.xml")
    end
end

EntityKill(entity)

