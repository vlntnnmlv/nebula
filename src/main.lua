dofile("src/node.lua")

function love.load()
    Node.new(0, 0, 1080, 720, { r = 1.0, g = 1.0, b = 1.0, a = 1.0})

    Node.new(456, 44, 400, 300, nil)
    Node.new(300, 60, 300, 260, nil)
end

function love.draw()
    Node.drawAll()
end

function love.update(dt)
end

function love.mousepressed(x, y, button)
end