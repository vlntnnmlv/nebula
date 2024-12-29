dofile("src/core/node.lua")

Planet = {}

Planet.new = function(scene, parent, x, y, m, isStar)
    local texture = nil
    if isStar then texture = "star" else texture = "meteor" end
    local self = Node.image(scene, parent, x - m / 2, y - m / 2, m, m, "resources/textures/"..texture..".png", "resources/shaders/shine.glsl", Color(1,1,1,1), true)

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
        self.x = self.x + self.vx * dt
        self.y = self.y + self.vy * dt
    end

    local baseDrawGizmo = self.drawGizmo
    self.drawGizmo = function()
        baseDrawGizmo()
        
        love.graphics.setColor(palette.gizmoRed.r, palette.gizmoRed.g, palette.gizmoRed.b, palette.gizmoRed.a)
        love.graphics.line(self.x + self.w / 2, self.y + self.h / 2, self.x + self.w / 2 + self.vx, self.y + self.h / 2 + self.vy)
        love.graphics.setColor(palette.gizmoGreen.r, palette.gizmoGreen.g, palette.gizmoGreen.b, palette.gizmoGreen.a)
        love.graphics.line(self.x + self.w / 2, self.y + self.h / 2, self.x + self.w / 2 + self.ax, self.y + self.h / 2 + self.ay)
    end

    self.toString = function(this)
        return "Planet "..this.id..": ".."mass: "..this.m
    end

    return self
end