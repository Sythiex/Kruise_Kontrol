local Constants = require("constants")

local vehicle_brake_on_cancel =
{
  type = "bool-setting",
  name = Constants.settings.brake_on_cancel,
  setting_type = "runtime-per-user",
  default_value = true,
  order = "a"
}

local allow_handcrafting =
{
  type = "bool-setting",
  name = Constants.settings.allow_handcrafting,
  setting_type = "runtime-per-user",
  default_value = true,
  order = "b"
}

data:extend
{
  vehicle_brake_on_cancel,
  allow_handcrafting
}
