class SigmaComputingCli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "1.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.0/sigma-cli-aarch64-apple-darwin.tar.xz"
      sha256 "529c8b95c31894c8cf9b12c6ea0fc0cb918e0daac3e30300b4b9859411dcf249"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.0/sigma-cli-x86_64-apple-darwin.tar.xz"
      sha256 "b790b0a34ba04cdb9825a4db0f586d8ec40d631062bcbcb96511f3104efe13f2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.0/sigma-cli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f46bd24c43ae59719c206ea83daf8fe4acbd3900fa16704e0a42880d83957314"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigma-cli/releases/v1.2.0/sigma-cli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "0edaf49a9ec939bac488a6f6196677d73d36dc47bad8595b9dfab5a78a963ed1"
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
