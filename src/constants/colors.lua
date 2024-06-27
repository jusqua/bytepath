local Moses = require('lib.moses.moses')
local utils = require('src.utils')

local normal = {
  default = utils.createColor(222, 222, 222),
  background = utils.createColor(16, 16, 16),
  ammo = utils.createColor(123, 200, 164),
  boost = utils.createColor(76, 195, 217),
  hp = utils.createColor(241, 103, 69),
  skill_point = utils.createColor(255, 198, 93),
}

local negative = {
  default = utils.createNegativeColor(normal.default),
  background = utils.createNegativeColor(normal.background),
  ammo = utils.createNegativeColor(normal.ammo),
  boost = utils.createNegativeColor(normal.boost),
  hp = utils.createNegativeColor(normal.hp),
  skill_point = utils.createNegativeColor(normal.skill_point),
}

return {
  normal = normal,
  negative = negative,
  all = Moses.append(Moses.values(normal), Moses.values(negative)),
}
