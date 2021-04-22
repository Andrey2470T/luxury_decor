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
		snappy = 1.5
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
	
	if seatdef.connectable and not seatdef.connected_parts_meshes then
		minetest.log("warning", "luxury_decor.register_seat(): Failed to register the seat! No a connected parts meshes list passed despite this is connectable!")
		return
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
				res, stack = seat.connect_sofa(pos, itemstack, pointed_thing)
			else
				local bool = sitting.sit_player(clicker, pos)
			
				if not bool then
					sitting.standup_player(clicker, pos)
				end
			end
		end
		return stack
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
	
	seat.register_connected_parts(seatdef)
end

seat.register_connected_parts = function(def)
	if not def.connectable then
		return
	end
	
	for type, mesh in pairs(def.connected_parts_meshes) do
		local copy_def = table.copy(def)
		copy_def.mesh = mesh
		copy_def.groups.not_in_creative_inventory = 1
		copy_def.collision_box = copy_def.drawtype == "mesh" and {
			type = "fixed",
			fixed = copy_def.connected_parts_node_boxes[type]
		}
		copy_def.node_box = copy_def.drawtype == "nodebox" and {
			type = "fixed",
			fixed = copy_def.connected_parts_node_boxes[type]
		}
		copy_def.selection_box = {
			type = "fixed",
			fixed = copy_def.connected_parts_selection_boxes and copy_def.connected_parts_selection_boxes[type] or 
				(copy_def.collision_box and copy_def.collision_box.fixed or copy_def.node_box and copy_def.node_box.fixed)
		}
		copy_def.drop = def.name
		if luxury_decor.get_material(copy_def) == "wooden" and copy_def.register_wood_sorts then
			wood.register_wooden_sorts_nodes(copy_def, type)
		else
			local res_name = "luxury_decor:" .. def.actual_name .. "_" .. type
			minetest.register_node(res_name, copy_def)
	
			if def.paintable then
				paint.register_colored_nodes(res_name)
			end
		end
	end
end

seat.get_sofa_part = function(sofaname)
	local def = minetest.registered_nodes[sofaname]
	
	if luxury_decor.get_type(def) ~= "sofa" then
		return -1
	end
	
	local splits = string.split(sofaname, "_")
	minetest.debug("splits: " .. dump(splits))
	
	if #splits <= 1 then
		return -1
	end
	
	for i, split in ipairs(splits) do
		if split == "left" or split == "right" or split == "corner" or split == "middle" then
			return split
		end
	end
	
	return ""
end

seat.get_sofa_name_from_part = function(def, partname)
	local wood_sort = luxury_decor.get_wood_sort(def)
	local color = luxury_decor.get_color(def)
	
	return "luxury_decor:" .. def.actual_name .. "_" .. partname .. (wood_sort ~= -1 and "_" .. wood_sort or "") .. (color ~= -1 and color ~= def.base_color and "_" .. color or "")
end

seat.connect_sofa = function(pos, itemstack, pointed_thing)
	local node = minetest.get_node(pos)
	local clicked_sofa_def = minetest.registered_nodes[node.name]
	local sofa_def = minetest.registered_nodes[itemstack:get_name()]
	if not sofa_def then
		return false, itemstack
	end
	local are_sofas_identical = luxury_decor.get_type(clicked_sofa_def) == luxury_decor.get_type(sofa_def) and
		luxury_decor.get_style(clicked_sofa_def) == luxury_decor.get_style(sofa_def) and
		luxury_decor.get_material(clicked_sofa_def) == luxury_decor.get_material(sofa_def) and
		luxury_decor.get_color(clicked_sofa_def) == luxury_decor.get_color(sofa_def) and
		luxury_decor.get_wood_sort(clicked_sofa_def) == luxury_decor.get_wood_sort(sofa_def)
		
	if not are_sofas_identical then
		return false, itemstack
	end
	local dir = clicked_sofa_def.paramtype2 == "facedir" and minetest.facedir_to_dir(node.param2)
	
	if not dir then
		return false, itemstack
	end
	dir = vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi)

	local close_node = minetest.get_node(pointed_thing.above)
	if close_node.name ~= "air" then
		return false, itemstack
	end
	local clicked_face_dir = vector.subtract(pointed_thing.above, pos)
	
	if clicked_face_dir.y ~= 0 then
		return false, itemstack
	end
	
	local dir_rot_y = vector.dir_to_rotation(dir).y
	
	local z_dir = vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -dir_rot_y)
	local z_clicked_face_dir = vector.rotate_around_axis(clicked_face_dir, {x=0, y=1, z=0}, -dir_rot_y)
	
	local clicked_face_dir_rot_y = vector.dir_to_rotation(z_clicked_face_dir).y
	local clicked_sofa_part = seat.get_sofa_part(node.name)
	
	local next_nodename
	local close_nodename
	local next_node_param2
	local close_node_param2

	if clicked_face_dir_rot_y == math.pi/2 then
		if clicked_sofa_part == "" then
			next_nodename = seat.get_sofa_name_from_part(sofa_def, "left")
			close_nodename = seat.get_sofa_name_from_part(sofa_def, "right")
		elseif clicked_sofa_part == "left" or clicked_sofa_part == "right" then
			next_nodename = clicked_sofa_part == "right" and seat.get_sofa_name_from_part(sofa_def, "middle")
			close_nodename = seat.get_sofa_name_from_part(sofa_def, "right")
		end
	elseif clicked_face_dir_rot_y == -math.pi/2 then
		if clicked_sofa_part == "" then
			next_nodename = seat.get_sofa_name_from_part(sofa_def, "right")
			close_nodename = seat.get_sofa_name_from_part(sofa_def, "left")
		elseif clicked_sofa_part == "left" or clicked_sofa_part == "right" then
			next_nodename = clicked_sofa_part == "left" and seat.get_sofa_name_from_part(sofa_def, "middle")
			close_nodename = seat.get_sofa_name_from_part(sofa_def, "left")
		end
	elseif clicked_face_dir_rot_y == 0 then
		if clicked_sofa_part == "left" then
			next_nodename = seat.get_sofa_name_from_part(sofa_def, "corner")
			close_nodename = seat.get_sofa_name_from_part(sofa_def, "left")
			close_node_param2 = minetest.dir_to_facedir(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -math.pi/2))
		elseif clicked_sofa_part == "right" then
			next_nodename = seat.get_sofa_name_from_part(sofa_def, "corner")
			next_node_param2 = minetest.dir_to_facedir(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi/2))
			close_nodename = seat.get_sofa_name_from_part(sofa_def, "right")
			close_node_param2 = next_node_param2
		end
	end
	
	if next_nodename and close_nodename then
		itemstack = itemstack:take_item()
		minetest.set_node(pos, {name = next_nodename, param2 = next_node_param2 or node.param2})
		minetest.set_node(pointed_thing.above, {name = close_nodename, param2 = close_node_param2 or node.param2})
		return true, itemstack
	end
	
	return false, itemstack
end
