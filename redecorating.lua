for _, material in ipairs({"", "jungle_", "pine_"}) do
    minetest.register_node("luxury_decor:" .. material .. "laminate", {
        description = "Floor tile (" .. material .. "laminate)",
        tiles = {material .. "laminate.png"},
        paramtype = "light",
        groups = {snappy=2},
        drawtype = "nodebox",
        node_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, -0.45, 0.5}
            }
        },
        sounds = default.node_sound_leaves_defaults()
    })
    
    minetest.register_craft({
        type = "shapeless",
        output = "luxury_decor:" .. material .. "laminate",
        recipe = {"luxury_decor:" .. material .. "wooden_plank", "luxury_decor:" .. material .. "wooden_plank"}
    })
end

minetest.register_node("luxury_decor:simple_flowerpot", {
    description = "Simple Flowerpot",
    visual_scale = 0.5,
    mesh = "simple_flowerpot.b3d",
    inventory_image = "simple_flowerpot_inv.png",
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

minetest.register_node("luxury_decor:luxury_flowerpot", {
    description = "Luxury Flowerpot",
    visual_scale = 0.5,
    mesh = "luxury_flowerpot.b3d",
    inventory_image = "luxury_flowerpot_inv.png",
    tiles = {"luxury_flowerpot.png"},
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
    
minetest.register_craft({
    output = "luxury_decor:simple_flowerpot",
    recipe = {
        {"default:clay_lump", "default:clay_lump", "dye:brown"},
        {"default:clay_lump", "default:dirt", ""},
        {"default:clay_lump", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:luxury_flowerpot",
    recipe = {
        {"default:clay_lump", "default:clay_lump", "dye:red"},
        {"default:clay_lump", "default:dirt", "default:copper_ingot"},
        {"default:clay_lump", "", ""}
    }
})
