VERSION = "0.4.7"

class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/tamada/btmeister"
  url "https://github.com/tamada/btmeister/releases/download/v#{VERSION}/btmeister-#{VERSION}_darwin_amd64.tar.gz"
  sha256 "06ff30ba167231281ba288d55900dcee64eaf6639f2d8f00d909299d07df9103"
  license "MIT"

  option "without-completions", "Disable bash completions"
  depends_on "rustup" => :build
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "btmeister"
    prefix.install "README.md"
    prefix.install "LICENSE"

    bash_completion.install "completions/bash/btmeister" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_btmeister" if build.with? "completions"
    fish_completion.install "completions/fish/btmeister" if build.with? "completions"
  end
end
