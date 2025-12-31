class Bridle < Formula
  desc "Unified configuration manager for AI coding assistants (Claude Code, OpenCode, Goose, AMP Code)"
  homepage "https://github.com/neiii/bridle"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.1.0/bridle-aarch64-apple-darwin.tar.xz"
      sha256 "331031af5a644c1350725ae2f5df256dc2dee36a5be83446c32f3565c410753a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.1.0/bridle-x86_64-apple-darwin.tar.xz"
      sha256 "aab8c4a582e4d296b8175b98d6f6e054bb1e39e5d03ada631cb451f52fa77856"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.1.0/bridle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c07cd15f086cdb105d341e6da577e865731bcbc0f2a1872aedc8e69dff08e4aa"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.1.0/bridle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d99e8889e9d1af494bdfac178897cbeb3c252c6f289c8537eb1877aaad1c0bb6"
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
