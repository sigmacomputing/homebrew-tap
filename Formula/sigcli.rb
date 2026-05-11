class Sigcli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.0.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.12/sigcli-aarch64-apple-darwin.tar.xz"
      sha256 "14ca18dd24d4c6ff2ffa3d9bb83048137c8e94fa9ecae68959514db28dd6988f"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.12/sigcli-x86_64-apple-darwin.tar.xz"
      sha256 "2ffc0787ad51ee63210aa1967efaac952f0352759f3406869bef79132cd42d9e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.12/sigcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e7fedbe2b4dc01ab5e67a8657476002be0d7112be33e37cd5597843e5992fb1e"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.0.12/sigcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a2fed187daaada7f7bf9f2d0d1632279f9507b03c6a427abf9efe10e8125fe3c"
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
