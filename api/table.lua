-- Table API

tables = {}

tables.types = {"dinner", "desk", "tabletop"}
tables.styles = {"simple", "luxury", "royal"}
tables.materials = {"wooden", "steel", "glass", "brass", "plastic", "stone"}
tables.wood_sorts = luxury_decor.wood_sorts


luxury_decor.register_table = function(def)
	local tabledef = table.copy(def)
	
	tabledef.actual_name = tabledef.actual_name or ""
	
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(tables.types, tabledef.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(tables.styles, tabledef.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(tables.materials, tabledef.material)
	
	tabledef.register_wood_sorts = luxury_decor.CHECK_FOR_WOOD_SORTS_LIST(tables.wood_sorts, tabledef.register_wood_sorts)
	
	if tabledef.register_wood_sorts then
		tabledef.base_color = luxury_decor.CHECK_FOR_COLORS_LIST(tabledef.base_color)
	else
		local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(tabledef.base_color)
		
		if not color_state then return end
		tabledef.base_color = rcolor
	end

	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	
	tabledef.visual_scale = tabledef.visual_scale or 0.5
	tabledef.use_texture_alpha 	= true
	tabledef.drawtype = tabledef.drawtype or "mesh"
	tabledef.mesh = tabledef.drawtype == "mesh" and tabledef.mesh
	tabledef.paramtype			= "light"
	tabledef.paramtype2			= tabledef.paramtype2 or "facedir"
	
	local upper_name = ""
	for i, str in ipairs(string.split(tabledef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	
	tabledef.description = tabledef.description or upper_name .. "\n" ..
		minetest.colorize("#ff0000", "type: " .. rtype) .. "\n" ..
		minetest.colorize("#ff00f1", "style: " .. rstyle) .. "\n" ..
		minetest.colorize("#45de0f", "material: " .. rmaterial)
		
	tabledef.groups				= {
		["style_" .. rstyle] = 1, 
		["material_" .. rmaterial] = 1, 
		["type_" .. rtype] = 1, 
		choppy = 2.5
	}
	
	if type(def.groups) == "table" then
		tabledef.groups = luxury_decor.unite_tables(tabledef.groups, def.groups)
	end
	
	tabledef.collision_box		= tabledef.drawtype == "mesh" and {
		type = "fixed",
		fixed = tabledef.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	tabledef.node_box			= tabledef.drawtype == "nodebox" and {
		type = "fixed",
		fixed = tabledef.node_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	tabledef.selection_box		= {
		type = "fixed",
		fixed = tabledef.selection_box or tabledef.collision_box and tabledef.collision_box.fixed or tabledef.node_box and tabledef.node_box.fixed
	}
	
	if not tabledef.sounds then
		tabledef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
				(rmaterial == "steel" or rmaterial == "brass") and default.node_sound_metal_defaults() or
				rmaterial == "plastic" and default.node_sound_leaves_defaults() or
				rmaterial == "glass" and default.node_sound_glass_defaults() or
				rmaterial == "stone" and default.node_sound_stone_defaults()
	end
	
	tabledef.paintable = tabledef.paintable or false
	tabledef.on_rightclick = tabledef.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
		local res, brush = paint.paint_node(pos, clicker)
		
		if not res and minetest.registered_nodes[itemstack:get_name()] then
			minetest.set_node(pointed_thing.above, {name = itemstack:get_name()})
		end
			
		return brush
	end
	
	local res_name = "luxury_decor:" .. tabledef.actual_name
	if rmaterial == "wooden" and type(tabledef.register_wood_sorts) == "table" then
		wood.register_wooden_sorts_nodes(tabledef)
	else
		tabledef.tiles = tabledef.textures
			--[[if type(tile) == "table" and tile.multiply_by_color then
				tile.color = tile.color or tabledef.base_color
			end]]
		
		tabledef.description = tabledef.description .. "\n" .. minetest.colorize("#1a1af1", "color: " .. tabledef.base_color)
		tabledef.groups["color_" .. tabledef.base_color] = 1
		tabledef.drop = tabledef.drop or res_name
		
		minetest.register_node(res_name, tabledef)
		
		if tabledef.craft_recipe then
			minetest.register_craft({
				type = tabledef.craft_recipe.type,
				output = res_name,
				recipe = tabledef.craft_recipe.recipe,
				replacements = tabledef.craft_recipe.replacements
			})
		end
	
		if tabledef.paintable then
			paint.register_colored_nodes(res_name)
		end
	end
	
	if tabledef.item_info then
		tabledef.description = tabledef.description .. tabledef.item_info
	end
end 
