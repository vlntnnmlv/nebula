dofile("src/core/node.lua")

Planet = {}

Planet.new = function(scene, parent, x, y, r)
    local self = Node.new(scene, parent, x - r / 2, y - r / 2, r * 2, r * 2)
    self.setShader(Shader.new("resources/shaders/shine.glsl"))
    self.setColor(RandomColor())
    self.ignoreEvents = true

    self.cx = x -- actual center of the planet
    self.cy = y -- actual center of the planet
    self.vx = 0
    self.vy = 0
    self.ax = 0
    self.ay = 0
    self.time = 0

    self.rotationSpeed = love.math.random() * 2

    self.setRadius = function(newR)
        self.r = newR
        self.m = math.pow(self.r, 3)
        self.x = self.cx - self.r / 2
        self.y = self.cy - self.r / 2
        self.setSize(self.r, self.r)
    end

    self.setRadius(r)

    self.shader.setParameter("iTime", function() return self.time end)

    local updateInternalBase = self.updateInternal
    self.updateInternal = function(dt)
        self.vx = self.vx + self.ax * dt
        self.vy = self.vy + self.ay * dt
        self.cx = self.cx + self.vx * dt
        self.cy = self.cy + self.vy * dt

        self.x = self.cx - self.r / 2 -- rect coordinates for rendering
        self.y = self.cy - self.r / 2 -- rect coordinates for rendering

        self.time = self.time + dt

        updateInternalBase()
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