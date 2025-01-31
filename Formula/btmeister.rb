VERSION="0.7.4"

class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/tamada/btmeister"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.4/btmeister-0.7.4_darwin_amd64.tar.gz"
    sha256 "5a2ed8666a78ef6672a913b03ce86fbc81c90fcd118ed754c6b93800b99f2325"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.4/btmeister-0.7.4_darwin_arm64.tar.gz"
    sha256 "d10c7a09c81c9bbd81a67a7f68c2d66f2320ff5b9152fecfcda4b7a29602bed3"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.4/btmeister-0.7.4_linux_amd64.tar.gz"
    sha256 "f5ee46ee28ea51114d760fa6f5037350c29e111cb721ffdadb1f155dcb20f2c2"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.4/btmeister-0.7.4_linux_arm64.tar.gz"
    sha256 "8df68f38bfd4f6151467ad62e2ce7f3e7b093dc826cd9ba85b890d5352196e92"
  end

  option "without-completions", "Disable bash completions"
  depends_on "rustup" => :build
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "btmeister"
    prefix.install "README.md"
    prefix.install "LICENSE"

    bash_completion.install "assets/completions/bash/btmeister" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_btmeister" if build.with? "completions"
    fish_completion.install "assets/completions/fish/btmeister" if build.with? "completions"
  end
end
