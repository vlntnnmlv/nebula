dofile("src/node.lua")

function love.load()
    root = Node.new(nil, 0, 0, 1080, 720, Color(1.0, 1.0, 1.0, 1.0))
    fps = Node.text(root, 0, 50, 15, 16, Color(0.0, 1.0, 0.0, 1.0))

    n1 = Node.new(root, 456, 44, 400, 300, nil)
    Node.new(root, 300, 60, 300, 260, nil)
    Node.text(n1, "Play", 456, 88, 32, Color(0.0, 0.0, 1.0, 1.0) )
end

function love.draw()
    Node.drawAll()
end

function love.update(dt)
    fps.text = love.timer.getFPS()
end

function love.mousepressed(x, y, button)
end