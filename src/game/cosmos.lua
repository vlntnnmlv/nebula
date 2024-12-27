dofile("src/game/planet.lua")

local function dist2(x1, y1, x2, y2)
    return x1 * y1 + x2 * y2
end

local function getForce(p1, p2)
    local distSq = dist2(p1.x, p1.y, p2.x, p2.y)
    local ax, ay = 0, 0

    if distSq > (p1.m + p2.m) * (p1.m + p2.m) then
        local f = p1.m * p2.m / distSq

        local dx, dy = p2.x - p1.x, p2.y - p1.y
        local a = math.atan2(dy, dx)

        ax = f * math.cos(a)
        ay = f * math.sin(a)
    end

    return ax, ay
end

Cosmos = {}

Cosmos.new = function(scene, parent, w, h)
    local self = Node.new(scene, parent, 0, 0, w, h, Color(0,0,0,0), false)

    self.star = Planet.new(scene, self, w / 2, h / 2, 128)
    self.planets = {}

    for i = 1,20 do
        local x = love.math.random() * w
        local y = love.math.random() * h
        local m = love.math.random() * 28 + 4
        self.planets[i] = Planet.new(scene, self, x, y, m)
    end

    self.updateInternal = function(dt)
        for i = 1,20 do
            local p1 = self.planets[i]
            local ax, ay = 0, 0
            local fx, fy = 0, 0
            for j = i,20 do
                local p2 = self.planets[j]
                fx, fy = getForce(p1, p2)
                ax = ax + fx
                ay = ay + fy
            end

            local p2 = self.star
            fx, fy = getForce(p1, p2)
            ax = ax + fx
            ay = ay + fy

            p1.ax = ax
            p1.ay = ay
        end
    end

    return self
end