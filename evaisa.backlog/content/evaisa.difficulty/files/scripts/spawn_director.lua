dofile("mods/evaisa.backlog/content/evaisa.difficulty/files/scripts/utilities.lua")

gui = gui or GuiCreate()

local current_id = 10
local function new_id()
    current_id = current_id + 1
    return current_id
end

GuiStartFrame(gui)

local spawners = {}
local cam_x, cam_y = GameGetCameraPos()
local spawner_entities = EntityGetInRadiusWithTag(cam_x, cam_y, 200, "enemy_spawner")
local on_screen_spawners = EntityGetInRadiusWithTag(cam_x, cam_y, 150, "enemy_spawner")

local difficulties = {
    noob = 1,
    easy = 2,
    normal = 3,
    hard = 4,
    nightmare = 5,
    death = 6,
    dev = 200
}

local spawner_types = {
    small = 1,
    big = 2,
}

-- loop through spawner entities and make sure they are not on screen
for i, spawner in ipairs(spawner_entities) do
    local is_on_screen = false
    for j, on_screen_spawner in ipairs(on_screen_spawners) do
        if(spawner == on_screen_spawner)then
            is_on_screen = true
            break
        end
    end

    
    local time_since_last_monster = EntityGetVariable(spawner, "time_since_last_monster", "int") or 60


    if(not is_on_screen and time_since_last_monster > 10)then
        local x, y = EntityGetTransform(spawner)

        local enemy_type = spawner_types.small
        if(EntityHasTag(spawner, "big_enemies"))then
            enemy_type = spawner_types.big
        end

        table.insert(spawners, {
            entity = spawner,
            x = x,
            y = y,
            biome_script = EntityGetName(spawner),
            type = enemy_type
        })
    end
end

local spawn_credits = 1
time = time or GlobalsGetValue("time", 1)


local selectedDifficulty = (ModSettingGet("evaisa.backlog.difficulty.difficulty") and difficulties[ModSettingGet("evaisa.backlog.difficulty.difficulty")]) or difficulties["noob"]
local biomes_visited = StatsGetValue("places_visited") or 1

local factor1 = 0.0506 * selectedDifficulty
local factor2 = 1.15^biomes_visited
local coeff = ((time / 60 / 60) * factor1) * factor2
-- inverse exponential coeff
local logarithmic_coeff = math.log(coeff+1, 2)

--[[
coeff_history = coeff_history or "coef: "
coeff_history = coeff_history .. "," .. coeff
]]

--logarithmic_history = logarithmic_history or "loga: "
--logarithmic_history = logarithmic_history .. "," .. logarithmic_coeff

--print(coeff_history)
--print(logarithmic_history)

--GamePrint("coeff: "..tostring(coeff)..", scale: "..tostring(logarithmic_coeff))

spawn_credits = math.floor(spawn_credits * (1 + (logarithmic_coeff * 2.5)))

local active_enemies = EntityGetInRadiusWithTag(cam_x, cam_y, 250, "enemy")

local active_bosses = EntityGetInRadiusWithTag(cam_x, cam_y, 250, "boss")

for i, boss in ipairs(active_bosses) do
    -- check if active enemies contains boss
    local is_active = false
    for j, enemy in ipairs(active_enemies) do
        if(boss == enemy)then
            is_active = true
            break
        end
    end
    if(not is_active)then
        table.insert(active_enemies, boss)
    end
end

local active_enemies_count = #active_enemies

local spawn_credits = spawn_credits - active_enemies_count

--GamePrint("Difficulty: "..tostring(coeff))




--GamePrint("Spawners: "..#spawners)
--GamePrint("Active Enemies: "..active_enemies_count)
--GamePrint("Spawn Credits: "..spawn_credits)


local function UpdateDifficultyValues()
    local player_entity = EntityGetClosestWithTag( 0, 0, "player_unit")
    local active_projectiles = EntityGetInRadiusWithTag(cam_x, cam_y, 300, "projectile")
    
    for i, projectile in ipairs(active_projectiles)do
        if(not EntityHasTag(projectile, "difficulty_scaled"))then
            local projectile_comp = EntityGetFirstComponent(projectile, "ProjectileComponent")
            local mShooterHerdId = ComponentGetValue2(projectile_comp, "mShooterHerdId")
            local mWhoShot = ComponentGetValue2(projectile_comp, "mWhoShot")
            if(mWhoShot ~= player_entity and mShooterHerdId ~= 0)then
                local velocity_comp = EntityGetFirstComponent(projectile, "VelocityComponent")
                local velocity_x, velocity_y = ComponentGetValue2(velocity_comp, "mVelocity")
                velocity_x = velocity_x * (logarithmic_coeff + 0.5)
                velocity_y = velocity_y * (logarithmic_coeff + 0.5)
                ComponentSetValue2(velocity_comp, "mVelocity", velocity_x, velocity_y)
                EntityAddTag(projectile, "difficulty_scaled")
            end
        end
    end

    for i, enemy in ipairs(active_enemies) do
        if(not EntityHasTag(enemy, "difficulty_scaled"))then
            local damage_model_comp = EntityGetFirstComponentIncludingDisabled(enemy, "DamageModelComponent")
            local health = ComponentGetValue2(damage_model_comp, "hp")
            local max_health = ComponentGetValue2(damage_model_comp, "max_hp")

            if(not EntityGetVariable(enemy, "original_hp", "float"))then
                EntitySetVariable(enemy, "original_hp", "float", health )
                EntitySetVariable(enemy, "original_maxhp", "float", max_health)
            else
                health = EntityGetVariable(enemy, "original_hp", "float")
                max_health = EntityGetVariable(enemy, "original_maxhp", "float")
            end

            max_health = max_health * (1 + (logarithmic_coeff * 2))
            health = health * (1 + (logarithmic_coeff * 2))
            ComponentSetValue2(damage_model_comp, "max_hp", max_health)
            ComponentSetValue2(damage_model_comp, "hp", health)
            EntityAddTag(enemy, "difficulty_scaled")
        end
    end
    

    local damagemodels = EntityGetComponent( player_entity, "DamageModelComponent" )
    if( damagemodels ~= nil ) then
        for i,damagemodel in ipairs(damagemodels) do
            
            local melee = tonumber(damage_multipliers["melee"])
            local projectile = tonumber(damage_multipliers["projectile"])
            local explosion = tonumber(damage_multipliers["explosion"])
            local electricity = tonumber(damage_multipliers["electricity"])
            local fire = tonumber(damage_multipliers["fire"])
            local drill = tonumber(damage_multipliers["drill"])
            local slice = tonumber(damage_multipliers["slice"])
            local ice = tonumber(damage_multipliers["ice"])
            local healing = tonumber(damage_multipliers["healing"])
            local physics_hit = tonumber(damage_multipliers["physics_hit"])
            local radioactive = tonumber(damage_multipliers["radioactive"])
            local poison = tonumber(damage_multipliers["poison"])
    
            melee = melee * (1 + (logarithmic_coeff / 3))
            projectile = projectile * (1 + (logarithmic_coeff / 3))
            explosion = explosion * (1 + (logarithmic_coeff / 3))
            electricity = electricity * (1 + (logarithmic_coeff / 3))
            fire = fire * (1 + (logarithmic_coeff / 3))
            drill = drill * (1 + (logarithmic_coeff / 3))
            slice = slice * (1 + (logarithmic_coeff / 3))
            ice = ice * (1 + (logarithmic_coeff / 3))
            radioactive = radioactive * (1 + (logarithmic_coeff / 3))
            poison = poison * (1 + (logarithmic_coeff / 3))
    
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "melee", tostring(melee) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "projectile", tostring(projectile) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "explosion", tostring(explosion) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "electricity", tostring(electricity) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "fire", tostring(fire) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "drill", tostring(drill) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "slice", tostring(slice) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "ice", tostring(ice) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "healing", tostring(healing) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "physics_hit", tostring(physics_hit) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "radioactive", tostring(radioactive) )
            ComponentObjectSetValue( damagemodel, "damage_multipliers", "poison", tostring(poison) )
    
        end
    end
end


if(#spawners > 0 and spawn_credits > 0)then
    SetRandomSeed(GameGetFrameNum() + StatsGetValue("world_seed") + cam_x, GameGetFrameNum() + StatsGetValue("world_seed") + cam_y)

    for i = 1, spawn_credits do
        local random_spawner = spawners[Random(1, #spawners)]
        local spawner_x, spawner_y = random_spawner.x, random_spawner.y
        local biome_script = random_spawner.biome_script
        local enemy_type = random_spawner.type
        local spawner = random_spawner.entity

        RegisterSpawnFunction = function () end
        --print(get_content(biome_script))
        dofile(biome_script)
        --GamePrint("Spawning enemy")
        
        if(enemy_type == spawner_types.small)then
            orig_spawn_small_enemies(spawner_x, spawner_y, 0, 0, false)
        elseif(enemy_type == spawner_types.big)then
            orig_spawn_big_enemies(spawner_x, spawner_y, 0, 0, false)
        end
        
        EntitySetVariable(spawner, "time_since_last_monster", "int", 0)

    end

    UpdateDifficultyValues()
end

local screen_x, screen_y = GuiGetScreenDimensions(gui)

local bar_width = 100
local bar_height = 10


local bar_data = {
    -- easy
    {
        color = {89, 204, 73},
        name = "Easy",
    },
    -- normal
    {
        color = {189, 207, 31},
        name = "Normal",
    },
    --hard
    {
        color = {201, 150, 8},
        name = "Hard",
    },
    -- very hard
    {
        color = {201, 37, 8},
        name = "Very Hard",
    },
    -- insane
    {
        color = {130, 9, 9},
        name = "Insane",
    },
    -- impossible
    {
        color = {89, 4, 27},
        name = "Impossible",
    },
    -- I SEE YOU
    {
        color = {110, 11, 72},
        name = "I SEE YOU",
    },
    -- I'M COMING FOR YOU
    {
        color = {57, 35, 120},
        name = "I'M COMING FOR YOU",
    },
    -- HAHAHAHAHAHAHAHAHAHA
    {
        color = {22, 15, 43},
        name = "HAHAHAHAHAHAHAHAHA",
    },
}

local function RenderDifficultyBar()

    local bar_offset_x = ModSettingGet("evaisa.backlog.difficulty.x_offset") and tonumber(ModSettingGet("evaisa.backlog.difficulty.x_offset")) or 0
    local bar_offset_y = ModSettingGet("evaisa.backlog.difficulty.y_offset") and tonumber(ModSettingGet("evaisa.backlog.difficulty.y_offset")) or 0

    GuiLayoutBeginHorizontal(gui, screen_x - (bar_width + 8) + bar_offset_x,  screen_y - (bar_height + 8) + bar_offset_y, true, 0, 0)

    GuiZSetForNextWidget(gui, 10)
    -- border
    GuiImage(gui, new_id(), 0, 0, "mods/evaisa.backlog/content/evaisa.difficulty/files/gfx/difficulty_bar.png", 1, 1, 1, 0)
    GuiZSetForNextWidget(gui, 100)
    local background_color = {41, 35, 32}
    GuiColorSetForNextWidget(gui, background_color[1] / 255, background_color[2] / 255, background_color[3] / 255, 1)
    -- background
    GuiImage(gui, new_id(), -bar_width, 1, "mods/evaisa.backlog/content/evaisa.difficulty/files/gfx/square.png", 1, bar_width / 8, 1, 0)

    GuiZSet(gui, 11)
    -- segment bar based on difficulty position
    local current_bar_position = math.floor(coeff * 100) / 100
    local full_width = (bar_width / 2) / 8

    local main_offset = 0
    main_position = main_position or 0

    current_diff = current_diff or nil

    for i, v in ipairs(bar_data) do
        GuiColorSetForNextWidget(gui, v.color[1] / 255, v.color[2] / 255, v.color[3] / 255, 1)

        local range_max = i - 0.5
        local range_min = range_max - 0.5
        local width = full_width
        
        if(current_bar_position > range_min - 0.5)then
            current_diff = v
        end

        local offset = 0
        if(i == 1)then
            offset = -bar_width / 2
            offset = offset - (bar_width * current_bar_position)

            if(offset < -bar_width)then
                offset = -bar_width
            else
                main_position = current_bar_position
            end

            main_offset = offset
            
        end

        if((main_offset == -bar_width and current_bar_position - range_max > 0) and not (i == #bar_data))then
            width = width * ((1 - (current_bar_position - (range_max))))
        end

        if(current_bar_position < range_min or (i == #bar_data))then
            local diff = (range_min - current_bar_position) - main_position
            width = width * (1 - diff)
            if(width > full_width and not (i == #bar_data))then
                width = full_width
            elseif(width > full_width * 2 and (i == #bar_data))then
                width = full_width * 2
            end
        end

        width = width < 0 and 0 or width

        GuiImage(gui, new_id(), offset, 1, "mods/evaisa.backlog/content/evaisa.difficulty/files/gfx/square.png", 1, width, 1, 0)
    end

    GuiImage(gui, new_id(), -100, 1, "mods/evaisa.backlog/content/evaisa.difficulty/files/gfx/lines2.xml", 0.07, 1, 1, 0, 2, "default")

    local text_width, text_height = GuiGetTextDimensions(gui, current_diff.name)
    local text_x = (bar_width / 2) + (text_width / 2)
    GuiColorSetForNextWidget(gui, 1, 1, 1, 1)
    GuiZSetForNextWidget(gui, 10)
    GuiText(gui, -text_x, -(bar_height + 2), current_diff.name)
    GuiColorSetForNextWidget(gui, 0, 0, 0, 0.5)
    GuiZSetForNextWidget(gui, 11)
    GuiText(gui, -text_width, -(bar_height + 1), current_diff.name)

    GuiZSetForNextWidget(gui, 9)

    if(ModSettingGet("evaisa.backlog.difficulty.show_difficulty_coeff"))then
        local coeff_width, coeff_height = GuiGetTextDimensions(gui, tostring(math.floor(coeff * 100) / 100))
        GuiText(gui,  (-((text_width / 2) + (bar_width / 2))) + 4, 0, tostring(math.floor(coeff * 100) / 100))
    end

    GuiLayoutEnd(gui)
end



RenderDifficultyBar()


UpdateDifficultyValues()

if(not (BiomeMapGetName() == "$biome_holymountain" and ModSettingGet("evaisa.backlog.difficulty.pause_in_mountain")) and not ModSettingGet("evaisa.backlog.difficulty.paused"))then
    time = time + 1
end

if(GameGetFrameNum() % 60 == 0)then
    
    GlobalsSetValue("time", time)
end
