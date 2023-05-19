HOMEBREW_SIBLING_VERSION="1.2.4"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  url "https://github.com/tamada/sibling/releases/download/v#{HOMEBREW_SIBLING_VERSION}/sibling-#{HOMEBREW_SIBLING_VERSION}_darwin_arm64.tar.gz"
  version HOMEBREW_SIBLING_VERSION
  sha256 "bab3bab6873a1cc4b97572dff3dd91690cac07fbc2a2a11b405046d746286950"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end
end
