HOMEBREW_SIBLING_VERSION="1.1.0"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  url "https://github.com/tamada/sibling/releases/download/v#{HOMEBREW_SIBLING_VERSION}/sibling-#{HOMEBREW_SIBLING_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_SIBLING_VERSION
  sha256 "976bdabd24a619112e5bca54f173914d75826a18e64008eecce39f04adb9816b"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end
end
