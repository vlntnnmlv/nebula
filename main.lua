dofile("src/node.lua")
dofile("src/palette.lua")

function love.load()
    mainFont = love.graphics.newFont("resources/fonts/alagard.ttf", 32)
    love.graphics.setFont(mainFont)

    root = Node.new(nil, 0, 0, 1080, 720, palette.ebony)
    fps = Node.text(root, 0, 15, 15, 32, palette.red)
    cursor = Node.new(root, 0, 0, 4, 4, palette.red)
    play = Node.text(root, "Play", 1080 / 2, 720 / 2, 64, palette.atomicTangerine)
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