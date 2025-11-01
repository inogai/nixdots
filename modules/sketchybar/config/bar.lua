local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 32,
  color = colors.bar.bg,
  padding_right = 2,
  padding_left = 2,
})

require("default")
local resbar = require("resbar")
require("resbar.prelude")

local Apple = require("components.Apple")
local Workspaces = require("components.Workspaces")

resbar.mount(Apple, {})
resbar.mount(Workspaces, {})
