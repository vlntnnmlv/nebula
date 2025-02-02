Line = CreateClass(Node)

function Line:init(scene, root, a, b)
    local x, y = a.x, a.y
    if a:mag() > b:mag() then
        x, y = b.x, b.y
    end

    local w, h = math.abs(a.x - b.x), math.abs(a.y - b.y)

    Node.init(self, scene, root, x, y, w, h)

    -- self.a = a
    -- self.b = b
    -- self.delta = 0.05

    -- local vertices = {}
    -- table.insert(vertices, { self.delta, 0.0 })
    -- table.insert(vertices, { 1.0, 1.0 - self.delta })
    -- table.insert(vertices, { 0.0, self.delta })
    -- table.insert(vertices, { 1.0 - self.delta, 1.0 })

    -- self.mesh = love.graphics.newMesh(vertices, "strip")
end

function Line:drawInternal()
    love.graphics.line(self.mesh, 0, 0, 0, self.w, self.h)
end