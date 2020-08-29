--  Piano API

piano = {} 

--  Constants
piano.keys_num = 52

piano.keys_sounds = {
    "A0",
    "H0",
    "C1",
    "D1",
    "E1",
    "F1",
    "G1",
    "A1",
    "H1",
    "C2",
    "D2",
    "E2",
    "F2",
    "G2",
    "A2",
    "H2",
    "C3",
    "D3",
    "E3",
    "F3",
    "G3",
    "A3",
    "H3",
    "C4",
    "D4",
    "E4",
    "F4",
    "G4",
    "A4",
    "H4",
    "C5",
    "D5",
    "E5",
    "F5",
    "G5",
    "A5",
    "H5",
    "C6",
    "D6",
    "E6",
    "F6",
    "G6",
    "A6",
    "H6",
    "C7",
    "D7",
    "E7",
    "F7",
    "G7",
    "A7",
    "H7",
    "C8"
}

--  Functions
luxury_decor.register_piano = function(def)
    local piano_def = {}
    
    piano_def.type  = def.type or "piano"
    piano_def.style = def.style or "simple"
    piano_def.color = def.color or "black"
    
    if not def.description or def.description == "" then
        piano_def.description = luxury_decor.upper_letters(piano_def.style, 1, 1) .. " " .. 
                luxury_decor.upper_letters(piano_def.color, 1, 1) .. " " .. 
                luxury_decor.upper_letters(piano_def.type, 1, 1)
        
        if def.item_info then
            piano_def = piano_def .. " " .. def.item_info
        end
    end
    
    piano_def.visual_scale          = def.visual_scale or 0.5
    piano_def.mesh                  = def.mesh
    piano_def.tiles                 = def.textures
    piano_def.paramtype             = "light"
    piano_def.paramtype2            = "facedir"
    piano_def.sunlight_propagates   = true
    piano_def.inventory_image       = def.inventory_image 
    piano_def.groups                = def.groups or {choppy=1}
    piano_def.drawtype              = "mesh"
    piano_def.collision_box         = {
        type = "fixed",
        fixed = def.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
    }
    piano_def.selection_box         = {
        type = "fixed",
        fixed = def.selection_box or piano_def.collision_box
    }
    piano_def.sounds                = def.sounds
    
    
    -- Start and end positions are defined relatively Z-axis that is facing for node
    -- Start position of the keyboard (at upper left corner!) (x, y, z)
    piano_def.keys_row_start_p      = def.keys_row_start_p
    -- End position of the keyboard (x, y, z)
    piano_def.keys_row_end_p        = def.keys_row_end_p

    
    -- Width of single key
    piano_def.key_w                 = def.key_w
    
    -- Calculates length of single key and save it further
    piano_def.key_len               = vector.distance(piano_def.keys_row_start_p, piano_def.keys_row_end_p)/piano.keys_num
    
    local nodename = "luxury_decor:" .. piano_def.style .. "_" .. piano_def.color .. "_" .. piano_def.type
    
    -- Register pianos with each pressed key
    for i, ksound in ipairs(piano.keys_sounds) do
        local find_dot = piano_def.mesh:find("%.", 1)
        minetest.register_node(nodename .. "_" .. ksound, {
            visual_scale        = piano_def.visual_scale,
            drawtype            = "mesh",
            mesh                = piano_def.mesh:sub(1, find_dot-1) .. "_" .. ksound .. piano_def.mesh:sub(find_dot, piano_def.mesh:len()),
            paramtype           = piano_def.paramtype,
            paramtype2          = piano_def.paramtype2,
            sunlight_propagates = piano_def.sunlight_propagates,
            tiles               = piano_def.tiles,
            inventory_image     = piano_def.inventory_image,
            groups              = {choppy=piano_def.groups.choppy, not_in_creative_inventory=1},
            collision_box       = piano_def.collision_box,
            selection_box       = piano_def.selection_box,
            sounds              = piano_def.sounds
        })
    end
    piano_def.on_construct      = function(pos)
        local node = minetest.get_node(pos)
        local def = minetest.registered_nodes[node.name]
        local krow_sp = def.keys_row_start_p
        local krow_ep = def.keys_row_start_p
        if krow_sp.y ~= krow_ep.y then return end
        local dir = minetest.facedir_to_dir(node.param2)
        
        if dir.y == 0 and (dir.z < 0 or dir.z == 0) then
            local yaw = vector.angle({x=0, y=0, z=1}, dir)
            krow_sp = vector.rotate(krow_sp, {x=0, y=yaw, z=0})
            krow_ep = vector.rotate(krow_ep, {x=0, y=yaw, z=0})
        end
        
        local meta = minetest.get_meta(pos)
        meta:set_string("keyboard_range", minetest.serialize({spoint=krow_sp, epoint=krow_ep}))
    end
    piano_def.on_rightclick     = function(pos, node, clicker, itemstack, pointed_thing)
        --[[local reach_vec = {x=0, y=0, z=30}
        reach_vec = vector.rotate(reach_vec, {x=clicker:get_look_vertical(), y=clicker:get_look_horizontal(), z=0})
        
        local pl_pos = clicker:get_pos()
        local ray = minetest.raycast(pl_pos, {x=pl_pos.x+reach_vec.x, y=pl_pos.y+reach_vec.y, z=pl_pos.z+reach_vec.z}, false, false)]]
        local exact_pos = mninetest.pointed_thing_to_face_pos(clicker, pointed_thing)
        local key_i = piano.get_pressed_key_i(pos, exact_pos)
        if key_i then
            piano.play_keysound(pos, key_i)
        end
        
    end
    
    minetest.register_node(nodename, piano_def)
end

piano.get_pressed_key_i = function(pos, exact_pos)
    --[[local node = minetest.get_node(pos)
    local intersect_p
    for pointed_thing in ray do
        local seek_node = minetest.get_node(pointed_thing.under)
        if n.name == node.name then
            intersect_p = pointed_thing.intersection_point
            break
        end
    end
    
    if not intersect_p then return end]]
    local kboard_r = minetest.deserialize(minetest.get_meta(pos):get_string("keyboard_range"))
    local dir = vector.direction(kboard_r.spoint, kboard_r.epoint)
    local dist = vector.distance(kboard_r.spoint, kboard_r.epoint)
    dir = vector.multiply(dir, dist)
    
    local udir = vector.divide(dir, piano.keys_num)
    
    local shift_pos = kboard_r.spoint
    for key_i = 1, piano.keys_num do
        local udir_angle = vector.angle(udir, {x=0, y=0, z=vector.length(udir)})
        local rot_to_lr_crn = vector.rotate({x=0, y=0, z=minetest.registered_nodes[minetest.get_node(pos).name].key_w}, {x=0, y=udir-90, z=0})
        local shift_pos2 = vector.add(vector.add(udir, rot_to_lr_crn), shift_pos)
        
        local x_diff = math.abs(shift_pos2.x-shift_pos.x)
        local z_diff = math.abs(shift_pos.x-shift_pos2.x)
        
        local is_exact_pos_between_two_ps = math.abs(exact_pos.x-shift_pos.x) < x_diff and math.abs(shift_pos2.x-exact_pos.x) < x_diff 
            and (math.abs(exact_pos.z-shift_pos.z) < z_diff and math.abs(shift_pos2.z-exact_pos.z)) 
        
        if is_exact_pos_between_two_ps then
            return key_i
        end
        
        shift_pos = vector.add(shift_pos, udir)
    end
    
    return
end

piano.play_keysound = function(pos, key_i)
    local node = minetest.get_node(pos)
    
    minetest.sound_play(
        "piano_key_" .. key_sounds[key_i] .. ".ogg", 
        {
         pos = pos,
         max_hear_distance = 30
        },
        true
    )
    
    local new_node_name = node.name:sub(14, node.name:len()) .. "_" .. piano.keys_sounds[key_i]
    minetest.set_node(pos, {name=new_node_name, param1=node.param1, param2=node.param2})
    minetest.after(0.8, function()
        minetest.set_node(pos, node)
    end, pos, node)
end
    
