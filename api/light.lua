-- Light API

lights = {}

lights.types = {"lantern", "candlestick", "chandelier"}
lights.styles = {"simple", "luxury", "royal"}
lights.materials = {"wooden", "steel", "plastic", "glass", "brass", "gold"}

-- Register a light node.
-- Supported types: "lantern" (default), "candlestick" and "chandelier".
-- Supported styles: "simple" (default), "luxury", "royal".
-- Supported materials: "wooden", "steel", "plastic", "glass", "brass", "gold".
-- Supported colors: all.
 
-- Only lights of "lantern" or "chandelier" types can be toggleable!

-- Params:
--'def' is light definition.
luxury_decor.register_light = function(def)
	local lightdef = {}
	
	lightdef.actual_name = def.actual_name or ""
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(lights.types, def.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(lights.styles, def.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(lights.materials, def.material)
	local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(def.base_color)
	
	lightdef.base_color = rcolor
	
	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	if not color_state then return end
	
	local upper_name = ""
	
	for i, str in ipairs(string.split(lightdef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	lightdef.description = upper_name .. "\n" ..
		minetest.colorize("#FF0000", "type: " .. rtype) .. "\n" ..
		minetest.colorize("#FF00F1", "style: " .. rstyle) .. "\n" ..
		minetest.colorize("#45de0f", "material: " .. rmaterial) .. "\n" ..
		minetest.colorize("#1a1af1", "color: " .. rcolor)
		
	if def.item_info then
		lightdef.description = lightdef.description .. def.item_info
	end
	
	lightdef.visual_scale	= def.visual_scale or 0.5
	lightdef.drawtype 		= "mesh"
	lightdef.mesh 			= def.mesh
	
	lightdef.tiles = def.textures
	lightdef.multiply_by_color = def.multiply_by_color
		--[[if type(tile) == "table" and tile.multiply_by_color then
			lightdef.tiles[i].color = rcolor
				lightdef.tiles[i].multiply_by_color = nil
		end]]

	lightdef.use_texture_alpha 	= true
	lightdef.paramtype			= "light"
	lightdef.paramtype2			= def.paramtype2 or "facedir"
	lightdef.inventory_image	= def.inventory_image
	lightdef.wield_image		= def.wield_image or lightdef.inventory_image
	
	lightdef.groups				= {
		["style_" .. rstyle] = 1, 
		["material_" .. rmaterial] = 1, 
		["color_" .. rcolor] = 1, 
		["type_" .. rtype] = 1, 
		snappy = 1.5
	}
	
	if type(def.groups) == "table" then
		lightdef.groups = luxury_decor.unite_tables(lightdef.groups, def.groups)
	end
	
	lightdef.collision_box		= {
		type = "fixed",
		fixed = def.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	lightdef.selection_box		= {
		type = "fixed",
		fixed = def.selection_box or lightdef.collision_box.fixed
	}
	lightdef.sounds = {}
	
	if not def.sounds then
		lightdef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
				(rmaterial == "steel" or rmaterial == "brass" or rmaterial == "gold") and default.node_sound_metal_defaults() or
				rmaterial == "plastic" and default.node_sound_leaves_defaults() or
				rmaterial == "glass" and default.node_sound_glass_defaults()
	else
		lightdef.sounds = def.sounds
	end
	
	lightdef.toggleable = def.toggleable or false
	lightdef.paintable = def.paintable or false
	
	
	local res_name = "luxury_decor:" .. lightdef.actual_name
	if (rtype == "lantern" or rtype == "chandelier") and lightdef.toggleable then
		lightdef.drop = def.drop_on or res_name .. "_off"
		lightdef.on_rightclick = def.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
			local brush = paint.paint_node(pos, clicker)
			lights.turn_on(pos)
			
			return brush
		end
		
		minetest.register_node(res_name .. "_off", table.copy(lightdef))
		paint.register_colored_nodes(res_name .. "_off")
		
		if def.craft_recipe then
			minetest.register_craft({
				type = def.craft_recipe.type,
				output = res_name .. "_off",
				recipe = def.craft_recipe.recipe,
				replacements = def.craft_recipe.replacements
			})
		end
		lightdef.light_source = def.light_source or minetest.LIGHT_MAX
		lightdef.drop = def.drop_on or res_name .. "_on"
		lightdef.groups.not_in_creative_inventory = 1
		lightdef.on_rightclick = def.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
			local brush = paint.paint_node(pos, clicker)
			lights.turn_off(pos)
			
			return brush
		end
		
		minetest.register_node(res_name .. "_on", lightdef)
		paint.register_colored_nodes(res_name .. "_on")
	else
		lightdef.on_rightclick = def.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
			local brush = paint.paint_node(pos, clicker)
			
			return brush
		end
		lightdef.light_source = def.light_source or minetest.LIGHT_MAX
		lightdef.drop = def.drop_on or res_name
		minetest.register_node(res_name, lightdef)
		paint.register_colored_nodes(res_name)
		
		if def.craft_recipe then
			minetest.register_craft({
				type = def.craft_recipe.type,
				output = res_name,
				recipe = def.craft_recipe.recipe,
				replacements = def.craft_recipe.replacements
			})
		end
	end
end

-- Turn on the light (it is supposed 'light_source' is higher than 0).

-- Params:
-- 'pos' is light node position.
lights.turn_on = function(pos)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	minetest.debug("def: " .. dump(def))
	
	if def.toggleable then
		local light_on_name = "luxury_decor:" .. def.actual_name .. "_on"
		local color = luxury_decor.get_color(def)
		minetest.debug("color: " .. (color or ""))
		minetest.debug("def.base_color: " .. def.base_color)
		
		if def.base_color ~= color then
			light_on_name = light_on_name .. "_" .. color
		end
		
		minetest.set_node(pos, {name = light_on_name, param2 = node.param2})
		return true
	end
	
	return false
end

-- Turn off the light.

-- Params:
-- 'pos' is light node position.
lights.turn_off = function(pos)
	local node = minetest.get_node(pos)
	local def = minetest.registered_nodes[node.name]
	
	if def.toggleable then
		local light_off_name = "luxury_decor:" .. def.actual_name .. "_off"
		local color = luxury_decor.get_color(def)
		
		if def.base_color ~= color then
			light_off_name = light_off_name .. "_" .. color
		end
		
		minetest.set_node(pos, {name = light_off_name, param2 = node.param2})
		return true
	end
	
	return false
end

-- Return a state of the light with 'def' node definition. If 'light_source' > 0 it interprets as 'on', else 'off'.
-- NOTE: If not toggleable, return 'nil' !
lights.get_state = function(def)
	if not def.toggleable then
		return
	end
	
	return not def.light_source and "off" or "on"
end
