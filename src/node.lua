function Color(r,g,b,a)
    return { r = r, g = g, b = b, a = a}
end

Node = {}

Node.nodes = {}
Node.nodesCount = 0
Node.drawGizmos = false

local function register_node(node)
    node.id = Node.nodesCount
    Node.nodesCount = Node.nodesCount + 1

    Node.nodes[node.id] = node
end

Node.new = function(parent, x, y, w, h, color)
    local self = {}
    
    self.parent = parent
    self.children = {}
    self.childrenCount = 0

    self.linkChild = function(child)
        self.children[self.childrenCount] = child
        self.childrenCount = self.childrenCount + 1
    end

    self.getParentID = function()
        if self.parent == nil then return "nil" end

        return self.parent.id
    end

    if self.parent ~= nil then
        self.parent.linkChild(self)
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
        if self.state == 1 then
            color.r = color.r - self.hoverMask.r
            color.g = color.g - self.hoverMask.g
            color.b = color.b - self.hoverMask.b
            color.a = color.a - self.hoverMask.a
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
        for i = 0, self.childrenCount - 1 do
            self.children[i].update(_)
        end
    end

    self.update = function(_)
        local mouseX, mouseY = love.mouse.getPosition()

        if mouseX <= self.x or mouseX >= self.x + self.w or mouseY <= self.y or mouseY >= self.y + self.h then
            self.state = 0
            return
        end

        self.state = 1

        self.updateChildren(_)
    end

    self.state = 0 -- normal state, 1 - hovered
    self.hoverMask = Color(0.0, 0.5, 0.5, 1.0) -- TODO: change how this thingy works

    register_node(self)

    return self
end

Node.text = function(parent, text, x, y, fontSize, color)
    local self = Node.new(parent, x, y, 0, 0, color)

    self.text = text
    self.font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)
    self.w = self.font:getWidth(self.text)
    self.h = self.font:getBaseline(self.text)

    self.drawInternal = function()
        love.graphics.setFont(self.font)
        love.graphics.print(self.text, self.x - self.w / 2, self.y - self.h / 2)
    end

    return self
end

Node.drawAll = function()
    if Node.nodesCount == 0 then return end

    Node.nodes[0].draw()
end

Node.updateAll = function(_)
    if Node.nodesCount == 0 then return end

    Node.nodes[0].updateChildren(_)
end