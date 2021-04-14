-- Shelf API

shelf = {}

shelf.types = {"overhang", "bookshelf"}
shelf.styles = {"simple", "luxury", "royal"}
shelf.materials = {"wooden", "steel", "glass", "brass", "plastic"}
shelf.wood_sorts = luxury_decor.wood_sorts


luxury_decor.register_shelf = function(def)
	local shelfdef = {}
	
	shelfdef.actual_name = def.actual_name or ""
	
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(shelf.types, def.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(shelf.styles, def.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(shelf.materials, def.material)
	
	def.register_wood_sorts = luxury_decor.CHECK_FOR_WOOD_SORTS_LIST(shelf.wood_sorts, def.register_wood_sorts)
	
	if def.register_wood_sorts then
		shelfdef.base_color = luxury_decor.CHECK_FOR_COLORS_LIST(def.base_color)
		shelfdef.textures = def.textures
		shelfdef.inventory_image = def.inventory_image
		shelfdef.wield_image = def.wield_image or shelfdef.inventory_image
		shelfdef.multiply_by_color = def.multiply_by_color
	else
		local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(def.base_color)
		
		if not color_state then return end
		shelfdef.base_color = rcolor
	end

	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	
	shelfdef.visual_scale	= def.visual_scale or 0.5
	shelfdef.drawtype 		= def.drawtype or "mesh"
	shelfdef.mesh 			= shelfdef.drawtype == "mesh" and def.mesh or ""
	shelfdef.use_texture_alpha 	= true
	shelfdef.paramtype			= "light"
	shelfdef.paramtype2			= def.paramtype2 or "facedir"
	
	local upper_name = ""
	for i, str in ipairs(string.split(shelfdef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	
	shelfdef.description = upper_name .. "\n" ..
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
		fixed = def.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	shelfdef.node_box			= shelfdef.drawtype == "nodebox" and {
		type = "fixed",
		fixed = def.node_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	shelfdef.selection_box		= {
		type = "fixed",
		fixed = def.selection_box or shelfdef.collision_box and shelfdef.collision_box.fixed or shelfdef.node_box and shelfdef.node_box.fixed
	}
	shelfdef.sounds = {}
	
	if not def.sounds then
		shelfdef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
				(rmaterial == "steel" or rmaterial == "brass") and default.node_sound_metal_defaults() or
				rmaterial == "plastic" and default.node_sound_leaves_defaults() or
				rmaterial == "glass" and default.node_sound_glass_defaults()
	else
		shelfdef.sounds = def.sounds
	end
	
	shelfdef.paintable = def.paintable or false
	shelfdef.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local res, brush = paint.paint_node(pos, clicker)
		if not res then
			if def.on_rightclick then 
				def.on_rightclick(pos, node, clicker, itemstack, pointed_thing)
			else
				minetest.item_place(itemstack, clicker, pointed_thing)
			end
		end
			
		return brush
	end
	
	local res_name = "luxury_decor:" .. shelfdef.actual_name
	if rmaterial == "wooden" and type(def.register_wood_sorts) == "table" then
		wood.register_wooden_sorts_nodes(shelfdef, def.register_wood_sorts)
	else
		shelfdef.tiles = def.textures
			--[[if type(tile) == "table" and tile.multiply_by_color then
				tile.color = tile.color or shelfdef.base_color
			end]]
		
		shelfdef.multiply_by_color = def.multiply_by_color
		shelfdef.description = shelfdef.description .. "\n" .. minetest.colorize("#1a1af1", "color: " .. shelfdef.base_color)
		shelfdef.groups["color_" .. shelfdef.base_color] = 1
		shelfdef.inventory_image = def.inventory_image
		shelfdef.wield_image = def.wield_image or shelfdef.inventory_image
		shelfdef.drop = def.drop or res_name
		
		minetest.register_node(res_name, shelfdef)
		
		if def.craft_recipe then
			minetest.register_craft({
				type = def.craft_recipe.type,
				output = res_name,
				recipe = def.craft_recipe.recipe,
				replacements = def.craft_recipe.replacements
			})
		end
	
		if shelfdef.paintable then
			paint.register_colored_nodes(res_name)
		end
	end
	
	if def.item_info then
		shelfdef.description = shelfdef.description .. def.item_info
	end
end
