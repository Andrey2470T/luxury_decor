

--[[function chairs.attach_player_to_node (attacher, node, node_pos, pos)    
    attacher:set_pos(pos)
    local phys_over = attacher:get_physics_override()
    attacher:set_physics_override({speed=0, jump=0})
    attacher:get_meta():set_string("is_attached", minetest.serialize({node=node, node_pos=node_pos, pos, old_phys_over = phys_over}))
end

function chairs.disattach_player_from_node(disattacher)
    local meta = disattacher:get_meta()
    local is_attached = minetest.deserialize(meta:get_string("is_attached"))
    local phys_over = is_attached.old_phys_over
    disattacher:set_physics_override({speed=phys_over.speed, jump=phys_over.jump})
    meta:set_string("is_attached", "")
end

function chairs.set_seat_pos(player, pos, dir, x_val, z_val)
    local is_attached = minetest.deserialize(player:get_meta():get_string("is_attached"))
    if is_attached ~= nil or is_attached ~= "" then
        for axis, val in pairs(dir) do
            if val ~= 0 then
                local new_pos = pos
                
                
                local dff = {
                    ["x"] = {z={"-", "+"}},
                    ["-x"] = {z={"+", "-"}},
                    ["z"] = {x={"+", "-"}},
                    ["-z"] = {x={"-", "+"}}
                }
                
                new_pos[axis] = pos[axis] + val
                
                break
            end
        end
        
        local sdfd = {"x", "-x", "z", "-z"}
        
        for _, axis in ipairs(sdfd) do
            local axis = tonumber(axis)
            if axis == dir_axis then
                local need_axis = pos[tonumber(string.sub(tostring(axis), 2))]
                local need_sign = need_axis[string.sub(val, 1, 1)]
    else
        return


function chairs.set_look_dir(player)
    local is_attached = minetest.deserialize(player:get_meta():get_string("is_attached"))
    if is_attached ~= nil or is_attached ~= "" then
        minetest.debug(dump(is_attached))
        local node_dir = is_attached.node.param2
        local player_dir = player:get_look_dir()
        local degrees = 0
        local radians = 0
        while node_dir ~= player_dir do
            degrees = degrees + 90
            radians = math.floor(math.rad(degrees))
            player:set_look_horizontal(radians)
            player_dir = player:get_look_dir()
            minetest.debug(dump(player_dir))
        end
    else
        return
    end
end
            
        
-- "seats" table should contain: {[1]={is_busy={bool, player_obj}, pos=table}, [2]={is_busy={bool, player_obj}, pos=table}, ... [n]}
function chairs.sit_player(sitter, node, pos, sitter_anim)
    
    local meta = minetest.get_meta(pos)
    local seats = minetest.deserialize(meta:get_string("seats_range"))
    
    for seat_num, seat_data in pairs(seats) do
        if seat_num == #seats and seat_data.is_busy.bool == true then
            minetest.chat_send_player(sitter:get_player_name(), "All seats are busy!")
            return
        end
        if seat_data.is_busy.bool == false then
            seat_data.is_busy.bool = true
            seat_data.is_busy.player = sitter:get_player_name()
            meta:set_string("seats_range", minetest.serialize(seats))
            chairs.attach_player_to_node(sitter, node, pos, seat_data.pos)
            if #sitter_anim > 1 then
                local random_anim = math.random(1, #sitter_anim)
                sitter:set_animation(sitter_anim[random_anim][1], sitter_anim[random_anim][frame_speed], sitter_anim[random_anim][frame_blend])
            else
                sitter:set_animation(sitter_anim[1][1], sitter_anim[1][frame_speed], sitter_anim[1][frame_blend])
            end
            
        end
        
    end
end

function chairs.standup_player(player, pos, oldmetadata_seats)
    local meta = minetest.get_meta(pos)
    local player_meta = minetest.deserialize(player:get_meta():get_string("is_attached"))
    minetest.debug(dump(player_meta))
    if player_meta ~= nil then
        local pos = player_meta.node_pos
        local seats = minetest.deserialize(meta:get_string("seats_range")) or oldmetadata_seats or {}
        
        for seat_num, seat_data in pairs(seats) do
            if seat_data.is_busy.player == player:get_player_name() then
                seat_data.is_busy.bool = false
                seat_data.is_busy.player = nil
                meta:set_string("seats_range", minetest.serialize(seats))
                chairs.disattach_player_from_node(player)
                player:set_animation({x=1,y=1}, 15, 0)
            end
        end
    else
        return
    end
end]]
                
minetest.register_node("luxury_decor:kitchen_wooden_chair", {
    description = "Kitchen Wooden Chair",
    visual_scale = 0.5,
    mesh = "kitchen_wooden_chair.obj",
    tiles = {"bright_wood_material.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.43, -0.45, -0.4, 0.43, 0.39, 0.35},
            {-0.43, -0.45, 0.35, 0.43, 1.3, 0.46}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.43, -0.45, -0.4, 0.43, 0.39, 0.35},
            {-0.43, -0.45, 0.35, 0.43, 1.3, 0.46}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
	meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.3, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, speed=15, blend=0, loop=true}}))
    end,
    after_dig_node = function (pos, oldnode, oldmetadata, digger)
        local seat = minetest.deserialize(oldmetadata.fields.seat)
            if seat.busy_by then
		local player = minetest.get_player_by_name(seat.busy_by)
		chairs.standup_player(player, pos, seat)
		
            end
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
	local bool = chairs.sit_player(clicker, node, pos) 
	if bool == nil then
		chairs.standup_player(clicker, pos)
	end
    end
            

})
 

minetest.register_node("luxury_decor:luxury_wooden_chair_with_cushion", {
    description = "Luxury Wooden Chair (with cushion)",
    visual_scale = 0.5,
    mesh = "luxury_wooden_chair_with_cushion.b3d",
    tiles = {"luxury_wooden_chair_with_cushion.png"},
    inventory_image = "luxury_wooden_chair_with_cushion_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
                 {-0.45, -0.5, -0.45, 0.45, 0.28, 0.42},
                 {-0.3, 0.28, 0.28, 0.45, 1.4, 0.42}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
                 {-0.45, -0.5, -0.45, 0.45, 0.28, 0.42},
                 {-0.3, 0.28, 0.28, 0.45, 1.4, 0.42}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
	meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.32, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, frame_speed=15, frame_blend=0, loop=true}}))
    end,
    after_dig_node = function (pos, oldnode, oldmetadata, digger)
	local seat = minetest.deserialize(oldmetadata.fields.seat)
	if seat.busy_by then
		local player = minetest.get_player_by_name(seat.busy_by)
		chairs.standup_player(player, pos, seat)
	end
        
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
	local bool = chairs.sit_player(clicker, node, pos)  
	if bool == nil then
		chairs.standup_player(clicker, pos)
	end
    end
})  


minetest.register_node("luxury_decor:decorative_wooden_chair", {
    description = "Decorative Wooden Chair",
    visual_scale = 0.5,
    mesh = "decorative_wooden_chair.b3d",
    inventory_image = "decorative_chair_inv.png",
    tiles = {"dark_wood_material2.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
                 {-0.5, 0.36, 0.4, 0.5, 1.5, 0.5}, -- Upper box
                 {-0.5, -0.5, -0.5, 0.5, 0.29, 0.5}, -- Lower box
                 {-0.45, 0.29, -0.475, 0.45, 0.36, 0.4} -- Middle box
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
                 {-0.5, 0.36, 0.4, 0.5, 1.5, 0.5}, -- Upper box
                 {-0.5, -0.5, -0.5, 0.5, 0.29, 0.5}, -- Lower box
                 {-0.45, 0.29, -0.475, 0.45, 0.36, 0.4} -- Middle box
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
	meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.4, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, frame_speed=15, frame_blend=0, loop=true}}))
    end,
    after_dig_node = function (pos, oldnode, oldmetadata, digger)
	local seat = minetest.deserialize(oldmetadata.fields.seat)
	if seat.busy_by then
		local player = minetest.get_player_by_name(seat.busy_by)
		chairs.standup_player(player, pos, seat)
	end
    
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
	local bool = chairs.sit_player(clicker, node, pos)  
	if bool == nil then
		chairs.standup_player(clicker, pos)
	end
    end
})
minetest.register_node("luxury_decor:round_wooden_chair", {
    description = "Round Wooden Chair",
    visual_scale = 0.5,
    mesh = "round_wooden_chair.obj",
    tiles = {"bright_wood_material2.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.45, -0.5, -0.45, 0.45, 0.35, 0.45},
            {-0.45, 0.35, 0.2, 0.45, 1.45, 0.35}
            
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.45, -0.5, -0.45, 0.45, 0.35, 0.45},
            {-0.45, 0.35, 0.2, 0.45, 1.45, 0.35}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
	meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.4, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, frame_speed=15, frame_blend=0, loop=true}}))
    end,
    after_dig_node = function (pos, oldnode, oldmetadata, digger)
	local seat = minetest.deserialize(oldmetadata.fields.seat)
	if seat.busy_by then
		local player = minetest.get_player_by_name(seat.busy_by)
		chairs.standup_player(player, pos, seat)
	end
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
	local bool = chairs.sit_player(clicker, node, pos)  
	if bool == nil then
		chairs.standup_player(clicker, pos)
	end
    end
})

for _, material in ipairs({"", "jungle", "pine_"}) do
    for i = 1, 9 do
        minetest.register_craft({
            type = "shapeless",
            output = "luxury_decor:" .. material .. " wooden_plank",
            recipe = {"default:" .. material .. "wood"}
        })
    end
end

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_chair",
    recipe = {
        {"luxury_decor:wooden_plank", "default:stick", "default:stick"},
        {"luxury_decor:wooden_plank", "default:stick", ""},
        {"luxury_decor:wooden_plank", "default:stick", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:luxury_wooden_chair_with_cushion",
    recipe = {
        {"luxury_decor:jungle_wooden_plank", "default:stick", "default:stick"},
        {"luxury_decor:jungle_wooden_plank", "default:stick", "wool:white"},
        {"luxury_decor:jungle_wooden_plank", "default:stick", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:round_wooden_chair",
    recipe = {
        {"luxury_decor:pine_wooden_plank", "default:stick", "default:stick"},
        {"luxury_decor:pine_wooden_plank", "default:stick", ""},
        {"luxury_decor:pine_wooden_plank", "default:stick", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:decorative_wooden_chair",
    recipe = {
        {"luxury_decor:jungle_wooden_plank", "default:stick", "default:stick"},
        {"luxury_decor:jungle_wooden_plank", "default:stick", ""},
        {"luxury_decor:jungle_wooden_plank", "default:stick", ""}
    }
})
--[[minetest.register_on_joinplayer(function (player)
    local is_attached = minetest.deserialize(player:get_meta():get_string("is_attached"))
    --minetest.debug(dump(is_attached))
    
    if is_attached ~= nil then
        local is_attached_to = is_attached.node
        chairs.standup_player(player)
        chairs.sit_player(player, is_attached_to, {{{x=81,y=81}, frame_speed=15, frame_blend=0}})
    end
end)
    
    

minetest.register_on_joinplayer(function (player)
    local meta = minetest.deserialize(player:get_meta():get_string("attached_to"))
    if meta ~= nil and meta ~= "" then
        local pos = player:get_pos()
        
        minetest.after(0, function()
            if minetest.get_node(meta[1][1]).name == meta[1][2] then
            --minetest.debug("DDDDDD!")
                player:set_pos(meta[1][1])
                player:set_animation(meta[6])
                player:set_physics_override({speed=0, jump=0})
            end
        end)
           
        
    end
end)]]
