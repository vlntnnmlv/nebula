dofile("src/core/node.lua")

Planet = {}

Planet.new = function(scene, parent, x, y, m, isStar)
    local texture = nil
    local shader = nil
    if isStar then
        texture = "star"
        shader = "shine"
    else
        texture = "planet"
        shader = "chrome"
    end

    local self = Node.image(scene, parent, x - m / 2, y - m / 2, m, m, "resources/textures/"..texture..".png", "resources/shaders/"..shader..".glsl", Color(1,1,1,1), true)
    self.isStar = isStar

    self.cx = x -- actual center of the planet
    self.cy = y -- actual center of the planet
    self.vx = 0
    self.vy = 0
    self.ax = 0
    self.ay = 0
    self.time = 0

    -- self.massText = Node.text(self.scene, self, self.m, self.cx, self.cy, 32, Palette.gizmoBlue, true, false)
    self.rotationSpeed = love.math.random() * 2

    self.setMass = function(newM)
        self.m = newM
        self.r = math.pow(self.m, 1/3)
        -- self.massText.text = self.m
        self.x = self.cx - self.r / 2
        self.y = self.cy - self.r / 2
        self.setSize(self.r, self.r)
    end

    self.setMass(m)

    if self.isStar then
        self.shaderParameters.append({ name = "iTime", value = 0})
    end

    local updateInternalBase = self.updateInternal
    self.updateInternal = function(dt)
        self.rotate(self.rotationSpeed * dt)

        self.vx = self.vx + self.ax * dt
        self.vy = self.vy + self.ay * dt
        self.cx = self.cx + self.vx * dt
        self.cy = self.cy + self.vy * dt

        -- self.massText.text = self.m

        self.x = self.cx - self.r / 2 -- rect coordinates for rendering
        self.y = self.cy - self.r / 2 -- rect coordinates for rendering

        self.time = self.time + dt
        if self.isStar then
            self.shaderParameters.head.value.value = self.time
        end

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