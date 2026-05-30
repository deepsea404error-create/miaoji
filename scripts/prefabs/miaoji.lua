----------------------------------------------------------------
-- 引入官方玩家角色创建模块
----------------------------------------------------------------
local MakePlayerCharacter = require "prefabs/player_common"

----------------------------------------------------------------
-- 资源声明
----------------------------------------------------------------
local assets =
{
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}

----------------------------------------------------------------
-- 预制体列表
----------------------------------------------------------------
local prefabs = {}
----------------------------------------------------------------
-- 初始物品
----------------------------------------------------------------
local start_inv = {
    "miaoji_claw",
    "miaoji_bg",
}
----------------------------------------------------------------
-- =================== 常量配置 ===================
----------------------------------------------------------------

-- 每级经验需求
local function GetExpNeedByLevel(lv)
    if lv <= 10 then
        return 400
    elseif lv <= 20 then
        return 800
    elseif lv <= 30 then
        return 1200
    elseif lv <= 40 then
        return 1600
    else
        return 2000
    end
end

-- 夜视光照成长
local LIGHT_PER_5_LEVEL = 0.4

----------------------------------------------------------------
-- =================== 状态倍率表 ===================
----------------------------------------------------------------
local DUSK_DAMAGE_MULT      = {[0]=1, [1]=1.1,  [2]=1.2}
local DUSK_SANITY_RECOVER   = {[0]=0, [1]=2,    [2]=4}
local NIGHT_DAMAGE_MULT     = {[0]=1, [1]=1.25, [2]=1.5}
local NIGHT_SANITY_RECOVER  = {[0]=0, [1]=4,    [2]=6}

--------------------------------------------------
-- =================== 夜晚光照 ===================
--------------------------------------------------
local function SpawnNightLight(inst)
    local light = SpawnPrefab("minerhatlight")
    light.entity:SetParent(inst.entity)

    local bonus = math.floor((inst._level or 1) / 5) * LIGHT_PER_5_LEVEL
    light.Light:SetRadius(1.6 + bonus)
    light.Light:SetFalloff(0.8)
    light.Light:SetIntensity(0.8)
    light.Light:SetColour(235/255, 255/255, 255/255)
    light.Light:Enable(true)

    light:AddTag("FX")
    inst._nightlight = light
end
----------------------------------------------------------------
-- =================== 书籍能力刷新 ===================
----------------------------------------------------------------
local function RefreshBookPower(inst)
    if not inst._ENABLE_BOOK_POWER then
        return
    end

    if inst._level >= inst._BOOK_UNLOCK_LEVEL then
        -- 已解锁
        if inst.components.reader == nil then
            inst:AddComponent("reader")
        end

        inst:AddTag("bookbuilder")
        if inst._BOOK_SANITY_MULT then
            inst:AddTag("bookreader")
        end

    else
        -- 未解锁时移除能力（很关键）
        if inst.components.reader ~= nil then
            inst:RemoveComponent("reader")
        end

        inst:RemoveTag("bookbuilder")
        inst:RemoveTag("bookreader")
    end
end
----------------------------------------------------------------
-- =================== 状态刷新 ===================
----------------------------------------------------------------
local function UpdateState(inst)
    if inst:HasTag("playerghost") then
        return
    end

    local phase   = TheWorld.state.phase
    local is_cave = TheWorld:HasTag("cave")

    -- 重置伤害倍率
    inst.components.combat.damagemultiplier = inst._level_damage_mult or 1

    -- 清理夜视光源
    if inst._nightlight then
        inst._nightlight:Remove()
        inst._nightlight = nil
    end

    -- 洞穴（永夜）
    if is_cave then
        inst.components.combat.damagemultiplier =
            inst.components.combat.damagemultiplier *
            NIGHT_DAMAGE_MULT[inst._NIGHT_MODE or 0]

        if inst._NIGHT_VISION then
            SpawnNightLight(inst)
        end

    -- 地表夜晚
    elseif phase == "night" then
        inst.components.combat.damagemultiplier =
            inst.components.combat.damagemultiplier *
            NIGHT_DAMAGE_MULT[inst._NIGHT_MODE or 0]

        if inst._NIGHT_VISION then
            SpawnNightLight(inst)
        end

    -- 地表黄昏
    elseif phase == "dusk" then
        inst.components.combat.damagemultiplier =
            inst.components.combat.damagemultiplier *
            DUSK_DAMAGE_MULT[inst._DUSK_MODE or 0]
    end
end

----------------------------------------------------------------
-- =================== 等级系统 ===================
----------------------------------------------------------------
local function RefreshLevelStats(inst)
    local lv = inst._level or 1

    local LEVEL_DMG_RATE   = inst._LEVEL_DMG_RATE   or 0.015
    local LEVEL_SPEED_RATE = inst._LEVEL_SPEED_RATE or 0.05

    inst.components.health:SetMaxHealth(150 + lv * 5)
    inst.components.hunger:SetMax(150 + lv * 3)
    inst.components.sanity:SetMax(200 + lv * 3)

    inst._level_damage_mult = 1 + lv * LEVEL_DMG_RATE

    local speed_lv = math.floor(lv / 5)
    inst.components.locomotor:SetExternalSpeedMultiplier(
        inst, "miaoji_level_speed", 1 + speed_lv * LEVEL_SPEED_RATE
    )
    -- 更新状态
    UpdateState(inst)
    -- 更新书籍能力系统
    RefreshBookPower(inst)
end

local function ShowExp(inst)
    if inst.components.talker then
        inst.components.talker:Say(
            string.format("LV%02d  %d/%d", inst._level, inst._exp, inst._exp_need)
        )
    end
end

local function AddExp(inst, amount)
    local LEVEL_MAX = inst._LEVEL_MAX or 50
    if inst._level >= LEVEL_MAX then return end

    inst._exp = inst._exp + amount

    while inst._exp >= inst._exp_need and inst._level < LEVEL_MAX do
        inst._exp = inst._exp - inst._exp_need
        inst._level = inst._level + 1
        inst._exp_need = GetExpNeedByLevel(inst._level)
        RefreshLevelStats(inst)
    end

    ShowExp(inst)
end

----------------------------------------------------------------
-- =================== 存档系统（关键） ===================
----------------------------------------------------------------

-- 保存（地表 / 洞穴通用）
local function OnSaveMiaoji(inst, data)
    data.level        = inst._level
    data.exp          = inst._exp
    data.exp_need     = inst._exp_need
    data.dusk_mode    = inst._DUSK_MODE
    data.night_mode   = inst._NIGHT_MODE
    data.night_vision = inst._NIGHT_VISION
end

-- 读取（地表 / 洞穴通用）
local function OnLoadMiaoji(inst, data)
    if data then
        inst._level        = data.level or 1
        inst._exp          = data.exp or 0
        inst._exp_need     = data.exp_need or GetExpNeedByLevel(inst._level)
        inst._DUSK_MODE    = data.dusk_mode or 0
        inst._NIGHT_MODE   = data.night_mode or 0
        inst._NIGHT_VISION = data.night_vision or false
    end

    RefreshLevelStats(inst)

    inst:DoTaskInTime(0, function()
        UpdateState(inst)
        ShowExp(inst)
    end)
end

----------------------------------------------------------------
-- =================== 客户端初始化 ===================
----------------------------------------------------------------
local function common_postinit(inst)
    -- 设置小地图图标
    inst.MiniMapEntity:SetIcon("miaoji.tex")
    -- 添加角色专属标签，可用于技能判定、物品限制等
    inst:AddTag("miaoji")
    -- 添加猴子诅咒免疫标签
    inst:AddTag("upkit_nocurse")
end

----------------------------------------------------------------
-- =================== 服务端初始化 ===================
----------------------------------------------------------------
local function master_postinit(inst)

    if not TheWorld.ismastersim then
        return
    end

    inst.soundsname = "willow"

    -- 基础三围
    inst.components.health:SetMaxHealth(150)
    inst.components.hunger:SetMax(150)
    inst.components.sanity:SetMax(200)

    -- 等级初始化（新角色）
    inst._level = inst._level or 1
    inst._exp = inst._exp or 0
    inst._exp_need = inst._exp_need or GetExpNeedByLevel(inst._level)
    inst._level_damage_mult = 1

    RefreshLevelStats(inst)
    inst:DoTaskInTime(0, ShowExp)

    ------------------------------------------------
    -- 击杀获得经验
    ------------------------------------------------
    inst:ListenForEvent("killed", function(_, data)
        if data and data.victim and data.victim.components.health then
            local maxhp = data.victim.components.health.maxhealth or 0
            local gain = math.min(math.floor(maxhp / 20), 500)
            if gain > 0 then
                AddExp(inst, gain)
            end
        end
    end)

    -- 世界状态监听(时间变化)
    inst:WatchWorldState("phase", function() UpdateState(inst) end)
    -- 世界状态监听(下洞穴变化)
    inst:WatchWorldState("iscave", function() UpdateState(inst) end)
    -- 延迟0秒后立即更新一次状态（确保初始状态正确）
    inst:DoTaskInTime(0, function() 
        UpdateState(inst) 
        RefreshBookPower(inst)--书籍能力
    end)

    --免疫猴子诅咒
    if inst.components.cursable then 
        inst.components.cursable.IsCursable = function(...)
            return false
        end
        inst.components.cursable.ApplyCurse = function(...)
            -- 空函数，什么都不做
        end
    end


    -----------------------------------------------
    -- ================= SAN 系统 =================
    -----------------------------------------------
    -- 免疫理智流失
    inst.components.sanity:SetLightDrainImmune(true)   -- 免疫黑暗理智流失
    inst.components.sanity:SetPlayerGhostImmunity(true)  -- 免疫幽灵状态惩罚
    -- inst.components.sanity:SetNegativeAuraImmunity(true)  -- 免疫怪物负面光环
    

    inst.components.sanity.custom_rate_fn = function(inst)
        local phase = TheWorld.state.phase
        local is_cave = TheWorld:HasTag("cave")
        if phase == "dusk" and not is_cave then
            return (DUSK_SANITY_RECOVER[inst._DUSK_MODE or 0] or 0) / 60
        elseif phase == "night" or is_cave then
            return (NIGHT_SANITY_RECOVER[inst._NIGHT_MODE or 0] or 0) / 60
        end
        return 0
    end
    ------------------------------------------------------------------
    -- ================= 自定义食物逻辑 =================
    -- 1. 完全免疫过期食物负面效果
    -- 2. 所有鱼类 & 鱼类料理 正面效果 ×1.5
    --    （在 Eat() 之前生效，料理必定生效）
    ------------------------------------------------------------------

    -- 指定料理列表（对应 prefab 名）
    local SPECIFIC_FOODS = {
        "surfnturf",               -- 海鲜牛排
        "moqueca",                 -- 海鲜杂烩
        "frogfishbowl",            -- 蓝带鱼排
        "barnaclestuffedfishhead", -- 酿鱼头
        "lobsterdinner",           -- 龙虾正餐
        "ceviche",                 -- 酸橘汁腌鱼
        "californiaroll",          -- 加州卷
        "seafoodgumbo",            -- 海鲜浓汤
        "fishsticks",              -- 炸鱼排
        "fishtacos",               -- 鱼肉玉米卷
    }

    -- 工具函数：判断是否是指定料理
    local function IsSpecialFood(food)
        if food == nil then return false end
        for _, name in ipairs(SPECIFIC_FOODS) do
            if food.prefab == name then
                return true
            end
        end
        return false
    end

    -- 工具函数：判断是否是鱼类
    local function IsFishFood(food)
        if food == nil then return false end
        if food:HasTag("fish") or food:HasTag("fishmeat") then
            return true
        end
        return false
    end

    -- Eat 重写
    local selfeater = inst.components.eater
    selfeater.ignoresspoilage = true -- 忽略腐烂负面

    local old = selfeater.Eat
    function inst.components.eater:Eat(food)
        if not selfeater:CanEat(food) then
            return old(selfeater, food)
        end

        local edible = food.components.edible
        if not edible then
            return old(selfeater, food)
        end

        -- 保存原始数值
        local health = edible.healthvalue or 0
        local hunger = edible.hungervalue or 0
        local sanity = edible.sanityvalue or 0
        -- 保存原始数值
        local old_health = edible.healthvalue or 0
        local old_hunger = edible.hungervalue or 0
        local old_sanity = edible.sanityvalue or 0

        -- ========== 腐烂食物无负面 ==========
        if food.components.perishable and food.components.perishable:IsSpoiled() then
            if health < 0 then food.edible.healthvalue = 0 end
            if sanity < 0 then food.edible.sanityvalue = 0 end
        end

        -- ========== 鱼类 ========== 
        if IsFishFood(food) then
            health = math.max(0, health) * 2
            hunger = math.max(0, hunger) * 2
            sanity = math.max(0, sanity) + 20
            AddExp(inst, 10)
            print("最大等级")
            print(inst._LEVEL_MAX)
            print("伤害成长倍率")
            print(inst._LEVEL_DMG_RATE)
            print("速度成长倍率")
            print(inst._LEVEL_SPEED_RATE)
        -- ========== 指定料理 ==========
        elseif IsSpecialFood(food) then
            health = math.max(0, health) * 1.5
            hunger = math.max(0, hunger) * 1.5
            sanity = math.max(0, sanity) + 10
            AddExp(inst, 10)
        end

        food.components.edible.healthvalue = health
        food.components.edible.hungervalue = hunger
        food.components.edible.sanityvalue = sanity

        local ret = old(selfeater, food)
        -- 回复原本数值
        food.components.edible.healthvalue = old_health
        food.components.edible.hungervalue = old_hunger
        food.components.edible.sanityvalue = old_sanity

        return ret
    end

    -- 绑定存档函数（关键）
    inst.OnSave = OnSaveMiaoji
    inst.OnLoad = OnLoadMiaoji
end

----------------------------------------------------------------
-- =================== 返回角色定义 ===================
----------------------------------------------------------------
-- ================ 返回角色Prefab定义 ================
-- 参数说明：
-- "miaoji" - 角色Prefab名称（必须与文件名一致）
-- prefabs - 需要预加载的附加prefab列表
-- assets - 资源列表
-- common_postinit - 客户端初始化函数
-- master_postinit - 服务端初始化函数
-- start_inv - 人物初始携带
return MakePlayerCharacter(
    "miaoji",              -- 角色ID，必须唯一
    prefabs,               -- 相关prefab列表
    assets,                -- 资源列表
    common_postinit,       -- 客户端初始化
    master_postinit,       -- 服务端初始化
    start_inv              -- 初始物品
)

