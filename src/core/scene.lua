dofile("src/core/node.lua")

Scene = {}

Scene.new = function()
    local self = {}

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

    self.updateAll = function(_)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(_)
        self.nodes[0].updateChildren(_)
    end

    self.updateMouseButtonEvent = function(pressed)
        if self.nodesCount == 0 then return end

        self.nodes[0].update(0)
        self.nodes[0].updateChildren(0)

        if pressed then
            self.pressedElement = self.focusElement
        end

        if not pressed and self.pressedElement ~= nil and self.pressedElement.id == self.focusElement.id and self.focusElement.action ~= nil then
            self.focusElement.action()
        end
    end

    return self
end