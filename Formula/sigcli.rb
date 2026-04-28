class Sigcli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.0.11"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.11/sigcli-aarch64-apple-darwin.tar.xz"
      sha256 "8ec7620e501d1075d8e3a221239131f97d83152ba5ee3c1a83b603614c0a3d59"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.11/sigcli-x86_64-apple-darwin.tar.xz"
      sha256 "3f1623212e4666ba54bea8f3ba1807200405acf701f21a842d8a513fc85f31fe"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.11/sigcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c007883dc7d307fcd5b31ecc83a1f23bcaa6d85b72d4e431679cca2fc2bc2b07"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.11/sigcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f19419824e88a623669df0150c3f7485db98b13a32ea8f65c20f76454032836f"
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
