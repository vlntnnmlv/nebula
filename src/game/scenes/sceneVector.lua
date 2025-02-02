require("core.geometry.dot")
require("core.geometry.line")
require("game.stockExchange.plot")

local scene = Scene.create("Vector")
local root = Image.create(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "white.png")
root:setColor(Color(0.5, 0.5, 0.5, 1.0))

-- local a = Vector2.create(SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
-- local dotA = Dot.create(scene, root, a)

-- local b = Vector2.create(SCREEN_WIDTH / 2 + 150, SCREEN_HEIGHT / 2 + 150)
-- local dotB = Dot.create(scene, root, b)

-- local c = Vector2.create(SCREEN_WIDTH / 2 - 150, SCREEN_HEIGHT / 2 + 150)
-- local dotC = Dot.create(scene, root, c)

-- local lineAB = Line.create(scene, root, a, b)

local plot = Plot.create(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

-- function aNode:updateInternal()
--     local x, y = love.mouse.getPosition()
--     aNode.x = x
--     aNode.y = y
-- end