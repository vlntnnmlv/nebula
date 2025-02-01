local sceneTest = Scene.create("Test")

local alpha = 1.0
local root = Image.create(sceneTest, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "white.png")
root:setColor(Color(0.0, 0.5, 0.5, 1.0))
-- root:setShader("pixelize")
-- root.shader:setParameter("iScale", { 128, 128 })
root:setShader("comet")
require("game.pinball")

local pinball = Pinball.create(sceneTest, root, SCREEN_WIDTH / 2, SCREEN_HEIGHT - 128, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.shader:setParameter("iResolution", { pinball.w, pinball.h })
root.shader:setParameter("iPosition", function() return { pinball.ball.x + pinball.ballSize / 2, pinball.ball.y + pinball.ballSize / 2} end)
root.shader:setParameter("iRadius", pinball.ballSize)
root.shader:setParameter("iDirection", function() return { pinball.vx, pinball.vy } end)

-- local node = Image.create(sceneTest, root, 120, 120, 240, 240, "eye.png")
-- function node:updateInternal()
--     self:rotate(math.sin(Time.time) / 5.0)
--     self:setAlpha(math.abs(math.sin(Time.time)))
-- end

-- node:setKeyAction("v", function() alpha = alpha - 0.01 node:setAlpha(alpha) end)
-- node:setKeyAction("b", function() alpha = alpha + 0.01 node:setAlpha(alpha) end)