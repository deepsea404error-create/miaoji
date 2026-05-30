local containers = require("containers")

-- local screen_w, screen_h = TheSim:GetScreenSize()

containers.params.miaoji_bg_plus_plus =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_krampusbag_2x8",
        animbuild = "ui_krampusbag_2x8",
        pos = Vector3(0, 0, 0),
    },
    issidewidget = true,
    type = "pack",
}

-- 自动生成 2×8 = 16 格
-- y 从 3.5 到 -3.5，每行间隔 1
-- x 从 -1 到 0，每列两格
for y = 3.5, -3.5, -1 do
    for x = -1, 0 do
        table.insert(
            containers.params.miaoji_bg_plus_plus.widget.slotpos,
            Vector3(75 * x - 85, 65 * y + 15, 0)
        )
    end
end
