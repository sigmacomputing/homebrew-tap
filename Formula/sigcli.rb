class Sigcli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.0.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/sigmacomputing/cli/releases/download/v0.0.9/sigcli-aarch64-apple-darwin.tar.xz"
      sha256 "2b834a9966b872b303e5929eeb4111f58c7fee375c4174d65c394d22bf2083fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sigmacomputing/cli/releases/download/v0.0.9/sigcli-x86_64-apple-darwin.tar.xz"
      sha256 "13f96b32eb49205cf882744d1b6b4de0724b109db71e9f3cabeac3174914192c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/sigmacomputing/cli/releases/download/v0.0.9/sigcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "bf428790492998680262c31ae4e078f6f9a71fc163aff2d5cc43bc734f603ce8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/sigmacomputing/cli/releases/download/v0.0.9/sigcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "6904f06ddbbc2e4e11652ff3300ed8903fe77a1b09829b02eb342abd800a4db8"
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
