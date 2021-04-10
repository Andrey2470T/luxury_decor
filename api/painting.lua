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
	["khaki"] = "#F0E68C",
	["peru"] = "#CD853F",
	["burlywood"] = "#DEB887",
	["cornsilk"] = "#FFF8DC"
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

-- Register colored nodes with all those colors that defined in 'paint.rgb_colors' table, except the one that the 'node_name' node already has.
-- It will return 'nil' if 'node_name' node is not paintable.
paint.register_colored_nodes = function(node_name)
	local def = minetest.registered_nodes[node_name]
	if not def.paintable then
		return
	end
	
	for color, _ in pairs(paint.rgb_colors) do
		local new_def = table.copy(def)
		if def.base_color ~= color then
			new_def.groups.not_in_creative_inventory = 1
			new_def.groups["color_" .. def.base_color] = nil
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
				if def.multiply_by_color[i] then
					if type(tile) == "table" and type(tile.color) == "string" then
						new_def.tiles[i].color = color
					else
						new_def.tiles[i] = {name = tile, color = color}
					end
				end
			end
			
			new_def.drop = new_def.drop .. "_" .. color
			minetest.register_node(def.name .. "_" .. color, new_def)
		end
	end
end

-- Paints the node with the color of the wielded brush.

-- Params:
-- 'pos' is a position of the node that will be painted.
-- 'painter' is a player that tries to paint.
paint.paint_node = function(pos, painter)
	local wielded_brush = painter:get_wielded_item()
	local wielded_brush_name = wielded_brush:get_name()
	
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	
	if not wielded_brush_name:match("luxury_decor:paint_brush_") or not def.paintable then
		return wielded_brush
	end

	local color_brush = wielded_brush_name:sub(("luxury_decor:paint_brush_"):len()+1)
	
	local is_color_in_table = false
	for c, _ in pairs(paint.rgb_colors) do
		if c == color_brush then
			is_color_in_table = true
			break
		end
	end
	
	if not is_color_in_table then
		return wielded_brush
	end
	
	if luxury_decor.get_color(def) == color_brush then
		return wielded_brush
	end
	
	local meta = wielded_brush:get_meta()
	local uses_amount = meta:get_string("uses_amount")

	if not uses_amount or uses_amount == "" then
		uses_amount = math.random(paint.min_max_uses.min, paint.min_max_uses.max)
		meta:set_string("uses_amount", tostring(uses_amount))
	end
	
	local new_wear = wielded_brush:get_wear() + 65535 / uses_amount
	
	if new_wear >= 65535 then
		wielded_brush = ItemStack("luxury_decor:paint_brush")
	else
		wielded_brush:set_wear(new_wear)
	end
	
	minetest.debug("luxury_decor.get_color(def): " .. luxury_decor.get_color(def))
	minetest.debug("color_brush: " .. color_brush)
	minetest.debug("def.name:gsub(): " .. def.name:gsub(luxury_decor.get_color(def), color_brush))
	
	local cur_color = luxury_decor.get_color(def)
	local name = color_brush ~= def.base_color and (def.base_color == cur_color and def.name .. "_" .. color_brush or def.name:gsub(cur_color, color_brush)) or def.name
	minetest.set_node(pos, {name = name, param1 = node.param1, param2 = node.param2})
	
	return wielded_brush
end


-- Register colorful brushes and clear brush
minetest.register_tool("luxury_decor:paint_brush", {
	description = "Paint Brush (clear)",
	inventory_image = "luxury_decor_paint_brush_hand.png^(luxury_decor_paint_brush.png)"
})

minetest.register_craft({
	type = "shapeless",
	output = "luxury_decor:paint_brush",
	recipe = {"default:stick", "farming:string"}
})

for color, _ in pairs(paint.rgb_colors) do
	minetest.register_tool("luxury_decor:paint_brush_" .. color, {
		description = "Paint Brush (right-click with it to paint)",
		inventory_image = "luxury_decor_paint_brush_hand.png^(luxury_decor_paint_brush.png^[multiply:" .. color ..")"
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "luxury_decor:paint_brush_" .. color,
		recipe = {"default:stick", "farming:string", "dye:" .. color}
	})
	
	minetest.register_craft({
		type = "shapeless",
		output = "luxury_decor:paint_brush_" .. color,
		recipe = {"luxury_decor:paint_brush", "dye:" .. color}
	})
end

