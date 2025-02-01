Image = CreateClass(Node)

function Image:init(scene, parent, x, y, w, h, texture)
    Node.init(self, scene, parent, x, y, w, h)

    -- TODO: Add some kind of ImageData registry to now load same textures more than once
    self.imageData = love.image.newImageData("resources/textures/"..texture)
    self.image = love.graphics.newImage(self.imageData)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
    self.rotation = 0
    self.originOffsetX = self.imageData:getWidth() / 2
    self.originOffsetY = self.imageData:getHeight() / 2
    self.shearX = 0
    self.shearY = 0

    self.mirrorX = false
    self.mirrorY = false

    self.shader:setParameter("iMirrorX", function() return self.mirrorX end)
    self.shader:setParameter("iMirrorY", function() return self.mirrorY end)
end

function Image:resize(newW, newH)
    Node.resize(self, newW, newH)

    self.scaleX = self.w / self.imageData:getWidth()
    self.scaleY = self.h / self.imageData:getHeight()
end

function Image:drawInternal()
    love.graphics.draw(self.image, self.w / 2, self.h / 2, self.rotation, self.scaleX, self.scaleY, self.originOffsetX, self.originOffsetY, self.shearX, self.shearY)
end

function Image:rotate(rotation)
    self.rotation = self.rotation + rotation
end