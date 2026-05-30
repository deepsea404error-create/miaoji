--------------------------------------------------------------------------
-- 彩棱王冠 PLUS
-- prefab: miaoji_prismatic_crown_plus
-- 作者：DeepSea404
-- 功能：
-- 1. 90% 护甲（3000 耐久）+ 20 位面防御
-- 2. +25%伤害
-- 3. +10 / 分钟理智
-- 4.免疫火焰扣血和冰冻效果
-- 5.消除所有敌人带来的降san光环的影响。
-- 6. 攻击时 20% 概率回复 5 生命（仅miaoji）
-- 7. 水上+洞穴虚空行走,水上每4s增加1点潮湿（仅miaoji）
-- 8. 反伤 40（仅miaoji）
-- 9. 可用宝石修复耐久
--    红 / 蓝宝石：25%
--    紫宝石：50%
--------------------------------------------------------------------------

local assets =
{
    Asset("ANIM", "anim/miaoji_prismatic_crown_plus.zip"),
    Asset("ATLAS", "images/inventoryimages/miaoji_prismatic_crown_plus.xml"),
    Asset("IMAGE", "images/inventoryimages/miaoji_prismatic_crown_plus.tex"),
}

--------------------------------------------------------------------------
-- 常量
--------------------------------------------------------------------------

local MAX_DURABILITY      = 3000

local ARMOR_ABSORB        = 0.9
local PLANAR_DEF          = 20

local DAMAGE_MULT         = 1.25
local DAPPERNESS          = 10 / 60

local HEAL_CHANCE         = 0.20
local HEAL_AMOUNT         = 5

local THORNS_DAMAGE       = 40

local MOISTURE_RATE        = 1  -- 每秒增加的潮湿值
local UPDATE_RATE          = 4  -- 更新频率（秒）

--------------------------------------------------------------------------
-- 潮湿管理
--------------------------------------------------------------------------

local function CheckIsOnWater(owner)
    if owner == nil then
        return false
    end
    
    local x, y, z = owner.Transform:GetWorldPosition()
    local tile = TheWorld.Map:GetTileAtPoint(x, y, z)
    
    -- 检查是否在海洋/水域瓷砖上
    return tile == GROUND.OCEAN_COASTAL or
           tile == GROUND.OCEAN_COASTAL_SHORE or
           tile == GROUND.OCEAN_WATERLOG or
           tile == GROUND.OCEAN_SWELL or
           tile == GROUND.OCEAN_ROUGH or
           tile == GROUND.OCEAN_HAZARDOUS or
           tile == GROUND.OCEAN_BRINEPOOL or
           tile == GROUND.OCEAN_BRINEPOOL_SHORE or
           tile == GROUND.OCEAN_WATERLOG or
           tile == GROUND.MANGROVE
end

local function UpdateMoisture(inst)
    if inst._owner == nil or not inst._owner:IsValid() then
        if inst._moisture_task ~= nil then
            inst._moisture_task:Cancel()
            inst._moisture_task = nil
        end
        return
    end
    
    if not inst._owner:HasTag("miaoji") then
        if inst._moisture_task ~= nil then
            inst._moisture_task:Cancel()
            inst._moisture_task = nil
        end
        return
    end
    
    -- 检查是否在水上
    if CheckIsOnWater(inst._owner) then
        if inst._owner.components.moisture ~= nil then
            -- 增加潮湿值
            inst._owner.components.moisture:DoDelta(MOISTURE_RATE)
        end
    end
end

--------------------------------------------------------------------------
-- 水上行走辅助函数
--------------------------------------------------------------------------

local function EnableWaterWalking(owner, inst)
    if owner.components.drownable then
        owner.components.drownable.enabled = false
    end
    if owner.components.locomotor then
        owner.components.locomotor:SetAllowPlatformHopping(false)
    end
    RemovePhysicsColliders(owner)
    
    -- 保存所有者引用
    inst._owner = owner
    
    -- 开始更新潮湿任务
    if inst._moisture_task == nil then
        inst._moisture_task = inst:DoPeriodicTask(UPDATE_RATE, function() 
            UpdateMoisture(inst) 
        end)
    end
end

local function DisableWaterWalking(owner, inst)
    if owner.components.drownable then
        owner.components.drownable.enabled = true
    end
    if owner.components.locomotor then
        owner.components.locomotor:SetAllowPlatformHopping(true)
    end
    ChangeToCharacterPhysics(owner)
    
    -- 清除潮湿任务
    if inst._moisture_task ~= nil then
        inst._moisture_task:Cancel()
        inst._moisture_task = nil
    end
    inst._owner = nil
end

--------------------------------------------------------------------------
-- 攻击回血
--------------------------------------------------------------------------

local function OnHitOther(owner, data)
    if data == nil or data.target == nil then
        return
    end

    if data.target.components.health == nil then
        return
    end

    if math.random() < HEAL_CHANCE then
        if owner.components.health ~= nil then
            owner.components.health:DoDelta(
                HEAL_AMOUNT,
                nil,
                "miaoji_prismatic_crown_plus"
            )
        end
    end
end

--------------------------------------------------------------------------
-- 反伤
--------------------------------------------------------------------------

local function OnAttacked(owner, data)
    if data == nil or data.attacker == nil then
        return
    end

    local attacker = data.attacker
    if attacker == owner then
        return
    end

    if attacker.components.health ~= nil then
        attacker.components.health:DoDelta(
            -THORNS_DAMAGE,
            nil,
            "miaoji_prismatic_crown_plus"
        )
    end
end

--------------------------------------------------------------------------
-- 装备 / 卸下
--------------------------------------------------------------------------

local function ApplyPlanarDefense(inst, owner)
    if owner.components.planardefense == nil then
        owner:AddComponent("planardefense")
    end
    owner.components.planardefense:AddBonus(inst, PLANAR_DEF, "miaoji_prismatic_crown_plus")
end

local function RemovePlanarDefense(inst, owner)
    if owner.components.planardefense ~= nil then
        owner.components.planardefense:RemoveBonus(inst, "miaoji_prismatic_crown_plus")
    end
end

local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_hat", "miaoji_prismatic_crown_plus", "swap_hat")
    owner.AnimState:Show("HAT")
    owner.AnimState:Hide("HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")

    -- 伤害倍率
    owner.components.combat.externaldamagemultipliers:SetModifier(
        inst,
        DAMAGE_MULT,
        "miaoji_prismatic_crown_plus"
    )

    -- 免疫负面 SAN 光环
    if owner.components.sanity ~= nil then
        owner.components.sanity:SetNegativeAuraImmunity(true)
    end

    -- 火焰免疫
    if owner.components.health ~= nil then
        owner.components.health.fire_damage_scale = 0
    end

    -- 冰冻免疫
    if owner.components.freezable ~= nil then
        owner.components.freezable:SetResistance(999)
    end

    -- 水上行走（仅限miaoji角色）
    -- if owner:HasTag("miaoji") then
    --     EnableWaterWalking(owner, inst)
    -- end
    if TUNING.MIAOJI_CROWN_WATER_WALK and owner:HasTag("miaoji") then
        EnableWaterWalking(owner, inst)
    end
    if owner:HasTag("miaoji") then
        owner:ListenForEvent("onhitother", OnHitOther, owner)
        owner:ListenForEvent("attacked", OnAttacked, owner)
    end
end

local function OnUnequip(inst, owner)
    owner.AnimState:Hide("HAT")
    owner.AnimState:Show("HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:ClearOverrideSymbol("swap_hat")

    RemovePlanarDefense(inst, owner)

    owner.components.combat.externaldamagemultipliers:RemoveModifier(
        inst,
        "miaoji_prismatic_crown_plus"
    )

    if owner.components.sanity ~= nil then
        owner.components.sanity:SetNegativeAuraImmunity(false)
    end

    if owner.components.health ~= nil then
        owner.components.health.fire_damage_scale = 1
    end

    if owner.components.freezable ~= nil then
        owner.components.freezable:SetResistance(0)
    end

    -- 恢复水上行走（如果之前启用过）
    if TUNING.MIAOJI_CROWN_WATER_WALK and owner:HasTag("miaoji") then
        DisableWaterWalking(owner, inst)
    end

    if owner:HasTag("miaoji") then
        owner:RemoveEventCallback("onhitother", OnHitOther, owner)
        owner:RemoveEventCallback("attacked", OnAttacked, owner)
    end
end

--------------------------------------------------------------------------
-- prefab 主体
--------------------------------------------------------------------------

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("miaoji_prismatic_crown_plus")
    inst.AnimState:SetBuild("miaoji_prismatic_crown_plus")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname =
        "images/inventoryimages/miaoji_prismatic_crown_plus.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
    inst.components.equippable.dapperness = DAPPERNESS

    ----------------------------------------------------------------------
    -- 护甲
    ----------------------------------------------------------------------

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(MAX_DURABILITY, ARMOR_ABSORB)

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

            -- 从 0 → 有耐久：恢复减伤
            if was_zero and owner ~= nil then
                self:SetAbsorption(ARMOR_ABSORB)
                ApplyPlanarDefense(self.inst, owner)
            end
        end
    end

    ----------------------------------------------------------------------
    -- trader 修复
    ----------------------------------------------------------------------

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

    -- 初始化变量
    inst._owner = nil
    inst._moisture_task = nil

    -- 清理函数
    inst.OnRemove = function(self)
        if self._moisture_task ~= nil then
            self._moisture_task:Cancel()
            self._moisture_task = nil
        end
        self._owner = nil
    end

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("miaoji_prismatic_crown_plus", fn, assets)