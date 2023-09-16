VERSION="v0.2.5"

class Urleap < Formula
  desc "URL shortener via bit.ly"
  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  homepage "https://github.com/tamada/urleap"
  version VERSION
  license "MIT License"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/urleap/releases/download/v0.2.5/urleap-0.2.5_darwin_amd64.tar.gz"
    sha256 "65e736275551ba53627d7f218fae704800e61489af1a11b383dc6624f6d8d793"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/urleap/releases/download/v0.2.5/urleap-0.2.5_darwin_arm64.tar.gz"
    sha256 "ac2b2b76f30bd3fba80855b87ce79789051c7a281ae23679863262901908be9a"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/urleap/releases/download/v0.2.5/urleap-0.2.5_linux_amd64.tar.gz"
    sha256 "c3915f948a519ef1d9885e28306c9e2b5355beb51ac74c403290e5a2a9886a82"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/urleap/releases/download/v0.2.5/urleap-0.2.5_linux_arm64.tar.gz"
    sha256 "9312ca60133df13d193c56c208730646b12ad97ec0add86863cf02796e9576f1"
  end

  def install
    bin.install "urleap"

    bash_completion.install "completions/bash/urleap" if build.with? "completions"
    zsh_completion.install  "completions/zsh/urleap"  if build.with? "completions"
    fish_completion.install "completions/fish/urleap" if build.with? "completions"
  end

  test do
    system "#{bin}/urleap --version"
  end
end
