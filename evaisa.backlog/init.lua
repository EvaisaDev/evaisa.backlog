local data = dofile("mods/evaisa.backlog/data.lua")

local collected_mod_init_data = {}

local noita_callbacks = {
    "OnModPreInit",
    "OnModInit",
    "OnModPostInit",
    "OnPlayerSpawned",
    "OnPlayerDied",
    "OnWorldInitialized",
    "OnWorldPreUpdate",
    "OnWorldPostUpdate",
    "OnBiomeConfigLoaded",
    "OnMagicNumbersAndWorldSeedInitialized",
    "OnPausedChanged",
    "OnModSettingsChanged",
    "OnPausePreUpdate",
}

local remove_callbacks_from_global = function()
    for _, callback in ipairs(noita_callbacks)do
        _G[callback] = nil
    end
end

for i, v in ipairs(data)do
    local mod_id = v.id
    local enabled = ModSettingGet("evaisa.backlog."..mod_id)
    if enabled and v.has_init then
        dofile("mods/evaisa.backlog/content/"..v.id.."/init.lua")
        for _, callback in ipairs(noita_callbacks)do
            if _G[callback] then
                if not collected_mod_init_data[mod_id] then
                    collected_mod_init_data[mod_id] = {}
                end
                collected_mod_init_data[mod_id][callback] = _G[callback]
            end
        end
    end
    remove_callbacks_from_global()
end

for i, callback in ipairs(noita_callbacks)do
    _G[callback] = function(...)
        for mod_id, mod_callbacks in pairs(collected_mod_init_data)do
            if mod_callbacks[callback] then
                mod_callbacks[callback](...)
            end
        end
    end
end