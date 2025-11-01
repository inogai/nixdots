local OrderedMap = require("pl.OrderedMap")

local colors = require("colors")
local icons = require("icons")
local resbar = require("resbar")

---@class resbar.Apple: resbar.Component
local Apple = setmetatable({}, { __index = resbar.Component })
Apple.__index = Apple
Apple.__componentName = "Apple"


function Apple.new(props)
  ---@type resbar.Apple
  local self = resbar.Component.new(props)
  setmetatable(self, Apple)
  return self
end

function Apple:render()
  ---@type resbar.RenderResult
  return {
    main = resbar.createElement("item", {
      icon = {
        font = { size = 16.0 },
        string = icons.apple,
        padding_right = 8,
        padding_left = 8,
      },
      label = { drawing = false },
      background = {
        color = colors.bg2,
        border_color = colors.grey,
        border_width = 1,
      },
      padding_left = 1,
      padding_right = 1,
      click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s 0",
    })
  }
end

return Apple
