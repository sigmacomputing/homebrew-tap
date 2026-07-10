class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.1/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "3f4a8730184427eb5acb28d75f78500bbc4614eab3edc3ccd0cd97495bce2a45"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.1/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "ee5bbf65c0585d707cc701f23bab92d938b70dc1803e16cd373376f7aab0c18f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.1/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bd1d0d314c16c2b02b4e718c6ff0024cb4d453d72c4d479b0f985bf958d2e9b2"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.1/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4a400e4da0648b7858d9f7d4b95a18e5510eb7d593ce14cd3228bbae4490992f"
    end
  end

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
    bin.install "sigma" if OS.mac? && Hardware::CPU.arm?
    bin.install "sigma" if OS.mac? && Hardware::CPU.intel?
    bin.install "sigma" if OS.linux? && Hardware::CPU.arm?
    bin.install "sigma" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
