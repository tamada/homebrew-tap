VERSION="0.4.0"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.4.0/gixor-0.4.0_darwin_amd64.tar.gz"
    sha256 "a8ade09ca7cbe905a742ca840668c0199c9705946136a1a801bed1bdd8cd04ed"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.4.0/gixor-0.4.0_darwin_arm64.tar.gz"
    sha256 "dac6102ab41a7a0940d49cdeac58497139178b217d8bb55d52a4c515e5c0bbab"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.4.0/gixor-0.4.0_linux_amd64.tar.gz"
    sha256 "8fc386984f74b2ce13c6393eebccc3a30386cf7bb9335a3a7b4adeed4b922ae6"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.4.0/gixor-0.4.0_linux_arm64.tar.gz"
    sha256 "f22a6e5de336c1b74c9eb7f89091cc560e2c2efa7193faa7f5e5f3d372886225"
  end

  def install
    bin.install "gixor"
    system "ln -s \"#{bin}/gixor\" #{bin}/git-ignore"

    bash_completion.install "assets/completions/bash/gixor" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_gixor" if build.with? "completions"
    fish_completion.install "assets/completions/fish/gixor" if build.with? "completions"
  end

  test do
    system "#{bin}/gixor --version"
  end
end
