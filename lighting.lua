minetest.register_node("luxury_decor:luxury_desk_lamp_off", {
    description = "Luxury Desk Lamp",
    visual_scale = 0.5,
    mesh = "luxury_desk_lamp.obj",
    inventory_image = "luxury_desk_lamp_inv.png",
    tiles = {"luxury_desk_lamp.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:luxury_desk_lamp_on"})
    end
}) 

minetest.register_node("luxury_decor:luxury_desk_lamp_on", {
    description = "Luxury Desk Lamp",
    visual_scale = 0.5,
    mesh = "luxury_desk_lamp.obj",
    inventory_image = "luxury_desk_lamp_inv.png",
    tiles = {"luxury_desk_lamp.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    drop = "luxury_decor:luxury_desk_lamp_off",
    light_source = 7,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:luxury_desk_lamp_off"})
    end
}) 

minetest.register_node("luxury_decor:iron_chandelier", {
    description = "Iron Chandelier",
    visual_scale = 0.5,
    mesh = "iron_chandelier.obj",
    inventory_image = "iron_chandelier_inv.png",
    tiles = {{
            name = "iron_chandelier_animated.png",
            animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, lenght = 4}
    }},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    light_source = 12,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.4, -0.5, 0.5, 0.5, 0.5},
            {-0.8, -0.9, -0.8, 0.8, -0.4, 0.8}
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.4, -0.5, 0.5, 0.5, 0.5},
            {-0.8, -0.9, -0.8, 0.8, -0.4, 0.8}
        }
    },
    sounds = default.node_sound_wood_defaults()
    
}) 


minetest.register_node("luxury_decor:wall_glass_lamp_off", {
    description = "Wall Glass Lamp",
    visual_scale = 0.5,
    mesh = "wall_glass_lamp.b3d",
    inventory_image = "wall_glass_lamp_inv.png",
    tiles = {"wall_glass_lamp.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:wall_glass_lamp_on", param2 = node.param2})
    end
}) 

minetest.register_node("luxury_decor:wall_glass_lamp_on", {
    description = "Wall Glass Lamp",
    visual_scale = 0.5,
    mesh = "wall_glass_lamp.b3d",
    inventory_image = "wall_glass_lamp_inv.png",
    tiles = {"wall_glass_lamp.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    drop = "luxury_decor:luxury_desk_lamp_off",
    light_source = 11,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:wall_glass_lamp_off", param2 = node.param2})
    end
}) 
