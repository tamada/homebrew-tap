VERSION="1.1.1"

class Wildcat < Formula
  desc "Another implementation of wc (word count)"
  homepage "https://github.com/tamada/wildcat"
  url "https://github.com/tamada/wildcat/releases/download/v#{VERSION}/wildcat-#{VERSION}_darwin_amd64.tar.gz"
  version VERSION
  sha256 "a10fff0f9569b1ea4fdb298ed5adb2ac9b79fd3085f518b84fbecc7a07d8fdc8"
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
