GIF = {}

GIF.new = function(scene, parent, x, y, w, h, frames)
    local self = Node.image(scene, parent, x, y, w, h, frames.head.value)

    self.imagesData = List.create()
    self.images = List.create()
    self.fps = 12
    self.frameSwapPeriod = 1 / self.fps
    self.frameSwapedTime = 0

    local cur = frames.head
    while cur ~= nil do
        local imageData = love.image.newImageData(cur.value)
        self.imagesData:append(imageData)
        self.images:append(love.graphics.newImage(imageData))
        cur = cur.next
    end

    self.currentFrame = self.images.head
    self.image = self.images.head.value

    local updateInternalBase = self.updateInternal
    self.updateInternal = function()
        updateInternalBase()

        if Time.time - self.frameSwapedTime < self.frameSwapPeriod then return end

        self.currentFrame = self.currentFrame.next
        if self.currentFrame == nil then self.currentFrame = self.images.head end
        self.image = self.currentFrame.value

        self.frameSwapedTime = Time.time
    end
end