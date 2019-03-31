local wood_sorts = {"", "jungle_"}
for num, shelf_sort in ipairs({"bright", "dark"}) do
    minetest.register_node("luxury_decor:closed_"..shelf_sort.."_wooden_shelf", {
	description = "Closed ".. string.upper(string.sub(shelf_sort, 1, 1)) .. string.sub(shelf_sort, 2) .. " Wooden Shelf",
	tiles = {shelf_sort.."_wood_material2.png"},
	paramtype = "light",
    paramtype2 = "facedir",
	groups = {choppy=2},
	drawtype = "nodebox",
	node_box = {
	    type = "fixed",
	    fixed = {
		{-0.4, 0.4, -0.5, 0.4, 0.5, 0.5},-- upper box
		{-0.4, -0.5, -0.5, 0.4, -0.4, 0.5}, -- lower box
		{-0.5, -0.5, -0.5, -0.4, 0.5, 0.5}, -- left box
		{0.4, -0.5, -0.5, 0.5, 0.5, 0.5} -- right box
	    }
	},
	selection_box = {
	    type = "fixed",
	    fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	},
	sounds = default.node_sound_wood_defaults()
    })
    
    minetest.register_node("luxury_decor:closed_"..shelf_sort.."_wooden_shelf_with_back", {
	description = "Closed ".. string.upper(string.sub(shelf_sort, 1, 1)) .. string.sub(shelf_sort, 2) .. " Wooden Shelf (with back)",
	tiles = {shelf_sort.."_wood_material2.png"},
	paramtype = "light",
    paramtype2 = "facedir",
	groups = {choppy=2},
	drawtype = "nodebox",
	node_box = {
	    type = "fixed",
	    fixed = {
            {-0.4, 0.4, -0.5, 0.4, 0.5, 0.5},-- upper box
	    {-0.4, -0.5, -0.5, 0.4, -0.4, 0.5}, -- lower box
	    {-0.5, -0.5, -0.5, -0.4, 0.5, 0.5}, -- left box
	    {0.4, -0.5, -0.5, 0.5, 0.5, 0.5}, -- right box
	    {-0.5, -0.5, 0.4, 0.5, 0.5, 0.5} -- back box
        }
	},
	selection_box = {
	    type = "fixed",
	    fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	},
	sounds = default.node_sound_wood_defaults()
    })
    
    
    minetest.register_node("luxury_decor:".. shelf_sort .."_wall_wooden_shelf", {
    description = string.upper(string.sub(shelf_sort, 1, 1)) .. string.sub(shelf_sort, 2) .. " Wall Wooden Shelf",
    visual_scale = 0.5,
    mesh = "wall_wooden_shelf.obj",
    tiles = {shelf_sort .. "_wood_material2.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy=2},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.05, 0.5, 0.3, 0.5}, --upper box
	    --[[{-0.4, -0.5, -0.5, 0.4, -0.4, 0.5}, --lower box
	    {-0.5, -0.5, -0.5, -0.4, 0.5, 0.5}, --left box
	    {0.4, -0.5, -0.5, 0.5, 0.5, 0.5}, --right box
	    {-0.5, -0.5, 0.4, 0.5, 0.5, 0.5} --back box]]
        }
    },
    selection_box = {
	type = "fixed",
	fixed = {-0.5, 0.1, -0.05, 0.5, 0.5, 0.5}
    },
    sounds = default.node_sound_wood_defaults()
    }) 
    
    minetest.register_craft({
        output = "luxury_decor:closed_" .. shelf_sort .. "_wooden_shelf",
        recipe = {
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "luxury_decor:" .. wood_sorts[num] .. "wooden_board", ""},
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "luxury_decor:" .. wood_sorts[num] .. "wooden_board", ""},
            {"", "", ""}
        }
    })
    
    minetest.register_craft({
        output = "luxury_decor:closed_" .. shelf_sort .. "_wooden_shelf_with_back",
        recipe = {
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "luxury_decor:" .. wood_sorts[num] .. "wooden_board", ""},
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "luxury_decor:" .. wood_sorts[num] .. "wooden_board", ""},
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "", ""}
        }
    })
    
    minetest.register_craft({
        output = "luxury_decor:" .. shelf_sort .. "_wall_wooden_shelf",
        recipe = {
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_plank", "luxury_decor:saw", ""},
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_plank", "", ""},
            {"", "", ""}
        },
        replacements = {
            {"", "", "luxury_decor:saw"},
            {"", "", ""},
            {"", "", ""}
        }
    })
    
    minetest.register_craft({
        output = "luxury_decor:" .. shelf_sort .. "_wall_wooden_shelf 2",
        recipe = {
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "luxury_decor:saw", ""},
            {"luxury_decor:" .. wood_sorts[num] .. "wooden_board", "", ""},
            {"", "", ""}
        },
        replacements = {
            {"", "", "luxury_decor:saw"},
            {"", "", ""},
            {"", "", ""}
        }
    })
end
    
    

