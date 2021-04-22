-- Shelf API

shelf = {}

shelf.types = {"overhang", "bookshelf"}
shelf.styles = {"simple", "luxury", "royal"}
shelf.materials = {"wooden", "steel", "glass", "brass", "plastic"}
shelf.wood_sorts = luxury_decor.wood_sorts


luxury_decor.register_shelf = function(def)
	local shelfdef = table.copy(def)
	
	shelfdef.actual_name = shelfdef.actual_name or ""
	
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(shelf.types, shelfdef.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(shelf.styles, shelfdef.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(shelf.materials, shelfdef.material)
	
	shelfdef.register_wood_sorts = luxury_decor.CHECK_FOR_WOOD_SORTS_LIST(shelf.wood_sorts, shelfdef.register_wood_sorts)
	
	if shelfdef.register_wood_sorts then
		shelfdef.base_color = luxury_decor.CHECK_FOR_COLORS_LIST(shelfdef.base_color)
	else
		local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(shelfdef.base_color)
		
		if not color_state then return end
		shelfdef.base_color = rcolor
	end

	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	
	shelfdef.visual_scale = shelfdef.visual_scale or 0.5
	shelfdef.use_texture_alpha 	= true
	shelfdef.drawtype = shelfdef.drawtype or "mesh"
	shelfdef.mesh = shelfdef.drawtype == "mesh" and shelfdef.mesh
	shelfdef.paramtype			= "light"
	shelfdef.paramtype2			= shelfdef.paramtype2 or "facedir"
	
	local upper_name = ""
	for i, str in ipairs(string.split(shelfdef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	
	shelfdef.description = shelfdef.description or upper_name .. "\n" ..
		minetest.colorize("#ff0000", "type: " .. rtype) .. "\n" ..
		minetest.colorize("#ff00f1", "style: " .. rstyle) .. "\n" ..
		minetest.colorize("#45de0f", "material: " .. rmaterial)
		
	shelfdef.groups				= {
		["style_" .. rstyle] = 1, 
		["material_" .. rmaterial] = 1, 
		["type_" .. rtype] = 1, 
		snappy = 1.5
	}
	
	if type(def.groups) == "table" then
		shelfdef.groups = luxury_decor.unite_tables(shelfdef.groups, def.groups)
	end
	
	shelfdef.collision_box		= shelfdef.drawtype == "mesh" and {
		type = "fixed",
		fixed = shelfdef.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	shelfdef.node_box			= shelfdef.drawtype == "nodebox" and {
		type = "fixed",
		fixed = shelfdef.node_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	shelfdef.selection_box		= {
		type = "fixed",
		fixed = shelfdef.selection_box or shelfdef.collision_box and shelfdef.collision_box.fixed or shelfdef.node_box and shelfdef.node_box.fixed
	}
	
	if not shelfdef.sounds then
		shelfdef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
				(rmaterial == "steel" or rmaterial == "brass") and default.node_sound_metal_defaults() or
				rmaterial == "plastic" and default.node_sound_leaves_defaults() or
				rmaterial == "glass" and default.node_sound_glass_defaults()
	end
	
	shelfdef.paintable = shelfdef.paintable or false
	shelfdef.on_rightclick = shelfdef.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
		local res, brush = paint.paint_node(pos, clicker)
		if not res then
			minetest.item_place(itemstack, clicker, pointed_thing)
		end
			
		return brush
	end
	
	local res_name = "luxury_decor:" .. shelfdef.actual_name
	if rmaterial == "wooden" and type(shelfdef.register_wood_sorts) == "table" then
		wood.register_wooden_sorts_nodes(shelfdef)
	else
		shelfdef.tiles = shelfdef.textures
			--[[if type(tile) == "table" and tile.multiply_by_color then
				tile.color = tile.color or shelfdef.base_color
			end]]
		
		shelfdef.description = shelfdef.description .. "\n" .. minetest.colorize("#1a1af1", "color: " .. shelfdef.base_color)
		shelfdef.groups["color_" .. shelfdef.base_color] = 1
		shelfdef.drop = shelfdef.drop or res_name
		
		minetest.register_node(res_name, shelfdef)
		
		if shelfdef.craft_recipe then
			minetest.register_craft({
				type = shelfdef.craft_recipe.type,
				output = res_name,
				recipe = shelfdef.craft_recipe.recipe,
				replacements = shelfdef.craft_recipe.replacements
			})
		end
	
		if shelfdef.paintable then
			paint.register_colored_nodes(res_name)
		end
	end
	
	if shelfdef.item_info then
		shelfdef.description = shelfdef.description .. shelfdef.item_info
	end
end
