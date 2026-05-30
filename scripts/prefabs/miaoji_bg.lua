------------------------------------------------------------
-- 猫猫口袋 背包 prefab（DST 版本）
-- 作者：DeepSea404
-- 功能：
-- 1. 背包大小 6 格
-- 2. 装备后增加 10% 移速
-- 3. 丢下 / 卸下自动关闭背包栏
------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_bg.zip"),
    Asset("ATLAS", "images/inventoryimages/miaoji_bg.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_bg.tex"),
}

------------------------------------------------------------
-- 工具函数：安全关闭容器
------------------------------------------------------------
local function CloseContainer(inst, owner)
    if inst.components.container ~= nil then
        if owner ~= nil then
            inst.components.container:Close(owner)
        else
            inst.components.container:Close()
        end
    end
end

------------------------------------------------------------
-- 装备 / 卸下
------------------------------------------------------------
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


------------------------------------------------------------
-- prefab 主体
------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_bg")
    inst.AnimState:SetBuild("miaoji_bg")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("backpack")
    inst:AddTag("miaoji_bg")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end
    --------------------------------------------------------
    -- 容器
    --------------------------------------------------------
    inst:AddComponent("container")
    -- inst.components.container:WidgetSetup("backpack")
    inst.components.container:WidgetSetup("miaoji_bg")

    --------------------------------------------------------
    -- 装备组件
    --------------------------------------------------------
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BACK or EQUIPSLOTS.BODY
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)
    -- 移速
    inst.components.equippable.walkspeedmult = 1.1

    --------------------------------------------------------
    -- 物品栏显示
    --------------------------------------------------------
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_bg.xml"
    inst.components.inventoryitem.imagename = "miaoji_bg"

    inst:AddComponent("inspectable")


    MakeHauntableLaunch(inst)

    return inst
end

------------------------------------------------------------
-- 返回 prefab
------------------------------------------------------------
return Prefab("miaoji_bg", fn, assets)