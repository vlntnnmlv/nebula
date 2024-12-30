dofile("src/core/node.lua")

Scene = {}

Scene.current = nil
Scene.data = {}

Scene.switchScene = function(id)
    Scene.current = Scene.data[id]
end

Scene.new = function(id)
    local self = {}

    self.id = id
    Scene.data[id] = self

    self.nodes = {}
    self.nodesCount = 0
    self.focusElement = nil
    self.pressedElement = nil
    self.drawGizmos = false

    self.registerNode = function(node)
        node.id = self.nodesCount

        self.nodesCount = self.nodesCount + 1

        self.nodes[node.id] = node
    end

    self.drawAll = function()
        if self.nodesCount == 0 then return end

        self.nodes[0].draw()
    end

    self.updateAll = function(dt)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(dt)
    end

    self.updateMouseButtonEvent = function(pressed)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(0)

        if self.focusElement.action == nil then return end

        if pressed then
            self.pressedElement = self.focusElement
            self.focusElement.action(pressed)
        end

        if not pressed and self.pressedElement ~= nil and self.pressedElement.id == self.focusElement.id and self.focusElement.action ~= nil then
            self.focusElement.action(pressed)
        end
    end

    return self
end