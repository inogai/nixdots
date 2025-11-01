local colors = require("colors")
local icons = require("icons")

local resbar = require("resbar")

---@class HelloWorldProps
---@field label string

---@class resbar.HelloWorld: resbar.Component
---@field props HelloWorldProps
local HelloWorld = setmetatable({}, { __index = resbar.Component })
HelloWorld.__index = HelloWorld
HelloWorld.__componentName = "HelloWorld"

function HelloWorld.new(props)
  local self = resbar.Component.new(props)
  setmetatable(self, HelloWorld)
  return self
end

function HelloWorld:render()
  local count, setCount = resbar.useState(0)

  Sbar.exec(
    "sleep 1 && echo TEST",
    function(result, exit_code)
      setCount(count + 1)
    end
  )

  return {
    main = resbar.createElement("item", {
      label = self.props.label .. tostring(count),
    })
  }
end

return HelloWorld
