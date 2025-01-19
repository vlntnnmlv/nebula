dofile("src/core/node/node.lua")

local scene = Scene.new("Transparancy")
local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root.shader = nil --setShader("color")
root.setColor(Color(1.0, 1.0, 1.0, 1.0))
-- root.shader.setParameter("iScale", { 128, 128 })

local node = Node.new(scene, root, SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 4, SCREEN_HEIGHT)
node.shader = nil
node.setColor(Color(0.0, 1.0, 0.0, 0.4))

local nody = Node.new(scene, node, SCREEN_WIDTH / 2, 150, 200, 200)
nody.shader = nil
-- nody.setShader("shine")
nody.setColor(Color(0.0, 0.0, 1.0, 1.0))
-- nody.shader.setParameter("iTime", function() return love.timer.getTime() end)