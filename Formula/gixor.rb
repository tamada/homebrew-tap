VERSION="0.5.2"

class Gixor < Formula
  desc "gitignore management system for the multiple repositories"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/gixor"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.5.2/gixor-0.5.2_darwin_amd64.tar.gz"
    sha256 "34e068baee85f4260b2eeeec92ac47494dceb4228a577b64abd00b46ff56ca9f"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.5.2/gixor-0.5.2_darwin_arm64.tar.gz"
    sha256 "56ea7c586161947b564de70892c47f3d0ab6b91438fe1eca633c2d934d182786"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/gixor/releases/download/v0.5.2/gixor-0.5.2_linux_amd64.tar.gz"
    sha256 "a4010244120f939a1d5e090b3ac559270d6b724466d13205f2b9712af2717bba"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/gixor/releases/download/v0.5.2/gixor-0.5.2_linux_arm64.tar.gz"
    sha256 "9fb2ba57a52e27cb8a9bb9228da6133d5d270d66e63d64af534b1c6af5fb9edf"
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
