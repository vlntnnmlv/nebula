Text = CreateClass(Node)

function Text.create(scene, parent, str, cx, cy, fontSize)
    local text = Text:new()

    text:init(scene, parent, str, cx, cy, fontSize)
    return text
end

function Text:init(scene, parent, str, cx, cy, fontSize)
    local font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)

    local w = font:getWidth(str)
    local h = font:getHeight(str)

    Node.init(self, scene, parent, w, h, cx, cy)

    self.font = font
    self.str = str
    self.cx = cx
    self.cy = cy

    self:restore()
end

function Text:restore()
    self.w = self.font:getWidth(self.str)
    self.h = self.font:getBaseline(self.str)
    self.x = self.cx - self.w / 2
    self.y = self.cy - self.h / 2
end

function Text:setText(str)
    self.str = str

    self:restore()
end

function Text:drawInternal()
    love.graphics.setFont(self.font)
    love.graphics.print(self.str, 0, 0)
end