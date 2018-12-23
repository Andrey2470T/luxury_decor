minetest.register_node("luxury_decor:laminate", {
    description = "Floor tile (laminate)",
    tiles = {"laminate.png"},
    paramtype = "light",
    groups = {snappy=2},
    drawtype = "nodebox",
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}
        }
    },
    sounds = default.node_sound_leaves_defaults()
})
    
minetest.register_node("luxury_decor:simple_flowerpot", {
    description = "Simple Flowerpot",
    visual_scale = 0.5,
    mesh = "simple_flowerpot.obj",
    tiles = {"simple_flowerpot.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2},
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
    sounds = default.node_sound_wood_defaults()
})
    
