import path from 'path'

const reserved = {
  homepage: 'Home_',
  redirecting: 'Redirecting_',
  notFound: 'NotFound'
}

const root = path.join(__dirname, '..', '..')
const cwd = process.cwd()

const config = {
  reserved,
  folders: {
    init: path.join(root, 'src', 'new'),
    src: path.join(cwd, 'src'),
    pages: {
      src: path.join(cwd, 'src', 'Pages'),
      defaults: path.join(cwd, 'Pages')
    },
    generated: path.join(cwd, 'src', 'Iop'),
    templates: {
      defaults: path.join(root, 'src', 'templates', 'add'),
      user: path.join(cwd, '.iop')
    },
    package: path.join(cwd, '.iop', 'package'),
    public: path.join(cwd, 'public'),
    dist: path.join(cwd, 'public', 'dist'),
  }
}

export default config