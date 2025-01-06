ArgsActions = {
    ["-scene"] = function(sceneID) Scene.switchScene(sceneID) end,
    ["-gizmo"] = function(gizmo) Scene.drawGizmos = gizmo == "1" end
}

function HandleArgs(args)
    local currentCommand = nil
    local currentValue = nil

    local i = 1
    while args[i] ~= nil do
        currentCommand = args[i]
        currentValue = args[i + 1]
        if currentValue == nil then
            print("Bad command line arguments!")
        end

        if ArgsActions[currentCommand] == nil then
            print("No such option is available: "..currentCommand)
        else
            ArgsActions[currentCommand](currentValue)
        end

        i = i + 2
    end
end