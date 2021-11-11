HOMEBREW_SIBLING_VERSION="1.1.1"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  url "https://github.com/tamada/sibling/releases/download/v#{HOMEBREW_SIBLING_VERSION}/sibling-#{HOMEBREW_SIBLING_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_SIBLING_VERSION
  sha256 "7b08346365bf9232c72433d297e77035fe83dde83c9964c60fb493ed90a353ce"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end
end
