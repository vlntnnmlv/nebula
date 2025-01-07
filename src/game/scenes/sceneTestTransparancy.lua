dofile("src/core/node.lua")

local scene = Scene.new("Transparancy")
local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setColor(Color(1.0, 1.0, 1.0, 1.0))

local node = Node.new(scene, root, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, SCREEN_HEIGHT)
node.setColor(Color(0.0, 1.0, 0.0, 0.5))

local nody = Node.new(scene, node, SCREEN_WIDTH / 2 - 100, 150, 200, 200)
nody.setColor(Color(0.0, 0.0, 1.0, 0.5))