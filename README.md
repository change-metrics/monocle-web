# Monocle web

A Work In Progress attempt to migrate the Monocle Web UI to [rescript-lang](https://rescript-lang.org).

## Install dependencies

```
mkdir -p ~/git/softwarefactory-project.io/software-factory
pushd ~/git/softwarefactory-project.io/software-factory
git clone https://softwarefactory-project.io/r/software-factory/re-patternfly
popd
```

## Run the developpement server

Install pnpm first using `npm install -g pnpm`

```ShellSession
pnpm install
pnpm start
```

In another shell start the developpement server

```ShellSession
pnpm run serve
```

Distribute the interface

```ShellSession
pnpm run dist
```
