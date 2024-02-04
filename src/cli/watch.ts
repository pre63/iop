import chokidar from 'chokidar'
import config from '../config'
import { make } from './make'

function debounce<F extends (...args: any[]) => void>(func: F, waitFor: number): (...args: Parameters<F>) => void {
  let timeoutId: ReturnType<typeof setTimeout> | null = null

  return function (...args: Parameters<F>) {
    if (timeoutId !== null) {
      clearTimeout(timeoutId)
    }
    timeoutId = setTimeout(() => func(...args), waitFor)
  }
}

export const watch = (runElmMake: boolean) => {
  const runBuild = make({ env: 'development', runElmMake })

  const debouncedRunBuild = debounce(() => {
    runBuild()
      .then(output => {
        console.info('')
        console.info(output)
        console.info('')
      })
      .catch(reason => {
        console.info('')
        console.error(reason)
        console.info('')
      })
  }, 500)

  chokidar
    .watch(config.folders.src, {
      ignoreInitial: true,
      ignored: [`${config.folders.src}/Iop/Gen`, `${config.folders.src}/Iop/Gen/**/*`]
    })
    .on('all', () => debouncedRunBuild())

  return runBuild()
}

export default {
  run: () => watch(false)
}
