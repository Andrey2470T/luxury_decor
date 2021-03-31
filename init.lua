luxury_decor = {}

luxury_decor.cabs_table = {}

    
local modpath = minetest.get_modpath("luxury_decor")

-- Helpers
dofile(modpath.."/api/check_funcs.lua")
dofile(modpath.."/api/helper_funcs.lua")

--  API
dofile(modpath.."/api/painting.lua")
dofile(modpath.."/api/cooker.lua")
dofile(modpath.."/api/light.lua")
dofile(modpath.."/api/piano.lua")
dofile(modpath.."/api/sitting.lua")
dofile(modpath.."/api/vase.lua")


--  Stuff
dofile(modpath.."/materials.lua")
dofile(modpath.."/bedroom.lua")
dofile(modpath.."/chairs.lua")
dofile(modpath.."/tables.lua")
dofile(modpath.."/kitchen_furniture.lua")
dofile(modpath.."/lights.lua")
dofile(modpath.."/music.lua")
dofile(modpath.."/redecorating.lua")
dofile(modpath.."/shelves.lua")
dofile(modpath.."/living_room.lua")

