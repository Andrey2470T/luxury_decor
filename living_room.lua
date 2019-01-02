local flowers_list = {
    name = {"rose", "tulip_black", "tulip", "geranium"},
    desc = {"Rose", "Tulip Black", "Tulip", "Geranium"}
}

minetest.register_node("luxury_decor:glass_vase", {
    description = "Glass Vase",
    visual_scale = 0.5,
    mesh = "glass_vase.obj",
    tiles = {"glass_vase.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 1.5},
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
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        for _, flower in ipairs(flowers_list.name) do
            if "flowers:" .. flower == node.name then
                minetest.remove_node(pos)
                minetest.set_node(pos, "luxury_decor:glass_vase_with_"..flower)
            end
        end
    end
})

for ind, f in ipairs(flowers_list.name) do
    minetest.register_node("luxury_decor:glass_vase_with_"..f, {
        description = "Glass Vase With " .. flowers_list.desc[ind],
        visual_scale = 0.5,
        mesh = "glass_vase.obj",
        tiles = {"glass_vase.png^flowers_"..f..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = {"luxury_decor:glass_vase", "luxury_decor:glass_vase_with_"..f},
        groups = {choppy = 1.5},
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
        sounds = default.node_sound_glass_defaults(),
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            minetest.remove_node(pos)
            minetest.set_node(pos, "luxury_decor:glass_vase")
            
            itemstack:add_item("flowers:" .. string.sub(node.name, 29))
        end
    })
end

local sofas_rgb_colors = {
    ["black"] = "#000000",
    ["red"] = "#FF0000",
    ["green"] = "#00FF00",
    ["white"] = "#FFFFFF",
    ["blue"] = "#0000FF",
    ["yellow"] = "#FFFF00",
    ["magenta"] = "#FF00FF",
    ["cyan"] = "#00FFFF",
    ["dark_green"] = "#008000",
    ["dark_grey"] = "#808080",
    ["grey"] = "#COCOCO",
    ["brown"] = "#A52A2A",
    ["orange"] = "#FF4500",
    ["pink"] = "#F08080",
    ["violet"] = "#4B0082"
}

local sofas_collision_boxes = {
    ["small"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
    },
    ["middle"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
    },
    ["long"] = {
        {-0.5, -0.5, -0.5, 2.5, 0.5, 0.5}
    },
    ["corner1"] = {
        {-0.5, -0.5, -0.5, 2.5, 0.5, 0.5},
        {-0.5, -0.5, -1.5, 0.5, 0.5, -0.5}
    },
    ["corner2"] = {
        {-0.5, -0.5, -0.5, 2.5, 0.5, 0.5},
        {1.5, -0.5, -1.5, 2.5, 0.5, 0.5}
    }
}

for ind, sofa_type in pairs({"small", "middle", "long", "corner1", "corner2"}) do
    for color, rgb_code in pairs(sofas_rgb_colors) do
        for _, pillow_color in ipairs({"red", "green" , "blue", "yellow", "violet"}) do
            minetest.register_node("luxury_decor:simple_".. color .. "_" .. sofa_type .. "_sofa_with_" .. pillow_color .. "_pillows", {
                description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " " .. string.upper(sofa_type) .. " Sofa"),
                visual_scale = 0.5,
                mesh = "simple_"..sofa_type.."_sofa.obj",
                tiles = {"simple_sofa.png^(simple_sofa_2.png^[colorize:" .. rgb_code .. ")^(simple_sofa_3.png^[colorize:" .. pillow_color .. ")"},
                paramtype = "light",
                paramtype2 = "facedir",
                groups = {choppy = 2.5},
                drawtype = "mesh",
                collision_box = {
                    type = "fixed",
                    fixed = sofas_collision_boxes[sofa_type]
                },
                selection_box = {
                    type = "fixed",
                    fixed = sofas_collision_boxes[sofa_type]
                },
                sounds = default.node_sound_wood_defaults(),
                on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                    if string.find(itemstack:get_name(), "dye:") then
                        local get_player_contr = clicker:get_player_control()
                        
                        if get_player_contr.sneak then
                            for _, p_color in ipairs({"red", "green", "blue", "yellow", "violet"}) do
                                if itemstack:get_name() == "dye:" .. p_color then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                    minetest.set_node(pos, "luxury_decor:simple_" .. color .. "_" .. sofa_type .. "_sofa_with_" .. p_color .. "_pillows")
                                end
                            end
                        else
                            for color2, rgb_code in pairs(sofas_rgb_colors) do
                                if "dye:" .. color2 == itemstack:get_name() then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                   minetest.set_node(pos, "luxury_decor:simple_" .. color2 .. "_" .. sofa_type .. "_sofa_with_" .. pillow_color .. "_pillows")
                                end
                            end
                        end
                        
                    elseif string.find(itemstack:get_name(), "luxury_decor:simple_" .. color .. "_small_sofa_with_" .. pillow_color .. "_pillows") then
                        local pos2 = clicker:get_pos()
                        if pointed_thing.above.x ~= pointed_thing.under.x and pos2.x ~= pos.x and string.find(node.name, "_long_") == nil then
                            local sofas_types_list = {"small", "middle", "long"}
                            
                            itemstack:take_item()
                            minetest.remove_node(pos)
                            minetest.set_node(pos, "luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows")
                            
                        elseif pointed_thing.above.z ~= pointed_thing.under.z and string.find(node.name, "_long_") ~= nil then
                            local dir = clicker:get_look_dir()
                            if dir.x > 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node(pos, "luxury_decor:simple_" .. color .. "_corner1_sofa_with_" .. pillow_color .. "_pillows")
                            elseif dir.x < 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node(pos, "luxury_decor:simple_" .. color .. "_corner2_sofa_with_" .. pillow_color .. "_pillows")
                            end
                        end
                    else
                    end
                    return itemstack
                end
            })
        end
    end
end
            
        
    

                        
                            
                        
                                
                        
                


--[[for _, color in ipairs(sofas_rgb_colors) do
    if color == "red" or color == "green" or color == "blue" or color == "yellow" or color == "violet" then
	for _, sofa_type in ipairs({"small", "middle", "long", "corner1", "corner2"}) do
	    for _, pillow_color in ipairs({"red", "green", "blue", "yellow", "violet"}) do
		minetest.register_node("luxury_decor:simple_".. color .. "_" .. sofa_type .. "_sofa", {
		     description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " " .. string.upper(sofa_type) .. " Sofa",
		     visual_scale = 0.5,
		     mesh = "simple_"..sofa_type.."_sofa.obj",
		     tiles = {""})
		     })]]
	    
