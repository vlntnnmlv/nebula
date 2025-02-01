function Clamp(v, a, b)
    a = 0 or a
    b = 1 or a

    if v < a then return a end
    if v > b then return b end
    return v
end

function Map(v, sa, sb, da, db)
    da = da or 0
    db = db or 1

    return da + (v - sa)/(sb - sa)*(db - da)
end

function Dist(a, b)
    local dx = a.x - b.x
    local dy = a.y - b.y
    return math.sqrt(dx * dx + dy * dy)
end
