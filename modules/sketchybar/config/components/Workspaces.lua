local List = require("pl.List")
local Map = require("pl.Map")
local OrderedMap = require("pl.OrderedMap")
local array2d = require("pl.array2d")
local stringx = require("pl.stringx")
local tablex = require("pl.tablex")

local app_icons = require("helpers.app_icons")
local colors = require("colors")
local execSync = require("helpers.execSync")
local resbar = require("resbar")
local settings = require("settings")

local useState = require("resbar").useState
local SpaceCustom = require("components.SpaceCustom")

---@alias Display integer
---@alias Workspace string

---@class WorkspaceInfo
---@field name string
---@field display Display
---@field iconLine string

---@class components.WorkspacesState
---@field displays pl.List<Display>
---@field workspaces pl.OrderedMap<Workspace, WorkspaceInfo[]>
---@field activeSpace Workspace

---@class components.Workspaces: resbar.Component
---@field state components.WorkspacesState
local Workspaces = setmetatable({}, { __index = resbar.Component })
Workspaces.__index = Workspaces
Workspaces.__componentName = "Workspaces"

---@return components.Workspaces
function Workspaces.new(props)
  local self = resbar.Component.new(props)
  setmetatable(self, Workspaces)
  ---@type components.WorkspacesState
  self.state = {
    displays = List {},
    workspaces = OrderedMap {},
    activeSpace = "1",
  }

  execSync([[aerospace list-monitors | cut -d '|' -f1]], function(output)
    local displays = stringx.split(output, "\n"):slice(0, -2):map(tonumber)
    self.state.displays = displays:sort()

    for _, d in ipairs(displays) do
      execSync([[aerospace list-workspaces --monitor ]] .. d, function(output)
        local workspaces = stringx.split(output, "\n"):slice(0, -2)

        for _, w in ipairs(workspaces) do
          self.state.workspaces:set(w, {
            name = w,
            display = d,
            active = false,
            apps = " -",
          })
        end

        self:schedule_rerender()
      end)
    end
  end)

  return self
end

---@return pl.OrderedMap
function Workspaces:render()
  local components = OrderedMap {}

  for s, space in self.state.workspaces:iter() do
    local c = resbar.createElement(SpaceCustom, {
      display = space.display,
      space = s,
      active = self.state.activeSpace == s,
      iconLine = self.state.workspaces:get(s).iconLine or " -",
    })
    components:set(s, c)
  end

  return components
end

function Workspaces:onMounted()
  local watcher = Sbar.add("item", {
    width = 0,
  })

  watcher:subscribe("aerospace_workspace_change", function(env)
    if env["AEROSPACE_FOCUSED_WORKSPACE"] == nil then
      return
    end
    local oldActive = self.state.activeSpace
    self.state.activeSpace = env["AEROSPACE_FOCUSED_WORKSPACE"]
    self:schedule_rerender(oldActive)
    self:schedule_rerender(self.state.activeSpace)
    -- handle potential window changes as well
    self:updateIconLine(oldActive)
    self:updateIconLine(self.state.activeSpace)
  end)

  watcher:subscribe("space_windows_change", function(env)
    for s, _ in self.state.workspaces:iter() do
      self:updateIconLine(s)
    end
  end)
end

---@param space Workspace
function Workspaces:updateIconLine(space)
  sbar.exec(
    [[aerospace list-windows --workspace ]] .. space .. [[ --json | jq -Mcr 'map(.["app-name"]) | join("\n")']],
    function(output)
      local apps = stringx.split(output, "\n"):slice(0, -2)
      local iconLine = ""

      for app, _ in apps:iter() do
        local lookup = app_icons[app]
        local icon = ((lookup == nil) and app_icons["Default"] or lookup)
        iconLine = iconLine .. icon
      end

      if iconLine == "" then
        iconLine = " -"
      end

      self.state.workspaces:get(space).iconLine = iconLine
      self:schedule_rerender({ space })
    end
  )
end

return Workspaces
