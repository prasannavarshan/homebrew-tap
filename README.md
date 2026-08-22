# homebrew-tap

Homebrew formulae for my public tools.

```bash
brew tap prasannavarshan/tap && brew trust prasannavarshan/tap && brew install update-toolchain
```

| Formula | What it is |
|---|---|
| [`update-toolchain`](https://github.com/prasannavarshan/update-toolchain) | Supply-chain hardened updater for a macOS developer toolchain |

## Why three commands and not one

Current Homebrew refuses to load a formula from an untrusted third-party tap, so
`brew trust` is required. There is no way for a tap to waive that from its own
side — it is a decision made on the installing machine, which is the point of
it. Only formulae in official Homebrew repositories are trusted by default.

If you would rather trust one formula than the whole tap:

```bash
brew trust --formula prasannavarshan/tap/update-toolchain
```

The repo must be named `homebrew-tap` for `brew tap prasannavarshan/tap` to
resolve — Homebrew strips the `homebrew-` prefix. That naming is not optional.

## Releasing

Bottles matter here for one specific reason: without one, Homebrew treats an
install as a source build and enforces its Command Line Tools version gate. That
blocks anyone whose CLT has fallen behind, even for a formula that compiles
nothing. A bottle skips that path entirely.

The flow is PR-based, which is what `brew test-bot` expects:

1. Tag the release in the tool's own repo:
   ```bash
   git tag v0.2.0 && git push origin v0.2.0
   ```
2. Get the tarball digest:
   ```bash
   curl -sL https://github.com/prasannavarshan/update-toolchain/archive/refs/tags/v0.2.0.tar.gz | shasum -a 256
   ```
3. Open a **pull request** here bumping `url` and `sha256` in the formula. A PR,
   not a direct push — `tests.yml` builds the bottles on the PR and uploads them
   as artifacts.
4. Once CI is green, run the **publish** workflow (Actions → publish → Run
   workflow) with the PR number. `brew pr-pull` downloads the bottle artifacts,
   uploads them to a GitHub Release here, writes the `bottle do` block into the
   formula, and merges.

`publish.yml` needs no personal access token — it uses the built-in
`GITHUB_TOKEN`.

## Workflows

| File | Trigger | Does |
|---|---|---|
| `tests.yml` | push / PR | `brew test-bot` — audit, style, install, test, build bottles |
| `publish.yml` | manual | `brew pr-pull` — publish bottles to Releases, update formula, merge |
| `dependabot.yml` | schedule | keeps the pinned action SHAs current |

`tests.yml` runs macOS only. `update-toolchain` is `depends_on :macos`, so a
Linux leg could only ever fail. Add more `os:` entries to bottle for older
macOS versions.
