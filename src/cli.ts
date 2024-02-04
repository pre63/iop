import Init from './cli/init'
import Add from './cli/add'
import Make from './cli/make'
import Watch from './cli/watch'
import Dev from './cli/dev'
import Help from './cli/help'

export default {
  add: Add.run,
  dev: Dev.run,
  gen: Make.gen,
  watch: Watch.run,
  help: Help.run,
  init: Init.run,
  make: Make.make,
}