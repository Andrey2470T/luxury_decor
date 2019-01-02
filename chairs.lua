local is_chair_busy_by = {}
local chairs = {}

function chairs.attach_player_to_node (attacher, node, pos)    
    attacher:set_pos(pos)
    attacher:set_physics_override({speed=0, jump=0})
    attacher:get_meta():set_string("is_attached", minetest.serialize({node, pos, old_phys_over = attacher:get_physics_override()}))
end

function chairs.disattach_player_from_node(disattacher)
    local meta = disattacher.get_meta():get_string("is_attached")
    local phys_over = meta.old_phys_over
    attacher:set_physics_override({phys_over.speed, phys_over.jump})
    meta:set_string("is_attached", "")
end

-- "seats" table should contain: {[1]={is_busy={bool, player_obj}, pos=table}, [2]={is_busy={bool, player_obj}, pos=table}, ... [n]}
function chairs.sit_player(sitter, node, sitter_anim)
    --[[local player_meta = minetest.deserialize(sitter:get_meta():get_string("is_attached"))
    if player_meta == "" or player_meta == nil then
        return
    end]]
    local meta = minetest.get_meta(pos)
    local seats = minetest.deserialize(meta:get_string("seats_range"))
    
    for seat_num, seat_data in pairs(seats) do
        if seat_data.is_busy.bool == false then
            seat_data.is_busy.bool = true
            seat_data.is_busy.player_obj = sitter
            chairs.attach_player_to_node(sitter, node, seat_data.pos)
            if #sitter_anim > 1 then
                local random_anim = math.random(1, #sitter_anim)
                sitter:set_animation(sitter_anim[random_anim])
            else
                sitter:set_animation(sitter_anim[1])
            end
            
        end
        
        if seat_num == #seats and seat_data.is_busy.bool == true then
            minetest.chat_send_player(sitter:get_player_name(), "All seats are busy!")
            return
        end
    end
end

function chairs.standup_player(player)
    local player_meta = minetest.deserialize(player:get_meta():get_string("is_attached"))
    if player_meta ~= "" or player_meta ~= nil then
        local seats = minetest.deserialize(minetest.get_meta():get_string("seats_range"))
        
        for seat_num, seat_data in pairs(seats) do
            if seat_data.is_busy.player_obj == player then
                seat_data.is_busy.bool = false
                seat_data.is_busy.player_obj = nil
                
                chairs.disattach_player_from_node(player)
                player:set_animation({x=1,y=1}, frame_speed=15, frame_blend=0))
            end
        end
    else
        return
    end
end
                
    

--[[function chairs.standup_player(player)
    local meta = player:get_meta()
    local is_attached_to = minetest.deserialize(meta:get_string("attached_to"))
    --minetest.debug(dump(is_attached_to[4]))
    player:set_animation(is_attached_to[6])
    player:set_physics_override(is_attached_to[4])
    
    meta:set_string("attached_to", "")
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
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("seats_range", minetest.serialize({[1] = {is_busy={bool=false, player_obj=nil}, pos = {x = pos.x, y = pos.y, z = pos.z}}}))
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
        --minetest.debug(dump(is_attached_to))
        if is_attached == nil or is_attached == "" then
            chairs.sit_player(clicker, node, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
            
        elseif is_attached ~= nil or is_attached ~= "" then
            chairs.standup_player(clicker)
            
        end
    end
            
        --[[elseif clicker:get_player_name() ~= is_attached_to[3] and is_attached_to ~= nil then
            minetest.chat_send_player(clicker:get_player_name(), "This bed is already busy!")
        elseif clicker:get_player_name() == is_attached_to[3] and pos == is_attached_to[1][1] and minetest.get_node(pos).name == is_attached_to[1][2] then
            minetest.debug("AAAAAAAAAAAAAAAAAAAAAAA")
            chairs.standup_player(clicker)
        end]]
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
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("seats_range", minetest.serialize({[1] = {is_busy={bool=false, player_obj=nil}, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}}}))
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
        --minetest.debug(dump(is_attached_to))
        if is_attached == nil or is_attached == "" then
            chairs.sit_player(clicker, node, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
            
        elseif is_attached ~= nil or is_attached ~= "" then
            chairs.standup_player(clicker)
            
        end
    end
})  


minetest.register_node("luxury_decor:decorative_wooden_chair", {
    description = "Decorative Wooden Chair",
    visual_scale = 0.5,
    mesh = "decorative_wooden_chair.obj",
    inventory_image = "decorative_chair_inv.png",
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
    on_construct = function (pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("seats_range", minetest.serialize({[1] = {is_busy={bool=false, player_obj=nil}, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}}}))
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
        --minetest.debug(dump(is_attached_to))
        if is_attached == nil or is_attached == "" then
            chairs.sit_player(clicker, node, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
            
        elseif is_attached ~= nil or is_attached ~= "" then
            chairs.standup_player(clicker)
            
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
        meta:set_string("seats_range", minetest.serialize({[1] = {is_busy={bool=false, player_obj=nil}, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}}}))
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = clicker:get_meta()
        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
        --minetest.debug(dump(is_attached_to))
        if is_attached == nil or is_attached == "" then
            chairs.sit_player(clicker, node, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
            
        elseif is_attached ~= nil or is_attached ~= "" then
            chairs.standup_player(clicker)
            
        end
    end
})
minetest.register_on_dignode(function (pos, oldnode, digger)
    local seats = minetest.get_meta(pos):get_string("seats_range")
    for seat_num, seat_data in pairs(seats) do
        if seat_data.is_busy.player_obj ~= nil then
            chairs.standup_player(seat_data.is_busy.player_obj)
        end
    end
end)

minetest.register_on_joinplayer(function (player)
    local is_attached = player:get_meta():get_string("is_attached")
    
    if is_attached ~= "" or is_attached ~= nil then
        local is_attached_to = is_attached.node
        chairs.standup_player(player)
        chairs.sit_player(player, is_attached_to, {{{x=81,y=81}, frame_speed=15, frame_blend=0}})
    end
end)
    
    
    
    --[[local node = minetest.get_node(pos)
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
