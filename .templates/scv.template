VERSION="1.0.0"

class Scv < Formula
  desc "similarities and distances calculator among vectors."
  homepage "https://github.com/tamada/scv"
  url "https://github.com/tamada/scv/releases/download/v#{VERSION}/scv-#{VERSION}_darwin_amd64.tar.gz"
  version VERSION
  sha256 "d3e8fc67d89e71bfe1cefc6f369a975eed8ccdeeed408d0903adf7fc90e9e901"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "scv"

    bash_completion.install "completions/bash/scv.bash" if build.with? "completions"
  end
end
