dofile("src/game/planet.lua")

local function dist2(x1, y1, x2, y2)
    return (x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)
end

local function getForce(p1, p2)
    local distSq = dist2(p1.cx, p1.cy, p2.cx, p2.cy)
    local distTrue = math.sqrt(distSq)
    local fx, fy = 0, 0

    if distTrue > p2.m / 2 and distTrue < 10000 then
        local f = 1000 * p1.m * p2.m / distSq

        local dx, dy = p2.cx - p1.cx, p2.cy - p1.cy
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
    self.planets = List.new()

    self.addPlanet = function(planet)
        self.planets.append(planet)

        self.planets.dump()
    end

    self.spawnPlanet = function(x,y,m)
        self.planets.append(Planet.new(scene, self, x, y, m))

        self.planets.dump()
    end

    local baseDrawGizmo = self.drawGizmo
    self.drawGizmo = function()
        baseDrawGizmo()

        local cur = self.planets.head
        while cur ~= nil do
            love.graphics.setColor(Palette.gizmoBlue.r, Palette.gizmoBlue.g, Palette.gizmoBlue.b, Palette.gizmoBlue.a)
            love.graphics.line(cur.value.cx, cur.value.cy, self.star.cx, self.star.cy)
            cur = cur.next
        end
    end

    self.updateInternal = function(dt)
        -- add new meteors

        -- update physics
        local cur1 = self.planets.head
        while cur1 ~= nil do
            local p1 = cur1.value
            local ax, ay = 0, 0
            local fx, fy = 0, 0

            local p2 = self.star
            fx, fy = getForce(p1, p2)

            if fx == 0 and fy == 0 then
                cur1.value.remove()
                cur1.value = nil

                local toRemove = cur1
                cur1 = cur1.next

                self.planets.remove(toRemove)
                self.planets.dump()
                goto continue
            end

            local cur2 = cur1.next
            while cur2 ~= nil do
                p2 = cur2.value
                fx, fy = getForce(p1, p2)
                ax = ax + fx
                ay = ay + fy

                cur2 = cur2.next
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