dofile("src/node.lua")

function love.load()
    mainFont = love.graphics.newFont("./../alagard.ttf", 32)
    love.graphics.setFont(mainFont)

    root = Node.new(nil, 0, 0, 1080, 720, Color(0.36, 0.35, 0.25, 1.0)) -- ebony

    fps = Node.text(root, 0, 15, 15, 32, Color(1.0, 0.0, 0.0, 1.0))

    cursor = Node.new(root, 0, 0, 4, 4, Color(1.0, 0.0, 0.0, 1.0))

    play = Node.text(root, "Play", 1080 / 2, 720 / 2, 64, Color(0.97, 0.62, 0.47, 1.0)) -- atomic tangerine
end

function love.draw()
    Node.drawAll()
end

function love.update(dt)
    fps.text = love.timer.getFPS()

    cursor.x = love.mouse.getX() - 2
    cursor.y = love.mouse.getY() - 2

    Node.updateAll(dt)
end

function love.mousepressed(x, y, button)
end