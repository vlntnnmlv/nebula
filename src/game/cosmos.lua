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
    self.planets = nil

    self.spawnPlanet = function(x,y,m)
        local planet = Planet.new(scene, self, x, y, m)
        if self.planets == nil then
            self.planets = List.append(self.planets, planet)
        else
            List.append(self.planets, planet)
        end

        List.dump(self.planets)
    end

    local baseDrawGizmo = self.drawGizmo
    self.drawGizmo = function()
        baseDrawGizmo()

        local cur = self.planets
        while cur ~= nil do
            love.graphics.setColor(palette.gizmoBlue.r, palette.gizmoBlue.g, palette.gizmoBlue.b, palette.gizmoBlue.a)
            love.graphics.line(cur.value.cx, cur.value.cy, self.star.cx, self.star.cy)
            cur = cur.next
        end
    end

    self.updateInternal = function(dt)
        -- add new meteors

        -- update physics
        local cur1 = self.planets
        while cur1 ~= nil do
            local p1 = cur1.value
            local ax, ay = 0, 0
            local fx, fy = 0, 0

            local p2 = self.star
            fx, fy = getForce(p1, p2)

            if fx == 0 and fy == 0 then
                cur1.value.remove()
                cur1.value = nil
                -- cur1.value.color = palette.gizmoRed

                local toRemove = cur1
                cur1 = cur1.next

                if List.len(self.planets) == 1 then
                    self.planets = nil
                end
                List.remove(toRemove)
                List.dump(self.planets)
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