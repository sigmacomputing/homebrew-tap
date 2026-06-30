class Sigcli < Formula
  desc "CLI for the Sigma Computing REST API"
  homepage "https://github.com/sigmacomputing/cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.1.0/sigcli-aarch64-apple-darwin.tar.xz"
      sha256 "8a3816274120898dc9182cf08febcfe5f0d03ed7203b7af31ece4886ab3a267a"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.1.0/sigcli-x86_64-apple-darwin.tar.xz"
      sha256 "9137def19c5703f0fc1a63391e33d44a3b847a6c4f8340057cc4d4334b36037e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.1.0/sigcli-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1bbcf519640686d25295bc79dae210fb79d838e6c53da9f015838509ed9a84e7"
    end
    if Hardware::CPU.intel?
      url "https://assets.sigmacomputing.com/sigcli/releases/v0.1.0/sigcli-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1f6ee60ea2e8ed945ed314051f31270c138f0fb2940a8cbddc2d8c011fafc853"
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
