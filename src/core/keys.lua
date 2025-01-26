Keys = CreateClass()

Keys.held = {}

function Keys.pressed(key)
    Keys.held[key] = true
end

function Keys.released(key)
    Keys.held[key] = false
end