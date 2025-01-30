local sceneTest = Scene.create("Test")

local alpha = 1.0
local root = Node.create(sceneTest, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root:setColor(Color(0.0, 0.5, 0.5, 1.0))
-- root:setShader("pixelize")
-- root.shader:setParameter("iScale", { 128, 128 })

-- require("game.pinball")

-- local pinball = Pinball.create(sceneTest, root, SCREEN_WIDTH / 2, SCREEN_HEIGHT - 128, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

-- local node = Image.create(sceneTest, root, 120, 120, 240, 240, "eye.png")
-- function node:updateInternal()
--     self:rotate(math.sin(Time.time) / 5.0)
--     self:setAlpha(math.abs(math.sin(Time.time)))
-- end

-- node:setKeyAction("v", function() alpha = alpha - 0.01 node:setAlpha(alpha) end)
-- node:setKeyAction("b", function() alpha = alpha + 0.01 node:setAlpha(alpha) end)