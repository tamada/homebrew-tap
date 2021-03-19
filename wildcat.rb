VERSION="1.1.0"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/tamada/wildcat"
  url "https://github.com/tamada/wildcat/releases/download/v#{VERSION}/wildcat-#{VERSION}_darwin_amd64.tar.gz"
  version VERSION
  sha256 "9e5c193354673e2be51fb6e3f7930fc3d17138b4991ddc62c973e769c4a21f7d"
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
