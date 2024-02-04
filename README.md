# iop: A Flexible Framework for Building Web Applications with Elm

iop is a sophisticated framework designed to enhance the development of web applications using Elm. It extends the capabilities of the elm-spa framework, focusing on performance, flexibility, and developer experience. With a suite of improvements and an intuitive CLI, iop streamlines the development process, making it easier and faster to build robust, scalable Elm applications.

## Key Improvements

iop advances beyond elm-spa with developer-centric enhancements:

- **Faster Builds**: Streamlines compilation for improved efficiency.
- **Partial Builds**: Incremental compilation targets only modified files, reducing build times.
- **Centralized Source Code**: Consolidates generated code in `src/`, solving language server error issues.
- **Library Independence**: Full customization flexibility; unchanged hash comments (`{- HASH -}`) skip regeneration.
- **Error Reporting**: Improves visibility of Elm compilation errors.
- **ACL Management**: Implements detailed access control, enabling precise permission settings.
- **Page Layouts**: Offers a modular layout system for dynamic UI design.

## Installation

To get started with iop, install it globally via npm:

```bash
npm install -g git+https://github.com/pre63/iop.git
```

## iop CLI

The command-line interface for iop simplifies project management, allowing for easy creation, building, and development of Elm web applications.

### Usage

Explore the iop CLI commands to manage your project efficiently:

```
$ iop help
iop – version 0.0.9

Commands:
  iop new . . . . . . . . .  create a new project
  iop add <url> . . . . . . . . create a new page
  iop build . . . . . . one-time production build
  iop server  . . . . . . start a live dev server

Other commands:
  iop gen . . . . generates code without elm make
  iop watch . . . .  runs iop gen as you code
```

## Contributing

Contributions to iop are welcome. The CLI is developed using TypeScript and Node.js. Follow these steps to set up your development environment:

```bash
git clone git@github.com:pre63/iop  # Clone the repository
npm install                         # Initialize development setup
```

For development and testing:

```bash
npm run build   # For one-time production build
```

### Local CLI Testing

To test the `iop` command with your local build:

```bash
npm run local
```

## Fork and License Information

iop is a fork of elm-spa, inheriting its commitment to providing a powerful foundation for Elm web application development. The original elm-spa is licensed under the BSD-3-Clause license. Contributions made to iop by pre63 and co. are licensed under the MIT License, reflecting a dedication to open-source collaboration and flexibility.

For more information about elm-spa, visit the original website: [elm-spa.dev](https://elm-spa.dev).
