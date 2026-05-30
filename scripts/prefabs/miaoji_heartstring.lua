local assets = {
    Asset("ANIM", "anim/miaoji_heartstring.zip"),
    Asset("ANIM", "anim/swap_miaoji_heartstring.zip"),
    Asset("ATLAS", "images/inventoryimages/miaoji_heartstring.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_heartstring.tex"),
}

local prefabs = {
    "miaoji_heartstring_arrow_normal",
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol(
        "swap_object",
        "swap_miaoji_heartstring",
        "swap_miaoji_heartstring"
    )
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")

    if owner ~= nil and not owner:HasTag("miaoji") then
        if owner.components.inventory ~= nil then
            owner:DoTaskInTime(0, function()
                owner.components.inventory:DropItem(inst)
            end)
        end
    end
end

local function onunequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_heartstring")
    inst.AnimState:SetBuild("miaoji_heartstring")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("weapon")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_heartstring.xml"

    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    -- 伤害
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(23)
    inst.components.weapon:SetRange(8)
    inst.components.weapon:SetProjectile(
        "miaoji_heartstring_arrow_normal"
    )

    inst:AddComponent("planardamage")
    inst.components.planardamage:SetBaseDamage(17)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_heartstring", fn, assets, prefabs)