VERSION="0.7.8"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.7.8/totebag-0.7.8_darwin_amd64.tar.gz"
    sha256 "9d22e14c665f57f8efd17bfb8be5061317e0049bd8f204cb162fc51733ae4c40"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.7.8/totebag-0.7.8_darwin_arm64.tar.gz"
    sha256 "dfa3e96a83e56d292749054299e98df662d629155487b5cbf9780fc3a019e619"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.7.8/totebag-0.7.8_linux_amd64.tar.gz"
    sha256 "6699f051107c9322d513738da28e7b4cf84b35983016b3a347f4c3a64cd00be8"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.7.8/totebag-0.7.8_linux_arm64.tar.gz"
    sha256 "415514d019f0c783831a5132031e70a03cf437d13f7954da43cf7a398a1a7a69"
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
