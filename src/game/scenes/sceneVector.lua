local scene = Scene.create("Vector")
local root = Image.create(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "white.png")
root:setColor(Color(0.1, 0.1, 0.1, 1.0))

local a = Vector2.create(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

local aNode = Image.create(scene, root, a.x, a.y, 16, 16, "dot.png", true)
aNode:setColor(Color(1.0, 0.0, 0.0, 1.0))
aNode.pivot = Vector2.create(0.5, 0.5)

-- function aNode:updateInternal()
--     local x, y = love.mouse.getPosition()
--     aNode.x = x
--     aNode.y = y
-- end