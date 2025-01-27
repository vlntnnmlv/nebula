function Clamp(v, a, b)
    a = 0 or a
    b = 1 or a

    if v < a then return a end
    if v > b then return b end
    return v
end
