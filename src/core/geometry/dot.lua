Dot = CreateClass(Node)

function Dot:init(scene, root, v)
    Node.init(self, scene, root, v.x, v.y, 16, 16)
    self.pivot = Vector2.create(0.5, 0.5)
    self.v = v

    local segments = 40
    local vertices = {}
    table.insert(vertices, { 0, 0 })
    for i = 0, segments do
		local angle = (i / segments) * math.pi * 2

		local sx = math.cos(angle)
		local sy = math.sin(angle)

		table.insert(vertices, { sx, sy })
	end

    self.mesh = love.graphics.newMesh(vertices, "fan")
end

function Dot:drawInternal()
    love.graphics.draw(self.mesh, self.w / 2, self.h / 2, 0, self.w / 2, self.h / 2)
end