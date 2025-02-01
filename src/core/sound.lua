Sound = CreateClass()
Sound.data = {}

function Sound.sfx(name, volume, pitch)
    local sound = nil
    if Sound.data[name] then
        sound = Sound.data[name]
    else
        sound = love.audio.newSource("resources/sounds/"..name..".mp3", "static")
        Sound.data[name] = sound
    end

    volume = volume or 1
    pitch = pitch or 1
    local actualSound = sound:clone()
    actualSound:setVolume(volume)
    actualSound:setPitch(pitch)
    actualSound:play();
end