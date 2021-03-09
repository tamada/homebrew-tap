VERSION="1.0.3"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/tamada/wildcat"
  version VERSION
  license "Apache-2.0"
  url "https://github.com/tamada/wildcat/releases/download/v#{VERSION}/wildcat-#{VERSION}_darwin_amd64.tar.gz"
  sha256 "290aebc46a85ad075b4429d699ae12754b5d4a56211b01509d413478a7b41ed7"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "wildcat"

    prefix.install "LICENSE"
    prefix.install "docs"
    prefix.install "README.md"

    bash_completion.install "completions/bash/wildcat.bash" if build.with? "completions"
  end
end
