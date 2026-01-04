class Bridle < Formula
  desc "Unified configuration manager for AI coding assistants (Claude Code, OpenCode, Goose, AMP Code)"
  homepage "https://github.com/neiii/bridle"
  version "0.2.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.4/bridle-aarch64-apple-darwin.tar.xz"
      sha256 "fcd47307476340203c2966d5ebaf47b804a647f534ab34eb46453570b4fddfac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.4/bridle-x86_64-apple-darwin.tar.xz"
      sha256 "e7041a25544c74293a81be69baa4dbb596a9290875e187baaf6077d6ff9c6345"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.4/bridle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "7289854f7e7a0b3918c8122b641ed486221e5f48cfbbce2d943556a3da2078e2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.4/bridle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6bfa73eca444f438741d94fbd5d719ec2779b17cae948a1c654bf7757abc3d30"
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
