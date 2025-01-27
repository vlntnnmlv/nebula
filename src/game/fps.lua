FPS = {}

FPS.new = function(scene, parent, cx, cy, fontSize)
    local self = Node.text(scene, parent, 0, cx, cy, fontSize, false)
    self.ignoreEvents = true

    self.updateInternal = function(dt)
        self.setText(love.timer.getFPS())
    end

    return self
end