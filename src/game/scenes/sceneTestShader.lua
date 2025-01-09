dofile("src/core/node.lua")

local scene = Scene.new("Shader")

local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setColor(Color(0.118, 0.165, 0.251, 1.0))
root.ignoreEvents = true

local picName = "big"

-- Node.image(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "resources/textures/probe/"..picName..".png")

local imageWidth, imageHeight = 565, 960
local image = Node.image(scene, root, SCREEN_WIDTH / 2 - imageWidth / 2, SCREEN_HEIGHT / 2 - imageHeight / 2, imageWidth, imageHeight, "resources/textures/probe/"..picName..".png")
image.setColor(Color(1,1,1,1))
image.ignoreEvents = true

-- image.shader.setParameter("iScale", { 128, 218 })