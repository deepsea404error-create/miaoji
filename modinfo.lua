------------------------------------------------------------
-- Mod 基本信息
------------------------------------------------------------

name = "Miaoji（喵吉）"
description = [[
基于 喵吉（单联机通用版）的全面重造
原作者：https://steamcommunity.com/sharedfiles/filedetails/?id=1296609863

一个在黑暗中逐渐觉醒的角色。
特点：
· 可升级，随着等级提升生命值、饥饿值、理智值和战斗/移动能力增强
· 黄昏、夜晚与洞穴会获得不同程度的战斗强化
· 夜晚可获得小范围光照（可在配置中开启/关闭）
· 夜晚与洞穴能够恢复理智，免疫黑暗理智流失
· 对腐烂食物完全免疫负面效果
· 鱼类及特定料理效果增强，并可获得经验
· 免疫猴子诅咒及部分负面光环效果
· 能够阅读和制作书籍
]]
author = "DeepSea404"
version = "0.0.6"

forumthread = ""

------------------------------------------------------------
-- API / 兼容性设置
------------------------------------------------------------

-- 当前 DST API 版本
api_version = 10

-- 仅兼容饥荒联机版
dst_compatible = true

dont_starve_compatible = false
reign_of_giants_compatible = false
shipwrecked_compatible = false

-- 人物 Mod 必须所有客户端安装
all_clients_require_mod = true

------------------------------------------------------------
-- Mod 图标
------------------------------------------------------------

icon_atlas = "modicon.xml"
icon = "modicon.tex"

------------------------------------------------------------
-- 服务器筛选标签（创意工坊搜索用）
------------------------------------------------------------

server_filter_tags =
{
    "character",     -- 人物 Mod
    "miaoji",        -- 角色名
    "night",         -- 夜晚强化
    "combat",        -- 战斗向
    "DeepSea404",    -- 作者
}

------------------------------------------------------------
-- 配置选项（核心）
------------------------------------------------------------

configuration_options =
{
    -----------------------------------------------------------------------
    {
        name = "",
        label = "【基础配置】",
        options = { {description = "", data = 0} },
        default = 0,
    },
    {
        name = "MAX_LEVEL",
        label = "最高等级上限",
        hover = "角色可达到的最高等级",
        options =
        {
            { description = "20 级", data = 20 },
            { description = "30 级", data = 30 },
            { description = "40 级", data = 40 },
            { description = "50 级（默认）", data = 50 },
            { description = "80 级", data = 80 },
            { description = "100 级", data = 100 },
        },
        default = 50,
    },

    {
        name = "LEVEL_DAMAGE_RATE",
        label = "每级伤害提升比例",
        hover = "每升 1 级提供的伤害倍率",
        options =
        {
            { description = "无加成", data = 0 },
            { description = "+0.5%", data = 0.005 },
            { description = "+1.0%", data = 0.01 },
            { description = "+1.5%（默认）", data = 0.015 },
            { description = "+2.0%", data = 0.02 },
            { description = "+2.5%", data = 0.025 },
        },
        default = 0.015,
    },

    {
        name = "LEVEL_SPEED_RATE",
        label = "每 5 级移速提升",
        hover = "每 5 级提供的移动速度倍率",
        options =
        {
            { description = "无加成", data = 0 },
            { description = "+3%", data = 0.03 },
            { description = "+5%（默认）", data = 0.05 },
            { description = "+8%", data = 0.08 },
        },
        default = 0.05,
    },
    {
        name = "DUSK_MODE",
        label = "黄昏强化程度",
        hover = "少量加成：1.1 伤害倍率，3/min 理智恢复    大量加成：1.2 伤害倍率，4/min 理智恢复",
        options =
        {
            { description = "无加成", data = 0 },
            { description = "少量加成", data = 1 },
            { description = "大量加成", data = 2 },
        },
        default = 1,
    },

    {
        name = "NIGHT_MODE",
        label = "夜晚 / 洞穴强化程度",
        hover = "少量加成：1.25 伤害倍率，4/min 理智恢复    大量加成：1.5 伤害倍率，6/min 理智恢复",
        options =
        {
            { description = "无加成", data = 0 },
            { description = "少量加成", data = 1 },
            { description = "大量加成", data = 2 },
        },
        default = 1,
    },

    {
        name = "NIGHT_VISION",
        label = "夜视能力（小范围光照）",
        hover = "开启后，夜晚与洞穴中角色会发出微弱光照",
        options =
        {
            { description = "关闭", data = false },
            { description = "开启", data = true },
        },
        default = true,
    },
    -----------------------------------------------------------------------
    {
        name = "",
        label = "【专属装备】",
        options = { {description = "", data = 0} },
        default = 0,
    },
    {
        name = "CROWN_WATER_WALK",
        label = "彩棱王冠+水上行走",
        hover = "开启后，彩棱王冠+ 可在水面行走（仅喵吉）",
        options =
        {
            { description = "关闭", data = false },
            { description = "开启（默认）", data = true },
        },
        default = true,
    },
    {
        name = "ENABLE_MIAOJI_WHIP",
        label = "修改原版三尾猫鞭",
        hover = "是否修改原版三尾猫鞭（关闭可避免与其他 Mod 冲突）",
        options =
        {
            { description = "关闭", data = false },
            { description = "开启（默认）", data = true },
        },
        default = true,
    },
    -----------------------------------------------------------------------
    {
        name = "",
        label = "【书籍能力系统】",
        options = { {description = "", data = 0} },
        default = 0,
    },
    {
        name = "ENABLE_BOOK_POWER",
        label = "书籍能力（制作与阅读）",
        hover = "开启后，喵吉可制作并阅读薇克巴顿的书籍",
        options =
        {
            { description = "关闭", data = false },
            { description = "开启（默认）", data = true },
        },
        default = true,
    },

    {
        name = "BOOK_SANITY_MULT",
        label = "读书理智消耗倍率",
        hover = "1.0 = 薇克巴顿，2.0 = 麦斯威尔，数值越大消耗越高",
        options =
        {
            { description = "1.0 倍", data = true },
            { description = "2.0 倍", data = false },
        },
        default = true,
    },

    {
        name = "BOOK_UNLOCK_LEVEL",
        label = "书籍能力解锁等级",
        hover = "达到该等级后才可制作和阅读书籍",
        options =
        {
            { description = "0 级", data = 0 },
            { description = "5 级", data = 5 },
            { description = "10 级（默认）", data = 10 },
            { description = "15 级", data = 15 },
            { description = "20 级", data = 20 },
        },
        default = 10,
    },
}
