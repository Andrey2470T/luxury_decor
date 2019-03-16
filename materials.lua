for _, material in ipairs({"", "jungle_", "pine_"}) do
    minetest.register_craftitem("luxury_decor:" .. material .. "wooden_plank", {
        description = string.upper(string.sub(material, 1, 1)) .. string.sub(material, 2, -2) .. " Wooden Plank",
        inventory_image = material .. "wooden_plank.png",
        stack_max = 99
    })
    
end

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:wooden_plank 2",
    recipe = {"luxury_decor:wooden_board", "luxury_decor:saw"},
    replacements = {
        {"", "luxury_decor:saw"}
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:jungle_wooden_plank 2",
    recipe = {"luxury_decor:jungle_wooden_board", "luxury_decor:saw"},
    replacements = {
        {"", "luxury_decor:saw"}
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:pine_wooden_plank 2",
    recipe = {"luxury_decor:pine_wooden_board", "luxury_decor:saw"},
    replacements = {
        {"", "luxury_decor:saw"}
    }
})

minetest.register_craftitem("luxury_decor:brass_ingot", {
    description = "Brass Ingot",
    inventory_image = "brass_ingot.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:brass_stick", {
    description = "Brass Stick",
    inventory_image = "brass_stick.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:zinc_ingot", {
    description = "Zinc Ingot",
    inventory_image = "zinc_ingot.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:zinc_fragments", {
    description = "Zinc Fragments",
    inventory_image = "zinc_fragments.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:copper_and_zinc", {
    description = "Copper and Zinc",
    inventory_image = "copper_and_zinc.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:wooden_board", {
    description = "Wooden Board",
    inventory_image = "wooden_board.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:jungle_wooden_board", {
    description = "Jungle Board",
    inventory_image = "jungle_board.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:pine_wooden_board", {
    description = "Pine Board",
    inventory_image = "pine_board.png",
    stack_max = 99
})
minetest.register_node("luxury_decor:zinc_ore", {
    description = "Zinc Ore",
    tiles = {"default_stone.png^mineral_zinc.png"},
    is_ground_content = true,
    paramtype = "light",
    light_source = 6,
    groups = {cracky=3, oddly_breakable_by_hand=1},
    sounds = default.node_sound_defaults(),
    after_dig_node = function(pos, node, player)
        local random_items_amount_to_give = math.random(4)
        
        local stack = ItemStack("luxury_decor:zinc_fragments")
        for give_item = 1, random_items_amount_to_give do
            stack:add_item("luxury_decor:zinc_fragments")
        end
    end
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "luxury_decor:zinc_ore",
    wherein = "default:stone",
    clust_scarcity = 200,
    clust_num_ores = 5,
    clust_size = 3,
    height_min = -31000,
    height_max = -40
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:brass_stick 3",
    recipe = {"luxury_decor:brass_ingot"}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:copper_and_zinc",
    recipe = {"default:copper_ingot", "luxury_decor:zinc_ingot"}
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:brass_ingot",
    recipe = "luxury_decor:copper_and_zinc",
    cooktime = 10
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:zinc_ingot",
    recipe = "luxury_decor:zinc_fragments",
    cooktime = 7
})

minetest.register_craftitem("luxury_decor:saw", {
    description = "Saw",
    inventory_image = "saw.png",
    stack_max = 99
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:wooden_board 3",
    recipe = {"stairs:slab_wood", "luxury_decor:saw"}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:jungle_wooden_board 3",
    recipe = {"stairs:slab_junglewood", "luxury_decor:saw"}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:pine_wooden_board 3",
    recipe = {"stairs:slab_pine_wood", "luxury_decor:saw"}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:saw",
    recipe = {"default:wood", "default:steel_ingot"},
    replacements = {
        {"luxury_decor:wooden_board", ""}
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:glass_vase 2",
    recipe = {"stairs:slab_glass", "luxury_decor:saw"},
    replacements = {
        {"", "luxury_decor:saw"}
    }
})
