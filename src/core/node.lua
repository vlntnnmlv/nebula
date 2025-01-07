dofile("src/core/palette.lua")
dofile("src/core/list.lua")
dofile("src/core/shader.lua")

Node = {}

Node.new = function(scene, parent, x, y, w, h)
    local self = {}

    self.scene = scene
    self.parent = parent
    self.children = List.new()
    self.hovered = false
    self.ignoreEvents = false
    self.color = Color(1, 1, 1, 1)
    self.shader = nil

    if self.parent ~= nil then
        self.parent.linkChild(self)
    end

    self.updateRealSize = function()
        self.rx = x * self.sx
        self.ry = y * self.sy

        self.rw = self.w * self.sx
        self.rh = self.h * self.sy

        self.children.apply(
            function(child)
                child.setScale(self.sx, self.sy)
            end
        )
    end

    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.sx = 1
    self.sy = 1
    self.updateRealSize()

    self.setColor = function(color)
        self.color = color
    end

    self.setScale = function(newsx, newsy)
        self.sx = newsx
        self.sy = newsy
    end

    self.setShader = function(shader)
        self.shader = shader
        self.canvas = love.graphics.newCanvas(self.w, self.h)
    end

    self.linkChild = function(child)
        self.children.append(child)
    end

    self.remove = function()
        self.parent.children.filter(function(node) return node.id == self.id end, true)
    end

    self.getParentID = function()
        if self.parent == nil then return nil end

        return self.parent.id
    end

    self.drawChildren = function()
        self.children.apply(function(child) child.draw() end)
    end

    self.draw = function()
        -- local actualColor = Color(self.color.r, self.color.g, self.color.b, self.color.a)
        -- if self.hovered then
        --     actualColor.r = actualColor.r - 0.1
        --     actualColor.g = actualColor.g - 0.1
        --     actualColor.b = actualColor.b - 0.1
        --     actualColor.a = actualColor.a
        -- end
        self.updateRealSize()

        love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        if self.shader ~= nil then
            self.shader.setActive(true)
        end

        -- if self.canvas ~= nil then
        --     love.graphics.setCanvas(self.canvas)
        --     love.graphics.clear()
        -- elseif self.parent ~= nil and self.parent.canvas ~= nil then
        --     love.graphics.setCanvas(self.parent.canvas)
        -- end

        self.drawInternal()

        if Scene.drawGizmos then
            self.drawGizmo()
            -- reset color after drawing gizmo
            love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        end

        -- local oldCanvas = nil
        -- if self.canvas ~= nil then
        --     oldCanvas = love.graphics.getCanvas()
        --     love.graphics.setCanvas(self.canvas)
        --     love.graphics.clear()
        -- end

        self.drawChildren()

        -- if self.parent ~= nil and self.parent.canvas ~= nil then
        --     love.graphics.setCanvas(self.parent.canvas)
        -- end

        -- if oldCanvas ~= nil then
        --     love.graphics.setCanvas(oldCanvas)
        -- end

        -- if self.canvas ~= nil then
        --     love.graphics.draw(self.canvas, self.x, self.y)
        -- end

        if self.shader ~= nil then
            self.shader.setActive(false)
        end

        -- love.graphics.setCanvas()
    end

    self.drawGizmo = function()
        love.graphics.setColor(Palette.gizmoRed.r, Palette.gizmoRed.g, Palette.gizmoRed.b, Palette.gizmoRed.a)
        love.graphics.polygon(
            "line",
            self.rx, self.ry,
            self.rx + self.rw, self.ry,
            self.rx + self.rw, self.ry + self.rh,
            self.rx, self.ry + self.rh
        )
    end

    self.drawInternal = function()
        -- love.graphics.polygon(
        --     "fill",
        --     self.x, self.y,
        --     self.x + self.w, self.y,
        --     self.x + self.w, self.y + self.h,
        --     self.x, self.y + self.h
        -- )
    end

    self.updateInternal = function(dt) end

    self.update = function(dt)
        if self.shader ~= nil then self.shader.update() end

        self.updateInternal(dt)

        return self.updateState(dt)
    end

    self.updateChildren = function(dt)
        local anyChildHovered = false

        if self.children.applyUntil(
                function(child)  return child.update(dt) end,
                function(result) return result == true end
            ) then
            anyChildHovered = true
        end

        return anyChildHovered
    end

    self.updateState = function(dt)
        local mouseX, mouseY = love.mouse.getPosition()

        local anyChildHovered = self.updateChildren(dt)

        if anyChildHovered then
            self.hovered = false
            return false
        end

        if self.ignoreEvents then return false end

        if mouseX <= self.x or mouseX >= self.x + self.w or mouseY <= self.y or mouseY >= self.y + self.h then
            self.hovered = false
            return false
        end

        self.hovered = true
        self.scene.focusElement = self

        return true
    end

    self.setAction = function(action)
        self.action = action
    end

    self.scene.registerNode(self)

    return self
end

Node.text = function(scene, parent, text, cx, cy, fontSize, incept)
    -- TODO: Clean this mess, why we are calculating this two times?
    local font = love.graphics.newFont("resources/fonts/alagard.ttf", fontSize)

    local w = font:getWidth(text)
    local h = font:getHeight(text)
    local self = Node.new(scene, parent, cx, cy, w, h)

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
        love.graphics.print(self.text, self.x, self.y)
    end

    return self
end

Node.image = function(scene, parent, x, y, w, h, image)
    local self = Node.new(scene, parent, x, y, w, h)

    self.imageData = love.image.newImageData(image)
    self.image = love.graphics.newImage(self.imageData)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
    self.rotation = 0
    self.originOffsetX = self.imageData:getWidth() / 2
    self.originOffsetY = self.imageData:getHeight() / 2
    self.shearX = 0
    self.shearY = 0

    self.setSize = function(newW, newH)
        self.w = newW
        self.h = newH
        self.scaleX = self.w / self.imageData:getWidth()
        self.scaleY = self.h / self.imageData:getHeight()
    end

    self.drawInternal = function()
        love.graphics.draw(self.image, self.x + self.w / 2, self.y + self.h / 2, self.rotation, self.scaleX, self.scaleY, self.originOffsetX, self.originOffsetY, self.shearX, self.shearY)
    end

    -- self.updateInternal = function(dt)
    --     if self.shader ~= nil then self.shader.update() end
    -- end

    self.rotate = function(rotation)
        self.rotation = self.rotation + rotation
    end

    return self
end