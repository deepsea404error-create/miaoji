------------------------------------------------------------
-- 1.可以砍树挖矿
-- 2.攻击造成48点伤害(位面伤害22+物理伤害26)
-- 3.对于非miaoji人物，装备时-10/min精神。
-- 4.有5%概率暴击(双倍物理伤害)
------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_sword.zip"),
    Asset("ANIM", "anim/swap_miaoji_sword.zip"),
    Asset("IMAGE", "images/inventoryimages/miaoji_sword.tex"),
    Asset("ATLAS", "images/inventoryimages/miaoji_sword.xml"),
}

------------------------------------------------------------
-- 装备
------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol(
        "swap_object",
        "swap_miaoji_sword",
        "swap_miaoji_sword"
    )
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    -- 非 miaoji：持续掉理智
    if owner ~= nil and not owner:HasTag("miaoji") then
        if inst._sanitytask == nil then
            inst._sanitytask = owner:DoPeriodicTask(1, function()
                if owner.components.sanity ~= nil then
                    owner.components.sanity:DoDelta(-10 / 60)
                end
            end)
        end
    end
end

------------------------------------------------------------
-- 卸下
------------------------------------------------------------
local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")

    if inst._sanitytask ~= nil then
        inst._sanitytask:Cancel()
        inst._sanitytask = nil
    end
end

------------------------------------------------------------
-- 攻击回调（暴击）
------------------------------------------------------------
local function IsCrit()
    return math.random() < 0.05 -- 5% 暴击
end

local function OnAttack(inst, owner, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then

        if IsCrit() then
            ------------------------------------------------
            -- 双倍伤害
            ------------------------------------------------
            target.components.combat:GetAttacked(
                owner,
                inst.components.weapon.damage,
                inst
            )

            ------------------------------------------------
            -- 官方通用强击打特效（稳定可见）
            ------------------------------------------------
            local fx = SpawnPrefab("impact")
            if fx ~= nil then
                fx.Transform:SetPosition(
                    target.Transform:GetWorldPosition()
                )
            end

            ------------------------------------------------
            -- 可选：暴击音效
            ------------------------------------------------
            if owner.SoundEmitter ~= nil then
                owner.SoundEmitter:PlaySound("dontstarve/common/whip")
            end
        end
    end
end

------------------------------------------------------------
-- 实体
------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_sword")
    inst.AnimState:SetBuild("miaoji_sword")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --------------------------------------------------------
    -- 武器
    --------------------------------------------------------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(26)
    inst.components.weapon:SetOnAttack(OnAttack)

    --------------------------------------------------------
    -- 位面伤害
    --------------------------------------------------------
    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(22)

    --------------------------------------------------------
    -- 工具（砍树 + 挖矿）
    --------------------------------------------------------
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 1)
    inst.components.tool:SetAction(ACTIONS.MINE, 1)

    --------------------------------------------------------
    -- 耐久(无耐久)
    --------------------------------------------------------
    -- inst:AddComponent("finiteuses")
    -- inst.components.finiteuses:SetMaxUses(TUNING.MIAOJI_SWORDD_USE)
    -- inst.components.finiteuses:SetUses(TUNING.MIAOJI_SWORDD_USE)
    -- inst.components.finiteuses:SetOnFinished(inst.Remove)

    --------------------------------------------------------
    -- 物品 / 装备
    --------------------------------------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_sword.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_sword", fn, assets)
