dofile("src/palette.lua")

function Color(r,g,b,a)
    return { r = r, g = g, b = b, a = a}
end

Node = {}

Node.nodes = {}
Node.nodesCount = 0

Node.focusElement = nil

Node.drawGizmos = false

local function register_node(node)
    node.id = Node.nodesCount
    Node.nodesCount = Node.nodesCount + 1

    Node.nodes[node.id] = node
end

Node.new = function(parent, x, y, w, h, color, ignoreEvents)
    local self = {}

    self.parent = parent
    self.children = {}
    self.childrenCount = 0

    if self.parent ~= nil then
        self.parent.linkChild(self)
    end

    if ignoreEvents == nil then
        self.ignoreEvents = false
    else
        self.ignoreEvents = ignoreEvents
    end

    self.x = x
    self.y = y
    self.w = w
    self.h = h

    if color == nil then
        self.color = Color(0.0, 0.0, 0.0, 0.1)
    else
        self.color = color
    end

    self.linkChild = function(child)
        self.children[self.childrenCount] = child
        self.childrenCount = self.childrenCount + 1
    end

    self.getParentID = function()
        if self.parent == nil then return "nil" end

        return self.parent.id
    end

    self.drawChildren = function()
        for i = 0, self.childrenCount - 1 do
            self.children[i].draw()
        end
    end

    self.draw = function()
        -- gizmo
        if Node.drawGizmos then
            love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
            love.graphics.polygon(
                "line",
                self.x, self.y,
                self.x + self.w, self.y,
                self.x + self.w, self.y + self.h,
                self.x, self.y + self.h
            )
        end

        local color = Color(self.color.r, self.color.g, self.color.b, self.color.a)
        if self.hovered then
            color.r = color.r - 0.1
            color.g = color.g - 0.1
            color.b = color.b - 0.1
            color.a = color.a
        end

        love.graphics.setColor(color.r, color.g, color.b, color.a)

        self.drawInternal()

        self.drawChildren()
    end

    self.drawInternal = function()
        love.graphics.polygon(
            "fill",
            self.x, self.y,
            self.x + self.w, self.y,
            self.x + self.w, self.y + self.h,
            self.x, self.y + self.h
        )
    end

    self.updateChildren = function(_)
        local anyChildHovered = false

        for i = 0, self.childrenCount - 1 do
            anyChildHovered = anyChildHovered or self.children[i].update(_)
        end

        return anyChildHovered
    end

    self.update = function(_)
        local mouseX, mouseY = love.mouse.getPosition()

        local anyChildHovered = self.updateChildren(_)

        if anyChildHovered then
            self.hovered = false
            return false
        end

        if self.ignoreEvents then return false end

        if mouseX <= self.x or mouseX >= self.x + self.w or mouseY <= self.y or mouseY >= self.y + self.h then
            self.hovered = false
            return false
        end

        self.hovered = true
        Node.focusElement = self

        return true
    end

    self.setAction = function(action)
        self.action = action
    end

    self.hovered = false

    register_node(self)

    return self
end

Node.text = function(parent, text, cx, cy, fontSize, color, ignoreEvents, incept)
    local self = Node.new(parent, cx, cy, 0, 0, color, ignoreEvents)

    self.restore = function()
        self.w = self.font:getWidth(self.text)
        self.h = self.font:getBaseline(self.text)
        self.x = self.cx - self.w / 2
        self.y = self.cy - self.h / 2

        if self.incept then
            if self.incepted == nil then
                self.incepted = Node.text(self, text, cx + 2, cy + 2, fontSize - 1, color, true, false)
            else
                self.incepted.setText(self.text)
            end
        end
    end

    self.text = text
    self.font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)
    self.incept = incept
    self.cx = cx
    self.cy = cy

    self.restore()

    self.setText = function(text)
        self.text = text

        self.restore()
    end

    self.drawInternal = function()
        love.graphics.setFont(self.font)
        love.graphics.print(self.text, self.x, self.y)
    end

    return self
end

Node.image = function(parent, x, y, w, h, image, color, ignoreEvents)
    local self = Node.new(parent, x, y, w, h, color, ignoreEvents)

    self.imageData = love.image.newImageData(image)
    self.image = love.graphics.newImage(self.imageData, { linear = true })

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()

    self.drawInternal = function()
        love.graphics.draw(self.image, self.x, self.y, 0, self.scaleX, self.scaleY)
    end

    return self
end

Node.drawAll = function()
    if Node.nodesCount == 0 then return end

    Node.nodes[0].draw()
end

Node.updateAll = function(_)
    if Node.nodesCount == 0 then return end

    Node.nodes[0].update(_)
    Node.nodes[0].updateChildren(_)
end

Node.pressedElement = nil

Node.updateMouseButtonEvent = function(pressed)
    if Node.nodesCount == 0 then return end

    Node.nodes[0].update(0)
    Node.nodes[0].updateChildren(0)

    if pressed then
        Node.pressedElement = Node.focusElement
    end

    if not pressed and Node.pressedElement.id == Node.focusElement.id and Node.focusElement.action ~= nil then
        Node.focusElement.action()
    end
end