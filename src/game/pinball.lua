Pinball = CreateClass(Node)

function Pinball.create(scene, root, ballX, ballY, x, y, w, h)
    local pinball = Pinball:new()

    pinball:init(scene, root, ballX, ballY, x, y, w, h)

    return pinball
end

function Pinball:init(scene, root, ballX, ballY, x, y, w, h)
    Node.init(self, scene, root, x, y, w, h)
    self:setColor(Color(1.0, 1.0, 1.0, 1.0))

    self.ballSize = 64
    self.ball = Image.create(
        scene,
        self,
        ballX - self.ballSize / 2,
        ballY - self.ballSize / 2,
        self.ballSize,
        self.ballSize,
        "pinball.png"
    )

    self.pointer = Image.create(
        scene,
        self,
        55,
        55,
        32,
        32,
        "pointer.png"
    )
    self.pointer.ignoreEvents = true
    self.pointer.active = false

    self.vx = 0 --love.math.random() * 1000
    self.vy = 0 --love.math.random() * 1000

    self.pointsTable = {}
end

function Pinball:action(pressed)
    local mx, my = love.mouse.getPosition()
    if pressed then
        self.pointer.active = true
        self.vx = 0
        self.vy = 0
        self.ball.x = mx - self.ballSize / 2
        self.ball.y = my - self.ballSize / 2
    end

    if not pressed then
        self.pointer.active = false
        self.vx = 4 * (self.ball.x - self.pointer.x)
        self.vy = 4 * (self.ball.y - self.pointer.y)
    end
end

function Pinball:spawnPoints(n)
    local text = Text.create(self.scene, self, n.."", self.ball.x + self.ballSize / 2, self.ball.y + self.ballSize / 2, 16)
    text:setColor(Palette.brightest)
    self.pointsTable[text] = { timeout = 1, start = Time.time }
end

function Pinball:updateInternal()
    for text, time in pairs(self.pointsTable) do
        if Time.time - time.start > time.timeout then
            self.pointsTable[text] = nil
            text:remove()
        else
            text:setAlpha(Map(Time.time - time.start, 0, time.timeout, 1, 0))
        end
    end

    self.ball:rotate(Time.dt * 5)

    local mx, my = love.mouse.getPosition()

    self.pointer.x = mx - 16
    self.pointer.y = my - 16

    -- TODO: Fix rotation here
    -- TODO: Add easier logic tp rotate
    local dx, dy = self.pointer.x - self.ball.x, self.pointer.y - self.ball.y
    local a = math.atan(dy/dx - 3.14 / 4)
    self.pointer.rotation = a

    if self.vx ~= 0 and self.vy ~= 0 then
        dx, dy = 0, 0
        dx = self.vx * Time.dt
        dy = self.vy * Time.dt

        if self.ball.x + dx + self.ballSize > self.w then
            self:spawnPoints(100)
            dx = self.ball.x + dx + self.ballSize - self.w
            self.vx = -self.vx
        end

        if self.ball.x + dx < 0 then
            self:spawnPoints(100)
            dx = -(self.ball.x + dx)
            self.vx = -self.vx
        end

        if self.ball.y + dy + self.ballSize > self.h then
            self:spawnPoints(100)
            dy = self.ball.y + dy + self.ballSize - self.h
            self.vy = -self.vy
        end

        if self.ball.y + dy < 0 then
            self:spawnPoints(100)
            dy = -(self.ball.y + dy)
            self.vy = -self.vy
        end

        self.ball.x = self.ball.x + dx
        self.ball.y = self.ball.y + dy
    end
end