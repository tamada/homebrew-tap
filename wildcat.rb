require "formula"

HOMEBREW_WILDCAT_VERSION="1.0.2"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/tamada/wildcat"
  url "https://github.com/tamada/wildcat/releases/download/v#{HOMEBREW_WILDCAT_VERSION}/wildcat-#{HOMEBREW_WILDCAT_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_WILDCAT_VERSION
  sha256 "8e02909c506ae98003e7a72872900b1d3cdc98782cc8d89aa6889d76c889a46c"

  depends_on "bash_completion@2" => :optional

  option "without-completions", "Disable bash completions"

  def install
    bin.install "wildcat"

    prefix.install "LICENSE"
    prefix.install "docs"
    prefix.install "README.md"

    if build.with? "completions"
      bash_completion.install "completions/bash/wildcat.bash"
    end
  end
end
