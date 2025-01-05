dofile("src/core/node.lua")

FPS = {}

FPS.new = function(scene, parent, cx, cy, fontSize)
    local self = Node.text(scene, parent, "", cx, cy, fontSize, false)
    self.ignoreEvents = true

    self.updateInternal = function(dt)
        self.setText(love.timer.getFPS())
    end

    return self
end