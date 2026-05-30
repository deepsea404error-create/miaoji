------------------------------------------------------------------
-- 彩棱王冠（普通版）
-- prefab: miaoji_prismatic_crown
-- 作者：DeepSea404
-- 功能：
-- 1. 80% 护甲（2000 耐久）+ 10 位面防御
-- 2. +5 / 分钟理智
-- 3. 攻击时 10% 概率回复 2 生命（仅miaoji）
-- 4. 反伤 30（仅miaoji）
-- 5. 可用宝石修复耐久
--    红 / 蓝宝石：25%
--    紫宝石：50%
------------------------------------------------------------------

local assets =
{
    Asset("ANIM",  "anim/miaoji_prismatic_crown.zip"),
    Asset("ATLAS", "images/inventoryimages/miaoji_prismatic_crown.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_prismatic_crown.tex"),
}

local prefabs = {}

----------------------------------------------------------------
-- 常量配置
----------------------------------------------------------------
local ARMOR_ABSORB   = 0.8       -- 80% 护甲
local ARMOR_MAX     = 2000      -- 最大耐久
local PLANAR_DEF     = 10        -- 位面防御
local DAPPERNESS    = 5 / 60     -- +5 / 分钟理智
local THORNS_DAMAGE = 30         -- 反伤
local HEAL_CHANCE   = 0.1        -- 10%
local HEAL_AMOUNT   = 2

----------------------------------------------------------------
-- 战斗相关
----------------------------------------------------------------

-- 攻击时概率回血
local function OnHitOther(owner, data)
    if math.random() < HEAL_CHANCE then
        if owner.components.health ~= nil then
            owner.components.health:DoDelta(
                HEAL_AMOUNT,
                nil,
                "miaoji_prismatic_crown"
            )
        end
    end
end

-- 受到攻击时反伤
local function OnAttacked(owner, data)
    if data ~= nil
        and data.attacker ~= nil
        and data.attacker.components.health ~= nil then

        data.attacker.components.health:DoDelta(
            -THORNS_DAMAGE,
            nil,
            "miaoji_prismatic_crown"
        )
    end
end

----------------------------------------------------------------
-- 位面防御管理
----------------------------------------------------------------
local function ApplyPlanarDefense(inst, owner)
    if owner.components.planardefense == nil then
        owner:AddComponent("planardefense")
    end
    owner.components.planardefense:AddBonus(
        inst,
        PLANAR_DEF,
        "miaoji_prismatic_crown"
    )
end

local function RemovePlanarDefense(inst, owner)
    if owner.components.planardefense ~= nil then
        owner.components.planardefense:RemoveBonus(
            inst,
            "miaoji_prismatic_crown"
        )
    end
end

----------------------------------------------------------------
-- 装备 / 卸下
----------------------------------------------------------------
local function OnEquip(inst, owner)
    ----------------------------------------------------------------
    -- 外观
    ----------------------------------------------------------------
    owner.AnimState:OverrideSymbol(
        "swap_hat",
        "miaoji_prismatic_crown",
        "swap_hat"
    )
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")

    ----------------------------------------------------------------
    -- 理智恢复
    ----------------------------------------------------------------
    inst.components.equippable.dapperness = DAPPERNESS

    ----------------------------------------------------------------
    -- 应用位面防御（仅在护甲有耐久时）
    ----------------------------------------------------------------
    if inst.components.armor ~= nil and inst.components.armor.condition > 0 then
        ApplyPlanarDefense(inst, owner)
    end

    ----------------------------------------------------------------
    -- 战斗事件
    ----------------------------------------------------------------
    
    if owner:HasTag("miaoji") then
        owner:ListenForEvent("onhitother", OnHitOther, owner)
        owner:ListenForEvent("attacked", OnAttacked, owner)
    end
end

local function OnUnequip(inst, owner)
    ----------------------------------------------------------------
    -- 外观还原
    ----------------------------------------------------------------
    owner.AnimState:Hide("HAT")
    owner.AnimState:Show("HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:ClearOverrideSymbol("swap_hat")

    ----------------------------------------------------------------
    -- 移除位面防御
    ----------------------------------------------------------------
    RemovePlanarDefense(inst, owner)

    ----------------------------------------------------------------
    -- 移除事件监听
    ----------------------------------------------------------------
    if owner:HasTag("miaoji") then
        owner:RemoveEventCallback("onhitother", OnHitOther, owner)
        owner:RemoveEventCallback("attacked", OnAttacked, owner)
    end
end

----------------------------------------------------------------
-- 实体构造
----------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_prismatic_crown")
    inst.AnimState:SetBuild("miaoji_prismatic_crown")
    inst.AnimState:PlayAnimation("idle")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    ----------------------------------------------------------------
    -- 基础组件
    ----------------------------------------------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_prismatic_crown.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)

    ----------------------------------------------------------------
    -- 护甲
    ----------------------------------------------------------------
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(
        ARMOR_MAX,     -- 最大耐久 2000
        ARMOR_ABSORB   -- 80% 吸收
    )

    -- 重写 SetCondition 方法，实现耐久0时只失去减伤和位面防御
    local _old_SetCondition = inst.components.armor.SetCondition
    inst.components.armor.SetCondition = function(self, amount)
        local owner = self.inst.components.inventoryitem ~= nil
            and self.inst.components.inventoryitem.owner
            or nil

        if amount <= 0 then
            -- 耐久归零：仅失去减伤
            self.condition = 0
            self:SetAbsorption(0)

            if owner ~= nil then
                RemovePlanarDefense(self.inst, owner)
            end

            self.inst:PushEvent("percentusedchange", {
                percent = self:GetPercent()
            })
        else
            local was_zero = self.condition <= 0
            _old_SetCondition(self, amount)

            -- 从 0 → 有耐久：恢复减伤和位面防御
            if was_zero and owner ~= nil then
                self:SetAbsorption(ARMOR_ABSORB)
                ApplyPlanarDefense(self.inst, owner)
            end
        end
    end

    ----------------------------------------------------------------
    -- 修复系统（Trader）
    ----------------------------------------------------------------
    inst:AddComponent("trader")
    inst.components.trader:SetAbleToAcceptTest(function(inst, item)
        return item ~= nil and (
            item.prefab == "redgem" or
            item.prefab == "bluegem" or
            item.prefab == "purplegem"
        )
    end)

    inst.components.trader.onaccept = function(inst, giver, item)
        local armor = inst.components.armor
        if armor == nil then
            return
        end

        local percent = (item.prefab == "purplegem") and 1 or 0.5
        local repair = armor.maxcondition * percent

        armor:SetCondition(math.min(armor.condition + repair, armor.maxcondition))

        if giver ~= nil and giver.SoundEmitter ~= nil then
            giver.SoundEmitter:PlaySound("dontstarve/common/repair_clothing")
        end

        item:Remove()
    end

    return inst
end

return Prefab("miaoji_prismatic_crown", fn, assets, prefabs)