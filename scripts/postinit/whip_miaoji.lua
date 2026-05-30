-- ------------------------------------------------------------
-- -- miaoji × 三尾猫鞭 扩展
-- -- 1. miaoji 使用猫鞭 +25 位面伤害
-- -- 2. miaoji 使用猫鞭不消耗耐久
-- ------------------------------------------------------------

-- local PLANAR_BONUS = 25

-- AddPrefabPostInit("whip", function(inst)
--     if not TheWorld.ismastersim then
--         return
--     end

--     --------------------------------------------------
--     -- 位面伤害
--     --------------------------------------------------
--     if inst.components.planardamage == nil then
--         inst:AddComponent("planardamage")
--     end

--     local base_planar = inst.components.planardamage:GetBaseDamage() or 0

--     --------------------------------------------------
--     -- 装备判断
--     --------------------------------------------------
--     local old_onequip = inst.components.equippable.onequipfn
--     inst.components.equippable:SetOnEquip(function(inst, owner)
--         if old_onequip then
--             old_onequip(inst, owner)
--         end

--         inst._miaoji_owner = owner ~= nil and owner:HasTag("miaoji")

--         if inst._miaoji_owner then
--             inst.components.planardamage:SetBaseDamage(base_planar + PLANAR_BONUS)
--         else
--             inst.components.planardamage:SetBaseDamage(base_planar)
--         end
--     end)

--     local old_onunequip = inst.components.equippable.onunequipfn
--     inst.components.equippable:SetOnUnequip(function(inst, owner)
--         if old_onunequip then
--             old_onunequip(inst, owner)
--         end

--         inst._miaoji_owner = false
--         inst.components.planardamage:SetBaseDamage(base_planar)
--     end)

--     --------------------------------------------------
--     -- ★ 核心：拦截耐久消耗 ★
--     --------------------------------------------------
--     if inst.components.finiteuses ~= nil then
--         local old_use = inst.components.finiteuses.Use

--         inst.components.finiteuses.Use = function(self, amount)
--             -- 如果是 miaoji 在用 → 不消耗
--             if inst._miaoji_owner then
--                 return
--             end

--             -- 否则正常消耗
--             return old_use(self, amount)
--         end
--     end
-- end)

------------------------------------------------------------
-- miaoji × 三尾猫鞭 扩展
-- 1. miaoji 使用猫鞭 +25 位面伤害
-- 2. 猫尾（coontail）可修复猫鞭
------------------------------------------------------------

local PLANAR_BONUS = 25
local REPAIR_AMOUNT = 50  -- 修复50点耐久

AddPrefabPostInit("whip", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    --------------------------------------------------
    -- 位面伤害组件
    --------------------------------------------------
    if inst.components.planardamage == nil then
        inst:AddComponent("planardamage")
    end

    local base_planar = inst.components.planardamage:GetBaseDamage() or 0

    --------------------------------------------------
    -- 装备 / 卸下处理
    --------------------------------------------------
    local old_onequip = inst.components.equippable.onequipfn
    inst.components.equippable:SetOnEquip(function(inst, owner)
        if old_onequip ~= nil then
            old_onequip(inst, owner)
        end

        if owner ~= nil and owner:HasTag("miaoji") then
            inst.components.planardamage:SetBaseDamage(base_planar + PLANAR_BONUS)
        else
            inst.components.planardamage:SetBaseDamage(base_planar)
        end
    end)

    local old_onunequip = inst.components.equippable.onunequipfn
    inst.components.equippable:SetOnUnequip(function(inst, owner)
        if old_onunequip ~= nil then
            old_onunequip(inst, owner)
        end

        inst.components.planardamage:SetBaseDamage(base_planar)
    end)

    --------------------------------------------------
    -- 猫尾修复猫鞭（参考你提供的修复机制）
    --------------------------------------------------
    
    -- 1. 为猫鞭添加 trader 组件
    if inst.components.trader == nil then
        inst:AddComponent("trader")
    end
    
    -- 2. 设置可接受的物品测试
    inst.components.trader:SetAbleToAcceptTest(function(inst, item)
        -- 只接受猫尾
        return item ~= nil and item.prefab == "coontail"
    end)
    
    -- 3. 设置接受物品时的处理函数
    inst.components.trader.onaccept = function(inst, giver, item)
        if item ~= nil and item.prefab == "coontail" then
            -- 检查是否有 finiteuses 组件
            if inst.components.finiteuses ~= nil then
                -- 播放音效
                if giver ~= nil and giver.SoundEmitter ~= nil then
                    giver.SoundEmitter:PlaySound("dontstarve/common/repair_whip")
                end
                
                -- 修复耐久
                local current = inst.components.finiteuses.current
                local total = inst.components.finiteuses.total
                local new_value = math.min(current + REPAIR_AMOUNT, total)
                inst.components.finiteuses:SetUses(new_value)
                
                -- 移除猫尾
                item:Remove()
            end
        end
    end
end)

------------------------------------------------------------
-- 为猫尾添加 tradable 组件
------------------------------------------------------------
AddPrefabPostInit("coontail", function(inst)
    if not TheWorld.ismastersim then
        return
    end
    
    if inst.components.tradable == nil then
        inst:AddComponent("tradable")
    end
end)