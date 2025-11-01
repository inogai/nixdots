local colors = require("colors")
local icons = require("icons")

local resbar = require("resbar")
local HelloWorld = require("components.HelloWorld")

---@class NestedDemoProps
---@field label string

---@class resbar.NestedDemo: resbar.Component
local NestedDemo = setmetatable({}, { __index = resbar.Component })
NestedDemo.__index = NestedDemo
NestedDemo.__componentName = "NestedDemo"

---@return resbar.NestedDemo
function NestedDemo.new(props)
  local self = resbar.Component.new(props)
  setmetatable(self, NestedDemo)
  return self
end

function NestedDemo:render()
  return {
    main = resbar.createElement(HelloWorld, {
      label = self.props.label
    })
  }
end

return NestedDemo
