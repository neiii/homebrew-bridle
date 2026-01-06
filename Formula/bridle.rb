class Bridle < Formula
  desc "Unified configuration manager for AI coding assistants (Claude Code, OpenCode, Goose, AMP Code)"
  homepage "https://github.com/neiii/bridle"
  version "0.2.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/0.2.5/bridle-aarch64-apple-darwin.tar.xz"
      sha256 "6a54e06084836fac2269b85940344543868b4e19997d852a4afbf8b39ae8b73d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/0.2.5/bridle-x86_64-apple-darwin.tar.xz"
      sha256 "12d72b8cfbf0ef37f52922a8271da715107068fc25fff1c78b8878d120c4c2fc"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/0.2.5/bridle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "92bdfc711893ac641f15ec3ea7664145641ea1d032e196dbdcfd945861b247f3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/0.2.5/bridle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c69ca1577c74665239dbcf36d475ed49a7c76f9a0ebe38a139de7f91e404f9b9"
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
