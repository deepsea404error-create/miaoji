local containers = require("containers")

-- local screen_w, screen_h = TheSim:GetScreenSize()

containers.params.miaoji_bg_plus =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_piggyback_2x6",
        animbuild = "ui_piggyback_2x6",
        pos = Vector3(0, 0, 0),
    },
    issidewidget = true,
    type = "pack",
}

-- 自动生成 2×6 = 12 格
for y = 2.5, -2.5, -1 do
    for x = -1, 0 do
        table.insert(
            containers.params.miaoji_bg_plus.widget.slotpos,
            Vector3(75 * x - 85, 75 * y - 15, 0)
        )
    end
end
