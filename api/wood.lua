-- Registration API of nodes with different sorts of wood

wood = {}

wood.register_wooden_sorts_nodes = function(def, part_type)
	if not def.register_wood_sorts then
		return
	end
	
	for i, wood_sort in ipairs(def.register_wood_sorts) do
		local light_state = lights.get_state(def)
		local result_name = "luxury_decor:" .. def.actual_name .. (part_type and "_" .. part_type or "") .. "_" .. wood_sort .. (light_state and "_" .. light_state or "")
		local copy_def = table.copy(def)
		
		copy_def.base_color = def.base_color[wood_sort]
		copy_def.tiles = def.textures[wood_sort]
		copy_def.inventory_image = def.inventory_image and def.inventory_image[wood_sort]
		copy_def.wield_image = def.wield_image and def.wield_image[wood_sort] or copy_def.inventory_image and copy_def.inventory_image[wood_sort]
		copy_def.description = copy_def.description .. "\n" ..
				minetest.colorize("#1a1af1", "color: " .. copy_def.base_color) .. "\n" .. 
				minetest.colorize("#f9e900", "wood_sort: " .. wood_sort)
		copy_def.groups["color_" .. copy_def.base_color] = 1
		copy_def.groups["wood_sort_" .. wood_sort] = 1
		copy_def.drop = def.drop or "luxury_decor:" .. def.actual_name .. "_" .. wood_sort
		
		minetest.register_node(result_name, copy_def)
		
		if def.craft_recipe then
			local recipe = {
				type = copy_def.craft_recipe.type,
				output = result_name,
				recipe = copy_def.craft_recipe.recipe,
				replacements = copy_def.craft_recipe.replacements or {}
			}
				
			for i, item in ipairs(recipe.recipe) do
				if type(item) == "table" then
					for j, item2 in ipairs(item) do
						item[j] = luxury_decor.build_wooden_item_string(item2, wood_sort) or item2
					end
				else
					recipe.recipe[i] = luxury_decor.build_wooden_item_string(item, wood_sort) or item
				end
			end
				
			for i, item in ipairs(recipe.replacements) do
				if type(item) == "table" then
					for j, item2 in ipairs(item) do
						item[j] = luxury_decor.build_wooden_item_string(item2, wood_sort) or item2
					end
				else
					recipe.replacements[i] = luxury_decor.build_wooden_item_string(item, wood_sort) or item
				end
			end
			
			minetest.register_craft(recipe)
		end
		if def.paintable then
			paint.register_colored_nodes(result_name)
		end
	end
end
