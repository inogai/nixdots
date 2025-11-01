---@class sketchybar.Item
---@field name string
---@field set function
---@field remove function

---@class resbar.Component
---@field props table
---@field state table
---@field _binding table[]
local Component = {}
Component.__componentName = "Unnamed"

---@param props table
---@return resbar.Component
function Component.new(props)
  local self = setmetatable({}, Component)
  self.props = props or {}
  self._binding = {}
  self.state = {}
  return self
end

---@alias resbar.RenderResult table<string, resbar.Element>

---@return resbar.RenderResult
function Component:render() error("子类必须实现render方法") end

---@param newValue table
---@return resbar.Component
function Component:setProps(newValue)
  self.props = newValue
  return self
end

function Component:onMounted() end

---@param children? string[]
function Component:schedule_rerender(children) error("`trigger_rerender` should be implemented `by resbar/init.lua`") end

return Component
