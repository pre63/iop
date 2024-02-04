import pkg from '../../package.json'

export default {
  run: () => helpText.trimLeft()
}

const bold = (str: string) => '\x1b[1m' + str + '\x1b[0m'
const cyan = (str: string) => '\x1b[36m' + str + '\x1b[0m'
const yellow = (str: string) => '\x1b[33m' + str + '\x1b[0m'

const helpText = `
${bold(`iop`)} – version ${yellow(pkg.version)}

Commands:
${bold(`iop ${cyan(`init`)}`)} . . . . . . . . .  create a init project
${bold(`iop ${cyan(`add`)}`)} <url>  . . . . . . . . create a init page
${bold(`iop ${cyan(`make`)}`)} . . . . . . . . one-time production make
${bold(`iop ${cyan(`server`)}`)}  . . . . . . . start a live dev server

Other commands:
${bold(`iop ${cyan(`gen`)}`)} . . . . . generates code without elm make
${bold(`iop ${cyan(`watch`)}`)}  . . . . . . . runs iop gen as you code
`