VERSION="0.7.1"

class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/tamada/btmeister"
  version VERSION
  license "MIT license"
  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.1/btmeister-0.7.1_darwin_amd64.tar.gz"
    sha256 "50d167c57255bb3096af568cb4522d68e7dbf4b3b8dbc45a82868fbaae4a5731"
  end
  if OS.mac? && Hardware::CPU.arm?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.1/btmeister-0.7.1_darwin_arm64.tar.gz"
    sha256 "6f51b99f11d7559ccb8b5cec78b6fe1b92407bea43773c000c577d0f6d3d736a"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.1/btmeister-0.7.1_linux_amd64.tar.gz"
    sha256 "d52ec7330b19c37b0e05cdbd60e7539741a24cfad85b667a88e7693b7565db01"
  end
  if OS.linux? && Hardware::CPU.arm?
    url "https://github.com/tamada/btmeister/releases/download/v0.7.1/btmeister-0.7.1_linux_arm64.tar.gz"
    sha256 "303801deaf35101a7ed8b5aa0dc5853840a500360e83fb7c90afd60409d3551a"
  end

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
