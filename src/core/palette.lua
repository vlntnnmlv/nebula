function Color(r,g,b,a)
    return { r = r, g = g, b = b, a = a}
end

Palette = {
    brightest = Color(0.968, 0.623, 0.474, 1.0),
    bright    = Color(0.968, 0.815, 0.541, 1.0),
    middle    = Color(0.890, 0.941, 0.607, 1.0),
    dark      = Color(0.529, 0.713, 0.654, 1.0),
    darkest   = Color(0.356, 0.249, 0.254, 1.0),

    --
    gizmoRed   = Color(1.0, 0.0, 0.0, 1.0),
    gizmoGreen = Color(0.0, 1.0, 0.0, 1.0),
    gizmoBlue  = Color(0.0, 0.0, 1.0, 1.0)
}