function Color(r,g,b,a)
    return { r = r, g = g, b = b, a = a}
end

Node = {}

Node.nodes = {}
Node.nodesCount = 0

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
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        love.graphics.polygon(
            "fill",
            self.x, self.y,
            self.x + self.w, self.y,
            self.x + self.w, self.y + self.h,
            self.x, self.y + self.h
        )
        love.graphics.setColor(1.0, 0.0, 0.0, 1.0)
        love.graphics.polygon(
            "line",
            self.x, self.y,
            self.x + self.w, self.y,
            self.x + self.w, self.y + self.h,
            self.x, self.y + self.h
        )

        self.drawChildren()
    end

    register_node(self)

    return self
end

Node.text = function(parent, text, x, y, fontSize, color)
    local self = Node.new(parent, x, y, 0, 0, color)

    self.text = text
    self.font = love.graphics.newFont(fontSize)
    self.w = self.font:getWidth(self.text)
    self.h = self.font:getBaseline(self.text)

    self.draw = function()
        love.graphics.setFont(self.font)

        love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        love.graphics.print(self.text, self.x - self.w / 2, self.y - self.h / 2)
    end

    return self
end

Node.drawAll = function()
    if Node.nodesCount == 0 then return end

    Node.nodes[0].draw()
end