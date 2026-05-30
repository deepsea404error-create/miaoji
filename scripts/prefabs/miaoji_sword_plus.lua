------------------------------------------------------------
-- 喵刀 Plus
-- 文件名 / Prefab：miaoji_sword_plus
--
-- 1. 可砍树 / 挖矿（效率 1.5）
-- 2. 攻击造成 64 点伤害（位面 28 + 物理 36）
-- 3. 非 miaoji 装备：-10 / min 理智
-- 4. 10% 暴击（双倍物理伤害）
------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_sword_plus.zip"),
    Asset("ANIM", "anim/swap_miaoji_sword_plus.zip"),
    Asset("IMAGE", "images/inventoryimages/miaoji_sword_plus.tex"),
    Asset("ATLAS", "images/inventoryimages/miaoji_sword_plus.xml"),
}

------------------------------------------------------------
-- 装备
------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol(
        "swap_object",
        "swap_miaoji_sword_plus",
        "swap_miaoji_sword_plus"
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
-- 暴击判定（10%）
------------------------------------------------------------
local function IsCrit()
    return math.random() < 0.10
end

------------------------------------------------------------
-- 攻击回调（暴击 = 双倍物理伤害）
------------------------------------------------------------
local function OnAttack(inst, owner, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
        if IsCrit() then
            ------------------------------------------------
            -- 再追加一次物理伤害和位面伤害
            ------------------------------------------------
            target.components.combat:GetAttacked(
                owner,
                inst.components.weapon.damage,
                inst
            )
            if inst.components.planardamage ~= nil then
                local planar_damage =
                    inst.components.planardamage:GetDamage(target)

                target.components.health:DoDelta(
                    -planar_damage,
                    nil,
                    inst.prefab,
                    true,   -- 忽略防御
                    owner,
                    true    -- 位面伤害标记
                )
            end
            ------------------------------------------------
            -- 命中特效
            ------------------------------------------------
            local fx = SpawnPrefab("impact")
            if fx ~= nil then
                fx.Transform:SetPosition(
                    target.Transform:GetWorldPosition()
                )
            end

            ------------------------------------------------
            -- 暴击音效
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

    inst.AnimState:SetBank("miaoji_sword_plus")
    inst.AnimState:SetBuild("miaoji_sword_plus")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("pointy")
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --------------------------------------------------------
    -- 武器（物理伤害 36）
    --------------------------------------------------------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(36)
    inst.components.weapon:SetOnAttack(OnAttack)

    --------------------------------------------------------
    -- 位面伤害（28）
    --------------------------------------------------------
    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(28)

    --------------------------------------------------------
    -- 工具（效率 2）
    --------------------------------------------------------
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 3)
    inst.components.tool:SetAction(ACTIONS.MINE, 3)

    --------------------------------------------------------
    -- 物品 / 装备
    --------------------------------------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_sword_plus.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_sword_plus", fn, assets)
