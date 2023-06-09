dofile("mods/evaisa.backlog/content/evaisa.difficulty/files/scripts/utilities.lua")

local spawner = GetUpdatedEntityID()
local x, y = EntityGetTransform(spawner)

local time_since_last_monster = EntityGetVariable(spawner, "time_since_last_monster", "int") or 60

time_since_last_monster = time_since_last_monster + 1

EntitySetVariable(spawner, "time_since_last_monster", "int", time_since_last_monster)