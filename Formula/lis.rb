VERSION="0.0.11"

class Lis < Formula
  desc "Minimal and alternative ls implementation in Rust."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/lis"
  version VERSION
  license "CC-0"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/lis/releases/download/v0.0.11/lis-0.0.11_amd64_darwin.tar.gz"
    sha256 "ce72660e3ed81cca82a3a83751c120297a65f67113087bbf36c28ef1f62b4ce7"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/lis/releases/download/v0.0.11/lis-0.0.11_amd64_linux.tar.gz"
    sha256 "bd0324e4cf23f1ae281da1cd679e691cf647475d28a5c0ad4c3a7a02d35e8406"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/lis/releases/download/v0.0.11/lis-0.0.11_arm64_darwin.tar.gz"
    sha256 "53262b53f7c5bcc74e06102b094dacf5f663c7abde518d17b9e8dec7f1b8a9fd"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/lis/releases/download/v0.0.11/lis-0.0.11_arm64_linux.tar.gz"
    sha256 "b56be1b07636863ae343335e1d18799251c27292246b18d1a00d77660f5f52ae"
  end

  def install
    bin.install "lis"

    bash_completion.install "completions/bash/lis" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_lis" if build.with? "completions"
    fish_completion.install "completions/fish/lis" if build.with? "completions"
  end

  test do
    system "#{bin}/lis --version"
  end
end
