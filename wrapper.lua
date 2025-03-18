-- GMod-compliant wrapper over the pure Lua prometheus library.
local ROOT_PATH = "starfall/thirdparty/prometheus/src/"
AddCSLuaFile()

local function gmodRequire(path)
    path = path:gsub("%.", "/") .. ".lua"

    local absolutePathExists = file.Exists(ROOT_PATH .. path, "LUA")
    if absolutePathExists then
        if SERVER then AddCSLuaFile(ROOT_PATH .. path) end
        return include(ROOT_PATH .. path)
    end

    local info = debug.getinfo(2, "S")
    local callerPath = info.short_src:gsub(ROOT_PATH, "")
    -- try relative resolution
    local callerPathSplit = callerPath:Split("/")
    table.remove(callerPathSplit, #callerPathSplit)
    local callerDir = table.concat(callerPathSplit, "/")

    local relativePath = callerDir .. "/" .. path
    local relativePathExists = file.Exists(ROOT_PATH .. relativePath, "LUA")

    if relativePathExists then
        if SERVER then AddCSLuaFile(ROOT_PATH .. relativePath) end
        return include(ROOT_PATH .. relativePath)
    end

    error("Cannot find module " .. path)
end

local oldRequire = require
_G.require = gmodRequire

AddCSLuaFile("src/prometheus.lua")
local prometheus = include("src/prometheus.lua")

_G.require = oldRequire

return prometheus