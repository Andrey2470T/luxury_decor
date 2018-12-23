local is_chair_busy_by = {}
local chairs = {}
function chairs.sit_player(player, node, pos, player_anim)
    local meta = player:get_meta()
    
    meta:set_string("attached_to", minetest.serialize({node, pos, player:get_player_name(), player:get_physics_override(), player:get_animation(), player_anim}))
    player:set_pos(pos)
        
    if player_anim ~= nil then
        --minetest.debug("TRUE")
        player:set_animation(player_anim)
        
    end
        
    player:set_physics_override({speed=0, jump=0})
end

function chairs.standup_player(player)
    local meta = player:get_meta()
    local is_attached_to = minetest.deserialize(meta:get_string("attached_to"))
    --minetest.debug(dump(is_attached_to[4]))
    player:set_animation(is_attached_to[6])
    player:set_physics_override(is_attached_to[4])
    
    meta:set_string("attached_to", "")
end
    
    
    
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
            {-0.3, -0.5, -0.25, 0.45, 0.22, 0.38},
            {-0.3, -0.5, 0.38, 0.45, 1, 0.48}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, -0.25, 0.45, 0.22, 0.38},
            {-0.3, -0.5, 0.38, 0.45, 1, 0.48}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached_to = minetest.deserialize(meta:get_string("attached_to"))
        --minetest.debug(dump(is_attached_to))
        if is_attached_to == nil or is_attached_to == "" then
            chairs.sit_player(clicker, {pos, node.name, node.param1, node.param2}, {x=pos.x, y=pos.y+0.4, z=pos.z}, {x=81, y=81})
            
        elseif clicker:get_player_name() ~= is_attached_to[3] and is_attached_to ~= nil then
            minetest.chat_send_player(clicker:get_player_name(), "This bed is already busy!")
        elseif clicker:get_player_name() == is_attached_to[3] and pos == is_attached_to[1][1] and minetest.get_node(pos).name == is_attached_to[1][2] then
            minetest.debug("AAAAAAAAAAAAAAAAAAAAAAA")
            chairs.standup_player(clicker)
        end
        --[[if is_attached_to ~= nil then
            minetest.debug(clicker:get_player_name())
            minetest.debug(is_attached_to[3])
            minetest.debug(dump(pos))
            minetest.debug(dump(is_attached_to[1][1]))
            minetest.debug(minetest.get_node(pos).name)
            minetest.debug(is_attached_to[1][2])
            
        end]]
        
        
        --[[if minetest.get_node(pos).name ~= node.name then
            is_chair_busy_by = nil
            clicker:set_physics_override({speed=1.0})
            default.player_set_animation(clicker, "stand", 30)
        end]]
            
    end
})
 

minetest.register_node("luxury_decor:luxury_wooden_chair_with_cushion", {
    description = "Luxury Wooden Chair (with cushion)",
    visual_scale = 0.5,
    mesh = "luxury_wooden_chair_with_cushion.obj",
    tiles = {"luxury_wooden_chair_with_cushion.png"},
    inventory_image = "luxury_wooden_chair_with_cushion_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, -0.25, 0.45, 0.22, 0.38},
            {-0.3, -0.5, 0.38, 0.45, 1, 0.48}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, -0.25, 0.45, 0.22, 0.38},
            {-0.3, -0.5, 0.38, 0.45, 1, 0.48}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached_to = minetest.deserialize(meta:get_string("attached_to"))
        if is_attached_to == nil or is_attached_to == "" then
            chairs.sit_player(clicker, {pos, node.name, node.param1, node.param2}, {x=pos.x, y=pos.y+0.45, z=pos.z}, {x=81, y=81})
            
        elseif clicker:get_player_name() ~= is_attached_to[3] and is_attached_to ~= nil then
            minetest.chat_send_player(clicker:get_player_name(), "This bed is already busy!")
        elseif clicker:get_player_name() == is_attached_to[3] and pos == is_attached_to[1][1] and minetest.get_node(pos).name == is_attached_to[1][2] then
            chairs.standup_player(clicker)
        end
        
        --[[if minetest.get_node(pos).name ~= node.name then
            is_chair_busy_by = nil
            clicker:set_physics_override({speed=1.0})
            default.player_set_animation(clicker, "stand", 30)
        end]]
            
    end
})  


minetest.register_node("luxury_decor:decorative_wooden_chair", {
    description = "Decorative Wooden Chair",
    visual_scale = 0.5,
    mesh = "decorative_wooden_chair.obj",
    tiles = {"dark_wood_material2.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, -0.25, 0.45, 0.22, 0.38},
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, 0.48, 0.4, 0.5, 2.1, 0.5}, -- Upper box
            {-0.5, -0.5, -0.5, 0.5, 0.48, 0.5}, -- Lower box
            {-0.45, 0.48, -0.475, 0.45, 0.56, 0.4} -- Middle box
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached_to = minetest.deserialize(meta:get_string("attached_to"))
        --minetest.debug(dump(is_attached_to))
        if is_attached_to == nil or is_attached_to == "" then
            chairs.sit_player(clicker, {pos, node.name, node.param1, node.param2}, {x=pos.x, y=pos.y+0.5, z=pos.z}, {x=81, y=81})
            
        elseif clicker:get_player_name() ~= is_attached_to[3] and is_attached_to ~= nil then
            minetest.chat_send_player(clicker:get_player_name(), "This bed is already busy!")
        elseif clicker:get_player_name() == is_attached_to[3] and pos == is_attached_to[1][1] and minetest.get_node(pos).name == is_attached_to[1][2] then
            minetest.debug("AAAAAAAAAAAAAAAAAAAAAAA")
            chairs.standup_player(clicker)
        end
        --[[if is_attached_to ~= nil then
            minetest.debug(clicker:get_player_name())
            minetest.debug(is_attached_to[3])
            minetest.debug(dump(pos))
            minetest.debug(dump(is_attached_to[1][1]))
            minetest.debug(minetest.get_node(pos).name)
            minetest.debug(is_attached_to[1][2])
            
        end]]
        
        
        --[[if minetest.get_node(pos).name ~= node.name then
            is_chair_busy_by = nil
            clicker:set_physics_override({speed=1.0})
            default.player_set_animation(clicker, "stand", 30)
        end]]
            
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
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached_to = minetest.deserialize(meta:get_string("attached_to"))
        --minetest.debug(dump(is_attached_to))
        if is_attached_to == nil or is_attached_to == "" then
            chairs.sit_player(clicker, {pos, node.name, node.param1, node.param2}, {x=pos.x, y=pos.y+0.4, z=pos.z}, {x=81, y=81})
            
        elseif clicker:get_player_name() ~= is_attached_to[3] and is_attached_to ~= nil then
            minetest.chat_send_player(clicker:get_player_name(), "This bed is already busy!")
        elseif clicker:get_player_name() == is_attached_to[3] and pos == is_attached_to[1][1] and minetest.get_node(pos).name == is_attached_to[1][2] then
            minetest.debug("AAAAAAAAAAAAAAAAAAAAAAA")
            chairs.standup_player(clicker)
        end
        --[[if is_attached_to ~= nil then
            minetest.debug(clicker:get_player_name())
            minetest.debug(is_attached_to[3])
            minetest.debug(dump(pos))
            minetest.debug(dump(is_attached_to[1][1]))
            minetest.debug(minetest.get_node(pos).name)
            minetest.debug(is_attached_to[1][2])
            
        end]]
        
        
        --[[if minetest.get_node(pos).name ~= node.name then
            is_chair_busy_by = nil
            clicker:set_physics_override({speed=1.0})
            default.player_set_animation(clicker, "stand", 30)
        end]]
            
    end
})
minetest.register_on_dignode(function (pos, oldnode, digger)
    local node = minetest.get_node(pos)
    local objects = minetest.get_objects_inside_radius({x = pos.x - 0.5, y = pos.y, z = pos.z - 0.5}, 1)
    for _, obj in ipairs(objects) do
        if obj:is_player() then
            local meta = minetest.deserialize(obj:get_meta():get_string("attached_to"))
            if meta ~= nil and meta ~= "" then
                obj:get_meta():set_string("attached_to", "")
                obj:set_physics_override({speed=1.0,jump=1.0})
                obj:set_animation({x=1, y=1})
            end
        end
    end
end)

minetest.register_on_joinplayer(function (player)
    local meta = minetest.deserialize(player:get_meta():get_string("attached_to"))
    if meta ~= nil and meta ~= "" then
        local pos = player:get_pos()
        --minetest.debug(minetest.get_node({x=pos.x, y=pos.y, z = pos.z}).name)
        --minetest.debug(minetest.get_node(meta[1][1]).name)
        --minetest.debug(dump(meta[1][1]))
        --[[local is_action_executed = nil
        minetest.register_globalstep(function (dtime)
            local name = minetest.get_node(meta[1][1]).name]]
        minetest.after(0, function()
            if minetest.get_node(meta[1][1]).name == meta[1][2] then
            --minetest.debug("DDDDDD!")
                player:set_pos(meta[1][1])
                player:set_animation(meta[6])
                player:set_physics_override({speed=0, jump=0})
            end
        end)
           
        
    end
end)
