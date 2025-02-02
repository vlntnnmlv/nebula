Vector2 = CreateClass()

function Vector2:init(x, y)
    self.x = x
    self.y = y
end

function Vector2:mag()
    return math.sqrt(self.x * self.x + self.y * self.y)
end

function Vector2:add(other)
    self.x = self.x + other.x
    self.y = self.y + other.y
end