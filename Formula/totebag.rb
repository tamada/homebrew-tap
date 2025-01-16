VERSION="0.6.0"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.6.0/totebag-0.6.0_darwin_amd64.tar.gz"
    sha256 "d032098e0b6dc39dd840cf2a0e2d91274757a403545615ee5648c2356c2918f4"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.6.0/totebag-0.6.0_darwin_arm64.tar.gz"
    sha256 "e1341e28e0353f484e26d73c24418e1fa6df7f670470b9f6bbfca012405d9771"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.6.0/totebag-0.6.0_linux_amd64.tar.gz"
    sha256 "4c79a9c61c3d23ad9512bfacfbf828cb60392b162139f0109ef32860ebd5065f"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.6.0/totebag-0.6.0_linux_arm64.tar.gz"
    sha256 "9ec0ac941278e3c5bc56c09497c1e03c280d7966ec719215722d0e81e0fe28c0"
  end

  def install
    bin.install "totebag"

    bash_completion.install "completions/bash/totebag" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_totebag" if build.with? "completions"
    fish_completion.install "completions/fish/totebag" if build.with? "completions"
  end

  test do
    system "#{bin}/totebag --version"
  end
end
