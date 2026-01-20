class Bridle < Formula
  desc "Unified configuration manager for AI coding assistants (Claude Code, OpenCode, Goose, AMP Code)"
  homepage "https://github.com/neiii/bridle"
  version "0.2.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.8/bridle-aarch64-apple-darwin.tar.xz"
      sha256 "af6c5b16a93fb5e44f09d36869f51b3ac007c7dfb182f09879b304209bfc90d9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.8/bridle-x86_64-apple-darwin.tar.xz"
      sha256 "e00dbdd51f61530ed77224e62257417fc53ad1bdb8f81746fcbaf73866a35de8"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.8/bridle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c6ab5434ecd69f80afdcac0628d941dfb72c265d767d3a3c098289ae2fd6d25"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.8/bridle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "aa0be55b65323a6c0bdc26bd51c065aeee7fa8de2399e6ace5d9f82a658ca64d"
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
