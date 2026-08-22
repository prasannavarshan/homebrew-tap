class UpdateToolchain < Formula
  desc "Supply-chain hardened updater for a macOS developer toolchain"
  homepage "https://github.com/prasannavarshan/update-toolchain"
  url "https://github.com/prasannavarshan/update-toolchain/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "3ebe024a4564f24eb824ed0943bbcb5c31cb186baa1efbe461f8f7192aa55b3f"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/prasannavarshan/homebrew-tap/releases/download/update-toolchain-0.3.0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "726aa29539114c07faa1eab0b6dfb8bf7e3c16c7528b076044e4c3a322cfe7c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f0de783c800c9815fc1992622c5c77191bae42e4946bee18f7b7d62cf663083f"
    sha256 cellar: :any_skip_relocation, tahoe:         "957815f596dac7ee08da0709be9215ea92bc742dc655a914efd95a17df9e2763"
  end

  depends_on :macos

  def install
    bin.install "bin/update-toolchain"
    # Installed at <prefix>/config so the script's own SCRIPT_ROOT/config lookup
    # resolves. The script resolves its symlink back to the Cellar before
    # computing SCRIPT_ROOT, so the brew shim in bin/ works unchanged.
    prefix.install "config"
    doc.install "README.md", "SECURITY.md", "CHANGELOG.md", "docs/article.md"
  end

  def caveats
    <<~EOS
      Allowlists default to the bundled examples, which reflect one developer's
      machine. Copy them and edit before relying on this:

        mkdir -p ~/.config/update-toolchain
        cp #{prefix}/config/*.example ~/.config/update-toolchain/
        cd ~/.config/update-toolchain && for f in *.example; do mv "$f" "${f%.example}"; done

      Then start read-only:

        update-toolchain --dry
    EOS
  end

  test do
    # --help must work without Homebrew introspection, sudo, or network.
    assert_match "Usage", shell_output("#{bin}/update-toolchain --help")

    # The bundled example configs must be present and parseable.
    assert_path_exists prefix/"config/allowed-taps.example"
    assert_path_exists prefix/"config/npm-pinned.example"

    # An unknown flag must be rejected rather than silently ignored.
    output = shell_output("#{bin}/update-toolchain --definitely-not-a-flag 2>&1", 1)
    assert_match "Unknown flag", output
  end
end
