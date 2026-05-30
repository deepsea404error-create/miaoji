------------------------------------------------------------
-- 猫爪（武器）
-- 仅 miaoji 可使用
-- 空手攻击动画
-- 无限耐久
-- 伤害 40
------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_claw.zip"), -- 物品动画（地面/背包）
    Asset("ATLAS", "images/inventoryimages/miaoji_claw.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_claw.tex"),
}

------------------------------------------------------------
-- 仅 miaoji 可装备检测
------------------------------------------------------------
local function IsMiaoji(inst, owner)
    if owner ~= nil and owner:HasTag("miaoji") then
        return true
    end

    -- 非 miaoji：强制掉落
    if owner ~= nil then
        owner:DoTaskInTime(0, function()
            if owner.components.inventory ~= nil then
                owner.components.inventory:DropItem(inst)
            end
            if owner.components.talker ~= nil then
                owner.components.talker:Say("这不是我的武器")
            end
        end)
    end

    return false
end

------------------------------------------------------------
-- 装备
------------------------------------------------------------
local function onequip(inst, owner)
    if not IsMiaoji(inst, owner) then
        return
    end

    -- 关键点：
    -- 不 override swap_object
    -- → 攻击动画为【空手】
end

------------------------------------------------------------
-- 卸下
------------------------------------------------------------
local function onunequip(inst, owner)
    -- 空手武器，无需清理动画
end

------------------------------------------------------------
-- 实体构建
------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_claw")
    inst.AnimState:SetBuild("miaoji_claw")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")
    inst:AddTag("miaoji_claw")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    --------------------------------------------------------
    -- 可检查
    --------------------------------------------------------
    inst:AddComponent("inspectable")

    --------------------------------------------------------
    -- 背包物品
    --------------------------------------------------------
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_claw.xml"
    inst.components.inventoryitem.imagename = "miaoji_claw"

    -- --------------------------------------------------------
    -- -- 不可堆叠（若添加对于武器/背包类物品回报错）
    -- --------------------------------------------------------
    -- inst:AddComponent("stackable")
    -- inst.components.stackable.maxsize = 1

    --------------------------------------------------------
    -- 装备
    --------------------------------------------------------
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HANDS
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    --------------------------------------------------------
    -- 武器
    --------------------------------------------------------
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(21)

    --------------------------------------------------------
    -- 位面伤害（DST 新机制）
    --------------------------------------------------------
    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(21)

    --------------------------------------------------------
    -- 无限耐久：不添加 finiteuses
    --------------------------------------------------------

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_claw", fn, assets)

