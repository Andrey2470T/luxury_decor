-- Helper functions

-- Upper all characters are in range ['s'-'e'], including 'e'.
-- Returns a whole modified 'str'.

-- Params:
-- 'str' is string that should be modified.
-- 's' is start index.
-- 'e' is end index, including itself.
luxury_decor.upper_letters = function(str, s, e)
    if not e then e = str:len() end
    local substr1 = (s == 1 and "" or str:sub(1, s))
    local substr_replace = str:sub(s, e)
    local substr2 = (e == str:len() and "" or str:sub(e+1, str:len()))
    
    local new_upper_str = ""
    for s in substr_replace:gmatch(".") do
        new_upper_str = new_upper_str .. s:upper()
    end
    
    return substr1 .. new_upper_str .. substr2
end

-- Checks whether 3d point 'p' is located within rectangle area 'rect'.
-- Returns 'true' if yes.

-- Params:
-- 'rect' is table with two points representing rectangle area on the plane (rect[1].y ~= rect[2].y, else return nil).
-- 'p' is 3d point.
luxury_decor.is_point_inside_xz_rect = function(rect, p)
	if rect[1].y ~= rect[2].y then return end
	
	local along_x = rect[1].x <= p.x and p.x <= rect[2].x or rect[1].x >= p.x and p.x >= rect[2].x
	local along_z = rect[1].z <= p.z and p.z <= rect[2].z or rect[1].z >= p.z and p.z >= rect[2].z
	
	return along_x and along_z
end

-- Unites two tables containing fields of both them. Returns resulted table.

--Params:
-- 't1' is first table.
-- 't2' is second table.
luxury_decor.unite_tables = function(t1, t2)
	local c_t1 = table.copy(t1)
	
	for k, v in pairs(t2) do
		c_t1[k] = v
	end
	
	return c_t1
end

luxury_decor.get_style = function(def)
	for name, val in pairs(def.groups) do
		local splits = string.split(name, "_")
		
		if splits[1] == "style" and val == 1 then
			return splits[2]
		end
	end
	
	return -1
end

luxury_decor.get_type = function(def)
	for name, val in pairs(def.groups) do
		local splits = string.split(name, "_")
		
		if splits[1] == "type" and val == 1 then
			return splits[2]
		end
	end
	
	return -1
end

luxury_decor.get_material = function(def)
	for name, val in pairs(def.groups) do
		local splits = string.split(name, "_")
		
		if splits[1] == "material" and val == 1 then
			return splits[2]
		end
	end
	
	return -1
end

luxury_decor.get_color = function(def)
	for name, val in pairs(def.groups) do
		local splits = string.split(name, "_")
		
		if splits[1] == "color" and val == 1 then
			return splits[2]
		end
	end
	
	return -1
end

luxury_decor.build_wooden_item_string = function(item_type, wood_sort)
	if item_type == "wooden_planks" then
		return "default:" .. wood_sort .. (wood_sort ~= "jungle" and "_" or "") .. "wood"
	elseif item_type == "wooden_plank" then
		return "luxury_decor:" .. wood_sort .. "_wooden_plank"
	elseif item_type == "wooden_board" then
		return "luxury_decor:" .. wood_sort .. "_wooden_board"
	elseif item_type == "wooden_stair" then
		return "stairs:stair_" .. wood_sort .. (wood_sort ~= "jungle" and "_" or "") .. "wood"
	elseif item_type == "wooden_slab" then
		return "stairs:slab_" .. wood_sort .. (wood_sort ~= "jungle" and "_" or "") .. "wood"
	elseif item_type == "wooden_stair_inner_corner" then
		return "stairs:stair_inner_" .. wood_sort .. (wood_sort ~= "jungle" and "_" or "") .. "wood"
	elseif item_type == "wooden_stair_outer_corner" then
		return "stairs:stair_outer_" .. wood_sort .. (wood_sort ~= "jungle" and "_" or "") .. "wood"
	end
	
	return
end
