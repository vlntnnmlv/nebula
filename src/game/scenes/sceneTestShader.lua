dofile("src/core/node.lua")

local scene = Scene.new("Test")

local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color(1,1,1,1), true)
local image = Node.image(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "resources/textures/beograd.jpg", Shader.new("resources/shaders/pixelize.glsl"), Color(1,1,1,1), true)

image.shader.setParameter("iScale", function() return love.mouse.getX() end)