local rgb_colors = {
    ["black"] = "#000000",
    ["red"] = "#FF0000",
    ["green"] = "#00FF00",
    ["white"] = "#FFFFFF",
    ["blue"] = "#0000FF",
    ["yellow"] = "#FFFF00",
    ["magenta"] = "#FF00FF",
    ["cyan"] = "#00FFFF",
    ["darkgreen"] = "#008000",
    ["darkgrey"] = "#808080",
    ["grey"] = "#C0C0C0",
    ["brown"] = "#A52A2A",
    ["orange"] = "#FF4500",
    ["pink"] = "#F08080",
    ["violet"] = "#4B0082"
}
    

local bed_num = 0
for color, rgb_code in pairs(rgb_colors) do
    bed_num = bed_num + 1
    minetest.register_node("luxury_decor:royal_single_bed_" .. bed_num, {
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
                {-1.5, -0.5, -0.5, 1.5, 0.5, 0.5}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-1.5, -0.5, -0.5, 1.5, 0.5, 0.5}
            }
        },
        sounds = default.node_sound_wood_defaults(),
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            if itemstack:get_name() == "luxury_decor:royal_single_bed" then
                local x1, y1, z1 = pos.x, pos.y, pos.z
                local x2 = pointed_thing.above.x or pointed_thing.under.x
                local y2 = pointed_thing.above.y or pointed_thing.under.y
                local z2 = pointed_thing.above.z or pointed_thing.under.z
                
                if pointed_thing.type == "node" and x1 ~= x2 and y1 == y2 and z1 == z2 then
                    local single_bed_coords = pointed_thing.above or pointed_thing.under
                    minetest.remove_node(pos)
                    minetest.set_node(single_bed_coords, {name="luxury_decor:royal_double_bed", param1=node.param1, param2=node.param2})
                end
            end
        end
    })
    
    minetest.register_node("luxury_decor:royal_double_bed_" .. bed_num, {
        description = "Royal Double Bed",
        visual_scale = 0.5,
        mesh = "royal_double_bed.obj",
        tiles = {"royal_bed.png^(royal_bed_2.png^[colorize:"..rgb_code..")"},
        paramtype = "light",
        paramtype2 = "facedir",
        groups = {choppy=3},
        drawtype = "mesh",
        collision_box = {
            type = "fixed",
            fixed = {
                {-1.1, -0.5, -1.8, 1.1, 0.5, 0.5}
            }
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-1.1, -0.5, -1.8, 1.1, 0.5, 0.5}
            }
        },
        sounds = default.node_sound_wood_defaults()
    })
end
