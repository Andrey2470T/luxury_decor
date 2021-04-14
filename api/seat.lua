-- Seat API
-- Allows to easily register as types of seats as sofas, chairs, armchairs, footstools and more!

seat = {}
seat.types = {"chair", "armchair", "sofa", "footstool"}
seat.styles = {"simple", "luxury", "royal"}
seat.materials = {"wooden", "steel", "plastic", "stone", "wool"}
seat.wood_sorts = luxury_decor.wood_sorts

luxury_decor.register_seat = function(def)
	local seatdef = {}
	
	seatdef.actual_name = def.actual_name or ""
	
	local type_state, rtype = luxury_decor.CHECK_FOR_TYPE(seat.types, def.type)
	local style_state, rstyle = luxury_decor.CHECK_FOR_STYLE(seat.styles, def.style)
	local material_state, rmaterial = luxury_decor.CHECK_FOR_MATERIAL(seat.materials, def.material)
	
	def.register_wood_sorts = luxury_decor.CHECK_FOR_WOOD_SORTS_LIST(seat.wood_sorts, def.register_wood_sorts)
	
	if def.register_wood_sorts then
		seatdef.base_color = luxury_decor.CHECK_FOR_COLORS_LIST(def.base_color)
		seatdef.textures = def.textures
		seatdef.inventory_image = def.inventory_image
		seatdef.wield_image = def.wield_image or seatdef.inventory_image
		seatdef.multiply_by_color = def.multiply_by_color
	else
		local color_state, rcolor = luxury_decor.CHECK_FOR_COLOR(def.base_color)
		
		if not color_state then return end
		seatdef.base_color = rcolor
	end

	if not type_state then return end
	if not style_state then return end
	if not material_state then return end
	
	seatdef.visual_scale	= def.visual_scale or 0.5
	seatdef.drawtype 		= def.drawtype or "mesh"
	seatdef.mesh 			= seatdef.drawtype == "mesh" and def.mesh or ""
	seatdef.use_texture_alpha 	= true
	seatdef.paramtype			= "light"
	seatdef.paramtype2			= def.paramtype2 or "facedir"
	
	local upper_name = ""
	for i, str in ipairs(string.split(seatdef.actual_name, "_")) do
		upper_name = upper_name .. luxury_decor.upper_letters(str, 1, 1) .. " "
	end
	
	
	seatdef.description = upper_name .. "\n" ..
		minetest.colorize("#ff0000", "type: " .. rtype) .. "\n" ..
		minetest.colorize("#ff00f1", "style: " .. rstyle) .. "\n" ..
		minetest.colorize("#45de0f", "material: " .. rmaterial)
		
	seatdef.groups				= {
		["style_" .. rstyle] = 1, 
		["material_" .. rmaterial] = 1, 
		["type_" .. rtype] = 1, 
		snappy = 1.5
	}
	
	if type(def.groups) == "table" then
		seatdef.groups = luxury_decor.unite_tables(seatdef.groups, def.groups)
	end
	
	seatdef.collision_box		= seatdef.drawtype == "mesh" and {
		type = "fixed",
		fixed = def.collision_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	seatdef.node_box			= seatdef.drawtype == "nodebox" and {
		type = "fixed",
		fixed = def.node_box or {-0.5, -0.5, -0.5, 0.5, 0.5, 0.5}
	}
	
	seatdef.selection_box		= {
		type = "fixed",
		fixed = def.selection_box or seatdef.collision_box and seatdef.collision_box.fixed or seatdef.node_box and seatdef.node_box.fixed
	}
	seatdef.sounds = {}
	
	if not def.sounds then
		seatdef.sounds = rmaterial == "wooden" and default.node_sound_wood_defaults() or
				rmaterial == "steel" and default.node_sound_metal_defaults() or
				(rmaterial == "plastic" or rmaterial == "wool") and default.node_sound_leaves_defaults() or
				rmaterial == "stone" and default.node_sound_stone_defaults()
	else
		seatdef.sounds = def.sounds
	end
	
	seatdef.paintable = def.paintable or false
	seatdef.connectable = (rtype == "sofa" or rtype == "footstool") and def.connectable
	
	if seatdef.connectable and not def.connected_parts_meshes then
		minetest.log("warning", "luxury_decor.register_seat(): Failed to register the seat! No a connected parts meshes list passed despite this is connectable!")
		return
	end
	
	if def.seat_data then
		seatdef.seat_data = def.seat_data
		seatdef.seat_data.pos = seatdef.seat_data.pos or {x=0, y=0, z=0}
		seatdef.seat_data.rot = seatdef.seat_data.rot or {x=0, y=0, z=0}
		
		if seatdef.seat_data.mesh then
			for i, mesh in ipairs(seatdef.seat_data.mesh) do
				if mesh.anim then
					mesh.anim.blend = mesh.anim.blend or 0.0
					mesh.anim.loop = mesh.anim.loop or true
				end
			end
		end
	end
	
	seatdef.on_construct = function(pos)
		minetest.get_meta(pos):set_string("is_busy", "")
		
		if def.on_construct then
			def.on_construct(pos)
		end
	end
	
	seatdef.on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
		local res, brush = paint.paint_node(pos, clicker)
		if not res then
			local bool = sitting.sit_player(clicker, pos)
			
			if not bool then
				sitting.standup_player(clicker, pos)
			end
			
			if def.on_rightclick then
				def.on_rightclick(pos, node, clicker, itemstack, pointed_thing)
			end
		end
			
		return brush
	end
	
	seatdef.on_destruct = function(pos)
		sitting.standup_player(minetest.get_player_by_name(minetest.get_meta(pos):get_string("is_busy")), pos)
		                       
		if def.on_destruct then
			def.on_destruct(pos)
		end
	end
		                      
	local res_name = "luxury_decor:" .. seatdef.actual_name
	if rmaterial == "wooden" and type(def.register_wood_sorts) == "table" then
		wood.register_wooden_sorts_nodes(seatdef, def.register_wood_sorts)
	else
		seatdef.tiles = def.textures
		seatdef.multiply_by_color = def.multiply_by_color
		seatdef.description = seatdef.description .. "\n" .. minetest.colorize("#1a1af1", "color: " .. seatdef.base_color)
		seatdef.groups["color_" .. seatdef.base_color] = 1
		seatdef.inventory_image = def.inventory_image
		seatdef.wield_image = def.wield_image or seatdef.inventory_image
		seatdef.drop = def.drop or res_name
		
		minetest.register_node(res_name, seatdef)
		
		if def.craft_recipe then
			minetest.register_craft({
				type = def.craft_recipe.type,
				output = res_name,
				recipe = def.craft_recipe.recipe,
				replacements = def.craft_recipe.replacements
			})
		end
	
		if seatdef.paintable then
			paint.register_colored_nodes(res_name)
		end
	end
	
	seat.register_connected_parts(seatdef, def.connected_parts_meshes, def.connected_parts_node_boxes, def.connected_parts_selection_boxes, def.register_wood_sorts)
end

seat.register_connected_parts = function(def, connected_parts_meshes, connected_parts_node_boxes, connected_parts_sel_boxes, wood_sorts)
	if not def.connectable then
		return
	end
	
	for type, mesh in pairs(connected_parts_meshes) do
		if luxury_decor.get_material(def) == "wooden" and wood_sorts then
			wood.register_wood_sorts(def, wood_sorts, type)
		else
			local copy_def = table.copy(def)
			copy_def.mesh = mesh
			copy_def.groups.not_in_creative_inventory = 1
			copy_def.collision_box = copy_def.drawtype == "mesh" and {
				type = "fixed",
				fixed = connected_parts_node_boxes[type]
			}
			copy_def.node_box = copy_def.drawtype == "nodebox" and {
				type = "fixed",
				fixed = connected_parts_node_boxes[type]
			}
			copy_def.selection_box = {
				type = "fixed",
				fixed = connected_parts_sel_boxes and connected_parts_sel_boxes[type] or 
					(copy_def.collision_box and copy_def.collision_box.fixed or copy_def.node_box and copy_def.node_box.fixed)
			}
			
			local res_name = "luxury_decor:" .. def.actual_name .. "_" .. type
			minetest.register_node(res_name, copy_def)
	
			if def.paintable then
				paint.register_colored_nodes(res_name)
			end
		end
	end
end
