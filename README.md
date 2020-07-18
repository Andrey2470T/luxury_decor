# Luxury Decor Mod For Minetest! Current version is 1.1.5!
![Luxury Decor](screenshot.png?raw=true)

## Description
This mod adds big amount of new furniture stuff of various sorts, decorations and exterior. Currently it adds one kitchen style (simple), a few types of chairs/tables, luxury lamp, simple sofas/footstools/armchairs/, iron chandelier, shelves, glass vase, pots, royal beds, simple wooden wall clock and simple bedside table. Lots of furniture items are ensured with crafting recipes. 

## Changelog List
### [18.07.20] 1.1.5:
####          1.Added solid oil.
####          2.Decreased alpha of oil source.
####          3.Optimized generation of ores.

### [26.09.19] 1.1.4: 
####          1.Added wood sawing sound while crafting with saw usage. 
####          2.Fixed an error causing due to '[[...]]' inside the comment.
####          3.Fridges dont cause any errors anymore.

### [27.08.19] 1.1.3: 
####          1.Moved sitting API into new folder named "api" into "sitting.lua".
####          2.Scaled down some chairs and lamps.

### [25.08.19] 1.1.2:
####          1.Fixed a serious bug is bound with disappearance of lying items as a result of switching other cabinet departmenrs.

### [??.??.??] 1.1.1:
####          1.Fixed overlaying of textures of some items (plastic chands).
####          2.Scaled down candlesticks and plastic desk lamps.

### [03.05.19] 1.1.0:
####          1.Added a whole set of chandeliers (plastic, luxury, glass and others), brass candlesticks and street lanterns.

### [31.03.19] 1.0.2:
####          1.Added crafting recipes for all items.
####          2.Added more craft ingredients.

### [27.03.19] 1.0.1:
####          1.The simple sofas connect between themselves correctly.
####          2.The sofas can be disconnectable by destroying them.
####          3.Fixed overlaying of sofas textures.

### [16.03.19] 1.0.0:
####          1.Added simple wooden kitchen furniture.
####          2.Added piano.
####          3.Added iron chandelier and wall glass lamp.
####          4.Added simple & luxury pots.
####          5.Added laminate floor.
####          6.Added simple colorful sofas and armchairs.
####          7.Added wall clock.
####          8.Added bedside table.
####          9.Added tables & chairs.
####         10.Added royal beds (single, double).


## Crafting & Cooking Recipes
Crafting:
-- Simple Wooden Bedside Table --
"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""
"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""

-- Bedside Drawer --
"luxury_decor:pine_wooden_board", "luxury_decor:pine_wooden_board", ""
"luxury_decor:pine_wooden_board", "", ""
"default:stick", "", ""

-- Royal Single Bed --
"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:brass_stick"
"luxury_decor:brass_stick", "luxury_decor:brass_stick", "default:gold_ingot"
"wool:white", "default:diamond", "dye:<color>"

-- Royal Double Bed --
"luxury_decor:royal_single_bed", "luxury_decor:royal_single_bed"

-- Kitchen Wooden Chair --
"luxury_decor:wooden_plank", "default:stick", "default:stick"
"luxury_decor:wooden_plank", "default:stick"
"luxury_decor:wooden_plank", "default:stick"

-- Luxury Wooden Chair With Cushion --
"luxury_decor:jungle_wooden_plank", "default:stick", "default:stick"
"luxury_decor:jungle_wooden_plank", "default:stick", "wool:white"
"luxury_decor:jungle_wooden_plank", "default:stick", ""

-- Round Wooden Chair --
"luxury_decor:pine_wooden_plank", "default:stick", "default:stick"
"luxury_decor:pine_wooden_plank", "default:stick", ""
"luxury_decor:pine_wooden_plank", "default:stick", ""

-- Decorative Wooden Chair --
"luxury_decor:jungle_wooden_plank", "default:stick", "default:stick"
"luxury_decor:jungle_wooden_plank", "default:stick", ""
"luxury_decor:jungle_wooden_plank", "default:stick", ""

-- Apple/Pine/Jungle Wooden Planks --
"luxury_decor:<wood_sort>_wooden_plank", "luxury_decor:saw"

-- Brass Stick --
"luxury_decor:brass_ingot"

-- Copper and Zinc --
"default:copper_ingot", "luxury_decor:zinc_ingot"

-- Saw --
"default:wood", "default:steel_ingot"

-- Apple/Pine/Jungle Wooden Boards --
"stairs:slab_<wood_sort>", "luxury_decor:saw"

-- Apple/Pine/Jungle Laminate Floor --
"luxury_decor:<wood_sort>wooden_plank", "luxury_decor:<wood_sort>wooden_plank"

-- Closed Wooden Shelves (pine and jungle) --
"luxury_decor:<wood_sort>_wooden_board", "luxury_decor:<wood_sort>_wooden_board"
"luxury_decor:<wood_sort>_wooden_board", "luxury_decor:<wood_sort>_wooden_board"

-- Closed Wooden Shelves With Back (pine and jungle) --
"luxury_decor:<wood_sort>_wooden_board", "luxury_decor:<wood_sort>_wooden_board"
"luxury_decor:<wood_sort>_wooden_board", "luxury_decor:<wood_sort>_wooden_board"
"luxury_decor:<wood_sort>_wooden_board"

-- Wall Wooden Shelves (pine and jungle) <1st variant> --
"luxury_decor:<wood_sort>_wooden_plank", "luxury_decor:saw"
"luxury_decor:<wood_sort>_wooden_plank"

-- Wall Wooden Shelves (pine and jungle) <2nd variant> --
"luxury_decor:<wood_sort>_wooden_board", "luxury_decor:saw"
"luxury_decor:<wood_sort>_wooden_board"

-- Kitchen Wooden Table --
"luxury_decor:wooden_plank", "luxury_decor:wooden_plank", "luxury_decor:wooden_plank"
"luxury_decor:wooden_plank", "default:stick", "luxury_decor:wooden_plank"
"default:stick", "default:stick"

-- Luxury Metallic Table --
"luxury_decor:jungle_wooden_plank", "luxury_decor:wooden_plank", "luxury_decor:wooden_plank"
"default:copper_ingot", "", "default:copper_ingot"

-- Simple Wooden Table --
"luxury_decor:jungle_wooden_plank", "luxury_decor:jungle_wooden_plank", "luxury_decor:jungle_wooden_plank", "default:stick", "luxury_decor:jungle_wooden_plank", "default:stick"

-- Wooden Drawer --
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "", "",
"default:stick", "", ""

-- Kitchen Wooden Cabinet With Two Drawers --
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "", ""

-- Kitchen Wooden Cabinet With Only Door --
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "", "",
"luxury_decor:wooden_board", "", ""

-- Kitchen Wooden Cabinet With Door And Drawer --
"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "", ""

-- Kitchen Wooden Cabinet With Two Doors --
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "", ""

-- Kitchen Wooden Cabinet With Two Doors And Drawer --
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "",
"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""

-- Kitchen Wooden Half-Cabinet --
"luxury_decor:wooden_board", "luxury_decor:wooden_drawer--", "",
"luxury_decor:wooden_board", "", "",

-- Kitchen Wooden Cabinet With Three Drawers --
"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", "",
"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", "",
"luxury_decor:wooden_board", "luxury_decor:wooden_drawer", ""

-- Kitchen Wooden Cabinet With Sink --
"luxury_decor:wooden_board", "luxury_decor:siphon", "dye:grey",
"luxury_decor:wooden_board", "luxury_decor:plastic_sheet", "",
"luxury_decor:wooden_board", "default:steel_ingot", ""

-- Fridge --
"default:steelblock", "luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet",
"luxury_decor:brass_ingot", "luxury_decor:plastic_sheet", "",
"dye:dark_grey", "", ""

-- Kitchen Tap --
"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "",
"default:steel_ingot", "", ""

-- Cooker --
"default:steel_ingot", "luxury_decor:plastic_sheet", "xpanes:pane_flat",
"default:steel_ingot", "luxury_decor:plastic_sheet", "",
"default:steel_ingot", "luxury_decor:brass_stick", ""

-- Siphon --
"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "",
"default:copper_ingot", "", ""

-- Dial --
"luxury_decor:plastic_sheet", "dye:black", "",
"luxury_decor:brass_stick", "", "",
"dye:yellow", "", ""

-- Plastic Sheet --
"default:leaves"

-- Incandescent Bulb --
"luxury_decor:plastic_sheet", "luxury_decor:wolfram_wire_reel", "",
"luxury_decor:plastic_sheet", "default:steel_ingot", ""

-- Wolfram Wire Reel --
"luxury_decor:wolfram_ingot"

-- Iron Chandelier --
"default:steel_ingot", "default:steel_ingot", "default:steel_ingot",
"default:steel_ingot", "default:steel_ingot", "dye:grey",
"luxury_decor:wax_lump", "luxury_decor:wax_lump"

-- Luxury Desk Lamp --
"luxury_decor:jungle_wooden_plank", "wool:white", "",
"luxury_decor:jungle_wooden_plank", "luxury_decor:incandescent_bulb", "",
"luxury_decor:jungle_wooden_plank", "luxury_decor:brass_ingot", ""

-- Wall Glass Lamp --
"default:glass", "default:glass", "",
"luxury_decor:brass_ingot", "dye:orange", "",
"luxury_decor:incandescent_bulb", "", ""

-- Simple Armchair With Pillow --
"luxury_decor:wooden_board", "wool:white", "dye:<color>",
"luxury_decor:wooden_board", "wool:white", "dye:<color>",
"default:stick", "", ""

-- Simple Sofa --
"luxury_decor:wooden_board", "luxury_decor:wooden_board", "wool:white",
"luxury_decor:wooden_board", "dye:<color>", "dye:grey",
"default:stick", "luxury_decor:brass_stick", ""

-- Simple Footstool --
"luxury_decor:wooden_board", "wool:white", "dye:<color>",
"luxury_decor:wooden_board", "wool:white", "dye:<color>",
"luxury_decor:wooden_plank", "", ""

-- Simple Wooden Wall Clock --
"luxury_decor:jungle_wooden_board", "luxury_decor:jungle_wooden_board", "",
"luxury_decor:jungle_wooden_plank", "luxury_decor:brass_stick", "luxury_decor:dial",
"default:copper_ingot", "default:steel_ingot", ""

-- Grand Piano --
"luxury_decor:plastic_sheet", "luxury_decor:brass_stick", "dye:black",
"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "dye:black",
"luxury_decor:plastic_sheet", "luxury_decor:wolfram_ingot", "default:steel_ingot"

-- Simple Flowerpot --
"default:clay_lump", "default:clay_lump", "dye:brown",
"default:clay_lump", "default:dirt", "",
"default:clay_lump", "", ""

-- Luxury Flowepor --
"default:clay_lump", "default:clay_lump", "dye:red",
"default:clay_lump","default:dirt", "default:copper_ingot",
"default:clay_lump", "", ""

--  Lampshade  --
"wool:white", "luxury_decor:brass_ingot", "",
"luxury_decor:steel_scissors", "", ""

--  Lampshades  --
"luxury_decor:lampshade", "luxury_decor:lampshade", "luxury_decor:lampshade"

--  Incandescent Bulbs  --
"luxury_decor:incandescent_bulb", "luxury_decor:incandescent_bulb", "luxury_decor:incandescent_bulb"

--  Scissors  --
"default:steel_ingot", "default:stick", "",
"default:stick", "", ""

--  Royal Brass Chandelier  --
"luxury_decor:brass_ingot", "luxury_decor:brass_ingot", "luxury_decor:brass_ingot",
"luxury_decor:brass_ingot", "luxury_decor:lampshades", "default:glass",
"dye:yellow", "luxury_decor:incandescent_bulbs", "default:gold_ingot"

--  Luxury Steel Chandelier  --
"default:steel_ingot", "default:glass", "luxury_decor:brass_ingot",
"default:steel_ingot", "default:steel_ingot", "default:glass",
"luxury_decor:incandescent_bulbs", "", ""

--  Brass Candlestick With One Candle --
"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:wax_lump",
"luxury_decor:brass_stick", "", ""

--  Brass Candlestick With Three Candles  --
"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:wax_lump",
"luxury_decor:brass_stick", "luxury_decor:wax_lump", "luxury_decor:brass_stick",
"luxury_decor:brass_stick", "luxury_decor:brass_stick", "luxury_decor:wax_lump"

--  Simple Plastic Chandelier  --
"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "luxury_decor:wooden_plank",
"luxury_decor:plastic_sheet", "dye:<color>", "luxury_decor:lampshades",
"luxury_decor:incandescent_bulbs", "", ""
  
 --  Plastic Desk Lamp  --
"luxury_decor:plastic_sheet", "luxury_decor:brass_stick", "luxury_decor:brass_stick",
"luxury_decor:plastic_sheet", "dye:"..color, "luxury_decor:lampshade",
"luxury_decor:plastic_sheet", "luxury_decor:incandescent_bulb", ""

--  Ceiling Lantern  --
"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "luxury_decor:brass_stick",
"xpanes:pane_flat", "xpanes:pane_flat", "luxury_decor:incandescent_bulb",
"default:diamond", "luxury_decor:zinc_ingot", "dye:black"

--  Wall Lantern  --
"luxury_decor:plastic_sheet", "luxury_decor:plastic_sheet", "xpanes:pane_flat",
"luxury_decor:plastic_sheet", "xpanes:pane_flat", "luxury_decor:incandescent_bulb",
"default:diamond", "dye:black", ""
        
Cooking:
-- Wax Lump --
"luxury_decor:paraffin_cake"

-- Paraffin Cake --
"bucket:bucket_oil"

-- Wolfram Ingot --
"luxury_decor:wolfram_lump"

-- Brass Ingot --
"luxury_decor:copper_and_zinc"
-- Simple Wooden Bedside Table --
"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""
"luxury_decor:pine_wooden_board", "luxury_decor:bedside_drawer", ""

## Code/Textures/Sounds License
MIT

## Mod Dependencies
default

## TODO List
Below is a listing of what is considered to be added in next versions.

* Add more kitchen/bathroom styles (luxury, royal, classic, modern and etc. )
* Improve models and textures of some furniture (royal beds, luxury wooden chair with cushion, pots, )
* Add chandeliers and candlesticks of different sorts.
* Add curtains/blinds of different sorts.
* Add a possibility to play pianos.
* Add a possibility to grow flowers in the pots.
* Add crafting recipes for all items and respectively more crafting ingredients. [HIGH PRIORITY]
* Fix a bug that happens by double opening the cabinets. [HIGH PRIORITY]
* Make the sofas connecting between themselves properly. [HIGH PRIORITY]
* Add decorations of different course.
* Add exterior stuff (summer tables, chairs, char grill, umbrellas and etc).
* Add windows (including openable/closable).
* Add doors of various styles.
* Add wardrobes/cupboards and ingredients for their building.
* Add more sorts of tables/desks and chairs.
* Add more sorts of sofas/footstools and armchairs.
* Add wall papers for different rooms and wall/floor tiles for bathrooms/kitchens.
* Add more floors types.
And more...

## Version Compatibility
5.0.0-dev ++
