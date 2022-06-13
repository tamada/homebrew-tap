# Documentation: https://docs.brew.sh/Formula-Cookbook
#                https://rubydoc.brew.sh/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!
class Btmeister < Formula
  desc "Detecting the build tools in use"
  homepage "https://github.com/tamada/btmeister"
  version "0.1.2"
  license "MIT"
  head "https://github.com/tamada/btmeister.git", branch: "main"

  option "without-completions", "Disable bash completions"
  depends_on "rustup" => :build
  depends_on "bash-completion@2" => :optional

  def install
    system "cargo", "build"
    bin.install "target/release/btmeister"
    prefix.install "README.md"
    prefix.install "LICENSE"
    prefix.install "target/completions"

    bash_completion.install "target/completions/bash/btmeister" if build.with? "completions"
    zsh_completion.install "target/completions/zsh/_btmeister" if build.with? "completions"
    fish_completion.install "target/completions/fish/btmeister" if build.with? "completions"
  end
end
