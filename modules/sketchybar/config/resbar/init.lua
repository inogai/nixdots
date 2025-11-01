local List = require "pl.List"
local OrderedMap = require "pl.OrderedMap"
local stringx = require "pl.stringx"
local tablex = require "pl.tablex"

-- resbar is Reactive Sbar

---@class resbar.ItemElement
---@field type "item"
---@field props resbar.ItemProps

---@class resbar.SpaceElement
---@field type "space"
---@field props resbar.SpaceProps

---@class resbar.PrimalElement
---@field type string
---@field props table

---@alias resbar.CompositeElement { type: resbar.Component, props: table }

---@alias resbar.Element
---| resbar.PrimalElement
---| resbar.CompositeElement

local M = {}

---@overload fun(type: "item", props: resbar.ItemProps): resbar.ItemElement
---@overload fun(type: "space", props: resbar.SpaceProps): resbar.SpaceElement
---@overload fun(type: resbar.Component, props: table): resbar.CompositeElement
function M.createElement(type, props)
  ---@type resbar.Element

  return {
    type = type,
    props = props or {},
  }
end

M.Component = require("resbar.Component")
M._isRendering = 0
M._scheduledRerenders = OrderedMap {}

---@param children? string[]
function M.Component:schedule_rerender(children)
  -- asynchronous rerender to avoid blocking the main thread
  Sbar.exec("echo test", function()
    if M._isRendering == 0 then
      print("[schedule_rerender] immediate rendering")
      M.render(self, children)
    else
      print("[schedule_rerender] defer rendering")
      M._scheduledRerenders:set(self, children)
    end
  end)
end

---@param instance resbar.Component
---@param children? string[]
function M.render(instance, children)
  print("[render]", instance.__componentName, inspect(instance.props))
  M._isRendering = M._isRendering + 1
  local elements = instance:render()

  if type(children) == "string" then
    children = { children }
  end

  for key, value in OrderedMap(elements):iter() do
    if children ~= nil and not tablex.find(children, key) then
      goto continue
    end

    if type(value.type) == "string" then
      ---@cast value resbar.PrimalElement
      if instance._binding[key] == nil then
        instance._binding[key] = Sbar.add(value.type, value.props)
      else
        instance._binding[key]:set(value.props)
      end
    else
      ---@cast value resbar.CompositeElement
      if instance._binding[key] == nil then
        instance._binding[key] = M.mount(value.type, value.props)
      else
        local childInstance = instance._binding[key]
        childInstance:setProps(value.props)
        M.render(childInstance)
      end
    end
    ::continue::
  end
  M._isRendering = M._isRendering - 1
  if M._isRendering == 0 then
    for inst, children in M._scheduledRerenders:iter() do
      print("[scheduled rerender]", inst, children)
      M.render(inst, children)
    end
  end
end

---@param component resbar.Component
---@param props table
---@return resbar.Component
function M.mount(component, props)
  props = props or {}
  local instance = component.new(props)
  M.render(instance)
  instance:onMounted()
  return instance
end

return M
