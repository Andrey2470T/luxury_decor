dofile(minetest.get_modpath("luxury_decor") .. "/chairs.lua")

local flowers_list = {
    name = {"rose", "tulip_black", "tulip", "geranium"},
    desc = {"Rose", "Tulip Black", "Tulip", "Geranium"}
}

minetest.register_node("luxury_decor:glass_vase", {
    description = "Glass Vase",
    visual_scale = 0.5,
    drawtype = "mesh",
    mesh = "glass_vase1.b3d",
    use_texture_alpha = true,
    tiles = {"glass_vase.png"},
    inventory_image = "glass_vase_inv.png",
    sunlight_propagates = true,
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 1.5},
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
        inventory_image = "glass_vase_inv.png",
        mesh = "glass_vase1.b3d",
        tiles = {"glass_vase.png^flowers_"..f..".png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = {"luxury_decor:glass_vase", "luxury_decor:glass_vase_with_"..f},
        groups = {choppy = 1.5, not_in_creative_inventory=1},
        use_texture_alpha = true,
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
                    itemstack:add_item("flowers:" .. string.sub(node.name, 30))
                    return itemstack
                end
            end
            
            minetest.remove_node(pos)
            minetest.set_node(pos, {name="luxury_decor:glass_vase"})
            
            itemstack:add_item("flowers:" .. string.sub(node.name, 30))
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
        {-0.34, -0.5, -0.4, 0.34, 0.05, 0.35}, -- Lower box
        {-0.34, -0.5, 0.35, 0.34, 0.55, 0.49}, -- Back box
        {-0.34, -0.5, -0.5, -0.51, 0.2, 0.49}, -- Right box
        {0.34, -0.5, -0.5, 0.51, 0.2, 0.49} -- Left box
        
    },
    ["2"] = {
        {-0.34, -0.5, -0.5, 0.51, 0.05, 0.35},
        {-0.34, -0.5, 0.35, 0.51, 0.55, 0.49},
        {-0.34, -0.5, -0.5, -0.51, 0.2, 0.49}
    },
    ["3"] = {
        {-0.51, -0.5, -0.5, 0.34, 0.05, 0.35},
        {-0.51, -0.5, 0.35, 0.34, 0.55, 0.49},
        {0.34, -0.5, -0.5, 0.51, 0.2, 0.49}
    },
    ["4"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    ["5"] = {
        {-0.48, -0.5, -0.5, 0.51, 0.05, 0.35},
        {-0.48, -0.5, 0.35, 0.51, 0.55, 0.49},
    }
}



local footstools_collision_boxes = {
    ["small"] = {{-0.35, -0.5, -0.35, 0.35, 0.05, 0.35}},
    ["middle"] = {{-0.35, -0.5, 0.23, 0.35, 0.05, -1.23}},
    ["long"] = {{-0.35, -0.5, 0.1, 0.35, 0.05, -2.1}}
}


function is_same_nums_sign(num1, num2)
    if num1 < 0 and num2 < 0 or num1 > 0 and num2 > 0 then
        return true
    else
        return false
    end
end

--"node1" contains: {name, param1, param2, pointed_thing, pos}
sofas = {}

sofas.define_needed_sofa_part = function (player, sofa, sofa2, replace_sofa1, replace_sofa2, pos, pointed_thing)
    local ordered_axises_table = {"-x", "-z", "x", "z"}
    pointed_axis = nil
    node_vector = nil
    local surface_pos = minetest.pointed_thing_to_face_pos(player, pointed_thing)
   
    for axis, val in pairs(pointed_thing.above) do
        if pointed_thing.under[axis] ~= val then
            if surface_pos[axis] < pos[axis] then
                pointed_axis = "-" .. tostring(axis)
            elseif surface_pos[axis] > pos[axis] then
                pointed_axis = tostring(axis)
            
            end
        end
    end
    
    for axis2, vector in pairs(minetest.facedir_to_dir(sofa.param2)) do
        if vector ~= 0 then
            if vector < 0 then
                node_vector = "-" .. tostring(axis2)
            elseif vector > 0 then
                node_vector = tostring(axis2)
            end
        end
    end
    
    
    for num, axis in pairs(ordered_axises_table) do
        if axis == node_vector then
            node_vector_ind = num
        end
    end
    
    for num, axis in pairs(ordered_axises_table) do
        if axis == pointed_axis then
            pointed_axis_ind = num
        end
    end
                
    if pointed_axis_ind > node_vector_ind then
        if pointed_axis == "z" and node_vector == "-x" then
            return {replace_sofa1, replace_sofa2}
        end
        
        return {replace_sofa2, replace_sofa1}
    elseif pointed_axis_ind < node_vector_ind then
        if pointed_axis == "-x" and node_vector == "z" then
            return {replace_sofa2, replace_sofa1}
        end
        
        return {replace_sofa1, replace_sofa2}
    end
end
            
sofas.define_needed_sofa_pos = function (player, sofa, pointed_thing, pos)
    local surface_pos = minetest.pointed_thing_to_face_pos(player, pointed_thing)
    local new_pos = {x=sofa.pos.x, y=sofa.pos.y, z=sofa.pos.z}
    for axis, val in pairs(pointed_thing.above) do
        if val ~= pointed_thing.under[axis] then
            if surface_pos[axis] < sofa.pos[axis] then
                new_pos[axis] = new_pos[axis] - 1
                return new_pos
            elseif surface_pos[axis] > sofa.pos[axis] then
                new_pos[axis] = new_pos[axis] + 1
                return new_pos
            end
        end
    end
end

sofas.define_sidelong_axises = function (axis)
    local ordered_axles = {"-x", "-z", "x", "z"}
    local axis1
    local axis2
    for num, axle in pairs(ordered_axles) do
        if axle == axis then
            if num == 1 then
                axis1 = ordered_axles[#ordered_axles]
                axis2 = ordered_axles[num+1]
            elseif num == #ordered_axles then
                axis1 = ordered_axles[num-1]
                axis2 = ordered_axles[1]
            else
                axis1 = ordered_axles[num-1]
                axis2 = ordered_axles[num+1]
            end
        end
    end
    
    return {[1]=axis1, [2]=axis2}
end

sofas.translate_str_vector_to_table = function (str_axis)
    local vector_table = {x=0, y=0, z=0}
    local axis2 = string.sub(str_axis, -1, -1)
    if string.sub(str_axis, 1, 1) == "-" then
        vector_table[axis2] = -1
    else
        vector_table[axis2] = 1
    end
    
    return vector_table
end

sofas.translate_vector_table_to_str = function (vector_table)
    local str_axis
    for axis, val in pairs(vector_table) do
        if val ~= 0 then
            if val < 0 then
                str_axis = "-" .. axis
            else
                str_axis = tostring(axis)
            end
        end
    end
    
    return str_axis
end
    
sofas.connect_sofas = function (player, node1, node2, pos, pointed_thing)
    local node_color1 = string.sub(node1.name, 22, -6)
    local node_color2 = string.sub(node2, 22, -6)
    local surface_pos = minetest.pointed_thing_to_face_pos(player, pointed_thing)
    local used_pt_axis
    local node_vector
    -- Определяет ось, по которой грань была кликнута
    for axis, val in pairs(pointed_thing.above) do
        if val ~= pointed_thing.under[axis] and axis ~= y then
            used_pt_axis = {axis=axis, val=surface_pos[axis]}
        end
    end
    
    for axis, vector in pairs(minetest.facedir_to_dir(node1.param2)) do
        if vector ~= 0 then
            node_vector = {axis=axis, vector=vector}
        end
    end
    
    -- Проверяет, цвет подушки у new_name1 такой же, как и у node2
    if node_color1 == node_color2 then
        -- Проверяет, node2 - полный ли диван, затем находит от позиции кликнутого дивана в радиусе 1 другие диваны
        if string.find(node2, "_1_") then
            if string.find(node1.name, "_1_") then
                if used_pt_axis.axis ~= node_vector.axis then
                    local node1_table = {name=node1.name, param1=node1.param1, param2=node1.param2}
                    local needed_sofa_parts = sofas.define_needed_sofa_part(player, node1_table, node2, string.gsub(node1.name, "1", "2"), string.gsub(node2, "1", "3"),  pos, pointed_thing)
                    local needed_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing, pos)
                    minetest.set_node(pos, {name = needed_sofa_parts[1], param1=node1.param1, param2=node1.param2})
                    minetest.set_node(needed_pos, {name = needed_sofa_parts[2], param1=node1.param1, param2=node1.param2})
                   
                else
                    return
                end
            elseif string.find(node1.name, "_2_") or string.find(node1.name, "_3_") then
                if used_pt_axis.axis ~= node_vector.axis then
                    local ordered_axles = {"-x", "-z", "x", "z"}
                    local num1
                    local num2
                    for num, axle in pairs(ordered_axles) do
                        local axis = string.sub(axle, -1, -1)
                        local executed1 = false
                        local executed2 = false
                        local used_pt_axle
                        local node_vect
                        if used_pt_axis.val < pos[axis] and executed1 ~= true and axis == used_pt_axis.axis then -- REWRITE!!!
                            used_pt_axle =  "-" .. tostring(used_pt_axis.axis)
                            executed1 = true
                        elseif used_pt_axis.val > pos[axis] and executed1 ~= true and axis == used_pt_axis.axis then
                            used_pt_axle = tostring(used_pt_axis.axis)
                            executed1 = true
                        end
                        
                        if node_vector.vector < 0 and executed2 ~= true then
                            node_vect = "-" .. tostring(node_vector.axis)
                            executed2 = true
                        elseif node_vector.vector > 0 and executed2 ~= true then
                            node_vect = tostring(node_vector.axis)
                            executed2 = true
                        end
                        
                        if axle == used_pt_axle then
                            num1 = num
                        end
                        
                        if axle == node_vect then
                            num2 = num
                        end
                        
                        if num1 ~= nil and num2 ~= nil then
                            
                            if (num1 < num2 and string.find(node1.name, "_3_")) or (num1 == 4 and num2 == 1) then
                                local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                local rep = string.gsub(node2, "1", "5")
                                local rep2 = string.gsub(node2, "1", "3")
                                minetest.set_node(pos, {name=rep, param1=node1.param1, param2=node1.param2})
                                minetest.set_node(needed_sofa_pos, {name=rep2, param1=node1.param1, param2=node1.param2})
                                return true
                            elseif (num1 > num2 and string.find(node1.name, "_2_")) or (num1 == 1 and num2 == 4) then
                                local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                local rep = string.gsub(node2, "1", "5")
                                local rep2 = string.gsub(node2, "1", "2")
                                minetest.set_node(pos, {name=rep, param1=node1.param1, param2=node1.param2})
                                minetest.set_node(needed_sofa_pos, {name=rep2, param1=node1.param1, param2=node1.param2})
                                return true
                            end
                        end
                    end
                elseif used_pt_axis.axis == node_vector.axis then
                        if string.find(node1.name, "_2_") then
                            local ordered_axles = {"-x", "-z", "x", "z"}
                            local used_pt_axle
                            local v = used_pt_axis.axis
                            if used_pt_axis.val < pos[v] then
                                used_pt_axle = "-" .. tostring(used_pt_axis.axis)
                            else
                                used_pt_axle = tostring(used_pt_axis.axis)
                            end
                           
                            local needed_axis
                            for num, axis in pairs(ordered_axles) do
                                
                                if used_pt_axle == axis then
                                    if num == #ordered_axles then
                                        needed_axis = ordered_axles[1]
                                   
                                    else
                                        needed_axis = ordered_axles[num+1]
                                        
                                    end
                                      
                                    local new_vector = {x=0, y=0, z=0}
                                    if string.find(needed_axis, "-") then
                                        new_vector[string.sub(needed_axis, 2)] = 1
                                    else
                                        new_vector[needed_axis] = -1
                                    end
                                    
                                    
                                    local rep = string.gsub(node2, "1", "4")
                                    local rep2 = string.gsub(node2, "1", "2")
                                    minetest.set_node(pos, {name=rep, param1=node1.param1, param2=node1.param2})
                                    local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                    minetest.set_node(needed_sofa_pos, {name=rep2, param1=node1.param1, param2=minetest.dir_to_facedir(new_vector)})
                                end
                            end
                        elseif string.find(node1.name, "_3_") then
                            
                            local ordered_axles = {"-x", "-z", "x", "z"}
                            local needed_axis
                            local v = used_pt_axis.axis
                            local used_pt_axle
                            if used_pt_axis.val < pos[v] then
                                used_pt_axle = "-" .. tostring(used_pt_axis.axis)
                            else
                                used_pt_axle = tostring(used_pt_axis.axis)
                            end
                                
                            for num, axis in pairs(ordered_axles) do
                                if used_pt_axle == axis then
                                    if num == 1 then
                                        needed_axis = ordered_axles[#ordered_axles]
                                    else
                                        needed_axis = ordered_axles[num-1]
                                    end
                                    
                                    local new_vector = {x=0, y=0, z=0}
                                    if string.find(needed_axis, "-") then
                                        new_vector[string.sub(needed_axis, -1, -1)] = 1
                                    else
                                        new_vector[needed_axis] = -1
                                    end
                                    
                                    local rep = string.gsub(node2, "1", "4")
                                    local rep2 = string.gsub(node2, "1", "3")
                                    minetest.set_node(pos, {name=rep, param1=node1.param1, param2=minetest.dir_to_facedir(new_vector)})
                                    local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                    minetest.set_node(needed_sofa_pos, {name=rep2, param1=node1.param1, param2=minetest.dir_to_facedir(new_vector)})
                                    return true
                                end
                            end
                            
                        end
            
               end
            else
                return
            end
        else
            return
        end
    else
        return
    end
end
                                        
                                    
                                
             
        
for color, rgb_color in pairs(sofas_rgb_colors) do
    for _, pillow_color in ipairs({"red", "green" , "blue", "yellow", "violet"}) do
        minetest.register_node("luxury_decor:simple_" .. color .. "_armchair_with_" .. pillow_color .. "_pillow", {
            description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " Armchair With " .. string.upper(pillow_color) .. " Pillow" ),
            visual_scale = 0.5,
            mesh = "simple_armchair.obj",
            tiles = {"simple_armchair.png^(simple_armchair_2_1.png^[colorize:" .. rgb_color .. "^simple_armchair_2.png)^(simple_armchair_3.png^[colorize:" .. pillow_color .. ")"},
            paramtype = "light",
            paramtype2 = "facedir",
            groups = {choppy = 2.5, },
            drawtype = "mesh",
            collision_box = {
                type = "fixed",
                fixed = {
                    {-0.31, -0.5, -0.45, 0.33, 0.15, 0.5},
                    {-0.5, -0.5, -0.45, -0.31, 0.36, 0.3},
                    {0.53, -0.5, -0.45, 0.33, 0.36, 0.3},
                    {-0.42, 0.15, 0.3, 0.44, 0.9, 0.5}
                }
            },
            selection_box = {
                type = "fixed",
                fixed = {
                    {-0.31, -0.5, -0.45, 0.33, 0.15, 0.5},
                    {-0.5, -0.5, -0.45, -0.31, 0.36, 0.3},
                    {0.53, -0.5, -0.45, 0.33, 0.36, 0.3},
                    {-0.42, 0.15, 0.3, 0.44, 0.9, 0.5}
                }
            },
            sounds = default.node_sound_wood_defaults(),
            on_construct = function (pos)
                local meta = minetest.get_meta(pos)
		meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, speed=15, blend=0, loop=true}}))
            end,
            after_dig_node = function (pos, oldnode, oldmetadata, digger)
		local seat = minetest.deserialize(oldmetadata.fields.seat)
		if seat.busy_by then
			local player = minetest.get_player_by_name(seat.busy_by)
			chairs.standup_player(player, pos, seat)
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
                    else
			local bool = chairs.sit_player(clicker, node, pos) 
			if bool == nil then
				chairs.standup_player(clicker, pos)
			end
                    end
                    return itemstack
                end
        })
            
        minetest.register_craft({
            output = "luxury_decor:simple_"..color.."_armchair_with_"..pillow_color.."_pillow",
            recipe = {
                {"luxury_decor:wooden_board", "wool:white", "dye:"..color},
                {"luxury_decor:wooden_board", "wool:white", "dye:"..pillow_color},
                {"default:stick", "", ""}
            }
        })
    end
end

for ind, sofa_count in pairs({"1", "2", "3", "4", "5"}) do
    local not_in_cinv = 0
    for color, rgb_color in pairs(sofas_rgb_colors) do
        if sofa_count ~= "1" then
            not_in_cinv = 1
        end
        minetest.register_node("luxury_decor:simple_".. sofa_count .. "_" .. color .. "_sofa", {
            description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " Sofa"),
            visual_scale = 0.5,
            mesh = "simple_sofa_" .. sofa_count .. ".obj",
            tiles = {"simple_sofa.png^(simple_sofa_2_1.png^[colorize:" .. rgb_color.. "^simple_sofa_2.png)"},
            paramtype = "light",
            paramtype2 = "facedir",
            groups = {choppy = 2.5, not_in_creative_inventory = not_in_cinv},
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
		meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, speed=15, blend=0, loop=true}}))
            end,
            after_dig_node = function (pos, oldnode, oldmetadata, digger)
		local seat = minetest.deserialize(oldmetadata.fields.seat)
		if seat.busy_by then
			local player = minetest.get_player_by_name(seat.busy_by)
			chairs.standup_player(player, pos, seat)
		end
            end,
            on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                if string.find(itemstack:get_name(), "dye:") then
                    for color2, rgb_code in pairs(sofas_rgb_colors) do
                        if "dye:" .. color2 == itemstack:get_name() then
                            itemstack:take_item()
                            minetest.remove_node(pos)
                            minetest.set_node(pos, {name="luxury_decor:simple_" .. sofa_count .. "_" .. color2 .. "_sofa"})
                        end
                    end
                
                elseif string.find(itemstack:get_name(), "luxury_decor:simple_") and string.find(itemstack:get_name(), "_sofa") then
                       sofas.connect_sofas(clicker, {name=node.name, param1=node.param1, param2=node.param2}, itemstack:get_name(), pos, pointed_thing)
                else
			local bool = chairs.sit_player(clicker, node, pos) 
			if bool == nil then
				chairs.standup_player(clicker, pos)
			end
                end
            end,
            on_dig = function (pos, node, player)
                if node.name == "luxury_decor:simple_2_" .. color .. "_sofa"  or
                   node.name == "luxury_decor:simple_3_" .. color .. "_sofa" or
                   node.name == "luxury_decor:simple_5_" .. color .. "_sofa" then
                    
                    local vector = minetest.facedir_to_dir(node.param2)
                    local axle1
                    local axle2
                    local ordered_axles = {"-x", "-z", "x", "z"}
                    for axis, val in pairs(vector) do
                        if val ~= 0 and axis ~= y then
                            if val < 0 then
                                axle1 = "-" .. tostring(axis)
                            else
                                axle1 = tostring(axis)
                            end       
                        elseif val == 0 and axis ~= y then
                            axle2 = axis
                        end
                    end
                    
                    local pos1 = {x=pos.x, y=pos.y, z=pos.z}
                    local pos2 = {x=pos.x, y=pos.y, z=pos.z}
                    pos1[axle2] = pos1[axle2] - 1
                    pos2[axle2] = pos2[axle2] + 1
                    local nearby_nodes = minetest.find_nodes_in_area(pos1, pos2, {"luxury_decor:simple_2_"..color.."_sofa", "luxury_decor:simple_3_"..color.."_sofa", "luxury_decor:simple_5_"..color.."_sofa", 
                    "luxury_decor:simple_4_"..color.."_sofa"})
                    for num, node_pos in pairs(nearby_nodes) do
                        if num == 1 or num == #nearby_nodes then
                            local nearby_node = minetest.get_node(node_pos)
                            if nearby_node.name == "luxury_decor:simple_5_"..color.."_sofa" and nearby_node.param2 == node.param2 then
                                local ordered_axises = sofas.define_sidelong_axises(axle1)
                                local new_positions = {
                                      {
                                      {x=pos.x, y=pos.y, z=pos.z},
                                      "luxury_decor:simple_3_"..color.."_sofa"
                                      },
                                      {
                                      {x=pos.x, y=pos.y, z=pos.z},
                                      "luxury_decor:simple_2_"..color.."_sofa"
                                      }
                                    }
                                      
                                for num, axis in pairs(ordered_axises) do
                                    local axle = string.sub(axis, -1, -1)
                                    if string.sub(axis, 1, 1) == "-" then
                                        if pos[axle] + 1 == node_pos[axle] then
                                            new_positions[num][1][axle] = new_positions[num][1][axle] + 1
                                            minetest.remove_node(pos)
                                            minetest.set_node(new_positions[num][1], {name=new_positions[num][2], param1=node.param1, param2=node.param2})
                                        end
                                    else
                                        if pos[axle] - 1 == node_pos[axle] then
                                            new_positions[num][1][axle] = new_positions[num][1][axle] - 1
                                            minetest.remove_node(pos)
                                            minetest.set_node(new_positions[num][1], {name=new_positions[num][2], param1=node.param1, param2=node.param2})
                                        end
                                    end
                                end
                            elseif (nearby_node.name == "luxury_decor:simple_2_"..color.."_sofa" or 
                                    nearby_node.name == "luxury_decor:simple_3_"..color.."_sofa") and nearby_node.param2 == node.param2 then
                                     minetest.remove_node(pos)
                                     minetest.set_node(node_pos, {name="luxury_decor:simple_1_"..color.."_sofa", param1=node.param1, param2=node.param2})
                            elseif nearby_node.name == "luxury_decor:simple_4_"..color.."_sofa" then
                                    local side_node_vector = minetest.facedir_to_dir(nearby_node.param2)
                                    local side_node_vector2
                                    for axis, val in pairs(side_node_vector) do
                                        if val ~= 0 then
                                            if val < 0 then
                                                side_node_vector2 = "-" .. axis
                                            else
                                                side_node_vector2 = tostring(axis)
                                            end
                                        end
                                    end
                                                                                            
                                    local side_axles = sofas.define_sidelong_axises(axle1)
                                    for n, axis in pairs(side_axles) do
                                        
                                        if side_node_vector2 == axle1 and n == 1 then
                                            local needed_axis3
                                            for num, axis in pairs(ordered_axles) do
                                                if side_node_vector2 == axis then
                                                    if num == #ordered_axles then
                                                        needed_axis3 = ordered_axles[1]
                                                    else
                                                        needed_axis3 = ordered_axles[num+1]
                                                    end
                                                    local new_vector2 = sofas.translate_str_vector_to_table(needed_axis3)
                                                    minetest.remove_node(pos)
                                                    minetest.set_node(node_pos, {name="luxury_decor:simple_3_"..color.."_sofa", param1=node.param1, param2=minetest.dir_to_facedir(new_vector2)})
                                                end
                                            end
                                        elseif n == 2 then
                                            for num, axis in pairs(ordered_axles) do
                                                if axis == axle1 then
                                                    local new_vector2 = sofas.translate_str_vector_to_table(side_node_vector2)
                                                    if num == 1 then
                                                        if side_node_vector2 == ordered_axles[#ordered_axles] then
                                                            minetest.remove_node(pos)
                                                            minetest.set_node(node_pos, {name="luxury_decor:simple_2_"..color.."_sofa", param1=node.param1, param2=minetest.dir_to_facedir(new_vector2)})
                                                        end
                                                    else
                                                        if ordered_axles[num-1] == side_node_vector2 then
                                                            minetest.remove_node(pos)
                                                            minetest.set_node(node_pos, {name="luxury_decor:simple_2_"..color.."_sofa", param1=node.param1, param2=minetest.dir_to_facedir(new_vector2)})
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                            end
                        end
                    end
                elseif node.name == "luxury_decor:simple_4_"..color.."_sofa" then
                        local str_axis = sofas.translate_vector_table_to_str(minetest.facedir_to_dir(node.param2))
                        local ordered_axles = {"-x", "-z", "x", "z"}
                                                
                        local pos1 = {x=pos.x, y=pos.y, z=pos.z}
                        local pos2 = {x=pos.x, y=pos.y, z=pos.z}
                        if string.sub(str_axis, 1, 1) == "-" then
                            pos1[string.sub(str_axis, -1, -1)] = pos1[string.sub(str_axis, -1, -1)] + 1
                        else
                            pos1[string.sub(str_axis, -1, -1)] = pos1[string.sub(str_axis, -1, -1)] - 1
                        end
                        local side_node_axis
                        for num, axis in pairs(ordered_axles) do
                            if axis == str_axis then
                                if num == 1 then
                                    side_node_axis = ordered_axles[#ordered_axles]
                                else
                                    side_node_axis = ordered_axles[num-1]
                                end
                            end
                        end
                                                                    
                        if string.sub(side_node_axis, 1, 1) == "-" then
                            pos2[string.sub(side_node_axis, -1, -1)] = pos2[string.sub(side_node_axis, -1, -1)] - 1
                        else
                            pos2[string.sub(side_node_axis, -1, -1)] = pos2[string.sub(side_node_axis, -1, -1)] + 1
                        end
                        
                        local side_node_axis_opposite
                        if string.sub(side_node_axis, 1, 1) == "-" then
                            side_node_axis_opposite = string.sub(side_node_axis, -1, -1)
                        else
                            side_node_axis_opposite = "-" .. side_node_axis
                        end
                       if minetest.get_node(pos1).name == "luxury_decor:simple_2_"..color.."_sofa" or minetest.get_node(pos1).name == "luxury_decor:simple_5_"..color.."_sofa" then
                            minetest.debug("1")
                            for num, axis in pairs(ordered_axles) do
                                if axis == str_axis then
                                    if (num == 1 and ordered_axles[#ordered_axles] == side_node_axis) or ordered_axles[num-1] == side_node_axis then
                                        minetest.debug("TRUE")
                                        local vector_table = sofas.translate_str_vector_to_table(side_node_axis_opposite)
                                        minetest.remove_node(pos)
                                        if minetest.get_node(pos1).name == "luxury_decor:simple_2_"..color.."_sofa" then
                                            minetest.set_node(pos1, {name="luxury_decor:simple_1_"..color.."_sofa", param1=node.param1, param2=minetest.dir_to_facedir(vector_table)})
                                        elseif minetest.get_node(pos1).name == "luxury_decor:simple_5_"..color.."_sofa" then
                                            minetest.set_node(pos1, {name="luxury_decor:simple_3_"..color.."_sofa", param1=node.param1, param2=minetest.dir_to_facedir(vector_table)})
                                        end
                                    end
                                end
                            end
                        end
                        if minetest.get_node(pos2).name == "luxury_decor:simple_3_"..color.."_sofa" or minetest.get_node(pos2).name == "luxury_decor:simple_5_"..color.."_sofa" then
                            minetest.debug("2")
                            local node2 = minetest.get_node(pos2)
                            local node2_str_vector = sofas.translate_vector_table_to_str(minetest.facedir_to_dir(node2.param2))
                            if str_axis == node2_str_vector then
                                minetest.remove_node(pos)
                                if node2.name == "luxury_decor:simple_3_"..color.."_sofa" then
                                    minetest.set_node(pos2, {name="luxury_decor:simple_1_"..color.."_sofa", param1=node.param1, param2=node.param2})
                                elseif node2.name == "luxury_decor:simple_5_"..color.."_sofa" then
                                    minetest.set_node(pos2, {name="luxury_decor:simple_2_"..color.."_sofa", param1=node.param1, param2=node.param2})
                                end
                            end
                        end
                        if (minetest.get_node(pos1).name and minetest.get_node(pos2).name) ~= "luxury_decor:simple_5_"..color.."_sofa" and 
                            minetest.get_node(pos1).name ~= "luxury_decor:simple_2_"..color.."_sofa" and minetest.get_node(pos2).name ~= "luxury_decor:simple_3_"..color.."_sofa" then
                            minetest.remove_node(pos)
                        end
                elseif node.name == "luxury_decor:simple_1_"..color.."_sofa" then
                        minetest.remove_node(pos)
                end
            end
        })
            
        if sofa_count == "1" then
            minetest.register_craft({
                output = "luxury_decor:simple_"..sofa_count.."_"..color.."_sofa",
                recipe = {
                     {"luxury_decor:wooden_board", "luxury_decor:wooden_board", "wool:white"},
                     {"luxury_decor:wooden_board", "dye:"..color, "dye:grey"},
                     {"default:stick", "luxury_decor:brass_stick", ""}
                }
            })
        end
        
    end
end

            
        
for ind, footstool_type in pairs({"small", "middle", "long"}) do
    for color, rgb_code in pairs(sofas_rgb_colors) do
        minetest.register_node("luxury_decor:simple_" .. color .. "_" .. footstool_type .. "_footstool", {
            description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " " .. string.upper(footstool_type) .. " Footstool"),
            visual_scale = 0.5,
            mesh = "simple_"..footstool_type.."_footstool.b3d",
            tiles = {"simple_sofa.png^(simple_sofa_2_1.png^[colorize:" .. rgb_code.. "^simple_sofa_2.png)"},
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
	    on_construct = function (pos)
		   local meta = minetest.get_meta(pos)
		   meta:set_string("seat", minetest.serialize({busy_by=nil, pos = {x = pos.x, y = pos.y+0.2, z = pos.z}, anim={mesh="character_sitting.b3d", range={x=1, y=80}, speed=15, blend=0, loop=true}}))
	    end,	
		after_dig_node = function (pos, oldnode, oldmetadata, digger)
			local seat = minetest.deserialize(oldmetadata.fields.seat)
			if seat.busy_by then
				local player = minetest.get_player_by_name(seat.busy_by)
				chairs.standup_player(player, pos, seat)
			end
		end,                                                                                   
            on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
                if string.find(itemstack:get_name(), "dye:") then
                    local get_player_contr = clicker:get_player_control()
                        
                    
                    for color2, rgb_code in pairs(sofas_rgb_colors) do
                        if "dye:" .. color2 == itemstack:get_name() then
                            itemstack:take_item()
                            minetest.remove_node(pos)
                            minetest.set_node(pos, {name="luxury_decor:simple_" .. color2 .. "_" .. footstool_type .. "_footstool", param1=node.param1, param2=node.param2})
                        end
                    end
                    
                        
                elseif string.find(itemstack:get_name(), "luxury_decor:simple_" .. color .. "_small_footstool") then
                    local node_dir = minetest.facedir_to_dir(node.param2)
                    local footstools_types_list = {"small", "middle", "long"}
                    local new_pos = pos
                    local new_vector = node_dir
                    if string.find(node.name, footstools_types_list[1]) then
                        for axle, val in pairs(pointed_thing.above) do
                            if new_vector[axle] ~= 0 then new_vector[axle] = 0 end
                            if val ~= pointed_thing.under[axle] and axle ~= y then
                                if val > pos[axle] then
                                    new_vector[axle] = -1
                                elseif val < pos[axle] then
                                    new_vector[axle] = 1
                                end
                                itemstack:take_item()
                                minetest.set_node(pos, {name="luxury_decor:simple_" .. color .. "_middle_footstool", param1=node.param1, param2=minetest.dir_to_facedir(new_vector)})
                            end
                        end
                    elseif string.find(node.name, footstools_types_list[2]) then
                        for axle, val in pairs(pointed_thing.above) do
                            if val ~= pointed_thing.under[axle] and axle ~= y then
                                if node_dir[axle] > 0 then
                                    new_pos[axle] = new_pos[axle] - 1
                                    itemstack:take_item()
                                    minetest.remove_node(pos)
                                    minetest.set_node(new_pos, {name="luxury_decor:simple_" .. color .. "_long_footstool", param1=node.param1, param2=node.param2})
                                elseif node_dir[axle] < 0 then
                                    itemstack:take_item()
                                    --minetest.remove_node(pos)
                                    minetest.set_node(pos, {name="luxury_decor:simple_" .. color .. "_long_footstool", param1=node.param1, param2=node.param2})
                                end
                            end
                        end
                    end
                else
			local bool = chairs.sit_player(clicker, node, pos) 
			if bool == nil then
				chairs.standup_player(clicker, pos)
			end                                                                          
		end
                                    
            end
        })
        
        if footstool_type == "small" then
            minetest.register_craft({
                 output = "luxury_decor:simple_"..color.."_"..footstool_type.."_footstool",
                 recipe = {
                       {"luxury_decor:wooden_board", "wool:white", "dye:"..color},
                       {"", "", ""},
                       {"", "", ""}
                 }
            })
        elseif footstool_type == "middle" then
            minetest.register_craft({
                 output = "luxury_decor:simple_"..color.."_"..footstool_type.."_footstool",
                 recipe = {
                       {"luxury_decor:wooden_board", "wool:white", "dye:"..color},
                       {"luxury_decor:wooden_plank", "farming:string", "farming:string"},
                       {"", "", ""}
                 }
            })
            
        elseif footstool_type == "long" then
            minetest.register_craft({
                 output = "luxury_decor:simple_"..color.."_"..footstool_type.."_footstool",
                 recipe = {
                       {"luxury_decor:wooden_board", "wool:white", "dye:"..color},
                       {"luxury_decor:wooden_board", "wool:white", "dye:"..color},
                       {"luxury_decor:wooden_plank", "", ""}
                 }
            })
        end
    end
end

minetest.register_node("luxury_decor:simple_wooden_wall_clock", {
    description = "Simple Wooden Wall Clock",
    visual_scale = 0.5,
    mesh = "simple_wooden_wall_clock.b3d",
    tiles = {
        {
            name = "simple_wooden_wall_clock_animated.png",
            animation = {type = "vertical_frames", aspect_w = 64, aspect_h = 64, length = 60.0}
        }
    },
    inventory_image = "simple_wooden_wall_clock_inv.png",
    wield_image = "simple_wooden_wall_clock_inv.png",
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

minetest.register_craft({
    output = "luxury_decor:simple_wooden_wall_clock",
    recipe = {
        {"luxury_decor:jungle_wooden_board", "luxury_decor:jungle_wooden_board", ""},
        {"luxury_decor:jungle_wooden_plank", "luxury_decor:brass_stick", "luxury_decor:dial"},
        {"default:copper_ingot", "default:steel_ingot", ""}
    }
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
	    
