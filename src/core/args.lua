local __argsResults = {
    scene = nil,
    drawGizmos = false,
    loggerVerbose = false,
    loggerSave = false
}

local __argsActions = {
    ["--scene"] = function(sceneID) __argsResults.scene = sceneID end,
    ["--gizmo"] = function(gizmo) __argsResults.drawGizmos = gizmo == "1" end,
    ["-v"] = function() __argsResults.loggerVerbose = true end,
    ["-s"] = function() __argsResults.loggerSave = true end
}

function HandleArgs(args)
    local currentCommand = nil
    local currentValue = nil

    local i = 1
    while args[i] ~= nil do
        currentCommand = args[i]
        currentValue = args[i + 1]

        if currentValue == nil then
            Logger.error("You managed to somehow corrupt command line arguments after they are cheked on 'nil'!")
        end

        local withArgument = string.sub(currentCommand, 0, 2) == "--"

        if __argsActions[currentCommand] == nil then
            Logger.error("No such option is available: "..currentCommand)
        else
            if withArgument then
                __argsActions[currentCommand](currentValue)
            else
                __argsActions[currentCommand]()
            end
        end

        if withArgument then
            i = i + 2
        else
            i = i + 1
        end
    end
    Logger.success("Command line args handled!")

    ApplyArgsResults(__argsResults)
    Logger.success("Command line args applied!")

    return __argsResults
end

function ApplyArgsResults(argsResults)
    Scene.drawGizmos = argsResults.drawGizmos

    Logger.verbose = argsResults.loggerVerbose
    Logger.save = argsResults.loggerSave
end