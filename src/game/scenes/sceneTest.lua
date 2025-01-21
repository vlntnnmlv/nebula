local sceneTest = Scene.new("Test")

local alpha = 1.0
local root = Node.new(sceneTest, nil, 0, 0, SCREEN_WIDTH + 1, SCREEN_HEIGHT + 1)
root.setColor(Color(0.0, 0.5, 0.5, 1.0))

local node = Node.new(sceneTest, root, 120, 120, 240, 240)
node.setColor(Color(0.5, 0.0, 0.5, alpha))

node.setKeyAction("v", function() alpha = alpha - 0.01 node.setColor(Color(0.5, 0.0, 0.5, alpha)) end)
node.setKeyAction("b", function() alpha = alpha + 0.01 node.setColor(Color(0.5, 0.0, 0.5, alpha)) end)
