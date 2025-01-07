Keys = {}

Keys.held = {}

Keys.pressed = function(key)
    Keys.held[key] = true
end

Keys.released = function(key)
    Keys.held[key] = false
end