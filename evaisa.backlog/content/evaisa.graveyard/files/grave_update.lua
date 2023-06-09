local entity = GetUpdatedEntityID()

local x, y, r, w, h = EntityGetTransform(entity)

EntitySetTransform(entity, x, y, 0, w, h)