Pinball = CreateClass(Node)

function Pinball:init(scene, root, ballX, ballY, x, y, w, h)
    Node.init(self, scene, root, x, y, w, h)
    self:setColor(Color(1.0, 1.0, 1.0, 1.0))

    self.bg = Node.create(scene, self, self.x, self.y, self.w, self.h)
    self.bg.ignoreEvents = true
    self.bg:setColor(Color(0.0, 0.0, 1.0, 1.0))
    self.bg:setShader("flow")

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
    self.vy = 20 --love.math.random() * 1000

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
        self.vx = 10 * (self.ball.x - self.pointer.x)
        self.vy = 10 * (self.ball.y - self.pointer.y)
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

    local vmag = math.sqrt(self.vx * self.vx + self.vy * self.vy)
    self.ball:rotate(Time.dt * vmag * 0.01)

    local mx, my = love.mouse.getPosition()

    self.pointer.x = mx - 16
    self.pointer.y = my - 16

    -- TODO: Fix rotation here
    -- TODO: Add easier logic tp rotate
    local dx, dy = (self.pointer.x) - (self.ball.x + self.ballSize / 2), (self.pointer.y) - (self.ball.y + self.ballSize / 2)
    local a = math.atan2(dy, dx)
    self.pointer.rotation = a - 3.14 / 4

    local speed = Dist({x = self.vx, y = self.vy}, {x = 0, y = 0}) --TODO: Add vector2 class
    local maxSpeed = Dist({x = SCREEN_WIDTH, y = SCREEN_HEIGHT}, {x = 0, y = 0})

    if self.ball.y < SCREEN_HEIGHT - self.ballSize - 5 then
        self.vy = self.vy + 20
    end
    if self.ball.y >= SCREEN_HEIGHT - self.ballSize - 5 and self.vy > 1 then
        self.ball.y = SCREEN_HEIGHT - self.ballSize
    end
    if math.abs(self.vx) < 1 then self.vx = 0 end
    if math.abs(self.vy) < 1 then self.vy = 0 end
    if math.abs(self.vx) > 1 or math.abs(self.vy) > 1 then
        dx, dy = 0, 0
        dx = self.vx * Time.dt
        dy = self.vy * Time.dt

        if math.abs(dx) < 1 then dx = 0 end
        if math.abs(dy) < 1 then dy = 0 end

        if dx == 0 then
            if self.vx < 0 then self.vx = self.vx + 5 end
            if self.vx > 0 then self.vx = self.vx - 5 end
        end

        if self.ball.x + dx + self.ballSize > self.w then
            Sound.sfx("bop", speed / maxSpeed, 1 + speed / maxSpeed)
            if math.abs(dx) > 10 then self:spawnPoints(100) end
            dx = -(self.ball.x + dx + self.ballSize - self.w)
            self.vx = -self.vx * 0.4
        end

        if self.ball.x + dx < 0 then
            Sound.sfx("bop", speed / maxSpeed, 1 + speed / maxSpeed)
            if math.abs(dx) > 10 then self:spawnPoints(100) end
            dx = -(self.ball.x + dx)
            self.vx = -self.vx * 0.4
        end

        if self.ball.y + dy + self.ballSize > self.h then
            Sound.sfx("bop", speed / maxSpeed, 1 + speed / maxSpeed)
            if math.abs(dy) > 10 then self:spawnPoints(100) end
            dy = -(self.ball.y + dy + self.ballSize - self.h)
            self.vy = -self.vy * 0.6
        end

        if self.ball.y + dy < 0 then
            Sound.sfx("bop", speed / maxSpeed, 1 + speed / maxSpeed)
            if math.abs(dy) > 10 then self:spawnPoints(100) end
            dy = -(self.ball.y + dy)
            self.vy = -self.vy * 0.6
        end

        self.ball.x = self.ball.x + dx
        self.ball.y = self.ball.y + dy
    end
end