--[[local table_meshes = {
    "kitchen_table",
    "kitchen_table1",
    "kitchen_table2",
    "kitchen_table3",
    "kitchen_table4"
}

for ind, mesh in pairs(table_meshes) do
    local groups = {not_in_creative_inventory=1}
    if ind == 1 then
        groups = {not_in_creative_inventory=0}
    end
    minetest.register_node("luxury_decor:"..mesh, {
        description = string.upper(mesh),
        visual_scale = 0.5,
        mesh = mesh..".obj",
        tiles = {"wood_material.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=3.5, groups[not_in_creative_inventory]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
            }
        },
        sounds = default.node_sound_wood_defaults(),
        on_place = function (itemstack, placer, pointed_thing)
            local table_pos = {pointed_thing.above.x, pointed_thing.above.y+0.5, pointed_thing.above.z}
            if itemstack == "luxury_decor:kitchen_table" then
                local put_tables_list = {}
                table.insert(put_tables_list, table_pos)
                
                for ind2, table in pairs(put_tables_list) do
                    local finding_table_nodes = minetest.find_nodes_in_area({x = pointed_thing.above.x - 1, y = pointed_thing.above.y + 0.5, z = pointed_thing.above.z + 1},
                    {x = pointed_thing.above.x +1, y = pointed_thing.above.y + 0.5, z = pointed_thing.z - 1}, {"luxury_decor:kitchen_table",
                                                                                                               "luxury_decor:kitchen_table1", 
                                                                                                               "luxury_decor:kitchen_table2", 
                                                                                                               "luxury_decor:kitchen_table3", 
                                                                                                               "luxury_decor:kitchen_table4"}
                    )
                    
                    if #finding_table_nodes[1] == 8 then
                        minetest.add_node({x=table_pos.x, y=table_pos.y, z=table_pos.z}, "luxury_decor:kitchen_table5")
                    elseif #finding_table_nodes[1] == 1 then
                        for ind3, axis in pairs(finding_table_nodes[1][ind2]) do
                            if axis ~= table_pos[ind3] then
                                minetest.add_node({x=table_pos.x, y=table_pos.y, z=table_pos.z}, "luxury_decor:kitchen_table2")
                                local vector_table = {0, 0, 0}
                                if table_pos[ind3] > 0 then
                                    table.remove(vector_table, ind3)
                                    table.insert(vector_table, ind3, 1)
                                elseif table_pos[ind3] < 0 then
                                    table.remove(vector_table, ind3)
                                    table.insert(vector_table, ind3, -1)
                                end
                                
                                break
                            end
                        end
                    else
                        minetest.add_node({x=table_pos.x, y=table_pos.y, z=table_pos.z}, "luxury_decor:kitchen_table")
                        return itemstack
                    end
                end
                
            else
                minetest.add_node({x=table_pos.x, y=table_pos.y, z=table_pos.z}, "luxury_decor:kitchen_table")
                return itemstack
            end
                
         end   
                                    
                        if finding_table_nodes[1][ind2][1] ~= table_pos.x then
                            minetest.add_node(table_pos, "luxury_decor:kitchen_table2")
                            if table_pos.x > 0 then
                                minetest.dir_to_wallmounted({x=1, y=0, z=0})
                            elseif table_pos.x < 0 then
                                minetest.dir_to_wallmounted({x=-1, y=0, z=0})
                        
                for _, pos in ipairs(finding_table_nodes) do
                    if pos == {x = pointed_thing.above.x-1, y = pointed_thing.above.y+0.5, z = pointed_thing.above.z} or
                       pos == {x = pointed_thing.above.x+1, y = pointed_thing.above.y+0.5, z = pointed_thing.above.z} or
                       pos == {x = pointed_thing.above.x, y = pointed_thing.above.y+0.5, z = pointed_thing.above.z-1} or
                       pos == {x = pointed_thing.above.x, y = pointed_thing.above.y+0.5, z = pointed_thing.above.z+1} then
                       
                       
    })
end]]


luxury_decor.register_table({
	actual_name = "simple_wooden_table",
	base_color = {
		["apple"] = "peru",
		["pine"] = "burlywood",
		["aspen"] = "cornsilk",
		["jungle"] = "brown",
		["acacia"] = "red"
	},
	register_wood_sorts = tables.wood_sorts,
	mesh = "simple_wooden_table.obj",
	textures = {
		["apple"] = {"luxury_decor_apple_material.png"},
		["pine"] = {"luxury_decor_pine_material.png"},
		["aspen"] = {"luxury_decor_aspen_material.png"},
		["jungle"] = {"luxury_decor_jungle_material.png"},
		["acacia"] = {"luxury_decor_acacia_material.png"}
	},
	groups = {choppy = 3},
	multiply_by_color = {1},
	paintable = true,
	collision_box = {
		{-1.45, -0.5, -0.5, 0.55, 0.5, 0.5}
	},
	craft_recipe = {
		recipe = {
			{"wooden_board", "wooden_board", "wooden_board"}, 
			{"wooden_plank", "wooden_plank", "wooden_plank"},
			{"luxury_decor:hammer", "wooden_plank", ""}
		},
		replacements = {
			{{"wooden_board", ""}, {"wooden_board", ""}, {"wooden_board", ""}},
			{{"wooden_plank", ""}, {"wooden_plank", ""}, {"wooden_plank", ""}},
			{{"luxury_decor:hammer", "luxury_decor:hammer"}, {"", ""}, {"", ""}}
		}
	}
})

luxury_decor.register_table({
	actual_name = "round_luxury_table",
	base_color = {
		["apple"] = "peru",
		["pine"] = "burlywood",
		["aspen"] = "cornsilk",
		["jungle"] = "brown",
		["acacia"] = "red"
	},
	register_wood_sorts = tables.wood_sorts,
	mesh = "round_luxury_table.b3d",
	textures = {
		["apple"] = {"luxury_decor_apple_material.png"},
		["pine"] = {"luxury_decor_pine_material.png"},
		["aspen"] = {"luxury_decor_aspen_material.png"},
		["jungle"] = {"luxury_decor_jungle_material.png"},
		["acacia"] = {"luxury_decor_acacia_material.png"}
	},
	multiply_by_color = {1},
	paintable = true,
	craft_recipe = {
		recipe = {
			{"", "wooden_board", ""}, 
			{"", "wooden_plank", "luxury_decor:hammer"},
			{"", "wooden_plank", ""}
		},
		replacements = {
			{{"", ""}, {"wooden_board", ""}, {"", ""}},
			{{"", ""}, {"wooden_plank", ""}, {"luxury_decor:hammer", "luxury_decor:hammer"}},
			{{"", ""}, {"wooden_plank", ""}, {"", ""}}
		}
	}
})

luxury_decor.register_table({
	actual_name = "kitchen_wooden_table",
	base_color = {
		["apple"] = "peru",
		["pine"] = "burlywood",
		["aspen"] = "cornsilk",
		["jungle"] = "brown",
		["acacia"] = "red"
	},
	register_wood_sorts = tables.wood_sorts,
	mesh = "kitchen_wooden_table.obj",
	textures = {
		["apple"] = {"luxury_decor_apple_material.png"},
		["pine"] = {"luxury_decor_pine_material.png"},
		["aspen"] = {"luxury_decor_aspen_material.png"},
		["jungle"] = {"luxury_decor_jungle_material.png"},
		["acacia"] = {"luxury_decor_acacia_material.png"}
	},
	groups = {choppy = 2},
	multiply_by_color = {1},
	paintable = true,
	craft_recipe = {
		recipe = {
			{"", "wooden_board", "luxury_decor:hammer"},
			{"wooden_plank", "default:stick", "wooden_plank"},
			{"wooden_plank", "", "wooden_plank"}
		},
		replacements = {
			{{"", ""}, {"wooden_board", ""}, {"luxury_decor:hammer", "luxury_decor:hammer"}},
			{{"wooden_plank", ""}, {"default:stick", ""}, {"wooden_plank", ""}},
			{{"wooden_plank", ""}, {"", ""}, {"wooden_plank", ""}}
		}
	}
})

--[[minetest.register_node("luxury_decor:simple_wooden_table", {
    description = "Simple Wooden Table",
    visual_scale = 0.5,
    mesh = "simple_wooden_table.obj",
    tiles = {"luxury_decor_jungle_material.png"},
    inventory_image = "luxury_decor_simple_wooden_table_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-1.45, -0.5, -0.5, 0.55, 0.5, 0.5},
            --{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-1.50, -0.5, -0.5, 0.50, 0.5, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})

minetest.register_node("luxury_decor:round_luxury_table", {
    description = "Round Luxury Wooden Table",
    visual_scale = 0.5,
    mesh = "round_luxury_table.b3d",
    tiles = {"luxury_decor_jungle_material.png"},
    inventory_image = "luxury_decor_round_luxury_table_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}
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

minetest.register_alias("luxury_decor:luxury_metallic_table", "luxury_decor:round_luxury_table")

minetest.register_node("luxury_decor:kitchen_wooden_table", {
    description = "Kitchen Wooden Table",
    visual_scale = 0.5,
    mesh = "kitchen_wooden_table.obj",
    tiles = {"luxury_decor_bright_wood_material.png"},
    inventory_image = "luxury_decor_kitchen_wooden_table_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
            --{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}
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
    output = "luxury_decor:kitchen_wooden_table",
    recipe = {
        {"luxury_decor:wooden_plank", "luxury_decor:wooden_plank", "luxury_decor:wooden_plank"},
        {"luxury_decor:wooden_plank", "default:stick", "luxury_decor:wooden_plank"},
        {"default:stick", "", "default:stick"}
    }
})

minetest.register_craft({
    output = "luxury_decor:round_luxury_table",
    recipe = {
        {"default:junglewood", "luxury_decor:jungle_wooden_board", "default:junglewood"}, 
        {"", "luxury_decor:jungle_wooden_plank", ""},
        {"", "luxury_decor:jungle_wooden_plank", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:simple_wooden_table",
    recipe = {
        {"luxury_decor:jungle_wooden_plank", "luxury_decor:jungle_wooden_plank", "luxury_decor:jungle_wooden_plank"}, 
        {"default:stick", "luxury_decor:jungle_wooden_plank", "default:stick"},
        {"", "", ""}
    }
})]]
