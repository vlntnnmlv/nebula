local sceneTest = Scene.create("Test")

local alpha = 1.0
local root = Node.create(sceneTest, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
root:setColor(Color(0.0, 0.5, 0.5, 1.0))
root:setShader("pixelize")
root.shader:setParameter("iScale", { 128, 128 })

local player = Image.create(sceneTest, root, 0, 0, 64, 64, "player.png")

player:setKeyAction("w", function() player.y = player.y - Time.dt * 100 end)
player:setKeyAction("a", function() player.prevX = player.x player.x = player.x - Time.dt * 100 end)
player:setKeyAction("s", function() player.y = player.y + Time.dt * 100 end)
player:setKeyAction("d", function() player.prevX = player.x player.x = player.x + Time.dt * 100 end)

function player:updateInternal()
    if self.prevX == nil then return end
    self.mirrorX = self.prevX < self.x
end

player.mirrorX = false

local node = Image.create(sceneTest, root, 120, 120, 240, 240, "eye.png")
function node:updateInternal()
    self:rotate(math.sin(Time.time) / 5.0)
    self:setAlpha(math.abs(math.sin(Time.time)))
end

-- local text = Text.create(sceneTest, node, "hello, world!", node.x + node.w/2, node.y + node.h/2, 36)
-- text:setColor(Color(1.0, 0, 0.0, 1.0))
-- Logger.warning(text.w.." "..text.h)

node:setKeyAction("v", function() alpha = alpha - 0.01 node:setAlpha(alpha) end)
node:setKeyAction("b", function() alpha = alpha + 0.01 node:setAlpha(alpha) end)