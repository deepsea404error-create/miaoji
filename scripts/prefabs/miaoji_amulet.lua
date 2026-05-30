local assets =
{
    Asset("ANIM", "anim/miaoji_amulet.zip"),
    Asset("ATLAS", "images/inventoryimages/miaoji_amulet.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_amulet.tex"),
}

------------------------------------------------------------
-- 常量
------------------------------------------------------------
local SHIELD_CD = 10          -- 冷却 10 秒
local SAN_COST = 8           -- 每次触发消耗 8 San

local RESISTANCES =
{
    "_combat",
    "explosive",
    "quakedebris",
    "caveindebris",
    "trapdamage",
}

------------------------------------------------------------
-- 护盾：是否允许抵挡
------------------------------------------------------------
local function ShouldResistFn(inst)
    local owner = inst._owner
    return owner ~= nil
        and inst.components.equippable:IsEquipped()
        and owner.components.sanity ~= nil
        and owner.components.sanity.current >= SAN_COST
        and not (owner.components.inventory ~= nil
            and owner.components.inventory:EquipHasTag("forcefield"))
end

------------------------------------------------------------
-- 护盾：成功抵挡一次攻击
------------------------------------------------------------
local function OnResistDamage(inst)
    local owner = inst._owner
    if owner == nil then
        return
    end

    -- 消耗理智
    if owner.components.sanity ~= nil then
        owner.components.sanity:DoDelta(-SAN_COST)
    end

    -- 骨甲同款特效
    local fx = SpawnPrefab("shadow_shield3")
    fx.entity:SetParent(owner.entity)

    -- 进入冷却
    inst.components.cooldown:StartCharging()

    -- 冷却期间禁用抵挡
    inst.components.resistance:SetOnResistDamageFn(nil)
    for _, v in ipairs(RESISTANCES) do
        inst.components.resistance:RemoveResistance(v)
    end
end

------------------------------------------------------------
-- 冷却结束，恢复抵挡
------------------------------------------------------------
local function OnChargedFn(inst)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)
    for _, v in ipairs(RESISTANCES) do
        inst.components.resistance:AddResistance(v)
    end
end

------------------------------------------------------------
-- 装备逻辑
------------------------------------------------------------
local function onequip(inst, owner)
    inst._owner = owner

    -- 移速 +10%
    if owner.components.locomotor then
        owner.components.locomotor:SetExternalSpeedMultiplier(
            inst,
            "miaoji_amulet_speed",
            1.1
        )
    end

    -- 饥饿消耗 ×0.8
    if owner.components.hunger then
        owner.components.hunger.burnratemodifiers:SetModifier(inst, 0.8)
    end

    -- 非 miaoji 理智 -3 / min
    if owner.prefab ~= "miaoji" then
        inst.components.equippable.dapperness = -3 / 60
    else
        inst.components.equippable.dapperness = 0
    end

    -- 免疫硬直 tag（需要你自己在别处配合使用）
    owner:AddTag("miaoji_amulet_noknock")

    -- 低血量回血
    if inst._regen_task == nil then
        inst._regen_task = owner:DoPeriodicTask(1, function()
            if owner.components.health
                and not owner.components.health:IsDead()
                and owner.components.health:GetPercent() < 0.6 then
                owner.components.health:DoDelta(0.5, true, "miaoji_amulet")
            end
        end)
    end

    --------------------------------------------------------
    -- 启用护盾系统
    --------------------------------------------------------
    inst.components.resistance:SetShouldResistFn(ShouldResistFn)
    inst.components.resistance:SetOnResistDamageFn(OnResistDamage)

    inst.components.cooldown.onchargedfn = OnChargedFn
    inst.components.cooldown:StartCharging(0)
end

------------------------------------------------------------
-- 卸下逻辑
------------------------------------------------------------
local function onunequip(inst, owner)
    if owner.components.locomotor then
        owner.components.locomotor:RemoveExternalSpeedMultiplier(
            inst,
            "miaoji_amulet_speed"
        )
    end

    if owner.components.hunger then
        owner.components.hunger.burnratemodifiers:RemoveModifier(inst)
    end

    owner:RemoveTag("miaoji_amulet_noknock")

    if inst._regen_task then
        inst._regen_task:Cancel()
        inst._regen_task = nil
    end

    -- 彻底关闭护盾
    if inst.components.cooldown then
        inst.components.cooldown.onchargedfn = nil
    end

    if inst.components.resistance then
        inst.components.resistance:SetOnResistDamageFn(nil)
        for _, v in ipairs(RESISTANCES) do
            inst.components.resistance:RemoveResistance(v)
        end
    end

    inst._owner = nil
end

------------------------------------------------------------
-- Prefab
------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddNetwork()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_amulet")
    inst.AnimState:SetBuild("miaoji_amulet")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("amulet")
    inst:AddTag("miaoji_amulet")
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_amulet.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.NECK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("inspectable")

    -- 护盾核心组件
    inst:AddComponent("resistance")
    inst:AddComponent("cooldown")
    inst.components.cooldown.cooldown_duration = SHIELD_CD

    -- 重载存档自动恢复效果
    inst.OnLoad = function(inst)
        if inst.components.equippable and inst.components.equippable:IsEquipped() then
            local owner = inst.components.inventoryitem.owner
            if owner ~= nil then
                onequip(inst, owner)
            end
        end
    end

    MakeHauntableLaunch(inst)
    return inst
end

return Prefab("miaoji_amulet", fn, assets)
