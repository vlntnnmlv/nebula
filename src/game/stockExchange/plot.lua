Plot = CreateClass(Node)

local function generateMockData()
    local data = {}
    for _ = 1, 20 do
        table.insert(data, love.math.randomNormal(0.5, 0.5))
    end
    return data
end

function Plot:init(scene, root, x, y, w, h)
    Node.init(self, scene, root, x, y, w, h)

    self.data = generateMockData()
    self.segments = List.create()

    local wStep = self.w / (#self.data - 1)
    for i = 1, #self.data - 1 do

        local segment = Image.create(
            scene,
            self,
            (i - 1) * wStep + 2, self.h * (1 - self.data[i]),
            wStep - 2, self.h * self.data[i],
            "white.png"
        )
        self.segments:append(segment)
    end
end