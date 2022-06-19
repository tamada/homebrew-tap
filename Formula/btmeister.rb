VERSION = "0.3.21"

class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/tamada/btmeister"
  url "https://github.com/tamada/btmeister/releases/download/v#{VERSION}/btmeister-#{VERSION}_darwin_amd64.tar.gz"
  sha256 "6f1bb83790528477081bbaf68bdffbda9810fa53609fa3ca39bcb661b2ef5f9f"
  license "MIT"

  option "without-completions", "Disable bash completions"
  depends_on "rustup" => :build
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "btmeister"
    prefix.install "README.md"
    prefix.install "LICENSE"
    prefix.install "completions"

    bash_completion.install "completions/bash/btmeister" if build.with? "completions"
    zsh_completion.install  "completions/zsh/_btmeister" if build.with? "completions"
    fish_completion.install "completions/fish/btmeister" if build.with? "completions"
  end
end
