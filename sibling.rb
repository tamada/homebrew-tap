HOMEBREW_SIBLING_VERSION="1.1.2"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  url "https://github.com/tamada/sibling/releases/download/v#{HOMEBREW_SIBLING_VERSION}/sibling-#{HOMEBREW_SIBLING_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_SIBLING_VERSION
  sha256 "d7699f1ed97097c7641539561b7624cdc38fdaf56574f1569e538cf563715ebd"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end
end
