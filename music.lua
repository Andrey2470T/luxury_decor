minetest.register_node("luxury_decor:grand_piano", {
    description = "Grand Piano",
    visual_scale = 0.5,
    mesh = "grand_piano.obj",
    tiles = {"grand_piano.png"},
    --inventory_image = "simple_wooden_table_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.4, -0.5, -1.4, 1.4, 0.4, 1.4},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.4, -0.5, -1.4, 1.4, 0.4, 1.4}
        }
    },
    sounds = default.node_sound_wood_defaults()
}) 
