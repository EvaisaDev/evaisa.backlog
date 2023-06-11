function table.clone(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in pairs(orig) do
            copy[orig_key] = orig_value
        end
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

function table.find(tab,el)
    for index, value in pairs(tab) do
        if value == el then
            return index
        end
    end
    return nil
end

function table.has(tab,el)
    for index, value in pairs(tab) do
        if value == el then
            return true
        end
    end
    return false
end

function table.remove_value(tab,el)
    for index, value in pairs(tab) do
        if value == el then
            table.remove(tab, index)
            return tab
        end
    end
    return tab
end

function table.length(T)
    local count = 0
    for _ in pairs(T) do count = count + 1 end
    return count
end

function table.merge(T)
    local new_table = {}
    for k, v in pairs(T)do
        if(v ~= nil)then
            for k2, v2 in pairs(v)do
                table.insert(new_table, v2)
            end
        end
    end
    return new_table
end

function math.round(num, numDecimalPlaces)
    local mult = 10^(numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function append_text(entity, text)
	text.offset_x = string.len(text.string)*1.9
	if(entity ~= nil)then
		local component = EntityAddComponent( entity, "SpriteComponent", {
			_tags = "enabled_in_world",
			image_file = text.font or "data/fonts/font_pixel_white.xml",
			emissive = "1",
			is_text_sprite = "1",
			offset_x = text.offset_x or "0",
			offset_y = text.offset_y or "0",
			alpha = text.alpha or "1",
			update_transform = "1",
			update_transform_rotation = "0",
			text = text.string or "",
			has_special_scale = "1",
			special_scale_x = text.scale_x or "1",
			special_scale_y = text.scale_y or "1",
			z_index = "-9000"
		} )
		return component
	end
end