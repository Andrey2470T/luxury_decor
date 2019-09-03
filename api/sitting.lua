-- Sitting API

-- Node that can be sat on, must contain meta data table like: {is_busy_by = playername, pos = {x, y, z}, anim = {range, speed, blend}}. In future versions a support will be added for random selection of animations.

chairs = {}
function chairs.attach_player_to_node (attacher, node_pos, attach_pos, cur_mesh, cur_anim)    
	attacher:set_pos(attach_pos)
	local phys_over = attacher:get_physics_override()
	attacher:set_physics_override({speed=0, jump=0})
	attacher:get_meta():set_string("is_attached", minetest.serialize({node_pos=node_pos, attach_pos=attach_pos, old_phys_over = phys_over, old_mesh=cur_mesh, old_anim = cur_anim}))
end

function chairs.detach_player_from_node(disattacher)
	local meta = disattacher:get_meta()
	local is_attached = minetest.deserialize(meta:get_string("is_attached"))
	local phys_over = is_attached.old_phys_over
	disattacher:set_physics_override({speed=phys_over.speed, jump=phys_over.jump})
	meta:set_string("is_attached", "")
end

function chairs.sit_player(player, node, pos)
	local meta = minetest.get_meta(pos)
	local seat = minetest.deserialize(meta:get_string("seat"))
	if not seat then
		return
	end
	
	local playername = player:get_player_name()
	minetest.debug(seat.busy_by)
	if type(seat.busy_by) == "string" then
		if seat.busy_by ~= playername then
		      minetest.chat_send_player(playername, "This seat is busy by player " .. seat.busy_by .. "!")
		end
		return
	end
	
	seat.busy_by = playername
	meta:set_string("seat", minetest.serialize(seat))
	local cur_anim = player:get_animation()
	local cur_mesh = player:get_properties().mesh
	chairs.attach_player_to_node(player, pos, seat.pos, cur_mesh, cur_anim)
	if seat.anim then
		player:set_properties({mesh = seat.anim.mesh})
		player:set_animation(seat.anim.range, seat.anim.speed, seat.anim.blend, seat.anim.loop)
	end
	
	return true
end

function chairs.standup_player(player, pos, old_seat_data)
	local seat
	if not old_seat_data then
		local meta = minetest.get_meta(pos)
		seat = minetest.deserialize(meta:get_string("seat"))
		if seat.busy_by == player:get_player_name() then
			--minetest.debug("TRUE")
			seat.busy_by = nil
			meta:set_string("seat", minetest.serialize(seat))
		end
	elseif type(old_seat_data) == "table" then
		seat = old_seat_data
		if seat.busy_by ~= player:get_player_name() then
			return
		end
	else
		return
	end
	local is_attached = minetest.deserialize(player:get_meta():get_string("is_attached"))
	if is_attached.old_mesh and is_attached.old_anim then 
		player:set_properties({mesh=is_attached.old_mesh})
		player:set_animation(is_attached.old_anim.range, is_attached.old_anim.speed, is_attached.old_anim.blend, is_attached.old_anim.loop) end
	chairs.detach_player_from_node(player)
	
	return true
end
