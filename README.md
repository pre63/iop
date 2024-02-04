# iop cli
> the command-line interface for __iop__

## installation

```bash
npm install -g iop@latest
```

## usage

```
$ iop help
```
```
iop – version 6.0.4

Commands:
iop new . . . . . . . . .  create a new project
iop add <url> . . . . . . . . create a new page
iop build . . . . . . one-time production build
iop server  . . . . . . start a live dev server

Other commands:
iop gen . . . . generates code without elm make
iop watch . . . .  runs iop gen as you code

Visit https://elm-spa.dev for more!
```

## learn more

Check out the official guide at https://elm-spa.dev!

# contributing

The CLI is written with TypeScript + NodeJS. Here's how you can get started contributing:

```bash
git clone git@github.com:pre63/iop  # clone the repo
cd iop/src/cli                      # enter the CLI folder
npm start                           # run first time dev setup
```

```bash
npm run dev     # compiles as you code
npm run build   # one-time production build
npm run test    # run test suite
```

## playing with the CLI locally

Here's how you can make the `iop` command work with your local build of this
repo.

```bash
npm remove -g iop   # remove any existing `iop` installs
npm link            # make `iop` refer to our local code
```