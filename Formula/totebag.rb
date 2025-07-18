VERSION="0.7.10"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.7.10/totebag-0.7.10_darwin_amd64.tar.gz"
    sha256 "28ad01419e64bf188accfbda9b327b2ebd9756e100ffb6b32baf614694eee98e"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.7.10/totebag-0.7.10_darwin_arm64.tar.gz"
    sha256 "47a5ce8cf531a9adefe2607696d11be8700f65836f0f19733b6b8f488b8ca0b5"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.7.10/totebag-0.7.10_linux_amd64.tar.gz"
    sha256 "55e745893fe607b48a47f0176af9e0f6aaac135d7719d8e059654be7d93fd25f"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.7.10/totebag-0.7.10_linux_arm64.tar.gz"
    sha256 "96c63d3e46bf8e283563954ba8948f25be2c58a0c5de4e32e912664f1f2ace0f"
  end

  def install
    bin.install "totebag"

    bash_completion.install "assets/completions/bash/totebag" if build.with? "completions"
    zsh_completion.install  "assets/completions/zsh/_totebag" if build.with? "completions"
    fish_completion.install "assets/completions/fish/totebag" if build.with? "completions"
  end

  test do
    system "#{bin}/totebag --version"
  end
end
