HOMEBREW_LIOSS_VERSION="1.0.0"

class Lioss < Formula
  desc "An agent for running unit tests/calculating coverages on the CLI environemnt for the Java platform."
  homepage "https://github.com/tamada/lioss"
  url "https://github.com/tamada/lioss/releases/download/v#{HOMEBREW_LIOSS_VERSION}/lioss-#{HOMEBREW_LIOSS_VERSION}_darwin_amd64.tar.gz"
  version HOMEBREW_LIOSS_VERSION
  sha256 "8e98a9ca1dbcc14f14c1f023602f16610534a9b71abe3ba35a735bbd49684afb"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional

  def install
    bin.install "bin/lioss"
    bin.install "bin/mkliossdb"

    prefix.install "data"
    prefix.install "README.md"
    prefix.install "LICENSE"

    if build.with? "completions"
      bash_completion.install "completions/bash/lioss"
      bash_completion.install "completions/bash/mkliossdb"
    end
  end
end
