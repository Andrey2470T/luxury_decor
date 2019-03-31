minetest.register_node("luxury_decor:grand_piano", {
    description = "Grand Piano",
    visual_scale = 0.5,
    mesh = "grand_piano.obj",
    inventory_image = "grand_piano_inv.png",
    tiles = {"grand_piano.png"},
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
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:grand_piano_opened", param1=node.param1, param2=node.param2})
    end
}) 


minetest.register_node("luxury_decor:grand_piano_opened", {
    description = "Grand Piano",
    visual_scale = 0.5,
    mesh = "grand_piano_opened.obj",
    inventory_image = "grand_piano_opened_inv.png",
    tiles = {"grand_piano.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3, not_in_creative_inventory=1},
    drop = "luxury_decor:grand_piano",
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
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:grand_piano", param1=node.param1, param2=node.param2})
    end
}) 

minetest.register_craft({
    output = "luxury_decor:grand_piano",
    recipe = {
        {"luxury_decor:plastic_sheet", "luxury_decor:brass_stick", "dye:black"},
        {"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "dye:black"},
        {"luxury_decor:plastic_sheet", "luxury_decor:wolfram_ingot", "default:steel_ingot"}
    }
})
