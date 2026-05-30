local containers = require("containers")

------------------------------------------------------------
-- 注册容器参数（DST 正确方式）
------------------------------------------------------------

-- 获取屏幕宽高
-- local screen_w, screen_h = TheSim:GetScreenSize()

containers.params.miaoji_bg =
{
    widget =
    {
        slotpos =
        {
            -- 第 1 行（最上）
            Vector3(-162,  108, 0),
            Vector3(-162+75,  108, 0),

            -- 第 2 行
            Vector3(-162,  36, 0),
            Vector3(-162+75,  36, 0),

            -- 第 3 行
            Vector3(-162, -36, 0),
            Vector3(-162+75, -36, 0),

            -- 第 4 行（最下）
            Vector3(-162, -108, 0),
            Vector3(-162+75, -108, 0),
        },
        animbank = "ui_backpack_2x4",
        animbuild = "ui_backpack_2x4",
        pos = Vector3(0,0,0),
    },
    issidewidget = true,

    type = "pack",
}
