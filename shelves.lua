for _, shelf_sort in ipairs({"bright", "dark"}) do
    minetest.register_node("luxury_decor:closed"..shelf_sort.."_wooden_shelf", {
	description = "Closed".. shelf_sort.. " Wooden Shelf",
	tiles = {shelf_sort.."_wood_material2"},
	paramtype = "light",
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
    
    minetest.register_node("luxury_decor:closed"..shelf_sort.."_wooden_shelf_with_back", {
	description = "Closed".. shelf_sort.. " Wooden Shelf (with back)",
	tiles = {shelf_sort.."_wood_material2"},
	paramtype = "light",
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
    description = shelf_sort .. "Wall Wooden Shelf",
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
            {-0.5, 0.5, -0.5, 0.5, 0.5, 0.5}, --upper box
	    --[[{-0.4, -0.5, -0.5, 0.4, -0.4, 0.5}, --lower box
	    {-0.5, -0.5, -0.5, -0.4, 0.5, 0.5}, --left box
	    {0.4, -0.5, -0.5, 0.5, 0.5, 0.5}, --right box
	    {-0.5, -0.5, 0.4, 0.5, 0.5, 0.5} --back box]]
        }
    },
    selection_box = {
	type = "fixed",
	fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
    },
    sounds = default.node_sound_wood_defaults()
    }) 
end
    
    

