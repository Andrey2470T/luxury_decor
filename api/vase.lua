--  Vase API


vase = {}

minetest.register_entity("luxury_decor:flower_base", {
     hp_max = 1,
     physical = false,
     collisionbox = {0, 0, 0, 0, 0, 0},
     pointable = false,
     visual = "item",
     visual_size = {x=0.3, y=0.3, z=0.3},
     wield_item = "air",
     static_save = true
})

vase.drop_flower = function(pos)
    local meta = minetest.get_meta(pos)
    local flower = minetest.deserialize(meta:get_string("flower_data"))
        
    if not flower or flower == "" then
        return 
    end
        
    local flower_obj = minetest.get_objects_inside_radius(flower.pos, 0.1)
            
    for i, obj in ipairs(flower_obj) do
        local self = obj:get_luaentity()
        if self and self.name == "luxury_decor:flower_base" then
            local stack = ItemStack(flower.name)
            minetest.item_drop(stack, clicker, flower.pos)
                    
            obj:remove()
            meta:set_string("flower_data", "")
                    
            return true
        end
        
    end
end

luxury_decor.register_vase = function(def)
    local vase_def              = {}
    vase_def.style              = def.style or "simple"
    vase_def.material           = def.material
    vase_def.color              = def.color
    vase_def.visual_scale        = def.visual_scale or 0.5
    
    if not def.description or def.description == "" then
        vase_def.description = luxury_decor.upper_letters(vase_def.style, 1, 1) .. " " .. 
                (vase_def.material and luxury_decor.upper_letters(vase_def.material, 1, 1) or "") .. 
                (vase_def.color and luxury_decor.upper_letters(vase_def.color, 1, 1) or "") .. " Vase "
        
        if def.item_info then
            vase_def.description = vase_def.description .. def.item_info
        end
    end
    
    vase_def.mesh               = def.mesh
    vase_def.tiles              = {}
    
    if type(def.textures) == "string" then vase_def.tiles[1] = def.textures
    elseif type(def.textures) == "table" then
        if vase_def.color then
            vase_def.tiles[1] = def.textures[1]
            vase_def.tiles[1]:insert(rgb_colors[vase_def.color])
            
            vase_def.tiles[2] = def.textures[2]
        else
            vase_def.tiles = def.textures
        end
    end
    vase_def.inventory_image    = def.inventory_image
    vase_def.groups             = def.groups or {snappy=1.5}
    vase_def.collision_box      = def.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
    vase_def.selection_box      = def.selection_box or vase_def.collision_box
    
    vase_def.sounds = {}
    
    if not def.sounds then
        vase_def.sounds = 
                (vase_def.material == "wooden" and default.node_sound_wood_defaults()) or
                (vase_def.material == "stone" and default.node_sound_stone_defaults()) or
                (vase_def.material == "glass" and default.node_sound_glass_defaults()) or
                (vase_def.material == "plastic" and default.node_sound_leaves_defaults()) or
                (vase_def.material == "metallic" and default.node_sound_metal_defaults())
    else
        vase_def.sounds = def.sounds
    end
    
    vase_def.flower_shift_pos = def.flower_shift_pos
    
    vase_def.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
        vase.drop_flower(pos)
        
        local is_flower = minetest.get_item_group(itemstack:get_name(), "flower")
        minetest.debug("is_flower: " .. is_flower)
        if is_flower ~= 0 then
            local shift_pos = vase_def.flower_shift_pos
            local abs_pos = {x=pos.x+shift_pos.x, y=pos.y+shift_pos.y, z=pos.z+shift_pos.z}
            local fl_name = itemstack:get_name()
            minetest.get_meta(pos):set_string("flower_data", minetest.serialize({name=fl_name, pos=abs_pos}))
            local fl_obj = minetest.add_entity(abs_pos, "luxury_decor:flower_base")
            
            minetest.debug("flowers_" .. fl_name:sub(9) .. ".png")
            fl_obj:set_properties({wield_item="flowers:" .. fl_name:sub(9)})
            
            itemstack:take_item()
        end
    end
    
    vase_def.on_destruct = function(pos)
        vase.drop_flower(pos)
    end
    
    minetest.debug("Simple plastic vase is being registered!")
    local name = "luxury_decor:" .. vase_def.style .. "_" .. (vase_def.material and vase_def.material .. "_" or "") .. (vase_def.color and vase_def.material .. "_" or "") .. "vase"
    minetest.register_node(name, {
        description         = vase_def.description,
        visual_scale        = vase_def.visual_scale,
        drawtype            = "mesh",
        mesh                = vase_def.mesh,
        use_texture_alpha   = true,
        tiles               = vase_def.tiles,
        inventory_image     = vase_def.inventory_image,
        sunlight_propagates = true,
        paramtype           = "light",
        paramtype2          = "facedir",
        groups              = vase_def.groups,
        collision_box        = {
            type = "fixed",
            fixed = vase_def.collision_box
        },
        selection_box        = {
            type = "fixed",
            fixed = vase_def.selection_box
        },
        sounds              = vase_def.sounds,
        on_rightclick       = vase_def.on_rightclick,
        on_destruct         = vase_def.on_destruct
    })
    
    minetest.debug(dump(minetest.registered_nodes[name]))
end
