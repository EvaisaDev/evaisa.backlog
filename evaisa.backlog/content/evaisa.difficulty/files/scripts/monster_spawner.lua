dofile("mods/monster_respawn/files/scripts/utilities.lua")

spawner = GetUpdatedEntityID()
x, y = EntityGetTransform(spawner)

time_since_last_monster = EntityGetVariable(spawner, "time_since_last_monster", "int")

monster_file = EntityGetVariable(spawner, "monster_file", "string")

original_monster = EntityGetVariable(spawner, "original_monster", "int")

--print(tostring(ModSettingGet("monster_respawn.spawn_rate")) * 60)

if(time_since_last_monster == -1 or time_since_last_monster > ModSettingGet("monster_respawn.spawn_rate") * 60)then
	if(original_monster == -1 or not EntityGetIsAlive(original_monster))then
		new_monster = EntityLoad(monster_file, x, y)
		EntityAddTag(new_monster, "spawned_from_spawner")
		EntitySetVariable(spawner, "original_monster", "int", new_monster)
		EntitySetVariable(spawner, "time_since_last_monster", "int", 0)
		original_monster = new_monster
		time_since_last_monster = 0
	end
end

if(EntityGetIsAlive(original_monster))then
	EntitySetVariable(spawner, "time_since_last_monster", "int", 0)
	time_since_last_monster = 0
end

time_since_last_monster = time_since_last_monster + 1

EntitySetVariable(spawner, "time_since_last_monster", "int", time_since_last_monster)