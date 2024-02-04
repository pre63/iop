import pkg from '../../package.json'

export default {
  run: () => helpText.trimLeft()
}

const bold = (str: string) => '\x1b[1m' + str + '\x1b[0m'
const cyan = (str: string) => '\x1b[36m' + str + '\x1b[0m'
const green = (str: string) => '\x1b[32m' + str + '\x1b[0m'
const yellow = (str: string) => '\x1b[33m' + str + '\x1b[0m'

const helpText = `
${bold(`iop`)} – version ${yellow(pkg.version)}

Commands:
${bold(`iop ${cyan(`new`)}`)} . . . . . . . . .  create a new project
${bold(`iop ${cyan(`add`)}`)} <url> . . . . . . . . create a new page
${bold(`iop ${cyan(`build`)}`)} . . . . . . one-time production build
${bold(`iop ${cyan(`server`)}`)}  . . . . . . start a live dev server

Other commands:
${bold(`iop ${cyan(`gen`)}`)} . . . . generates code without elm make
${bold(`iop ${cyan(`watch`)}`)} . . . .  runs iop gen as you code
`