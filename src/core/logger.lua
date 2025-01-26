Logger = CreateClass()

love.filesystem.setIdentity("nebula")

Logger.save = false
Logger.verbose = false
Logger.file = nil
Logger.filename = nil

local colors = {
    ERROR = 31,
    WARNING = 33,
    SUCCESS = 32,
    NORMAL = 37
}

local effects = {
    NORMAL = 0,
    BOLD = 1,
    UNDERLINE = 4
}

function FORMAT(message, color, effect)
    if color == nil and effect == nil then return message end

    if color == nil then color = colors.NORMAL end
    if effect == nil then effect = effects.NORMAL end

    return "\27["..effect..";"..color.."m"..message.."\27[0m"
end

local function log(prefix, message, color, effect)
    local timestamp = "["..os.date("%H:%M:%S", os.time()).."]"

    if Logger.verbose then
        print(timestamp.. " "..FORMAT(prefix, color, effect).." "..message)
    end

    if Logger.save then
        if Logger.file == nil then
            Logger.filename = os.date("%m-%d-%Y_%H%-M-%S", os.time())..".log"
            Logger.file = love.filesystem.newFile(Logger.filename)
            local ok, err = Logger.file:open("w")
            if not ok then
                print(timestamp.." "..FORMAT("[ERROR]", colors.ERROR, effects.NORMAL).." "..err)
                return
            end
        end

        love.filesystem.append(Logger.filename, timestamp.." "..prefix.." "..message.."\n")
    end
end

function Logger.error(message)
    log("[ERROR]", message, colors.ERROR, effects.NORMAL)
end

function Logger.warning(message)
    log("[WARNING]", message, colors.WARNING, effects.NORMAL)
end

function Logger.success(message)
    log("[SUCCESS]", message, colors.SUCCESS, effects.NORMAL)
end

function Logger.notice(message)
    log("[NOTICE]", message, colors.NORMAL, effects.NORMAL)
end

function Logger.dispose()
    if Logger.file ~= nil then Logger.file:close() end
end