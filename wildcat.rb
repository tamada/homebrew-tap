VERSION="1.2.0"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/tamada/wildcat"
  url "https://github.com/tamada/wildcat/releases/download/v#{VERSION}/wildcat-#{VERSION}_darwin_amd64.tar.gz"
  version VERSION
  sha256 "308046086a8531f162b3096002951adb629c55a6c99e7d335f7f60732ff93a67"
  license "Apache-2.0"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "wildcat"

    prefix.install_metafiles
    prefix.install "docs"

    bash_completion.install "completions/bash/wildcat.bash" if build.with? "completions"
  end

  test do
      system bin/"wildcat", "--version"
  end
end
