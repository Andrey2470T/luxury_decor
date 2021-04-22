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
	local lightdef = table.copy(def)
	
	lightdef.actual_name = lightdef.actual_name or ""
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(lights.types, lightdef.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(lights.styles, lightdef.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(lights.materials, lightdef.material)
	local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(lightdef.base_color)
	
	lightdef.base_color = rcolor
	
	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	if not color_state then return end
	
	local upper_name = ""
	
	for i, str in ipairs(string.split(lightdef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	lightdef.description = lightdef.description or upper_name .. "\n" ..
		minetest.colorize("#FF0000", "type: " .. rtype) .. "\n" ..
		minetest.colorize("#FF00F1", "style: " .. rstyle) .. "\n" ..
		minetest.colorize("#45de0f", "material: " .. rmaterial) .. "\n" ..
		minetest.colorize("#1a1af1", "color: " .. rcolor)
		
	if lightdef.item_info then
		lightdef.description = lightdef.description .. lightdef.item_info
	end
	
	lightdef.visual_scale = lightdef.visual_scale or 0.5
	lightdef.tiles = lightdef.textures
	lightdef.drawtype = lightdef.drawtype or "mesh"
	lightdef.mesh = lightdef.drawtype == "mesh" and lightdef.mesh
	lightdef.use_texture_alpha 	= true
	lightdef.paramtype			= "light"
	lightdef.paramtype2			= lightdef.paramtype2 or "facedir"
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
		fixed = lightdef.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	lightdef.selection_box		= {
		type = "fixed",
		fixed = lightdef.selection_box or lightdef.collision_box.fixed
	}
	
	if not lightdef.sounds then
		lightdef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
			(rmaterial == "steel" or rmaterial == "brass" or rmaterial == "gold") and default.node_sound_metal_defaults() or
			rmaterial == "plastic" and default.node_sound_leaves_defaults() or
			rmaterial == "glass" and default.node_sound_glass_defaults()
	end
	
	lightdef.toggleable = lightdef.toggleable or false
	lightdef.paintable = lightdef.paintable or false
	
	
	local res_name = "luxury_decor:" .. lightdef.actual_name
	if (rtype == "lantern" or rtype == "chandelier") and lightdef.toggleable then
		local copy_def = table.copy(lightdef)
		copy_def.drop = lightdef.drop_on or res_name .. "_off"
		copy_def.light_source = 0
		copy_def.on_rightclick = lightdef.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
			local res, brush = paint.paint_node(pos, clicker)
			if not res then
				lights.turn_on(pos)
			end
			
			return brush
		end
		
		minetest.register_node(res_name .. "_off", copy_def)
		paint.register_colored_nodes(res_name .. "_off")
		
		if copy_def.craft_recipe then
			minetest.register_craft({
				type = copy_def.craft_recipe.type,
				output = res_name .. "_off",
				recipe = copy_def.craft_recipe.recipe,
				replacements = copy_def.craft_recipe.replacements
			})
		end
		lightdef.light_source = lightdef.light_source or minetest.LIGHT_MAX
		lightdef.groups.not_in_creative_inventory = 1
		lightdef.on_rightclick = lightdef.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
			local res, brush = paint.paint_node(pos, clicker)
			if not res then
				lights.turn_off(pos)
			end
			
			return brush
		end
		
		minetest.register_node(res_name .. "_on", lightdef)
		paint.register_colored_nodes(res_name .. "_on")
	else
		lightdef.on_rightclick = lightdef.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
			local res, brush = paint.paint_node(pos, clicker)
			
			return brush
		end
		lightdef.light_source = lightdef.light_source or minetest.LIGHT_MAX
		lightdef.drop = lightdef.drop_on or res_name
		minetest.register_node(res_name, lightdef)
		paint.register_colored_nodes(res_name)
		
		if lightdef.craft_recipe then
			minetest.register_craft({
				type = lightdef.craft_recipe.type,
				output = res_name,
				recipe = lightdef.craft_recipe.recipe,
				replacements = lightdef.craft_recipe.replacements
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
