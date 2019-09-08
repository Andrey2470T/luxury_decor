minetest.register_node("luxury_decor:luxury_desk_lamp_off", {
    description = "Luxury Desk Lamp",
    visual_scale = 0.5,
    mesh = "luxury_desk_lamp.b3d",
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
    mesh = "luxury_desk_lamp.b3d",
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
            animation = {type = "vertical_frames", aspect_w = 16, aspect_h = 16, lenght = 5}
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

minetest.register_node("luxury_decor:royal_brass_chandelier_off", {
    description = "Royal Brass Chandelier",
    visual_scale = 0.5,
    mesh = "royal_brass_chandelier.b3d",
    use_texture_alpha = true,
    inventory_image = "royal_brass_chandelier_inv.png",
    tiles = {"royal_brass_chandelier.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
            {-1.1, -1.5, -1.1, 1.1, -0.5, 1.1}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
            {-1.1, -1.5, -1.1, 1.1, -0.5, 1.1}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:royal_brass_chandelier_on", param2 = node.param2})
    end
    
}) 

minetest.register_node("luxury_decor:royal_brass_chandelier_on", {
    description = "Royal Brass Chandelier",
    visual_scale = 0.5,
    mesh = "royal_brass_chandelier.b3d",
    use_texture_alpha = true,
    inventory_image = "royal_brass_chandelier_inv.png",
    tiles = {"royal_brass_chandelier.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    drop = "luxury_decor:royal_brass_chandelier_off",
    light_source = 11,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
            {-1.1, -1.5, -1.1, 1.1, -0.5, 1.1}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.5, 0.4},
            {-1.1, -1.5, -1.1, 1.1, -0.5, 1.1}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:royal_brass_chandelier_off", param2 = node.param2})
    end
}) 

minetest.register_node("luxury_decor:luxury_steel_chandelier_off", {
    description = "Luxury Steel Chandelier (with glass shades)",
    visual_scale = 0.5,
    mesh = "luxury_steel_chandelier.b3d",
    use_texture_alpha = true,
    inventory_image = "luxury_steel_chandelier_inv.png",
    tiles = {"luxury_steel_chandelier.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 2.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.75, -0.3, 0.3, 0.5, 0.3},
            {-0.9, -1.75, -0.9, 0.9, -0.75, 0.9}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.75, -0.3, 0.3, 0.5, 0.3},
            {-0.9, -1.75, -0.9, 0.9, -0.75, 0.9}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:luxury_steel_chandelier_on", param2 = node.param2})
    end
    
}) 
    
minetest.register_node("luxury_decor:luxury_steel_chandelier_on", {
    description = "Luxury Steel Chandelier (with glass shades)",
    visual_scale = 0.5,
    mesh = "luxury_steel_chandelier.b3d",
    use_texture_alpha = true,
    inventory_image = "luxury_steel_chandelier_inv.png",
    tiles = {"luxury_steel_chandelier.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 2.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    drop = "luxury_decor:luxury_steel_chandelier_off",
    light_source = 9,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.75, -0.3, 0.3, 0.5, 0.3},
            {-0.9, -1.75, -0.9, 0.9, -0.75, 0.9}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.75, -0.3, 0.3, 0.5, 0.3},
            {-0.9, -1.75, -0.9, 0.9, -0.75, 0.9}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.remove_node(pos)
        minetest.set_node(pos, {name="luxury_decor:luxury_steel_chandelier_off", param2 = node.param2})
    end
    
}) 

for color, rgb_code in pairs(rgb_colors) do
   minetest.register_node("luxury_decor:simple_plastic_"..color.."_chandelier_off", {
    description = "Simple Plastic Chandelier (with ".. color .. " plastic shades)",
    visual_scale = 0.5,
    mesh = "simple_plastic_chandelier.b3d",
    use_texture_alpha = true,
    tiles = {"simple_plastic_chandelier.png^(simple_plastic_chandelier_2_1.png^[colorize:"..rgb_code.."^simple_plastic_chandelier_2.png)"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.1, -0.3, 0.3, 0.5, 0.3},
            {-0.7, -0.65, -0.7, 0.7, -0.1, 0.7}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.1, -0.3, 0.3, 0.5, 0.3},
            {-0.7, -0.65, -0.7, 0.7, -0.1, 0.7}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        if string.find(itemstack:get_name(), "dye:") then
            local color_dye = string.sub(itemstack:get_name(), 5)
            minetest.set_node(pos, {name="luxury_decor:simple_plastic_"..color_dye.."_chandelier_off", param1=node.param1, param2=node.param2})
            itemstack:take_item()
        else
            minetest.remove_node(pos)
            minetest.set_node(pos, {name="luxury_decor:simple_plastic_"..color.."_chandelier_on", param2 = node.param2})
        end
    end
    
   }) 
       
   minetest.register_node("luxury_decor:simple_plastic_"..color.."_chandelier_on", {
    description = "Simple Plastic Chandelier (with ".. color .. " plastic shades)",
    visual_scale = 0.5,
    mesh = "simple_plastic_chandelier.b3d",
    use_texture_alpha = true,
    tiles = {"simple_plastic_chandelier.png^(simple_plastic_chandelier_2_1.png^[colorize:"..rgb_code.."^simple_plastic_chandelier_2.png)"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    drop = "luxury_decor:simple_plastic_"..color.."_chandelier_off",
    light_source = 8,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.1, -0.3, 0.3, 0.5, 0.3},
            {-0.7, -0.65, -0.7, 0.7, -0.1, 0.7}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.1, -0.3, 0.3, 0.5, 0.3},
            {-0.7, -0.65, -0.7, 0.7, -0.1, 0.7}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        if string.find(itemstack:get_name(), "dye:") then
            local color_dye = string.sub(itemstack:get_name(), 5)
            minetest.set_node(pos, {name="luxury_decor:simple_plastic_"..color_dye.."_chandelier_on", param1=node.param1, param2=node.param2})
            itemstack:take_item()
        else
            minetest.remove_node(pos)
            minetest.set_node(pos, {name="luxury_decor:simple_plastic_"..color.."_chandelier_off", param2 = node.param2})
        end
        
    end
    
   }) 
    
   minetest.register_node("luxury_decor:plastic_"..color.."_desk_lamp_off", {
    description = "Plastic Desk Lamp (with ".. color .. " plastic shade)",
    visual_scale = 0.5,
    mesh = "plastic_desk_lamp.b3d",
    use_texture_alpha = true,
    tiles = {"plastic_desk_lamp.png^(plastic_desk_lamp_2_1.png^[colorize:"..rgb_code.."^plastic_desk_lamp_2.png)"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.6, 0.4}
            
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.6, 0.4}
            
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        if string.find(itemstack:get_name(), "dye:") then
            local color_dye = string.sub(itemstack:get_name(), 5)
            minetest.set_node(pos, {name="luxury_decor:plastic_"..color_dye.."_desk_lamp_off", param1=node.param1, param2=node.param2})
            itemstack:take_item()
        else
            minetest.remove_node(pos)
            minetest.set_node(pos, {name="luxury_decor:plastic_"..color.."_desk_lamp_on", param2 = node.param2})
        end
    end
    
   }) 
       
   minetest.register_node("luxury_decor:plastic_"..color.."_desk_lamp_on", {
    description = "Plastic Desk Lamp (with ".. color .. " plastic shades)",
    visual_scale = 0.5,
    mesh = "plastic_desk_lamp.b3d",
    use_texture_alpha = true,
    tiles = {"plastic_desk_lamp.png^(plastic_desk_lamp_2_1.png^[colorize:"..rgb_code.."^plastic_desk_lamp_2.png)"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    drop = "luxury_decor:plastic_"..color.."_desk_lamp_off",
    light_source = 9,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.6, 0.4}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.4, -0.5, -0.4, 0.4, 0.6, 0.4}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        if string.find(itemstack:get_name(), "dye:") then
            local color_dye = string.sub(itemstack:get_name(), 5)
            minetest.set_node(pos, {name="luxury_decor:plastic_"..color_dye.."_desk_lamp_on", param1=node.param1, param2=node.param2})
            itemstack:take_item()
        else
            minetest.remove_node(pos)
            minetest.set_node(pos, {name="luxury_decor:plastic_"..color.."_desk_lamp_off", param2 = node.param2})
        end
    end
    
   }) 
   minetest.register_craft({
        output = "luxury_decor:simple_plastic_"..color.."_chandelier_off",
        recipe = {
            {"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "luxury_decor:wooden_plank"},
            {"luxury_decor:plastic_sheet", "dye:"..color, "luxury_decor:lampshades"},
            {"luxury_decor:incandescent_bulbs", "", ""}
        }
   })
   
   minetest.register_craft({
        output = "luxury_decor:plastic_"..color.."_desk_lamp_off",
        recipe = {
            {"luxury_decor:plastic_sheet", "luxury_decor:brass_stick", "luxury_decor:brass_stick"},
            {"luxury_decor:plastic_sheet", "dye:"..color, "luxury_decor:lampshade"},
            {"luxury_decor:plastic_sheet", "luxury_decor:incandescent_bulb", ""}
        }
   })
end

minetest.register_node("luxury_decor:brass_candlestick", {
    description = "Brass Candlestick (with one candle)",
    visual_scale = 0.5,
    mesh = "brass_candlestick.b3d",
    --inventory_image = "brass_candlestick_inv.png",
    tiles = {{
            name = "brass_candlestick_animated.png",
            animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, lenght = 8}
    }},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 1.5},
    drawtype = "mesh",
    light_source = 10,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.15, -0.5, -0.15, 0.15, 0.7, 0.15}
            
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.15, -0.5, -0.15, 0.15, 0.7, 0.15}
        }
    },
    sounds = default.node_sound_wood_defaults()
    
}) 

minetest.register_node("luxury_decor:brass_candlestick_with_three_candles", {
    description = "Brass Candlestick (with three candles)",
    visual_scale = 0.5,
    mesh = "brass_candlestick_with_three_candles.b3d",
    --inventory_image = "brass_candlestick_inv.png",
    tiles = {{
            name = "brass_candlestick_animated.png",
            animation = {type = "vertical_frames", aspect_w = 32, aspect_h = 32, lenght = 8}
    }},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 1.8},
    drawtype = "mesh",
    light_source = 12,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.45, -0.5, -0.15, 0.45, 0.7, 0.15}
            
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.45, -0.5, -0.15, 0.45, 0.7, 0.15}
        }
    },
    sounds = default.node_sound_wood_defaults()
    
}) 

minetest.register_node("luxury_decor:ceiling_lantern", {
    description = "Ceiling Lantern",
    visual_scale = 0.5,
    mesh = "ceiling_lantern.b3d",
    use_texture_alpha = true,
    --inventory_image = "luxury_steel_chandelier_inv.png",
    tiles = {"street_lantern.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1.5},
    drawtype = "mesh",
    light_source = 12,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.2, -0.8, -0.2, 0.2, 0.5, 0.2},
            {-0.5, -2.4, -0.5, 0.5, -0.8, 0.5}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.2, -0.8, -0.2, 0.2, 0.5, 0.2},
            {-0.5, -2.4, -0.5, 0.5, -0.8, 0.5}
        }
    },
    sounds = default.node_sound_leaves_defaults()
}) 

minetest.register_node("luxury_decor:wall_lantern", {
    description = "Wall Lantern",
    visual_scale = 0.5,
    mesh = "wall_lantern.b3d",
    use_texture_alpha = true,
    --inventory_image = "luxury_steel_chandelier_inv.png",
    tiles = {"street_lantern.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy = 1.5},
    drawtype = "mesh",
    light_source = 12,
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -1, 0.5, 0.7, -0.1},
            {-0.5, 0.7, -1, 0.5, 1.4, 0.5}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -1, 0.5, 0.7, -0.1},
            {-0.5, 0.7, -1, 0.5, 1.4, 0.5}
        }
    },
    sounds = default.node_sound_leaves_defaults()
}) 


minetest.register_craft({
    output = "luxury_decor:iron_chandelier",
    recipe = {
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
        {"default:steel_ingot", "default:steel_ingot", "dye:grey"},
        {"luxury_decor:wax_lump", "luxury_decor:wax_lump", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:luxury_desk_lamp_off",
    recipe = {
        {"luxury_decor:jungle_wooden_plank", "luxury_decor:lampshade", ""},
        {"luxury_decor:jungle_wooden_plank", "luxury_decor:incandescent_bulb", ""},
        {"luxury_decor:jungle_wooden_plank", "luxury_decor:brass_ingot", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:wall_glass_lamp_off",
    recipe = {
        {"default:glass", "default:glass", ""},
        {"luxury_decor:brass_ingot", "dye:orange", ""},
        {"luxury_decor:incandescent_bulb", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:royal_brass_chandelier_off",
    recipe = {
        {"luxury_decor:brass_ingot", "luxury_decor:brass_ingot", "luxury_decor:brass_ingot"},
        {"luxury_decor:brass_ingot", "luxury_decor:lampshades", "default:glass"},
        {"dye:yellow", "luxury_decor:incandescent_bulbs", "default:gold_ingot"}
    }
})

minetest.register_craft({
    output = "luxury_decor:luxury_steel_chandelier_off",
    recipe = {
        {"default:steel_ingot", "default:glass", "luxury_decor:brass_ingot"},
        {"default:steel_ingot", "default:steel_ingot", "default:glass"},
        {"luxury_decor:incandescent_bulbs", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:brass_candlestick",
    recipe = {
        {"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:wax_lump"},
        {"luxury_decor:brass_stick", "", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:brass_candlestick_with_three_candles",
    recipe = {
        {"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:wax_lump"},
        {"luxury_decor:brass_stick", "luxury_decor:wax_lump", "luxury_decor:brass_stick"},
        {"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:wax_lump"}
    }
})

minetest.register_craft({
    output = "luxury_decor:ceiling_lantern",
    recipe = {
        {"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "luxury_decor:brass_stick"},
        {"xpanes:pane_flat", "xpanes:pane_flat", "luxury_decor:incandescent_bulb"},
        {"default:diamond", "luxury_decor:zinc_ingot", "dye:black"}
    }
})

minetest.register_craft({
    output = "luxury_decor:wall_lantern",
    recipe = {
        {"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "xpanes:pane_flat"},
        {"luxury_decor:plastic_sheet", "xpanes:pane_flat", "luxury_decor:incandescent_bulb"},
        {"default:diamond", "dye:black", ""}
    }
})
