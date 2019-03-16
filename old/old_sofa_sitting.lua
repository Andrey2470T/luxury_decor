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
                        elseif pointed_thing.under.x > pointed_thing.above.x and string.find(node.name, "_long_") == nil then
                            local sofas_types_list = {"small", "middle", "long"}
                            if dir.x < 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x-1, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows"})
                            elseif dir.x > 0 then
                                itemstack:take_item()
                                minetest.remove_node(pos)
                                minetest.set_node({x=pos.x, y=pos.y, z=pos.z}, {name="luxury_decor:simple_" .. color .. "_" .. sofas_types_list[ind+1] .. "_sofa_with_" .. pillow_color .. "_pillows"})
                            
                            end
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
                    elseif pointed_thing.under.y < pointed_thing.above.y and dir.y < 0 and string.find(node.name, "_long_") == nil then
                            itemstack:take_item()
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
