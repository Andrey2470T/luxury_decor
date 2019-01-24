cabinets = {}
cabs_table = {}

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
    
    meta:set_string(formspec["name"], formspec["data"])
    return true
end

--[[Arguments:
*opener - player data;
*pos - position of clicked node;
*node_replace - itemstring, node that needed to be replaced to former.
*cabinet_name - "generalized" name of all its components, that is kitchen_wooden_cabinet_1, kitchen_wooden_cabinet_2, kitchen_wooden_cabinet_3 are kitchen_wooden_cabinet indeed, they are just modified models;
*clicked_button_name - name of button that was clicked;
*formspec - table with next keys: name, data (formspec string itself);
*sound_play - table that can keep ONLY two sound names that needed to be played during opening and closing. Keys are: first is "open", second is "close".]]
cabinets.open = function (opener, pos, node_replace, cabinet_name, clicked_button_name, formspec, sound_play)
    local node = minetest.get_node(pos)
    local name = node.name
    local meta = minetest.deserialize(minetest.get_meta(pos):get_string(name))
    
    -- The lower loop is running departments of the node as kitchen_wooden_cabinet_1... then it compares clicked_button_name is equal to the button name in the department.
    for depart_num, depart_data in pairs(meta) do
        if meta[depart_num]["button"] == clicked_button_name then
            changed_part_data = meta
            
            -- Onwards it determines the department is "opened" or "closed", if "closed" sets opposite to this mode in changed_depart_data, else returns nil.
            if meta[depart_num]["mode"] == "closed" then
                changed_part_data[depart_num]["mode"] = "opened"
            elseif meta[depart_num]["mode"] == "opened" then
                return
            end
            
            -- Here the loop is running cabs_table[name] table where "name" is "general" node name of all its "departments", then it`s running each "department" and comparing modes with mode of "changed_depart_data".
            -- (To the comment above) comparing modes is needed to determine which registered part of general node contains departments with same modes.
            for node_name, node_data in pairs(cabs_table[cabinet_name][name]) do
                for depart_num2, depart_data2 in pairs(node_data) do
                    if node_data[depart_num2]["mode"] == changed_part_data[depart_num2]["mode"] then
                        -- For success it copies inventory list of the department and put to corresponding one of changed_
                        changed_part_data[depart_num2]["inv_list"] = node_data[depart_num2]["inv_list"]
                    else
                        return
                    end
                    
                end
                
            end
        end
        
        
    end
            
    minetest.remove_node(pos)
    minetest.set_node(pos, {name=node_replace, param1=node.param1, param2 = node.param2})
            
    if sound_play and sound_play["open"] then
        minetest.sound_play(sound_play["open"])
    end
            
    local new_meta = minetest.get_meta(pos)
    new_meta:set_string(formspec["name"], formspec["data"])
    
    local inv = minetest.get_inventory({type = "node", name = pos})
    local lists = inv:get_lists()
    
    for _, depart_data in ipairs(changed_part_data) do
        inv:set_list(depart_data["listname"], depart_data["inv_list"])
        if depart_data["mode"] == "opened" then
            inv:set_size(depart_data["listname"], depart_data["inv_size"])
        end
    end
        
    minetest.show_formspec(opener:get_player_name(), node_replace, formspec[name])
end


cabinets.close = function (closer, pos, node_replace, cabinet_name, clicked_button_name, formspec, sound_play)
    local node = minetest.get_node(pos)
    local name = node.name
    local meta = minetest.deserialize(minetest.get_meta(pos):get_string(name))
    
    -- The lower loop is running departments of the node as kitchen_wooden_cabinet_1... then it compares clicked_button_name is equal to the button name in the department.
    for depart_num, depart_data in pairs(meta) do
        if meta[depart_num]["button"] == clicked_button_name then
            changed_part_data = meta
            
            -- Onwards it determines the department is "opened" or "closed", if "closed" sets opposite to this mode in changed_depart_data, else returns nil.
            if meta[depart_num]["mode"] == "opened" then
                changed_part_data[depart_num]["mode"] = "closed"
            elseif meta[depart_num]["mode"] == "closed" then
                return
            end
            
            -- Here the loop is running cabs_table[name] table where "name" is "general" node name of all its "departments", then it`s running each "department" and comparing modes with mode of "changed_depart_data".
            -- (To the comment above) comparing modes is needed to determine which registered part of general node contains departments with same modes.
            for node_name, node_data in pairs(cabs_table[cabinet_name][name]) do
                for depart_num2, depart_data2 in pairs(node_data) do
                    if node_data[depart_num2]["mode"] == changed_part_data[depart_num2]["mode"] then
                        -- For success it copies inventory list of the department and put to corresponding one of changed_
                        changed_part_data[depart_num2]["inv_list"] = node_data[depart_num2]["inv_list"]
                    else
                        return
                    end
                    
                end
                
            end
        end
        
        
    end
            
    minetest.remove_node(pos)
    minetest.set_node(pos, {name=node_replace, param1=node.param1, param2=node.param2})
            
    if sound_play and sound_play["close"] then
        minetest.sound_play(sound_play["close"])
    end
            
    local new_meta = minetest.get_meta(pos)
    new_meta:set_string(formspec["name"], formspec["data"])
    
    local inv = minetest.get_inventory({type = "node", name = pos})
    local lists = inv:get_lists()
    
    for _, depart_data in ipairs(changed_part_data) do
        inv:set_list(depart_data["listname"], depart_data["inv_list"])
        if depart_data["mode"] == "opened" then
            inv:set_size(depart_data["listname"], depart_data["inv_size"])
        end
    end
        
    minetest.show_formspec(closer:get_player_name(), node_replace, formspec[name])
end
                
                
cabinets.define_needed_cabinet = function (formname, nodename)
    for _, depart in ipairs(kit_wood_cabs[nodename]) do
        if depart["button"] == formname then
            modes = {}
            for _, depart2 in ipairs(kit_wood_cabs[name]) do
                modes[#modes+1] = depart2["mode"]
            end
            break
        end
    end
    for name, cab in pairs(kit_wood_cabs) do
        local mode_num = 0
        for name2, depart in ipairs(cab) do
            mode_num = mode_num + 1
            if modes[mode_num] == depart["mode"] then
                if modes[mode_num] == #modes then
                    return name2
                end
            end
        end
    end
end

cabinets.define_mode = function (formname, nodename)
    for _, depart in ipairs(kit_wood_cabs[nodename]) do
        if depart["button"] == formname then
            return depart["mode"]
        end
    end
end

minetest.register_on_joinplayer(function (player)
    minetest.debug(dump(cabinets))
end)
-- Create a table with external table for each cabinet sort (depends to boxes). Inside each second field a list of boxes and their datas.

kit_wood_cabs = {
    ["kitchen_wooden_cabinet_1"] = {
        --form_size="",
        {mode="closed", button = "kwc1_1", img_button = "close_button.png", listname = "kwc1_1", inv_list={}},
        {mode="closed", button = "kwc1_2", img_button = "close_button.png", listname = "kwc1_2", inv_list={}}
        
    },
    ["kitchen_wooden_cabinet_2"] = {
        --form_size="",
        {mode="opened", button = "kwc2_1", img_button = "open_button.png", listname = "kwc2_1", inv_list={}, inv_size=4*2},
        {mode="closed", button = "kwc2_2", img_button = "close_button.png", listname = "kwc2_2", inv_list={}},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_3"] = {
        --form_size="",
        {mode="closed", button = "kwc3_1", img_button = "close_button.png", listname = "kwc3_1", inv_list={}},
        {mode="opened", button = "kwc3_2", img_button = "open_button.png", listname = "kwc3_2", inv_list={}, inv_size=4*2},
        not_in_creative_inventory=1
        
    },
    ["kitchen_wooden_cabinet_4"] = {
        --form_size="",
        {mode="opened", button = "kwc4_1", img_button = "open_button.png", listname = "kwc4_1", inv_list={}, inv_size=4*2},
        {mode="opened", button = "kwc4_2", img_button = "open_button.png", listname = "kwc4_2", inv_list={}, inv_size=4*2},
        not_in_creative_inventory=1
        
    }
}
if not cabs_table["kitchen_wooden_cabinet"] then
    cabs_table["kitchen_wooden_cabinet"] = kit_wood_cabs
end
                
-- The loop is running the table above and register each cabinet sort.

local cabinet_num = 0
local form
for cab, cab_boxes in pairs(kit_wood_cabs) do
    cabinet_num = cabinet_num + 1
    minetest.register_node("luxury_decor:"..cab, {
        description = "Kitchen Wooden Cabinet",
        visual_scale = 0.5,
        mesh = cab..".obj",
        tiles = {"wood_material.png"},
        paramtype = "light",
        paramtype2 = "facedir",
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
            local list1 = "list[nodemeta:".. pos.x .. "," .. pos.y .. "," .. pos.z .. ";".. cab_boxes[1].listname .. ";1.5, 0;4, 2]"
            local list2 = "list[nodemeta:".. pos.x .. "," .. pos.y .. "," .. pos.z .. ";".. cab_boxes[2].listname .. ";1.5, 1;4, 2]"                                                           
            form = "size[6,10]" .. img_button1 .. img_button2 .. list1 .. list2 .. "]"
            --minetest.debug(dump(cabinets))
            cabinets.put_data_into_cabinet(pos, "kitchen_wooden_cabinet", tostring(cabinet_num), cab_boxes, {name=name, data=form})
            local inv = minetest.get_inventory({type="node", pos=pos})
            inv:set_list(cab_boxes[1].listname, cab_boxes[1].inv_list)
            inv:set_list(cab_boxes[2].listname, cab_boxes[2].inv_list)
            inv:set_size(cab_boxes[1].listname, cab_boxes[1].inv_size or 0)
            inv:set_size(cab_boxes[2].listname, cab_boxes[2].inv_size or 0)
            minetest.debug(dump(inv:get_list(cab_boxes[1].listname)))
            minetest.debug(dump(inv:get_list(cab_boxes[2].listname)))
            -- Fills "form_size" of each cabinet with needed size and "form_data" of each box with datas to build formspec with lists.
            --[[for cab2, cab_boxes2 in pairs(kit_wood_cabs) do
                cab_boxes2[cab2][form_size] = "size[8,4]"
                for box_num, cab_data in ipairs(cab_boxes2[2]) do
                    cab_data[box_num][form_data] = inv_elems[1] .. "0.2, 0.1;0.5, 2" .. inv_elems[2] 
                    if cab_data[
                end
            end]]
        end,
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            minetest.show_formspec(clicker:get_player_name(), cab, form)  
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            minetest.debug("AAAAAAAAAAAAAAAAAAA")
            local name = minetest.get_node(pos).name
            local generalized_name = string.match(name, '^._-')
            
            --[[for _, depart in ipairs(kit_wood_cabs[name]) do
               if depart[button] == formname then
                  if depart[mode] == "closed" then
                     for _, depart2 in ipairs(kit_wood_cabs) do
                        if ]]
            local defined_mode = cabinets.define_mode(formname, name)
            if defined_mode == "closed" then
               cabinets.open(sender, pos, cabinets.define_needed_cabinet(formname, name), generalized_name, formname, form)
            elseif defined_mode == "opened" then
               cabinets.close(sender, pos, cabinets.define_needed_cabinet(formname, name), generalized_name, formname, form)
            end
            
                   
        end
    })
end



--[[Arguments:
    *cabinet - table that contains name and position of the cabinet
    *cabinet_boxes_data - table with cabinet data in what are names of cabinets are set in-world, position of each cabinet and their boxes datas, their modes ("opened"/"closed") and inventory formspecs.
 ]]
--[[cabinets_funcs.put_data_into_cabinet = function (cabinet, cabinet_boxes_data)
    local name = cabinet[1]
    if not cabinets[name] then
        cabinets[name] = {}
    end
    
    local pos = cabinet[2]
    cabinets[name][pos] = {}
    
    for box_name, box in pairs(cabinet_boxes_data) do
        local box = cabinet_boxes_data[box_name]
        cabinets[name][pos][box_name] = box
        local meta = minetest.get_meta(cabinets[name][pos][box_name][2])
        meta:set_string("inventory", cabinets[name][pos][box_name][4])
        --minetest.debug(dump(cabinet_boxes_data[box_name][2]))
        --minetest.debug(dump(cabinet_boxes_data[box_name][1].name))
        minetest.set_node(cabinet_boxes_data[box_name][2], cabinet_boxes_data[box_name][1])
        --minetest.debug("DGSDGDSGFDSGSFDGSDGSD")
        local box_meta = minetest.get_meta(cabinet_boxes_data[box_name][2])
        box_meta:set_string(cabinet_boxes_data[box_name][1].name, minetest.serialize({cabinet[1], cabinet[2]}))
        --minetest.debug("DDDDDDDDDDDD")
    end
    
    minetest.debug(dump(cabinets[name][pos]))
end
    
        
Arguments:
    *opener - Player
    *cabinet - table that contains name and position of the cabinet
    *cabinets_data - table that contains "name" field of the cabinet inside "pos" field of each set the cabinet in-world and its data (list of boxes inside)
    *cabinet_box - table that contains data of clicked box (name, itemstring, pos, mode and inv)
    *offset - table with coordinates (x, y, z) that means how many coordinate points this is needed to offset
    *formspec - table that contains listname, itemstacks_list, formname and formspec itself]]
--[[cabinets_funcs.open = function (opener, cabinet, cabinets_data, cabinet_box, offset, formspec)
    local name = cabinet[1]
    local pos = cabinet[3]
    local cabinet_box_name = cabinet_box[1]
    if cabinets_data[name] then
        if cabinets_data[pos] then
            --for _, box in ipairs(cabinets_data[pos]) do
            local inv = minetest.get_inventory({type="node", pos = pos})
            local lists = inv:get_lists()
            local list = lists[1]
            cabinets[name][pos][cabinet_box_name][4] = {formspec[1], formspec[2], formspec[3], formspec[4]}
            cabinets[name][pos][cabinet_box_name][3] = "opened"
            --cabinets_data[cabinet_pos][cabinet_box[2] .. tostring(#cabinets_data[cabinet_pos])][3] = list
            --cabinets_data[cabinet_pos][cabinet_box[2] .. tostring(#cabinets_data[cabinet_pos])][4] = formspec_data_field
            minetest.remove_node(cabinet_box[2])
            local new_pos = {x=pos.x + offset.x, y=pos.y + offset.y, z=pos.z + offset.z}
            cabinets[name][pos][cabinet_box_name][2] = new_pos
            minetest.set_node(new_pos, cabinet_box[2])
            
            local meta = minetest.get_meta(new_pos)
            meta:set_string("inventory", cabinets[name][pos][cabinet_box_name][4][4])
            local new_inv = minetest.get_inventory({type="node", pos=new_pos})
            local new_lists = new_inv:get_lists()
            local new_list = new_lists[1]
            
            for _, itemstack in ipairs(new_list) do
                new_inv:add_item(cabinets[name][pos][cabinet_box_name][4][1], itemstack:get_count())
            end
            
            minetest.show_formspec(opener, cabinets[name][pos][cabinet_box_name][4][3], cabinets[name][pos][cabinet_box_name][4][4])
        end
    end
end]]

--[[Arguments:
    *Same ones as for cabinets_funcs.open(), expect "offset" where should be new position for new node placing]]
--[[cabinets_funcs.close = function (closer, cabinet, cabinets_data, cabinet_box, offset)
    local name = cabinet[1]
    local pos = cabinet[2]
    local cabinet_box_name = cabinet_box[1]
    local inv = minetest.get_inventory({type="node", pos=pos})
    local lists = inv:get_lists()
    local list = lists[1]
    
    cabinets[name][pos][cabinet_box_name][4][2] = list
    cabinets[name][pos][cabinet_box_name][3] = "closed"
    
    minetest.remove_node(cabinet_box[2])
    local new_pos = {x=pos.x + offset.x, y=pos.y + offset.y, z=pos.z + offset.z}
    cabinets[name][pos][cabinet_box_name][1] = new_pos
    minetest.add_node(new_pos, cabinet_box[2])
end
            
        
        
minetest.register_node("luxury_decor:kitchen_wooden_cabinet", {
    description = "Kitchen Wooden Cabinet",
    visual_scale = 0.5,
    mesh = "kitchen_wooden_cabinet.obj",
    tiles = {"wood_material.png"},
    --inventory_image = "simple_wooden_table_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3.5},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, -0.4, 0.5, 0.5}, -- Left nodebox
            {0.4, -0.5, -0.5, 0.5, 0.5, 0.5}, -- Right nodebox
            {-0.4, 0.4, -0.5, 0.5, 0.5, 0.5}, -- Upper nodebox
            {-0.4, -0.5, -0.6, 0.4, -0.4, 0.5}, -- Downer nodebox
            {-0.4, -0.4, 0.5, 0.4, -0.4, 0.4}, -- Back nodebox
            {-0.4, -0.05, -0.5, 0.4, 0.05, 0.4}, -- Shelf Nodebox
            
            
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.415, -0.415, -0.45, -0.5, 0.42, 0.45}, -- Left nodebox
            {0.415, -0.415, -0.45, 0.5, 0.42, 0.45}, -- Right nodebox
            {-0.5, 0.42, -0.45, 0.5, 0.5, 0.45}, -- Upper nodebox
            {-0.5, -0.42, -0.45, 0.5, -0.5, 0.45}, -- Downer nodebox
            {-0.45, -0.42, 0.37, 0.45, 0.42, 0.45}, -- Back nodebox
            {-0.41, -0.037, -0.45, 0.41, 0.037, 0.45}, -- Shelf Nodebox
            
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_construct = function (pos)
        local name = minetest.get_node(pos).name
        local cabinet_data = {
            {minetest.get_node(pos).name, pos},
            --{"box1", "box2"},
            {
                ["box1"] = {   
                    {
                        name="luxury_decor:kitchen_wooden_cabinet_box",
                        param1 = minetest.get_node(pos).param1,
                        param2 = minetest.get_node(pos).param2
                    },
                    {x=pos.x, y=pos.y+0.25, z=pos.z},
                    "closed",
                    "box_inventory[{"..pos.x..","..pos.y..","..pos.z.."}]", "size[8, 4][nodemeta:"..pos.x..",".. pos.y+0.25 ..","..pos.z..";main;0, 1;8, 3]list[current_player;main;0, 5;8, 3]"
                    
                },
                ["box2"] = {   
                    {
                        name="luxury_decor:kitchen_wooden_cabinet_box",
                        param1 = minetest.get_node(pos).param1,
                        param2 = minetest.get_node(pos).param2
                    },
                    {x=pos.x, y=pos.y-0.25, z=pos.z},
                    "closed",
                    "box_inventory[{"..pos.x..","..pos.y..","..pos.z.."}]", "size[8, 4][nodemeta:"..pos.x..",".. pos.y-0.25 ..","..pos.z..";main;0, 1;8, 3]list[current_player;main;0, 5;8, 3]"
                }
            }
        }
        cabinets_funcs.put_data_into_cabinet(cabinet_data[1], cabinet_data[2])
        local name = minetest.get_node(pos).name
        if not cabinets[name] then
            cabinets[name] = {}
        end
        
        cabinets[name][pos] = {}
        cabinets[name][pos][ = {{x=pos.x, y=pos.y+0.25, z=pos.z}, "closed"}
        kitchen_wooden_cabinets[pos]["box2"] = {{x=pos.x, y=pos.y-0.25, z=pos.z}, "closed"}
        
        minetest.add_node({x=pos.x, y=pos.y+0.25, z=pos.z}, "luxury_decor:kitchen_wooden_cabinet_box")
        minetest.add_node({x=pos.x, y=pos.y-0.25, z=pos.z}, "luxury_decor:kitchen_wooden_cabinet_box")
    end
        
}) 

minetest.register_node("luxury_decor:kitchen_wooden_cabinet_box", {
    description = "Kitchen Wooden Cabinet Box",
    visual_scale = 0.5,
    mesh = "kitchen_wooden_cabinet_box.obj",
    tiles = {"wood_material.png"},
    --inventory_image = "simple_wooden_table_inv.png",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {choppy = 3.5, not_in_creative_inventory=1},
    drawtype = "mesh",
    collision_box = {
        type = "fixed",
        fixed = {
            {-0.45, 0.05, -0.475, 0.45, 0.43, 0.48},
        }
    },
    selection_box = {
        type = "fixed",
        fixed = {
            {-0.45, 0.05, -0.475, 0.45, 0.43, 0.48},
        }
    },
    sounds = default.node_sound_wood_defaults(),
    on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        --minetest.debug(meta[1])
        --minetest.debug(meta[2])
        local cabinet_name, cabinet_pos = meta:get_string(meta[1]), meta:get_string(meta[2])
        
        if cabinet_name ~= nil or cabinet_name ~= "" then
           local cabinet_data = cabinets[cabinet_name][cabinet_pos]
           for box_name, box in ipairs(cabinet_data) do
              if cabinet_data[box_name][1].name == node.name then
                 local cabinet = {meta[1], meta[2]}
                 local cabinet_box = {box_name, cabinet_data[box_name][1].name, cabinet_data[box_name][2], cabinet_data[box_name][3], cabinet_data[box_name][4]}
                 local offset = {x=0, y=0, z=-0.7}
                 cabinets_funcs.open(clicker:get_player_name(), cabinet, cabinets, cabinet_box, offset, {"main", {}, "box_formspec", cabinets_data[box_name][4][4]})
                 
                 break
              end
           end
        end
    end,
    
    on_receive_fields = function (pos, formname, fields, sender)
        if fields.quit then
           local meta = minetest.get_meta(pos)
           local cabinet_name, cabinet_pos, cabinet_data = meta:get_string(meta[1]), meta:get_string(meta[2]), cabinets[cabinet_name][cabinet_pos]
           for box_name, box in ipairs(cabinet_data) do
              if cabinet_data[box_name][1].name == node.name then
                  local cabinet_box = {box_name, cabinet_data[box_name][1].name, cabinet_data[box_name][2], cabinet_data[box_name][3], cabinet_data[box_name][4]}
                  
                  cabinets_funcs.close(sender:get_player_name(), {meta[1], meta[2]}, cabinets, cabinet_box, offset)
                    
                  break
              end
           end
        end
    end        
})]]

minetest.register_node("luxury_decor:cooker", {
    description = "Cooker",
    visual_scale = 0.5,
    mesh = "cooker.obj",
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
    sounds = default.node_sound_stone_defaults()
})
