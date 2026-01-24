VERSION="0.8.9"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.8.9/totebag-0.8.9_darwin_amd64.tar.gz"
    sha256 "b35df468779d936f3c3f2c088dd2612408b7c359ba70eeb608fe3eefea80a1bc"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.8.9/totebag-0.8.9_darwin_arm64.tar.gz"
    sha256 "fb39cff9cee15eb83357994853bff8d26a967219276b3c76bcf33fe22ac9f025"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.8.9/totebag-0.8.9_linux_amd64.tar.gz"
    sha256 "2deb2d7d0874fa34710ed016455c2a06381efcd649580c3008a2186d9ef9fbc2"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.8.9/totebag-0.8.9_linux_arm64.tar.gz"
    sha256 "062b353c2bfd3469a65a53152c5882839ef281c2deaabf7542206fa45bb67d6f"
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
