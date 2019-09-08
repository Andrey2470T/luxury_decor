cabinets = {}

--[[Arguments:
*pos - position of clicked node;
*cabinet_name - same value as well as one of cabinets.open();
*cabinet_num - number of cabinet, in other words this is component of the cabinet. Number is string;
*data - table that contains list of all its components with each component name key and its data (formspec tables).]]
cabinets.put_data_into_cabinet = function (pos, cabinet_name, cabinet_num, data, formspec)
    local meta = minetest.get_meta(pos)
    
    if type(data) == "table" and #data ~= 0 then
       meta:set_string(cabinet_name .. "_" .. cabinet_num, minetest.serialize(data))
    else
        return
    end
    
    meta:set_string("formspec", formspec["data"])
    return meta
end

-- DEPRECATED! An unified function is necessary as open and close ones implement the same.
--[[Arguments:
*pos - position of clicked node;
*node_replace - itemstring, node that needed to be replaced to former.
*cabinet_name - "generalized" name of all its components, that is kitchen_wooden_cabinet_1, kitchen_wooden_cabinet_2, kitchen_wooden_cabinet_3 are kitchen_wooden_cabinet indeed, they are just modified models;
*formspec - table with next keys: name, data (formspec string itself);
*sound_play - table that can keep ONLY two sound names that needed to be played during opening and closing. Keys are: first is "open", second is "close".]]
cabinets.open = function (pos, node_replace, clicked_button_name, formspec, sounds_play)
    local node = minetest.get_node(pos)
    local name = node.name
    local general_name = string.sub(name, 14, -3)
    local actual_name = string.sub(name, 14)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    
    --local changed_depart_data
    
    -- The lower loop is running departments of the node as kitchen_wooden_cabinet_1... then it compares clicked_button_name is equal to the button name in the department.
    
    for depart_num, depart_data in pairs(cabs_table[general_name][actual_name]) do
        if type(depart_data) == "table" and depart_data.mode == "opened" then
		local list = inv:get_list(depart_data.listname)
		local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
		cabs_table[general_name].inv_list[depart_num][str_pos] = list
	end
	if type(depart_data) == "table" and depart_data.button == clicked_button_name then
		minetest.sound_play(sounds_play[depart_num], {
		pos = pos,
		max_hear_distance = 15
	        })
	end
    end
    minetest.remove_node(pos)
    minetest.set_node(pos, {name=node_replace, param1=node.param1, param2=node.param2})
end

-- DEPRECATED! An unified function is necessary as open and close ones implement the same.
cabinets.close = function (pos, node_replace, clicked_button_name, formspec, sounds_play)
    local node = minetest.get_node(pos)
    local name = node.name
    local general_name = string.sub(name, 14, -3)
    local actual_name = string.sub(name, 14)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    
    -- The lower loop is running departments of the node as kitchen_wooden_cabinet_1... then it compares clicked_button_name is equal to the button name in the department.
    
    for depart_num, depart_data in pairs(cabs_table[general_name][actual_name]) do
        if type(depart_data) == "table" and depart_data.mode == "opened" then
            local list = inv:get_list(depart_data.listname)
            local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
            cabs_table[general_name].inv_list[depart_num][str_pos] = list
	end
	if type(depart_data) == "table" and depart_data.button == clicked_button_name then
		minetest.sound_play(sounds_play[depart_num], {
		pos = pos,
		max_hear_distance = 15
	        })
	end
    end      
        minetest.remove_node(pos)
	minetest.set_node(pos, {name=node_replace, param1=node.param1, param2=node.param2})
end
           
                
local modes = {}
cabinets.define_needed_cabinet = function (fields, nodename)
    local substring = string.sub(nodename, 14)
    local generalized_name = string.sub(substring, 1, -3)
    for _, depart in ipairs(cabs_table[generalized_name][substring]) do
        modes[#modes+1] = depart.mode
    end
    
    for _, depart in ipairs(cabs_table[generalized_name][substring]) do
        local name = depart.button
        if fields[name] then
            for num, depart2 in pairs(cabs_table[generalized_name][substring]) do
                if depart2.button == depart.button then
                    if depart2.mode == "closed" then
                        modes[num] = "opened"
                    elseif depart2.mode == "opened" then
                        modes[num] = "closed"
                    end
                    break
                end
            end
            
        end
    end
    
    for name, cabs_list in pairs(cabs_table[generalized_name]) do
        local mode_num = 0
        for num, cab in pairs(cabs_list) do
            mode_num = mode_num + 1
            if cab.mode ~= modes[mode_num] then
                break
            end
            if num == #cabs_list then
                return name
            end
        end
    end
end

local number = 0
cabinets.define_mode = function (fields, nodename)
    local substring = string.sub(nodename, 14)
    local general_name = string.sub(substring, 1, -3)
    for num, depart in pairs(cabs_table[general_name][substring]) do
        if type(depart) == "table" then
            local name = depart.button
            if fields[name] then
                return depart.mode
            end
        end
    end
end

--[[Create a table with external table for each cabinet sort (depends to boxes). Inside each second field a list of boxes and their datas.
     Besides, it *must* contain "inv_list" is a list with items inside each the cabinet department]]

cabs_table["kitchen_wooden_cabinet"] = {
    ["kitchen_wooden_cabinet_1"] = {
        {mode="closed", button = "kwc1_1", img_button = "open_button.png"},
        {mode="closed", button = "kwc1_2", img_button = "open_button.png"},
        
    },
    ["kitchen_wooden_cabinet_2"] = {
        {mode="opened", button = "kwc2_1", img_button = "close_button.png", listname = "kwc2_1", inv_size=6*2},
        {mode="closed", button = "kwc2_2", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_3"] = {
        {mode="closed", button = "kwc3_1", img_button = "open_button.png"},
        {mode="opened", button = "kwc3_2", img_button = "close_button.png", listname = "kwc3_2", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_4"] = {
        {mode="opened", button = "kwc4_1", img_button = "close_button.png", listname = "kwc4_1", inv_size=6*2},
        {mode="opened", button = "kwc4_2", img_button = "close_button.png", listname = "kwc4_2", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}, {}}
}

cabs_table["kitchen_wooden_cabinet_with_door"] = {
    ["kitchen_wooden_cabinet_with_door_1"] = {
        {mode="closed", button = "kwc_with_door1", img_button = "open_button.png"}
        
    },
    ["kitchen_wooden_cabinet_with_door_2"] = {
        {mode="opened", button = "kwc_with_door2", img_button = "close_button.png", listname = "kwc_with_door2", inv_size=6*4},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}}
}

cabs_table["kitchen_wooden_cabinet_with_door_and_drawer"] = {
    ["kitchen_wooden_cabinet_with_door_and_drawer_1"] = {
        {mode="closed", button = "kwc_with_door_and_drawer1_1", img_button = "open_button.png"},
        {mode="closed", button = "kwc_with_door_and_drawer1_2", img_button = "open_button.png"},
        
    },
    ["kitchen_wooden_cabinet_with_door_and_drawer_2"] = {
        {mode="opened", button = "kwc_with_door_and_drawer2_1", img_button = "close_button.png", listname = "kwc_with_door_and_drawer2_1", inv_size=6},
        {mode="closed", button = "kwc_with_door_and_drawer2_2", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_with_door_and_drawer_3"] = {
        {mode="closed", button = "kwc_with_door_and_drawer3_1", img_button = "open_button.png"},
        {mode="opened", button = "kwc_with_door_and_drawer3_2", img_button = "close_button.png", listname = "kwc_with_door_and_drawer3_2", inv_size=6*3},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_with_door_and_drawer_4"] = {
        {mode="opened", button = "kwc_with_door_and_drawer4_1", img_button = "close_button.png", listname = "kwc_with_door_and_drawer4_1", inv_size=6},
        {mode="opened", button = "kwc_with_door_and_drawer4_2", img_button = "close_button.png", listname = "kwc_with_door_and_drawer4_2", inv_size=6*3},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}, {}}
}

cabs_table["kitchen_wooden_cabinet_with_two_doors"] = {
    ["kitchen_wooden_cabinet_with_two_doors_1"] = {
        {mode="closed", button = "kwc_with_two_doors1", img_button = "open_button.png"}
        
    },
    ["kitchen_wooden_cabinet_with_two_doors_2"] = {
        {mode="opened", button = "kwc_with_two_doors2", img_button = "close_button.png", listname = "kwc_with_two_doors2", inv_size=6*4},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}}
}

cabs_table["kitchen_wooden_cabinet_with_two_doors_and_drawer"] = {
    ["kitchen_wooden_cabinet_with_two_doors_and_drawer_1"] = {
        {mode="closed", button = "kwc_with_two_doors_and_drawer1_1", img_button = "open_button.png"},
        {mode="closed", button = "kwc_with_two_doors_and_drawer1_2", img_button = "open_button.png"},
        
    },
    ["kitchen_wooden_cabinet_with_two_doors_and_drawer_2"] = {
        {mode="opened", button = "kwc_with_two_doors_and_drawer2_1", img_button = "close_button.png", listname = "kwc_with_two_doors_and_drawer2_1", inv_size=6},
        {mode="closed", button = "kwc_with_two_doors_and_drawer2_2", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_with_two_doors_and_drawer_3"] = {
        {mode="closed", button = "kwc_with_two_doors_and_drawer3_1", img_button = "open_button.png"},
        {mode="opened", button = "kwc_with_two_doors_and_drawer3_2", img_button = "close_button.png", listname = "kwc_with_two_doors_and_drawer3_2", inv_size=6*3},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_with_two_doors_and_drawer_4"] = {
        {mode="opened", button = "kwc_with_two_doors_and_drawer4_1", img_button = "close_button.png", listname = "kwc_with_two_doors_and_drawer4_1", inv_size=6},
        {mode="opened", button = "kwc_with_two_doors_and_drawer4_2", img_button = "close_button.png", listname = "kwc_with_two_doors_and_drawer4_2", inv_size=6*3},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}, {}}
}

cabs_table["kitchen_wooden_half_cabinet"] = {
    ["kitchen_wooden_half_cabinet_1"] = {
        {mode="closed", button = "kwc_half1", img_button = "open_button.png"}
        
    },
    ["kitchen_wooden_half_cabinet_2"] = {
        {mode="opened", button = "kwc_half2", img_button = "close_button.png", listname = "kwc_half2", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}}
}

cabs_table["kitchen_wooden_threedrawer_cabinet"] = {
    ["kitchen_wooden_threedrawer_cabinet_1"] = {
        {mode="closed", button = "kwc_threedrawer1_1", img_button = "open_button.png"},
        {mode="closed", button = "kwc_threedrawer1_2", img_button = "open_button.png"},
        {mode="closed", button = "kwc_threedrawer1_3", img_button = "open_button.png"},
        
    },
    ["kitchen_wooden_threedrawer_cabinet_2"] = {
        {mode="opened", button = "kwc_threedrawer2_1", img_button = "close_button.png", listname = "kwc_threedrawer2_1", inv_size=6*2},
        {mode="closed", button = "kwc_threedrawer2_2", img_button = "open_button.png"},
        {mode="closed", button = "kwc_threedrawer2_3", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_threedrawer_cabinet_3"] = {
        {mode="closed", button = "kwc_threedrawer3_1", img_button = "open_button.png"},
        {mode="opened", button = "kwc_threedrawer3_2", img_button = "close_button.png", listname = "kwc_threedrawer3_2", inv_size=6*2},
        {mode="closed", button = "kwc_threedrawer3_3", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_threedrawer_cabinet_4"] = {
        {mode="closed", button = "kwc_threedrawer4_1", img_button = "open_button.png"},
        {mode="closed", button = "kwc_threedrawer4_2", img_button = "open_button.png"},
        {mode="opened", button = "kwc_threedrawer4_3", img_button = "close_button.png", listname = "kwc_threedrawer4_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_threedrawer_cabinet_5"] = {
        {mode="opened", button = "kwc_threedrawer5_1", img_button = "close_button.png", listname = "kwc_threedrawer5_1", inv_size=6*2},
        {mode="closed", button = "kwc_threedrawer5_2", img_button = "open_button.png"},
        {mode="opened", button = "kwc_threedrawer5_3", img_button = "close_button.png", listname = "kwc_threedrawer5_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_threedrawer_cabinet_6"] = {
        {mode="opened", button = "kwc_threedrawer6_1", img_button = "close_button.png", listname = "kwc_threedrawer6_1", inv_size=6*2},
        {mode="opened", button = "kwc_threedrawer6_2", img_button = "close_button.png", listname = "kwc_threedrawer6_2", inv_size=6*2},
        {mode="closed", button = "kwc_threedrawer6_3", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_threedrawer_cabinet_7"] = {
        {mode="closed", button = "kwc_threedrawer7_1", img_button = "open_button.png"},
        {mode="opened", button = "kwc_threedrawer7_2", img_button = "close_button.png", listname = "kwc_threedrawer7_2", inv_size=6*2},
        {mode="opened", button = "kwc_threedrawer7_3", img_button = "close_button.png", listname = "kwc_threedrawer7_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_threedrawer_cabinet_8"] = {
        {mode="opened", button = "kwc_threedrawer8_1", img_button = "close_button.png", listname = "kwc_threedrawer8_1", inv_size=6*2},
        {mode="opened", button = "kwc_threedrawer8_2", img_button = "close_button.png", listname = "kwc_threedrawer8_2", inv_size=6*2},
        {mode="opened", button = "kwc_threedrawer8_3", img_button = "close_button.png", listname = "kwc_threedrawer8_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}, {}, {}}
}

cabs_table["kitchen_wooden_cabinet_with_sink"] = {
    ["kitchen_wooden_cabinet_with_sink_1"] = {
        {mode="closed", button = "kwc_with_sink1", img_button = "open_button.png"}
        
    },
    ["kitchen_wooden_cabinet_with_sink_2"] = {
        {mode="opened", button = "kwc_with_sink2", img_button = "close_button.png", listname = "kwc_with_sink2", inv_size=3*3},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}}
}

cabs_table["fridge"] = {
    ["fridge_1"] = {
        {mode="closed", button = "fridge_closed", img_button = "open_button.png"}
        
    },
    ["fridge_2"] = {
        {mode="opened", button = "fridge_opened", img_button = "close_button.png", listname = "fridge_opened", inv_size=6*6},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}}
}
-- The loop is running the table above and register each cabinet sort.

for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_cabinet"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Two Drawers",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_two_drawers.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_cabinet_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button1 = "image_button[0.5, 0;1, 2;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            local img_button2 = "image_button[0.5, 3;1, 2;" .. cab_boxes[2].img_button .. ";" .. cab_boxes[2].button .. ";]"
            
            local y = 0
            local form = "size[9,10.5]" .. img_button1 .. img_button2 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_cabinet"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_cabinet"].inv_list[num][str_pos] = {}
                    end
                   if drawer.mode == "opened" then
                       local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";1.5,".. y .. ";6, 2]"
                       form = form .. list
                end
                end
                y= y+3
            end
            
            form = form .. "list[current_player;main;0.5,6.5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_cabinet"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Drawer", "open_Drawer"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Drawer", "close_Drawer"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
              
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
                    
        end
    })
  end
end


for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_cabinet_with_door"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Door",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_door.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_cabinet_with_door_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button = "image_button[0.5, 0.5;2, 4;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            
            local form = "size[9,10.5]" .. img_button 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_cabinet_with_door"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_cabinet_with_door"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";2.5, 0.5;6, 4]"
                   form = form .. list
                end
            end
            
            form = form .. "list[current_player;main;0.5,5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_cabinet_with_door"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Cabinet"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Cabinet"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end

for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_cabinet_with_door_and_drawer"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Door And Drawer",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_door_and_drawer.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_cabinet_with_door_and_drawer_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button1 = "image_button[0.5, 0;1, 2;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            local img_button2 = "image_button[0.5, 3;1, 3;" .. cab_boxes[2].img_button .. ";" .. cab_boxes[2].button .. ";]"
            
            local y = 0
            local y_size = 1
            local form = "size[9,11.5]" .. img_button1 .. img_button2 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_cabinet_with_door_and_drawer"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_cabinet_with_door_and_drawer"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";1.5,".. y .. ";6," .. y_size .."]"
                   form = form .. list
                end
                y= y+3
                y_size=y_size+2
            end
            
            form = form .. "list[current_player;main;0.5,6.5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_cabinet_with_door_and_drawer"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
	    end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Drawer", "open_Cabinet"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Drawer", "close_Cabinet"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end

for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_cabinet_with_two_doors"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Two Doors",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_two_doors.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_cabinet_with_two_doors_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button = "image_button[0.5, 0.5;2, 4;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            
            local form = "size[9,10.5]" .. img_button 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_cabinet_with_two_doors"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_cabinet_with_two_doors"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";2.5, 0.5;6, 4]"
                   form = form .. list
                end
            end
            
            form = form .. "list[current_player;main;0.5,5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_cabinet_with_two_doors"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Cabinet"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Cabinet"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end

for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_cabinet_with_two_doors_and_drawer"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Two Drawers And Drawer",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_two_doors_and_drawer.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_cabinet_with_two_doors_and_drawer_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button1 = "image_button[0.5, 0;1, 2;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            local img_button2 = "image_button[0.5, 3;1, 3;" .. cab_boxes[2].img_button .. ";" .. cab_boxes[2].button .. ";]"
            
            local y = 0
            local y_size = 1
            local form = "size[9,11.5]" .. img_button1 .. img_button2 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_cabinet_with_two_doors_and_drawer"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_cabinet_with_two_doors_and_drawer"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";1.5,".. y .. ";6," .. y_size .."]"
                   form = form .. list
                end
                y= y+3
                y_size=y_size+2
            end
            
            form = form .. "list[current_player;main;0.5,6.5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_cabinet_with_two_doors_and_drawer"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Drawer", "open_Cabinet"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Drawer", "close_Cabinet"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end

for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_half_cabinet"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Half-Cabinet",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_half_cabinet.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_half_cabinet_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, 0, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.04, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button = "image_button[0.5, 0.5;1, 2;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            
            local form = "size[9,8.5]" .. img_button 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_half_cabinet"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_half_cabinet"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";1.5, 0.5;6, 2]"
                   form = form .. list
                end
            end
            
            form = form .. "list[current_player;main;0.5,4;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_half_cabinet"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Drawer"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Drawer"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end

--cab_boxes is a cabinet sort with certain opened/closed drawers/shelves.
for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_threedrawer_cabinet"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Three Drawers",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_three_drawers.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_threedrawer_cabinet_1",
        groups = {choppy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button1 = "image_button[0.5, 0;1, 2;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            local img_button2 = "image_button[0.5, 2.5;1, 2;" .. cab_boxes[2].img_button .. ";" .. cab_boxes[2].button .. ";]"
            local img_button3 = "image_button[0.5, 5;1, 2;" .. cab_boxes[3].img_button .. ";" .. cab_boxes[3].button .. ";]"
            
            local y = 0
            local form = "size[9,11.5]" .. img_button1 .. img_button2 .. img_button3
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_threedrawer_cabinet"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_threedrawer_cabinet"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";1.5,".. y .. ";6, 2]"
                   form = form .. list
                end
                y= y+2.5
            end
            
            form = form .. "list[current_player;main;0.5,7.5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = minetest.get_inventory({type="node", pos={x=pos.x, y=pos.y, z=pos.z}})
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_threedrawer_cabinet"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Drawer", "open_Drawer", "open_Drawer"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Drawer", "close_Drawer", "close_Drawer"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
              
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
                    
        end
    })
  end
end

for cab, cab_boxes in pairs(cabs_table["kitchen_wooden_cabinet_with_sink"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet With Sink",
        visual_scale = 0.5,
        inventory_image = "kitchen_wooden_cabinet_with_sink.png",
        mesh = cab..".b3d",
        tiles = {"simple_kitchen_cabinet_with_sink.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:kitchen_wooden_cabinet_with_sink_1",
        groups = {choppy=3, snappy=2, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.25, 0.5},
                {-0.5, 0.25, -0.5, -0.4, 0.5, 0.5},
                {0.4, 0.25, -0.5, 0.5, 0.5, 0.5},
                {-0.4, 0.25, -0.5, 0.4, 0.5, -0.4},
                {-0.4, 0.25, 0.4, 0.4, 0.5, 0.5}
            },
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.25, 0.5},
                {-0.5, 0.25, -0.5, -0.4, 0.5, 0.5},
                {0.4, 0.25, -0.5, 0.5, 0.5, 0.5},
                {-0.4, 0.25, -0.5, 0.4, 0.5, -0.4},
                {-0.4, 0.25, 0.4, 0.4, 0.5, 0.5}
            },
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button = "image_button[0.5, 0.5;2, 3;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            
            local form = "size[9,8.5]" .. img_button 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["kitchen_wooden_cabinet_with_sink"].inv_list[num][str_pos] then
                       cabs_table["kitchen_wooden_cabinet_with_sink"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";2.5, 0.5;3, 3]"
                   local trash_button = "button[2.5, 3.5;3, 1;kwc_trash;Trash Items]"
                   form = form .. list .. trash_button
                end
            end
            
            form = form .. "list[current_player;main;0.5,4.5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["kitchen_wooden_cabinet_with_sink"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            if fields["kwc_trash"] then
                local meta = minetest.get_meta(pos)
                local inv = meta:get_inventory()
                local list = inv:get_list("kwc_with_sink2")
                local stacks_list = {}
                for num, stack in pairs(list) do
                    stacks_list[num] = stack:get_name()
                end
                for num, item in pairs(list) do
                    if inv:get_stack("kwc_with_sink2", num) ~= "" or inv:get_stack("kwc_with_sink2", num) ~= nil then
                        inv:set_stack("kwc_with_sink2", num, "")
                    end
                    
                end
                local list2 = meta:get_inventory():get_list("kwc_with_sink2")
                local stacks_list2 = {}
                for num, stack in pairs(list2) do
                    stacks_list2[num] = stack:get_name()
                end
                return true
            end
            
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
		minetest.debug(button_name)
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"open_Cabinet"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"close_Cabinet"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end

minetest.register_node("luxury_decor:kitchen_tap_off", {
    description = "Kitchen Tap (off)",
    visual_scale = 0.5,
    mesh = "kitchen_tap_off.b3d",
    inventory_image = "kitchen_tap_inv.png",
    tiles = {"kitchen_tap.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {snappy=1.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.05, -0.5, 0.37, 0.05, -0.25, 0.47}
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.05, -0.5, 0.37, 0.05, -0.25, 0.47}
        }
    },
    sounds = default.node_sound_metal_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        minetest.set_node(pos, {name="luxury_decor:kitchen_tap_on", param1 = node.param1, param2=node.param2})
    end
})

local elapsed_num = 0
local particles_list = {}
minetest.register_node("luxury_decor:kitchen_tap_on", {
    description = "Kitchen Tap (on)",
    visual_scale = 0.5,
    mesh = "kitchen_tap_on.b3d",
    inventory_image = "kitchen_tap_inv.png",
    tiles = {"kitchen_tap.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    drop = "luxury_decor:kitchen_tap_off",
    groups = {snappy=1.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.05, -0.5, 0.37, 0.05, -0.25, 0.47},
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.05, -0.5, 0.37, 0.05, -0.25, 0.47}
        }
    },
    sounds = default.node_sound_metal_defaults(),
    on_construct = function (pos)
        local param2 = minetest.get_node(pos).param2
        local min_pos = {x=pos.x, y=pos.y-0.34, z=pos.z}
        local max_pos = {x=pos.x, y=pos.y-0.34, z=pos.z}
        local vector = minetest.facedir_to_dir(param2)
        for axle, val in pairs(vector) do
            if val ~= 0 then
                if vector[axle] < 0 then
                    min_pos[axle] = min_pos[axle] - 0.07
                    max_pos[axle] = max_pos[axle] - 0.08
                elseif vector[axle] > 0 then
                    min_pos[axle] = min_pos[axle] + 0.07
                    max_pos[axle] = max_pos[axle] + 0.08
                end
            elseif val == 0 and axle ~= y then
                min_pos[axle] = min_pos[axle] - 0.02
                max_pos[axle] = max_pos[axle] + 0.03
            end
        end
        
        local timer = minetest.get_node_timer(pos)
        local timeout = math.random(20, 35)
        local elapsed = timeout / 2
        timer:set(timeout, elapsed)
        timer:start(timeout)
        for i = 1, 5 do
            local particle_id = minetest.add_particlespawner({
                amount=45,
                time=0,
                minpos=min_pos,
                maxpos=max_pos,
                minvel={x=0, y=-0.6, z=0},
                maxvel={x=0, y=-0.9, z=0},
                minacc={x=0, y=-0.7,z=0},
                maxacc={x=0, y=-0.10, z=0},
                minexptime=3,
                maxexptime=6,
                minsize=0.1,
                maxsize=0.4,
                collisiondetection=true,
                collision_removal=true,
                object_collision=true,
                vertical=true,
                texture="default_water.png"
            })
            particles_list[i] = particle_id
        end
        handle = minetest.sound_play("tap_on", {
            pos = pos,
            max_hear_distance = 15,
            loop = true,
        })
    end,
    on_timer = function (pos, elapsed)
        local nodes = minetest.find_nodes_in_area({x=pos.x, y=pos.y-0.5, z=pos.z}, {x=pos.x, y=pos.y-20.5, z=pos.z}, {"air"})
        for _, node_pos in ipairs(nodes) do
            if minetest.get_node(node_pos).name == "air" then
                if minetest.get_node({x=node_pos.x, y=node_pos.y-1, z=node_pos.z}).name ~= "air" then
                    minetest.set_node(node_pos, {name="default:water_flowing"})
                end
            elseif minetest.get_node(node_pos).name == "default:water_flowing" then
                minetest.set_node(node_pos, {name="default:water_source"})
            end
        end
    end,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local timer = minetest.get_node_timer(pos)
        timer:stop()
        minetest.sound_stop(handle)
        for _, particle_id in ipairs(particles_list) do
            minetest.delete_particlespawner(particle_id)
        end
        minetest.set_node(pos, {name="luxury_decor:kitchen_tap_off", param1 = node.param1, param2=node.param2})
    end,
    after_destruct = function (pos, oldnode)
        minetest.sound_stop(handle)
        for _, particle_id in ipairs(particles_list) do
            minetest.delete_particlespawner(particle_id)
        end
    end
})

for cab, cab_boxes in pairs(cabs_table["fridge"]) do
  if cab ~= "inv_list" then
    minetest.register_node("luxury_decor:"..cab, {
        description = "Fridge",
        visual_scale = 0.5,
        inventory_image = "fridge_inv.png",
        mesh = cab..".b3d",
        tiles = {"fridge.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:fridge_1",
        groups = {snappy=3, not_in_creative_inventory = cab_boxes["not_in_creative_inventory"]},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.6, 0.5},
                {-0.5, 0.6, -0.435, 0.5, 1.99, 0.5}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0.6, 0.5},
                {-0.5, 0.6, -0.435, 0.5, 1.99, 0.5}
            }
        },
        sounds = default.node_sound_wood_defaults(),
        on_construct = function (pos)
            local name = minetest.get_node(pos).name
            local img_button = "image_button[0.5, 0.5;3, 6;" .. cab_boxes[1].img_button ..";" .. cab_boxes[1].button .. ";]"
            
            local form = "size[10,11.5]" .. img_button 
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["fridge"].inv_list[num][str_pos] then
                       cabs_table["fridge"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";3.5, 0.5;6, 6]"
                   form = form .. list
                end
            end
            
            form = form .. "list[current_player;main;1,7;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(cab_boxes) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(cab_boxes[num2].listname, cabs_table["fridge"].inv_list[num2][str_pos])
                    inv:set_size(cab_boxes[num2].listname, cab_boxes[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(cab_boxes) do
                if type(drawer) == "table" then
                    local name = drawer.button
                    if fields[name] then
                        button_name = name
                        break
                    end
                end
            end
            
            if defined_mode == "closed" then
               cabinets.open(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"doors_steel_door_open"})
            elseif defined_mode == "opened" then
               cabinets.close(pos, "luxury_decor:" .. cabinets.define_needed_cabinet(fields, name), button_name, meta:get_string("formspec"), {"doors_steel_door_close"})
            end
            
                   
        end,
        after_dig_node = function (pos, oldnode, oldmetadata, digger)
            local name = string.sub(oldnode.name, 14)
            local generalized_name = string.sub(name, 1, -3)
            
            if cabs_table[generalized_name][name] then
                for num, drawer_lists in pairs(cabs_table[generalized_name].inv_list) do
                    for cab_pos, drawer_list in pairs(drawer_lists) do
                        local str_pos = tostring(pos.x) .. "," .. tostring(pos.y) .. "," .. tostring(pos.z)
                        if cab_pos == str_pos then
                            cabs_table[generalized_name].inv_list[num][cab_pos] = nil
                        end
                    end
                end
            end
            
        end
    })
  end
end
minetest.register_node("luxury_decor:cooker", {
    description = "Cooker",
    visual_scale = 0.5,
    mesh = "cooker.obj",
    inventory_image = "cooker_inv.png",
    tiles = {"cooker.png"},
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky=3.5},
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
    sounds = default.node_sound_stone_defaults()--[[,
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)]]
        
})

minetest.register_craftitem("luxury_decor:wooden_drawer", {
        description = "Wooden Drawer",
        inventory_image = "wooden_drawer.png",
        stack_max = 99
})

minetest.register_craft({
    output = "luxury_decor:wooden_drawer",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "", ""},
        {"default:stick", "", ""}
    }
})
                        
minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_cabinet_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""},
        {"luxury_decor:wooden_board", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_cabinet_with_door_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "", ""},
        {"luxury_decor:wooden_board", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_cabinet_with_door_and_drawer_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_cabinet_with_two_doors_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_cabinet_with_two_doors_and_drawer_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_board", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_half_cabinet_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""},
        {"luxury_decor:wooden_board", "", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_threedrawer_cabinet_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""},
        {"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_wooden_cabinet_with_sink_1",
    recipe = {
        {"luxury_decor:wooden_board", "luxury_decor:siphon", "dye:grey"},
        {"luxury_decor:wooden_board", "luxury_decor:plastic_sheet", ""},
        {"luxury_decor:wooden_board", "default:steel_ingot", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:fridge_closed",
    recipe = {
        {"default:steelblock", "luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet"},
        {"luxury_decor:brass_ingot", "luxury_decor:plastic_sheet", ""},
        {"dye:dark_grey", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:kitchen_tap_off",
    recipe = {
        {"luxury_decor:plastic_sheet", "luxury_decor:brass_ingot", ""},
        {"default:steel_ingot", "", ""},
        {"", "", ""}
    }
})

minetest.register_craft({
    output = "luxury_decor:cooker",
    recipe = {
        {"default:steel_ingot", "luxury_decor:plastic_sheet", "xpanes:pane_flat"},
        {"default:steel_ingot", "luxury_decor:plastic_sheet", ""},
        {"default:steel_ingot", "luxury_decor:brass_stick", ""}
    }
})
