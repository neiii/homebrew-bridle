class Bridle < Formula
  desc "Unified configuration manager for AI coding assistants (Claude Code, OpenCode, Goose, AMP Code)"
  homepage "https://github.com/neiii/bridle"
  version "0.2.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.7/bridle-aarch64-apple-darwin.tar.xz"
      sha256 "497693195e56774bd90aaca102421f1d5d96b9455ebf849ceefe2c4b8bf37b3a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.7/bridle-x86_64-apple-darwin.tar.xz"
      sha256 "76e6389b2b8b1679b5b0949e5f493d010218a0d90c2a4f87bfd3b2e5258d8b61"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.7/bridle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e35669456484a56bec36bfdb3ffb256440f25c1f3e1f26ce60e2f9b810e9e14a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.7/bridle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fa91b7ea2c3bf1120b28b02b0a95d9b307cdcbfc676c6a3e63ba874cad22339d"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "bridle" if OS.mac? && Hardware::CPU.arm?
    bin.install "bridle" if OS.mac? && Hardware::CPU.intel?
    bin.install "bridle" if OS.linux? && Hardware::CPU.arm?
    bin.install "bridle" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
