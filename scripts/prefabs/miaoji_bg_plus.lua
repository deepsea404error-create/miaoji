------------------------------------------------------------
-- 猫猫口袋 Plus（2级）
-- DeepSea404
-- 功能：
-- 12格背包
-- 移速 +15%
-- 理智恢复 3 / 秒
-- 防雨 60%
-- 保鲜
------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_bg_plus.zip"),
    Asset("ATLAS", "images/inventoryimages/miaoji_bg_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_bg_plus.tex"),
}

-- 装备上
local function onequip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Open(owner)  -- 打开背包容器界面
    end
end

-- 脱下装备
local function onunequip(inst, owner)
    if inst.components.container ~= nil then
        inst.components.container:Close(owner)  -- 打开背包容器界面
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_bg_plus")
    inst.AnimState:SetBuild("miaoji_bg_plus")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")
    inst:AddTag("miaoji_bg_plus")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -- 容器
    inst:AddComponent("container")
    inst.components.container:WidgetSetup("miaoji_bg_plus")

    -- 装备
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- 移速
    inst.components.equippable.walkspeedmult = 1.15
    -- 每秒恢复3理智
    inst.components.equippable.dapperness = 3/60

    -- 防雨
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(0.6)

    -- 保鲜
    inst:AddComponent("preserver")
    inst.components.preserver:SetPerishRateMultiplier(1/2) -- 0为不腐烂(目前为2倍保鲜)

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_bg_plus.xml"
    inst.components.inventoryitem.imagename = "miaoji_bg_plus"

    inst:AddComponent("inspectable")
    
    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_bg_plus", fn, assets)
