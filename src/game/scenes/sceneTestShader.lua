dofile("src/core/node.lua")

local scene = Scene.new("Shader")

local offsetX, offsetY = 0, 0
local scale = 2
local depth = 100

local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setShader("fractal")

root.setKeyAction("p", function() scale = scale * 0.99 end)
root.setKeyAction("o", function() scale = scale * 1.01 end)
root.setKeyAction("w", function() offsetY = offsetY + 0.01 end)
root.setKeyAction("a", function() offsetX = offsetX + 0.01 end)
root.setKeyAction("s", function() offsetY = offsetY - 0.01 end)
root.setKeyAction("d", function() offsetX = offsetX - 0.01 end)
root.setKeyAction("l", function() depth = depth - 100 end)
root.setKeyAction("k", function() depth = depth + 100 end)

root.shader.setParameter("iScale", function() return scale end)
root.shader.setParameter("iDepth", function() return depth end)
root.shader.setParameter("iOffset", function() return { offsetX, offsetY } end )
root.shader.setParameter("iTime", function() return love.timer.getTime() end )

root.ignoreEvents = false

-- local picName = "tree.jpg"

-- -- Node.image(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "probe/"..picName..".png")

-- local imageWidth, imageHeight = SCREEN_WIDTH, SCREEN_HEIGHT
-- local image = Node.image(scene, root, SCREEN_WIDTH / 2 - imageWidth / 2, SCREEN_HEIGHT / 2 - imageHeight / 2, imageWidth, imageHeight, picName)
-- image.setShader("pixelize")
-- image.shader.setParameter("iScale", { 128, 128 })
-- image.setColor(Color(1,1,1,1))
-- image.ignoreEvents = true

-- image.shader.setParameter("iScale", { 128, 218 })