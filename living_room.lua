dofile(minetest.get_modpath("luxury_decor") .. "/chairs.lua")

local flowers_list = {
    name = {"rose", "tulip_black", "tulip", "geranium"},
    desc = {"Rose", "Tulip Black", "Tulip", "Geranium"}
}

minetest.register_node("luxury_decor:glass_vase", {
    description = "Glass Vase",
    visual_scale = 0.5,
    mesh = "glass_vase.b3d",
    tiles = {"glass_vase.png"},
    use_texture_alpha = true,
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 1.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2}
        }
    },
    sounds = default.node_sound_glass_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        for _, flower in ipairs(flowers_list.name) do
            if "flowers:" .. flower == itemstack:get_name() then
                minetest.remove_node(pos)
                minetest.set_node(pos, {name="luxury_decor:glass_vase_with_"..flower})
            end
        end
    end
})

--[[function set_x_or_y_for_pos(player, node, value, y)    -- Finish writing!!!
    local signs = {
        ["z"] = "0",
        ["x"], = "1",
        ["-z"], = "2",
        ["-x"] = "3"
    }
    
    local new_pos = {x=nil, y=y, z=nil}
    for val, sign in pairs(signs) do
        if value == sign then
            new_pos[tonumber(string.gmatch(val, string.find(val, "-") or "") or val)] = ]]
    
for ind, f in pairs(flowers_list.name) do
    minetest.register_node("luxury_decor:glass_vase_with_"..f, {
        description = "Glass Vase With " .. flowers_list.desc[ind],
        visual_scale = 0.5,
        mesh = "glass_vase.b3d",
        tiles = {"glass_vase.png^flowers_"..f..".png"},
        use_texture_alpha = true,
        paramtype = "light",
        paramtype2 = "facedir",
        drop = {"luxury_decor:glass_vase", "luxury_decor:glass_vase_with_"..f},
        groups = {choppy = 1.5},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.2, -0.5, -0.2, 0.2, 0.5, 0.2}
            }
        },
        sounds = default.node_sound_glass_defaults(),
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            for _, flower in ipairs(flowers_list.name) do
                if "flowers:" .. flower == itemstack:get_name() then
                    minetest.remove_node(pos)
                    minetest.set_node(pos, {name="luxury_decor:glass_vase_with_"..flower})
                    itemstack:add_item("luxury_decor:glass_vase")
                    itemstack:add_item("flowers:" .. string.sub(node.name, 29))
                    return itemstack
                end
            end
            
            minetest.remove_node(pos)
            minetest.set_node(pos, {name="luxury_decor:glass_vase"})
            
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
    ["grey"] = "#C0C0C0",
    ["brown"] = "#A52A2A",
    ["orange"] = "#FF4500",
    ["pink"] = "#F08080",
    ["violet"] = "#4B0082"
}

local sofas_collision_boxes = {
    ["1"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
        
    },
    ["2"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    ["3"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    ["4"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    }
    ["5"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    }
}



local footstools_collision_boxes = {
    ["small"] = {{-0.3, -0.5, -0.3, 0.3, 0.2, 0.3}},
    ["middle"] = {{-0.3, -0.5, -0.3, 1.1, 0.2, 0.3}},
    ["long"] = {{-0.3, -0.5, -0.3, 1.8, 0.2, 0.3}}
}
    
sofas = {}
sofas.connect_sofas = function (player, node1, node2)
    local name1 = node1.name
    local new_name1 = string.sub(name1, 21, "_")
    local node2 = string.sub(node2, 21, "_")
    if new_name1 == node2 then
        local dir = player:get_look_dir()
        local new_pos = node1.pos
        for axis, num in pairs(dir) do
            if num < 0 then
                new_pos[axis] = node1.pos[axis] - 1
                minetest.set_node(new_pos, {name=node2, param1 = node1.param1, param2 = node2.param2})
                return true
            elseif num > 0 then
                new_pos[axis] = node1.pos[axis] + 1
                minetest.set_node(new_pos, {name=node2, param1 = node1.param1, param2 = node2.param2})
                return true
            end
        end
    else
        return
    end
end
                
                
        --[[if string.find(name1, "_4") then
            local dir = node1.param2
            if dir.x ~= 0 then
                minetest.set_node(node2, {x=node1.pos.x, y=pos})]]
        

for color, rgb_color in pairs(sofas_rgb_colors) do
    for _, pillow_color in ipairs({"red", "green" , "blue", "yellow", "violet"}) do
        minetest.register_node("luxury_decor:simple_" .. color .. "_armchair_with_" .. pillow_color .. "_pillow", {
            description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " Armchair With " .. string.upper(pillow_color) .. " Pillow" ),
            visual_scale = 0.5,
            mesh = "simple_armchair.obj",
            tiles = {"simple_sofa.png^(simple_sofa_2.png^[colorize:" .. rgb_code .. ")^(simple_sofa_3.png^[colorize:" .. pillow_color .. ")"},
            paramtype = "light",
            paramtype2 = "facedir",
            groups = {choppy = 2.5},
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
            on_construct = function (pos)
                local meta = minetest.get_meta(pos)
                meta:set_string("seats_range", minetest.serialize({[1] = {is_busy={bool=false, player=nil}, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}}}))
            end,
            on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                    if string.find(itemstack:get_name(), "dye:") then
                        local get_player_contr = clicker:get_player_control()
                        
                        if get_player_contr.sneak then
                            for _, p_color in ipairs({"red", "green", "blue", "yellow", "violet"}) do
                                if itemstack:get_name() == "dye:" .. p_color then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                    minetest.set_node(pos, {name="luxury_decor:simple_" .. color .. "_" .. sofa_count .. "_sofa_with_" .. p_color .. "_pillow"})
                                end
                            end
                        else
                            for color2, rgb_code in pairs(sofas_rgb_colors) do
                                if "dye:" .. color2 == itemstack:get_name() then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                   minetest.set_node(pos, {name="luxury_decor:simple_" .. color2 .. "_" .. sofa_count .. "_sofa_with_" .. pillow_color .. "_pillow"})
                                end
                            end
                        end
                    else
			            local meta = clicker:get_meta()
                        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
                        if is_attached == nil or is_attached == "" then
                            chairs.sit_player(clicker, node, pos, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
                            chairs.set_look_dir(clicker)
                        
                        elseif is_attached ~= nil or is_attached ~= "" then
                            chairs.standup_player(clicker, pos)
             
                        end
                    end
                    return itemstack
                end
        })
    end
end

for ind, sofa_count in pairs({"1", "2", "3", "4", "5"}) do
    for color, rgb_color in pairs(sofas_rgb_colors) do
        for _, pillow_color in ipairs({"red", "green" , "blue", "yellow", "violet"}) do
        minetest.register_node("luxury_decor:simple_".. color .. "_" .. sofa_count .. "_sofa_with_" .. pillow_color .. "_pillow", {
                description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " Sofa With " .. string.upper(pillow_color) .. " Pillow" ),
                visual_scale = 0.5,
                mesh = "simple_sofa_" .. sofa_count .. ".obj",
                tiles = {"simple_sofa.png^(simple_sofa_2.png^[colorize:" .. rgb_code .. ")^(simple_sofa_3.png^[colorize:" .. pillow_color .. ")"},
                paramtype = "light",
                paramtype2 = "facedir",
                groups = {choppy = 2.5},
                drawtype = "mesh",
                collision_box = {
                    type = "fixed",
                    fixed = sofas_collision_boxes[sofa_count]
                },
                selection_box = {
                    type = "fixed",
                    fixed = sofas_collision_boxes[sofa_count]
                },
                sounds = default.node_sound_wood_defaults(),
		        on_construct = function (pos)
                    local meta = minetest.get_meta(pos)
                    meta:set_string("seats_range", minetest.serialize({[1] = {is_busy={bool=false, player=nil}, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}}}))
                end,
                after_dig_node = function (pos, oldnode, oldmetadata, digger)
                    local seats = minetest.deserialize(oldmetadata.fields.seats_range)
                    if seats ~= nil then
                       for seat_num, seat_data in pairs(seats) do
                           if seat_data.is_busy.player ~= nil then
                              local player = minetest.get_player_by_name(seat_data.is_busy.player)
                              chairs.standup_player(player, pos, seats)
                           end
                       end
                    end
                end,
                on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                    if string.find(itemstack:get_name(), "dye:") then
                        local get_player_contr = clicker:get_player_control()
                        
                        if get_player_contr.sneak then
                            for _, p_color in ipairs({"red", "green", "blue", "yellow", "violet"}) do
                                if itemstack:get_name() == "dye:" .. p_color then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                    minetest.set_node(pos, {name="luxury_decor:simple_" .. color .. "_" .. sofa_count .. "_sofa_with_" .. p_color .. "_pillow"})
                                end
                            end
                        else
                            for color2, rgb_code in pairs(sofas_rgb_colors) do
                                if "dye:" .. color2 == itemstack:get_name() then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                   minetest.set_node(pos, {name="luxury_decor:simple_" .. color2 .. "_" .. sofa_count .. "_sofa_with_" .. pillow_color .. "_pillow"})
                                end
                            end
                        end
                    elseif string.find(itemstack:get_name(), "simple_sofa_") then
                        sofas.connect_sofas({name=node.name, param1=node.param1, param2=node.param2, pos=pos}, itemstack:get_name())
                    else
			            local meta = clicker:get_meta()
                        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
                        if is_attached == nil or is_attached == "" then
                            chairs.sit_player(clicker, node, pos, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
                            chairs.set_look_dir(clicker)
                        
                        elseif is_attached ~= nil or is_attached ~= "" then
                            chairs.standup_player(clicker, pos)
             
                        end
                    end
                    return itemstack
                end
        end
        end
    end
end
            
for ind, sofa_type in pairs({"small", "middle", "long", "corner_1", "corner_2"}) do
    for color, rgb_code in pairs(sofas_rgb_colors) do
        for _, pillow_color in ipairs({"red", "green" , "blue", "yellow", "violet"}) do
            minetest.register_node("luxury_decor:simple_".. color .. "_" .. sofa_type .. "_sofa_with_" .. pillow_color .. "_pillows", {
                description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " " .. string.upper(sofa_type) .. " Sofa With " .. string.upper(pillow_color) .. " Pillows" ),
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
		on_construct = function (pos)
		    local meta = minetest.get_meta(pos)
		    
		    local seats_table = {
                {["small"] = 
                    {[1]=
                        {
                            is_busy = {bool=false, player=nil}, 
                            pos = {x = pos.x, y=pos.y+0.2, z = pos.z}
                        }
                    }
                },
                {["middle"] = 
                    {[1]=
                        {
                            is_busy={bool=false, player=nil}, 
                            pos={x = pos.x, y = pos.y+0.2, z = pos.z}
                        }, 
                     [2]=
                        {
                            is_busy={bool=false, player=nil}, 
                            pos={x=pos.x+1, y=pos.y+0.2, z=pos.z}
                        }
                    }
                },
			{["long"] = {[1]={is_busy={bool=false, player_obj=nil}, pos={x=pos.x, y=pos.y+0.2, z=pos.z}}, 
			[2]={is_busy={bool=false, player=nil}, pos={x=pos.x+1, y=pos.y+0.2, z=pos.z}}, 
			[3]={is_busy={bool=false, player=nil}, pos={x=pos.x+2, y=pos.y+0.2, z=pos.z}}}},
			{["corner_1"] = {[1]={is_busy={bool=false, player=nil}, pos={x=pos.x, y=pos.y+0.2, z=pos.z}}, 
			[2]={is_busy={bool=false, player=nil}, pos={x=pos.x+1, y=pos.y+0.2, z=pos.z}}, 
			[3]={is_busy={bool=false, player=nil}, pos={x=pos.x+2, y=pos.y+0.2, z=pos.z}},
		        [4]={is_busy={bool=false, player=nil}, pos={x=pos.x+2, y=pos.y+0.2, z=pos.z-1}}}},
			{["corner_2"] = {[1]={is_busy={bool=false, player=nil}, pos={x=pos.x, y=pos.y+0.2, z=pos.z-1}}, 
			[2]={is_busy={bool=false, player=nil}, pos={x=pos.x, y=pos.y+0.2, z=pos.z}}, 
			[3]={is_busy={bool=false, player=nil}, pos={x=pos.x+1, y=pos.y+0.2, z=pos.z}},
		        [4]={is_busy={bool=false, player=nil}, pos={x=pos.x+2, y=pos.y+0.2, z=pos.z}}}}
		    
		    }
		    
            for num, data in pairs(seats_table) do
                for sf_type, sf_data in pairs(seats_table[num]) do
                    if minetest.get_node(pos).name == "luxury_decor:simple_" .. color .. "_" .. sf_type .. "_sofa_with_" .. pillow_color .. "_pillows" then
                        meta:set_string("seats_range", minetest.serialize(sf_data))
                    end
		        end
            end    
                
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            --local seats = minetest.deserialize(minetest.get_meta(pos):get_string("seats_range"))
            local seats = minetest.deserialize(oldmetadata.fields.seats_range)
            if seats ~= nil then
                for seat_num, seat_data in pairs(seats) do
                    if seat_data.is_busy.player ~= nil then
                        local player = minetest.get_player_by_name(seat_data.is_busy.player)
                        chairs.standup_player(player, pos, seats)
                    end
                end
            end
        end,
                on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                    if string.find(itemstack:get_name(), "dye:") then
                        local get_player_contr = clicker:get_player_control()
                        
                        if get_player_contr.sneak then
                            for _, p_color in ipairs({"red", "green", "blue", "yellow", "violet"}) do
                                if itemstack:get_name() == "dye:" .. p_color then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                    minetest.set_node(pos, {name="luxury_decor:simple_" .. color .. "_" .. sofa_type .. "_sofa_with_" .. p_color .. "_pillows"})
                                end
                            end
                        else
                            for color2, rgb_code in pairs(sofas_rgb_colors) do
                                if "dye:" .. color2 == itemstack:get_name() then
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                   minetest.set_node(pos, {name="luxury_decor:simple_" .. color2 .. "_" .. sofa_type .. "_sofa_with_" .. pillow_color .. "_pillows"})
                                end
                            end
                        end
                        
                    elseif string.find(itemstack:get_name(), "luxury_decor:simple_" .. color .. "_small_sofa_with_" .. pillow_color .. "_pillows") then
                        local dir = clicker:get_look_dir()
                        local player_pos = clicker:get_pos()
                        if pointed_thing.under.x ~= pointed_thing.above.x and string.find(node.name, "_long_") == nil then
                            local sofas_types_list = {"small", "middle", "long"}
                            if dir.x > 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows"})
                            elseif dir.x < 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows"})
                            
                            end
                        --[[elseif pointed_thing.under.x > pointed_thing.above.x and string.find(node.name, "_long_") == nil then
                            local sofas_types_list = {"small", "middle", "long"}
                            if dir.x < 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows"})
                            elseif dir.x > 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows"})
                            
                            end]]
                        elseif pointed_thing.above.z ~= pointed_thing.under.z and player_pos.z < pos.z and string.find(node.name, "_long_") ~= nil then
                            if dir.x > 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x-3, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_corner1_sofa_with_" .. pillow_color .. "_pillows"})
                            elseif dir.x < 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node(pos, {name="luxury_decor:simple_" .. color .. "_corner2_sofa_with_" .. pillow_color .. "_pillows"})
                            end
                        --elseif pointed_thing.under.x > pointed_thing.above.x and dir.y > 0 and string.find(node.name, "_long_") == nil then
                            --itemstack:take_item()
                            --minetest.remove_node(pos)
                            --minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                        --elseif pointed_thing.under.y > pointed_thing.above.y and dir.y > 0 and string.find(node.name, "_long_") == nil then
                            --itemstack:take_item()
                            --minetest.remove_node(pos)
                            --minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                       -- elseif pointed_thing.under.y < pointed_thing.above.y and dir.y < 0 and string.find(node.name, "_long_") == nil then
                            --itemstack:take_item()
                            --minetest.remove_node(pos)
                            --minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                    
                        end
                        
                    else
			            local meta = clicker:get_meta()
                        local is_attached = minetest.deserialize(meta:get_string("is_attached"))
                        if is_attached == nil or is_attached == "" then
                            chairs.sit_player(clicker, node, pos, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
                        
                        elseif is_attached ~= nil or is_attached ~= "" then
                            chairs.standup_player(clicker, pos)
             
                        end
                    end
                    return itemstack
                end
            })
        end
    end
end
            
        
for ind, footstool_type in pairs({"small", "middle", "long"}) do
    for color, rgb_code in pairs(sofas_rgb_colors) do
        minetest.register_node("luxury_decor:simple_" .. color .. "_" .. footstool_type .. "_footstool", {
            description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " " .. string.upper(footstool_type) .. " Footstool"),
            visual_scale = 0.5,
            mesh = "simple_"..footstool_type.."_footstool.obj",
            tiles = {"simple_sofa.png^(simple_sofa_2.png^[colorize:" .. rgb_code .. ")"},
            paramtype = "light",
            paramtype2 = "facedir",
            groups = {choppy = 2},
            drawtype = "mesh",
            collision_box = {
                type = "fixed",
                fixed = footstools_collision_boxes[footstool_type]
            },
            selection_box = {
                type = "fixed",
                fixed = footstools_collision_boxes[footstool_type]
            },
            sounds = default.node_sound_wood_defaults(),
            on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                if string.find(itemstack:get_name(), "dye:") then
                    local get_player_contr = clicker:get_player_control()
                        
                    
                    for color2, rgb_code in pairs(sofas_rgb_colors) do
                        if "dye:" .. color2 == itemstack:get_name() then
                            itemstack:take_item()
                            minetest.remove_node(pos)
                            minetest.set_node(pos, {name="luxury_decor:simple_" .. color2 .. "_" .. footstool_type .. "_footstool"})
                        end
                    end
                    
                        
                elseif string.find(itemstack:get_name(), "luxury_decor:simple_" .. color .. "_small_footstool") then
                    local dir = clicker:get_look_dir()
                    local footstools_types_list = {"small", "middle", "long"}
                    if pointed_thing.under.x < pointed_thing.above.x and dir.x < 0 and string.find(node.name, "_long_") == nil then
                        itemstack:take_item()
                        minetest.remove_node(pos)
                        minetest.set_node({x=pos.x+1, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                    elseif pointed_thing.under.x > pointed_thing.above.x and dir.x > 0 and string.find(node.name, "_long_") == nil then
                        itemstack:take_item()
                        minetest.remove_node(pos)
                        minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                    
                    elseif pointed_thing.under.y > pointed_thing.above.y and dir.y > 0 and string.find(node.name, "_long_") == nil then
                        itemstack:take_item()
                        minetest.remove_node(pos)
                        minetest.set_node({x=pos.x, y=pos.y, z=pos.z-1}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                    elseif pointed_thing.under.y < pointed_thing.above.y and dir.y > 0 and string.find(node.name, "_long_") == nil then
                        itemstack:take_item()
                        minetest.remove_node(pos)
                        minetest.set_node({x=pos.x, y=pos.y, z=pos.z+1}, {name="luxury_decor:simple_" .. color .. "_" .. footstools_types_list[ind+1] .. "_footstool"})
                    
                    end
                end
            end
        })
    end
end

minetest.register_node("luxury_decor:simple_wooden_wall_clock", {
    description = "Simple Wooden Wall Clock",
    visual_scale = 0.5,
    mesh = "simple_wooden_wall_clock.obj",
    tiles = {{
        name = "simple_wooden_wall_clock_animated.png",
        animation = {type = "vertical_frames", aspect_w = 64, aspect_h = 64, lenght = 40.0}
    }},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 2},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, 0.1, 0.3, 0.4, 0.5},
            --[[{-0.65, -0.3, -1.46, 0.65, 1.4, -1.66},
            {-0.65, -0.3, 0.46, 0.65, 1.4, 0.66}]]
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.3, -0.5, 0.15, 0.3, 0.35, 0.5}
        }
    },
    sounds = default.node_sound_wood_defaults()
})
                            
                        
                                
                        
                


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
	    
