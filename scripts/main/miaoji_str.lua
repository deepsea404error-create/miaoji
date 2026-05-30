--------------------------------------------------------------------------
-- 喵吉 STRINGS 定义（统一管理）
--------------------------------------------------------------------------

--------------------------------------------------------------------------
-- 人物信息
--------------------------------------------------------------------------

-- 选人界面
STRINGS.CHARACTER_NAMES.miaoji = "喵吉"
STRINGS.CHARACTER_TITLES.miaoji = "普通的喵咪"
STRINGS.CHARACTER_DESCRIPTIONS.miaoji =
    "*在黄昏和黑夜能够得到加强\n" ..
    "*对这个世界充满好奇\n" ..
    "*是一只普通却努力生活的喵咪"

STRINGS.CHARACTER_QUOTES.miaoji = "这里是哪里喵"
STRINGS.CHARACTER_SURVIVABILITY.miaoji = "中等"

-- 人物语言（使用威尔逊）
STRINGS.CHARACTERS.MIAOJI = require "speech_wilson"

-- 游戏内名称
STRINGS.NAMES.MIAOJI = "喵吉"
STRINGS.SKIN_NAMES.miaoji_none = "喵吉"

--------------------------------------------------------------------------
-- 物品：猫猫口袋
--------------------------------------------------------------------------

-- 猫猫口袋
STRINGS.NAMES.MIAOJI_BG = "猫猫口袋"
STRINGS.RECIPE_DESC.MIAOJI_BG =
    "轻便的小口袋\n" ..
    "增加10%移动速度\n" ..
    "提供40%防雨效果"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_BG =
    "一个可爱的口袋"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_BG =
    "装点小东西刚刚好喵"

--------------------------------------------------------------------------
-- 猫猫口袋 +
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_BG_PLUS = "猫猫口袋+"
STRINGS.RECIPE_DESC.MIAOJI_BG_PLUS =
    "更加舒适的口袋\n" ..
    "增加15%移动速度\n" ..
    "每秒恢复3点理智\n" ..
    "提供60%防雨效果\n" ..
    "2倍保鲜"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_BG_PLUS =
    "看起来更高级了"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_BG_PLUS =
    "可以装更多东西了喵"

--------------------------------------------------------------------------
-- 猫猫口袋 ++
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_BG_PLUS_PLUS = "猫猫口袋++"
STRINGS.RECIPE_DESC.MIAOJI_BG_PLUS_PLUS =
    "几乎完美的猫猫口袋\n" ..
    "增加25%移动速度\n" ..
    "每秒恢复5点理智\n" ..
    "100%防雨（等同眼球伞）\n" ..
    "4倍保鲜"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_BG_PLUS_PLUS =
    "这口袋不简单"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_BG_PLUS_PLUS =
    "这是喵的究极装备喵！"

--------------------------------------------------------------------------
-- 武器：猫猫爪
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_CLAW = "猫猫爪"
STRINGS.RECIPE_DESC.MIAOJI_CLAW =
    "喵吉出生自带的利爪\n" ..
    "只有喵吉才能使用"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_CLAW =
    "锋利但不太适合我"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_CLAW =
    "这是喵的一部分喵"

--------------------------------------------------------------------------
-- 武器：喵刀
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_SWORD = "喵刀"
STRINGS.RECIPE_DESC.MIAOJI_SWORD =
    "来自异界的武器\n" ..
    "能够当作斧头和稿子使用\n" ..
    "5%概率暴击\n" ..
    "非喵吉人物-10理智/min"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_SWORD =
    "来自异界的武器"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_SWORD =
    "这是喵的喵刀！"

--------------------------------------------------------------------------
-- 武器：喵刀plus
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_SWORD_PLUS = "喵刀+"
STRINGS.RECIPE_DESC.MIAOJI_SWORD_PLUS =
    "来自异界的武器\n" ..
    "能够当作斧头和稿子使用(更高的效率)\n" ..
    "10%概率暴击\n" ..
    "非喵吉人物-10理智/min"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_SWORD_PLUS =
    "来自异界的武器，似乎更加强大了"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_SWORD_PLUS =
    "这是喵的喵刀！"

--------------------------------------------------------------------------
-- 武器：喵刀plus
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_SWORD_PLUS_PLUS = "喵刀++"
STRINGS.RECIPE_DESC.MIAOJI_SWORD_PLUS_PLUS =
    "来自异界的武器\n" ..
    "能够当作斧头和稿子使用(更高的效率)\n" ..
    "15%概率暴击，且造成冰冻\n" ..
    "非喵吉人物-10理智/min\n" ..
    "右键释放矮星"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_SWORD_PLUS_PLUS =
    "来自异界的武器，似乎更加强大了"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_SWORD_PLUS_PLUS =
    "这是喵的喵刀！"

--------------------------------------------------------------------------
-- 武器：猫灵护符
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_AMULET = "猫灵护符"
STRINGS.RECIPE_DESC.MIAOJI_AMULET =
    "血量低于60%时每秒恢复0.5血\n" ..
    "增加10%移速\n" ..
    "非喵吉人物-3理智/min\n" ..
    "完全抵挡一次攻击，冷却10秒，消耗8san"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_AMULET =
    "拥有神秘力量的护符"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_AMULET =
    "这是喵的护身符！"

--------------------------------------------------------------------------
-- 武器：猫灵护符+
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_AMULET_PLUS = "猫灵护符+"
STRINGS.RECIPE_DESC.MIAOJI_AMULET_PLUS =
    "血量低于80%时每秒恢复1血\n" ..
    "增加20%移速\n" ..
    "非喵吉人物-3理智/min\n" ..
    "控温，每天温度调节消耗15san\n" ..
    "完全抵挡一次攻击，冷却5秒，消耗5san"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_AMULET_PLUS =
    "拥有强大神秘力量的护符"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_AMULET_PLUS =
    "这是喵的终极护身符！"

--------------------------------------------------------------------------
-- 武器：心弦
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_HEARTSTRING = "心弦"
STRINGS.RECIPE_DESC.MIAOJI_HEARTSTRING =
    "一把远程武器"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_HEARTSTRING =
    "似乎它的魔力消散了"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_HEARTSTRING =
    "远程的魔法弓喵！"
--------------------------------------------------------------------------
-- 武器：心弦+
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_HEARTSTRING_PLUS = "心弦+"
STRINGS.RECIPE_DESC.MIAOJI_HEARTSTRING_PLUS =
    "更强的魔法弓,50%概率造成0.5倍的范围伤害"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_HEARTSTRING_PLUS =
    "似乎魔力没有得到完美的释放"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_HEARTSTRING_PLUS =
    "更强远程的魔法弓喵！"
--------------------------------------------------------------------------
-- 武器：彩棱头冠
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_PRISMATIC_CROWN = "彩棱头冠"
STRINGS.RECIPE_DESC.MIAOJI_PRISMATIC_CROWN =
    "80%护甲(10位面防御)，单体反伤，攻击概率回血\n" ..
    "可使用红蓝紫宝石修复。"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_PRISMATIC_CROWN =
    "顶头冠折射着七彩的光芒。"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_PRISMATIC_CROWN =
    "彩虹的光芒让喵感觉更精神了！"
--------------------------------------------------------------------------
-- 武器：彩棱头冠+
--------------------------------------------------------------------------

STRINGS.NAMES.MIAOJI_PRISMATIC_CROWN_PLUS = "彩棱头冠+"
STRINGS.RECIPE_DESC.MIAOJI_PRISMATIC_CROWN_PLUS =
    "90%护甲(20位面防御)，25%增伤，单体反伤，攻击概率回血\n" ..
    "免疫冰冻火焰，降san光环。可使用红蓝紫宝石修复。"

STRINGS.CHARACTERS.GENERIC.DESCRIBE.MIAOJI_PRISMATIC_CROWN_PLUS =
    "璀璨夺目的光辉，蕴含着神秘的力量。"

STRINGS.CHARACTERS.MIAOJI.DESCRIBE.MIAOJI_PRISMATIC_CROWN_PLUS =
    "升级之后的光芒，让喵充满了力量！"
--------------------------------------------------------------------------
-- 原版物品转换
--------------------------------------------------------------------------
STRINGS.RECIPE_DESC.FISHMEAT_SMALL = "把肉伪装成鱼"
STRINGS.RECIPE_DESC.SMALLMEAT = "把鱼伪装成肉"

STRINGS.RECIPE_DESC.FISHMEAT = "看起来更像鱼了"
STRINGS.RECIPE_DESC.MEAT = "看起来更像肉了"

STRINGS.RECIPE_DESC.COONTAIL = "用牛毛做成的猫尾巴"

STRINGS.RECIPE_DESC.OPALPRECIOUSGEM = "七彩光芒汇聚于一体"
