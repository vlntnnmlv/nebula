dofile("src/game/planet.lua")

local function dist2(x1, y1, x2, y2)
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
end

local function getForce(p1, p2)
    local distSq = dist2(p1.x, p1.y, p2.x, p2.y)
    local fx, fy = 0, 0

    if math.sqrt(distSq) > p2.m then
        local f = 1000 * p1.m * p2.m / distSq

        local dx, dy = p2.x - p1.x, p2.y - p1.y
        local a = math.atan2(dy, dx)

        fx = f * math.cos(a)
        fy = f * math.sin(a)
    end

    return fx, fy
end

Cosmos = {}

Cosmos.new = function(scene, parent, w, h)
    local self = Node.new(scene, parent, 0, 0, w, h, Color(0,0,0,0), false)

    self.star = Planet.new(scene, self, w / 2, h / 2, 128, true)
    self.planets = nil

    self.spawnPlanet = function(x,y,m)
        local planet = Planet.new(scene, self, x, y, m)
        if self.planets == nil then
            self.planets = List.append(self.planets, planet)
        else
            List.append(self.planets, planet)
        end
    end

    for _ = 1,5 do
        local x = love.math.random() * w
        local y = love.math.random() * h
        local m = love.math.random() * 28 + 4
        self.spawnPlanet(x, y, m)
    end

    self.updateInternal = function(dt)
        -- add new meteors

        -- update physics
        local cur1 = self.planets
        while cur1 ~= nil do
            local p1 = cur1.value
            local ax, ay = 0, 0
            local fx, fy = 0, 0

            local cur2 = cur1.next
            while cur2 ~= nil do
                local p2 = cur2.value
                fx, fy = getForce(p1, p2)
                ax = ax + fx
                ay = ay + fy

                cur2 = cur2.next
            end

            local p2 = self.star
            fx, fy = getForce(p1, p2)

            if fx == 0 and fy == 0 then
                -- cur1.value.remove()
                cur1.value.color = palette.gizmoRed
                cur1.value.ax = 0
                cur1.value.ay = 0
                cur1.value.vx = 0
                cur1.value.vy = 0

                local toRemove = cur1
                cur1 = cur1.next
                List.remove(toRemove)

                goto continue
            end

            ax = ax + fx
            ay = ay + fy

            p1.ax = ax
            p1.ay = ay

            cur1 = cur1.next
            ::continue::
        end
    end

    return self
end