HOMEBREW_SIBLING_VERSION="1.1.2"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  url "https://github.com/tamada/sibling/releases/download/v#{HOMEBREW_SIBLING_VERSION}/sibling-#{HOMEBREW_SIBLING_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_SIBLING_VERSION
  sha256 "6f13a912f9189474a723d29508302d7d83b8d3bf2346b67ec3058a3ee2327942"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end
end
