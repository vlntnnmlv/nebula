local sceneTest = Scene.create("Test")

local alpha = 1.0
local root = Node.create(sceneTest, nil, 0, 0, SCREEN_WIDTH + 1, SCREEN_HEIGHT + 1)
root:setColor(Color(0.0, 0.5, 0.5, 1.0))

local node = Node.create(sceneTest, root, 120, 120, 240, 240)
node:setColor(Color(0.5, 0.0, 0.5, alpha))

node:setKeyAction("v", function() alpha = alpha - 0.01 node:setColor(Color(0.5, 0.0, 0.5, alpha)) end)
node:setKeyAction("b", function() alpha = alpha + 0.01 node:setColor(Color(0.5, 0.0, 0.5, alpha)) end)
