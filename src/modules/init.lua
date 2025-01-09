return {
  start = {
    description = 'Start simulation with current device',
    module = require('src.modules.StartModule'),
  },
  resolution = {
    description = 'Change window resolution',
    module = require('src.modules.ResolutionModule'),
  },
  exit = {
    description = 'Shutdown simulation',
    module = require('src.modules.ExitModule'),
  },
}
