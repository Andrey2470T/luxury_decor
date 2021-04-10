-- Check Functions.

-- These functions check for whether used types, materials, styles in the registration API are supported by their API.

luxury_decor.CHECK_FOR_TYPE = function(table_ref, _type)
	if _type == nil or _type == "" then
		_type = table_ref[1]
	end

	for _, s_type in ipairs(table_ref) do
		if s_type == _type then
			return true, _type
		end
	end

	minetest.log("warning", "luxury_decor.CHECK_FOR_TYPE(): Impossible to register node: unsupported type or this has not string type!")
	return false
end

luxury_decor.CHECK_FOR_STYLE = function(table_ref, style)
	if style == nil or style == "" then
		style = table_ref[1]
	end

	for _, s_style in ipairs(table_ref) do
		if s_style == style then
			return true, style
		end
	end

	minetest.log("warning", "luxury_decor.CHECK_FOR_STYLE(): Impossible to register node: unsupported style or this has not string type!")
	return false
end

luxury_decor.CHECK_FOR_MATERIAL = function(table_ref, material)
	if material == nil or material == "" then
		material = table_ref[1]
	end

	for _, s_material in ipairs(table_ref) do
		if s_material == material then
			return true, material
		end
	end

	minetest.log("warning", "luxury_decor.CHECK_FOR_MATERIAL(): Impossible to register node: unsupported material or this has not string type!")
	return false
end

luxury_decor.CHECK_FOR_COLOR = function(color)
	if color == nil or color == "" then
		color = paint.default_color
	end
	
	for col, _ in pairs(paint.rgb_colors) do
		if col == color then
			return true, color
		end
	end
	
	minetest.log("warning", "luxury_decor.CHECK_FOR_COLOR(): Impossible to register node: unsupported color or this has not string type!")
	return false
end

luxury_decor.CHECK_FOR_WOOD_SORTS_LIST = function(table_ref, woods)
	if woods == nil or woods == "" then
		return
	end
	
	table.sort(table_ref, function(a, b)
		return a:byte() < b:byte()
	end)
	table.sort(woods, function(a, b) 
		return a:byte() < b:byte()
	end)
	
	woods = table.copy(woods)
	for i, wood in ipairs(woods) do
		local is_woodsort_found = false
		for _, wood2 in ipairs(table_ref) do
			if wood2 == wood then
				is_woodsort_found = true
			end
		end
		
		if not is_woodsort_found then
			woods[i] = nil
			minetest.log("warning", "luxury_decor.CHECK_FOR_WOOD_TYPE_LIST(): Couldn`t find \'" .. wood .. "\' sort of wood in the wood types list!")
		end
	end
	
	return woods
end

luxury_decor.CHECK_FOR_COLORS_LIST = function(colors)
	if colors == nil or colors == "" then
		return
	end
	
	colors = table.copy(colors)
	for wood, color in pairs(colors) do
		local state, col = luxury_decor.CHECK_FOR_COLOR(color)
		
		if state then
			colors[wood] = col
		else
			colors[wood] = nil
			minetest.log("warning", "luxury_decor.CHECK_FOR_COLORS_LIST(): Couldn`t find \'" .. color .. "\' color in the colors list!")
		end
	end
	
	return colors
end
