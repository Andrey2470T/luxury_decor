cabs_table["simple_wooden_bedside_table"] = {
    ["simple_wooden_bedside_table_1"] = {
        {mode="closed", button = "sw_bedt1_1", img_button = "open_button.png"},
        {mode="closed", button = "sw_bedt1_2", img_button = "open_button.png"},
        {mode="closed", button = "sw_bedt1_3", img_button = "open_button.png"},
        
    },
    ["simple_wooden_bedside_table_2"] = {
        {mode="opened", button = "sw_bedt2_1", img_button = "close_button.png", listname = "sw_bedt2_1", inv_size=6*2},
        {mode="closed", button = "sw_bedt2_2", img_button = "open_button.png"},
        {mode="closed", button = "sw_bedt2_3", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["simple_wooden_bedside_table_3"] = {
        {mode="closed", button = "sw_bedt3_1", img_button = "open_button.png"},
        {mode="opened", button = "sw_bedt3_2", img_button = "close_button.png", listname = "sw_bedt3_2", inv_size=6*2},
        {mode="closed", button = "sw_bedt3_3", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["simple_wooden_bedside_table_4"] = {
        {mode="closed", button = "sw_bedt4_1", img_button = "open_button.png"},
        {mode="closed", button = "sw_bedt4_2", img_button = "open_button.png"},
        {mode="opened", button = "sw_bedt4_3", img_button = "close_button.png", listname = "sw_bedt4_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["simple_wooden_bedside_table_5"] = {
        {mode="opened", button = "sw_bedt5_1", img_button = "close_button.png", listname = "sw_bedt5_1", inv_size=6*2},
        {mode="closed", button = "sw_bedt5_2", img_button = "open_button.png"},
        {mode="opened", button = "sw_bedt5_3", img_button = "close_button.png", listname = "sw_bedt5_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["simple_wooden_bedside_table_6"] = {
        {mode="opened", button = "sw_bedt6_1", img_button = "close_button.png", listname = "sw_bedt6_1", inv_size=6*2},
        {mode="opened", button = "sw_bedt6_2", img_button = "close_button.png", listname = "sw_bedt6_2", inv_size=6*2},
        {mode="closed", button = "sw_bedt6_3", img_button = "open_button.png"},
        not_in_creative_inventory=1
        
    },
    ["simple_wooden_bedside_table_7"] = {
        {mode="closed", button = "sw_bedt7_1", img_button = "open_button.png"},
        {mode="opened", button = "sw_bedt7_2", img_button = "close_button.png", listname = "sw_bedt7_2", inv_size=6*2},
        {mode="opened", button = "sw_bedt7_3", img_button = "close_button.png", listname = "sw_bedt7_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    ["simple_wooden_bedside_table_8"] = {
        {mode="opened", button = "sw_bedt8_1", img_button = "close_button.png", listname = "sw_bedt8_1", inv_size=6*2},
        {mode="opened", button = "sw_bedt8_2", img_button = "close_button.png", listname = "sw_bedt8_2", inv_size=6*2},
        {mode="opened", button = "sw_bedt8_3", img_button = "close_button.png", listname = "sw_bedt8_3", inv_size=6*2},
        not_in_creative_inventory=1
        
    },
    inv_list = {{}, {}, {}} 
}

for bedside_t, bedside_ts in pairs(cabs_table["simple_wooden_bedside_table"]) do
  if bedside_t ~= "inv_list" then
    minetest.register_node("luxury_decor:"..bedside_t, {
        description = "Simple Wooden Bedside Table",
        visual_scale = 0.5,
        inventory_image = "simple_wooden_bedside_table_inv.png",
        mesh = bedside_t..".b3d",
        tiles = {"simple_bedside_table.png"},
        paramtype = "light",
        paramtype2 = "facedir",
        drop = "luxury_decor:simple_wooden_bedside_table_1",
        groups = {choppy=3, not_in_creative_inventory = bedside_ts["not_in_creative_inventory"]},
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
            local img_button1 = "image_button[0.5, 0;1, 2;" .. bedside_ts[1].img_button ..";" .. bedside_ts[1].button .. ";]"
            local img_button2 = "image_button[0.5, 2.5;1, 2;" .. bedside_ts[2].img_button .. ";" .. bedside_ts[2].button .. ";]"
            local img_button3 = "image_button[0.5, 5;1, 2;" .. bedside_ts[3].img_button .. ";" .. bedside_ts[3].button .. ";]"
            
            local y = 0
            local form = "size[9,11.5]" .. img_button1 .. img_button2 .. img_button3
            for num, drawer in pairs(bedside_ts) do
                if type(drawer) == "table" and drawer.mode == "opened" then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    if not cabs_table["simple_wooden_bedside_table"].inv_list[num][str_pos] then
                       cabs_table["simple_wooden_bedside_table"].inv_list[num][str_pos] = {}
                   end
                   local list = "list[nodemeta:"..pos.x..","..pos.y..","..pos.z..";".. drawer.listname .. ";1.5,".. y .. ";6, 2]"
                   form = form .. list
                end
                y= y+2.5
            end
            
            form = form .. "list[current_player;main;0.5,7.5;8,4;]"
            local meta = minetest.get_meta(pos)
            meta:set_string("formspec", form)
            
            local inv = meta:get_inventory()
            for num2, drawer2 in pairs(bedside_ts) do
                if type(drawer2) == "table" and drawer2.inv_size ~= nil and drawer2.listname ~= nil then
                    local str_pos = tostring(pos.x) .. ", " .. tostring(pos.y) .. ", " .. tostring(pos.z)
                    inv:set_list(bedside_ts[num2].listname, cabs_table["simple_wooden_bedside_table"].inv_list[num2][str_pos])
                    inv:set_size(bedside_ts[num2].listname, bedside_ts[num2].inv_size)
                end
                
                
            end
            inv:set_size("main", 8*4)
        end,
        on_receive_fields = function (pos, formname, fields, sender)
            local name = minetest.get_node(pos).name
            local meta = minetest.get_meta(pos)
            local defined_mode = cabinets.define_mode(fields, name)
            local button_name
            for num, drawer in pairs(bedside_ts) do
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
    
    if not bedside_ts.not_in_creative_inventory then
        minetest.register_craft({
            output = "luxury_decor:" .. bedside_t,
            recipe = {
                {"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""},
                {"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""},
                {"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""}
            }
        })
                
    end
  end
end

minetest.register_craftitem("luxury_decor:bedside_drawer", {
    description = "Bedside Drawer",
    inventory_image = "bedside_drawer.png",
    stack_max = 99
})

minetest.register_craft({
    output = "luxury_decor:bedside_drawer",
    recipe = {
        {"luxury_decor:pine_wooden_board", "luxury_decor:pine_wooden_board", ""},
        {"luxury_decor:pine_wooden_board", "", ""},
        {"default:stick", "", ""}
    }
})
    

for color, rgb_code in pairs(rgb_colors) do
    minetest.register_node("luxury_decor:royal_single_bed_" .. color, {
        description = "Royal Single Bed",
        visual_scale = 0.5,
        mesh = "royal_single_bed.obj",
        tiles = {"royal_bed.png^(royal_bed_2.png^[colorize:"..rgb_code..")"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=3},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -1.44, 0.5, 0.3, 0.46},
                {-0.5, -0.5, 0.46, 0.5, 1.5, 0.65},
                {-0.5, -0.5, -1.44, 0.5, 0.3, -1.65}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -1.44, 0.5, 0.3, 0.46},
                {-0.5, -0.5, 0.46, 0.5, 1.5, 0.65},
                {-0.5, -0.5, -1.44, 0.5, 0.3, -1.65}
            }
        },
        sounds = default.node_sound_wood_defaults(),
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            --[[if string.find(itemstack:get_name(), "royal_single_bed") then
                local color1 = string.sub(node.name, 32, -1)
                local color2 = string.sub(itemstack:get_name(), 32, -1)
                local node_dir = minetest.facedir_to_dir(node.param2)
                local axles_list = {""}
                local exact_pos = minetest.pointed_thing_to_face_pos(clicker, pointed_thing)
                if color1 == color2 then
                    local axle
                    for axle, val in pairs(pointed_thing.above) do
                        if val ~= pointed_thing.under[axle] and axle ~= y then
                            if exact_pos[axle] > pos[axle] then
                                minetest.set_node(pos, )
                                
                            
                    for axis, vector in pairs(minetest.facedir_to_dir(node.param2)) do
                        if vector ~= 0 then
                           axle = axis
                        end
                    end
                    
                    local exact_pos = minetest.pointed_thing_to_face_pos(clicker, pointed_thing)
                    local new_pos = pos
                    for axis, val in pairs(pointed_thing.above) do
                        if val ~= pointed_thing.under and axis ~= axle then
                           if exact_pos[axis]  pos[axis] then
                               new_pos[axis] = new_pos[axis] -1
                           end
                           
                           minetest.remove_node(pos)
                           minetest.set_node(new_pos, {name="luxury_decor:royal_double_bed_" .. color, param1=node.param1, param2=node.param2})
                        end
                    end
                end]]
            if string.find(itemstack:get_name(), "dye:") then
                local color_dye = string.sub(itemstack:get_name(), 5)
                minetest.remove_node(pos)
                minetest.set_node(pos, {name="luxury_decor:royal_single_bed_" .. color_dye, param1=node.param1, param2=node.param2})
                itemstack:take_item()
                return itemstack
            end
            
        end
    })
    
    minetest.register_craft({
        output = "luxury_decor:royal_single_bed_" .. color,
        recipe = {
            {"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:brass_stick"},
            {"luxury_decor:brass_stick", "luxury_decor:brass_stick", "default:gold_ingot"},
            {"wool:white", "default:diamond", "dye:" .. color}
        }
    })
    
    minetest.register_node("luxury_decor:royal_double_bed_" .. color, {
        description = "Royal Double Bed",
        visual_scale = 0.5,
        mesh = "royal_double_bed.b3d",
        tiles = {"royal_bed.png^(royal_bed_2.png^[colorize:"..rgb_code..")"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=3},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -1.62, 1.5, 0.3, 0.27},
                {-0.5, -0.5, 0.27, 1.5, 1.5, 0.47},
                {-0.5, -0.5, -1.62, 1.5, 1.5, -1.82}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -1.62, 1.5, 0.3, 0.27},
                {-0.5, -0.5, 0.27, 1.5, 1.5, 0.47},
                {-0.5, -0.5, -1.62, 1.5, 1.5, -1.82}
            }
        },
        sounds = default.node_sound_wood_defaults(),
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            if string.find(itemstack:get_name(), "dye:") then
                local color_dye = string.sub(itemstack:get_name(), 5)
                minetest.remove_node(pos)
                minetest.set_node(pos, {name="luxury_decor:royal_double_bed_" .. color_dye, param1=node.param1, param2=node.param2})
                itemstack:take_item()
                return itemstack
                
            end
        end
    })
    
    minetest.register_craft({
        type = "shapeless",
        output = "luxury_decor:royal_double_bed_" .. color,
        recipe = {"luxury_decor:royal_single_bed_" .. color, "luxury_decor:royal_single_bed_" .. color}
    })
end

