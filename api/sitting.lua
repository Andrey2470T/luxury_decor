-- Sitting API

-- Node that can be sat on, must contain meta data table like: {is_busy_by = playername, pos = {x, y, z}, anim = {range, speed, blend}}. In future versions a support will be added for random selection of animations.

sitting = {}
function sitting.attach_player_to_node (attacher, seat_data)--node_pos, attach_pos, cur_mesh, cur_anim)    
	attacher:set_pos(seat_data.pos)
	attacher:set_look_vertical(seat_data.rot.x)
	attacher:set_look_horizontal(seat_data.rot.y)
	attacher:set_physics_override({speed=0, jump=0})
	
	if seat_data then
		attacher:set_properties({mesh = seat_data.mesh.model})
		attacher:set_animation(seat_data.mesh.anim.range, seat_data.mesh.anim.speed, seat_data.mesh.anim.blend, seat_data.mesh.anim.loop)
	end
end

function sitting.detach_player_from_node(detacher, prev_data)
	if not prev_data then
		return
	end
	
	detacher:set_physics_override(prev_data.physics)
	detacher:set_properties({mesh = prev_data.mesh})
	detacher:set_animation(prev_data.anim.range, prev_data.anim.speed, prev_data.anim.blend, prev_data.anim.loop)
end

function sitting.sit_player(player, node_pos)
	if not player then
		return false
	end
	local meta = minetest.get_meta(node_pos)
	local is_busy_by = meta:get_string("is_busy")
	local playername = player:get_player_name()
	
	if is_busy_by ~= "" then
		minetest.chat_send_player(playername, "This seat is busy by player \"" .. is_busy_by .. "\"!")
		return false
	end
	
	local node = minetest.get_node(node_pos)
	local seat_data = minetest.registered_nodes[node.name].seat_data
	local physics = player:get_physics_override()
	local range, speed, blend, loop = player:get_animation()
	player:get_meta():set_string("previous_mesh_data", minetest.serialize({
		mesh = player:get_properties().mesh,
		anim = {range = range, speed = speed, blend = blend, loop = loop},
		physics = {speed = physics.speed, jump = physics.jump}
	}))
	local rand_mesh = seat_data.mesh and seat_data.mesh[math.random(1, #seat_data.mesh)]
	local dir_rot = vector.dir_to_rotation(minetest.facedir_to_dir(node.param2))
	sitting.attach_player_to_node(player, {pos = vector.add(node_pos, seat_data.pos), rot = vector.add(dir_rot, seat_data.rot), mesh = rand_mesh})
	
	meta:set_string("is_busy", playername)
	
	return true
end

function sitting.standup_player(player, node_pos)
	if not player then
		return
	end
	local meta = minetest.get_meta(node_pos)
	
	if player:get_player_name() ~= meta:get_string("is_busy") then
		return false
	end
	
	local player_meta = player:get_meta()
	sitting.detach_player_from_node(player, minetest.deserialize(player_meta:get_string("previous_mesh_data")))
	
	player_meta:set_string("previous_mesh_data", "")
	meta:set_string("is_busy", "")
	
	return true
end
