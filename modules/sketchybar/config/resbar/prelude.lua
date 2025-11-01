local resbar = require("resbar")

---@param props resbar.Element[]
---@return resbar.Element[]
function Luax(props) return props end

---@param props resbar.ItemProps
---@return resbar.Element
function Item(props) return resbar.createElement("item", props) end

---@param props resbar.SpaceProps
---@return resbar.Element
function Space(props) return resbar.createElement("space", props) end
