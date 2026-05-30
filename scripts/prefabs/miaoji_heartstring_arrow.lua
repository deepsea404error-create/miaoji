local assets = {
    Asset("ANIM", "anim/miaoji_heartstring_arrow.zip"),
}

local prefabs = {
    "impact",
}

------------------------------------------------------------------
-- OnHit：只做特效 + AOE，绝不手动扣血
------------------------------------------------------------------
local function OnHit(inst, attacker, target)
    -- 命中特效
    if target ~= nil and target:IsValid() and target.components.combat ~= nil then
        local impactfx = SpawnPrefab("impact")
        if impactfx ~= nil then
            local follower = impactfx.entity:AddFollower()
            follower:FollowSymbol(
                target.GUID,
                target.components.combat.hiteffectsymbol,
                0, 0, 0
            )
        end
    end

    ------------------------------------------------------------------
    -- AOE
    ------------------------------------------------------------------
    local weapon = attacker
        and attacker.components.combat
        and attacker.components.combat:GetWeapon()

    if weapon ~= nil and weapon:HasTag("aoe_bow") and math.random() < 0.5 then
        local x, y, z = inst.Transform:GetWorldPosition()

        local ents = TheSim:FindEntities(
            x, y, z,
            3,
            nil,
            {"INLIMBO", "player", "chester", "companion"}
        )

        for _, v in ipairs(ents) do
            if v ~= target
            and v:IsValid()
            and v.components.combat ~= nil
            and not (v.components.health ~= nil and v.components.health:IsDead()) then
                -- 物理伤害
                local phys_dmg = (weapon.components.weapon ~= nil) and weapon.components.weapon.damage * 0.8 or 0
                v.components.combat:GetAttacked(attacker, phys_dmg, weapon)

                -- 范围特效
                local fx = SpawnPrefab("impact")
                if fx ~= nil then
                    fx.Transform:SetPosition(v.Transform:GetWorldPosition())
                    fx.Transform:SetRotation(math.random() * 360)
                end
            end
        end
    end

    inst:Remove()
end

------------------------------------------------------------------
-- Prefab
------------------------------------------------------------------
local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_heartstring_arrow")
    inst.AnimState:SetBuild("miaoji_heartstring_arrow")
    inst.AnimState:PlayAnimation("normal")

    inst:AddTag("sharp")
    inst:AddTag("weapon")
    inst:AddTag("projectile")
    inst:AddTag("NOCLICK")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst.persists = false

    ------------------------------------------------------------------
    -- 组件
    ------------------------------------------------------------------
    inst:AddComponent("weapon")
    inst:AddComponent("planardamage") -- projectile 自带 planar

    inst:AddComponent("projectile")
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile.range = 12
    inst.components.projectile.has_damage_set = true
    inst.components.projectile:SetLaunchOffset(Vector3(1, 1, 0))
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetHitDist(1.5)

    ------------------------------------------------------------------
    -- OnPreHit：继承弓的伤害
    ------------------------------------------------------------------
    inst.components.projectile:SetOnPreHitFn(function(inst, attacker, target)
        if attacker ~= nil and attacker.components.combat ~= nil then
            local weapon = attacker.components.combat:GetWeapon()

            if weapon ~= nil and weapon.components.weapon ~= nil then
                -- 普通伤害
                inst.components.weapon:SetDamage(
                    weapon.components.weapon.damage
                )

                -- 平面伤害
                if weapon.components.planardamage ~= nil then
                    inst.components.planardamage:SetBaseDamage(
                        weapon.components.planardamage:GetBaseDamage()
                    )
                end
            end
        end
    end)

    inst.components.projectile:SetOnHitFn(OnHit)

    return inst
end

return Prefab("miaoji_heartstring_arrow_normal", fn, assets, prefabs)