local nxml = dofile("mods/evaisa.backlog/content/evaisa.difficulty/lib/nxml.lua")

local all_biomes_file = ModTextFileGetContent("data/biome/_biomes_all.xml")
local all_biomes_xml = nxml.parse(all_biomes_file)

local biome_files = {}

for elem in all_biomes_xml:each_child() do
    if(elem.name == "Biome" and elem.attr.biome_filename ~= nil)then
        biome_files[elem.attr.biome_filename] = true
        print("Biome found: "..elem.attr.biome_filename)
    end
end

local biome_scripts = {} 
for file, v in pairs(biome_files)do
    local biome_file_content = ModTextFileGetContent(file)
    local biome_xml = nxml.parse(biome_file_content)
    for elem in biome_xml:each_child() do
        if(elem.name == "Topology" and elem.attr.lua_script ~= nil)then
            biome_scripts[elem.attr.lua_script] = true
        end
    end
end

for script, v in pairs(biome_scripts)do
    local script_file = ModTextFileGetContent(script)
    -- replace `spawn_small_enemies(x, y, w, h, is_open_path)` with `orig_spawn_small_enemies(x, y, w, h, is_open_path)`
    -- replace `spawn_big_enemies(x, y, w, h, is_open_path)` with `orig_spawn_big_enemies(x, y, w, h, is_open_path)`

    local function literalize(str)
        return str:gsub("[%(%)%.%%%+%-%*%?%[%]%^%$]", function(c) return "%" .. c end)
    end
    

    script_file = script_file:gsub(literalize("spawn_small_enemies(x, y, w, h, is_open_path)"), "orig_spawn_small_enemies(x, y, w, h, is_open_path)")
    script_file = script_file:gsub(literalize("spawn_big_enemies(x, y, w, h, is_open_path)"), "orig_spawn_big_enemies(x, y, w, h, is_open_path)")

    script_file = script_file .. "\n" ..[[
        function spawn_small_enemies(x, y, w, h, is_open_path)
            local spawner = EntityLoad("mods/evaisa.backlog/content/evaisa.difficulty/files/entities/spawner.xml", x, y)
            EntitySetName(spawner, "]]..script..[[")
            EntityAddTag(spawner, "small_enemies")
        end

        function spawn_big_enemies(x, y, w, h, is_open_path)
            local spawner = EntityLoad("mods/evaisa.backlog/content/evaisa.difficulty/files/entities/spawner.xml", x, y)
            EntitySetName(spawner, "]]..script..[[")
            EntityAddTag(spawner, "big_enemies")
        end
    ]]

    ModTextFileSetContent(script, script_file)

    print(script .. " Patched!")

end
