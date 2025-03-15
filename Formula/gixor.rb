VERSION="0.3.0"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.3.0/gixor-0.3.0_darwin_amd64.tar.gz"
    sha256 "7060c812b33f47328f1f17a62e3e80a72d1cb704f0b5fb35e3e40c31625558f9"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.3.0/gixor-0.3.0_darwin_arm64.tar.gz"
    sha256 "8d57cc1de3c92065e890b12bc29871561e1da482ca1fc5eec00e6e3445548b80"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.3.0/gixor-0.3.0_linux_arm64.tar.gz"
    sha256 "c21e879e3df0a5e9d3b5716c882fe14727584049863fbae5cd914a509f339002"
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
