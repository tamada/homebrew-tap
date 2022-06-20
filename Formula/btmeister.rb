VERSION = "0.4.7"

class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/tamada/btmeister"
  url "https://github.com/tamada/btmeister/releases/download/v#{VERSION}/btmeister-#{VERSION}_darwin_amd64.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
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
