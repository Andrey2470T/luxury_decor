-- Seat API
-- Allows to easily register as types of seats as sofas, chairs, armchairs, footstools and more!

seat = {}
seat.types = {"chair", "armchair", "sofa", "footstool"}
seat.styles = {"simple", "luxury", "royal"}
seat.materials = {"wooden", "steel", "plastic", "stone", "wool"}
seat.wood_sorts = luxury_decor.wood_sorts

luxury_decor.register_seat = function(def)
	local seatdef = table.copy(def)
	
	seatdef.actual_name = seatdef.actual_name or ""
	
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(seat.types, seatdef.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(seat.styles, seatdef.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(seat.materials, seatdef.material)
	
	seatdef.register_wood_sorts = luxury_decor.CHECK_FOR_WOOD_SORTS_LIST(seat.wood_sorts, seatdef.register_wood_sorts)
	
	if seatdef.register_wood_sorts then
		seatdef.base_color = luxury_decor.CHECK_FOR_COLORS_LIST(seatdef.base_color)
	else
		local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(seatdef.base_color)
		
		if not color_state then return end
		seatdef.base_color = rcolor
	end

	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	
	seatdef.visual_scale = seatdef.visual_scale or 0.5
	seatdef.use_texture_alpha 	= true
	seatdef.drawtype = seatdef.drawtype or "mesh"
	seatdef.mesh = seatdef.drawtype == "mesh" and seatdef.mesh
	seatdef.paramtype			= "light"
	seatdef.paramtype2			= seatdef.paramtype2 or "facedir"
	
	local upper_name = ""
	for i, str in ipairs(string.split(seatdef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	
	seatdef.description = seatdef.description or upper_name .. "\n" ..
		minetest.colorize("#ff0000", "type: " .. rtype) .. "\n" ..
		minetest.colorize("#ff00f1", "style: " .. rstyle) .. "\n" ..
		minetest.colorize("#45de0f", "material: " .. rmaterial)
		
	seatdef.groups				= {
		["style_" .. rstyle] = 1, 
		["material_" .. rmaterial] = 1, 
		["type_" .. rtype] = 1, 
		choppy = 2.5
	}
	
	if type(def.groups) == "table" then
		seatdef.groups = luxury_decor.unite_tables(seatdef.groups, def.groups)
	end
	
	seatdef.collision_box		= seatdef.drawtype == "mesh" and {
		type = "fixed",
		fixed = seatdef.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	seatdef.node_box			= seatdef.drawtype == "nodebox" and {
		type = "fixed",
		fixed = seatdef.node_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	seatdef.selection_box		= {
		type = "fixed",
		fixed = seatdef.selection_box or seatdef.collision_box and seatdef.collision_box.fixed or seatdef.node_box and seatdef.node_box.fixed
	}
	
	if not seatdef.sounds then
		seatdef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
			rmaterial == "steel" and default.node_sound_metal_defaults() or
			(rmaterial == "plastic" or rmaterial == "wool") and default.node_sound_leaves_defaults() or
			rmaterial == "stone" and default.node_sound_stone_defaults()
	end
	
	seatdef.paintable = seatdef.paintable or false
	seatdef.connectable = (rtype == "sofa" or rtype == "footstool") and seatdef.connectable
	
	if seatdef.connectable then 
		seatdef.groups["part_original"] = 1
	end
	
	if seatdef.seat_data then
		seatdef.seat_data.pos = seatdef.seat_data.pos or {x=0, y=0, z=0}
		seatdef.seat_data.rot = seatdef.seat_data.rot or {x=0, y=0, z=0}
		
		if seatdef.seat_data.mesh then
			for i, mesh in ipairs(seatdef.seat_data.mesh) do
				if mesh.anim then
					mesh.anim.blend = mesh.anim.blend or 0.0
					mesh.anim.loop = mesh.anim.loop or true
				end
			end
		end
	end
	
	seatdef.on_construct = seatdef.on_construct or function(pos)
		minetest.get_meta(pos):set_string("is_busy", "")
	end
	
	seatdef.on_rightclick = seatdef.on_rightclick or function(pos, node, clicker, itemstack, pointed_thing)
		local res, stack = paint.paint_node(pos, clicker)
		if not res then
			local def = minetest.registered_nodes[itemstack:get_name()]
			if def and luxury_decor.get_type(def) == "sofa" then
				res, stack = connection.connect_node(pos, itemstack, pointed_thing)
				
				if not res and minetest.registered_nodes[itemstack:get_name()] then
					minetest.set_node(pointed_thing.above, {name = itemstack:get_name()})
				end
			else
				local bool = sitting.sit_player(clicker, pos)
			
				if not bool then
					sitting.standup_player(clicker, pos)
				end
			end
		end
		return stack
	end
	
	seatdef.on_dig = seatdef.on_dig or function(pos, node, digger)
		connection.disconnect_node(pos)
		minetest.node_dig(pos, node, digger)
		
		return true
	end
	
	seatdef.on_destruct = seatdef.on_destruct or function(pos)
		sitting.standup_player(minetest.get_player_by_name(minetest.get_meta(pos):get_string("is_busy")), pos)
	end
		                      
	local res_name = "luxury_decor:" .. seatdef.actual_name
		
	if rmaterial == "wooden" and type(seatdef.register_wood_sorts) == "table" then
		wood.register_wooden_sorts_nodes(seatdef)
	else
		seatdef.tiles = seatdef.textures
		seatdef.description = seatdef.description .. "\n" .. minetest.colorize("#1a1af1", "color: " .. seatdef.base_color)
		seatdef.groups["color_" .. seatdef.base_color] = 1
		
		minetest.register_node(res_name, seatdef)
		
		if seatdef.craft_recipe then
			minetest.register_craft({
				type = seatdef.craft_recipe.type,
				output = res_name,
				recipe = seatdef.craft_recipe.recipe,
				replacements = seatdef.craft_recipe.replacements
			})
		end
	
		if seatdef.paintable then
			paint.register_colored_nodes(res_name)
		end
	end
	
	if seatdef.item_info then
		seatdef.description = seatdef.description .. seatdef.item_info
	end
	connection.register_connected_parts(seatdef)
end
