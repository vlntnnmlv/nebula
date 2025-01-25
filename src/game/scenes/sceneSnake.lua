local scene = Scene.new("Snake")

local gridStep = SCREEN_WIDTH / 20;

local root = Node.new(scene, nil, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
local snakeLayer = Node.new(scene, root, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
local snakeX = 0
local snakeY = 0
local snake = Node.new(scene, snakeLayer, snakeX, snakeY, gridStep, gridStep)
snake.setColor(Color(0.1, 0.6, 0.2, 1.0))
snake.points = 0

local foodX
local foodY

local resetFood = function(food)
    foodX = math.floor((love.math.random() * SCREEN_WIDTH) / gridStep)
    foodY = math.floor((love.math.random() * SCREEN_HEIGHT) / gridStep)
    food.x = foodX * gridStep
    food.y = foodY * gridStep
end

local food = Node.new(scene, root, 0, 0, gridStep, gridStep)
food.setColor(Color(0.6, 0.1, 0.2, 1.0))

resetFood(food)

local updatePeriod = 1/10
local lastUpdate = 0

snake.updateInternal = function(dt)
    if love.timer.getTime() - lastUpdate < updatePeriod then return end

    lastUpdate = love.timer.getTime()

    if Keys.held["w"] then
        snakeY = snakeY - 1
    elseif Keys.held["a"] then
        snakeX = snakeX - 1
    elseif Keys.held["s"] then
        snakeY = snakeY + 1
    elseif Keys.held["d"] then
        snakeX = snakeX + 1
    end

    snake.x = snakeX * gridStep
    snake.y = snakeY * gridStep

    if snakeX == foodX and snakeY == foodY then
        snake.points = snake.points + 1
        resetFood(food)
    end
end