-- Painting API

paint = {}

paint.default_color = "white"
paint.min_max_uses = {min=3, max=6}

paint.rgb_colors = {
	["black"] = "#000000",
	["red"] = "#FF0000",
	["green"] = "#00FF00",
	["white"] = "#FFFFFF",
	["blue"] = "#0000FF",
	["yellow"] = "#FFFF00",
	["magenta"] = "#FF00FF",
	["cyan"] = "#00FFFF",
	["dark_green"] = "#008000",
	["dark_grey"] = "#808080",
	["grey"] = "#C0C0C0",
	["brown"] = "#A52A2A",
	["orange"] = "#FF4500",
	["pink"] = "#F08080",
	["violet"] = "#4B0082",
	["khaki"] = "#F0E68C"
}

paint.get_color_index = function(color)
	local counter = 0
	for col, _ in pairs(paint.rgb_colors) do
		counter = counter + 1
		
		if col == color then
			return counter
		end
	end
	
	return -1
end

paint.register_colored_nodes = function(node_name)
	local def = minetest.registered_nodes[node_name]
	if not def.paintable then
		return
	end
	
	for color, _ in pairs(paint.rgb_colors) do
		local new_def = table.copy(def)
		if def.base_color ~= color then
			new_def.groups.not_in_creative_inventory = 1
			new_def.groups["color_" .. color] = 1
			
			local upper_name = ""
			
			for i, str in ipairs(string.split(def.actual_name, "_")) do
				upper_name = upper_name .. " " .. luxury_decor.upper_letters(str, 1, 1)
			end
			
			new_def.description = upper_name .. "\n" ..
				minetest.colorize("#FF0000", "type: " .. luxury_decor.get_type(new_def)) .. "\n" ..
				minetest.colorize("#FF00F1", "style: " .. luxury_decor.get_style(new_def)) .. "\n" ..
				minetest.colorize("#45de0f", "material: " .. luxury_decor.get_material(new_def)) .. "\n" ..
				minetest.colorize("#1a1af1", "color: " .. luxury_decor.get_color(new_def))
			
			for i, tile in ipairs(def.tiles) do
				if type(tile) == "table" then
					if tile.color ~= nil or tile.color ~= "" then
						new_def.tiles[i].color = color
					end
				end
			end
			
			new_def.drop = new_def.drop ~= "" and new_def.drop .. "_" .. color
			minetest.register_node(def.name .. "_" .. color, new_def)
		end
	end
end

paint.paint_node = function(pos, painter)
	local wielded_brush = painter:get_wielded_item()
	local wielded_brush_name = wielded_brush:get_name()
	
	if not wielded_brush_name:match("luxury_decor:paint_brush_") then
		return 
	end
	local meta = wielded_brush:get_meta()
	local uses_amount = meta:get_string("uses_amount")

	if not uses_amount or uses_amount == "" then
		uses_amount = math.random(paint.min_max_uses.min, paint.min_max_uses.max)
		meta:set_string("uses_amount", tostring(uses_amount))
			
		wielded_brush:set_wear(wielded_brush:get_wear()+65535/uses_amount)
	end
		
	local color_pattern = "_[(black)(red)(green)(white)(blue)(yellow)(magenta)(cyan)(dark_green)(dark_grey)(grey)(brown)(orange)(pink)(violet)(khaki)]$"
	local brush_color = wielded_brush_name:match(color_pattern)
	local name = minetest.get_node(pos).name
	local find_cur_color = name:find(color_pattern)
		
	minetest.set_node(name:sub(1, find_cur_color) .. brush_color:sub(2))
end


minetest.register_tool("luxury_decor:paint_brush", {
	description = "Paint Brush (clear)",
	inventory_image = "luxury_decor_paint_brush_hand.png^(luxury_decor_paint_brush.png)"
})

minetest.register_craft({
	type = "shapeless",
	output = "luxury_decor:paint_brush",
	recipe = {"default:stick", "farming:string 3"}
})

for color, _ in pairs(paint.rgb_colors) do
	minetest.register_tool("luxury_decor:paint_brush_" .. color, {
		description = "Paint Brush (right-click with it to paint)",
		inventory_image = "luxury_decor_paint_brush_hand.png^(luxury_decor_paint_brush.png^[colorize:" .. color ..")"
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "luxury_decor:paint_brush_" .. color,
		recipe = {"default:stick", "farming:string 3", "dye:" .. color}
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "luxury_decor:paint_brush_" .. color,
		recipe = {"luxury_decor:paint_brush", "dye:" .. color}
	})
end

