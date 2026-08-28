class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "1.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.2/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "e3525284b46f11f16cbf1644d2e6efe09e4c252df2f45c4100d2298371b3b1c9"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.2/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "38e716c6478f09b52790f1edd266171a1903c0cd23ede3b801a9181d919ad8be"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.2/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d09b4e3ccaf4f6df4d0d00663cea530c2dae47a70bdc1eaac7498f7ebbd3185"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.2/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9be405c3aced9ede6c72cc7b0eb98fbd05c94600470b8a326e5da46d3fc12b4c"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "sigma"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "sigma"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "sigma"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "sigma"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
