# homebrew-tap

Homebrew formulae for my public tools.

```bash
brew tap prasannavarshan/tap
brew trust prasannavarshan/tap      # required: Homebrew gates third-party taps
brew install update-toolchain
```

| Formula | What it is |
|---|---|
| [`update-toolchain`](https://github.com/prasannavarshan/update-toolchain) | Supply-chain hardened updater for a macOS developer toolchain |

## Notes

The repo must be named `homebrew-tap` for `brew tap prasannavarshan/tap` to
resolve — Homebrew strips the `homebrew-` prefix. That naming is not optional.
