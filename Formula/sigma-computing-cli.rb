class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "1.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.3.0/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "fb06e29caa7205b519438fe10c1f3b757edc466ba0d53a1091e019447d9dcb7b"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.3.0/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "2904c7573df9a39becd06f4b633cb9e82b6efa2af592ec32c896e885ef4be07a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.3.0/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2f5f9071b75f026201b39f5e9e778597eff69c2305919fdf2db01c5a85315f0"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.3.0/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "935d6909f28ed206dcee875da3d0e7c5c089b6f9ee7a74dbad479baa2dd4cd11"
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
