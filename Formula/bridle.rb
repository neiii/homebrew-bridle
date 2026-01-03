class Bridle < Formula
  desc "Unified configuration manager for AI coding assistants (Claude Code, OpenCode, Goose, AMP Code)"
  homepage "https://github.com/neiii/bridle"
  version "0.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.2/bridle-aarch64-apple-darwin.tar.xz"
      sha256 "69655f944be7c5dcd03461c6a21701d685e482d91bf95d42700f996d6182fac7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.2/bridle-x86_64-apple-darwin.tar.xz"
      sha256 "0bf2274b05896c38f94203e45e817232b5ea3918aef7a04bcf057a77b9d5e140"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/neiii/bridle/releases/download/v0.2.2/bridle-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ac3666ec636bdbc550d18c7bca8f27032ceee0d56d028e0c45e69f86437ed22b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/neiii/bridle/releases/download/v0.2.2/bridle-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01e77fd944dabb0f6e18000c035f315ad6fb528b4e128835d47eadec1747461a"
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
