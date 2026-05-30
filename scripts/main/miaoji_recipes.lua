RegisterInventoryItemAtlas("images/inventoryimages/miaoji_bg.xml", "miaoji_bg.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_bg_plus.xml", "miaoji_bg_plus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_bg_plus_plus.xml", "miaoji_bg_plus_plus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_claw.xml", "miaoji_claw.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_sword.xml", "miaoji_sword.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_sword_plus.xml", "miaoji_sword_plus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_sword_plus_plus.xml", "miaoji_sword_plus_plus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_amulet.xml", "miaoji_amulet.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_amulet_plus.xml", "miaoji_amulet_plus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_heartstring.xml", "miaoji_heartstring.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_heartstring_plus.xml", "miaoji_heartstring_plus.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_prismatic_crown.xml", "miaoji_prismatic_crown.tex")
RegisterInventoryItemAtlas("images/inventoryimages/miaoji_prismatic_crown_plus.xml", "miaoji_prismatic_crown_plus.tex")


AddRecipe2("miaoji_bg", {
    Ingredient("silk", 6),
    Ingredient("rope", 2),
    Ingredient("twigs", 6),
    Ingredient("goldnugget", 3),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,                -- 可不受解锁限制
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

AddRecipe2("miaoji_bg_plus", {
    Ingredient("miaoji_bg", 1),
    Ingredient("redgem", 1),
    Ingredient("bluegem", 1),
    Ingredient("purplegem", 1),
    Ingredient("nightmarefuel", 10),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,                -- 可不受解锁限制
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

AddRecipe2("miaoji_bg_plus_plus", {
    Ingredient("miaoji_bg_plus", 1),
    Ingredient("opalpreciousgem", 1),
    Ingredient("walrus_tusk", 1),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,                -- 可不受解锁限制
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 猫猫爪
AddRecipe2("miaoji_claw",{
    Ingredient("twigs", 2),
    Ingredient("boneshard", 4),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 喵刀
AddRecipe2("miaoji_sword",{
    Ingredient("coontail", 2),
    Ingredient("goldnugget", 4),
    Ingredient("cutstone", 3),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 喵刀+
AddRecipe2("miaoji_sword_plus",{
    Ingredient("miaoji_sword", 1),
    Ingredient("thulecite", 4),
    Ingredient("livinglog", 3),
    Ingredient("purplegem", 2),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 喵刀++
AddRecipe2("miaoji_sword_plus_plus",{
    Ingredient("miaoji_sword_plus", 1),
    Ingredient("cane", 1),
    Ingredient("yellowstaff", 1),
    Ingredient("moonglass", 3),
    Ingredient("horrorfuel", 3),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 猫灵护符
AddRecipe2("miaoji_amulet",{
    Ingredient("thulecite", 3),
    Ingredient("nightmarefuel", 4),
    Ingredient("orangegem", 1),
    Ingredient("redgem", 5),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 猫灵护符+
AddRecipe2("miaoji_amulet_plus",{
    Ingredient("miaoji_amulet", 1),
    Ingredient("heatrock", 1),
    Ingredient("featherfan", 1),
    Ingredient("beefalohat", 1),
    Ingredient("jellybean", 1),
},TECH.MAGIC_TWO,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

-- 心弦
AddRecipe2("miaoji_heartstring",{
    Ingredient("purplegem", 1),
    Ingredient("livinglog", 3),
    Ingredient("nightmarefuel", 4),
},TECH.MAGIC_ONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 心弦+
AddRecipe2("miaoji_heartstring_plus",{
    Ingredient("miaoji_heartstring", 1),
    Ingredient("thulecite", 4),
    Ingredient("opalpreciousgem", 1),
},TECH.MAGIC_TWO,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 彩棱王冠
AddRecipe2("miaoji_prismatic_crown",{
    Ingredient("marble", 12),
    Ingredient("purplegem", 1),
    Ingredient("feather_robin", 3),
    Ingredient("nightmarefuel", 4),
    Ingredient("goldnugget", 3),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
-- 彩棱王冠+
AddRecipe2("miaoji_prismatic_crown_plus",{
    Ingredient("miaoji_prismatic_crown", 1),
    Ingredient("thulecite", 4),
    Ingredient("moonglass", 8),
    Ingredient("opalpreciousgem", 1),
},TECH.NONE,{
    builder_tag = "miaoji",
    nounlock = true,
},{ 
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
------------------------------------------------------------
-- 原版配方
------------------------------------------------------------

-- 小肉 → 小鱼块
AddRecipe2("fishmeat_small", {
    Ingredient("smallmeat", 1),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

-- 小鱼块 → 小肉
AddRecipe2("smallmeat", {
    Ingredient("fishmeat_small", 1),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

-- 大肉 → 大鱼块
AddRecipe2("fishmeat", {
    Ingredient("meat", 1),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

-- 大鱼块 → 大肉
AddRecipe2("meat", {
    Ingredient("fishmeat", 1),
}, TECH.NONE, {
    builder_tag = "miaoji",
    nounlock = true,
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

-- 牛毛 → 猫尾
AddRecipe2("coontail", {
    Ingredient("beefalowool", 2),
}, TECH.SCIENCE_TWO, {
    builder_tag = "miaoji",
    nounlock = true,
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})

-- 各色宝石 → 彩虹宝石
AddRecipe2("opalpreciousgem", {
    Ingredient("redgem", 1),
    Ingredient("bluegem", 1),
    Ingredient("purplegem", 1),
    Ingredient("orangegem", 1),
    Ingredient("greengem", 1),
    Ingredient("yellowgem", 1),
}, TECH.MAGIC_TWO, {
    builder_tag = "miaoji",
    nounlock = true,
}, {
    "CHARACTER",
    "MODS",
    "EVRERYTHING"
})
