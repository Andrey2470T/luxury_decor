

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
]]
                
minetest.register_node("luxury_decor:kitchen_wooden_chair", {
    description = "Kitchen Wooden Chair",
    visual_scale = 0.5,
    mesh = "kitchen_wooden_chair.obj",
    tiles = {"luxury_decor_bright_wood_material.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.35, -0.5, -0.35, 0.35, 0.2, 0.25},
            {-0.35, -0.5, 0.25, 0.35, 0.925, 0.35}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.35, -0.5, -0.35, 0.35, 0.2, 0.25},
            {-0.35, -0.5, 0.25, 0.35, 0.925, 0.35}
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
 

minetest.register_node("luxury_decor:round_luxury_chair_with_cushion", {
    description = "Round Luxury Chair (with cushion)",
    visual_scale = 0.5,
    mesh = "round_luxury_chair.b3d",
    tiles = {"luxury_decor_round_luxury_chair.png"},
    inventory_image = "luxury_decor_round_luxury_chair_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
                 {-0.45, -0.5, -0.45, 0.45, 0.28, 0.42},
                 {-0.45, 0.28, 0.28, 0.45, 1.2, 0.42}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
                 {-0.45, -0.5, -0.45, 0.45, 0.2, 0.42},
                 {-0.45, 0.28, 0.28, 0.45, 1.2, 0.42}
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

minetest.register_alias("luxury_decor:luxury_wooden_chair_with_cushion", "luxury_decor:round_luxury_chair_with_cushion")


minetest.register_node("luxury_decor:decorative_wooden_chair", {
    description = "Decorative Wooden Chair",
    visual_scale = 0.5,
    mesh = "decorative_wooden_chair.b3d",
    inventory_image = "luxury_decor_decorative_chair_inv.png",
    tiles = {"luxury_decor_dark_wood_material2.png"},
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
    tiles = {"luxury_decor_bright_wood_material2.png"},
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
        {"default:wood", "luxury_decor:wooden_plank", "default:stick"},
        {"luxury_decor:wooden_plank", "default:stick", ""},
        {"luxury_decor:wooden_plank", "default:stick", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:round_luxury_chair_with_cushion",
    recipe = {
        {"default:junglewood", "luxury_decor:jungle_wooden_plank", "luxury_decor:jungle_wooden_plank"},
        {"default:stick", "default:stick", "wool:white"},
        {"default:stick", "default:stick", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:round_wooden_chair",
    recipe = {
        {"default:pinewood", "default:stick", "default:stick"},
        {"luxury_decor:pine_wooden_plank", "default:stick", ""},
        {"luxury_decor:pine_wooden_plank", "default:stick", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:decorative_wooden_chair",
    recipe = {
        {"default:junglewood", "default:stick", "default:stick"},
        {"default:junglewood", "default:stick", ""},
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
