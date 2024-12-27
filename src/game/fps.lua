dofile("src/core/node.lua")

FPS = {}

FPS.new = function(scene, parent, cx, cy, fontSize, color)
    local self = Node.text(scene, parent, "", cx, cy, fontSize, color, true, false)

    self.updateInternal = function(dt)
        self.setText(love.timer.getFPS())
    end
end