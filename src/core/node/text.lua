Text = CreateClass(Node)

function Text:init(scene, parent, str, cx, cy, fontSize)
    local font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)

    -- TODO: Fix doublicate calculation
    local w = font:getWidth(str)
    local h = font:getHeight(str)

    Node.init(self, scene, parent, cx, cy, w, h)

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