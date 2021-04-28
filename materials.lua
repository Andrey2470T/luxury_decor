local function random_dropped_items_amount(player, itemstack, max_items_amount)
	local random_items_amount_to_give = math.random(max_items_amount)
        
        local stack = ItemStack(itemstack.. tostring(random_items_amount_to_give))
	local inv = minetest.get_inventory({type="player", name=player:get_player_name()})
	inv:add_item("main", stack)
end

for _, wood_sort in ipairs(luxury_decor.wood_sorts) do
	local upcase_letters = luxury_decor.upper_letters(wood_sort, 1, 1)
	local wooden_board_itemstr = luxury_decor.build_wooden_item_string("wooden_board", wood_sort)
	minetest.register_craftitem(wooden_board_itemstr, {
		description = upcase_letters .. " Wooden Board",
		inventory_image = "luxury_decor_" .. wood_sort .. "_board.png",
		groups = {wooden_board = 1}
	})
	
	minetest.register_craft({
		type = "shapeless", 
		output = wooden_board_itemstr .. " 3",
		recipe = {luxury_decor.build_wooden_item_string("wooden_slab", wood_sort), "luxury_decor:saw"},
		replacements = {
			{{luxury_decor.build_wooden_item_string("wooden_slab", wood_sort),""}, {"luxury_decor:saw", "luxury_decor:saw"}}
		}
	})
	
	local wooden_plank_itemstr = luxury_decor.build_wooden_item_string("wooden_plank", wood_sort)
	minetest.register_craftitem(wooden_plank_itemstr, {
		description = upcase_letters .. " Wooden Plank",
		inventory_image = "luxury_decor_" .. wood_sort .. "_plank.png",
		groups = {wooden_plank = 1}
	})
	
	minetest.register_craft({
		type = "shapeless", 
		output = wooden_plank_itemstr .. " 2",
		recipe = {wooden_board_itemstr, "luxury_decor:saw"},
		replacements = {
			{{wooden_board_itemstr ,""}, {"luxury_decor:saw", "luxury_decor:saw"}}
		}
	})
	
	local wooden_drawer_itemstr = luxury_decor.build_wooden_item_string("wooden_drawer", wood_sort)
	minetest.register_craftitem(wooden_drawer_itemstr, {
		description = upcase_letters .. " Wooden Drawer",
		inventory_image = "luxury_decor_" .. wood_sort .. "_drawer.png",
		groups = {wooden_drawer = 1}
	})
	
	minetest.register_craft({
		output = wooden_drawer_itemstr,
		recipe = {
			{wooden_board_itemstr, wooden_board_itemstr, ""},
			{wooden_board_itemstr, "", ""},
			{"default:stick", "", ""}
		}
	})
end

minetest.register_craftitem("luxury_decor:bucket_oil", {
    description = "Bucket Oil",
    inventory_image = "luxury_decor_bucket_oil.png",
    stack_max = 99
})

minetest.register_node("luxury_decor:oil_source", {
	description = "Oil Source",
	drawtype = "liquid",
	tiles = {"luxury_decor_oil_source.png"},
	alpha = 250,
	paramtype = "light",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "source",
	liquid_alternative_flowing = "luxury_decor:oil_flowing",
	liquid_alternative_source = "luxury_decor:oil_source",
	liquid_viscosity = 7,
    liquid_range = 5,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory=1},
    on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        if itemstack:get_name() == "bucket:bucket_empty" then
            minetest.remove_node(pos)
            itemstack:take_item()
            local stack = ItemStack("luxury_decor:bucket_oil")
	    local inv = minetest.get_inventory({type="player", name=player:get_player_name()})
	    inv:add_item("main", stack)
        end
    end
})

minetest.register_node("luxury_decor:solid_oil", {
    description = "Solid Oil (use furnace to melt)",
    tiles = {"luxury_decor_solid_oil.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2},
    sounds = default.node_sound_stone_defaults()
})

minetest.register_node("luxury_decor:oil_flowing", {
	description = "Flowing Oil",
	drawtype = "flowingliquid",
	tiles = {"luxury_decor_oil_source.png"},
    special_tiles = {
		{
			name = "luxury_decor_oil_source_animated.png",
			backface_culling = false,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 10,
			},
		},
		{
			name = "luxury_decor_oil_source_animated.png",
			backface_culling = true,
			animation = {
				type = "vertical_frames",
				aspect_w = 16,
				aspect_h = 16,
				length = 10,
			},
		}
	},
	alpha = 250,
	paramtype = "light",
	paramtype2 = "flowingliquid",
	walkable = false,
	pointable = false,
	diggable = false,
	buildable_to = true,
	is_ground_content = false,
	drop = "",
	drowning = 1,
	liquidtype = "flowing",
    liquid_range = 4,
	liquid_alternative_flowing = "luxury_decor:oil_flowing",
	liquid_alternative_source = "luxury_decor:oil_source",
	liquid_viscosity = 7,
	post_effect_color = {a = 103, r = 30, g = 60, b = 90},
	groups = {water = 3, liquid = 3, not_in_creative_inventory = 1},
    on_rightclick = function (pos, node, player, itemstack, pointed_thing)
        if itemstack:get_name() == "bucket:bucket_empty" then
            minetest.remove_node(pos)
            itemstack:take_item()
            local stack = ItemStack("luxury_decor:bucket_oil")
            local inv = minetest.get_inventory({type="player", name=player:get_player_name()})
            inv:add_item("main", stack)
            
	end
    end
})

minetest.register_craftitem("luxury_decor:bucket_oil", {
	description = "Oil Bucket",
	inventory_image = "luxury_decor_bucket_oil.png",
	on_place = function(itemstack, placer, pointed_thing)
		itemstack:take_item()
		local stack = ItemStack("bucket:bucket_empty")
		local inv = minetest.get_inventory({type="player", name=placer:get_player_name()})
		inv:add_item("main", stack)
		minetest.set_node(pointed_thing.above, {name="luxury_decor:oil_source"})
		return itemstack
	end
})

minetest.register_craftitem("luxury_decor:steel_scissors", {
    description = "Steel Scissors",
    inventory_image = "luxury_decor_steel_scissors.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:lampshade", {
    description = "Lampshade",
    inventory_image = "luxury_decor_lampshade.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:lampshades", {
    description = "Lampshades",
    inventory_image = "luxury_decor_lampshades.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:paraffin_cake", {
    description = "Paraffin Cake",
    inventory_image = "luxury_decor_paraffin.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:wax_lump", {
    description = "Wax Lump",
    inventory_image = "luxury_decor_wax_lump.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:brass_ingot", {
    description = "Brass Ingot",
    inventory_image = "luxury_decor_brass_ingot.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:brass_stick", {
    description = "Brass Stick",
    inventory_image = "luxury_decor_brass_stick.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:zinc_ingot", {
    description = "Zinc Ingot",
    inventory_image = "luxury_decor_zinc_ingot.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:zinc_fragments", {
    description = "Zinc Fragments",
    inventory_image = "luxury_decor_zinc_fragments.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:copper_and_zinc", {
    description = "Copper and Zinc",
    inventory_image = "luxury_decor_copper_and_zinc.png",
    stack_max = 99
})


minetest.register_craftitem("luxury_decor:plastic_sheet", {
    description = "Plastic Sheet",
    inventory_image = "luxury_decor_plastic_sheet.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:incandescent_bulb", {
    description = "Incandescent Bulb",
    inventory_image = "luxury_decor_incandescent_bulb.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:incandescent_bulbs", {
    description = "Incandescent Bulbs",
    inventory_image = "luxury_decor_incandescent_bulbs.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:wolfram_lump", {
    description = "Wolfram Lump",
    inventory_image = "luxury_decor_wolfram_lump.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:wolfram_ingot", {
    description = "Wolfram Ingot",
    inventory_image = "luxury_decor_wolfram_ingot.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:wolfram_wire_reel", {
    description = "Wolfram Wire Reel",
    inventory_image = "luxury_decor_wolfram_wire_reel.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:dial", {
    description = "Dial",
    inventory_image = "luxury_decor_dial.png",
    stack_max = 99
})

minetest.register_craftitem("luxury_decor:siphon", {
    description = "Siphon",
    inventory_image = "luxury_decor_siphon.png",
    stack_max = 99
})

minetest.register_node("luxury_decor:zinc_ore", {
    description = "Zinc Ore",
    tiles = {"default_stone.png^luxury_decor_mineral_zinc.png"},
    is_ground_content = true,
    paramtype = "light",
    light_source = 6,
    drop="",
    groups = {cracky=3},
    sounds = default.node_sound_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
       random_dropped_items_amount(digger, "luxury_decor:zinc_fragments ", 5)
    end
})

minetest.register_node("luxury_decor:wolfram_ore", {
    description = "Wolfram Ore",
    tiles = {"default_stone.png^luxury_decor_mineral_wolfram.png"},
    is_ground_content = true,
    paramtype = "light",
    light_source = 2,
    drop="",
    groups = {cracky=3.5},
    sounds = default.node_sound_defaults(),
    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        random_dropped_items_amount(digger, "luxury_decor:wolfram_lump ", 4)
    end
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "luxury_decor:zinc_ore",
    wherein = "default:stone",
    clust_scarcity = 400,
    clust_num_ores = 5,
    clust_size = 3,
    height_min = -31000,
    height_max = -125
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "luxury_decor:wolfram_ore",
    wherein = "default:stone",
    clust_scarcity = 800,
    clust_num_ores = 4,
    clust_size = 2,
    height_min = -31000,
    height_max = -150
})

minetest.register_ore({
    ore_type = "scatter",
    ore = "luxury_decor:solid_oil",
    wherein = "default:stone",
    clust_scarcity = 700,
    clust_num_ores = 3,
    clust_size = 3,
    height_min = -31000,
    height_max = -25
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:bucket_oil",
    recipe = {"bucket:bucket_empty", "luxury_decor:oil_source"}
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:oil_source",
    recipe = "luxury_decor:solid_oil",
    cooktime = 4
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:paraffin_cake 2",
    recipe = "luxury_decor:bucket_oil",
    cooktime = 15--[[,
    replacements = {"bucket:bucket_empty"}]]
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:wax_lump",
    recipe = "luxury_decor:paraffin_cake",
    cooktime = 8
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:plastic_sheet",
    recipe = "default:leaves"
})

minetest.register_craft({
    output = "luxury_decor:incandescent_bulb 3",
    recipe = {
        {"luxury_decor:plastic_sheet", "luxury_decor:wolfram_wire_reel", ""},
        {"luxury_decor:plastic_sheet", "default:steel_ingot", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    type = "cooking",
    output = "luxury_decor:wolfram_ingot",
    recipe = "luxury_decor:wolfram_lump",
    cooktime = 18
})

minetest.register_craft({
    output = "luxury_decor:steel_scissors",
    recipe = {
        {"default:steel_ingot", "default:stick", ""},
        {"default:stick", "", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:lampshade 3",
    recipe = {
        {"wool:white", "luxury_decor:brass_ingot", ""},
        {"luxury_decor:steel_scissors", "", ""},
        {"", "", ""}
    },
    replacements = {
        {{"wool:white", ""}, {"luxury_decor:brass_ingot", ""}, {"", ""}},
        {{"luxury_decor:steel_scissors", "luxury_decor:steel_scissors"}, {"", ""}, {"", ""}},
        {{"", ""}, {"", ""}, {"", ""}}
    }
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:lampshades",
    recipe = {"luxury_decor:lampshade", "luxury_decor:lampshade", "luxury_decor:lampshade"}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:incandescent_bulbs",
    recipe = {"luxury_decor:incandescent_bulb", "luxury_decor:incandescent_bulb", "luxury_decor:incandescent_bulb"}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:wolfram_wire_reel",
    recipe = {"luxury_decor:wolfram_ingot"}
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
    inventory_image = "luxury_decor_saw.png",
    stack_max = 99
})


minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:saw",
    recipe = {"group:wooden_plank", "default:steel_ingot"}
})

minetest.register_craftitem("luxury_decor:hammer", {
    description = "Hammer",
    inventory_image = "luxury_decor_hammer.png",
    stack_max = 99
})

minetest.register_craft({
	type = "shapeless",
	output = "luxury_decor:hammer 2",
	recipe = {"group:wooden_board", "default:steel_ingot", "luxury_decor:saw"},
	replacements = {{"group:wooden_board", ""}, {"default:steel_ingot", ""}, {"luxury_decor:saw", "luxury_decor:saw"}}
})

minetest.register_craft({
    type = "shapeless",
    output = "luxury_decor:glass_vase 2",
    recipe = {"stairs:slab_glass", "luxury_decor:saw"},
    replacements = {
        {{"stairs:slab_glass", ""}, {"luxury_decor:saw", "luxury_decor:saw"}}
    }
})

minetest.register_craft({
    output = "luxury_decor:siphon",
    recipe = {
        {"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", ""},
        {"default:copper_ingot", "", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:dial 2",
    recipe = {
        {"luxury_decor:plastic_sheet", "dye:black", ""},
        {"luxury_decor:brass_stick", "", ""},
        {"dye:yellow", "", ""}
    }
})


minetest.register_on_craft(function (itemstack, player, old_craft_grid, craft_inv)
	for i = 1, #old_craft_grid do
		local ud = old_craft_grid[i]
		local name = ud:get_name()
		if name == "luxury_decor:saw" then
            minetest.sound_play("wood_sawing", {
				to_player = player:get_player_name()
				})
		end
        
        if name == "luxury_decor:steel_scissors" then
            minetest.sound_play("steel_scissors", {to_player=player:get_player_name()})
            return
        end
	end
end)
