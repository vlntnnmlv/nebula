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

    return Vector2.create(self.x, self.y)
end

function Vector2:sub(other)
    self.x = self.x - other.x
    self.y = self.y - other.y

    return Vector2.create(self.x, self.y)
end

function Vector2:div(f)
    self.x = self.x / f
    self.y = self.y / f

    return Vector2.create(self.x, self.y)
end

function Vector2:mult(f)
    self.x = self.x * f
    self.y = self.y * f

    return Vector2.create(self.x, self.y)
end