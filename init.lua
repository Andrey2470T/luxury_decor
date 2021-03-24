luxury_decor = {}

luxury_decor.cabs_table = {}

luxury_decor.rgb_colors = {
    ["black"] = "#000000",
    ["red"] = "#FF0000",
    ["green"] = "#00FF00",
    ["white"] = "#FFFFFF",
    ["blue"] = "#0000FF",
    ["yellow"] = "#FFFF00",
    ["magenta"] = "#FF00FF",
    ["cyan"] = "#00FFFF",
    ["dark_green"] = "#008000",
    ["dark_grey"] = "#808080",
    ["grey"] = "#C0C0C0",
    ["brown"] = "#A52A2A",
    ["orange"] = "#FF4500",
    ["pink"] = "#F08080",
    ["violet"] = "#4B0082"
}

    
local modpath = minetest.get_modpath("luxury_decor")

--  API
dofile(modpath.."/api/cooker.lua")
dofile(modpath.."/api/helper_funcs.lua")
dofile(modpath.."/api/piano.lua")
dofile(modpath.."/api/sitting.lua")
dofile(modpath.."/api/vase.lua")


--  Stuff
dofile(modpath.."/materials.lua")
dofile(modpath.."/bedroom.lua")
dofile(modpath.."/chairs.lua")
dofile(modpath.."/tables.lua")
dofile(modpath.."/kitchen_furniture.lua")
dofile(modpath.."/lighting.lua")
dofile(modpath.."/music.lua")
dofile(modpath.."/redecorating.lua")
dofile(modpath.."/shelves.lua")
dofile(modpath.."/living_room.lua")

