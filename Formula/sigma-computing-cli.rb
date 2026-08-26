class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.1.0/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "f450cec1eae57474deec1fc9a2970fe98953c7b8f9dc4fb8e93f5c33cd054bf6"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.1.0/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "094836a2f808d2693e2468cda013b5b0a41117c078b2751732505e617ffc1bcd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.1.0/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b266ffa25f05ab76d3bc85da22944a662196ebf0f522a79bed76f06b87f44e2c"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.1.0/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "731fa06f4ddc7b892e9a24e800081cb33fcd147f03ea24ba12493fd4e1265111"
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
