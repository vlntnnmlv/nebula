dofile("src/core/node.lua")

local scene = Scene.new("Transparancy")
local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setColor(Palette.darkest)

local node = Node.new(scene, root, 100, 100, 500, 500)
node.setColor(Color(0.1,0.1,0.1,0.1))
node.setShader(Shader.new("resources/shaders/chrome.glsl"))
node.shader.setParameter("iTime", 100)

local nody = Node.new(scene, node, 150, 150, 200, 200).setColor(Color(0,1,0,1))