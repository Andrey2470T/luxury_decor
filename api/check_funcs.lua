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

