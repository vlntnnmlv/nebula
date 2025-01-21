dofile("src/core/node/node.lua")

local scene = Scene.new("Transparancy")
local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.setShader("pixelize")
root.shader.setParameter("iScale", {64, 64})
root.setColor(Color(1.0, 1.0, 1.0, 1.0))

local node = Node.new(scene, root, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, SCREEN_HEIGHT)
node.setColor(Color(0.0, 1.0, 0.0, 1.0))

local nody = Node.new(scene, root, SCREEN_WIDTH / 2, 150, 200, 200)
nody.setColor(Color(0.0, 0.0, 1.0, 1.0))

local nodidi = Node.new(scene, root, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4, SCREEN_WIDTH / 2, SCREEN_WIDTH / 2)
nodidi.setShader("shine")
nodidi.setColor(Color(1.0, 0.2, 0.1, 1.0))
nodidi.shader.setParameter("iTime", function() return love.timer.getTime() end)