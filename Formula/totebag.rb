VERSION="0.9.0"

class Totebag < Formula
  desc "A tool for archiving files and directories and extracting several archive formats."
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/totebag"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.9.0/totebag-0.9.0_darwin_amd64.tar.gz"
    sha256 "ba6bf5b4d45eedb924f322501e97e29ec96a845b1603cb407e0fded30b808b83"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.9.0/totebag-0.9.0_darwin_arm64.tar.gz"
    sha256 "940e1dde4bcc1603656ccdb5c4d5f2dc6111539083dc323ceec868570a1ac9a9"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/totebag/releases/download/v0.9.0/totebag-0.9.0_linux_amd64.tar.gz"
    sha256 "1e3485b2cad02d5b02e9ebe2ed48889bfee1eb198bd22c73bacaa66248462f03"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/totebag/releases/download/v0.9.0/totebag-0.9.0_linux_arm64.tar.gz"
    sha256 "7d174f1df71adf8c23c7dffed5d77b8836353037627c8ad2faa965dd2c918360"
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
