require("core/class")
require("core/list")
require("core/palette")
require("core/shader")

local methods = {
    -- UI tree
    linkChild = function(this, child)
        this.children.append(child)
    end,

    remove = function(this)
        this.parent.children.filter(function(node) return node.id == this.id end, true)
    end,

    getParentID = function(this)
        if this.parent == nil then return nil end

        return this.parent.id
    end,

    -- Events processing
    updateInternal = function(this, dt) end,

    update = function(this, dt)
        if not this.active then return end

        if this.shader ~= nil then this.shader.update() end

        this.updateInternal(dt)

        this.updateState(dt)
    end,

    updateChildren = function(this, dt)
        this.children.apply(function(child) return child.update(dt) end)
    end,

    updateState = function(this, dt)
        if this.ignoreEvents then return false end

        local mouseX, mouseY = love.mouse.getPosition()
        if mouseX <= this.x or mouseX >= this.x + this.w or mouseY <= this.y or mouseY >= this.y + this.h then
            return false
        end

        this.scene.focusElement = this

        this.updateChildren(dt)
    end,

    setKeyAction = function(this, key, action)
        this.keyActions[key] = action
    end,

    updateKeys = function(this)
        for key, action in pairs(this.keyActions) do
            if Keys.held[key] then
                action()
            end
        end
    end,

    setAction = function(this, action)
        this.action = action
    end,

    -- Rendering
    setColor = function(this, color)
        this.color = color

        if this.shader ~= nil then
            this.shader.setParameter("iColor", { color.r, color.g, color.b, color.a })
        end
    end,

    setSize = function(this, newW, newH)
        this.w = newW
        this.h = newH

        local cw, ch = 1, 1
        if this.w > 1 then cw = this.w end
        if this.h > 1 then ch = this.h end

        this.canvas:release()
        this.canvas = love.graphics.newCanvas(cw, ch)
    end,

    setShader = function(this, shader)
        this.shader = Shader.new(shader)
    end,

    setShaderActive = function(this, active)
        if this.shader == nil then return end

        this.shader.setActive(active)
    end,

    draw = function(this)
        if not this.active then return end

        love.graphics.setCanvas(this.canvas)
        love.graphics.clear(1.0, 1.0, 1.0, 1.0)

        love.graphics.setColor(this.color.r, this.color.g, this.color.b, this.color.a)
        this.drawInternal()

        love.graphics.setCanvas()

        love.graphics.setColor(1.0, 1.0, 1.0, 1.0)
        love.graphics.draw(this.canvas, this.x, this.y)

        this.children.apply(function(child) child.draw() end)

        love.graphics.setCanvas()

        if Scene.drawGizmos then
            love.graphics.setCanvas(this.scene.gizmoCanvas)
            this.drawGizmo()
            love.graphics.setCanvas()
        end
    end,

    drawGizmo = function(this)
        love.graphics.setColor(Palette.gizmoRed.r, Palette.gizmoRed.g, Palette.gizmoRed.b, Palette.gizmoRed.a)
        love.graphics.setLineWidth(2)
        love.graphics.polygon(
            "line",
            1 + this.x, 1 + this.y,
            this.x + this.w - 1, 1 + this.y,
            this.x + this.w - 1, this.y + this.h - 1,
            1 + this.x, this.y + this.h - 1
        )

        love.graphics.print(this.id, this.x + this.w - 20, this.y + 4)

        if this.scene.focusElement == this then
            love.graphics.circle("fill", this.x + 9, this.y + 9, 5)
        end

        love.graphics.setColor(this.color.r, this.color.g, this.color.b, this.color.a)
    end,

    drawInternal = function(this)
        love.graphics.polygon(
            "fill",
            0, 0,
            0 + this.w - 1, 0,
            0 + this.w - 1, 0 + this.h - 1,
            0, 0 + this.h - 1
        )
    end
}

local constructor = function(this, scene, parent, x, y, w, h)
    -- UI tree
    this.scene = scene
    this.parent = parent
    this.children = List.new()

    if this.parent ~= nil then
        this.parent.linkChild(this)
    end

    this.scene.registerNode(this)

    -- Events processing
    this.ignoreEvents = false
    this.active = true
    this.keyActions = { }

    -- Rendering
    this.canvas = love.graphics.newCanvas(this.w, this.h, { format = "rgba8" })
    this.shader = Shader.new("image")
    this.setColor(Color(1.0, 1.0, 1.0, 1.0))

    this.w = w
    this.h = h
    this.x = x
    this.y = y
end

Node = AssembleClass(constructor, methods)

Node.text = function(scene, parent, text, cx, cy, fontSize, incept)
    -- TODO: Clean this mess, why we are calculating this two times?
    local font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)

    local w = font:getWidth(text)
    local h = font:getHeight(text)
    local self = Node.new(scene, parent, cx, cy, w, h)

    self.shader = nil

    self.restore = function()
        self.w = self.font:getWidth(self.text)
        self.h = self.font:getBaseline(self.text)
        self.x = self.cx - self.w / 2
        self.y = self.cy - self.h / 2

        if self.incept then
            if self.incepted == nil then
                self.incepted = Node.text(self.scene, self, text, cx + 2, cy + 2, fontSize - 1, false)
            else
                self.incepted.setText(self.text)
            end
        end
    end

    self.text = text
    self.font = font
    self.incept = incept
    self.cx = cx
    self.cy = cy

    self.restore()

    self.setText = function(text)
        self.text = text

        self.restore()
    end

    self.drawInternal = function()
        love.graphics.setFont(self.font)
        love.graphics.print(self.text, 0, 0)
    end

    return self
end

Node.image = function(scene, parent, x, y, w, h, image)
    local self = Node.new(scene, parent, x, y, w, h)
    self.shader = Shader.new("image")

    self.imageData = love.image.newImageData("resources/textures/"..image)
    self.image = love.graphics.newImage(self.imageData)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
    self.rotation = 0
    self.originOffsetX = self.imageData:getWidth() / 2
    self.originOffsetY = self.imageData:getHeight() / 2
    self.shearX = 0
    self.shearY = 0

    local setSizeBase = self.setSize
    self.setSize = function(newW, newH)
        setSizeBase(newW, newH)

        self.scaleX = self.w / self.imageData:getWidth()
        self.scaleY = self.h / self.imageData:getHeight()
    end

    self.drawInternal = function()
        Logger.notice("Draw image")
        love.graphics.draw(self.image, 0 + self.w / 2, 0 + self.h / 2, self.rotation, self.scaleX, self.scaleY, self.originOffsetX, self.originOffsetY, self.shearX, self.shearY)
    end

    self.rotate = function(rotation)
        self.rotation = self.rotation + rotation
    end

    return self
end