dofile("src/core/node/node.lua")

Planet = {}

Planet.new = function(scene, parent, x, y, r)
    local self = Node.new(scene, parent, x - r / 2, y - r / 2, r * 2, r * 2)
    self.setShader("shine")
    self.setColor(RandomColor())
    self.shader.setParameter("iTime", function() return self.time end)

    self.ignoreEvents = true

    -- actual center of the planet
    self.cx = x
    self.cy = y

    self.vx = 0
    self.vy = 0
    self.ax = 0
    self.ay = 0
    self.time = 0

    self.setRadius = function(newR)
        self.r = newR
        self.m = math.pow(self.r, 3)
        self.x = self.cx - self.r / 2
        self.y = self.cy - self.r / 2
        self.setSize(self.r, self.r)
    end

    self.setRadius(r)

    local updateInternalBase = self.updateInternal
    self.updateInternal = function(dt)
        self.vx = self.vx + self.ax * dt
        self.vy = self.vy + self.ay * dt
        self.cx = self.cx + self.vx * dt
        self.cy = self.cy + self.vy * dt

        -- rect coordinates for rendering
        self.x = self.cx - self.r / 2
        self.y = self.cy - self.r / 2

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
        return "P["..this.id..": ".."mass: "..this.m.."]"
    end

    return self
end