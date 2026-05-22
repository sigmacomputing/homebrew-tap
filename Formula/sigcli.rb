class Sigcli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.0.13"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.13/sigcli-aarch64-apple-darwin.tar.xz"
      sha256 "28e2bea976bd2ee83e6bff87d9e633cf0307abbeb4270ff5b904a3a460fc8345"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.13/sigcli-x86_64-apple-darwin.tar.xz"
      sha256 "a5768c667728b19760c52f382d5c44bb275036747c0efe03e812e3f03ea6a6b5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.13/sigcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "22f31197a960658cdb246d2d31ff3db4e9c96538203c98746e54387f0812d52e"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.13/sigcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a390384a5abd2490ce6b8ccaf13d6581ef0fcc432f76f64e241353576d2d11cd"
    end
  end
  license "Apache-2.0"

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
    bin.install "sigcli" if OS.mac? && Hardware::CPU.arm?
    bin.install "sigcli" if OS.mac? && Hardware::CPU.intel?
    bin.install "sigcli" if OS.linux? && Hardware::CPU.arm?
    bin.install "sigcli" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
