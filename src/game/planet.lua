dofile("src/core/node.lua")

Planet = {}

Planet.new = function(scene, parent, x, y, m, isStar)
    local texture = nil
    if isStar then texture = "star" else texture = "meteor" end
    local self = Node.image(scene, parent, x - m / 2, y - m / 2, m, m, "resources/textures/"..texture..".png", "resources/shaders/shine.glsl", Color(1,1,1,1), true)

    self.cx = x
    self.cy = y
    self.vx = 0
    self.vy = 0
    self.ax = 0
    self.ay = 0

    self.m = m
    self.rotationSpeed = love.math.random() * 2

    self.updateInternal = function(dt)
        self.rotate(self.rotationSpeed * dt)

        self.vx = self.vx + self.ax * dt
        self.vy = self.vy + self.ay * dt
        self.cx = self.cx + self.vx * dt
        self.cy = self.cy + self.vy * dt

        self.x = self.cx - self.m / 2
        self.y = self.cy - self.m / 2
    end

    local baseDrawGizmo = self.drawGizmo
    self.drawGizmo = function()
        baseDrawGizmo()
        
        love.graphics.setColor(Palette.gizmoRed.r, Palette.gizmoRed.g, Palette.gizmoRed.b, Palette.gizmoRed.a)
        love.graphics.line(self.cx, self.cy, self.x + self.vx, self.y + self.vy)
        love.graphics.setColor(Palette.gizmoGreen.r, Palette.gizmoGreen.g, Palette.gizmoGreen.b, Palette.gizmoGreen.a)
        love.graphics.line(self.cx, self.cy, self.x + self.ax, self.y + self.ay)
    end

    self.toString = function(this)
        return "Planet "..this.id..": ".."mass: "..this.m
    end

    return self
end