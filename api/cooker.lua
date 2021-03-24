--  Cooker API

cooker = {}

cooker.get_formspec = function(pos)
    local node = minetest.get_node(pos)
    local def = minetest.registered_nodes[node.name]
    local form = "formspec_version[3]"

    local burners_fs = ""
    local oven_fs = ""
    
    local fs_w = 8
    local fs_h = 0
    if def.type == "stove" or def.type == "mixed" then
        local brns_n_in_row = def.burners_n > 4 and 4 or def.burners_n
        local slots_span = (fs_w-brns_n_in_row)/(brns_n_in_row+1)
        local burner_x = 0
        local burner_y = 0
        --local brns_dist_x = 2
        --local brns_dist_y = 1
        def.burners_n = def.burners_n > 8 and 8 or def.burners_n    -- limit of burners number up to 8 maximum
        for i = 1, def.burners_n do
            burner_x = (i-1)%4 == 0 and slots_span or (burner_x + 1 + slots_span)
            burner_y = (i-1)%4 == 0 and burner_y + 1 + slots_span or slots_span
            burners_fs = burners_fs .. "list[context;brn_src" .. i .. ";" .. burner_x .. "," .. burner_y .. ";1,1;]" ..
                    "image[" .. burner_x .. "," .. burner_y + 1 .. ";1,0.5;luxury_decor_burner.png]"
        end
        
        form = form .. burners_fs
        fs_h = burner_y + 1 + slots_span + 0.5
    end
    
    if def.type == "oven" or def.type == "mixed" then
        def.oven_departments_n = def.oven_departments_n > 2 and 2 or def.oven_departments_n
        local slots_dist_x = 3
        local slots_dist_y = 1.5
        local pad = (fs - 2 - slots_dist_x)/2
        oven_fs_h = def.oven_departments_n + (def.oven_departments_n-1)*slots_dist_y + 1.5 + pad + (fs_h == 0 and pad or 0)
        fs_h = fs_h .. oven_fs_h
        if def.state == "closed" then
            oven_fs = oven_fs .. "button[" .. fs_w/2-2 .. "," .. oven_fs_h/2-1 .. ";2,1;oven_open;Open Oven;]"
        elseif def.state == "opened" then
            local dptmts_y = fs_h == 0 and pad or fs_h
        
            for i = 1, def.oven_departments_n do
                dptms_y = i > 1 and dptms_y + 1 + slots_dist_y
                oven_fs = oven_fs .. "list[context;oven_src" .. i .. ";" .. pad .. "," .. dptms_y .. ";1,1;]" ..
                        "image[" .. pad + 1 + slots_dist_x/2-0.5 .. "," .. dptmts_y .. ";1,0.5;default_furnace_arrow_bg.png^[transform:R180];]" ..
                        "list[" .. pad+1+slots_dist_x .. "," .. dptmts_y .. ";1,1]"
            
            end
            
            oven_fs = oven_fs .. "button[" .. fs_w/2-2 .. "," .. (dptms_y + 2) .. ";2,1;oven_close;Close;]"
            form = form .. oven_fs
        end
    end
    
    form = form .. "size[" .. fs_w .. "," .. fs_h .. "]" .. burners_fs .. oven_fs
    
    
    return form
end
        
    
cooker.event_handler = function(pos, formname, fields, player)
    if formname ~= "luxury_decor:cooker_formspec" then return end
    
    local node = minetest.get_node(pos)
    if fields.oven_open then
        minetest.set_node(pos, {name=node.name:gsub("closed", "opened"), param1=node.param1, param2=node.param2})
        minetest.show_formspec(player, formname, cooker.get_formspec(pos))
    elseif fields.oven_close then
        minetest.set_node(pos, {name=node.name:gsub("opened", "closed"), param1=node.param1, param2=node.param2})
        minetest.show_formspec(player, formname, cooker.get_formspec(pos))
    end
end
    
luxury_decor.register_cooker = function(def)
    local cookdef = table.copy(def)
    
    cookdef.type			= def.type  or "mixed"   -- potential types: "stove", "oven", "mixed", "furnace" and etc
    cookdef.material		= def.material or "steel"
    cookdef.color			= def.color or "white"
    
    cookdef.drawtype		= "mesh"
    
    cookdef.visual_scale 	= def.visual_scale or 0.5
    
    if not def.description or def.description == "" then
        cookdef.description = "Cooker\n" .. minetest.colorize("#FF0000", "type: " .. cookdef.type) .. "\n" ..
                minetest.colorize("#45de0f", "material: " .. cookdef.material) .. "\n" ..
                minetest.colorize("#1a1af1", "color: " .. cookdef.color)
        
        if def.item_info then
            cookdef.description = cookdef.description .. def.item_info
        end
    end
    
    cookdef.groups			= def.groups or {cracky=1.5}
    
    cookdef.sounds = {}
    
    if not def.sounds then
        cookdef.sounds = 
                (cookdef.material == "stone" and default.node_sound_stone_defaults()) or
                (cookdef.material == "wood" and default.node_sound_wood_defaults()) or
                (cookdef.material == "steel" and default.node_sound_metal_defaults())
    else
        cookdef.sounds 		= def.sounds
    end
    
    cookdef.burners_n 		= def.burners_n or 0
    
    cookdef.on_receive_fields = cooker.event_handler
    
    cookdef.on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", cooker.get_formspec(pos))
    end
    
    for _, st in ipairs({"closed", "opened"}) do
        local cdef 		= table.copy(cookdef)
        cdef.mesh		= def[st].mesh
        cdef.tiles		= {}
            
        if type(def[st].textures) == "string" then
            cdef.tiles = {name=cdef[st].textures, color=cdef.color}
        elseif type(def[st].textures) == "table" then
            for i, tex in ipairs(cdef[st].textures) do
                cdef.tiles[i] = tex
                if type(tex) == "table" and type(tex.multiply_by_color) == "boolean" then
                    cdef.tiles[i].multiply_by_color = nil
                    cdef.tiles[i].color = cdef.color
                end
            end
        end
    
		if not cdef[st].description or cdef[st].description == "" then
			cdef.description = "Cooker\n" .. minetest.colorize("#FF0000", "type: " .. cdef.type) .. "\n" ..
			minetest.colorize("#45de0f", "material: " .. cdef.material) .. "\n" ..
			minetest.colorize("#1a1af1", "color: " .. cdef.color) .. "\n" .. 
			minetest.colorize("#FF0000", "mode: " .. st)
        
			if cdef.item_info then
				cdef.description = cdef.description .. cdef.item_info
			end
		end

        cdef.inventory_image = cdef[st].inventory_image
        cdef.light_source = cdef[st].light_source or 0
        cdef.collision_box = {
            type = "fixed",
            fixed = cdef[st].collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
        }
    
        cdef.selection_box = {
            type = "fixed",
            fixed = cdef[st].selection_box or cdef.collision_box.fixed
        }
    
        
        minetest.register_node("luxury_decor:" .. cdef.material .. "_" .. cdef.color .. "_" .. cdef.type .. (cdef.type=="mixed" and "_oven" or "") .. "_" .. st, cdef)
    end
end
    
    
    
