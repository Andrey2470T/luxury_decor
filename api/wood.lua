-- Registration API of nodes with different sorts of wood

wood = {}

wood.register_wooden_sorts_nodes = function(def, part_type)
	if not def.register_wood_sorts then
		return
	end
	
	for i, wood in ipairs(def.register_wood_sorts) do
		local light_state = lights.get_state(def)
		local result_name = "luxury_decor:" .. def.actual_name .. (part_type and "_" .. part_type or "") .. "_" .. wood .. (light_state and "_" .. light_state or "")
		local copy_def = table.copy(def)
		
		copy_def.base_color = def.base_color[wood]
		copy_def.tiles = def.textures[wood]
		copy_def.inventory_image = def.inventory_image and def.inventory_image[wood]
		copy_def.wield_image = def.wield_image and def.wield_image[wood] or copy_def.inventory_image and copy_def.inventory_image[wood]
		copy_def.description = copy_def.description .. "\n" ..
				minetest.colorize("#1a1af1", "color: " .. copy_def.base_color) .. "\n" .. 
				minetest.colorize("#f9e900", "wood_sort: " .. wood)
		copy_def.groups["color_" .. copy_def.base_color] = 1
		copy_def.groups["wood_sort_" .. wood] = 1
		
		minetest.register_node(result_name, copy_def)
		
		if def.craft_recipe then
			local recipe = {
				type = def.craft_recipe.type,
				output = result_name,
				recipe = def.craft_recipe.recipe,
				replacements = def.craft_recipe.replacements or {}
			}
				
			for i, item in ipairs(recipe.recipe) do
				if type(item) == "table" then
					for j, item2 in ipairs(item) do
						item[j] = luxury_decor.build_wooden_item_string(item2, wood) or item2
					end
				else
					recipe.recipe[i] = luxury_decor.build_wooden_item_string(item, wood) or item
				end
			end
				
			for i, item in ipairs(recipe.replacements) do
				if type(item) == "table" then
					for j, item2 in ipairs(item) do
						item[j] = luxury_decor.build_wooden_item_string(item2, wood) or item2
					end
				else
					recipe.replacements[i] = luxury_decor.build_wooden_item_string(item, wood) or item
				end
			end
						
				minetest.register_craft(recipe)
		end
		if def.paintable then
			paint.register_colored_nodes(result_name)
		end
	end
	
	def.base_color = nil
	def.textures = nil
	def.inventory_image = nil
	def.wield_image = nil
end
