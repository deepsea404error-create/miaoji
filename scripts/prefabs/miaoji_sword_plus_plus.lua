------------------------------------------------------------
-- 喵刀 Plus Plus
-- miaoji_sword_plus_plus
------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_sword_plus_plus.zip"),
    Asset("ANIM", "anim/swap_miaoji_sword_plus_plus.zip"),
    Asset("IMAGE", "images/inventoryimages/miaoji_sword_plus_plus.tex"),
    Asset("ATLAS", "images/inventoryimages/miaoji_sword_plus_plus.xml"),
}

------------------------------------------------------------
-- 装备
------------------------------------------------------------
local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol(
        "swap_object",
        "swap_miaoji_sword_plus_plus",
        "swap_miaoji_sword_plus_plus"
    )
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    -- 非 miaoji：掉理智
    if owner ~= nil and not owner:HasTag("miaoji") then
        inst._sanitytask = owner:DoPeriodicTask(1, function()
            if owner.components.sanity ~= nil then
                owner.components.sanity:DoDelta(-10 / 60)
            end
        end)
    end

    -- 增加移动速度 25%
    if owner.components.locomotor ~= nil then
        inst._speedmult = 1.25
        owner.components.locomotor:SetExternalSpeedMultiplier(inst, "miaoji_sword_plus_plus_speed", inst._speedmult)
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
    -- 移除移动速度加成
    if owner.components.locomotor ~= nil then
        owner.components.locomotor:RemoveExternalSpeedMultiplier(inst, "miaoji_sword_plus_plus_speed")
    end
end

------------------------------------------------------------
-- 暴击判定（15%）
------------------------------------------------------------
local function IsCrit()
    return math.random() < 0.15
end

------------------------------------------------------------
-- 攻击（暴击 + 冰冻）
------------------------------------------------------------
local function OnAttack(inst, owner, target)
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
        if IsCrit() then
            -- 再造成一次物理伤害（双倍）
            target.components.combat:GetAttacked(
                owner,
                inst.components.weapon.damage,
                inst
            )
            -- 再造成一次位面伤害（双倍）
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
            -- 冰冻目标
            if target.components.freezable ~= nil then
                target.components.freezable:AddColdness(2)
                target.components.freezable:SpawnShatterFX()
            end

            -- 命中特效
            local fx = SpawnPrefab("impact")
            if fx ~= nil then
                fx.Transform:SetPosition(target.Transform:GetWorldPosition())
            end

            if owner.SoundEmitter ~= nil then
                owner.SoundEmitter:PlaySound("dontstarve/common/staff_cold")
            end
        end
    end
end

------------------------------------------------------------
-- 右键释放【矮星】
------------------------------------------------------------
local function CreateLight(inst, doer, pos)
    -- 服务端生成
    if not TheWorld.ismastersim then
        return true
    end

    -- 生成矮星
    local light = SpawnPrefab("stafflight")
    if light ~= nil then
        light.Transform:SetPosition(pos:Get())
    end

    -- 消耗精神
    local caster = inst.components.inventoryitem.owner
    if caster ~= nil and caster.components.sanity ~= nil then
        caster.components.sanity:DoDelta(-30)
    end

    return true
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

    inst.AnimState:SetBank("miaoji_sword_plus_plus")
    inst.AnimState:SetBuild("miaoji_sword_plus_plus")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --------------------------------------------------------
    -- 武器
    --------------------------------------------------------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(47)
    inst.components.weapon:SetOnAttack(OnAttack)

    --------------------------------------------------------
    -- 位面伤害
    --------------------------------------------------------
    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(40)

    --------------------------------------------------------
    -- 工具（效率 5）
    --------------------------------------------------------
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.CHOP, 5)
    inst.components.tool:SetAction(ACTIONS.MINE, 5)

    --------------------------------------------------------
    -- 右键施法
    --------------------------------------------------------
    inst:AddComponent("spellcaster")
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster:SetSpellFn(CreateLight)

    --------------------------------------------------------
    -- 装备
    --------------------------------------------------------
    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_sword_plus_plus.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_sword_plus_plus", fn, assets)
