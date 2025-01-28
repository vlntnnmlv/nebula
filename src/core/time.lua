Time =
{
    time = 0,
    dt = 0,
    loveDt = 0,
}

function Time.init()
    Time.time = love.timer.getTime()
end

function Time.update(loveDt)
    local oldTime = Time.time;
    Time.time = love.timer.getTime()
    Time.dt = Time.time - oldTime

    Time.loveDt = loveDt
end