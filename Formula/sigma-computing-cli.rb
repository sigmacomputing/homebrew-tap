class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.0/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "d54ed3e92c9eaab88b753b383c37191339b400e2231f2e1aa12d9ae8fb8a4c3a"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.0/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "4b995d485cb21715a60d81c584fdbb55d7c8fcd1385d3f95d12403bb3f3f565a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.0/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "03250d64882c22a59ae58a2cce2c0a760fae0d69008ad7b4562cc2d47334600a"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v0.2.0/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d9b4cd8480dc744a7e35e71674a072ad6d9035e33f4a2ad17e293f57f549871a"
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
