--  Connection API
-- Can be used e.g. for connectable stuff as sofas, footstools, shelves, tables and other.

connection = {}

-- Params:
-- 'pos' is position of clicked node.
-- 'itemstack' is an identical node that wanted to be set and connected with the clicked node.
-- 'pointed_thing' is 'pointed_thing' table of the clicked node.
-- Currently connectable nodes can be connected only sideways!
connection.connect_node = function(pos, itemstack, pointed_thing)
	local clicked_node = minetest.get_node(pos)
	local clicked_node_def = minetest.registered_nodes[clicked_node.name]
	local node_def = minetest.registered_nodes[itemstack:get_name()]
	if not node_def then
		return false, itemstack
	end
	local are_nodes_identical = connection.are_nodes_identical(clicked_node_def, node_def)
		
	if not are_nodes_identical then
		return false, itemstack
	end
	local dir = clicked_node_def.paramtype2 == "facedir" and minetest.facedir_to_dir(clicked_node.param2) or
			clicked_node_def.paramtype2 == "wallmounted" and minetest.wallmounted_to_dir(clicked_node.param2)
	
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
	local clicked_node_part = connection.get_node_part(clicked_node_def)
	
	local next_nodename
	local close_nodename
	local next_node_param2
	local close_node_param2

	if clicked_face_dir_rot_y == math.pi/2 then
		if clicked_node_part == "original" then
			next_nodename = connection.get_node_name_from_part(node_def, "left")
			close_nodename = connection.get_node_name_from_part(node_def, "right")
		elseif clicked_node_part == "left" or clicked_node_part == "right" then
			next_nodename = clicked_node_part == "right" and connection.get_node_name_from_part(node_def, "middle")
			close_nodename = connection.get_node_name_from_part(node_def, "right")
		end
	elseif clicked_face_dir_rot_y == -math.pi/2 then
		if clicked_node_part == "original" then
			next_nodename = connection.get_node_name_from_part(node_def, "right")
			close_nodename = connection.get_node_name_from_part(node_def, "left")
		elseif clicked_node_part == "left" or clicked_node_part == "right" then
			next_nodename = clicked_node_part == "left" and connection.get_node_name_from_part(node_def, "middle")
			close_nodename = connection.get_node_name_from_part(node_def, "left")
		end
	elseif clicked_face_dir_rot_y == 0 then
		if clicked_node_part == "left" then
			next_nodename = connection.get_node_name_from_part(node_def, "corner")
			close_nodename = connection.get_node_name_from_part(node_def, "left")
			close_node_param2 = clicked_node_def.paramtype2 == "facedir" and minetest.dir_to_facedir(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -math.pi/2)) or
					clicked_node_def.paramtype2 == "wallmounted" and minetest.dir_to_wallmounted(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -math.pi/2))
		elseif clicked_node_part == "right" then
			next_nodename = connection.get_node_name_from_part(node_def, "corner")
			next_node_param2 = clicked_node_def == "facedir" and minetest.dir_to_facedir(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi/2)) or
					clicked_node_def == "wallmounted" and minetest.dir_to_wallmounted(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi/2))
			close_nodename = connection.get_node_name_from_part(node_def, "right")
			close_node_param2 = next_node_param2
		end
	end
	
	if next_nodename and close_nodename then
		itemstack = itemstack:take_item()
		minetest.swap_node(pos, {name = next_nodename, param2 = next_node_param2 or clicked_node.param2})
		minetest.set_node(pointed_thing.above, {name = close_nodename, param2 = close_node_param2 or clicked_node.param2})
		return true, itemstack
	end
	
	return false, itemstack
end


-- Disconnect adjacent identical nodes from the destroyed node with position 'pos'.
-- Should be called *after* the node with 'pos' is removed! E.g. in 'after_dig_node' callback.

-- Params:
-- 'pos' is position of destroyed node.
connection.disconnect_node = function(pos)
	local destroyed_node = minetest.get_node(pos)
	local destroyed_node_def = minetest.registered_nodes[destroyed_node.name]

	local dir = destroyed_node_def.paramtype2 == "facedir" and minetest.facedir_to_dir(destroyed_node.param2) or
			destroyed_node_def.paramtype2 == "wallmounted" and minetest.wallmounted_to_dir(destroyed_node.param2)
	dir = vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi)
	
	local adjacent_left_pos = vector.add(pos, vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -math.pi/2))
	local adjacent_right_pos = vector.add(pos, vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi/2))
	local adjacent_left_node = minetest.get_node(adjacent_left_pos)
	local adjacent_right_node = minetest.get_node(adjacent_right_pos)
	
	local are_left_and_destr_nodes_can_disconnect = connection.are_nodes_identical(minetest.registered_nodes[adjacent_left_node.name], destroyed_node_def) and 
			destroyed_node.param2 == adjacent_left_node.param2
	local right_node_def = minetest.registered_nodes[adjacent_right_node.name]
	local right_node_dir = right_node_def.paramtype2 == "facedir" and minetest.facedir_to_dir(adjacent_right_node.param2) or
			right_node_def.paramtype2 == "wallmounted" and minetest.wallmounted_to_dir(adjacent_right_node.param2) or {x=0, y=0, z=0}
	local are_param2_vals_eq = connection.get_node_part(right_node_def) == "corner" and 
			vector.dir_to_rotation(dir).y - math.pi/2 == vector.dir_to_rotation(vector.rotate_around_axis(right_node_dir, {x=0, y=1, z=0}, math.pi)).y or
			destroyed_node.param2 == adjacent_right_node.param2
	local are_right_and_destr_nodes_can_disconnect = connection.are_nodes_identical(minetest.registered_nodes[adjacent_right_node.name], destroyed_node_def) and are_param2_vals_eq
	
	local destr_node_part = connection.get_node_part(destroyed_node_def)
	
	if are_left_and_destr_nodes_can_disconnect then
		if destr_node_part == "right" or destr_node_part == "middle" then
			local left_node_part = connection.get_node_part(minetest.registered_nodes[adjacent_left_node.name])
			if left_node_part == "middle" then
				minetest.swap_node(adjacent_left_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "right"), param2 = destroyed_node.param2})
			elseif left_node_part == "corner" then
				local right_node_def = minetest.registered_nodes[adjacent_left_node.name]
				local right_node_param2 = right_node_def.paramtype2 == "facedir" and minetest.dir_to_facedir(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -math.pi/2)) or
						right_node_def.paramtype2 == "wallmounted" and minetest.dir_to_wallmounted(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, -math.pi/2))
				minetest.swap_node(adjacent_left_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "right"), param2 = right_node_param2})
			else
				minetest.swap_node(adjacent_left_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "original"), param2 = destroyed_node.param2})
			end
		end
	end
	
	if are_right_and_destr_nodes_can_disconnect then
		if destr_node_part == "left" or destr_node_part == "middle" or destr_node_part == "corner" then
			local right_node_part = connection.get_node_part(right_node_def)
			if right_node_part == "middle" then
				minetest.swap_node(adjacent_right_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "left"), param2 = destroyed_node.param2})
			elseif right_node_part == "corner" then
				local right_node_param2 = minetest.dir_to_facedir(vector.rotate_around_axis(dir, {x=0, y=1, z=0}, math.pi/2))
				minetest.swap_node(adjacent_right_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "left"), param2 = adjacent_right_node.param2})
			else
				minetest.swap_node(adjacent_right_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "original"), param2 = destroyed_node.param2})
			end
			
			if destr_node_part == "corner" then
				local adjacent_forward_pos = vector.add(pos, dir)
				local adjacent_forward_node = minetest.get_node(adjacent_forward_pos)
		
				local are_forward_and_destr_nodes_identical = connection.are_nodes_identical(minetest.registered_nodes[adjacent_forward_node.name], destroyed_node_def)
				local forward_node_def = minetest.registered_nodes[adjacent_forward_node.name]
				local forward_node_dir = forward_node_def.paramtype2 == "facedir" and minetest.facedir_to_dir(adjacent_forward_node.param2) or
						forward_node_def.paramtype2 == "wallmounted" and minetest.wallmounted_to_dir(adjacent_forward_node.param2) or {x=0, y=0, z=0}
				forward_node_dir = vector.rotate_around_axis(forward_node_dir, {x=0, y=1, z=0}, math.pi)
				are_param2_vals_eq = vector.dir_to_rotation(forward_node_dir).y - math.pi/2 == vector.dir_to_rotation(dir).y
				
				if are_forward_and_destr_nodes_identical and are_param2_vals_eq then
					local forward_node_part = connection.get_node_part(forward_node_def)
			
					if forward_node_part == "middle" then
						minetest.swap_node(adjacent_forward_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "right"), param2 = adjacent_forward_node.param2})
					elseif forward_node_part == "left" then
						minetest.swap_node(adjacent_forward_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "original"), param2 = adjacent_forward_node.param2})
					elseif forward_node_part == "corner" then
						forward_node_dir = vector.rotate_around_axis(forward_node_dir, {x=0, y=1, z=0}, math.pi/2)
						minetest.swap_node(adjacent_forward_pos, {name = connection.get_node_name_from_part(destroyed_node_def, "right"), param2 = minetest.dir_to_facedir(forward_node_dir)})
					end
				end
			end
		end
	end
	
	return true
end

-- Registers connected parts nodes of the node with definition 'def' that is already registered. That node should have "part_original" group.
connection.register_connected_parts = function(def)
	if not def.connectable then
		return
	end
	
	for _, type in ipairs({"left", "right", "middle", "corner"}) do
		local copy_def = table.copy(def)
		copy_def.mesh = copy_def.drawtype == "mesh" and copy_def.connected_parts_meshes[type]
		copy_def.groups.not_in_creative_inventory = 1
		copy_def.groups.part_original = nil
		copy_def.groups["part_" .. type] = 1
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
		
		if luxury_decor.get_material(copy_def) == "wooden" and copy_def.register_wood_sorts then
			wood.register_wooden_sorts_nodes(copy_def, type)
		else
			copy_def.drop = def.drop or "luxury_decor:" .. def.actual_name
			local res_name = "luxury_decor:" .. def.actual_name .. "_" .. type
			minetest.register_node(res_name, copy_def)
	
			if def.paintable then
				paint.register_colored_nodes(res_name)
			end
		end
	end
end

-- Checks if the first and second nodes are identical. They are regarded identical if they have similar types, styles, materials, colors and wood sorts that defined within this mod.
connection.are_nodes_identical = function(node_def, node2_def)
	return luxury_decor.get_type(node_def) == luxury_decor.get_type(node2_def) and
			luxury_decor.get_style(node_def) == luxury_decor.get_style(node2_def) and
			luxury_decor.get_material(node_def) == luxury_decor.get_material(node2_def) and
			luxury_decor.get_color(node_def) == luxury_decor.get_color(node2_def) and
			luxury_decor.get_wood_sort(node_def) == luxury_decor.get_wood_sort(node2_def)
end

-- Returns part name which the given node belongs to. It can be "left", "right", "middle", "corner" and also "original" (unconnected).
connection.get_node_part = function(def)
	if def then
		for name, val in pairs(def.groups) do
			local splits = string.split(name, "_")
		
			if splits[1] == "part" and val == 1 then
				return splits[2]
			end
		end
	end
	
	return -1
end

connection.get_node_name_from_part = function(def, partname)
	local wood_sort = luxury_decor.get_wood_sort(def)
	local color = luxury_decor.get_color(def)
	
	return "luxury_decor:" .. def.actual_name .. (partname ~= "original" and "_" .. partname or "") .. 
			(wood_sort ~= -1 and "_" .. wood_sort or "") .. (color ~= -1 and color ~= def.base_color and "_" .. color or "")
end
