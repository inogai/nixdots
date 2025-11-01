local colors = require("colors")
local resbar = require("resbar")
local settings = require("settings")

---@class SpaceCustomProps
---@field display integer
---@field space string
---@field active boolean
---@field iconLine string

---@class SpaceCustom: resbar.Component
---@field props SpaceCustomProps
local SpaceCustom = setmetatable({}, { __index = resbar.Component })
SpaceCustom.__index = SpaceCustom
SpaceCustom.__componentName = "SpaceCustom"

---@return SpaceCustom
function SpaceCustom.new(props)
  local self = resbar.Component.new(props)
  setmetatable(self, SpaceCustom)
  return self
end

---@return pl.OrderedMap
function SpaceCustom:render()
  local props = self.props
  local active = props.active
  return {
    main = resbar.createElement("space", {
      display = props.display,
      space = props.space,
      icon = {
        font = { family = settings.font.numbers },
        string = props.space,
        padding_left = 15,
        padding_right = 8,
        color = active and colors.red or colors.white,
        highlight_color = active and colors.red or colors.white,
      },
      label = {
        padding_right = 20,
        color = active and colors.white or colors.grey,
        highlight_color = active and colors.red or colors.white,
        font = "sketchybar-app-font:Regular:16.0",
        string = props.iconLine,
        y_offset = -1,
      },
      padding_right = 1,
      padding_left = 1,
      background = {
        color = colors.bg1,
        border_width = 1,
        height = 26,
        border_color = active and colors.space_bracket.border_active or colors.space_bracket.border_inactive,
      },
      click_script = "aerospace workspace " .. tostring(props.space),
    }),
  }
end

return SpaceCustom
