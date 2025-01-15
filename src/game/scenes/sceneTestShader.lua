dofile("src/core/node.lua")

local scene = Scene.new("Shader")

local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)

---- voronoy
root.setShader("voronoy")

local points = {}

local function generatePoints()
    for i=2,50 do
        local x, y = love.math.random(), love.math.random()
        points[i] = { x, y }
    end
end

local function getMousePositionScaled()
    local x, y = love.mouse.getPosition()
    local w, h = SCREEN_WIDTH, SCREEN_HEIGHT

    return { x / w, y / h }
end

generatePoints()
root.shader.setParameter("iPoints", function () points[1] = getMousePositionScaled() return points end, 1)
root.setAction(
    function(pressed)
        if not pressed then return end
        generatePoints()
    end
)

---- fractal
-- root.setShader("fractal")

-- local offsetX, offsetY = 0, 0
-- local scale = 2
-- local depth = 100

-- root.setKeyAction("p", function() scale = scale * 0.99 end)
-- root.setKeyAction("o", function() scale = scale * 1.01 end)
-- root.setKeyAction("w", function() offsetY = offsetY - 0.01 end)
-- root.setKeyAction("a", function() offsetX = offsetX - 0.01 end)
-- root.setKeyAction("s", function() offsetY = offsetY + 0.01 end)
-- root.setKeyAction("d", function() offsetX = offsetX + 0.01 end)
-- root.setKeyAction("l", function() depth = depth - 100 end)
-- root.setKeyAction("k", function() depth = depth + 100 end)

-- root.setAction(
--     function(pressed)
--         if pressed then return end

--         offsetX, offsetY = 0, 0
--         scale = 2
--         depth = 100
--     end
-- )

-- root.shader.setParameter("iScale", function() return scale end)
-- root.shader.setParameter("iDepth", function() return depth end)
-- root.shader.setParameter("iOffset", function() return { offsetX, offsetY } end )
-- root.shader.setParameter("iTime", function() return love.timer.getTime() end )


-- local picName = "tree.jpg"

-- -- Node.image(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "probe/"..picName..".png")

-- local imageWidth, imageHeight = SCREEN_WIDTH, SCREEN_HEIGHT
-- local image = Node.image(scene, root, SCREEN_WIDTH / 2 - imageWidth / 2, SCREEN_HEIGHT / 2 - imageHeight / 2, imageWidth, imageHeight, picName)
-- image.setShader("pixelize")
-- image.shader.setParameter("iScale", { 128, 128 })
-- image.setColor(Color(1,1,1,1))
-- image.ignoreEvents = true

-- image.shader.setParameter("iScale", { 128, 218 })