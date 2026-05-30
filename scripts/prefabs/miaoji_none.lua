local prefabs = {}

table.insert(prefabs, CreatePrefabSkin("miaoji_none", {
    assets = {
        -- 角色本体动画
        Asset("ANIM", "anim/miaoji.zip"),
        -- 幽灵动画
        Asset("ANIM", "anim/ghost_miaoji_build.zip"),
    },

    skins = {
        normal_skin = "miaoji",              -- 正常状态 build
        ghost_skin  = "ghost_miaoji_build",  -- 幽灵状态 build
    },

    base_prefab = "miaoji",                 -- 角色 prefab 名
    build_name_override = "miaoji",          -- 覆盖使用的 build 名

    type = "base",                           -- base = 默认皮肤
    rarity = "Character",                   -- 角色皮肤

    skin_tags = {
        "BASE",
        "MIAOJI",
        "CHARACTER",
    },
}))

return unpack(prefabs)
