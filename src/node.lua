Node = {}

Node.nodes = {}
Node.next_id = 1

local function register_node(node)
    node.id = Node.next_id
    Node.next_id = Node.next_id + 1

    Node.nodes[node.id] = node
end

Node.new = function(x, y, w, h, color)
    local self = {}

    self.x = x
    self.y = y
    self.w = w
    self.h = h

    if color == nil then
        self.color = { r = 0.0, g = 0.0, b = 0.0, a = 0.1 } 
    else
        self.color = color
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
        love.graphics.print(self.id, self.x + self.w / 2, self.y + self.h / 2)
    end

    register_node(self)

    return self
end

Node.drawAll = function()
    for i = 1, Node.next_id - 1 do
        Node.nodes[i].draw()
    end
end