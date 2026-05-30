GLOBAL.setmetatable(env, {
    __index = function(t, k)
        return GLOBAL.rawget(GLOBAL, k)
    end
})

PrefabFiles =
{
    "miaoji",
    "miaoji_none",
    "miaoji_bg",
    "miaoji_bg_plus",
    "miaoji_bg_plus_plus",
    "miaoji_claw",
    "miaoji_sword",
    "miaoji_sword_plus",
    "miaoji_sword_plus_plus",
    "miaoji_amulet",
    "miaoji_amulet_plus",
    "miaoji_heartstring",
    "miaoji_heartstring_plus",
    "miaoji_heartstring_arrow",
    "miaoji_prismatic_crown",
    "miaoji_prismatic_crown_plus",
}

Assets = {

    -- 存档槽位肖像
    Asset("IMAGE", "images/saveslot_portraits/miaoji.tex"),
    Asset("ATLAS", "images/saveslot_portraits/miaoji.xml"),

    -- 角色选择界面肖像
    Asset("IMAGE", "images/selectscreen_portraits/miaoji.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/miaoji.xml"),
    
    -- 角色选择界面剪影
    Asset("IMAGE", "images/selectscreen_portraits/miaoji_silho.tex"),
    Asset("ATLAS", "images/selectscreen_portraits/miaoji_silho.xml"),

    -- 检查界面大图
    Asset("IMAGE", "bigportraits/miaoji.tex"),
    Asset("ATLAS", "bigportraits/miaoji.xml"),
    
    -- 小地图图标
    Asset("IMAGE", "images/map_icons/miaoji.tex"),
    Asset("ATLAS", "images/map_icons/miaoji.xml"),
    
    -- 玩家列表头像
    Asset("IMAGE", "images/avatars/avatar_miaoji.tex"),
    Asset("ATLAS", "images/avatars/avatar_miaoji.xml"),
    
    -- 幽灵状态头像
    Asset("IMAGE", "images/avatars/avatar_ghost_miaoji.tex"),
    Asset("ATLAS", "images/avatars/avatar_ghost_miaoji.xml"),
    
    -- 自我检查界面图片
    Asset("IMAGE", "images/avatars/self_inspect_miaoji.tex"),
    Asset("ATLAS", "images/avatars/self_inspect_miaoji.xml"),

    -- 人物主体资源
	Asset( "ANIM", "anim/miaoji.zip" ),

    -- 猫猫包
    Asset("ATLAS", "images/inventoryimages/miaoji_bg.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_bg.tex"),

    -- 猫猫包plus
    Asset("ATLAS", "images/inventoryimages/miaoji_bg_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_bg_plus.tex"),
    
    -- 猫猫包plusplus
    Asset("ATLAS", "images/inventoryimages/miaoji_bg_plus_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_bg_plus_plus.tex"),
    
    -- 猫猫爪
    Asset("ATLAS", "images/inventoryimages/miaoji_claw.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_claw.tex"),
    
    -- 喵刀
    Asset("ATLAS", "images/inventoryimages/miaoji_sword.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_sword.tex"),

    Asset("ATLAS", "images/inventoryimages/miaoji_sword_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_sword_plus.tex"),

    Asset("ATLAS", "images/inventoryimages/miaoji_sword_plus_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_sword_plus_plus.tex"),
    
    -- 猫灵护符
    Asset("ATLAS", "images/inventoryimages/miaoji_amulet.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_amulet.tex"),
    
    Asset("ATLAS", "images/inventoryimages/miaoji_amulet_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_amulet_plus.tex"),

    -- 心弦
    Asset("ATLAS", "images/inventoryimages/miaoji_heartstring.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_heartstring.tex"),
    
    Asset("ATLAS", "images/inventoryimages/miaoji_heartstring_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_heartstring_plus.tex"),

    -- 彩棱头冠
    Asset("ATLAS", "images/inventoryimages/miaoji_prismatic_crown.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_prismatic_crown.tex"),
    
    Asset("ATLAS", "images/inventoryimages/miaoji_prismatic_crown_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_prismatic_crown_plus.tex"),
}

-- 注册到物品栏
AddMinimapAtlas("images/map_icons/miaoji.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_bg.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_bg_plus.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_bg_plus_plus.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_claw.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_sword.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_sword_plus.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_sword_plus_plus.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_amulet.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_amulet_plus.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_heartstring.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_heartstring_plus.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_prismatic_crown.xml")
AddMinimapAtlas("images/inventoryimages/miaoji_prismatic_crown_plus.xml")

-- 人物配置
local LEVEL_MAX = GetModConfigData("MAX_LEVEL")
local LEVEL_DMG_RATE = GetModConfigData("LEVEL_DAMAGE_RATE")
local LEVEL_SPEED_RATE = GetModConfigData("LEVEL_SPEED_RATE")
local DUSK_MODE = GetModConfigData("DUSK_MODE")
local NIGHT_MODE = GetModConfigData("NIGHT_MODE")
local NIGHT_VISION = GetModConfigData("NIGHT_VISION")
local ENABLE_BOOK_POWER  = GetModConfigData("ENABLE_BOOK_POWER")
local BOOK_SANITY_MULT   = GetModConfigData("BOOK_SANITY_MULT")
local BOOK_UNLOCK_LEVEL  = GetModConfigData("BOOK_UNLOCK_LEVEL")

AddPlayerPostInit(function(inst)
    if inst.prefab == "miaoji" then
        inst._LEVEL_MAX = LEVEL_MAX or 50
        inst._LEVEL_DMG_RATE = LEVEL_DMG_RATE or 0.015
        inst._LEVEL_SPEED_RATE = LEVEL_SPEED_RATE or 0.05
        inst._DUSK_MODE = DUSK_MODE or 0
        inst._NIGHT_MODE = NIGHT_MODE or 0
        inst._NIGHT_VISION = NIGHT_VISION or false

        inst._ENABLE_BOOK_POWER = ENABLE_BOOK_POWER or false
        inst._BOOK_SANITY_MULT = BOOK_SANITY_MULT or true
        inst._BOOK_UNLOCK_LEVEL = BOOK_UNLOCK_LEVEL or 10
    end
end)

-- 其他配置
local ENABLE_MIAOJI_WHIP = GetModConfigData("ENABLE_MIAOJI_WHIP")
TUNING.MIAOJI_CROWN_WATER_WALK =
    GetModConfigData("CROWN_WATER_WALK") == true



-- miaoji影盾设置
local function PatchSG(sg)
    if sg == nil then return end

    local function PatchEvent(evname)
        local ev = sg.events[evname]
        if ev and ev.fn and not ev._patched then
            local oldfn = ev.fn
            ev.fn = function(inst, data)
                if inst:HasTag("miaoji_amulet_noknock") then
                    return
                end
                return oldfn(inst, data)
            end
            ev._patched = true
        end
    end

    PatchEvent("attacked")
    PatchEvent("knockback")
    PatchEvent("knockbacklanded")
end

AddStategraphPostInit("wilson", PatchSG)
AddStategraphPostInit("wilson_client", PatchSG)


-- 人物
AddModCharacter("miaoji", "MALE")

-- mod文本信息
modimport("scripts/main/miaoji_str.lua")
-- 配方
modimport("scripts/main/miaoji_recipes.lua")
-- 背包框架
modimport("scripts/containers/miaoji_bg.lua")
modimport("scripts/containers/miaoji_bg_plus.lua")
modimport("scripts/containers/miaoji_bg_plus_plus.lua")
-- 修改原版三尾猫鞭
if ENABLE_MIAOJI_WHIP then
    modimport("scripts/postinit/whip_miaoji.lua")
end