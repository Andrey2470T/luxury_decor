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
        {-0.34, -0.45, -0.4, 0.34, 0.05, 0.35}, -- Lower box
        {-0.34, -0.45, 0.35, 0.34, 0.55, 0.49}, -- Back box
        {-0.34, -0.45, -0.4, -0.51, 0.3, 0.49}, -- Right box
        {0.34, -0.45, -0.4, 0.51, 0.3, 0.49} -- Left box
        
    },
    ["2"] = {
        {-0.34, -0.45, -0.4, 0.51, 0.05, 0.35},
        {-0.34, -0.45, 0.35, 0.51, 0.55, 0.49},
        {-0.34, -0.45, -0.4, -0.51, 0.3, 0.49}
    },
    ["3"] = {
        {-0.34, -0.45, -0.4, 0.51, 0.05, 0.35},
        {-0.34, -0.45, 0.35, 0.51, 0.55, 0.49},
        {0.34, -0.45, -0.4, 0.51, 0.3, 0.49}
    },
    ["4"] = {
        {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5},
    },
    ["5"] = {
        {-0.34, -0.45, -0.4, 0.51, 0.05, 0.35},
        {-0.34, -0.45, 0.35, 0.51, 0.55, 0.49},
    }
}



local footstools_collision_boxes = {
    ["small"] = {{-0.3, -0.5, -0.3, 0.3, 0, 0.3}},
    ["middle"] = {{-0.3, -0.5, 0.3, 0.3, 0, -1.1}},
    ["long"] = {{-0.3, -0.5, 0.3, 0.3, 0, 1.8}}
}


function is_same_nums_sign(num1, num2)
    if num1 < 0 and num2 < 0 or num1 > 0 and num2 >0 then
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
            if surface_pos[axis] < 0 and surface_pos[axis] < pos[axis] then
                pointed_axis = "-" .. tostring(axis)
            elseif surface_pos[axis] < 0 and surface_pos[axis] > pos[axis] then
                pointed_axis = tostring(axis)
            elseif surface_pos[axis] > 0 and surface_pos[axis] < pos[axis] then
                pointed_axis = "-" .. tostring(axis)
            elseif surface_pos[axis] > 0 and surface_pos[axis] > pos[axis] then
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
        if axis == pointed_axis then
            pointed_axis_ind = num  
        end
        if axis == node_vector then
            node_vector_ind = num
        end
    end
    
    if pointed_axis_ind > node_vector_ind then
        return {replace_sofa1, replace_sofa2}
    elseif pointed_axis_ind < node_vector_ind then
        return {replace_sofa2, replace_sofa1}
    end
end
            
sofas.define_needed_sofa_pos = function (player, sofa, pointed_thing)
    local surface_pos = minetest.pointed_thing_to_face_pos(player, pointed_thing)
    local new_pos = sofa.pos
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
    
sofas.connect_sofas = function (player, node1, node2, pos, pointed_thing)
    local node_color1 = string.sub(node1.name, 22, -6)
    local node_color2 = string.sub(node2, 22, -6)
    local surface_pos = minetest.pointed_thing_to_face_pos(player, pointed_thing)
    
    -- Определяет ось, по которой грань была кликнута
    for axis, val in pairs(pointed_thing.above) do
        if val ~= pointed_thing.under[axis] then
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
                    local needed_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                    minetest.remove_node(pos)
                    minetest.set_node(needed_pos, {name = needed_sofa_parts[2], param1=node1.param1, param2=node1.param2})
                    minetest.set_node(pos, {name = needed_sofa_parts[1], param1=node1.param1, param2=node1.param2})
                else
                    return
                end
            elseif string.find(node1.name, "_2_") or string.find(node1.name, "_3_") then
                if used_pt_axis.axis ~= node_vector.axis then
                    local ordered_axles = {"-x", "-z", "x", "z"}
                    
                    for num, axle in pairs(ordered_axles) do
                        local axis = string.sub(axle, -1, -1)
                        local executed1 = false
                        local executed2 = false
                        if used_pt_axis.val < pos[axis] and executed1 ~= true and tonumber(axis) == used_pt_axis.axis then
                            local used_pt_axle =  "-" .. tostring(used_pt_axis.axis)
                            executed1 = true
                        else
                            local used_pt_axle = tostring(used_pt_axis.axis)
                            executed1 = true
                        end
                        
                        if node_vector.vector < 0 and executed2 ~= true then
                            minetest.debug("CCCC")
                            local node_vect = "-" .. tostring(node_vector.axis)
                            executed2 = true
                        else
                            minetest.debug("DDDD")
                            local node_vect = tostring(node_vector.axis)
                            executed2 = true
                        end
                        
                        --minetest.debug(used_pt_axle)
                        --minetest.debug(node_vect)
                        if axle == used_pt_axle then
                            minetest.debug("AAA")
                            local num1 = num
                        end
                        
                        if axle == node_vect then
                            minetest.debug("BBB")
                            local num2 = num
                            
                            if num1 < num2 and string.find(node1.name, "_3_") then
                                local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                local rep = string.gsub(node2, "1", "5")
                                local rep2 = string.gsub(node2, "1", "3")
                                minetest.set_node(pos, {name=rep[1], param1=node1.param1, param2=node1.param2})
                                minetest.set_node(needed_sofa_pos, {name=rep2[1], param1=node1.param1, param2=node1.param2})
                                return true
                            elseif num1 > num2 and string.find(node1.name, "_2_") then
                                local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                local rep = string.gsub(node2, "1", "5")
                                local rep2 = string.gsub(node2, "1", "2")
                                minetest.set_node(pos, {name=rep[1], param1=node1.param1, param2=node1.param2})
                                minetest.set_node(needed_sofa_pos, {name=rep2[1], param1=node1.param1, param2=node1.param2})
                                return true
                            end
                        end
                    end
                elseif used_pt_axis.axis == node_vector.axis then
                    if is_same_nums_sign(used_pt_axis.val, node_vector.vector) then
                        if string.find(node1.name, "_2_") then
                            local ordered_axles = {"-x", "-z", "x", "z"}
                            
                            for num, axle in pairs(ordered_axles) do
                                if used_pt_axis.val < 0 then
                                    local used_pt_axle = "-" .. tostring(used_pt_axis.axis)
                                else
                                    local used_pt_axle = tostring(used_pt_axis.axis)
                                end
                                
                                if used_pt_axle == axle then
                                    if #ordered_axles == num then
                                        local needed_axis = ordered_axles[1]
                                        local needed_axis2 = ordered_axles[2]
                                    else
                                        local needed_axis = ordered_axles[num+1]
                                        if needed_axis == axle then
                                            needed_axis2 = ordered_axles[1]
                                        else
                                            needed_axis2 = ordered_axles[num+2]
                                        end
                                    end
                                    
                                    
                                    local new_vector = node_vector
                                    if string.find(needed_axis, "-") then
                                        new_vector[tonumber(string.sub(needed_axis, -1))] = -1
                                    else
                                        new_vector[tostring(needed_axis)] = 1
                                    end
                                    
                                    if string.find(needed_axis2, "-") then
                                        new_vector[tonumber(string.sub(needed_axis2, -1))] = -1
                                    else
                                        new_vector[tostring(needed_axis)] = 1
                                    end
                                    
                                    local rep = string.gsub(node2, "1", "4")
                                    local rep2 = string.gsub(node2, "1", "2")
                                    minetest.set_node(pos, {name=rep[1], param1=node1.param1, param2=minetest.dir_to_facedir(new_vector)})
                                    local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                    minetest.set_node(needed_sofa_pos, {name=rep2[1], param1=node1.param1, param2=minetest.dir_to_facedir(needed_axis2)})
                                end
                            end
                        elseif string.find(node1.name, "_3_") then
                            local ordered_axles = {"-x", "-z", "x", "z"}
                            
                            for num, axle in pairs(ordered_axles) do
                                if used_pt_axis.val < 0 then
                                    local used_pt_axle = "-" .. tostring(used_pt_axis.axis)
                                else
                                    local used_pt_axle = tostring(used_pt_axis.axis)
                                end
                                
                                if used_pt_axle == axle then
                                    if num == 1 then
                                        local needed_axis = ordered_axles[#ordered_axles]
                                    else
                                        local needed_axis = ordered_axles[num-1]
                                    end
                                    
                                    local new_vector = node_vector
                                    if string.find(needed_axis, "-") then
                                        new_vector[tonumber(string.sub(needed_axis, -1))] = -1
                                    else
                                        new_vector[tostring(needed_axis)] = 1
                                    end
                                    
                                    local rep = string.gsub(node2, "1", "4")
                                    local rep2 = string.gsub(node2, "1", "3")
                                    minetest.set_node(pos, {name=rep[1], param1=node1.param1, param2=node1.param2})
                                    local needed_sofa_pos = sofas.define_needed_sofa_pos(player, {name=node1.name, param1=node1.param1, param2=node1.param2, pos=pos}, pointed_thing)
                                    minetest.set_node(needed_sofa_pos, {name=rep2[1], param1=node1.param1, param2=minetest.dir_to_facedir(needed_axis)})
                                end
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
                                        
                                    
                                
                    
                    --[[local surface_pos = minetest.pointed_thing_to_face_pos(player, pointed_thing)
                    local nearby_sofas = minetest.find_nodes_in_area({x=pos.x-1, y=pos.y, z=pos.z-1}, {x=pos.x+1, y=pos.y, z=pos.z+1}, {"luxury_decor:simple_sofa_5"})
                    if nearby_sofas then
                        for _, sofa_pos in ipairs(nearby_sofas) do
                            local node = minetest.get_node(sofa_pos)
                            for axis, vector in pairs(minetest.facedir_to_dir(node.param2)) do
                                if vector ~= 0 then
                                    local node2_vector = {axis=axis, vector=vector}
                                end
                            end
                            if node.name == "luxury_decor:simple_sofa_5" and node2_vector.axis == node_vector.axis then
                                for axis, val in pairs(sofa_pos) do
                                    if val ~= used_pt_axis.val then
                                        
                    
                    
                    
                    
                    
            local p = node1.pos
            local sofas = minetest.find_nodes_in_area({x=p.x-1, y=p.y, z=p.z-1}, {x=p.x+1, y=p.y, z=p.z+1}, 
                {"luxury_decor:simple_sofa_2", "luxury_decor:simple_sofa_3", "luxury_decor:simple_sofa_4", "luxury_decor:simple_sofa_5"})
                
            for _, sofa_pos in ipairs(sofas) do
                local sofa_itemstr = minetest.get_node(sofa_pos).name
                if sofa_itemstr == "luxury_decor:simple_sofa_5" then
                    for axis, val in pairs(sofa_pos) do
                        if 
                    if minetest.get_node(sofa_pos).param2 == node1.param2 and node1.pos[axis] == 
                    
                    
                    
            if not string.find(node1.name, "_4_") then
               for axis, val in pairs(node1.pointed_thing.above) do
                   if val ~= node1.pointed_thing.under[axis] and axis ~= y then
                       local new_pos = node1.pos
                       local player_dir = player:get_look_dir()
                       if player_dir[axis] < 0 then
                           new_pos[axis] = new_pos[axis] + 1
                           minetest.set_node(new_pos, {name=node2, param1=node1.param1, param2=node2.param2})
                       elseif player_dir[axis] > 0 then
                           new_pos[axis] = new_pos[axis] - 1
                           minetest.set_node(new_pos, {name=node2, param1=node1.param1, param2=node2.param2})
                       end
                       return true
                   end
               end
            else
                local node_dir = node1.param2
                local directed_axis
                for axis, val in pairs(node_dir) do
                    if val ~= 0 and axis ~= y then
                        directed_axis = {axis, val}
                    elseif axis == y then
                        return
                    end
                end
                
                for axis, val in pairs(node1.pointed_thing.above) do
                   if val ~= node1.pointed_thing.under[axis] and axis ~= y then
                       local new_pos = node1.pos
                       local player_dir = player:get_look_dir()
                       if player_dir[axis] < 0 then
                           new_pos[axis] = new_pos[axis] + 1
                           if axis == directed_axis.axis and directed_axis.val ~= player_dir[axis] then
                              minetest.set_node(new_pos, {name=node2, param1=node1.param1, param2=node2.param2})
                           elseif axis ~= directed_axis.axis and directed_axis.val ~= player_dir[axis] then
                              local new_dir = minetest.facedir_to_dir(node1.param2)
                              new_dir[axis] = 1
                              minetest.set_node(new_pos, {name=node2, param1=node1.param1, param2= minetest.dir_to_facedir(new_dir)})
                           end
                       elseif player_dir[axis] > 0 then
                           new_pos[axis] = new_pos[axis] - 1
                           if axis == directed_axis.axis and directed_axis.val ~= player_dir[axis] then
                              minetest.set_node(new_pos, {name=node2, param1=node1.param1, param2=node2.param2})
                           elseif axis ~= directed_axis.axis and directed_axis.val ~= player_dir[axis] then
                              local new_dir = minetest.facedir_to_dir(node1.param2)
                              new_dir[axis] = -1
                              minetest.set_node(new_pos, {name=node2, param1=node1.param1, param2= minetest.dir_to_facedir(new_dir)})
                           end
                       end
                       return true
                   end
               end
            end
        else
            return
        end
    else
        return
    end
end

                        
                
                    
                    
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
                
                
        if string.find(name1, "_4") then
            local dir = node1.param2
            if dir.x ~= 0 then
                minetest.set_node(node2, {x=node1.pos.x, y=pos})]]
        
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

for ind, sofa_count in pairs({"1", "2", "3", "4", "5"}) do
    local not_in_cinv = 0
    for color, rgb_color in pairs(sofas_rgb_colors) do
        --for _, pillow_color in ipairs({"red", "green" , "blue", "yellow", "violet"}) do
        if sofa_count ~= "1" then
            not_in_cinv = 1
        end
        minetest.register_node("luxury_decor:simple_".. sofa_count .. "_" .. color .. "_sofa", {
            description = minetest.colorize(sofas_rgb_colors[color], "Simple " .. string.upper(color) .. " Sofa"),
            visual_scale = 0.5,
            mesh = "simple_sofa_" .. sofa_count .. ".obj",
            tiles = {"simple_sofa.png^(simple_sofa_2.png^[colorize:" .. rgb_color.. ")"},
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
                        
                    --[[if get_player_contr.sneak then
                        for _, p_color in ipairs({"red", "green", "blue", "yellow", "violet"}) do
                            if itemstack:get_name() == "dye:" .. p_color then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node(pos, {name="luxury_decor:simple_" .. sofa_count .. "_" .. color .. "_sofa_with_" .. p_color .. "_pillow"})
                               end
                        end]]
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
                    local meta = clicker:get_meta()
                    local is_attached = minetest.deserialize(meta:get_string("is_attached"))
                    if is_attached == nil or is_attached == "" then
                        chairs.sit_player(clicker, node, pos, {{{x=81, y=81}, frame_speed=15, frame_blend=0}})
                        
                    elseif is_attached ~= nil or is_attached ~= "" then
                        chairs.standup_player(clicker, pos)
             
                    end
                end
            end
        })
        
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
	    
