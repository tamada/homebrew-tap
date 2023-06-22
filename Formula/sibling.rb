VERSION="1.3.0"

class Sibling < Formula
  desc "get next/previous sibling directory name."
  homepage "https://github.com/tamada/sibling"
  url "https://github.com/tamada/sibling/releases/download/v#{VERSION}/sibling-#{VERSION}_darwin_arm64.tar.gz"
  version VERSION
  sha256 "1a4ef68c4ed4ccb43f4dedfb730eda08fde402d9fb47e19fc6f09e4f636f1698"
  license "WTFPL"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "sibling"

    bash_completion.install "completions/bash/sibling.bash" if build.with? "completions"
  end
end
