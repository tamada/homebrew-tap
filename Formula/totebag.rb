VERSION="0.10.0"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.10.0/totebag-0.10.0_darwin_amd64.tar.gz"
    sha256 "f453110e4f5b4cebcbb7ee7ad8932968ac316cde10f3659ecca5911159b04d5e"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.10.0/totebag-0.10.0_darwin_arm64.tar.gz"
    sha256 "27600366982647b06758717e4d8ee84c5b533b883f266533f3da2166a343d048"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.10.0/totebag-0.10.0_linux_amd64.tar.gz"
    sha256 "adf2a225bf5bf797d35eca397fca1926dd45e6a0aeb1aee3507d382537d3c81c"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.10.0/totebag-0.10.0_linux_arm64.tar.gz"
    sha256 "74cde22955d3227ff7b598a5ff2e3ee24329203d2bfddc6802d888ef37dfe69b"
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
