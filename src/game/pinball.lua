Pinball = CreateClass(Node)

function Pinball.create(scene, root, ballX, ballY, x, y, w, h)
    local pinball = Pinball:new()

    pinball:init(scene, root, ballX, ballY, x, y, w, h)

    return pinball
end

function Pinball:init(scene, root, ballX, ballY, x, y, w, h)
    Node.init(self, scene, root, x, y, w, h)
    self:setColor(Color(0.0, 0.0, 0.0, 0.0))

    self.ballSize = 64
    self.ball = Image.create(
        scene,
        root,
        ballX - self.ballSize / 2,
        ballY - self.ballSize / 2,
        self.ballSize,
        self.ballSize,
        "pinball.png"
    )

    self.vx = love.math.random() * 1000
    self.vy = love.math.random() * 1000

    print(self.vx, self.vy)
end

function Pinball:updateInternal()
    self.ball:rotate(Time.dt * 5)

    local dx, dy = 0, 0
    dx = self.vx * Time.dt
    dy = self.vy * Time.dt

    if self.ball.x + dx + self.ballSize > self.w then
        dx = self.ball.x + dx + self.ballSize - self.w
        self.vx = -self.vx
    end

    if self.ball.x + dx < 0 then
        dx = -(self.ball.x + dx)
        self.vx = -self.vx
    end

    if self.ball.y + dy + self.ballSize > self.h then
        dy = self.ball.y + dy + self.ballSize - self.h
        self.vy = -self.vy
    end

    if self.ball.y + dy < 0 then
        dy = -(self.ball.y + dy)
        self.vy = -self.vy
    end

    self.ball.x = self.ball.x + dx
    self.ball.y = self.ball.y + dy
end