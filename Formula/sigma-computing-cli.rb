class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "1.2.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.3/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "8d3911d70a5f6faa3c9d418ba4c66e2132daf309498af0a1e3fa964ea33838be"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.3/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "70a1fcd7c10e5b96931a82f41349ab42574a569070e450ca792791604e2db253"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.3/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "38e146acec9287dae50acc12e70e00edbae837d4601aafb1295e796081661fbe"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.3/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d87d16eaa76ec54cabb016a6d1c68612b19d3b86be90813dccfc1ed8c828e313"
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
