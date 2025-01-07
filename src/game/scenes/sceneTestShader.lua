dofile("src/core/node.lua")

local scene = Scene.new("Shader")

local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.ignoreEvents = true

local image = Node.image(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, "resources/textures/vinesrain.jpg")
image.setShader(Shader.new("resources/shaders/pixelize.glsl"))
-- image.setColor(Color(1,1,1,1))
image.ignoreEvents = true

image.shader.setParameter("iScale", 128)

-- Node.new(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, Color(1, 0, 0, 0), true)