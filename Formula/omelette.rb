require "formula"

VERSION="1.1.1"

class Omelette < Formula
  desc "An agent for running unit tests/calculating coverages on the CLI environemnt for the Java platform."
  homepage "https://github.com/tamada/omelette"
  url "https://github.com/tamada/omelette/releases/download/v#{VERSION}/omelette-#{VERSION}_darwin_amd64.tar.gz"
  version VERSION
  sha256 "a2c0f51c13fc46686a6ae6ae1ceaf02a1b8b37c547a3f6cf91922bc7c9b52a65"

  option "without-completions", "Disable bash completions"
  depends_on "bash-completion@2" => :optional
  depends_on "java" => :optional

  def install
    bin.install "bin/omelette"
    system "sh", "./bin/download_dependencies.sh"

    prefix.install "lib"

    bash_completion.install "completions/bash/omelette" if build.with? "completions"
  end
end
